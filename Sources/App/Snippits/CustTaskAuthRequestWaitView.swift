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

    /// service, product, manual, rental
    var type: ChargeType
    var id: UUID
    var requestedPrice: Int64
    var reason: String
    
    private var callback: ((  
        _ auth: Bool
    ) -> ())
    
    init(
        type: ChargeType,
        id: UUID,
        requestedPrice: Int64,
        reason: String,
        callback: @escaping ((
            _ auth: Bool
        ) -> ())
    ) {
        self.type = type
        self.id = id
        self.requestedPrice = requestedPrice
        self.reason = reason
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    @State var responseText = "Solicitando cambio de precio"
    
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
                            
                            loadingView(show: true)
                            
                            API.custAPIV1.changePriceCancel(
                                taskid: taskid
                            ) { resp in
                                
                                loadingView(show: false)
                                
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
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        loadingView(show: true)
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event = event else {
                return
            }

            switch event {
            case .custTaskDenied:
                if let payload = self.ws.custTaskDenied($0) {
                    
                    if payload.alertType != .changePrice {
                        /// Only prrice changaes can be auth
                        return
                    }

                    guard let taskid = self.taskid else {
                        return
                    }
                    
                    guard taskid == payload.id else {
                        return
                    }
                            
                    self.callback(false)
                    
                    showError(.generalError, "El cambio de precio no fue autorizado.")
                    
                    self.remove()
                    
                }
            case .custTaskAuthoroized:
                if let payload = self.ws.custTaskAuthoroized($0) {
                    
                    if payload.alertType != .changePrice {
                        /// Only prrice changaes can be auth
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
        
        API.custAPIV1.changePrice(
            type: self.type,
            id: self.id,
            requestedPrice: self.requestedPrice,
            reason: self.reason
        ) { resp in
        
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                self.remove()
                return
            }
            
            guard let id = resp.data?.taskid else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.responseText = "Solicitud exitosa, esperando respuesta."
            
            self.taskid = id
            
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
