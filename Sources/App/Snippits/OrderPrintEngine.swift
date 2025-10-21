//
//  OrderPrintEngine.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

class OrderPrintEngine: Div {
    
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
    
    lazy var qrInternal = Div()
        .marginBottom(7.px)
        .marginTop(12.px)
        .id(Id(stringLiteral: "qrInternal"))
    
    lazy var qrCustomer = Div()
        .marginBottom(7.px)
        .marginTop(12.px)
        .id(Id(stringLiteral: "qrCustomer"))
    
    lazy var orderImg = Img()
    
    lazy var chargesOne = Table{
        Tr{
            Td("Unis").width(50.px)
            Td("Description")
            Td("CUni").width(70.px)
            Td("STotal").width(70.px)
        }
    }.width(100.percent)
    
    lazy var chargesTwo = Table{
        Tr{
            Td("Unis").width(50.px)
            Td("Description")
            Td("CUni").width(70.px)
            Td("STotal").width(70.px)
        }
    }.width(100.percent)
    
    lazy var equipmetsDataOne: Div = .init()
    lazy var equipmetsDataTwo: Div = .init()
    
    lazy var storeData = Div{
        Strong("Orden de Trabajo")
            .fontSize(16.px)
    }
    
    var logo = "/skyline/media/logoTierraCeroLongBlack.svg"
    
    var createdAt = ""
    var dueAt = ""
    
    var fontSize = 12.px
    
