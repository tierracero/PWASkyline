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

        @State var selectedId: UUID? = nil
        
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
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .disabled(true)
            .height(42.px)
            .onChange({ _, select in
                self.reciptType = FinacialServicesReciptType(rawValue: select.text)
            })
        
        lazy var amountField = InputText(self.$amount)
            .placeholder("Cantidad a otorgar/reportar")
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .textAlign(.right)
            .height(42.px)
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
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
        
        lazy var fiscalUUIDField = InputText(self.$reciptId)
            .hidden(self.$reciptType.map{ $0 != .fiscalDocument })
            .placeholder("fd703f26-9127-4089-bf97-154af8e9538e")
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
        
        lazy var folioField = InputText(self.$reciptFolio)
            .placeholder("SERIES / FOLIO")
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
        
        /// SearchVendorView
        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 900)) {
                VTitle(
                    self.$user.map {
                        ($0?.id == custCatchID) ? "Reportar gasto / compra" : "Otorgar capital"
                    }
                ) {
                    USmallTitle(
                        self.$user.map {
                            guard let user = $0 else {
                                return "Seleccione usuario"
                            }
                            return user.id == custCatchID ? "Gasto propio" : "Transferencia"
                        }
                    )
                    .class(Class(TCMoneyManagerClass.badge))
                } onClose: {
                    self.remove()
                }
                .backgroundColor(.init(r: 37, g: 44, b: 59))

                VBodyGrid {
                    VGrid(.full) {
                        VBox(.raised) {
                            Div {
                                Img()
                                    .src("/skyline/media/coin.png")
                                    .width(40.px)
                                    .height(40.px)
                                    .custom("object-fit", "contain")

                                Div {
                                    USubTitle("Nuevo movimiento financiero")
                                    UMinorTitle("Capture el responsable, importe y soporte del movimiento.")
                                        .marginTop(4.px)
                                        .custom("line-height", "1.4")
                                }
                                .custom("min-width", "0")
                            }
                            .display(.grid)
                            .custom("grid-template-columns", "50px minmax(0, 1fr)")
                            .custom("align-items", "center")
                            .custom("gap", "12px")
                        }
                        //.class(Class(TCMoneyManagerClass.hero))
                    .custom("background-color", "rgba(37, 44, 59, 1.0) !important")
                    }

                    VGrid(.full) {
                        VBox(.standard) {
                            Div {
                                Div {
                                    Img()
                                        .src("/skyline/media/usernameIconWhite.svg")
                                        .width(30.px)
                                        .height(30.px)
                                }
                                .display(.flex)
                                .custom("align-items", "center")
                                .custom("justify-content", "center")
                                .width(48.px)
                                .height(48.px)
                                .custom("border", "1px solid rgba(66, 183, 245, 0.3)")
                                .custom("border-radius", "12px")
                                .custom("background", "rgba(10, 55, 87, 0.58)")

                                Div {
                                    USmallTitle("Responsable")
                                    USubTitle("Seleccione un usuario")
                                        .marginTop(4.px)
                                    UMinorTitle("El usuario determina si se reporta un gasto o se otorga capital.")
                                        .marginTop(4.px)
                                }
                                .custom("min-width", "0")

                                if custCatchHerk > 1 {
                                    USmallButton("Seleccionar")
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
                            .class(Class(TCMoneyManagerClass.userSummary))
                            .hidden(self.$user.map { $0 != nil })

                            Div {
                                Div {
                                    Img()
                                        .src("/skyline/media/usernameIconWhite.svg")
                                        .width(30.px)
                                        .height(30.px)
                                }
                                .display(.flex)
                                .custom("align-items", "center")
                                .custom("justify-content", "center")
                                .width(48.px)
                                .height(48.px)
                                .custom("border", "1px solid rgba(66, 183, 245, 0.3)")
                                .custom("border-radius", "12px")
                                .custom("background", "rgba(10, 55, 87, 0.58)")

                                Div {
                                    USmallTitle("Usuario seleccionado")
                                    USubTitle(self.$user.map { $0?.username ?? "" })
                                        .marginTop(4.px)
                                }
                                .custom("min-width", "0")

                                if custCatchHerk > 1 {
                                    USmallButton("Cambiar")
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
                            .class(Class(TCMoneyManagerClass.userSummary))
                            .hidden(self.$user.map { $0 == nil })
                        }
                        .class(Class(TCMoneyManagerClass.formCard))
                    }

                    VGrid(.half) {
                        UField(
                            self.$user.map {
                                ($0?.id == custCatchID) ? "Cantidad a otorgar" : "Cantidad a reportar"
                            },
                            required: true
                        ) {
                            self.amountField
                        }
                    }
                    .hidden(self.$user.map { $0 == nil })

                    VGrid(.half) {
                        UField("Motivo o nombre", required: true) {
                            self.financialField
                        }
                    }
                    .hidden(self.$user.map { $0 == nil })

                    VGrid(.full) {
                        VBox(.standard) {
                            Div {
                                Div {
                                    USubTitle("Proveedor y comprobante")
                                    UMinorTitle("Seleccione el proveedor cuando la compra o pago ya fue realizado.")
                                        .marginTop(4.px)
                                }
                                .custom("min-width", "0")

                                USmallButton("Buscar proveedor")
                                    .onClick {
                                        addToDom(SearchVendorView(loadBy: nil) { account in
                                            self.vendor = account
                                        })
                                    }
                            }
                            .display(.grid)
                            .custom("grid-template-columns", "minmax(0, 1fr) auto")
                            .custom("align-items", "center")
                            .custom("gap", "12px")

                            Div("Seleccione un proveedor para capturar el comprobante relacionado.")
                                .class(Class(TCMoneyManagerClass.hint))
                                .marginTop(14.px)
                                .hidden(self.$vendor.map { $0 != nil })

                            Div {
                                Div {
                                    USmallTitle("Proveedor seleccionado")
                                    USubTitle(self.$vendor.map { $0?.razon ?? "" })
                                        .marginTop(5.px)
                                    UMinorTitle(self.$vendor.map { $0?.rfc ?? "" })
                                        .marginTop(4.px)
                                }

                                Div {
                                    UField("Tipo de comprobante", required: true) {
                                        self.reciptTypeSelect
                                    }

                                    UField("UUID fiscal", required: true) {
                                        self.fiscalUUIDField
                                    }
                                    .hidden(self.$reciptType.map { $0 != .fiscalDocument })

                                    UField("Folio / serie", required: true) {
                                        self.folioField
                                    }
                                }
                                .class(Class(TCMoneyManagerClass.formGrid))
                                .marginTop(14.px)
                            }
                            .hidden(self.$vendor.map { $0 == nil })
                        }
                        .class(Class(TCMoneyManagerClass.formCard))
                    }
                    .hidden(self.$user.map { $0?.id != custCatchID })

                    VGrid(.half) {
                        ULargeButton("Cancelar")
                            .width(100.percent)
                            .onClick {
                                self.remove()
                            }
                    }
                    .hidden(self.$user.map { $0 == nil })

                    VGrid(.half) {
                        ULargeButton(
                            self.$user.map {
                                ($0?.id == custCatchID) ? "Reportar gasto / compra" : "Otorgar capital"
                            }
                        )
                        .width(100.percent)
                        .class(Class(TCMoneyManagerClass.primaryButton))
                        .onClick {
                            self.createReport()
                        }
                    }
                    .hidden(self.$user.map { $0 == nil })
                }
            }
            .class(Class(TCMoneyManagerClass.popup))
        }
        
        override func buildUI() {
            super.buildUI()

            TCMoneyManagerTheme.apply(to: self)
            
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

            financialField.select()
        }
        
        func createReport(){
            
            guard let user else {
                showError(.generalError, "Seleccione usuario.")
                return
            }
            
            guard let amount = Double(self.amount)?.toCents else {
                showError(.generalError, "Ingrese una Cantidad valida.")
                amountField.select()
                return
            }
            
            if financialTitle.isEmpty {
                showError(.generalError, "Ingrese descripción del evento.")
                financialField.select()
                return
            }
            
            /// if its the same user then it's a  REPORT PURCHASE/ EXPENSE
            if custCatchID == user.id {
                
                guard let vendor else {
                    showError(.generalError, "Seleccione proveedor.")
                    return
                }
                
                guard let reciptType else {
                    showError(.generalError, "Seleccione tipo de recibo.")
                    return
                }
                
                var reciptUuid: UUID? = nil
                
                if reciptType == .fiscalDocument {
                    
                    guard let _reciptUuid = UUID(uuidString: reciptId) else {
                        showError(.generalError, "Ingrese el UUID del documento fiscal.")
                        return
                    }
                    
                    reciptUuid = _reciptUuid
                }
                
                if reciptFolio.isEmpty {
                    showError(.generalError, "Ingrese el Serie/Folio del Recibo/Factura.")
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
                        showError(.comunicationError, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else{
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.generalError, .unexpenctedMissingPayload)
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
                        showError(.comunicationError, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else{
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.generalError, .unexpenctedMissingPayload)
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

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $user.removeAllListeners()
            $financialTitle.removeAllListeners()
            $amount.removeAllListeners()
            $vendor.removeAllListeners()
            $reciptType.removeAllListeners()
            $reciptTypeListener.removeAllListeners()
            $reciptFolio.removeAllListeners()
            $reciptId.removeAllListeners()
            $reciptImage.removeAllListeners()
        }
    }
}
