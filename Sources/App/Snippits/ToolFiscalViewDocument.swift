//
//  ToolFiscalViewDocument.swift
//  
//
//  Created by Victor Cantu on 2/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscalViewDocument: Div {
    
    override class var name: String { "div" }
    
    let type: FiscalType
    
    var doc: FIAccountsServices
    
    @State var reldocs: [FIAccountsServices]
    
    let account: CustAcctFiscal
    
    private var isCanceled: ((
    ) -> ())
    
    init(
        type: FiscalType,
        doc: FIAccountsServices,
        reldocs: [FIAccountsServices],
        account: CustAcctFiscal,
        isCanceled: @escaping ((
        ) -> ())
    ) {
        self.type = type
        self.doc = doc
        self.reldocs = reldocs
        self.account = account
        self.isCanceled = isCanceled
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var balance: Int64 = 0
    
    @State var status: FIFacturaStatus = .active
    
    @State var comment = ""
    
    var emisorName = ""
    
    var pdfLink = ""
    
    var xmlLink = ""
   
    lazy var detailsView = Div{
        H2("Detalles")
            .color(.gray)
        
        /// `Status del Documento`
        Label("Status del Documento")
            .marginBottom(3.px)
            .color(.gray)
        
        InputText(self.$status.map{ $0.description })
            .class( .textFiledBlackDarkMedium)
            .custom("width", "calc(100% - 18px)")
            .marginBottom(7.px)
            .disabled(true)
        
    }
    .custom("height", "calc(100% - 42px)")
    .custom("width", "calc(33% - 7px)")
    .marginRight(7.px)
    .fontSize(18.px)
    .overflow(.auto)
    .float(.left)
    
    lazy var deleteDocumentsView = Div()
    
    lazy var relatedDocumentsView = Div()
    
    lazy var toolsView = Div{
        H2("Documentos")
            .color(.gray)
        
        Div{
            
            A{
                Img()
                    .src("/skyline/media/pdf_icon.png")
                    .marginTop(18.px)
                    .height(75.px)
            }
            .href(self.pdfLink)
            .margin(all: 7.px)
            
            A {
                Img()
                    .src("/skyline/media/xml_icon.png")
                    .marginTop(18.px)
                    .height(75.px)
            }
            .href(self.xmlLink)
            .margin(all: 7.px)
        }
        .margin(all: 7.px)
        .align(.center)
        
        self.deleteDocumentsView
        
        Div(" - No hay documentos relacionados - ")
            .marginBottom(12.px)
            .marginTop(12.px)
            .fontSize(24.px)
            .align(.center)
            .color(.gray)
            .hidden(self.$reldocs.map{ !$0.isEmpty })
        
        self.relatedDocumentsView
    }
    .custom("height", "calc(100% - 42px)")
    .custom("width", "calc(33% - 7px)")
    .marginRight(7.px)
    .fontSize(18.px)
    .float(.left)
    
    /// ``Delete Document``
    @State var deleteDocumentViewIsHidden = true
    
    /// FiscalCancelDocumentMotive
    @State var deleteDocumentSelectListener = ""
    
    @State var deleteDocumentSelectHelp = ""
    
    @State var deleteDocumentSelectReason = ""
    
    @State var communicationMethod = ""
    
    lazy var deleteDocumentSelect = Select(self.$deleteDocumentSelectListener){
        Option("- Seleccione Motivo -")
            .value("")
    }
    .class(.textFiledBlackDarkLarge)
    .marginBottom(7.px)
    .borderRadius(7.px)
    .width(100.percent)
    .fontSize(23.px)
    .float(.right)
    .onChange { _, select in
        if let code = FiscalCancelDocumentMotive(rawValue: select.value) {
            self.deleteDocumentSelectHelp = code.help
        }
        else{
            self.deleteDocumentSelectHelp = ""
        }
    }
    
    lazy var communicationMethodField = InputText(self.$communicationMethod)
        .placeholder("Ingrese correo o movil")
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .borderRadius(7.px)
        .width(100.percent)
        .fontSize(23.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Detalles de documeto fiscal")
                    .color(.white)
            }
            .marginBottom(7.px)
            
            Div {
                /// `Emisor`
                Div{
                    Label("Emisor")
                        .color(.yellowTC)
                    Label(self.doc.emisorRfc)
                        .float(.right)
                }
                .marginBottom(3.px)
                
                InputText(self.emisorName)
                    .class( .textFiledBlackDarkMedium)
                    .custom("width", "calc(100% - 18px)")
                    .marginBottom(7.px)
                    .disabled(true)
                
                /// `Receptor`
                Div{
                    Label("Receptor")
                        .color(.yellowTC)
                    Label(self.doc.receptorRfc)
                        .float(.right)
                }
                .marginBottom(3.px)

                InputText("\(self.account.folio) \(self.doc.receptorName)")
                    .class( .textFiledBlackDarkMedium )
                    .custom("width", "calc(100% - 18px)")
                    .marginBottom(7.px)
                    .disabled(true)
                
                /// `UUID`
                Label("UUID")
                    .marginBottom(3.px)
                    .color(.gray)
                
                InputText(self.doc.uuid?.uuidString ?? "")
                    .class( .textFiledBlackDarkMedium)
                    .custom("width", "calc(100% - 18px)")
                    .marginBottom(7.px)
                    .disabled(true)
                
                
                /// `Serie /  Folio`
                Label("Serie / Folio")
                    .marginBottom(3.px)
                    .color(.gray)

                InputText("\(self.doc.serie) / \(self.doc.folio)")
                    .class( .textFiledBlackDarkMedium)
                    .custom("width", "calc(100% - 18px)")
                    .marginBottom(7.px)
                    .disabled(true)
                
                /// `UUID`
                Label("Tipo / Metodo de Pago")
                    .marginBottom(3.px)
                    .color(.gray)
                
                InputText("\(self.doc.tipoDeComprobante.rawValue) \(self.doc.tipoDeComprobante.description) / \(self.doc.tipoDePago.rawValue) \(self.doc.tipoDePago.description)")
                    .class( .textFiledBlackDarkMedium)
                    .custom("width", "calc(100% - 18px)")
                    .marginBottom(7.px)
                    .disabled(true)
                
                /// Total / Balance
                if self.doc.methodoDePago == .pagoEnParcialidadesODiferido {
                    
                    Div{
                        Label("Total")
                            .marginBottom(3.px)
                            .color(.gray)
                        
                        InputText(self.doc.total.formatMoney)
                            .custom("width", "calc(100% - 18px)")
                            .class( .textFiledBlackDarkMedium)
                            .marginBottom(7.px)
                            .textAlign(.right)
                            .disabled(true)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        Label("Balance")
                            .marginBottom(3.px)
                            .color(.yellowTC)
                        
                        InputText((self.doc.total - self.doc.paidBalance).formatMoney)
                            .custom("width", "calc(100% - 18px)")
                            .class( .textFiledBlackDarkMedium)
                            .marginBottom(7.px)
                            .textAlign(.right)
                            .disabled(true)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                else {
                    Label("Total")
                        .marginBottom(3.px)
                        .color(.gray)
                    
                    InputText(self.doc.total.formatMoney)
                        .custom("width", "calc(100% - 18px)")
                        .class( .textFiledBlackDarkMedium)
                        .marginBottom(7.px)
                        .textAlign(.right)
                        .disabled(true)
                }
                
                Div{
                    Div("Enviar")
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            self.sendFiscalDocument()
                        }
                    
                    Label("Enviar Factura")
                        .marginBottom(3.px)
                        .color(.gray)
                }
                
                Div().height(7.px).clear(.both)
                
                self.communicationMethodField
                
                /// `UUID`
                Label("Comentarios")
                    .marginBottom(3.px)
                    .color(.gray)
                
                Div(self.$comment.map { $0.isEmpty ? "- sin comentario - " : $0 } )
                    .align( self.$comment.map{ $0.isEmpty ? .center : .left } )
                    .color( self.$comment.map{ $0.isEmpty ? .gray : .white } )
                    .marginBottom(7.px)
                
            }
            .custom("height", "calc(100% - 42px)")
            .custom("width", "calc(33% - 7px)")
            .marginRight(7.px)
            .fontSize(18.px)
            .float(.left)
            
            self.detailsView
            
            self.toolsView
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(80.percent)
        .width(90.percent)
        .left(5.percent)
        .top(10.percent)
        
        Div{
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.deleteDocumentViewIsHidden = true
                        }
                    
                    H2("Confirme Cancelacion")
                        .color(.white)
                    
                    /// ``Selccioe motivo``
                    Label("Motivo")
                        .marginBottom(12.px)
                        .fontSize(18.px)
                        .color(.gray)
                    
                    self.deleteDocumentSelect
                    
                    Div(self.$deleteDocumentSelectHelp.map { $0.isEmpty ? "- Seleccione Motivo -" : $0 })
                        .align(self.$deleteDocumentSelectHelp.map{ $0.isEmpty ? .center : .left })
                        .color(self.$deleteDocumentSelectHelp.map{ $0.isEmpty ? .gray : .white })
                        .marginBottom(7.px)
                        .color(.gray)
                    
                    /// ``Comentarios``
                    
                    Label("Comentarios")
                        .marginBottom(12.px)
                        .fontSize(18.px)
                        .color(.gray)
                    
                    TextArea(self.$deleteDocumentSelectReason)
                        .class(.textFiledBlackDarkLarge)
                        .placeholder("Ingrese la razon por la que se solicita la cancelacion...")
                        .padding(all: 12.px)
                        .marginBottom(7.px)
                        .width(95.percent)
                        .fontSize(18.px)
                        .height(70.px)
                    
                    Div{
                        Div("Solicitar Cancelacion")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                
                                if self.doc.status == .canceled || self.doc.status == .cancelationRequest  {
                                    showError(.errorGeneral, "Este docuemnto ya esta cancelado.")
                                    return
                                }
                                
                                self.deleteDocument()
                            }
                    }
                    .align(.right)
                    
                }
                .marginBottom(7.px)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 250px)")
            .custom("top", "calc(50% - 200px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(500.px)
        }
        .hidden(self.$deleteDocumentViewIsHidden)
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .color(.white)
        .left(0.px)
        .top(0.px)

    }

    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        color(.white)
        left(0.px)
        top(0.px)
        
        if !account.fiscalPOCMail.isEmpty {
            communicationMethod = account.fiscalPOCMail
        }
        else if !account.fiscalPOCMobile.isEmpty {
            communicationMethod = account.fiscalPOCMobile
        }
        else if !account.email.isEmpty {
            communicationMethod = account.email
        }
        else if !account.mobile.isEmpty {
            communicationMethod = account.mobile
        }
        
        fiscalProfiles.forEach { profile in
            if profile.rfc == doc.emisorRfc {
                emisorName = profile.razon
            }
        }
        
        status = doc.status
        
        var folio = ""
        
        fiscalProfiles.forEach { profile in
            if profile.rfc.uppercased() == doc.emisorRfc.uppercased() {
                folio = profile.folio
            }
        }
        
        let _folio = (folio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _pdf = (doc.pdf.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _xml = (doc.xml.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        pdfLink = pdfLinkString(folio: _folio, pdf: _pdf)
        
        xmlLink = xmlLinkString(folio: _folio, xml: _xml)
        
        switch self.doc.tipoDeComprobante {
        case .ingreso:
            
            if self.doc.version == "3.3" {
                
                guard let data = doc.raw.data(using: .utf8) else {
                    showError(.errorGeneral, "No se pudo decodificar DATA de RAW [\(doc.version)] Contacte a Soporte TC")
                    return
                }
                
                do {
                    let raw = try JSONDecoder().decode(FiscalDocumentObject.self, from: data)
                    
                    comment = raw.comment
                    
                    detailsView.appendChild(Label("Conceptos"))
                    
                    var table = Table{
                        Tr{
                            Td("Descripción")
                            Td("Uni.")
                                .align(.center)
                                .width(50.px)
                            Td("C.Uni")
                                .align(.center)
                                .width(50.px)
                            Td("Total")
                                .align(.center)
                                .width(50.px)
                        }
                    }
                        .width(100.percent)
                        .fontSize(12.px)
                    
                    var retenidos: Int64 = 0
                    var trasladados: Int64 = 0
                    
                    raw.items.forEach { item in
                        
                        item.taxString.forEach { type, value in
                            
                            value.forEach { obj in
                            
                                if type == "trasladado" {
                                    trasladados += obj.importe
                                }
                                else {
                                    retenidos += obj.importe
                                }
                                
                            }
                        }
                        
                        table.appendChild(Tr{
                            Td(item.name)
                            Td(item.quant.formatMoney)
                            Td(item.cost.formatMoney)
                            Td(item.importe.formatMoney)
                        })
                        
//                        let item: FiscalDocumentObject.TaxItem
                        
                        //detailsView.appendChild()
                    }
                    
                    if trasladados > 0 {
                        table.appendChild(Tr{
                            Td("")
                            Td("Trasladados")
                                .align(.right)
                                .colSpan(2)
                            Td(trasladados.formatMoney)
                                .align(.right)
                        })
                    }
                    
                    if retenidos > 0 {
                        table.appendChild(Tr{
                            Td("")
                            Td("Trasladados")
                                .align(.right)
                                .colSpan(2)
                            Td(retenidos.formatMoney)
                                .align(.right)
                        })
                    }
                    
                    table.appendChild(Tr{
                        Td("")
                        Td("Total")
                            .align(.right)
                            .colSpan(2)
                        Td(self.doc.total.formatMoney)
                            .align(.right)
                    })
                    
                    detailsView.appendChild(table)
                    
                }
                catch {
                    showError(.errorGeneral, "No se pudo decodificar RAW DATA [\(doc.version)] Contacte a Soporte TC")
                    
                    print("🔴  error  🔴")
                    
                    print(error)
                    
                }
            }
            else if self.doc.version == "4.0" {
                
                guard let data = doc.raw.data(using: .utf8) else {
                    showError(.errorGeneral, "No se pudo decodificar DATA de RAW [\(doc.version)] Contacte a Soporte TC")
                    return
                }
                
                do {
                    
                    let raw = try JSONDecoder().decode(Comprobante.IngresoRaw.self, from: data)
                    
                    comment = raw.comment
                    
                    detailsView.appendChild(Label("Conceptos"))
                    
                    var table = Table {
                        Tr{
                            Td("Descripción")
                            Td("Uni.")
                                .align(.center)
                                .width(50.px)
                            Td("C.Uni")
                                .align(.center)
                                .width(50.px)
                            Td("Total")
                                .align(.center)
                                .width(50.px)
                        }
                    }
                        .width(100.percent)
                        .fontSize(12.px)
                    
                    var retenidos: Int64 = 0
                    var trasladados: Int64 = 0
                    
                    raw.conceptos.concepto.forEach { concepto in
                        
                        if let taxes = concepto.impuestos?.retenidos {
                            taxes.retenido.forEach { tax in
                                retenidos += (tax.importe).toInt64
                            }
                        }
                        
                        if let taxes = concepto.impuestos?.traslados {
                            taxes.traslado.forEach { tax in
                                
                                //print("⭐️  tax.importe \(tax.importe)  ⚪️")
                                
                                trasladados += (tax.importe).toInt64
                            }
                        }
                        
                        table.appendChild(Tr{
                            Td(concepto.descripcion)
                            Td((concepto.cantidad).formatMoney)
                            Td((concepto.valorUnitario).formatMoney)
                            Td((concepto.importe).formatMoney)
                        })
                        
                    }
                    
                    if trasladados > 0 {
                        table.appendChild(Tr{
                            Td("")
                            Td("Trasladados")
                                .align(.right)
                                .colSpan(2)
                            Td(trasladados.formatMoney)
                                .align(.right)
                        })
                    }
                    
                    if retenidos > 0 {
                        table.appendChild(Tr{
                            Td("")
                            Td("Trasladados")
                                .align(.right)
                                .colSpan(2)
                            Td(retenidos.formatMoney)
                                .align(.right)
                        })
                    }
                    
                    table.appendChild(Tr{
                        Td("")
                        Td("Total")
                            .align(.right)
                            .colSpan(2)
                        Td(self.doc.total.formatMoney)
                            .align(.right)
                    })
                    
                    detailsView.appendChild(table)
                    
                }
                catch {
                    showError(.errorGeneral, "No se pudo decodificar RAW DATA [\(doc.version)] Contacte a Soporte TC")
                }
                
            }
            else {
                showError(.errorGeneral, "Documento mp soportado [\(doc.version)] Contacte a Soporte TC")
            }
            
            if doc.status != .canceled && doc.status != .cancelationRequest {
                
                deleteDocumentsView.appendChild(Div{
                    
                    Div("⚠️ Para poder eliminar esto documento elimine los Documentos / Pagos ")
                        .hidden(self.$reldocs.map{ $0.isEmpty })
                    
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/cross.png")
                                .marginRight(12.px)
                                .cursor(.pointer)
                                .width(24.px)
                            
                            Span("Eliminar Factura")
                        }
                        .width(100.percent)
                        .class(.uibtnLarge)
                        .align(.center)
                        .onClick {
                            self.deleteDocumentViewIsHidden = false
                        }
                    }
                    .hidden(self.$reldocs.map{ !$0.isEmpty })
                    .align(.right)
                })
                
            }
            
        case .egreso:
            break
        case .nomina:
            break
        case .pago:
            
            if doc.status != .canceled && doc.status != .cancelationRequest  {
                deleteDocumentsView.appendChild(Div{
                    Div{
                        Img()
                            .src("/skyline/media/cross.png")
                            .marginRight(7.px)
                            .cursor(.pointer)
                            .width(24.px)
                        
                        Span("Eliminar Pago")
                    }
                    .class(.uibtnLarge)
                    .width(100.percent)
                    .onClick {
                        self.deleteDocumentViewIsHidden = false
                    }
                })
            }
            
        case .traslado:
            break
        }
        
        /// [ RFC : FIAcct.Folio ]
        var rfcFolioRefrence: [String:String] = [:]
        
        fiscalProfiles.forEach { profile in
            rfcFolioRefrence[profile.rfc] = profile.folio
        }
        
        if reldocs.count > 0 {
            
            relatedDocumentsView.appendChild(H2("Documentos Relacionado").color(.white))
            
            reldocs.forEach { item in
                relatedDocumentsView.appendChild(loadFiscRow(folio: rfcFolioRefrence[item.emisorRfc] ?? "", doc: item))
            }
        }
        
        FiscalCancelDocumentMotive.allCases.forEach { item in
            deleteDocumentSelect.appendChild(Option(item.description).value(item.rawValue))
        }
        
        if doc.status != .canceled && doc.status != .cancelationRequest {
            /// `Doc is activa`
            
            balance = (doc.total - doc.paidBalance)
            
            if doc.tipoDeComprobante == .ingreso && doc.tipoDePago == .porDefenir && balance > 0{
                /// `Ingreso agregar pago`
                
                
                
                let addPaymentBtn = Div{
                    Div{
                        
                        Img()
                            .src("/skyline/media/coin.png")
                            .marginRight(7.px)
                            .cursor(.pointer)
                            .marginTop(7.px)
                            .width(24.px)
                        
                        Span("Agregar Pago")
                    }
                    .width(100.percent)
                    .class(.uibtnLarge)
                    .align(.center)
                    .onClick {
                        self.addPayment()
                    }
                }
                    .hidden(self.$balance.map{ $0 <= 0 })
                
                
                toolsView.appendChild(addPaymentBtn)
                
            }
            
        }
        
    }
    
    func sendFiscalDocument(){
        if let _ = Int64(communicationMethod) {
            let (isValid, reason) = isValidPhone(communicationMethod)
            
            if !isValid {
                showError(.errorGeneral, reason)
                return
            }
        }
        else {
            guard isValidEmail(communicationMethod) else {
                showError(.errorGeneral, "Correo electronico invalido")
                return
            }
        }
        
        loadingView(show: true)
        
        API.fiscalV1.reSendFiscalDocument(fiscalId: doc.id, method: communicationMethod) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            showSuccess(.operacionExitosa, "Factura Enviada")
            
        }
        
    }
    
    func loadFiscRow(folio: String, doc: FIAccountsServices) -> FiscalDocumentRow {

        return FiscalDocumentRow(
            folio: folio,
            doc: doc
        )

    }
    
    func deleteDocument() {
        
        guard let motive = FiscalCancelDocumentMotive(rawValue: self.deleteDocumentSelectListener) else {
            showError(.errorGeneral, "Seleccion motivo de cancelacion.")
            return
        }
        
        if deleteDocumentSelectReason.isEmpty {
            showError(.errorGeneral, "Ingrese explicación de la cencalación.")
            return
        }
        
        loadingView(show: true)
        
        API.fiscalV1.delete(
            id: doc.id,
            motive: motive,
            reason: deleteDocumentSelectReason
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data.")
                return
            }
            
            var title = ""
            
            var message = ""
            
            switch payload.typeOfCancelation {
            case .invalid:
                title = "Fallo solicitud de cancelacion"
                message = "No fue posible asolicitar o acompletar la cancelación del documento."
            case .required:
                title = "Solicitud de cancelacion exitoso"
                message = "Se ha iniciado el proceso de cancelacion \(payload.folio), esperaremos respuesta del receptor o en 72 h cancelacion automatica."
                self.doc.status = .cancelationRequest
            case .canceled:
                title = "Cancelacion Exitosa"
                message = "Se ha cancelado su documento con exito"
                self.doc.status = .canceled
                /// Successfully canceled, remove from dom
                self.isCanceled()
            }
            
            self.deleteDocumentViewIsHidden = true
            
            addToDom(ConfirmView(
                type: .ok,
                title: title,
                message: message
            ) { _, _ in
                
            })
        }
    }
    
    func addPayment(){
        if balance <= 0 {
            return
        }
        
        let view = AddPaymentFormView(
            accountId: nil,
            cardId: nil,
            currentBalance: balance
        ) { code, description, amount, provider, lastFour, auth, uts in
            
            API.fiscalV1.payment(
                storeId: custCatchStore, 
                ids: [self.doc.id],
                description: description,
                payment: amount.toCents,
                comment: "",
                officialDate: uts,
                forma: code,
                provider: provider,
                auth: auth,
                lastFour: lastFour
            ) { resp in
                
                guard let resp else{
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.errorGeneral, .unexpectedError("No se localizo data de la respueta"))
                    return
                }
                
                self.reldocs.append(payload)
                
                /// [ RFC : FIAcct.Folio ]
                var rfcFolioRefrence: [String:String] = [:]
                
                fiscalProfiles.forEach { profile in
                    rfcFolioRefrence[profile.rfc] = profile.folio
                }
                
                self.relatedDocumentsView.appendChild(self.loadFiscRow(folio: rfcFolioRefrence[payload.emisorRfc] ?? "", doc: payload))
                
            }
            
        }
        
        view.isDownPaymentDisabled = true
        view.datePickerIsHidden = false
        
        addToDom(view)
        
    }
    
}