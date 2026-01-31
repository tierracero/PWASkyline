//
//  MoneyManger+FinancialServices+DetailView.swift
//  
//
//  Created by Victor Cantu on 8/9/23.
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.FinancialServicesView {
    
    class DetailView: Div {
        
        override class var name: String { "div" }
        
        public var financial: CustUserFinacialServices
        
        @State var notes: [CustGeneralNotesQuick]
        
        @State var vendor: CustVendorsQuick?
        
        private var updated: ((
        ) -> ())
        
        public init(
            financial: CustUserFinacialServices,
            notes: [CustGeneralNotesQuick],
            vendor: CustVendorsQuick?,
            updated: @escaping ((
            ) -> ())
        ){
            self.financial = financial
            self.notes = notes
            self.vendor = vendor
            self.updated = updated
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var isCompleted = false
        
        @State var amount = "0"
        
        @State var returned = "0"
        
        @State var balance = "0"
        
        /// ``Users data Involved``
        
        @State var createdBy = ""
        
        @State var targetUser = ""
        
        @State var noteText = ""
        
        lazy var noteField = InputText(self.$noteText)
            .custom("width", "calc(100% - 150px)")
            .class(.textFiledBlackDark)
            .placeholder("Agregar Nota...")
            .height(28.px)
            .onFocus { tf in
                tf.select()
            }
        
        /// ``Update data fileds``
        ///
        /// FinacialServicesReciptType?
        /// fiscalDocument, recipt
        /// If provided  recip will be costered closed
        @State var reciptType: FinacialServicesReciptType? = .recipt
        
        @State var reciptTypeListener = FinacialServicesReciptType.recipt.rawValue
        
        @State var reciptFolio: String = ""
        
        /// In case their is a fiscal document to relate to financial transaction
        @State var reciptId: String = ""
        
        /// Incase their is a recip (no fiscal document) relate to financial transaction
        @State var reciptImage: String?
        
        lazy var reciptTypeSelect = Select(self.$reciptTypeListener)
            .disabled(self.$isCompleted)
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
        
        lazy var returnedField = InputText(self.$returned)
            .placeholder("Cantidad a otorgar/reportar")
            .disabled(self.$isCompleted)
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
            .onClick { tf in
                tf.select()
            }
        
        lazy var fiscalUUIDField = InputText(self.$reciptId)
            .hidden(self.$reciptType.map{ $0 != .fiscalDocument })
            .placeholder("fd703f26-9127-4089-bf97-154af8e9538e")
            .disabled(self.$isCompleted)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
        
        lazy var folioField = InputText(self.$reciptFolio)
            .placeholder("SERIES / FOLIO")
            .disabled(self.$isCompleted)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
        
        
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
                        
                        H2{
                            Span("Ver Registro Financiero")
                                .color(.lightBlueText)
                            Span(self.financial.folio)
                                .marginLeft(7.px)
                                .color(.white)
                        }
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    // General Data
                    Div{
                        Div{
                            Label("Creado Por")
                                .color(.lightGray)
                                .marginBottom(3.px)
                                .fontSize(12.px)
                            Div(self.$createdBy)
                                .class(.oneLineText)
                                .marginBottom(7.px)
                                .fontSize(24.px)
                                .color(.white)
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Label("Portado Por")
                                .color(.lightGray)
                                .marginBottom(3.px)
                                .fontSize(12.px)
                            Div(self.$createdBy)
                                .class(.oneLineText)
                                .marginBottom(7.px)
                                .fontSize(24.px)
                                .color(.white)
                            
                        }
                        .width(50.percent)
                        .float(.left)
                    
                        Div().clear(.both)
                        
                    }
                    
                    /// Update data
                    Div{
                        Div{
                            
                            Div{
                                
                                Label("Creado en")
                                    .color(.lightGray)
                                    .marginBottom(3.px)
                                    .fontSize(12.px)
                                Div(getDate(self.financial.createdAt).formatedLong)
                                    .class(.oneLineText)
                                    .marginBottom(7.px)
                                    .fontSize(24.px)
                                    .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                
                                Label("Tipo Documento")
                                    .color(.lightGray)
                                    .marginBottom(3.px)
                                    .fontSize(12.px)
                                Div(self.financial.type.description)
                                    .class(.oneLineText)
                                    .marginBottom(7.px)
                                    .fontSize(24.px)
                                    .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                            
                            Label("Comentarios")
                                .color(.lightGray)
                                .marginBottom(3.px)
                                .fontSize(12.px)
                            Div(self.financial.comments)
                                .class(.oneLineText)
                                .marginBottom(7.px)
                                .fontSize(24.px)
                                .color(.white)
                            
                            Div().clear(.both)
                            
                            
                            Div{
                                
                                /// Select Provider
                                Div{
                                    
                                    Span("Seleccion Proveedor (opcional)")
                                        .color(.lightGray)
                                    
                                    Div("Buscar Proveedor")
                                        .hidden(self.$isCompleted)
                                        .color(.yellowTC)
                                        .marginBottom(7.px)
                                        .marginTop(-7.px)
                                        .float(.right)
                                        .class(.uibtn)
                                        .onClick {
                                            
                                            if self.isCompleted {
                                                return
                                            }
                                            
                                            addToDom( SearchVendorView(loadBy: nil) { account in
                                                self.vendor = account
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
                                
                                Div{
                                    Div("Balance Original")
                                        .marginBottom(3.px)
                                        .color(.lightGray)
                                }
                                .width(50.percent)
                                .float(.left)
                                
                                Div{
                                    Div(self.$amount)
                                        .textAlign(.right)
                                        .fontSize(24.px)
                                        .color(.white)
                                }
                                .width(50.percent)
                                .float(.left)
                                
                                Div().clear(.both)
                                
                                Div().clear(.both).marginBottom(12.px)
                                
                                Div{
                                    Div("Valor del Ticket")
                                        .marginBottom(3.px)
                                        .color(.lightGray)
                                }
                                .width(50.percent)
                                .float(.left)
                                
                                Div{
                                    self.returnedField
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                                
                                Div{
                                    Div("Cambio Devuelto")
                                        .marginBottom(3.px)
                                        .color(.lightGray)
                                }
                                .width(50.percent)
                                .float(.left)
                                
                                Div{
                                    Div(self.$balance)
                                        .textAlign(.right)
                                        .fontSize(24.px)
                                        .color(.goldenRod)
                                }
                                .width(50.percent)
                                .float(.left)
                                
                                Div().clear(.both).marginBottom(7.px)
                                
                            }
                            .margin(all: 7.px)
                            
                            Div{
                                
                                Div{
                                    Img()
                                        .src("/skyline/media/icon_print.png")
                                        .class(.iconWhite)
                                        .marginRight(7.px)
                                        .width(18.px)
                                    Span("Imprimir")
                                }
                                .marginTop(0.px)
                                .class(.uibtnLarge)
                                .float(.left)
                                .onClick {
                                    
                                    getUserRefrence(id: .id(self.financial.createdBy)) { _createdBy in
                                        getUserRefrence(id: .id(self.financial.targetUser)) { _targetUser in
                                            
                                            if let _createdBy {
                                                self.createdBy = _createdBy.username
                                            }
                                            
                                            if let _targetUser {
                                                self.targetUser = _targetUser.username
                                            }
                                            
                                            let printBody = CustUserFinacialServicesPrintEngine(
                                                item: self.financial,
                                                createdBy: self.createdBy,
                                                targetUser: self.targetUser,
                                                vendor: self.vendor
                                            ).innerHTML
                                            
                                            _ = JSObject.global.renderGeneralPrint!(custCatchUrl, self.financial.folio, printBody)
                                        }
                                    }
                                    
                                }
                                
                                Div("Actualizar Registro")
                                    .hidden(self.$isCompleted)
                                    .class(.uibtnLargeOrange)
                                    .marginRight(7.px)
                                    .onClick {
                                        self.updateFinancialService()
                                    }
                            }
                            .align(.right)
                            
                        }
                        .width(55.percent)
                        .float(.left)
                        
                        Div{
                            H2("Notas").color(.lightBlueText)
                            Div{
                                ForEach(self.$notes){ note in
                                    QuickMessageObject(
                                        isEven: false,
                                        note: note
                                    )
                                }
                            }
                            .padding(all: 3.px)
                            .class(.roundBlue)
                            .margin(all: 3.px)
                            .overflow(.auto)
                            .height(385.px)
                            
                            Div().class(.clear)
                            
                            Div("Agregar Comentarios")
                                .fontSize(12.px)
                                .color(.white)
                            
                            Div()
                                .class(.clear)
                                .marginBottom(3.px)
                            
                            Div{
                                
                                self.noteField
                                    .onEnter {
                                        self.addNote()
                                    }
                                
                                Span(" Agergar Nota ")
                                    .marginLeft(7.px)
                                    .class(.uibtn)
                                    .width(100.px)
                                    .onClick {
                                        self.addNote()
                                    }
                                
                            }
                            .marginBottom(12.px)
                        }
                        .width(45.percent)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                    
                }
                .padding(all: 7.px)
                
            }
            .custom("left", "calc(50% - 400px)")
            .custom("top", "calc(50% - 295px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .minHeight(590.px)
            .width(800.px)
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
            
            getUserRefrence(id: .id(self.financial.createdBy)) { _createdBy in
                if let _createdBy {
                    self.createdBy = _createdBy.username
                }
            }
            
            getUserRefrence(id: .id(self.financial.targetUser)) { _targetUser in
                if let _targetUser {
                    self.targetUser = _targetUser.username
                }
            }
            
            FinacialServicesReciptType.allCases.forEach { type in
                reciptTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            reciptTypeListener = financial.reciptType?.rawValue ?? ""
            
            amount = financial.amount.formatMoney
            
            returned = financial.returned.formatMoney
            
            balance = financial.balance.formatMoney
            
            reciptFolio = financial.reciptFolio ?? ""
            
            reciptId = financial.reciptId?.uuidString ?? ""
            
            //reciptImage
            
            if let vendorid = financial.vendor {
                
                isCompleted = true
                
                API.custAPIV1.getVendor(id: vendorid) { resp in
                    
                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.comunicationError, .unexpenctedMissingPayload)
                        return
                    }
                    
                    self.vendor = payload
                    
                }
            }
            
            $returned.listen {
                
                guard let _returned = Double(self.returned)?.toCents else {
                    return
                }
                
                self.balance = (self.financial.amount - _returned).formatMoney
            }
            
            if financial.status == .billed {
                isCompleted = true
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }
        
        func updateFinancialService() {
            
            if isCompleted {
                return
            }
            
            guard let _returned = Double(self.returned)?.toCents else {
                showError(.generalError, "Ingrese una Cantidad valida.")
                returnedField.select()
                return
            }
            
            guard _returned <= financial.amount else {
                showError(.generalError, "El pago no puede ser mayor al balance")
                returnedField.select()
                return
            }
            
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
            
            addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme Accion",
                message: "Confirme que recibira $\((self.financial.amount - _returned).formatMoney) en efectivo y actulizara el registro finiacero. Esto pasara/permanecera en su poseción."
            ){ isCompleted, _ in
                
                loadingView(show: true)
                
                API.custAPIV1.updateFianancialService(
                    id: self.financial.id,
                    returned: _returned,
                    vendorid: vendor.id,
                    reciptType: reciptType,
                    reciptId: reciptUuid,
                    reciptFolio: self.reciptFolio,
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
                    
                    self.isCompleted = true
                    
                    self.financial.vendor = vendor.id
                    self.financial.returned = _returned
                    self.financial.balance = self.financial.amount - _returned
                    self.financial.vendor = vendor.id
                    self.financial.reciptType = reciptType
                    self.financial.reciptId = reciptUuid
                    self.financial.reciptFolio = self.reciptFolio
                    
                    let printBody = CustUserFinacialServicesPrintEngine(
                        item: self.financial,
                        createdBy: self.createdBy,
                        targetUser: self.targetUser,
                        vendor: vendor
                    ).innerHTML
                    
                    _ = JSObject.global.renderGeneralPrint!(custCatchUrl, self.financial.folio, printBody)
                    
                    self.updated()
                }
                
            })
            
        }
        
        func addNote(){
            if noteText.isEmpty {
                return
            }
            
            showError(.generalError, "Lo sentimos esta función aun no esta habilitada")
            
        }
    }
}
