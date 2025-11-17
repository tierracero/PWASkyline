//
//  OrderPrintServiceLeterEngine.swift
//
//
//  Created by Victor Cantu on 10/26/24.
//

import Foundation
import TCFundamentals
import Web

class OrderPrintServiceLeterEngine: Div {
    
    var order: CustOrderLoadFolioDetails
    var notes: [CustOrderLoadFolioNotes]
    var payments: [CustOrderLoadFolioPayments]
    var charges: [CustOrderLoadFolioCharges]
    var pocs: [CustPOCInventoryOrderView]
    var files: [CustOrderLoadFolioFiles]
    var equipments: [CustOrderLoadFolioEquipments]
    var rentals: [CustPOCRentalsMin]
    var transferOrder: CustTranferManager?
    
    init(
        order: CustOrderLoadFolioDetails,
        notes: [CustOrderLoadFolioNotes],
        payments: [CustOrderLoadFolioPayments],
        charges: [CustOrderLoadFolioCharges],
        pocs: [CustPOCInventoryOrderView],
        files: [CustOrderLoadFolioFiles],
        equipments: [CustOrderLoadFolioEquipments],
        rentals: [CustPOCRentalsMin],
        transferOrder: CustTranferManager?
    ) {
        self.order = order
        self.notes = notes
        self.payments = payments
        self.charges = charges
        self.pocs = pocs
        self.files = files
        self.equipments = equipments
        self.rentals = rentals
        self.transferOrder = transferOrder
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    
    override class var name: String { "div" }
    
    lazy var lineBreak = Div()
    
    lazy var dateViewOne = Div()
    lazy var dateViewTwo = Div()
    
    lazy var orderImg = Img()
    
    lazy var chargesData = Table{
        Tr{
            Td("Unis").width(50.px)
            Td("Description")
            Td("CUni").width(70.px)
            Td("STotal").width(70.px)
        }
    }.width(100.percent)
    
    lazy var equipmetsDataOne: Div = .init()
    
    lazy var storeData = Div{
        
        Strong("Orden de Trabajo")
            .fontSize(16.px)
        
        Div().clear(.both).height(3.px)
        
    }
    
    var logo = "/skyline/media/logoTierraCeroLongBlack.svg"
    
    var dueAt = ""
    
    var closedAt = ""
    
    var fontSize = 12.px
    
    @DOM override var body: DOM.Content {
        
        switch configStore.print.document {
        case .letter:
            
            /// LOGO and DATA
            Div{
                Div{
                    Img()
                        .src(self.logo)
                        .maxWidth(200.px)
                        .maxHeight(70.px)
                }
                .width(33.percent)
                .float(.left)
            
                self.storeData
                .width(33.percent)
                .float(.left)
            
                Div{
                    Strong {
                        Div("FOLIO: ")
                        .fontSize(24.px)
                        Div(self.order.folio)
                        .fontSize(36.px)
                    }
                }
                .width(33.percent)
                .float(.left)
            }
            
            Div().clear(.both).height(7.px)
            
            Div{
                Table{
                    Tr{
                        Td("Nombre del Cliente")
                        Td(self.order.name)
                            .colSpan(3)
                    }
                    
                    if !self.order.street.isEmpty || !self.order.colony.isEmpty || !self.order.city.isEmpty || !self.order.state.isEmpty {
                        Tr{
                            Td("Direccion:")
                            Td("\(self.order.street) \(self.order.colony) \(self.order.city) \(self.order.state)")
                                .colSpan(3)
                        }
                    }
                    
                    Tr{
                        Td("Creado en")
                            .width(25.percent)
                        Td(getDate(self.order.createdAt).formatedLong)
                            .width(25.percent)
                        Td("Finalizado")
                            .width(25.percent)
                        Td(self.closedAt)
                            .width(25.percent)
                    }
                    
                    
                }
                .width(100.percent)
            }
            
            Div().clear(.both).height(7.px)
            
            self.equipmetsDataOne
            
            Div().clear(.both).height(7.px)
            
            Div {
                Table {
                    Tr{
                        Td{
                            self.chargesData
                        }
                        .colSpan(3)
                    }
                }
                .width(100.percent)
            }
            
        case .halfLetter:
            H1("Documento no soportado")
        case .miniprinter:
            H1("Documento no soportado")
        case .pdf:
            H1("Documento no soportado")
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        var cc = 1
        
        var total: Int64 = 0
        
        equipments.forEach { eq in
            
            var tag1 = ""
            var tag2 = ""
            var tag3 = ""
            var tag4 = ""
            
            if !eq.tag1.isEmpty { tag1 = "\(configServiceTags.tag1Name) \(eq.tag1)" }
            if !eq.tag2.isEmpty { tag2 = " \(configServiceTags.tag2Name) \(eq.tag2)" }
            if !eq.tag3.isEmpty { tag3 = " \(configServiceTags.tag3Name) \(eq.tag3)" }
            if !eq.tag3.isEmpty { tag4 = " \(configServiceTags.tag4Name) \(eq.tag4)" }
            
            var eqObjOne = Div {
                Strong("Equipo \(cc):")
                Span("\(tag1) \(tag2) \(tag3) \(tag4) ").marginLeft(3.px)
                Br()
                Span(configServiceTags.tagDescrName)
                Span(eq.tagDescr).marginLeft(3.px)
                Br()
            }

            if(configGeneral.docuWelcome.count > 1000 && configGeneral.docuWelcome.count < 1801){
                
                eqObjOne = Div {
                    Strong("Equipo \(cc):")
                    Span("\(eq.tag1) \(eq.tag2) \(eq.tag3) \(eq.tag4) ").marginLeft(3.px)
                    Br()
                    Span(configServiceTags.tagDescrName)
                    Span(eq.tagDescr).marginLeft(3.px)
                    Br()
                }
                
            }
            else if(configGeneral.docuWelcome.count > 1800){
                eqObjOne = Div {
                    Strong("\(cc):")
                    Span("\(eq.tag1) \(eq.tag2) \(eq.tag3) \(eq.tag4) ").marginLeft(3.px)
                    Span(eq.tagDescr).marginLeft(3.px)
                    Br()
                }
            }
            
            if configServiceTags.checkTag1 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag1Name): \(eq.tagCheck1 ? "SI" : "NO")").marginLeft(3.px))
            }
            
            if configServiceTags.checkTag2 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag2Name): \(eq.tagCheck2 ? "SI" : "NO")").marginLeft(3.px))
            }
            
