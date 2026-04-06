//
//  ToolFiscalAddComplementoView.swift
//  
//
//  Created by Victor Cantu on 3/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscalAddComplementoView: Div {
    override class var name: String { "div" }
    /// fiscalProfiles
    var profile: FiscalComponents.Profile
    
    var docs: [FIAccountsServices]
    
    private var callback: ((
        _ item: [UUID]
    ) -> ())
    
    init(
        profile: FiscalComponents.Profile,
        docs: [FIAccountsServices],
        callback: @escaping ((
            _ item: [UUID]
        ) -> ())
    ) {
        
        self.profile = profile
        self.docs = docs
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var paymentDocument: FIAccountsServices? = nil
    
    @State var receptorRazon = ""
    
    @State var receptorRfc = ""
    
    @State var selectedDocumentsIds: [UUID] = []
    
    @State var subtotal:Int64 = 0
    
    @State var documentFilter = ""
    
    var filteredDocuments: [FIAccountsServices] = []
    
    lazy var documentFilterFilter = InputText(self.$documentFilter)
        .class(.textFiledBlackDarkLarge, .zoom)
        .onKeyUp({ tf, event in
            
            let term = tf.text.lowercased().purgeSpaces.purgeHtml.replace(from: ",", to: "")
            
            Dispatch.asyncAfter(0.33) {
                if term == tf.text.lowercased().purgeSpaces.purgeHtml.replace(from: ",", to: ""){
                    self.filterDocments()
                }
            }
            
        })
        .placeholder("Buscar...")
        .width(95.percent)
        .fontSize(23.px)
        .disabled(true)
        .float(.right)
    
    lazy var itemsView = Div()
        .height(self.$receptorRfc.map{ $0.isEmpty ? 390.px : 345.px })
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .overflow(.auto)
    
    lazy var paymentDocumentDiv = Div()
        .align(.center)
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Agregar complemento de pago")
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            Div {
                
                Label("Receptor")
                    .marginBottom(3.px)
                    .fontSize(24.px)
                    .color(.gray)
                
                H2(self.profile.razon)
                    .class(.oneLineText)
                    .color(.white)
                
            }
            .marginBottom(7.px)
            
            Div {
                
                Label("Emisor")
                    .marginBottom(3.px)
                    .fontSize(24.px)
                    .color(.gray)
                
                Div().class(.clear)
                
                Div{
                    
                    Div(self.$receptorRfc.map{ $0.isEmpty ? "RFC" : $0 })
                        .color(self.$receptorRfc.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
                        .marginRight(1.percent)
                        .class(.oneLineText)
                        .marginBottom(3.px)
                        .width(97.percent)
                        .fontSize(24.px)
                        .float(.left)
                    
                    Div(self.$receptorRazon.map{ $0.isEmpty ? "Empresa SA de CV" : $0 })
                        .color(self.$receptorRazon.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
                        .class(.oneLineText)
                        .marginBottom(3.px)
                        .fontSize(24.px)
                        .float(.left)
                }
                .width(self.$receptorRfc.map{ $0.isEmpty ? 50.percent : 100.percent })
                .float(.left)
                
                Div{
                    H3("Filtrar Documentos")
                        .color(.white)
                    
                    self.documentFilterFilter
                    
                }
                .hidden(self.$receptorRfc.map{ !$0.isEmpty })
                .width(50.percent)
                
                .float(.left)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            self.itemsView
            
            Div{
                
                H2("Balance")
                    .marginRight(7.px)
                    .color(.white)
                    .float(.left)
                
                H2(self.$subtotal.map{ $0.formatMoney })
                    .color(.darkOrange)
                    .float(.left)
                
                Div("Pagar")
                    .class(.uibtnLargeOrange)
                    .marginTop(-7.px)
                    .float(.right)
                    .onClick {
                        self.sendToPay()
                    }
                
                Div().class(.clear)
                
            }
            .hidden(self.$receptorRfc.map{ $0.isEmpty })
            .padding(all: 12.px)
            
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 400px)")
        .custom("top", "calc(50% - 300px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(600.px)
        .width(800.px)
        
        Div{
            Div {
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Agregar complemento de pago")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    Div().marginTop(24)
                    Span("Aqui esta su docuento de pago.")
                    Div().marginTop(24)
                    self.paymentDocumentDiv
                    
                }
                .marginBottom(7.px)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 300px)")
            .custom("top", "calc(50% - 150px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(300.px)
            .width(600.px)
        }
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .hidden(self.$paymentDocument.map{ $0 == nil })
        .left(0.px)
        .top(0.px)
        
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
        
        documentFilterFilter.select()
        
        docs.forEach { doc in
            itemsView.appendChild(loadFiscRow(doc: doc))
        }
        
        $selectedDocumentsIds.listen {
            
            var total: Int64 = 0
            
            self.docs.forEach { doc in
                if self.selectedDocumentsIds.contains(doc.id) {
                    
                    total += (doc.total - doc.paidBalance)
                    
                }
            }
            
            self.subtotal = total
            
        }
        
    }
    
    func filterDocments() {
        
        var currentIds: [UUID] = []
        
        let term = documentFilter.lowercased().purgeSpaces.purgeHtml.replace(from: ",", to: "")
        
        /// `` full equivencily``
        docs.forEach { doc in
            
            var add = false
            
            if doc.folio == term {
                add = true
            }
            
            if doc.receptorRfc.lowercased() == term {
                add = true
            }
            
            let total = doc.total.fromCents.toString.explode(".").first ?? ""
            
            if total == term {
                add = true
            }

            if add {
                currentIds.append(doc.id)
                itemsView.appendChild(loadFiscRow(doc: doc))
            }
            
        }
        
        /// `` contains equivencily``
        docs.forEach { doc in
            
            var add = false
            
            if doc.folio.contains(term) {
                add = true
            }
            
            if doc.receptorRfc.lowercased().contains(term) {
                add = true
            }
            
            if doc.receptorName.lowercased().contains(term) {
                add = true
            }
            
            let total = doc.total.fromCents.toString.explode(".").first ?? ""
            
            if total.contains(term) {
                add = true
            }

            if add {
                
                if currentIds.contains(doc.id) {
                    return
                }
                
                currentIds.append(doc.id)
                itemsView.appendChild(loadFiscRow(doc: doc))
            }
            
        }
    }
    
    func loadFiscRow( doc: FIAccountsServices) -> Div {

        let dataView = Div()
        
        let view = Div {
            
            Div{
                
                Div(doc.receptorRfc)
                    .class(.oneLineText)
                    .marginRight(3.px)
                    .color(.gray)
                    .width(200.px)
                    .float(.left)
                
                Div(doc.receptorName)
                    .custom("width", "calc(100% - 204px)")
                    .class(.oneLineText)
                    .color(.white)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            
            dataView
                
        }
            .backgroundColor(self.$selectedDocumentsIds.map { $0.contains( doc.id ) ? .black : .backGroundRow })
            .hidden(self.$receptorRfc.map{ ($0.isEmpty || $0 == doc.receptorRfc) ? false : true })
            .borderRadius(12.px)
            .padding(all: 3.px)
            .margin(all: 3.px)
            .cursor(.pointer)
            .color(.white)
            .onClick {
                if self.selectedDocumentsIds.contains(doc.id) {
                    var newSelectedDocs: [UUID] = []
                   
                    self.selectedDocumentsIds.forEach { id in
                        
                        if doc.id == id {
                            return
                        }
                        
                        newSelectedDocs.append(id)
                        
                    }
                    
                    self.selectedDocumentsIds = newSelectedDocs
                    
                }
                else{
                    self.selectedDocumentsIds.append(doc.id)
                }
                
                if self.selectedDocumentsIds.isEmpty {
                    self.receptorRfc = ""
                    self.receptorRazon = ""
                }
                else{
                    self.receptorRfc = doc.receptorRfc
                    self.receptorRazon = doc.receptorName
                }
                
            }
        
        
        var paidColor: Color = .white
        
        var paidDate = ""
        
        if let dueAt = doc.dueAt {
            
            paidDate = getDate(dueAt).formatedLong
            
            let dueIn = dueAt - getNow()
            
            if dueIn > Int64().sevenDays {
                paidColor = .white
            }
            else if dueIn > Int64().threeDays && dueIn < Int64().sevenDays {
                paidColor = .green
            }
            else if dueIn > Int64().oneDay && dueIn < Int64().threeDays {
                paidColor = .yellowDarkText
            }
            else if dueIn > 0.toInt64 && dueIn < Int64().oneDay {
                paidColor = .darkOrange
            }
            else if dueIn < 0.toInt64 {
                paidColor = .slateRed
            }
            
        }
        
        dataView.appendChild(Div{
            
            Div("Folio / Serie")
                .width(20.percent)
                .fontSize(14.px)
                .color(.gray)
                .float(.left)
            
            Div("Creado")
                .width(30.percent)
                .fontSize(14.px)
                .color(.gray)
                .float(.left)
            
            Div("Pagar")
                .width(30.percent)
                .fontSize(14.px)
                .color(.gray)
                .float(.left)
            
            Div("Bal: \(doc.total.formatMoney)")
                .width(20.percent)
                .fontSize(14.px)
                .align(.right)
                .color(.gray)
                .float(.left)
            
            Div().class(.clear)
            
            Div{
                Span(doc.folio)
                    .padding(all: 0.px)
                    .margin(all: 0.px)
                Span(" ")
                    .padding(all: 0.px)
                    .margin(all: 0.px)
                Span(doc.serie)
                    .padding(all: 0.px)
                    .margin(all: 0.px)
                    .color(.gray)
            }
                .class(.oneLineText)
                .width(20.percent)
                .fontSize(24.px)
                .color(.white)
                .float(.left)
        
            
            Div(getDate(doc.officialDate).formatedLong)
                .class(.oneLineText)
                .width(30.percent)
                .fontSize(24.px)
                .color(.white)
                .float(.left)
            
            Div(paidDate)
                .class(.oneLineText)
                .width(30.percent)
                .color(paidColor)
                .fontSize(24.px)
                .float(.left)
            
            Div("$" + (doc.total - doc.paidBalance).formatMoney)
                .class(.oneLineText)
                .width(20.percent)
                .fontSize(24.px)
                .align(.right)
                .color(.white)
                .float(.left)
            
            Div().class(.clear)
            
            
        }.width(100.percent))
        
        return view
        
    }
    
    func sendToPay(){
        
        if selectedDocumentsIds.isEmpty {
            return
        }
        
        var selectedDocuments: [FIAccountsServices] = []
        
        docs.forEach { doc in
            if selectedDocumentsIds.contains(doc.id) {
                selectedDocuments.append(doc)
            }
        }
        
        addToDom(AddPaymentFormView(
            accountId: nil,
            cardId: nil,
            currentBalance: self.subtotal
        ) { code, description, amount, provider, lastFour, auth, uts in
            API.fiscalV1.payment(
                storeId: custCatchStore, 
                ids: self.selectedDocumentsIds,
                description: description,
                payment: amount,
                comment: "",
                officialDate: uts,
                forma: code,
                provider: provider,
                auth: auth,
                lastFour: lastFour
            ) { resp in
                
                guard let resp else{
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, .unexpectedError("No se localizo data de la respueta"))
                    return
                }
                
                self.paymentDocumentDiv.appendChild(FiscalDocumentRow(
                    folio: self.profile.folio,
                    doc: payload
                ))
                
                self.paymentDocument = payload

                self.callback(self.selectedDocumentsIds)
                
            }
        })
        
    }
}
