//
//  AddPaymentFormView.swift
//
//
//  Created by Victor Cantu on 2/23/22.
//

import Foundation
import TCFundamentals
import Web

class AddPaymentFormView: Div {
    
    override class var name: String { "div" }
    
    /// CustAcct.id
    let accountId: UUID?
    
    /// Premier Card Id
    let cardId: String?
    
    @State var currentBalance: Int64
    
    var isUsingPoints: Bool
    
    private var callback: ((
        _ code: FiscalPaymentCodes,
        _ description: String,
        _ amount: Int64,
        _ provider: String,
        _ lastFour: String,
        _ auth: String,
        _ uts: Int64?
    ) -> ())
        
    init(
        accountId: UUID?,
        cardId: String?,
        currentBalance: Int64,
        isUsingPoints: Bool = false,
        callback: @escaping ((
            _ code: FiscalPaymentCodes,
            _ description: String,
            _ amount: Int64,
            _ provider: String,
            _ lastFour: String,
            _ auth: String,
            _ uts: Int64?
        ) -> ())
    ) {
        self.accountId = accountId
        self.cardId = cardId
        self.currentBalance = currentBalance
        self.callback = callback
        self.isUsingPoints = isUsingPoints
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var paymentMethod: FiscalPaymentCodes = .efectivo
    
    @State var paymentMethodListener = FiscalPaymentCodes.efectivo.rawValue
    
    @State var payDescr = "Pago"
    
    @State var payment = "0.00"
    
    @State var providerFilter = ""
    
    var providerName = ""
    
    @State var provider = ""
    
    @State var lastFour = ""
    
    @State var auth = ""
    
    @State var newBalance = "0.00"
    
    @State var isDownPayment = false
    
    @State var isDownPaymentDisabled = false
    
    @State var datePickerIsHidden = false
    
    @State var date = ""
    
    @State var generalBankResultsIsHidden = true
    
    var banks: [BanksItem] = []
    
    lazy var changeBalance = H1(self.$newBalance)
        .color(.white)
    
    lazy var paymentMethods = Select($paymentMethodListener)
        .class(.textFiledBlackDarkLarge)
        .width(99.percent)
        .fontSize(23.px)
    
    lazy var generalBankField = InputText(self.$providerFilter)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Seleccione Banco")
        .class(.textFiledLight)
        .width(93.percent)
        .fontSize(23.px)
        .height(28.px)
        .onFocus {
            self.generalBankResultsIsHidden = false
        }
        .onKeyUp({ tf in
            self.filterPublicBanks()
        })
        .onBlur {
            
            Dispatch.asyncAfter(0.35) {
                self.generalBankResultsIsHidden = true
                if !self.providerName.isEmpty {
                    self.providerFilter = self.providerName
                    self.checkFreePayment()
                }
            }
            
        }
    
    lazy var generalBankResults = Div()
        .hidden(self.$generalBankResultsIsHidden)
        .backgroundColor(.white)
        .borderRadius(12.px)
        .position(.absolute)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .width(65.percent)
        .marginLeft(30.percent)
        .zIndex(1)
    
    lazy var myBanks = Select()
        .class(.textFiledBlackDarkLarge)
    
    lazy var cardProvider = Select {
        Option("Seleccione Proveedor")
            .value("")
        
        Option("Master Card")
            .value("MC")
        
        Option("Visa")
            .value("VISA")
        
        Option("American Express")
            .value("AMEX")
        
        Option("Discover")
            .value("DISCOVER")
        
        Option("Otro")
            .value("other")
        
    }
    .class(.textFiledBlackDarkLarge)
    
    lazy var adjustmentView = Div {
        
        H2("Datos del Ajuste")
            .color(.lightBlueText)
        
        Div{
            Label("Motivo del Ajuste")
                .fontSize(24.px)
                .color(.white)
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            TextArea(self.$auth)
                .placeholder("Ingrese la razon del ajuste")
                .class(.textFiledBlackDarkLarge)
                .width(99.percent)
                .fontSize(23.px)
                .height(70.px)
        }
        .width(50.percent)
        .float(.left)
     
        Div().clear(.both)
        
    }
        .class(.roundBlue)
        .padding(all: 7.px)
        .hidden(self.$paymentMethod.map{
            $0 != .condonacion &&
            $0 != .compensacion &&
            $0 != .remisionDeDeuda
        })
    
    lazy var cardPaymentLastFourField = InputText(self.$lastFour)
        .class(.textFiledBlackDarkLarge)
        .placeholder("4 ultimos")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var cardPaymentAuthField = InputText(self.$auth)
        .placeholder("Folio de Autorizacion")
        .class(.textFiledBlackDarkLarge)
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var cardPaymentView = Div {
        
        H2("Datos del pago con tarjeta")
            .color(.lightBlueText)
        
        Div{
            Label("Proveedor")
                .fontSize(24.px)
                .color(.white)
            
        }
        .width(50.percent)
        .float(.left)
        
        Div{
        
            self.cardProvider
            .onChange { event, select in
                self.provider = select.value
                self.checkFreePayment()
            }
            .fontSize(23.px)
            .width(99.percent)
            
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear).height(7.px)
        
        Div{
            
            Label("Ultimos Cuatro")
                .fontSize(24.px)
                .color(.white)
            
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            self.cardPaymentLastFourField
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear).height(7.px)
        
        Div{
            Label("Folio de Autorizacion")
                .fontSize(24.px)
                .color(.white)
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            self.cardPaymentAuthField
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear)
        
    }
        .class(.roundBlue)
        .padding(all: 7.px)
        .hidden(self.$paymentMethod.map{
            $0 != .tarjetaDeDebito &&
            $0 != .tarjetaDeCredito
        })
    
    lazy var checkPaymentNumber = InputText(self.$auth)
        .class(.textFiledBlackDarkLarge, .zoom)
        .placeholder("4 ultimos")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var checkPaymentView = Div {
        
        H2("Datos del Cheque")
            .color(.lightBlueText)
        
        Div{
            Label("Proveedor")
                .fontSize(24.px)
                .color(.white)
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            self.generalBankField
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear).height(7.px)
        
        self.generalBankResults
        
        Div().class(.clear)
        
        Div{
            Label("Numero de Cheque")
                .fontSize(24.px)
                .color(.white)
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            self.checkPaymentNumber
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear)
        
    }
        .class(.roundBlue)
        .padding(all: 7.px)
        .hidden(self.$paymentMethod.map{ $0 != .chequeNominativo })
    
    lazy var speiPaymentFolio = InputText(self.$auth)
        .placeholder("Folio De Tranferencia")
        .class(.textFiledBlackDarkLarge, .zoom)
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var speiPaymentView = Div {
        
        H2("Datos de la transferencia")
            .color(.lightBlueText)
        
        Div{
            Label("Banco")
                .fontSize(24.px)
                .color(.white)
            
            Div()
            
            Label("¿Donde Recibiste El Deposito?")
                .color(.gray)
            
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            self.myBanks
            .onChange { event, select in
                self.provider = select.value
                self.checkFreePayment()
            }
            .width(99.percent)
            .fontSize(23.px)
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear).height(7.px)
        
        Div{
            Label("Folio De Tranferencia")
                .fontSize(24.px)
                .color(.white)
        }
        .width(50.percent)
        .float(.left)
        
        Div{
            self.speiPaymentFolio
        }
        .width(50.percent)
        .float(.left)
        
        Div().class(.clear)
        
    }
        .class(.roundBlue)
        .padding(all: 7.px)
        .hidden(self.$paymentMethod.map{ $0 != .transferenciaElectronicaDeFondos })
    
    lazy var paymentDescription = InputText(self.$payDescr)
        .class(.textFiledBlackDarkLarge)
    
    lazy var paymentInput = InputText(self.$payment)
        .class(.textFiledBlackDarkLarge)
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.uiView2)
                .onClick{
                    self.remove()
                }
            