            if configServiceTags.checkTag3 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag3Name): \(eq.tagCheck3 ? "SI" : "NO")").marginLeft(3.px))
            }
            
            if configServiceTags.checkTag4 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag4Name): \(eq.tagCheck4 ? "SI" : "NO")").marginLeft(3.px))
            }
            
            cc += 1
            
            equipmetsDataOne.appendChild(eqObjOne)
            
            
        }
        
        charges.forEach { obj in
            let stotal = ((obj.price * obj.cuant) / 100)
            total += stotal
            
            chargesData.appendChild(
                Tr{
                    Td(obj.cuant.fromCents.toString)
                    Td(obj.name)
                    Td(obj.price.formatMoney)
                    Td(stotal.formatMoney)
                }
            )
        }
        
        var pocsRefrence: [UUID: [Int64 : [CustPOCInventoryOrderView]]] = [:]
        
        pocs.forEach { obj in
            
            if let _ = pocsRefrence[obj.pocId] {
                
                if let _ = pocsRefrence[obj.pocId]?[obj.soldPrice] {
                    pocsRefrence[obj.pocId]?[obj.soldPrice]?.append(obj)
                }
                else {
                    pocsRefrence[obj.pocId]?[obj.soldPrice] = [obj]
                }
                
            }
            else {
                pocsRefrence[obj.pocId] = [obj.soldPrice : [obj]]
            }
            
        }
        
        pocsRefrence.forEach { pocId, priceRefrence in
        
            priceRefrence.forEach { price, items in
            
                let soldPrice = price * items.count.toInt64
                
                total += soldPrice
                
                items.first
                
                chargesData.appendChild(
                    Tr{
                        Td(items.count.toString)
                        Td("\(items.first?.name ?? "N/A") \(items.first?.model ?? "N/A")")
                        Td(price.fromCents.toString)
                        Td(soldPrice.formatMoney)
                    }
                )
                
            }
            
        }
        
        payments.forEach { obj in
            
            total -= obj.cost
            
            chargesData.appendChild(
                Tr{
                    Td("1")
                    Td(obj.description)
                    Td(obj.cost.fromCents.toString)
                    Td(obj.cost.formatMoney)
                }
            )
        }
        
        chargesData.appendChild(
            Tr{
                Td(" ")
                Td(" ")
                Td("TOTAL")
                Td(total.formatMoney)
            }
        )
        
        if let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
            if !_logo.isEmpty {
                logo = "https://\(custCatchUrl)/contenido/\(_logo)"
            }
        }
        
        
        
        let createdAt = getDate(order.createdAt)
        
        if let closedAt = order.closedAt {
            self.closedAt = getDate(closedAt).formatedLong
        }
        
        dateViewOne.appendChild(
            Div{
                
                Strong("Creado")
                    .color(.lightGray)
                    .marginLeft(7.px)
                
                Strong(createdAt.formatedShort)
                
            }.align(.left)
        )
        
        if let cstore = order.store {
            
            stores.forEach { id, store in
                
                if cstore == id {
                    
                    self.storeData.appendChild(
                        Small {
                            
                            Span("SUC:").marginRight(3.px)
                            Strong(store.name).marginRight(3.px)
                            Span(store.telephone).marginRight(3.px)
                            Br()
                            Span(store.street).marginRight(3.px)
                            Span(store.colony).marginRight(3.px)
                            Span(store.city).marginRight(3.px)
                            Br()
                            Span(store.schedulea).marginRight(3.px)
                            Span(store.scheduleb).marginRight(3.px)
                            Span(store.schedulec).marginRight(3.px)
                            Br()
                        }
                            .fontSize(12.px)
                    )
                    
                }
                
            }
        }
        
        
        
    }
}
