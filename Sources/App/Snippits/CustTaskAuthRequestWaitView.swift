//
//  CustTaskAuthRequestWaitView.swift
//  
//
//  Created by Victor Cantu on 5/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CustTaskAuthRequestWaitView: Div {
    
    override class var name: String { "div" }

    private enum Action {
        case changePrice(type: ChargeType, id: UUID, requestedPrice: Int64, reason: String, authorizationContext: CustComponents.ChangePriceAuthorizationContext)
        case removeCharge(orderId: UUID, chargeId: UUID)
        case removePayment(orderId: UUID, paymentId: UUID)

        var alertType: CustTaskAuthorizationManagerAlertType {
            switch self {
            case .changePrice:
                return .changePrice
            case .removeCharge:
                return .orderCharge
            case .removePayment:
                return .orderPayment
            }
        }

        var title: String {
            switch self {
            case .changePrice:
                return "Solicitando cambio de precio"
            case .removeCharge:
                return "Solicitando eliminar cargo"
            case .removePayment:
                return "Solicitando eliminar pago"
            }
        }

        var deniedMessage: String {
            switch self {
            case .changePrice:
                return "El cambio de precio no fue autorizado."
            case .removeCharge:
                return "La eliminacion del cargo no fue autorizada."
            case .removePayment:
                return "La eliminacion del pago no fue autorizada."
            }
        }
    }

    private let action: Action
    
    private var callback: ((  
        _ auth: Bool
    ) -> ())
    
    init(
        type: ChargeType,
        id: UUID,
        requestedPrice: Int64,
        reason: String,
        authorizationContext: CustComponents.ChangePriceAuthorizationContext,
        callback: @escaping ((
            _ auth: Bool
        ) -> ())
    ) {
        self.action = .changePrice(type: type, id: id, requestedPrice: requestedPrice, reason: reason, authorizationContext: authorizationContext)
        self.callback = callback
    }

    init(
        removeChargeFrom orderId: UUID,
        chargeId: UUID,
        callback: @escaping (Bool) -> Void
    ) {
        self.action = .removeCharge(orderId: orderId, chargeId: chargeId)
        self.callback = callback
    }

    init(
        removePaymentFrom orderId: UUID,
        paymentId: UUID,
        callback: @escaping (Bool) -> Void
    ) {
        self.action = .removePayment(orderId: orderId, paymentId: paymentId)
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    @State var responseText = "Solicitando autorizacion"
    
    var taskid: UUID? = nil
    
    lazy var loader = Img()
        .src("/skyline/media/loader.gif")
        .marginRight( 7.px)
        .width(16.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        
                        if let taskid = self.taskid {
                            
                            loadingView.show()
                            
                            API.custAPIV1.changePriceCancel(
                                taskid: taskid
                            ) { resp in
                                
                                loadingView.hide()
                                
                                self.remove()
                                
                                guard let resp else {
                                    showError(.comunicationError, .serverConextionError)
                                    return
                                }
                                
                                guard resp.status == .ok else{
                                    showError(.generalError, resp.msg)
                                    return
                                }
                                
                                
                            }
                        }
                        else {
                            self.remove()
                        }
                    }
                 
                H2("Autorizacion Requerida")
                    .color(.lightBlueText)
                    .class(.oneLineText)
            }
            .paddingBottom(3.px)
            
            Div().class(.clear).height(36.px)
            
            H1(self.$responseText)
                .color(.white)
            
            Div().class(.clear).height(7.px)
            
            Div{
                self.loader
            }
            .align(.center)
            
            Div().class(.clear).height(36.px)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
    }
    
    override func buildUI() {
        super.buildUI()

        responseText = action.title
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        loadingView.show()
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event = event else {
                return
            }

            switch event {
            case .custTaskDenied:
                if let payload = self.ws.custTaskDenied($0) {
                    
                    if payload.alertType != self.action.alertType {
                        return
                    }

                    guard let taskid = self.taskid else {
                        return
                    }
                    
                    guard taskid == payload.id else {
                        return
                    }
                            
                    self.callback(false)
                    
                    showError(.generalError, self.action.deniedMessage)
                    
                    self.remove()
                    
                }
            case .custTaskAuthoroized:
                if let payload = self.ws.custTaskAuthoroized($0) {
                    
                    if payload.alertType != self.action.alertType {
                        return
                    }

                    guard let taskid = self.taskid else {
                        return
                    }

                    guard taskid == payload.id else {
                        return
                    }
                    
                    self.callback(true)
                    
                    self.remove()
                    
                }
            default:
                break
            }
            
            WebApp.current.wsevent.wrappedValue = ""
        }
        
        switch action {
        case .changePrice(let type, let id, let requestedPrice, let reason, let authorizationContext):
            API.custAPIV1.changePrice(
                type: type,
                id: id,
                requestedPrice: requestedPrice,
                reason: reason,
                authorizationContext: authorizationContext
            ) { resp in
                self.handleRequestResponse(
                    statusIsOK: resp?.status == .ok,
                    message: resp?.msg,
                    taskid: resp?.data?.taskid,
                    actionType: resp?.data?.actionType
                )
            }
        case .removeCharge(let orderId, let chargeId):
            API.custOrderV1.removeChargeCTAM(orderId: orderId, chargeId: chargeId) { resp in
                self.handleRequestResponse(statusIsOK: resp?.status == .ok, message: resp?.msg, taskid: resp?.data?.taskid)
            }
        case .removePayment(let orderId, let paymentId):
            API.custOrderV1.removePaymentCTAM(orderId: orderId, paymentId: paymentId) { resp in
                self.handleRequestResponse(statusIsOK: resp?.status == .ok, message: resp?.msg, taskid: resp?.data?.taskid)
            }
        }
    }

    private func handleRequestResponse(
        statusIsOK: Bool,
        message: String?,
        taskid: UUID?,
        actionType: CustTaskAuthorizationManagerActionType? = nil
    ) {
        loadingView.hide()

        guard statusIsOK else {
            showError(.generalError, message ?? "No se pudo solicitar autorizacion.")
            remove()
            return
        }

        guard let taskid else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            remove()
            return
        }

        if actionType == .notify {
            callback(true)
            remove()
            return
        }

        responseText = "Solicitud exitosa, esperando respuesta."
        self.taskid = taskid
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $responseText.removeAllListeners()
    }
}