            H2("Ingresar Pago")
                .color(.lightBlueText)
            
            Div().class(.clear)
            
            
            Div{
                
                Div{
                    Label("Forma de Pago:")
                        .fontSize(23.px)
                        .color(.white)
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    self.paymentMethods
                }
                .width(50.percent)
                .float(.left)
                
            }
            
            
            Div().class(.clear).marginTop(7.px)
            
            self.adjustmentView
            
            self.cardPaymentView
            
            self.checkPaymentView
            
            self.speiPaymentView
            
            Div().class(.clear).height(12.px)
            
            Div{
                Label("Balance")
                    .marginRight(12.px)
                    .fontSize(24.px)
                    .color(.white)
            }
            .width(50.percent)
            .align(.right)
            .float(.left)
            
            Div {
                H1(self.currentBalance.formatMoney)
                    .color(.white)
            }
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear).height(12.px)
            
            /*
            Div {
                Label("Descripcion")
                    .fontSize(24.px)
                    .color(.white)
            }
            .width(50.percent)
            .float(.left)
            
            Div{
                self.paymentDescription
                    .class(.textFiledLight)
                    .width(90.percent)
                    .height(34.px)
                    .onFocus{ input in
                        input.select()
                    }
            }
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear).height(12.px)
            */
            
            Div {
                Label("Pago")
                    .marginRight(12.px)
                    .fontSize(24.px)
                    .color(.white)
            }
            .width(50.percent)
            .align(.right)
            .float(.left)
        
            Div{
                self.paymentInput
                    .class(.textFiledLight)
                    .placeholder("0.00")
                    .width(150.px)
                    .height(28.px)
                    .onFocus{ input in
                        input.select()
                    }
                    .onKeyUp { input, event in
                        self.calcNewBalance()
                    }
                    .onKeyDown({ tf, event in
                        guard let _ = Double(event.key) else {
                            if !ignoredKeys.contains(event.key) {
                                event.preventDefault()
                            }
                            return
                        }
                    })
            }
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear).height(12.px)
            
            Div {
                Label("Cambio")
                    .color(.init(r: 86, g: 230, b: 86))
                    .marginRight(12.px)
                    .fontSize(32.px)
            }
            .width(50.percent)
            .align(.right)
            .float(.left)
        
            Div{
                self.changeBalance
            }
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear).height(12.px)
            
            Div{
                /// toggle
                Label {
                    InputCheckbox(self.$isDownPayment)
                    
                    Span()
                        .class(.slider, .round)
                        .cursor(.pointer)
                }
                .class(.switch)
                .float(.left)
                .marginRight(12.px)
                
                H2("Tomar Como Anticipo")
                    .color(.white)
                    .float(.left)
                
                Div().class(.clear)
            }
            .hidden(self.$isDownPaymentDisabled)
            
            Div().class(.clear).height(12.px)
                .hidden(self.$isDownPaymentDisabled)
            
            Div{
                
                Div{
                    Label("Fecha de Pago")
                        .fontSize(24.px)
                        .color(.white)
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    InputText(self.$date)
                        .class(.textFiledBlackDarkLarge)
                        .placeholder("DD/MM/AAAA")
                        .width(200.px)
                        .height(34.px)
                        .onFocus{ input in
                            input.select()
                        }
                }
                .width(50.percent)
                .float(.left)
                
                Div().class(.clear).marginTop(12.px)
            }
            .hidden(self.$datePickerIsHidden)
            
            Div{
                
                if !(self.cardId ?? "").isEmpty, !self.isUsingPoints {
                    
                    Div {
                        
                        Img()
                            .src("skyline/media/star_yellow.png")
                            .marginRight(7.px)
                            .width(18.px)
                        
                        Strong("Pagar con Puntos")
                            //.fontSize(28.px)
                        
                    }
                    .class(.uibtnLarge)
                    .onClick(self.doPaymentWithPoints)
                    .margin(all: 0.px)
                    .float(.left)
                    
                }
                
                Div{
                    
                    Img()
                        .src("images/add.png")
                        .marginRight(7.px)
                        .width(18.px)
                    
                    Strong(self.$isDownPayment.map{ $0 ? "Agragar Anticipo" : "Agregar Pago" })
                        
                }
                .class(.uibtnLargeOrange)
                .onClick(self.doPayment)
                .margin(all: 0.px)
                
            }
            .marginTop(12.px)
            .align(.right)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("top","calc(50% - 250px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        $paymentMethodListener.listen {
        
            guard let meth = FiscalPaymentCodes(rawValue: $0) else {
                return
            }
            
            self.provider = ""
            self.lastFour = ""
            self.auth = ""
            
            self.paymentMethod = meth
            
            if meth == .transferenciaElectronicaDeFondos {
               if mybanks.isEmpty {
                   
                   self.paymentMethodListener = FiscalPaymentCodes.efectivo.rawValue
                   showError(.requiredField, "No tiene bancos. Ingrese a configuracion para agregar bancos.")
                   
                   return
               }
            }
           
        }
        
        FiscalPaymentCodes.allCases.forEach { code in
            if code.basicCodes {
                paymentMethods.appendChild(
                    Option("\(code.rawValue) \(code.description)")
                        .value(code.rawValue)
                )
            }
        }
        
        API.v1.getBanks { resp in
            
            guard let resp = resp else {
                return
            }
            
            self.banks = resp
             
            self.filterPublicBanks()
            
        }
        
        myBanks.appendChild(
            Option("Seleccione Banco")
                .value("")
        )
        
        mybanks.forEach { bank in
            self.myBanks.appendChild(
                Option("\(bank.bank) \(bank.account.suffix(4)) \(bank.nick)")
                    .value("\(bank.bank) \(bank.account.suffix(4))")
            )
        }
        
        if currentBalance <= 0 {
            self.isDownPayment = true
            self.payDescr = "Anticipo"
        }
        
        $isDownPayment.listen {
            if $0 {
                if self.payDescr == "Pago" {
                    self.payDescr = "Anticipo"
                }
            }
            else{
                if self.payDescr == "Anticipo" {
                    self.payDescr = "Pago"
                }
            }
            
            self.calcNewBalance()
        }
        
    }
    
    func doPayment(){
        
        guard let meth = FiscalPaymentCodes(rawValue: paymentMethods.value) else{
            showError(.requiredField, "Seleccione metodo de pago valido.")
            return
        }
        
        switch meth {
        case .chequeNominativo:
            if provider.isEmpty {
                showError(.requiredField, "Seleccione Banco provedor de cheque")
                return
            }
            if self.auth.isEmpty {
                showError(.requiredField, "Ingrese numero de cheque")
                return
            }
        case .transferenciaElectronicaDeFondos:
            let bank = myBanks.value
            if bank.isEmpty {
                showError(.requiredField, "Seleccione Banco")
                return
            }
            if self.auth.isEmpty {
                showError(.requiredField, "Ingrese folio de transferencia")
                return
            }
        case .tarjetaDeCredito, .tarjetaDeDebito, .tarjetaDeServicios:
            
            let bank = cardProvider.value
            
            if bank.isEmpty {
                showError(.requiredField, "Seleccione Banco")
                return
            }
            
            if self.lastFour.isEmpty {
                showError(.requiredField, "Ingrese custro ultimos de la trajeta")
                return
            }
            
            if self.auth.isEmpty {
                showError(.requiredField, "Ingrese folio de autorización")
                return
            }
            
        case .condonacion:
            break
        case .compensacion:
            break
        case .remisionDeDeuda:
            break
        default:
            break
        }
        
        guard var thisPaymentFloat = Double(payment) else {
            self.paymentInput.select()
            showError(.invalidFormat, "Ingrese un pago valido")
            return
        }
        
        if thisPaymentFloat <= 0 {
            /*
             
             i dont know if i need this !!
             
            if meth == .efectivo {
                self.callback( .efectivo, "", 0, "", "", "", nil)
                return
            }
            */
            self.paymentInput.select()
            showError(.invalidFormat, "Ingrese un pago valido")
            return
        }
        
        var thisPayment = thisPaymentFloat.toCents
        
        if !self.isDownPayment {
            if thisPayment > currentBalance {
                
                let change = currentBalance - thisPayment
                
                thisPayment = thisPayment - (change * -1)
                
            }
        }
        
        var uts: Int64? = nil
        
        if !date.isEmpty {
            
            guard let _uts = parseDate(date: date, time: "16:00") else {
                return
            }
            
            uts = _uts
            
        }
        
        self.callback(meth, payDescr, thisPayment, provider, lastFour, auth, uts)
        
        self.remove()
        
    }
    
    func doPaymentWithPoints(){
        
        guard currentBalance > 0 else {
            showError(.generalError, "No hay balance a pagar.")
            return
        }
        
        guard let accountId else {
            showError(.generalError, "No se ha localizado id de la cuenta.")
           return
        }
        
        guard let cardId, !cardId.isEmpty else {
            showError(.generalError, "No se ha vinculado tarjeta de recompensas")
           return
        }
        
        loadingView(show: true)
        
        API.rewardsV1.getPoints(
            cardId: cardId
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            let view = AddPaymentWithPointsView(
                accountId: accountId,
                cardId: cardId,
                currentBalance: self.currentBalance,
                points: payload
            ) { code, description, amount, provider, lastFour, auth, uts in
               
                self.callback(code, description, amount, provider, lastFour, auth, uts)
                
                self.remove()
                
            }
            
            addToDom(view)
            
        }
        
    }
    
    func calcNewBalance(){
        
        newBalance = "0.00"
        self.changeBalance.color(.white)
        
        if payment.isEmpty {
            return
        }
        
        guard let thisPayment = Double(payment)?.toCents else{

            print("🚧  ERROR  payment ")

            return
        }
        
        if self.isDownPayment {
            
            newBalance = "0.00"
            
            self.changeBalance.color(.black)
            
        }
        else{
            
            if (thisPayment - currentBalance) <= 0 {
                newBalance = "0.00"
                return
            }
            
            print("currentBalance", currentBalance)

            print("thisPayment", thisPayment)

            newBalance = (thisPayment - currentBalance).formatMoney
            
            if thisPayment >= currentBalance{
                self.changeBalance.color(.init(r: 86, g: 230, b: 86))
            }
            else{
                self.changeBalance.color(.red)
            }
        }
        
        
    }
    
    func checkFreePayment() {
        
        cardPaymentAuthField
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)
        
        checkPaymentNumber
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)
        
        speiPaymentFolio
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)
        
        switch paymentMethod {
        case .efectivo:
            /// Cash dose not requier validation
            break
        case .chequeNominativo:
            
            guard !provider.isEmpty else {
                return
            }
            
            guard !auth.isEmpty else {
                return
            }
            
            checkPaymentNumber
                .class(.isLoading)
            
        case .transferenciaElectronicaDeFondos:
            
            guard !provider.isEmpty else {
                return
            }
            
            guard !auth.isEmpty else {
                return
            }
            
            speiPaymentFolio
                .class(.isLoading)
            
            
        case .tarjetaDeDebito, .tarjetaDeCredito, .tarjetaDeServicios:
            
            guard !provider.isEmpty else {
                return
            }
            
            guard !lastFour.isEmpty else {
                return
            }
            
            guard !auth.isEmpty else {
                return
            }
            
            cardPaymentAuthField
                .class(.isLoading)
        case .condonacion, .compensacion, .remisionDeDeuda:
            /// Adjustment does not requiere validation
            break
        default:
            return
        }
        
        
        API.custAPIV1.paymentAuthPreValidation(
            formaDePago: paymentMethod,
            provider: provider,
            auth: auth,
            lastFour: lastFour
        ) { resp in
            
            self.checkPaymentNumber
                .removeClass(.isLoading)
            
            self.cardPaymentAuthField
                .removeClass(.isLoading)
            
            self.speiPaymentFolio
                .removeClass(.isLoading)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            print(resp)

            switch self.paymentMethod {
            case .efectivo:
                /// Cash dose not requier validation
                break
            case .chequeNominativo:
                if data.isFree {
                    self.checkPaymentNumber
                        .class(.isOk)
                }
                else{
                    self.checkPaymentNumber
                        .class(.isNok)
                }
                
            case .transferenciaElectronicaDeFondos:
                if data.isFree {
                    self.speiPaymentFolio
                        .class(.isOk)
                }
                else{
                    self.speiPaymentFolio
                        .class(.isNok)
                }
            case .tarjetaDeDebito, .tarjetaDeCredito, .tarjetaDeServicios:
                if data.isFree {
                    self.cardPaymentAuthField
                        .class(.isOk)
                }
                else{
                    self.cardPaymentAuthField
                        .class(.isNok)
                }
            case .condonacion, .compensacion, .remisionDeDeuda:
                /// Adjustment does not requiere validation
                break
            default:
                return
            }

            
        }
        
        
    }
    
    func filterPublicBanks(){
        
        generalBankResults.innerHTML = ""
        
        let term = providerFilter.lowercased().purgeSpaces
        
        if term.isEmpty {
            
            banks.forEach { bank in
                
                let view = Div{
                    Div(bank.name)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .fontSize(24.px)
                }
                    .marginBottom(7.px)
                    .borderRadius(7.px)
                    .width(95.percent)
                    .class(.uibutton)
                    .textAlign(.left)
                    .onClick {
                        self.generalBankField.class(.isOk)
                        self.providerFilter = bank.name
                        self.providerName = bank.name
                        self.provider = bank.code
                        self.generalBankResultsIsHidden = true
                    }
                
                generalBankResults.appendChild(view)
                
                
                
            }
            
        }
        else{
            
            var current: [String] = []
            
            banks.forEach { bank in
                
                if bank.name.lowercased().hasPrefix(term) {
                    current.append(bank.code)
                    
                    let view = Div{
                        Div(bank.name)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .fontSize(24.px)
                    }
                        .marginBottom(7.px)
                        .borderRadius(7.px)
                        .width(95.percent)
                        .class(.uibutton)
                        .textAlign(.left)
                        .onClick {
                            self.generalBankField.class(.isOk)
                            self.providerFilter = bank.name
                            self.providerName = bank.name
                            self.provider = bank.code
                            self.generalBankResultsIsHidden = true
                        }
                    
                    generalBankResults.appendChild(view)
                    
                }
                
            }
            
            banks.forEach { bank in
                
                if current.contains(bank.code) {
                    return
                }
                
                if bank.name.lowercased().contains(term) {
                    
                    current.append(bank.code)
                    
                    let view = Div{
                        Div(bank.name)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .fontSize(24.px)
                    }
                        .marginBottom(7.px)
                        .borderRadius(7.px)
                        .width(95.percent)
                        .class(.uibutton)
                        .textAlign(.left)
                        .onClick {
                            self.generalBankField.class(.isOk)
                            self.providerFilter = bank.name
                            self.providerName = bank.name
                            self.provider = bank.code
                            self.generalBankResultsIsHidden = true
                        }
                    
                    generalBankResults.appendChild(view)
                    
                }
                
            }
        }
        
    }
}
