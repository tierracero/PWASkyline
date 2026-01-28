//
//  AccountMembershipControlView.swift
//
//
//  Created by Victor Cantu on 2/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class AccountMembershipControlView: Div {
    
    override class var name: String { "div" }
    
    var accountId: UUID
    
    /// Siwe P remier Card Id
    var cardId: String?
    
    var currentActivationTime: Int64?
    
    var currentMembership: UUID?
    
    var billDate : Int64
    
    private var callback: ((
        _ currentActivationTime: Int64,
        _ membershipId: UUID,
        _ membershipName: String,
        _ accountBalance: Int64
    ) -> ())
    
    init(
        accountId: UUID,
        cardId: String?,
        currentMembership: UUID?,
        currentActivationTime: Int64?,
        billDate : Int64,
        callback: @escaping ((
            _ currentActivationTime: Int64,
            _ membershipId: UUID,
            _ membershipName: String,
            _ accountBalance: Int64
        ) -> ())
    ) {
        self.accountId = accountId
        self.currentMembership = currentMembership
        self.currentActivationTime = currentActivationTime
        self.callback = callback
        self.billDate = billDate
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var viewMode: ViewMode = .selectSoc
    
    @State var selectedSoc: CustSOC? = nil
    
    @State var changePriceViewIsHidden = true

    @State var price = "0"
    
    @State var payCode: FiscalPaymentCodes = .efectivo
    
    @State var payDescription = ""
    
    @State var payAmount: Int64 = 0
    
    @State var payProvider = ""
    
    @State var payLastFour = ""
    
    @State var payAuth = ""
    
    @State var initialDate = ""
    
    var initialDateCalendar = ""
    
    var initialDateUTS: Int64 = 0
    
    @State var finishedDate = ""
    
    var finishedDateCalendar = ""
    
    var finishedDateUTS: Int64 = 0
    
    lazy var socGrid = Div()
        .class(.roundDarkBlue)
        .overflow(.auto)
        .height(300.px)
    
    lazy var salePriceInput = InputText(self.$price)
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .width(25.percent)
        .fontSize(23.px)
        .height(28.px)
        .disabled(true)
    
    @DOM override var body: DOM.Content {
        //Select Code
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.remove()
                    }
                
                H2("Seleccione Servicio")
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            
            self.socGrid
            
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
        .hidden(self.$viewMode.map{ $0 != .selectSoc })
        
        /// Confirm Amount
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.selectedSoc = nil
                    }
                
                H2("Confirme Servicio")
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            
            /// `Nombre`
            Div{
                Label("Nombre")
                    .color(.gray)
                
                Div{
                    InputText(self.$selectedSoc.map{ $0?.name ?? ""})
                        .class(.textFiledBlackDark)
                        .placeholder("Nombre")
                        .width(90.percent)
                        .fontSize(23.px)
                        .height(28.px)
                        .disabled(true)
                        .marginBottom(7.px)
                }
            }
            .class(.section)
            
            Div().class(.clear).marginBottom(7.px)
            
            /// `Description`
            Div{
                Label("Descriptión")
                    .color(.gray)
                
                Div{
                    InputText(self.$selectedSoc.map{ "\($0?.smallDescription ?? "") \($0?.description ?? "")" })
                        .class(.textFiledBlackDark)
                        .placeholder("Descripción")
                        .width(90.percent)
                        .fontSize(23.px)
                        .height(28.px)
                        .disabled(true)
                        .marginBottom(7.px)
                }
                
            }
            .class(.section)
            
            /// `Months`
            Div{
                Label("Duracion")
                    .color(.gray)
                
                Div{
                    InputText(self.$selectedSoc.map{ $0?.units?.toString ?? "1"})
                        .class(.textFiledBlackDark)
                        .placeholder("0.00")
                        .width(25.percent)
                        .fontSize(23.px)
                        .height(28.px)
                        .disabled(true)
                        .marginBottom(7.px)
                }
                
            }
            .class(.section)
            
            /// `Price`
            Div{
                
                Label("Precio")
                    .color(.gray)
                
                Div{
                    Span {
                        
                        Div{
                            Img()
                                .src("/skyline/media/random.png")
                                .height(12.px)
                                .marginRight(7.px)
                            
                            Span("C.P.")
                                .fontSize(14.px)
                                .color(.gray)
                        }
                        .custom("width", "fit-content")
                        .padding(all: 7.px)
                        .marginLeft(0.px)
                        .class(.uibtn)
                        .float(.right)
                        .hidden(self.$changePriceViewIsHidden.map{ !$0 })
                        .onClick { _ in
                            self.changePriceViewIsHidden = false
                        }
                    }
                    .float(.right)
                    
                    self.salePriceInput
                }
                
            }
            .class(.section)
            
            /// `Change Price`
            Div{
                
                ///Precio Public
                Div{
                    Label("Precio Public")
                        .color(.gray)
                    
                    Div{
                        Div{
                            Span("$")
                                .marginRight(7.px)
                            Span(self.$selectedSoc.map{ ($0?.pricea ?? 0.toInt64).formatMoney })
                                .color(.gray)
                        }
                        .custom("width", "fit-content")
                        .paddingRight(7.px)
                        .paddingLeft(7.px)
                        .margin(all: 0.px)
                        .fontSize(23.px)
                        .onClick {
                            self.changePriceViewIsHidden = true
                            self.price = (self.selectedSoc?.pricea ?? 0.toInt64).formatMoney
                        }
                    }
                    .class(.uibtnLarge)
                }
                .class(.section)
                
                ///Medio Mayoreo
                Div{
                    Label("Medio Mayoreo")
                        .color(.gray)
                    
                    Div{
                        Div{
                            Span("$")
                                .marginRight(7.px)
                            Span(self.$selectedSoc.map{ ($0?.priceb ?? 0.toInt64).formatMoney })
                                .color(.gray)
                        }
                        .custom("width", "fit-content")
                        .paddingRight(7.px)
                        .paddingLeft(7.px)
                        .margin(all: 0.px)
                        .fontSize(23.px)
                        .onClick {
                            self.changePriceViewIsHidden = true
                            self.price = (self.selectedSoc?.priceb ?? 0.toInt64).formatMoney
                        }
                        
                    }
                    .class(.uibtnLarge)
                }
                .class(.section)
                
                ///Precio Mayoreo
                Div{
                    Label("Precio Mayoreo")
                        .color(.gray)
                    
                    Div{
                        Div{
                            Span("$")
                                .marginRight(7.px)
                            Span(self.$selectedSoc.map{ ($0?.pricec ?? 0.toInt64).formatMoney })
                                .color(.gray)
                        }
                        .custom("width", "fit-content")
                        .paddingRight(7.px)
                        .paddingLeft(7.px)
                        .margin(all: 0.px)
                        .fontSize(23.px)
                        .onClick {
                            self.changePriceViewIsHidden = true
                            self.price = (self.selectedSoc?.pricec ?? 0.toInt64).formatMoney
                        }
                    }
                    .class(.uibtnLarge)
                }
                .class(.section)
                
            }
            .hidden(self.$changePriceViewIsHidden.map{ $0 })
            
            Div()
                .marginBottom(3.px)
                .class(.clear)
            
            Div{
                Div("Agregar Pago")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addPayment()
                    }
            }
            .hidden(self.$changePriceViewIsHidden.map{ !$0 })
            .align(.right)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
        .hidden(self.$viewMode.map{ $0 != .selectPaymeth })
        
        /// Confirm Information
        Div {
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.viewMode = .selectPaymeth
                    }
                
                H2("Confirme Membresia")
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            
            Div().class(.clear).marginTop( 3.px)
            
            Div{
                Label("Plan seleccionado")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div{
                    
                    Span(self.$selectedSoc.map { $0?.name ?? "" })
                       .color(self.$selectedSoc.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
                       .class(.oneLineText, .textFiledBlackDark)
                       .position(.absolute)
                       .borderRadius(7.px)
                       .padding(all: 3.px)
                       .width(50.percent)
                       .fontSize(23.px)
                       .height(26.px)
                    
                    Div().class(.clear)
                }
            }
            .class(.section)
            
            Div().class(.clear).marginTop( 7.px)
            
            Div{
                Label("Decripción")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div {
                    Span(self.$selectedSoc.map { "\($0?.smallDescription ?? "") \($0?.description ?? "")" })
                       .color(self.$selectedSoc.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
                       .class(.oneLineText, .textFiledBlackDark)
                       .position(.absolute)
                       .borderRadius(7.px)
                       .padding(all: 3.px)
                       .width(50.percent)
                       .fontSize(23.px)
                       .height(26.px)
                    
                    Div().class(.clear)
                }
            }
            .class(.section)
            
            Div().class(.clear).marginTop( 7.px)
            
            Div{
                Label("Precio")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div {
                    Span(self.$price)
                       .color(self.$selectedSoc.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
                       .class(.oneLineText, .textFiledBlackDark)
                       .position(.absolute)
                       .borderRadius(7.px)
                       .padding(all: 3.px)
                       .width(50.percent)
                       .fontSize(23.px)
                       .height(26.px)
                    
                    Div().class(.clear)
                }
            }
            .class(.section)
            
            Div().class(.clear).marginTop( 7.px)
            
            
            Div{
                Label("Tipo de pago")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div {
                    Span(self.$payCode.map{ $0.description })
                       .color( .lightGray )
                       .class(.oneLineText, .textFiledBlackDark)
                       .position(.absolute)
                       .borderRadius(7.px)
                       .padding(all: 3.px)
                       .width(50.percent)
                       .fontSize(23.px)
                       .height(26.px)
                    
                    Div().class(.clear)
                }
            }
            .class(.section)
            
            Div{
                
                Label("Pago")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div {
                    Span(self.$payAmount.map{ $0.formatMoney })
                       .color( .lightGray )
                       .class(.oneLineText, .textFiledBlackDark)
                       .position(.absolute)
                       .borderRadius(7.px)
                       .padding(all: 3.px)
                       .width(50.percent)
                       .fontSize(23.px)
                       .height(26.px)
                    
                    Div().class(.clear)
                }
                
            }
            .class(.section)
            
            Div().class(.clear).marginTop( 7.px)
            
            Div{
                
                Span("Fecha de inicio")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div().class(.clear).marginTop( 3.px)
                
                Div(self.$initialDate)
                    .class(.oneLineText, .textFiledBlackDark)
                    .custom("width", "fit-content")
                   .color( .lightGray )
                   .borderRadius(7.px)
                   .padding(all: 3.px)
                   .cursor(.pointer)
                   .fontSize(23.px)
                   .height(26.px)
                   .onClick {
                       
                       self.loadDate(selectedDateStamp: self.initialDateCalendar) { uts in
                           
                           let date = getDate(uts)
                           
                           self.initialDate = date.formatedLong
                           
                           self.initialDateCalendar = date.calendarDateStamp
                           
                           self.initialDateUTS = uts
                           
                       }
                   }
                
                Div().class(.clear)
                
            }
            .class(.oneHalf)
            
            Div{
                Span("Fecha de finalizacion")
                    .fontSize(16.px)
                    .color(.gray)
                
                Div().class(.clear).marginTop( 3.px)
                
                Div(self.$finishedDate)
                    .class(.oneLineText, .textFiledBlackDark)
                    .custom("width", "fit-content")
                   .color( .lightGray)
                   .borderRadius(7.px)
                   .padding(all: 3.px)
                   .cursor(.pointer)
                   .fontSize(23.px)
                   .height(26.px)
                   .onClick {
                       self.loadDate(selectedDateStamp: self.finishedDateCalendar) { uts in
                           
                           let date = getDate(uts)
                           
                           self.finishedDate = date.formatedLong
                           
                           self.finishedDateCalendar = date.calendarDateStamp
                           
                           self.finishedDateUTS = uts
                           
                       }
                   }
                
                Div().class(.clear)
            }
            .class(.oneHalf)
            
            Div().class(.clear).marginTop( 7.px)
            
            Div{
               Div("+ Agregar paquete")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addMembership()
                    }
            }
            .align(.right)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(20.percent)
        .color(.white)
        .hidden(self.$viewMode.map{ $0 != .confirm })
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        loadingView(show: true)
        
        API.custAPIV1.getSOCs(type: .membership) { resp in
        
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            data.forEach { soc in
             
                let avatar = Img()
                    .src("/skyline/media/tierraceroRoundLogoBlack.svg")
                    .width(24.px)
                
                if !soc.avatar.isEmpty {
                    avatar.load("https://\(custCatchUrl)/contenido/thump_\(avatar)")
                }
                
                self.socGrid.appendChild(
                    Div{
                        Div{
                            avatar
                        }
                        .float(.left)
                        .width(28.px)
                        
                        Div(soc.name)
                            .class(.oneLineText)
                            .custom("width", "calc(100% - 170px)")
                            .float(.left)
                        
                        Div(soc.pricea.formatMoney)
                            .class(.oneLineText)
                            .textAlign(.right)
                            .width(125.px)
                            .float(.right)
                        
                        Div().class(.clear)
                    }
                        .custom("width", "calc(100% - 29px)")
                        .class(.uibtnLarge)
                        .marginLeft(7.px)
                        .onClick {
                            self.selectedSoc = soc
                        }
                )
            }
            
        }
        
        $selectedSoc.listen {
            
            if let soc = $0 {
                
                self.price = soc.pricea.formatMoney
                
                self.viewMode = .selectPaymeth
                
            }
            else {
                self.viewMode = .selectSoc
            }
            
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func addPayment(){
        
        guard let payment = Float(self.price)?.toCents else {
            return
        }
        
        let pv = AddPaymentFormView (
            accountId: accountId,
            cardId: cardId,
            currentBalance: payment
        ) { code, description, amount, provider, lastFour, auth, uts in
            
            self.payCode = code
            self.payDescription = description
            self.payAmount = amount
            self.payProvider = provider
            self.payLastFour = lastFour
            self.payAuth = self.payAuth
            
            let monthsToApply = self.selectedSoc?.units ?? 1
            
            ///`initialDate`
            
            self.initialDateUTS = getNow()
            
            if let currentActivationTime = self.currentActivationTime {
                
                if currentActivationTime < self.initialDateUTS {
                    
                    addToDom(ConfirmOptionView(
                        viewTitle: "Membresia vencida",
                        viewDescription: "El servicio vencio desde \(getDate(currentActivationTime).formatedLong)\n¿Desde cuando quiere renovar?",
                        buttonOneTag: "Hoy",
                        buttonTwoTag: "Dia que vencio",
                        optionOne: {
                            self.initialDateUTS = getNow()
                            self.setMembershipDate(monthsToApply: monthsToApply)
                        },
                        optionTwo: {
                            self.initialDateUTS = currentActivationTime
                            self.setMembershipDate(monthsToApply: monthsToApply)
                        }))
                    
                    return
                }
                
                self.initialDateUTS = currentActivationTime
                
            }
            
            self.setMembershipDate(monthsToApply: monthsToApply)
        }
        
        pv.isDownPaymentDisabled = true
        
        pv.payment = payment.formatMoney
        
//        pv.paymentInput.disabled(true)
        
        pv.paymentInput.select()
        
        addToDom(pv)
        
        
    }
    
    func setMembershipDate(monthsToApply: Int64){
        
        let startDate = getDate(self.initialDateUTS)
        
        self.initialDate = startDate.formatedLong
        
        self.initialDateCalendar = startDate.calendarDateStamp
        
        /// `finishedDate`
        self.finishedDateUTS = ( self.initialDateUTS + ((60 * 60 * 24 * 31).toInt64 * monthsToApply) )
        
        let endDate = getDate(self.finishedDateUTS)
        
        self.finishedDate = endDate.formatedLong
        
        self.finishedDateCalendar = endDate.calendarDateStamp
        
        self.viewMode = .confirm
    }
    
    func loadDate(selectedDateStamp: String, callback: @escaping ( (
        _ uts: Int64
    ) -> ()) ) {
        
        /// let selectedDateStamp = "\(date.year)/\(date.month)/\(date.day)"
        
        self.appendChild(
            SelectCalendarDate(
                type: nil,
                selectedDateStamp: selectedDateStamp,
                currentSelectedDates: []
            ) { _, uts, _ in
                
                callback(Int64(uts))
                
            }
        )
    }
    
    func addMembership(){
        
        /// CustSOC
        guard let selectedSoc else {
            showError(.errorGeneral, "No se localizo paquete seleccionado.")
            return
        }
        
        guard let _price = Float(price)?.toCents else {
            showError(.errorGeneral, "Seleccione precio de mebresia adecuado.")
            return
        }
        
        if initialDateUTS >= finishedDateUTS {
            showError(.errorGeneral, "El rango de fechas es invalido, la fecha de inicio debe ser menor a la fecha de finalizacion")
            return
        }
        
        loadingView(show: true)
        
        API.custAccountV1.addMembership(
            storeId: custCatchStore,
            accountid: accountId,
            socid: selectedSoc.id,
            socName: selectedSoc.name,
            price: _price,
            code: payCode,
            description: payDescription,
            amount: payAmount,
            provider: payProvider,
            auth: payAuth,
            lastFour: payLastFour,
            starAt: initialDateUTS,
            expiredAt: finishedDateUTS
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
                showError(.errorGeneral, "No se obtuvo payload de data")
                return
            }
            
            showSuccess(.operacionExitosa, "Plan/Memebresia Agragada")
            
            self.callback(
                self.finishedDateUTS,
                selectedSoc.id,
                selectedSoc.name,
                payload.balance
            )
            
            self.remove()
        }
    }
}

extension AccountMembershipControlView {
    enum ViewMode {
        case selectSoc
        case selectPaymeth
        case confirm
    }
}
