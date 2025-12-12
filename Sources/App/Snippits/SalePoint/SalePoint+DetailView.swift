//
//  SalePoint+DetailView.swift
//  
//
//  Created by Victor Cantu on 7/20/23.
//

import TCFundamentals
import Foundation
import Web
import XMLHttpRequest

extension SalePointView {
    
    class DetailView: Div {
        
        override class var name: String { "div" }
        
        // TODO: change to load by id
        
        let saleId: HybridIdentifier
        
        init(
            saleId: HybridIdentifier
        ) {
            
            self.saleId = saleId
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var itemGrid = Table{
            Tr {
                //Td().width(50)
                Td("Marca").width(150)
                Td("Modelo / Nombre")
                Td("Units").width(100)
                Td("C. Uni").width(100)
                Td("S. Total").width(100)
                Td("").width(50)
            }
        }
        .width(100.percent)
        .color(.white)
        
        @State var newNote = ""
        
        lazy var newNoteField = InputText(self.$newNote)
            .custom("width","calc(100% - 150px)")
            .placeholder("Agergar comentario...")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var notesDiv = Div()
        
        @State var custAcct: CustAcct? = nil
        
        @State var custSale: CustSale? = nil
        
        var custPOCInventory: [CustPOCInventorySoldObject] = []
        
        var custGeneralNotes: [CustGeneralNotes] = []
        
        var custPurchesOrder: [CustSaleAdditinalManager] = []
        
        var custPickUpOrder: [CustSaleAdditinalManager] = []
        
        var pocs: [String:CustPOCQuick] = [:]
        
        var inventory: [String:CustPOCInventorySoldObject] = [:]
        
        var charges: [CustAcctChargesQuick] = []
        
        @State var soldStore = ""

        @State var soldAt = ""
        
        @State var soldBy = ""
        
        @State var totalCost = ""
        
        @State var totalBalance = ""
        
        @State var totalRevenue = ""
        
        @State var totalCommision = ""
        
        @State var totalPremier = ""
        
        @State var fiscalDocument = ""
        
        @State var fiscalDocumentDue = ""
        
        /// unrequest, pendToPay, paid, sentToAcct, sentToDebt
        @State var fiscalDocumentStatus: FolioFiscDocStatus = .unrequest
        
        @State var fiscalDocumentID: UUID? = nil
        
        /// billed, unbilled, inrevice, removeRequest, canceled
        @State var status: BillingStatus = .canceled
        
        @DOM override var body: DOM.Content {
            Div {
                
                // Top Tools
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    Div(self.$status.map{ $0.description.uppercased() })
                        .letterSpacing(3.px)
                        .marginRight(23.px)
                        .color(.yellowTC)
                        .fontSize(23.px)
                        .float(.right)
                    
                    H2("Detalles de la Venta")
                        .color(.lightBlueText)
                        .float(.left)
                     
                    H2(self.$custSale.map{ $0?.folio ?? "N/A" })
                        .color(.yellowTC)
                        .marginLeft(7.px)
                        .float(.left)
                }
                .paddingBottom(3.px)
                
                Div().clear(.both)
                
                //Details
                Div{
                    
                    Div{
                        Div{
                            H3("Datos de la cuenta")
                                .marginBottom(7.px)
                                .color(.yellowTC)
                                
                            /// Account Item
                            Div{
                                
                                Div{
                                    
                                    Label("Folio").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.folio ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("# de Cuenta")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                    Label("Primer Nombre").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.firstName ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("Primer Nombre")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                    Label("Primer Apellido").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.lastName ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("Primer Apellido")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                }
                                .width(33.percent)
                                .float(.left)
                                
                                Div{
                                    
                                    Label("Tipo de Cuenta").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.type.description ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("Tipo de cuenta")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                    Label("Tipo de Precio").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.costType.description ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("Primer Nombre")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                    Label("Nombre Empresa").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.businessName ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("Nombre Empresa")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                }
                                .width(33.percent)
                                .float(.left)
                                
                                Div{
                                    
                                    Label("Credito").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.crstatus?.description ??  ""})
                                        .class(.textFiledBlackDark)
                                        .placeholder("Estado del Credito")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                    Label("Status").color(.gray)
                                    InputText(self.$custAcct.map{ $0?.status.description ?? "" })
                                        .class(.textFiledBlackDark)
                                        .placeholder("Estado de la cuenta")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                    
                                }
                                .width(33.percent)
                                .float(.left)
                                
                                Div().clear(.both)
                            }
                            
                            H3("Productos y cargos")
                                .marginBottom(7.px)
                                .color(.yellowTC)
                                
                            /// Poducts and Charges
                            self.itemGrid
                        }
                        .custom("height", "calc(100% - 47px)")
                        .overflow(.auto)
                        
                        Div{
                            Div{
                                
                                Img()
                                    .src("/skyline/media/cross.png")
                                    .marginRight(7.px)
                                    .cursor(.pointer)
                                    .height(18.px)
                                
                                Span("Cancelar")
                            }
                            .hidden(self.$status.map{ !($0 == .unbilled || $0 == .billed) })
                            .class(.uibtnLargeOrange)
                            .marginRight(7.px)
                            .marginTop(0.px)
                            .float(.right)
                            .onClick {
                                self.deleteSale()
                            }
                        
                            Div{
                                
                                Img()
                                    .src("/skyline/media/icon_print.png")
                                    .class(.iconWhite)
                                    .marginRight(7.px)
                                    .cursor(.pointer)
                                    .height(18.px)
                                Span("Ticket")
                            }
                            .class(.uibtnLargeOrange)
                            .marginRight(12.px)
                            .marginTop(0.px)
                            .float(.left)
                            .onClick {
                                
                                if configStore.printPdv.document == .miniprinter {
                                    
                                    self.printTicket()
                                    
                                }
                                else{
                                    
                                    guard let saleId = self.custSale?.id.uuidString else {
                                        return
                                    }
                                    
                                    let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") +
                                    "&ie=printPDVSale&id=" + saleId
                                    
                                    _ = JSObject.global.goToURL!(url)
                                    
                                }
                                
                            }
                    
                            Div{
                                
                                Img()
                                    .src("/skyline/media/whatsapp.png")
                                    .class(.iconWhite)
                                    .marginRight(7.px)
                                    .cursor(.pointer)
                                    .height(18.px)
                                Span("Enviar")
                            }
                            .class(.uibtnLargeOrange)
                            .marginTop(0.px)
                            .float(.left)
                            .onClick {
                                
                                self.sendSaleByMessage()  
                                
                            }
                        

                        }
                        
                    }
                    .height(100.percent)
                    .width(70.percent)
                    .overflow(.auto)
                    .float(.left)
                    
                    Div{
                        /// Detalles de la venta
                        Div{
                            H3("Datos de Venta")
                                .marginBottom(7.px)
                                .color(.yellowTC)
                            
                            Div{
                                Label("Tienda").color(.gray)
                                InputText(self.$soldStore)
                                    .class(.textFiledBlackDark)
                                    .placeholder("Tienda")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)


                                Label("Fecha").color(.gray)
                                InputText(self.$soldAt)
                                    .class(.textFiledBlackDark)
                                    .placeholder("Tienda")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                
                                Label("Vendedor").color(.gray)
                                InputText(self.$soldBy)
                                    .class(.textFiledBlackDark)
                                    .placeholder("Vendedor")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                
                                /*
                                Label("Fecha").color(.gray)
                                InputText(self.custSale?.createdAt.map{
                                    
                                    guard let uts = $0 else {
                                        return "N/A"
                                    }
                                    
                                    return getDate(uts).formatedShort
                                    
                                })
                                    .class(.textFiledBlackDark)
                                    .placeholder("DD/MM/AAAA")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                */
                                if custCatchHerk > 3 {
                                    Label("Ganacia").color(.gray)
                                    InputText(self.$totalRevenue)
                                        .class(.textFiledBlackDark)
                                        .placeholder("0.00")
                                        .marginBottom(7.px)
                                        .width(85.percent)
                                        .disabled(true)
                                }
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                Label("Balance").color(.gray)
                                InputText(self.$totalBalance)
                                    .class(.textFiledBlackDark)
                                    .placeholder("0.00")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                
                                Label("Total").color(.gray)
                                InputText(self.$totalCost)
                                    .class(.textFiledBlackDark)
                                    .placeholder("0.00")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                
                                Label("Comision").color(.gray)
                                InputText(self.$totalCommision)
                                    .class(.textFiledBlackDark)
                                    .placeholder("0.00")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                
                                Label("Recompensa Siwe").color(.gray)
                                InputText(self.$totalPremier)
                                    .class(.textFiledBlackDark)
                                    .placeholder("0.00")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                                
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        ///  Cliente y facturacion
                        Div{
                            Div{
                                
                                Div{
                                    Div(" Facturar ")
                                        .hidden(self.$fiscalDocumentID.map{ ($0 != nil) })
                                        .class(.uibtn)
                                        .float(.right)
                                        .onClick {
                                            self.facturar()
                                        }
                                    
                                    Div(" Ver Facturar ")
                                        .hidden(self.$fiscalDocumentID.map{ ($0 == nil) })
                                        .class(.uibtn)
                                        .float(.right)
                                        .onClick {
                                            
                                            guard let id = self.fiscalDocumentID else {
                                                return
                                            }
                                            
                                            loadingView(show: true)

                                            API.fiscalV1.loadDocument(docid: id) { resp in

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

                                                let view = ToolFiscalViewDocument(
                                                    type: payload.type,
                                                    doc: payload.doc,
                                                    reldocs: payload.reldocs,
                                                    account: payload.account
                                                ) {
                                                    /// Document canceled
                                                    self.fiscalDocumentStatus = .unrequest
                                                    self.fiscalDocumentID = nil
                                                }
                                                addToDom(view)
                                            }
                                        }
                                }
                                .hidden(self.$status.map{ !($0 == .unbilled || $0 == .billed) })
                                .float(.right)
                                
                                H3("Facturación")
                                    .color(.yellowTC)
                                
                            }
                            .marginBottom(7.px)
                            
                            Div{
                                Label("Factura").color(.gray)
                                InputText(self.$fiscalDocument)
                                    .cursor( self.$custSale.map{ ($0?.fiscalDocumentID == nil) ? .default : .pointer } )
                                    .class(.textFiledBlackDark)
                                    .placeholder("Tienda")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                Label("Fecha de Pago").color(.gray)
                                InputText(self.$fiscalDocumentDue)
                                    .class(.textFiledBlackDark)
                                    .placeholder("Tienda")
                                    .marginBottom(7.px)
                                    .width(85.percent)
                                    .disabled(true)
                            }
                            .width(50.percent)
                            .float(.left)
                        }
                        
                        /// Notas y comentarios
                        Div{
                            H3("Notas y comentarios")
                                .marginBottom(7.px)
                                .color(.yellowTC)
                            
                            Div{
                                self.notesDiv
                            }
                            .class(.roundDarkBlue)
                            .padding(all: 7.px)
                            .marginBottom(7.px)
                            .overflow(.auto)
                            .height(250.px)
                            
                            Div{
                                self.newNoteField
                                    .onEnter({
                                        self.addNote()
                                    })
                                    .float(.left)

                                
                                Div("Agregar")
                                    .class(.uibtnLargeOrange)
                                    .textAlign(.center)
                                    .marginTop(-7.px)
                                    .float(.right)
                                    .width(100.px)
                                    .onClick {
                                        self.addNote()
                                    }
                                
                                Div().clear(.both)
                            }
                        }
                         
                    }
                    .width(30.percent)
                    .float(.left)
                    
                }
                .custom("height", "calc(100% - 27px)")
                .padding(all: 3.px)
                .overflow(.auto)
                
                Div().class(.clear)
                
            }
            .custom("height", "calc(100% - 70px)")
            .custom("width", "calc(100% - 100px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(40.px)
            .top(25.px)
        }
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custPDVV1.getSale(saleId: self.saleId) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    self.remove()
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.remove()
                    return
                }
                
