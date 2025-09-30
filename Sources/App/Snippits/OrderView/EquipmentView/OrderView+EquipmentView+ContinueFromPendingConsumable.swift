//
//  OrderView+EquipmentView+ContinueFromPendingConsumable.swift
//
//
//  Created by Victor Cantu on 10/19/23.
//

import Foundation
import TCFundamentals
import Web

extension OrderView.EquipmentView {
    
    class ContinueFromPendingConsumable: Div {
        
        override class var name: String { "div" }
        
        public var orderId: UUID
        
        public var equipmentId: UUID
        
        public var maneger: PendingConsumableManagerQuick
        
        public var lastCommunicationMethod: MessagingCommunicationMethods?
        
        private var callback: ((
            _ orderStatus: CustFolioStatus
        ) -> ())
        
        init(
            orderId: UUID,
            equipmentId: UUID,
            maneger: PendingConsumableManagerQuick,
            lastCommunicationMethod: MessagingCommunicationMethods?,
            callback: @escaping (
                _ orderStatus: CustFolioStatus
            ) -> Void
        ) {
            self.orderId = orderId
            self.equipmentId = equipmentId
            self.maneger = maneger
            self.lastCommunicationMethod = lastCommunicationMethod
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var vendor: CustVendorsQuick? = nil
        
        /// ``Update data fileds``
        /// FinacialServicesReciptType?
        /// fiscalDocument, recipt
        /// If provided  recip will be costered closed
        @State var reciptType: FinacialServicesReciptType? = .recipt
        
        @State var reciptTypeListener = FinacialServicesReciptType.recipt.rawValue
        
        @State var reciptFolio: String = ""
        
        /// In case their is a fiscal document to relate to financial transaction
        @State var reciptId: String = ""
        
        @State var comment = ""
        
        lazy var reciptTypeSelect = Select(self.$reciptTypeListener)
            .body(content: {
                Option("Seleccione Opcion")
                    .value("")
            })
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
            .onChange({ _, select in
                self.reciptType = FinacialServicesReciptType(rawValue: select.text)
            })
        
        lazy var fiscalUUIDField = InputText(self.$reciptId)
            .hidden(self.$reciptType.map{ $0 != .fiscalDocument })
            .placeholder("fd703f26-9127-4089-bf97-154af8e9538e")
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
        
        lazy var folioField = InputText(self.$reciptFolio)
            .placeholder("SERIES / FOLIO")
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
        
        lazy var commentField = InputText(self.$comment)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .placeholder("Comentario de compra")
            .textAlign(.left)
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
                    
                    Label("Detalles:")
                    
                    Div().height(3.px)
                    
                    Div{
                        H2(self.maneger.comment)
                    }
                    
                    
                    //maneger
                    
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        /// Select Provider
                        Div{
                            
                            Span("Seleccion Proveedor")
                                .color(.lightGray)
                            
                            Div("Buscar Proveedor")
                                .color(.yellowTC)
                                .marginBottom(7.px)
                                .marginTop(-7.px)
                                .float(.right)
                                .class(.uibtn)
                                .onClick {
                                    
                                    addToDom( SearchVendorView(loadBy: nil) { vendor in
                                        self.vendor = vendor
                                    })
                                }
                            
                        }
                        .marginBottom(3.px)
                        
                        Div().clear(.both)
                        
                        Div(self.$vendor.map{ "\($0?.rfc ?? "Seleccione Proveedor") \($0?.razon ?? "")" })
                            .color( self.$vendor.map{ ($0 == nil) ? .gray : .cornflowerBlue })
                            .class(.oneLineText)
                            .marginBottom(12.px)
                            .fontSize(24.px)
                        
                        Div{
                            Div("Tipo de Comprobante")
                                .marginBottom(3.px)
                                .color(.lightGray)
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.reciptTypeSelect
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).marginBottom(7.px)
                        
                        Div{
                            
                            Div("UUID Fiscal")
                                .hidden(self.$reciptType.map{ $0 != .fiscalDocument })
                                .marginBottom(3.px)
                                .color(.lightGray)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.fiscalUUIDField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).marginBottom(7.px)
                        
                        Div{
                            Div("Folio / Serie")
                                .marginBottom(3.px)
                                .color(.lightGray)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.folioField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).marginBottom(7.px)
                        
                    }
                    
                    Label("Comentarios")
                    
                    Div().height(3.px)
                    
                    self.commentField
                    
                    Div().height(7.px)
                    
                    Div("Registrar compra")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(94.percent)
                        .onClick {
                            self.continueProcess()
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
            
            FinacialServicesReciptType.allCases.forEach { type in
                reciptTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
        }
        
        func continueProcess(){
            
            loadingView(show: true)
            
            API.custOrderV1.pendingConsumableContinue(
                hasPurchase: true,
                orderId: orderId,
                equipmentId: equipmentId,
                managerId: maneger.id,
                vendorId: vendor?.id,
                documentId: UUID(uuidString: reciptId),
                documentFolio: reciptFolio,
                comment: comment,
                sendComm: true,
                lastCommunicationMethod: lastCommunicationMethod
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .unexpenctedMissingPayload)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.callback(payload.orderStatus)
                
                self.remove()
                
            }
            
        }
        
    }
    
}

