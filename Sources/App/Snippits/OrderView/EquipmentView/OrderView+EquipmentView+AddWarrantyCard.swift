//
//  OrderView+EquipmentView+AddWarrantyCard.swift
//
//
//  Created by Victor Cantu on 10/19/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddWarrantyCard: Div {
    
    override class var name: String { "div" }

    var viewId: UUID { .init() }
    
    /// order, asset, preload
    let loadType: LoadType

    private var callback: ((
        _ cardCode: String
    ) -> ())
    
    init(
        loadType: LoadType,
        callback: @escaping (
            _ cardCode: String
        ) -> Void
    ) {
        self.loadType = loadType
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var cardCode = ""
    
    @State var card: CustShortLinkManager? = nil

    lazy var cardCodeField = InputText(self.$cardCode)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDarkLarge, .zoom)
        .placeholder("qr-XXXXXXXXXX")
        .textAlign(.left)
        .height(48.px)
        .onFocus { tf in
            tf.select()
        }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Agregar Tarjeta de Servicio")
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().height(12.px)
                
                Label("Tarjeta de Servicio")
                        .fontSize(18.px)
                
                                        
                Div().height(12.px)

                Div {
                    Div {
                        self.cardCodeField
                    }
                    .custom("width", "calc(100% - 42px)")
                    .float(.left)

                    Div().width(7.px).float(.left)

                    Div {
                        
                        Img()
                            .src("/skyline/media/mobileScannerWhite.png")
                            .cursor(.pointer)
                            .width(35.px)
                            .onClick {
                                self.requestMobileScanner()
                            }
                            
                    }
                    .width(35.px)
                    .float(.left)

                }

                Div().height(12.px)

                Div("Agregar Tarjeta")
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(94.percent)
                    .opacity(0.3)
                    .cursor(.default)
                    .hidden(self.$card.map{ $0 != nil })

                Div("Agregar Tarjeta")
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(94.percent)
                    .hidden(self.$card.map{ $0 == nil })
                    .onClick {
                        self.addWarantyCard()
                    }
                    
            }
            .padding(all: 12.px)
            
        }
        .custom("left", "calc(50% - 200px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .width(400.px)
        .top(25.percent)
        .color(.white)

    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        WebApp.current.wsevent.listen {
            guard self.isInDOM else { return }

            if $0.isEmpty { return }
            
            let (event, _) = WS().recive($0)
            
            guard let event = event else {
                return
            }
            print("⚡️ EVENT \(event)")
            switch event {
            case .requestMobileScannerComplete:
                
                if let payload = WS().requestMobileScannerComplete($0) {
                    
                    guard self.viewId == payload.eventid else {
                        return
                    }

                    print("🟢 FOUND VIEW 🟢 FOUND VIEW 🟢 FOUND VIEW 🟢 FOUND VIEW ")
                    
                    // searchFolio
                    let text = payload.text

                    print(text)

                    if text.contains("/c/") {
                        
                        let parts = text.explode("/c/")
                        
                        var code = parts.last ?? ""
                        
                        if !code.hasPrefix("qr-") {
                            code = "qr-\(code)"
                        }

                        self.cardCode = code

                    }
                    else {
                        self.cardCode = text
                    }
                    
                }
            default:
            break
            }
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        cardCodeField.select()

        $cardCode.listen {
            self.card = nil

            let term = $0.purgeSpaces.purgeHtml

            self.cardCodeField
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)

            if term.isEmpty {
                return
            }

            self.cardCodeField.class(.isLoading)

            Dispatch.asyncAfter(0.3) {
                
                let current = self.cardCode.purgeSpaces.purgeHtml

                if current != term {
                    return
                }

                self.requstWarrantyCad(term: term)
                
            }

        }
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $cardCode.removeAllListeners()
        $card.removeAllListeners()
    }

    func requstWarrantyCad(term: String) {

        if !term.hasPrefix("qr-") {
            cardCode = "qr-\(term)"
            return
        }   

        let requestType: CustShortLinkManagerType
        switch loadType {
        case .order, .preloadOrder:
            requestType = .folio
        case .asset, .preloadAsset:
            requestType = .asset
        }

        API.custAPIV1.requestServiceCard(
            type: requestType,
            id: .code(term)
        ) { resp in
    
            self.cardCodeField.removeClass(.isLoading)

            guard let resp else {
                self.cardCodeField.class(.isNok)
                return
            }

            guard resp.status == .ok else {
                self.cardCodeField.class(.isNok)
                return
            }

            guard let payload = resp.data else {
                return
            }
            
            self.card = payload.card

            self.cardCodeField.class(.isOk)

        }
    }

    func addWarantyCard() {

        guard let card: CustShortLinkManager else {
            showError(.unexpectedResult, "Seleccione una tarjeta valida")
            return
        }

        var type: CustComponents.ActivateServiceCardType? = nil

        switch loadType {
            case .order(let orderId, let equipmentId):
            type = .order(orderId: orderId, equipmentId: equipmentId)
            case .asset(let assetId):
            type = .asset(assetId: assetId)
            case .preloadAsset, .preloadOrder:
            self.callback(card.code)
            self.remove()
            return
        }

        guard let type: CustComponents.ActivateServiceCardType else {
            showError(.generalError, "No se pudo cargar peticion")
            return
        }

        loadingView.show()

        API.custAPIV1.activateServiceCard(
            cardId: card.id,
            type: type
        ) { resp in

            loadingView.hide()
        
            guard let resp else {
                self.cardCodeField.class(.isNok)
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else{
                self.cardCodeField.class(.isNok)
                showError(.generalError , resp.msg)
                return
            }

            showSuccess(.operacionExitosa, "Se agergo tarjeta")

            self.callback(card.code)

            self.remove()

            
        }
    }

    func requestMobileScanner() {
        API.custAPIV1.requestMobileCamara(
            type: .scanner,
            connid: custCatchChatConnID,
            eventid: viewId,
            relatedid: nil,
            relatedfolio: "",
            multipleTakes: false
        ) { resp in

            loadingView.hide()

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
        }
}


}

extension AddWarrantyCard {

    /// order, asset, preload
    enum LoadType {

        case order(orderId: UUID, equipmentId: UUID)

        case asset(assetId: UUID)

        case preloadOrder

        case preloadAsset

    }
}
