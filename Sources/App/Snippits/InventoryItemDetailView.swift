//
//  InventoryItemDetailView.swift
//  
//
//  Created by Victor Cantu on 7/21/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class InventoryItemDetailView: Div {
    
    override class var name: String { "div" }
    
    @State var itemid: UUID
    
    
    private var priceChange: ((
        _ price: Int64
    ) -> ())
    
    
    init(
        itemid: UUID,
        priceChange: @escaping ( (
            _ price: Int64
        ) -> ())
    ) {
        self.itemid = itemid
        self.priceChange = priceChange
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var createdBy = ""
    
    @State var createdAt = ""
    
    @State var soldBy = ""
    
    @State var soldAt = ""
    
    @State var soldPrice: Int64? = nil
    
    @State var custAcctRefrence = ""
    
    @State var folioSoldRefrence = ""
    
    @State var prod: CustPOCInventory? = nil
    
    @State var newNote = ""
    
    @State var warenExtenrnal = "Sin Garantia"
    
    @State var warenInternal = "Sin Garantia"
    
    @State var relatedAccount = ""
    
    @State var relatedFolio = ""
    
    @State var locaition = ""
    
    @State var revenue = "--"
    
    lazy var newNoteField = InputText(self.$newNote)
        .custom("width","calc(100% - 150px)")
        .placeholder("Agergar comentario...")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var notesDiv = Div()
    
    @State var editPriceIsHidden = true
    
    @State var status: CustPOCInventoryStatus = .sold
    
    @State var newPrice = ""
    
    @State var changeReason = "Cambio por ajuste de migracion"
    
    lazy var newPriceField = InputText(self.$newPrice)
        .custom("width","calc(100% - 12px)")
        .placeholder("0.00")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var changeReasonField = InputText(self.$changeReason)
        .custom("width","calc(100% - 12px)")
        .placeholder("Agergar comentario...")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div {
            // Top Tools
            Div{
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.remove()
                    }
                
                /// Todo  create series and  suffix slot
                H2("Detalle del articulo \(self.itemid.suffix)")
                    .color(.lightBlueText)
            }
            .paddingBottom(3.px)
            
            Div{
                Div{
                    Label("Creado")
                    Div(self.$createdAt)
                        .class(.oneLineText)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div().class(.clear)
                
                Div{
                    Label("Creador")
                    Div(self.$createdBy)
                        .class(.oneLineText)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div().class(.clear)
                
                Div{
                    Label("Cuenta Rel")
                    Div(self.$relatedAccount)
                        .class(.oneLineText)
                        .minHeight(32.px)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div().class(.clear)
                
                Div{
                    Label("Garantia Interna")
                    Div(self.$warenInternal)
                        .class(.oneLineText)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div().class(.clear)
                
                Div{
                    Label("Factura")
                    Div(self.$prod.map{ $0?.facturaDeCompra?.uuidString ?? "" })
                        .cursor(self.$prod.map{ $0?.facturaDeCompra == nil ? .default : .pointer})
                        .class(.oneLineText)
                        .minHeight(32.px)
                        .fontSize(23.px)
                        .color(.yellowTC)
                        .onClick {
                            
                            guard let docid = self.prod?.facturaDeCompra else {
                                return
                            }
                            
                            loadingView(show: true)
                            
                            API.fiscalV1.getFiscaXMLIngreso(id: docid) { resp in
                                
                                loadingView(show: false)
                                
                                guard let resp = resp else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }
                                
                                guard resp.status == .ok else {
                                    showError(.errorGeneral, resp.msg)
                                    return
                                }
                                
                                guard let doc = resp.data else {
                                    showError(.errorGeneral, resp.msg)
                                    return
                                }

                                addToDom(ToolViewFiscalXMLDocument(doc: doc))
                                
                            }
                        }
                }
                .class(.section)
            }
            .width(50.percent)
            .float(.left)
            
            Div{
                Div{
                    Label("Vendido")
                    Div(self.$soldAt)
                        .class(.oneLineText)
                        .minHeight(32.px)
                        .fontSize(18.px)
                        .color(.white)
                }
                .class(.section)
                Div().class(.clear)
                
                Div{
                    Label("Vendedor")
                    Div(self.$soldBy)
                        .class(.oneLineText)
                        .minHeight(32.px)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div().class(.clear)
                
                Div{
                    Label("Folio Rel")
                    Div(self.$relatedFolio)
                        .class(.oneLineText)
                        .minHeight(32.px)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div().class(.clear)
                
                Div{
                    Label("Garantia Externa")
                    Div(self.$warenExtenrnal)
                        .class(.oneLineText)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
                
                Div{
                    Label("Ubicacion")
                    Div(self.$locaition)
                        .class(.oneLineText)
                        .fontSize(23.px)
                        .color(.white)
                }
                .class(.section)
            }
            .width(50.percent)
            .float(.left)
            
            Div().clear(.both)
            
            Div{
                Div{
                    Label("Costo")
                        .color(.gray)
                    Div(self.$prod.map{ $0?.cost.formatMoney ?? "--" })
                        .class(.oneLineText)
                        .fontSize(20.px)
                        .color(.white)
                }
                .width(20.percent)
                .float(.left)
                Div{
                    
                    
                    Label("Venta")
                        .color(.gray)
                    
                    if custCatchHerk >= 4 {
                        
                        Img()
                            .src("/skyline/media/pencil.png")
                            .hidden(self.$status.map{ $0 != .inConcession })
                            .marginLeft(7.px)
                            .cursor(.pointer)
                            .height(16.px)
                            .onClick {
                                self.editPriceIsHidden = false
                                self.newPriceField.select()
                            }
                        
                    }
                    
                    Div().clear(.both)
                    
                    Div(self.$soldPrice.map{ $0?.formatMoney ?? "" })
                        .class(.oneLineText)
                        .fontSize(20.px)
                        .color(.white)
                }
                .width(20.percent)
                .float(.left)
                Div{
                    Label("Comision")
                        .color(.gray)
                    Div(self.$prod.map{ $0?.comision.formatMoney ?? "--" })
                        .class(.oneLineText)
                        .fontSize(20.px)
                        .color(.white)
                }
                .width(20.percent)
                .float(.left)
                Div{
                    Label("Siwe")
                        .color(.gray)
                    Div(self.$prod.map { $0?.premierPoints.formatMoney ?? "--" })
                        .class(.oneLineText)
                        .fontSize(20.px)
                        .color(.white)
                }
                .width(20.percent)
                .float(.left)
                Div{
                    Label("Ganacia")
                        .color(.gray)
                    Div(self.$revenue)
                        .class(.oneLineText)
                        .fontSize(20.px)
                        .color(.white)
                }
                .width(20.percent)
                .float(.left)
                
            }
            
            Div().clear(.both).height(7.px)
            
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
        .custom("left", "calc(50% - 300px)")
        .custom("top", "calc(50% - 350px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(686.px)
        .width(586.px)
        
        Div{
            
            Div {
                
                Div{
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.editPriceIsHidden = true
                        }
                    
                    H2("Editar precio")
                        .color(.lightBlueText)
                    
                    Div{
                        
                        Div{
                            Span("Nuevo Precio")
                                .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.newPriceField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    
                    Div().clear(.both).height(7.px)
                    
                    Span("Motivo del cambio")
                        .color(.white)
                    
                    Div().clear(.both).height(3.px)
                    
                    self.changeReasonField
                    
                    Div().clear(.both).height(7.px)
                    
                    Div{
                        Div("Cambiar Precio")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                self.changePrice()
                            }
                    }
                    .align(.right)
                }
                .paddingBottom(3.px)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 200px)")
            .custom("top", "calc(50% - 150px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(400.px)
        }
        .class(.transparantBlackBackGround)
        .hidden(self.$editPriceIsHidden)
        .height(100.percent)
        .position(.absolute)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
            
        loadingView(show: true)
        
        API.custAPIV1.pocInventoryDetails(id: itemid) { resp in
            
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
                print("🔴  no paylod")
                return
            }
            
            let item = payload.prod
            
            if let _ = item.soldBy {
                
                self.revenue = ((item.soldPrice ?? 0) - item.cost - item.comision - item.premierPoints).formatMoney
                
            }
            
            self.prod = item
            
            self.soldPrice = item.soldPrice
            
            self.newPrice = item.soldPrice?.formatMoney ?? ""
            
            self.status = item.status
            
            self.relatedAccount = payload.custAcctRefrence
            
            self.relatedFolio = payload.folioSoldRefrence
            
            self.createdAt = getDate(item.createdAt).formatedLong
            
            if let createdBy = item.createdBy {
                
                getUserRefrence(id: .id(createdBy)) { user in
                    if let user {
                        print()
                        self.createdBy = "@" + (user.username.explode("@").first ?? "")
                    }
                }
                
            }
            
            if let _soldAt = item.soldAt {
                self.soldAt = getDate(_soldAt).formatedLong
            }
            
            if let userid = item.soldBy {
                getUserRefrence(id: .id(userid)) { user in
                    if let user  {
                        self.soldBy = "@" + (user.username.explode("@").first ?? "")
                    }
                }
            }
            
            if let warentSelfTo = item.warentSelfTo {
                self.warenInternal = getDate(warentSelfTo).formatedLong
            }
            
            if let warentFabricTo = item.warentFabricTo {
                self.warenExtenrnal = getDate(warentFabricTo).formatedLong
            }
            
            payload.notes.forEach { note in
                   
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
            
            if let bodid = payload.prod.custStoreBodegas {
                if let name = bodegas[bodid] {
                    self.locaition = name.name
                }
            }
            
            if let secid = payload.prod.custStoreSecciones {
                if let name = seccions[secid] {
                    self.locaition += "/\(name.name)"
                }
            }
            
        }
    }
    
    func addNote(){
        
        let note = self.newNote.purgeSpaces.purgeHtml
        
        if note.isEmpty {
            newNoteField.select()
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.addInventoryItemNote(itemid: itemid, note: note) { resp in
            
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
    
    func changePrice(){
         
        guard let price = Double(newPrice)?.toCents else {
            showError(.errorGeneral, "Ingrese un nuevo precio valido")
            newPriceField.select()
            return
        }
        
        if changeReason.isEmpty {
            showError(.errorGeneral, "Ingrese motivo del cambio")
            changeReasonField.select()
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.changePriceInConcesion(
            itemId: self.itemid,
            newPrice: price,
            reason: changeReason
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let _ = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.changeReason = ""
            
            self.editPriceIsHidden = true
            
            self.soldPrice = price
            
            self.priceChange(price)
            
        }
    }
}