                guard let payload = resp.data else{
                    return
                }
                
                

                self.custAcct = payload.custAcct
                
                self.custSale = payload.custSale
                
                self.soldAt =  getDate(payload.custSale.createdAt).formatedLong

                self.fiscalDocumentStatus = payload.custSale.fiscalDocumentStatus
                
                self.fiscalDocumentID = payload.custSale.fiscalDocumentID
                
                self.status = payload.custSale.status
                
                self.custPOCInventory = payload.custPOCInventory
                
                self.custGeneralNotes = payload.custGeneralNotes
                
                self.custPurchesOrder = payload.custPickUpOrder
                
                self.custPickUpOrder = payload.custPickUpOrder
                
                self.pocs = payload.pocs
                
                self.inventory = payload.inventory
                
                self.charges = payload.charges
                
                var pocRef: [UUID:CustPOCQuick] = [:]
                
                payload.pocs.forEach { _, poc in
                    pocRef[poc.id] = poc
                }
                
                /// pocid : [CustPOCInventorySoldObject]
                var itemsRef: [UUID:[CustPOCInventorySoldObject]] = [:]
                
                var _cost: Int64 = 0
                
                var _commision: Int64 = 0
                
                var _revenue: Int64 = 0
                
                var _rewards: Int64 = 0
                
