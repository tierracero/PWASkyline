//
//  MoneyManger+FinancialServices+SpendingView.swift
//  
//
//  Created by Victor Cantu on 7/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.FinancialServicesView {
    
    class SpendingView: Div {
        
        override class var name: String { "div" }
        
        private var callback: ((
            _ financial: CustUserFinacialServicesQuick
        ) -> ())
        
        init(
            callback: @escaping ((
                _ financial: CustUserFinacialServicesQuick
            ) -> ())
        ) {
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var user: CustUsername? = nil
        
        @State var financialTitle: String = ""
        
        @State var amount: String = "0"
        
        @State var vendor: CustVendorsQuick?
        
        /// FinacialServicesReciptType?
        /// fiscalDocument, recipt
        /// If provided  recip will be costered closed
        @State var reciptType: FinacialServicesReciptType? = .recipt
        
        @State var reciptTypeListener = ""
        
        @State var reciptFolio: String = ""
        
        /// In case their is a fiscal document to relate to financial transaction
        @State var reciptId: String = ""
        
        /// Incase their is a recip (no fiscal document) relate to financial transaction
        @State var reciptImage: String?
        
        lazy var reciptTypeSelect = Select(self.$reciptTypeListener)
            .body(content: {
                Option("Seleccione Opcion")
                    .value("")
            })
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .disabled(true)
            .height(36.px)
            .onChange({ _, select in
                self.reciptType = FinacialServicesReciptType(rawValue: select.text)
            })
        
        lazy var amountField = InputText(self.$amount)
            .placeholder("Cantidad a otorgar/reportar")
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
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
        
        lazy var financialField = InputText(self.$financialTitle)
            .placeholder("Descripción o Motivo")
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
        
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
        
        /// SearchVendorView
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
                        
                        /// Titile
                        H2(self.$user.map{ ($0?.id == custCatchID) ? "Reportar Gasto/Compra" : "Otorgar Capital" })
                            .color(.lightBlueText)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    /// No target select view
                    Div{
                        Table{
                            Tr{
                                Td{
                                    Span("🐼 Seleccione Usuario")
                                    if custCatchHerk > 1 {
                                        Div("Seleccione Usuario").class(.uibtnLargeOrange)
                                            .onClick {
                                                
                                                var type = SelectCustUsernameView.LoadType.store(custCatchStore)
                                                
                                                if custCatchHerk > 3 {
                                                    type = .all
                                                }
                                                
                                                addToDom(SelectCustUsernameView(
                                                    type: type,
                                                    ignore: [],
                                                    callback: { user in
                                                        self.user = user
                                                        self.amountField.select()
                                                    }
                                                ))
                                            }
                                    }
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                    }
                    .hidden(self.$user.map{ $0 != nil })
                    .height(400.px)
                    
                    /// Finicial data view
                    Div{
                        /// Select User
                        Div("Usuario a Otorgar")
                            .marginBottom(3.px)
                            .color(.lightGray)
                        
                        Div(self.$user.map{ $0?.username ?? "" })
                            .marginBottom(12.px)
                            .fontSize(24.px)
                            .color(.white)
                        
                        Div().clear(.both)
                        
                        
                        Div{
                            /// Amount
                            Div(self.$user.map{ ($0?.id == custCatchID) ? "Cantidad a Otorgar" : "Cantidad a Reportar" })
                                .marginBottom(3.px)
                                .color(.lightGray)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.amountField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).marginBottom(7.px)
                        
                        Div{
                            Div("Motivo o nombre")
                                .marginBottom(3.px)
                                .color(.lightGray)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.financialField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                        Div{
                            
                            Div{
                                
                                /// Select Provider
                                Div{
                                    
                                    Span("Seleccion Proveedor (opcional)")
                                        .color(.lightGray)
                                    
                                    Div("Buscar Proveedor")
                                        .marginBottom(7.px)
                                        .marginTop(-7.px)
                                        .float(.right)
                                        .class(.uibtn)
                                        .onClick {
                                            addToDom( SearchVendorView(loadBy: nil) { account in
                                                self.vendor = account
                                            })
                                        }
                                    
                                }
                                .marginBottom(3.px)
                                
                                Div().clear(.both)
                                
                                Div("Seleccione solo si compra/pago ya fue realizada")
                                    .hidden(self.$vendor.map{ $0 != nil })
                                    .marginBottom(7.px)
                                    .marginBottom(3.px)
                                    .color(.yellowTC)
                                    .align(.center)
                                
                                Div{
                                    
                                    Div(self.$vendor.map{ "\($0?.rfc ?? "") \($0?.razon ?? "")" })
                                        .color(.cornflowerBlue)
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
                                    
                                    Div().clear(.both)
                                    
                                }
                                .hidden(self.$vendor.map{ $0 == nil })
                                
                            }
                            .margin(all: 7.px)
                            
                        }
                        .hidden(self.$user.map{ $0?.id != custCatchID })
                        .class(.roundDarkBlue)
                        .marginBottom(7.px)
                        
                        Div{
                            
                            Div(self.$user.map{ ($0?.id == custCatchID) ? "Reportar Gasto/Compra" : "Otorgar Capital" })
                                .class(.uibtnLargeOrange)
                                .marginBottom(7.px)
                                .onClick {
                                    self.createReport()
                                }
                            
                        }
                        .align(.center)
                        
                    }
                    .hidden(self.$user.map{ $0 == nil })
                }
                .padding(all: 12.px)
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .width(35.percent)
            .left(30.percent)
            .top(20.percent)
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
            
            reciptTypeListener = FinacialServicesReciptType.recipt.rawValue
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            if custCatchHerk > 1 {
                
                var type = SelectCustUsernameView.LoadType.store(custCatchStore)
                
                if custCatchHerk > 3 {
                    type = .all
                }
                
                addToDom(SelectCustUsernameView(
                    type: type,
                    ignore: [],
                    callback: { user in
                        self.user = user
                        self.amountField.select()
                    }
                ))
                
            }
            else {
                
                getUsers(storeid: custCatchStore, onlyActive: true) { users in
                    
                    users.forEach { user in
                        
                        if custCatchID == user.id {
                            self.user = user
                            self.amountField.select()
                        }
                        
                    }
                    
                }
            }
        }
        
        func createReport(){
            
            guard let user else {
                showError(.errorGeneral, "Seleccione usuario.")
                return
            }
            
            guard let amount = Double(self.amount)?.toCents else {
                showError(.errorGeneral, "Ingrese una Cantidad valida.")
                amountField.select()
                return
            }
            
            if financialTitle.isEmpty {
                showError(.errorGeneral, "Ingrese descripción del evento.")
                financialField.select()
                return
            }
            
            /// if its the same user then it's a  REPORT PURCHASE/ EXPENSE
            if custCatchID == user.id {
                
                guard let vendor else {
                    showError(.errorGeneral, "Seleccione proveedor.")
                    return
                }
                
                guard let reciptType else {
                    showError(.errorGeneral, "Seleccione tipo de recibo.")
                    return
                }
                
                var reciptUuid: UUID? = nil
                
                if reciptType == .fiscalDocument {
                    
                    guard let _reciptUuid = UUID(uuidString: reciptId) else {
                        showError(.errorGeneral, "Ingrese el UUID del documento fiscal.")
                        return
                    }
                    
                    reciptUuid = _reciptUuid
                }
                
                if reciptFolio.isEmpty {
                    showError(.errorGeneral, "Ingrese el Serie/Folio del Recibo/Factura.")
                    return
                }
                
                loadingView(show: true)
                
                API.custAPIV1.createFinancialService(
                    type: .money,
                    targetUser: user.id,
                    amount: amount,
                    description: financialTitle,
                    vendorid: vendor.id,
                    vendorName: vendor.razon,
                    reciptType: reciptType,
                    reciptId: reciptUuid,
                    reciptFolio: (reciptFolio.isEmpty) ? nil : reciptFolio,
                    reciptImage: nil
                ) { resp in
                
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else{
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.errorGeneral, .unexpenctedMissingPayload)
                        return
                    }
                    
                    let printBody = CustUserFinacialServicesPrintEngine(
                        item: payload,
                        createdBy: custCatchUser,
                        targetUser: user.username,
                        vendor: vendor
                    ).innerHTML
                    
                    _ = JSObject.global.renderGeneralPrint!(custCatchUrl, payload.folio, printBody)
                    
                    self.remove()
                    
                }
                
            }
            /// if its the difrente user then it's a  MONEY TRANSFER
            else {
         
                loadingView(show: true)
                
                API.custAPIV1.createFinancialService(
                    type: .money,
                    targetUser: user.id,
                    amount: amount,
                    description: financialTitle,
                    vendorid: nil,
                    vendorName: nil,
                    reciptType: nil,
                    reciptId: nil,
                    reciptFolio: nil,
                    reciptImage: nil
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else{
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.errorGeneral, .unexpenctedMissingPayload)
                        return
                    }
                    
                    self.callback(.init(
                        id: payload.id,
                        createdAt: payload.createdAt,
                        targetUser: payload.targetUser,
                        folio: payload.folio,
                        type: payload.type,
                        comments: payload.comments,
                        amount: payload.amount,
                        returned: payload.returned,
                        balance: payload.balance,
                        reciptType: payload.reciptType,
                        status: payload.status
                    ))
                    
                    let printBody = CustUserFinacialServicesPrintEngine(
                        item: payload,
                        createdBy: custCatchUser,
                        targetUser: user.username,
                        vendor: nil
                    ).innerHTML
                    
                    _ = JSObject.global.renderGeneralPrint!(custCatchUrl, payload.folio, printBody)
                    
                    self.remove()
                    
                    
                }
                
            }
        }
    }
}
