//
//  OrderView+EquipmentView+AddWarrantyCard.swift
//
//
//  Created by Victor Cantu on 10/19/23.
//

import Foundation
import TCFundamentals
import Web

extension OrderView.EquipmentView {

    class AddWarrantyCard: Div {
        
        override class var name: String { "div" }
        
        public var orderId: UUID

        public var equipmentId: UUID
        
        private var callback: ((
            _ cardCode: String
        ) -> ())
        
        init(
            orderId: UUID,
            equipmentId: UUID,
            callback: @escaping (
                _ cardCode: String
            ) -> Void
        ) {
            self.orderId = orderId
            self.equipmentId = equipmentId
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

                    self.cardCodeField

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

            API.custOrderV1.requestWarrantyCard(id: .code(term)) { resp in
        
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

            loadingView(show: true)

            API.custOrderV1.activateWarrantyCard(
                cardId: card.id,
                orderId: orderId,
                equipmentId: equipmentId
            ) { resp in

                loadingView(show: false)
            
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

    }
}