                payload.custPOCInventory.forEach { item in
                    
                    _cost += item.cost

                    _commision += item.comision
                    
                    _rewards = item.points
                    
                    if let soldPrice = item.soldPrice {
                        _revenue += soldPrice - item.cost -  item.premierPoints - item.comision
                        
                        print(_revenue)
                    }
                    
                    if let _ = itemsRef[item.POC] {
                        itemsRef[item.POC]?.append(item)
                    }
                    else{
                        itemsRef[item.POC] = [item]
                    }
                }
                
                itemsRef.forEach { id, items in
                    
                    guard let item = items.first else{
                        return
                    }
                    
                    guard let poc = pocRef[item.POC] else {
                        return
                    }
                    
                    var hasPriceVariation = false
                    
                    var soldPrice: Int64? = nil
                    
                    items.forEach { item in
                        
                        if let soldPrice {
                            if soldPrice != item.soldPrice {
                                hasPriceVariation = true
                            }
                        }
                        else {
                            soldPrice = item.soldPrice
                        }
                    }
                    
                    let total: Int64 = items.map{ ($0.soldPrice ?? 0) }.reduce(0, +)
                    
                    if hasPriceVariation {
                        soldPrice = ( total / items.count.toInt64 )
                    }
                    
                    let tr = KartSoldItemView(
                        id: id,
                        cost: item.cost,
                        quant: (items.count).toInt64,
                        price: soldPrice ?? 0,
                        total: total,
                        hasPriceVariation: hasPriceVariation,
                        data: .init(
                            t: .product,
                            i: item.id,
                            u: poc.upc,
                            n: poc.name,
                            b: poc.brand,
                            m: poc.model,
                            p: item.soldPrice ?? 0,
                            a: poc.avatar,
                            reqSeries: poc.reqSeries
                        )
                    )
                        
                        .class(.hoverFocusBlack)
                        .color(.white)
                 
                    tr.viewDetailButton = true
                    
                    tr.items = items
                    
                    self.itemGrid.appendChild(tr)
                    
                }
                
