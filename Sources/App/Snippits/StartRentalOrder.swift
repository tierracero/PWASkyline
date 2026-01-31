//
//  StartRentalOrder.swift
//  
//
//  Created by Victor Cantu on 6/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class StartRentalOrder: Div {
    
    override class var name: String { "div" }
    
    var currentUsedIDs: [UUID] = []
    
    @State var currentRentals: [RentalObjectRefrence] = []
    @State var selectedDateStamp = ""
    @State var selctedDate = "FECHA"
    @State var balanceString = "0.00"
    @State var uts: Double = 0
    @State var highPriority: Bool = false
    
    var dueAt: Double = 0
    var startAt: Double = 0
    var endAt: Double = 0
    var firstName: String = ""
    var lastName: String = ""
    var mobile: String = ""
    var telephone: String = ""
    var street: String = ""
    var colony: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var zip: String = ""
    
    var isAddingProduct = false
    
    let custAcct: CustAcctSearch
    private var callback: ((_ id: UUID) -> ())
    
    init(
        custAcct: CustAcctSearch,
        callback: @escaping ((_ id: UUID) -> ())
    ) {
        self.custAcct = custAcct
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var itemGrid = Table {
        Tr {
            Td().width(50)
            Td().width(50)
            Td("Nombre")
            Td("Units").width(100)
            Td("C. Uni").width(100)
            Td("S. Total").width(100)
        }
    }
    .width(100.percent)
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.view)
                .onClick{
                    if self.currentRentals.isEmpty {
                        //SkylineApp.current.$keyUp.removeAllListeners()
                        self.remove()
                    }
                    else {
                        self.appendChild(ConfirmView(
                            type: .yesNo,
                            title: "Confirme Salida",
                            message: "¿Quiere salir? Se perderan todos los datos.",
                            callback: { resp, _ in
                                if resp {
                                    //SkylineApp.current.$keyUp.removeAllListeners()
                                    self.remove()
                                }
                            })
                        )
                    }
                }
            
            H2("Orden de Renta")
                .color(.lightBlueText)
            
            Div().class(.clear)
            
            Div{
                
                Label("Cuenta")
                    .color(.gray)
                    .fontSize(16.px)
                
                Div().class(.clear)
                
                Strong(self.custAcct.folio)
                
                Div().class(.clear)
                
                Label("Tipo de Cuenta")
                    .color(.gray)
                    .fontSize(16.px)
                
                Div().class(.clear)
                
                Strong("\(self.custAcct.type.description) \\ \(self.custAcct.costType.description)")
                
            }
            .height(110.px)
            .fontSize(22.px)
            .class(.oneThird)
            
            Div{
                
                Label("Nombre del Clientes")
                    .color(.gray)
                    .fontSize(16.px)
                
                Div().class(.clear)
                
                Strong("\(self.custAcct.firstName) \(self.custAcct.lastName)")
                
                Div().class(.clear)
                
                Label("Telefono / Correo")
                    .color(.gray)
                    .fontSize(16.px)
                
                Div().class(.clear)
                
                Strong("\(self.custAcct.mobile) \(self.custAcct.email)")
                
            }
            .height(110.px)
            .fontSize(22.px)
            .class(.oneThird)
            
            Div{
                if self.custAcct.type != .personal {
                    
                    Label("Datos de la empresa")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Strong(self.custAcct.businessName)
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Strong(self.custAcct.fiscalRazon)
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Strong(self.custAcct.fiscalRfc)
                    
                }
            }
            .height(110.px)
            .fontSize(22.px)
            .class(.oneThird)
            
            Div()
                .class(.clear)
                .marginTop(12.px)
            
            Div{
                
                Div{
                    Span()
                        .class(.ico)
                        .backgroundImage("/skyline/media/add.png")
                    
                    Span("Agregar Prenda")
                    
                }
                .class(.uibutton)
                .marginRight(12.px)
                .float(.right)
                .cursor(.pointer)
                .onClick{
                    self.addProduct()
                }
                
                Div{
                    Img()
                        .src("/skyline/media/calendar.png")
                        .width(24.px)
                        .marginRight(7.px)
                    
                    Span(self.$selctedDate)
                    
                }
                .fontSize(32.px)
                .marginRight(12.px)
                .float(.right)
                .cursor(.pointer)
                .onClick{
                    self.selectDate()
                }
                
                H2("Ingrese Cargos")
                    .color(.highlighBlue)
                
            }
            
            Div().class(.clear)
            
            Div{
                Div{
                    self.itemGrid
                }
                
                .padding(all: 7.px)
            }
            .custom("height", "calc(100% - 240px)")
            .class(.roundBlue)
            .overflow(.auto)
            
            Div().class(.clear)
            
            Div{
                
                Img()
                    .src("/skyline/media/card_paybtn.png")
                    .float(.right)
                
                Div{
                    Span()
                        .class(.ico)
                        .backgroundImage("/skyline/media/bill.png")
                    
                    Span("Pagar y Cerrar")
                    
                }
                .class(.uibutton)
                .marginRight(12.px)
                .float(.right)
                .onClick(self.confirmSale)
                
                H2(self.$balanceString)
                    .float(.right)
                    .fontSize(32.px)
                    .marginLeft(5.px)
                    .marginRight(5.px)
                    .color(.highlighBlue)
                
                H2("TOTAL")
                    .float(.right)
                    .fontSize(32.px)
                    .marginLeft(5.px)
                    .marginRight(5.px)
                    .color(.lightGray)
                
            }
            .marginTop(12.px)
            
            
        }
        .padding(all: 12.px)
        .top(10.percent)
        .height(80.percent)
        .width(80.percent)
        .custom("left", "calc(10% - 12px)")
        .position(.absolute)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
        
    }
    
    override func buildUI() {
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        
        /*
        SkylineApp.current.$keyUp.listen {
            if $0 == "+" && !self.isAddingProduct {
                self.addProduct()
            }
        }
        */
        
        self.$uts.listen {
            let newDate = Date(timeIntervalSince1970: TimeInterval($0))
            self.selctedDate = "\(newDate.day)/\(newDate.month)/\(newDate.year)"
        }
        
        selectDate()
        
        @State var selctedDate = "FECHA"
        
        @State var uts: Int64 = 0
        
        self.$currentRentals.listen {
            self.calcBalance()
        }
    }
    
    func selectDate() {
        self.appendChild(
            SelectCalendarDate(
                            type: .rental,
                            selectedDateStamp: self.selectedDateStamp,
                            currentSelectedDates: []
                        ){ selectedDateStamp, uts, highPriority in
                            self.selectedDateStamp = selectedDateStamp
                            
                            print("🟡  new date \(uts)")
                            
                            self.uts = uts
                            self.highPriority = highPriority
                            self.currentRentals = []
                            self.itemGrid.innerHTML = ""
                            self.itemGrid.appendChild(Tr {
                                Td().width(50)
                                Td().width(50)
                                Td("Nombre")
                                Td("Units").width(100)
                                Td("C. Uni").width(100)
                                Td("S. Total").width(100)
                            })
                            
                            if highPriority {
                                self.itemGrid.appendChild(Tr {
                                    Td().width(50)
                                    Td().width(50)
                                    Td("Cargo de alta prioridad")
                                    Td("1").width(100)
                                    Td("150.00").width(100)
                                    Td("150.00").width(100)
                                })
                            }
                            
                            self.addProduct()
                        }

        )
    }
    
    func addProduct(){
        
        self.isAddingProduct = true

        self.appendChild(AddRentalSelectDepartment(
            costType: self.custAcct.costType,
            currentUsedIDs: self.currentUsedIDs,
            uts: self.uts,
            highPriority: self.highPriority
        ) { rentalObject in
            
            guard let rentalObject = rentalObject else {
                self.isAddingProduct = false
                return
            }
            
            rentalObject.items.forEach { item in
                self.currentUsedIDs.append(item.itemid)
            }
            
            rentalObject.items.forEach { rental in
                let id = UUID()
                
                let tr = RentalItemView(
                    id: id,
                    lineCount: self.currentRentals.count + 1,
                    deleteButton: (custCatchHerk >= 3),
                    data: rental,
                    name: rentalObject.name,
                    cost: rentalObject.cost
                ){ id in
                    
                }
                
                self.currentRentals.append(.init(
                    id: id,
                    tr: tr,
                    rental: rentalObject
                ))
                
                self.itemGrid.appendChild(tr)
                
            }
            
        })
    }
    
    func confirmSale() {
        
        guard currentRentals.count > 0 else {
            return
        }
        
        guard let _ = Float(self.balanceString)?.toCents else{
            return
        }
        
        guard self.uts > 0 else{
            showError(.invalidField, "Seleccione fecha de renta")
            return
        }
        
        let view = RentalOrderConfirmation(uts: self.uts, custAcct: self.custAcct) { dueAt, startAt, endAt, firstName, lastName, mobile, telephone, street, colony, city, state, country, zip in
            
            self.dueAt = dueAt
            self.startAt = startAt
            self.endAt = endAt
            self.firstName = firstName
            self.lastName = lastName
            self.mobile = mobile
            self.telephone = telephone
            self.street = street
            self.colony = colony
            self.city = city
            self.state = state
            self.country = country
            self.zip = zip
            
            self.addPayment()
        }
        
        self.appendChild(view)

        view.timeField.select()
        
    }
    
    func addPayment(){
        guard currentRentals.count > 0 else {
            return
        }
        
        guard let currentBalance = Float(self.balanceString)?.toCents else{
            return
        }
        
        let paymentView = AddPaymentFormView (
            accountId: custAcct.id,
            cardId: custAcct.CardID,
            currentBalance: currentBalance
        ) { code, description, amount, provider, lastFour, auth, uts in
            self.closeSale(code, description, amount.fromCents, provider, lastFour, auth)
        }
        
        self.appendChild(paymentView)
        
        paymentView.paymentInput.select()
        
    }
    
    func closeSale(
        _ fiscCode: FiscalPaymentCodes,
        _ description: String,
        _ amount: Float,
        _ provider: String,
        _ lastFour: String,
        _ auth: String
    ){
        
        let rentals: [RentalObject] = currentRentals.map{ $0.rental }
        
        if rentals.isEmpty {
            showError(.invalidFormat, "Ingrese productos de renta")
            return
        }
        
        var payment: [PaymentObject] = []
        if amount > 0 {
            
            payment.append(
                .init(
                    fiscCode: fiscCode,
                    description: description,
                    amount: amount.toCents,
                    reference: "",
                    provider: provider,
                    lastFour: lastFour,
                    auth: auth
                )
            )
            
        }
        
        loadingView(show: true)
        
        API.custOrderV1.create(
            type: .rental,
            store: custCatchStore,
            custAcct: custAcct.id,
            custSubAcct: nil,
            workedBy: nil,
            dueDate: Int64(self.dueAt),
            rentStartAt: Int64(self.startAt),
            rentEndAt: Int64(self.endAt),
            description: "",
            smallDescription: "",
            lat: nil,
            lon: nil,
            contact: .init(
                firstName: self.firstName,
                secondName: "",
                lastName: self.lastName,
                secondLastName: "",
                mobile: self.mobile,
                telephone: self.telephone,
                email: ""
            ),
            address: .init(
                street: self.street,
                colony: self.colony,
                city: self.city,
                zip: self.zip,
                state: self.state,
                country: self.country
            ),
            rentals: rentals,
            charges: [],
            payment: payment,
            equipments: [],
            files: []
        ) { resp in
            
            loadingView(show: false)
        
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let id = resp.id else {
                showError(.generalError, .unexpectedMissingValue("id de folio"))
                return
            }
            
            self.callback(id)
            
            if let folio = resp.folio {
                showSuccess(.operacionExitosa, "Folio: \(folio) creado con exito")
            }
            else{
                showSuccess(.operacionExitosa, "Folio creado con exito")
            }
            
            self.remove()
            
        }
        
    }
    
    func calcBalance(){
        
        var balance: Int64 = 0
        
        self.currentRentals.forEach { object in
            let cost = object.rental.cost
            let count = Int64(object.rental.items.count)
            balance += cost * count
        }
        
        if self.highPriority {
            balance += 15000.toInt64
        }
        
        self.balanceString = balance.formatMoney
        
    }
    
}

extension StartRentalOrder {
    struct RentalObjectRefrence {
        let id: UUID
        let tr: Tr
        let rental: RentalObject
    }
}
