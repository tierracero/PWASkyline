//
//  OrderView+EquipmentView+SendToPendingConsumable.swift
//
//
//  Created by Victor Cantu on 10/19/23.
//

import Foundation
import TCFundamentals
import Web

extension OrderView.EquipmentView {
    
    class SendToPendingConsumable: Div {
        
        override class var name: String { "div" }
        
        public var orderId: UUID
        
        public var equipmentId: UUID
        
        public var lastCommunicationMethod: MessagingCommunicationMethods?
        
        private var callback: ((
            _ newDate: Int64?,
            _ manager: PendingConsumableManagerQuick
        ) -> ())
        
        init(
            orderId: UUID,
            equipmentId: UUID,
            lastCommunicationMethod: MessagingCommunicationMethods?,
            callback: @escaping (
                _ newDate: Int64?,
                _ manager: PendingConsumableManagerQuick
            ) -> Void
        ) {
            self.orderId = orderId
            self.equipmentId = equipmentId
            self.lastCommunicationMethod = lastCommunicationMethod
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var days = ""
        
        @State var descr = ""
        
        @State var reason = ""
        
        lazy var daysField = InputText(self.$days)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDarkLarge)
            .placeholder("0")
            .textAlign(.right)
            .height(28.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
        
        lazy var descriptionField = InputText(self.$descr)
            .custom("width", "calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .placeholder("Que se va a comprar")
            .height(28.px)
            .onFocus { tf in
                tf.select()
            }
        
        lazy var reasonField = InputText(self.$reason)
            .custom("width", "calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .placeholder("Mensaje al cliente (opcional)")
            .height(28.px)
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
                        
                        H2("Pendiente por Insumo/Refacción")
                            .color(.lightBlueText)
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    Div{
                        Label("Dias de espera")
                            .fontSize(18.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        self.daysField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().height(7.px)
                    
                    Label("¿Que se va acomprar?")
                    
                    Div().height(3.px)
                    
                    self.descriptionField
                    
                    Div().height(7.px)
                    
                    Label("Mensaje al cliente (opcional)")
                    
                    Div().height(3.px)
                    
                    self.reasonField
                    
                    Div().height(7.px)
                    
                    Div("Enviar a espera")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(94.percent)
                        .onClick {
                            self.sendToPending()
                        }
                }
                .padding(all: 12.px)
                
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
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
            left(0.px)
            top(0.px)
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            daysField.select()
        }
        
        func sendToPending(){
            
            loadingView(show: true)
            
            guard let days = Int(self.days) else {
                showError(.generalError, "Incluya un numero de dias validos")
                daysField.select()
                return
            }
            
            guard days > 0 else {
                showError(.generalError, "Incluya el numero de dias paa recibir insumo/refacción")
                daysField.select()
                return
            }
            
            API.custOrderV1.pendingConsumable(
                orderid: self.orderId,
                equipmentid: self.equipmentId,
                days: days,
                description: descr,
                reason: reason,
                sendComm: true,
                lastCommunicationMethod: lastCommunicationMethod
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .unexpenctedMissingPayload)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                orderCatch[self.orderId]?.status = .pendingSpare
                
                self.callback(payload.newDate, payload.manager)
                
                self.remove()
                
            }
        }
        
    }
}