                payload.charges.forEach { charge in
                    
                    let thisCost = charge.cost * (charge.cuant / 100)
                    
                    let thisPrice = charge.price * (charge.cuant / 100)
                    
                    _cost += thisCost
                    
                    _revenue += thisPrice - thisCost
                    
                    let tr = KartItemView(
                        id: charge.id,
                        cost: charge.cost,
                        quant: charge.cuant / 100,
                        price: charge.price,
                        data: .init(
                            t: (charge.SOC == nil) ? .manual : .service ,
                            i: charge.SOC ?? charge.id,
                            u: "",
                            n: charge.name,
                            b: "",
                            m: "",
                            p: charge.price,
                            a: "",
                            reqSeries: false
                        ),
                        deleteButton: false
                    ) { id in
                        
                    } editManualCharge: { id, units, description, price, cost in
                        
                    }
                    .color(.white)
                    
                    self.itemGrid.appendChild(tr)
                    
                }
                
                payload.custGeneralNotes.forEach { note in
                    
                    @State var uname = ""
                    
                    if let userid = note.createdBy {
                        getUserRefrence(id: .id(userid)) { user in
                            uname = "@" + ((user?.username.explode("@").first) ?? user?.firstName ?? "N/A")
                        }
                    }
                    
                    var createdAt = getDate(note.createdAt)
                    
                    let dateString = "\(createdAt.formatedLong) \(createdAt.time)"
                    
                    let noteDiv = Div{
                        
                        Div{
                            Span(dateString)
                                .marginRight(7.px)
                            Span(uname)
                        }
                        .marginBottom(7.px)
                        .textAlign(.right)
                        
                        Div(note.activity)
                        
                        
                    }
                    .marginBottom(12.px)
                    .color(.white)
                    
                    self.notesDiv.appendChild(noteDiv)
                }
                