    @DOM override var body: DOM.Content {
        
        switch configStore.print.document {
        case .letter:
            Div {
                Table {
                    /// LOGO and DATA
                    Tr{
                        Td{
                            Img()
                                .src(self.logo)
                                .maxWidth(200.px)
                                .maxHeight(70.px)
                        }
                        .align(.left)
                        .width(33.percent)
                        /// INFO
                        Td{
                            Strong(self.order.folio)
                        }
                        .align(.center)
                        .fontSize(42.px)
                        .width(33.percent)
                        /// DATE / DUE
                        Td{
                            self.dateViewOne
                        }
                        .width(33.percent)
                    }
                    ///
                    Tr{
                        Td{
                            Strong(self.order.name)
                        }.colSpan(2)
                        Td{
                            
                            self.qrInternal
                            
                            Div{
                                self.orderImg
                                
                                    .marginTop(7.px)
                                    .height(170.px)
                            }
                            .align(.center)
                            
                            
                            Div()
                                .borderBottom(width: .thin, style: .solid, color: .black)
                                .marginTop(24.px)
                                .marginBottom(12.px)
                            
                            Div("Firma de Conformidad")
                                .align(.center)
                            
                            Div()
                                .borderBottom(width: .thin, style: .solid, color: .black)
                                .marginTop(24.px)
                                .marginBottom(12.px)
                            
                            Div("Firma de Recibido")
                                .align(.center)
                            
                        }
                        .rowSpan(4)
                        .align(.center)
                        
                    }
                    ///
                    Tr{
                        Td{
                            if !self.order.street.isEmpty || !self.order.colony.isEmpty || !self.order.city.isEmpty {
                                Span("\(self.order.street) \(self.order.colony) \(self.order.city) ")
                            }
                            if !self.order.mobile.isEmpty {
                                 Span(" Celular: ")
                                Strong(self.order.mobile)
                            }
                            if !self.order.email.isEmpty {
                                Span(" Correo: ")
                                Strong(self.order.email)
                            }
                            if !self.order.telephone.isEmpty {
                                Span(" Telefono: ")
                                Strong(self.order.telephone)
                            }
                            
                            Br()
                            
                            self.equipmetsDataOne
                            
                            self.chargesOne
                            
                            Div{
                                Span(configGeneral.docuWelcome)
                                Br()
                                Span("Acuerdo de privacidad en \(customerServiceProfile?.account.url ?? "")/privacidad.")
                            }
                            .fontSize(self.fontSize)
                            
                        }
                        .rowSpan(2)
                        .colSpan(2)
                    }
                }
                .width(100.percent)
            }
            .height(470.px)
            .overflowX(.hidden)
            
            self.lineBreak
            
            Div {
                Table {
                    /// LOGO and DATA
                    Tr{
                        Td{
                            Img()
                                .src(self.logo)
                                .maxWidth(200.px)
                                .maxHeight(70.px)
                        }
                        .align(.left)
                        .width(33.percent)
                        /// INFO
                        Td{
                            self.storeData
                        }
                        .align(.center)
                        .fontSize(42.px)
                        .width(33.percent)
                        /// DATE / DUE
                        Td{
                            Strong {
                                Div("FOLIO: ")
                                .fontSize(24.px)
                                Div(self.order.folio)
                                .fontSize(36.px)
                            }
                        }
                        .width(33.percent)
                    }
                    ///
                    Tr{
                        Td{
                            Strong(self.order.name)
                        }.colSpan(2)
                        Td{
                            
                            self.dateViewTwo
                            
                            self.qrCustomer
                            
                        }
                        .rowSpan(4)
                        .align(.center)
                    }
                    ///
                    Tr{
                        Td{
                            if !self.order.street.isEmpty || !self.order.colony.isEmpty || !self.order.city.isEmpty {
                                Span("\(self.order.street) \(self.order.colony) \(self.order.city) ")
                            }
                            if !self.order.mobile.isEmpty {
                                Span(" Celular: ")
                                Strong(self.order.mobile)
                            }
                            if !self.order.email.isEmpty {
                                Span(" Correo: ")
                                Strong(self.order.email)
                            }
                            if !self.order.telephone.isEmpty {
                                Span(" Telefono: ")
                                Strong(self.order.telephone)
                            }
                            
                            Br()
                            
                            self.equipmetsDataTwo
                            
                            self.chargesTwo
                            
                            Div{
                                Span(configGeneral.docuWelcome)
                                Br()
                                Span("Acuerdo de privacidad en \(customerServiceProfile?.account.url ?? "")/privacidad.")
                            }
                            .fontSize(self.fontSize)
                            
                        }
                        .rowSpan(2)
                        .colSpan(2)
                    }
                }
                .width(100.percent)
            }
            .height(470.px)
            .overflowX(.hidden)
            
        case .halfLetter:
            H1("Documento no soportado")
        case .miniprinter:
            Div{
                
                Div{
                    Img()
                        .src(self.logo)
                        .maxWidth(200.px)
                        .maxHeight(70.px)
                    
                    self.storeData
                    
                }
                .align(.center)
                
                Div{
                    Strong {
                        Div(self.order.folio)
                            .fontSize(28.px)
                    }
                }
                .align(.center)
                .marginBottom(7.px)
                .marginTop(7.px)
                
                if !self.order.street.isEmpty || !self.order.colony.isEmpty || !self.order.city.isEmpty {
                    Span("\(self.order.street) \(self.order.colony) \(self.order.city) ")
                }
                
                if !self.order.mobile.isEmpty {
                    Span(" Celular: ")
                    Strong(self.order.mobile)
                }
                
                if !self.order.email.isEmpty {
                    Span(" Correo: ")
                    Strong(self.order.email)
                }
                
                if !self.order.telephone.isEmpty {
                    Span(" Telefono: ")
                    Strong(self.order.telephone)
                }
                
                Br()
                
                self.equipmetsDataOne
                
                self.chargesOne
                
                self.qrInternal
                    .display(.none)
                
                self.qrCustomer
                    .align(.center)
                
                Div{
                    self.orderImg    
                }
                .align(.center)
                
                Div{
                    Span(configGeneral.docuWelcome)
                    Br()
                    Span("Acuerdo de privacidad en \(customerServiceProfile?.account.url ?? "")/privacidad.")
                }
                .fontSize(13.px)
                
                Div()
                    .borderBottom(width: .thin, style: .solid, color: .black)
                    .marginTop(24.px)
                    .marginBottom(12.px)
                
                Div("Firma de Conformidad")
                    .align(.center)
                
                Div()
                    .borderBottom(width: .thin, style: .solid, color: .black)
                    .marginTop(24.px)
                    .marginBottom(12.px)
                
                Div("Firma de Recibido")
                    .align(.center)
                
                
            }.width(300.px)
        case .pdf:
            H1("Documento no soportado")
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        do {
           let data = try JSONEncoder().encode(configStore)
            
            if let str = String(data: data, encoding: .utf8) {
                print("🤩  ⭐️  🤩  ⭐️  🤩  ⭐️  🤩  ⭐️  🤩  ⭐️  🤩  ⭐️  🤩  ⭐️  🤩  ⭐️  🤩")
                print(str)
            }
            
        }
        catch { }
        
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
                Strong("Equipo \(cc): \(eq.IDTag1) ")
                Span("\(tag1) \(tag2) \(tag3) \(tag4) ").marginLeft(3.px)
                Br()
                Span(configServiceTags.tagDescrName)
                Span(eq.tagDescr).marginLeft(3.px)
                Br()
            }
            
            var eqObjTwo = Div {
                Strong("Equipo \(cc): \(eq.IDTag1) ")
                Span("\(tag1) \(tag2) \(tag3) \(tag4) ").marginLeft(3.px)
                Br()
                Span(configServiceTags.tagDescrName)
                Span(eq.tagDescr).marginLeft(3.px)
                Br()
            }
            
            if(configGeneral.docuWelcome.count > 1000 && configGeneral.docuWelcome.count < 1801){
                eqObjOne = Div {
                    Strong("Equipo \(cc): \(eq.IDTag1.suffix(6)) ")
                    Span("\(eq.tag1) \(eq.tag2) \(eq.tag3) \(eq.tag4) ").marginLeft(3.px)
                    Br()
                    Span(configServiceTags.tagDescrName)
                    Span(eq.tagDescr).marginLeft(3.px)
                    Br()
                }
                
                eqObjTwo = Div {
                        Strong("Equipo \(cc): \(eq.IDTag1.suffix(6)) ")
                        Span("\(eq.tag1) \(eq.tag2) \(eq.tag3) \(eq.tag4) ").marginLeft(3.px)
                        Br()
                        Span(configServiceTags.tagDescrName)
                        Span(eq.tagDescr).marginLeft(3.px)
                    Br()
                }
            }
            else if(configGeneral.docuWelcome.count > 1800){
                eqObjOne = Div {
                    Strong("\(cc):  \(eq.IDTag1.suffix(4)) ")
                    Span("\(eq.tag1) \(eq.tag2) \(eq.tag3) \(eq.tag4) ").marginLeft(3.px)
                    Span(eq.tagDescr).marginLeft(3.px)
                    Br()
                }
            }
            
            if configServiceTags.checkTag1 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag1Name): \(eq.tagCheck1 ? "SI" : "NO")").marginLeft(3.px))
                eqObjTwo.appendChild(Span("\(configServiceTags.checkTag1Name): \(eq.tagCheck1 ? "SI" : "NO")").marginLeft(3.px))
            }
            
            if configServiceTags.checkTag2 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag2Name): \(eq.tagCheck2 ? "SI" : "NO")").marginLeft(3.px))
                eqObjTwo.appendChild(Span("\(configServiceTags.checkTag2Name): \(eq.tagCheck2 ? "SI" : "NO")").marginLeft(3.px))
            }
            
            if configServiceTags.checkTag3 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag3Name): \(eq.tagCheck3 ? "SI" : "NO")").marginLeft(3.px))
                eqObjTwo.appendChild(Span("\(configServiceTags.checkTag3Name): \(eq.tagCheck3 ? "SI" : "NO")").marginLeft(3.px))
            }
            if configServiceTags.checkTag4 {
                eqObjOne.appendChild(Span("\(configServiceTags.checkTag4Name): \(eq.tagCheck4 ? "SI" : "NO")").marginLeft(3.px))
                eqObjTwo.appendChild(Span("\(configServiceTags.checkTag4Name): \(eq.tagCheck4 ? "SI" : "NO")").marginLeft(3.px))            }
            
            cc += 1
            
            equipmetsDataOne.appendChild(eqObjOne)
            equipmetsDataTwo.appendChild(eqObjTwo)
            
        }
        
        if charges.isEmpty && pocs.isEmpty && payments.isEmpty {
            chargesOne.appendChild(
                Tr{
                    Td("Sin cargos o pagos actuales")
                        .colSpan(4)

                }
            )
            chargesTwo.appendChild(
                Tr{
                    Td("Sin cargos o pagos actuales")
                        .colSpan(4)

                }
            )
        }
        else {
            
            charges.forEach { obj in
                let stotal = ((obj.price * obj.cuant) / 100)
                total += stotal
                chargesOne.appendChild(
                    Tr{
                        Td(obj.cuant.fromCents.toString)
                        Td(obj.name)
                        Td(obj.price.formatMoney)
                        Td(stotal.formatMoney)
                    }
                )
                chargesTwo.appendChild(
                    Tr{
                        Td(obj.cuant.fromCents.toString)
                        Td(obj.name)
                        Td(obj.price.formatMoney)
                        Td(stotal.formatMoney)
                    }
                )
            }
            
            pocs.forEach { obj in
                let soldPrice = obj.soldPrice ?? 0
                total += soldPrice
                chargesOne.appendChild(
                    Tr{
                        Td("1")
                        Td("\(obj.name) \(obj.model)")
                        Td(soldPrice.fromCents.toString)
                        Td(soldPrice.formatMoney)
                    }
                )
                chargesTwo.appendChild(
                    Tr{
                        Td("1")
                        Td("\(obj.name) \(obj.model)")
                        Td(soldPrice.fromCents.toString)
                        Td(soldPrice.formatMoney)
                    }
                )
            }
            
            payments.forEach { obj in
                total -= obj.cost
                chargesOne.appendChild(
                    Tr{
                        Td("1")
                        Td(obj.description)
                        Td(obj.cost.fromCents.toString)
                        Td(obj.cost.formatMoney)
                    }
                )
                chargesTwo.appendChild(
                    Tr{
                        Td("1")
                        Td(obj.description)
                        Td(obj.cost.fromCents.toString)
                        Td(obj.cost.formatMoney)
                    }
                )
            }
            
            chargesOne.appendChild(
                Tr{
                    Td()
                    Td()
                    Td("Balance")
                    Td(total.formatMoney)
                }
            )
            
            chargesTwo.appendChild(
                Tr{
                    Td()
                    Td()
                    Td("Balance")
                    Td(total.formatMoney)
                }
            )
            
        }
        
        for _ in 0...configStore.print.lineBreak {
            lineBreak.appendChild(Br())
        }
        
        switch configStore.print.image {
        case .none:
            self.orderImg.hidden(true)
        case .pinpattern:
            self.orderImg.src("https://tierracero.com/dev/core/images/pimg-PatronPIN.jpg")
        case .location:
            self.orderImg.hidden(true)
        }
        
        if let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
            if !_logo.isEmpty {
                logo = "https://\(custCatchUrl)/contenido/\(_logo)"
            }
        }
        
        if let dueDate = order.dueDate {
            
            let _dd = getDate(dueDate)
            dateViewOne.appendChild(
                Div{
                    
                    Strong(configServiceTags.typeOfServiceObject.dateTag)
                        .color(.lightGray)
                        .marginLeft(7.px)
                    
                    Strong(_dd.formatedShort)
                    
                }.align(.left)
            )
            dateViewTwo.appendChild(
                Div{
                    
                    Strong(configServiceTags.typeOfServiceObject.dateTag)
                        .color(.lightGray)
                        .marginLeft(7.px)
                    
                    Strong(_dd.formatedShort)
                    
                }.align(.left)
            )
        }
        
        let createdAt = getDate(order.createdAt)
        dateViewOne.appendChild(
            Div{
                
                Strong("Creado")
                    .color(.lightGray)
                    .marginLeft(7.px)
                
                Strong(createdAt.formatedShort)
                
            }.align(.left)
        )
        dateViewTwo.appendChild(
            Div{
                
                Strong("Creado")
                    .color(.lightGray)
                    .marginLeft(7.px)
                
                Strong(createdAt.formatedShort)
                
            }.align(.left)
        )
        
        if( configGeneral.docuWelcome.count > 1000 && configGeneral.docuWelcome.count < 1801 ) {
            fontSize = 10.px
        }
        else if(configGeneral.docuWelcome.count > 1800) {
            fontSize =  8.px
        }
        else {
            fontSize =  12.px
        }
        
        if let cstore = order.store {
            
            stores.forEach {  id, store in
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