                self.totalCost = _cost.formatMoney
                
                self.totalBalance = payload.custSale.balance.formatMoney
                
                self.totalRevenue = _revenue.formatMoney
                
                self.totalCommision = _commision.formatMoney
                
                self.totalPremier = _rewards.formatMoney
                
                stores.forEach { _, store in
                    if payload.custSale.custStore == store.id {
                        self.soldStore = store.name
                    }
                }
                
                getUsers(storeid: nil, onlyActive: false) { users in
                    users.forEach { user in
                        if payload.custSale.createdBy == user.id {
                            self.soldBy = user.username
                        }
                    }
                }
                
                if let fiscid = payload.custSale.fiscalDocumentID {
                    self.fiscalDocument = fiscid.uuidString
                }
                
                if let dueAt = payload.custSale.fiscalDocumentDueDate {
                    self.fiscalDocumentDue = getDate(dueAt).formatedShort
                }
                
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
        }
        
        func addNote(){
            
            let note = self.newNote.purgeSpaces.purgeHtml
            
            if note.isEmpty {
                newNoteField.select()
                return
            }
            
            loadingView(show: true)
            
            guard let saleId = custSale?.id else {
                return
            }
            
            API.custPOCV1.addSaleNote(saleid: saleId, note: note) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    self.remove()
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.remove()
                    return
                }
                
                self.newNote = ""
                
                showSuccess(.operacionExitosa, "Comentario agregado")
                
            }
        }
        
        func printTicket(){
            
            guard let custSale else {
                return
            }
            
            let printBody = PDVPrintEngine(
                custAcct: custAcct,
                custSale: custSale,
                custPOCInventory: custPOCInventory,
                custPurchesOrder: custPurchesOrder,
                custPickUpOrder: custPickUpOrder,
                pocs: pocs,
                inventory: inventory,
                charges: charges,
                cardex: []
            ).innerHTML
            
            var purRefs = "{}"
            var _purRefs: [String:String] = [:]
            
            var pickRef = "{}"
            var _pickRef: [String:String] = [:]
            
            custPurchesOrder.forEach { item in
                _purRefs[item.id.uuidString] = item.folio
            }
            
            custPickUpOrder.forEach { item in
                _pickRef[item.id.uuidString] = item.folio
            }
            
            do {
                let data = try JSONEncoder().encode(_purRefs)
                
                if let json = String(data: data, encoding: .utf8) {
                    purRefs = json
                }
                
            }
            catch {}
            
            do {
                let data = try JSONEncoder().encode(_pickRef)
                
                if let json = String(data: data, encoding: .utf8) {
                    pickRef = json
                }
                
            }
            catch {}
            // (url, folio, contents, purRefs, pickRef )
            _ = JSObject.global.renderSalePrint!(custCatchUrl, custSale.folio, printBody, purRefs, pickRef)
            
        }
        
        func deleteSale(){
            
            guard let sale = custSale else {
                return
            }
            
            guard let createdBy = sale.createdBy else {
                return
            }
            
            addToDom(DeleteSaleConfirmView(
                folio: sale.folio,
                total: sale.total,
                createdBy: createdBy,
                callback: { type, reason, targetUser in
                    
                    loadingView(show: true)
                    
                    API.custPDVV1.cancelSale(
                        type: type,
                        saleid: sale.id,
                        reason: reason,
                        refundTo: targetUser
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, "Error de comunicacion")
                            return
                        }
                        
                        if resp.status != .ok {
                            showError(.errorGeneral, resp.msg)
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Venta cancelada")
                        
                        self.status = .canceled
                        
                    }
                }
            ))
        }
        
        func facturar(){
            
            guard let account = self.custAcct else{
                
                let view = SearchCustomerQuickView { account in
                    
                    loadingView(show: true)
                    
                    API.custAccountV1.load(id: .id(account.id)) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
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
                        
                        let account = payload.custAcct
                        
                        self.custAcct = account
                        
                        self.facturar()
                    }
                    
                    
                } create: { term in
                    /// No customer, create customer.
                    addToDom(CreateNewCusomerView(
                        searchTerm: term,
                        custType: .business,
                        callback: { acctType, custType, searchTerm in
                            
                            let custDataView = CreateNewCustomerDataView(
                                acctType: acctType,
                                custType: custType,
                                orderType: nil,
                                searchTerm: searchTerm
                            ) { account in
                                
                                loadingView(show: true)
                                
                                API.custAccountV1.load(id: .id(account.id)) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp else {
                                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
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
                                    
                                    let account = payload.custAcct
                                    
                                    self.custAcct = account
                                    
                                    self.facturar()
                                }
                                
                            }

                            self.appendChild(custDataView)
                            
                        }))
                }

                addToDom(view)
                
                return
            }
            
            guard let sale = self.custSale else {
                return
            }
            
            loadingView(show: true)
            
            let view = ToolFiscal(
                loadType: .sale(id: sale.id),
                folio: sale.folio,
                callback: { id, folio, pdf, xml in
                    
                    self.fiscalDocumentStatus = .paid
                    
                    self.fiscalDocumentID = id
                    
                    /*
                    self.fiscalDiv.innerHTML = ""
                    
                    let _folio = (folio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                        .replace(from: "/", to: "%2f")
                        .replace(from: "+", to: "%2b")
                        .replace(from: "=", to: "%3d")
                    
                    let _pdf = (pdf.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                        .replace(from: "/", to: "%2f")
                        .replace(from: "+", to: "%2b")
                        .replace(from: "=", to: "%3d")
                    
                    let _xml = (xml.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                        .replace(from: "/", to: "%2f")
                        .replace(from: "+", to: "%2b")
                        .replace(from: "=", to: "%3d")
                    
                    let pdfLink = pdfLinkString(folio: _folio, pdf: _pdf)
                    
                    let xmlLink = xmlLinkString(folio: _folio, xml: _xml)
                    
                    self.fiscalDiv.appendChild(Div {
                        
                        A{
                            Img()
                                .src("/skyline/media/pdf_icon.png")
                                .marginTop(18.px)
                                .height(55.px)
                        }
                        .href(pdfLink)
                        .margin(all: 7.px)
                        .onClick { _, event in
                            event.stopPropagation()
                        }
                        
                        A {
                            Img()
                                .src("/skyline/media/xml_icon.png")
                                .marginTop(18.px)
                                .height(55.px)
                        }
                        .href(xmlLink)
                        .margin(all: 7.px)
                        .onClick { _, event in
                            event.stopPropagation()
                        }
                        
                    })
                    */
                })
            
            view.reciver = .init(
                id: account.id,
                folio: account.folio,
                businessName: account.businessName,
                firstName: account.firstName,
                lastName: account.lastName,
                mcc: account.mcc,
                mobile: account.mobile,
                email: account.email,
                autoPaySpei: account.autoPaySpei,
                autoPayOxxo: account.autoPayOxxo,
                fiscalProfile: account.fiscalProfile,
                fiscalRazon: account.fiscalRazon,
                fiscalRfc: account.fiscalRfc,
                fiscalRegime: account.fiscalRegime,
                fiscalZip: account.fiscalZip,
                cfdiUse: account.cfdiUse,
                fiscalPOCFirstName: account.fiscalPOCFirstName,
                fiscalPOCLastName: account.fiscalPOCLastName,
                fmcc: account.fmcc,
                fiscalPOCMobile: account.fiscalPOCMobile,
                fiscalPOCMobileValidaded: account.fiscalPOCMailValidaded,
                fiscalPOCMail: account.fiscalPOCMail,
                fiscalPOCMailValidaded: account.fiscalPOCMailValidaded,
                crstatus: account.crstatus, 
                isConcessionaire: account.isConcessionaire
            )
            
            addToDom(view)
        }

        func sendSaleByMessage(){

            let view = ConfirmMobilePhone(term: self.custAcct?.mobile ?? "" ){ mobile in


                loadingView(show: true)

                guard let custSale = self.custSale  else {
                    showError(.errorGeneral, "No se localizo venta")
                    return
                }

                let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") +
                        "&ie=sendPDVSale" +
                        "&id=" + (custSale.id.uuidString) + 
                        "&firstName=CLIENTE" +
                        "&mobile=" + mobile

                let xhr = XMLHttpRequest()
                
                xhr.open(method: "POST", url: url)
                
                xhr.setRequestHeader("Accept", "application/json")
                    .setRequestHeader("Content-Type", "application/json")
                    .setRequestHeader("AppName", applicationName)
                    .setRequestHeader("AppVersion", SkylineWeb().version.description)
                
                if let jsonData = try? JSONEncoder().encode(APIHeader(
                    AppID: thisAppID,
                    AppToken: thisAppToken,
                    url: custCatchUrl,
                    user: custCatchUser,
                    mid: custCatchMid,
                    key: custCatchKey,
                    token: custCatchToken,
                    tcon: .web, 
                    applicationType: .customer
                )){
                    if let str = String(data: jsonData, encoding: .utf8) {
                        let utf8str = str.data(using: .utf8)
                        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                            xhr.setRequestHeader("Authorization", base64Encoded)
                        }
                    }
                }
                
                xhr.send()
                
                xhr.onError {
                    print("error")
                    print(xhr.responseText ?? "")
                }
                
                xhr.onLoad {

                    if let data = xhr.responseText?.data(using: .utf8) {

                        print("🟢  sendPDVSale")

                        print(String(data: data, encoding: .utf8) ?? "N/A")

                    }

                    /*
                    if let data = xhr.responseText?.data(using: .utf8) {
                        do {
                            let resp = try JSONDecoder().decode(MailAPIResponset<[MailBox]>.self, from: data)
                            callback(resp)
                        } catch  {
                            print("📩  📩  📩  📩  📩  📩  📩  \(#function)")
                            print(error)
                            print(xhr.responseText!)
                            callback(nil)
                        }
                    }
                    else{
                        callback(nil)
                    }
                    */

                    loadingView(show: false)

                    showSuccess(.operacionExitosa, "Enviado")
                    //showSuccess(.operacionExitosa, "Elemento Enviado")
                }
            

                

            }

        addToDom(view)
            

        }

    }
}
