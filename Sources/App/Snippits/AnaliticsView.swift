//
//  AnaliticsView.swift
//  
//
//  Created by Victor Cantu on 12/7/22.
//

import TCFundamentals
import TCFireSignal
import Foundation
import Web

/// dueAlert, message, alertid
enum NotificationType: Codable, CustomStringConvertible {
    
    case dueAlert(dueIn: BillDueTimeframe)
    
    case message(text: String)
    
    case alertid(id: UUID)
    
    var description: String {
        switch self {
        case .dueAlert(let due):
            return due.description
        case .message(let text):
            return text
        case .alertid(let id):
            return id.uuidString
        }
    }
    
}

class AnaliticsView: PageController {
    
    override class var name: String { "div" }
    
    @State var asMainView: Bool
    
    /// dueAlert, message, alertid
    let notification: NotificationType?
    
    init(
        asMainView: Bool,
        notification: NotificationType?
    ) {
        self.asMainView = asMainView
        self.notification = notification
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var dueBalance: Int64 = 0
    /// All bills (current + due)
    @State var billedBalance: Int64 = 0
    /// Charges  taht have not been bill like overage
    @State var unBilledBalance: Int64 = 0
    /// Oxxo pay Refrence
    @State var oxxo: String = ""
    /// Spei payment refrence
    @State var spei: String = ""
    /// Last 12 bills
    @State var bills: [TCBillingQuick] = []
    
    @State var oxxoTypeViewIsHidden = true
    
    @State var oxxoCardViewIsHidden = true
    
    @State var paymentNotificationIsHidden = true
    
    @State var billDueTimeframe: BillDueTimeframe? = nil
    
    lazy var oxxoTypeView = Div {
        
        Div{
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.oxxoTypeViewIsHidden = true
                    }
                
                H2("Tipo de referencia")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Span("Puede imprimir su referencia o crear una ficha para llevar consigo.").color(.gray)
            
            Div().class(.clear)
            
            Div("Referencia impresa")
            .class(.uibtnLarge)
            .width(96.percent)
            .onClick {
                self.printOxxoPay()
            }
            
            Div().class(.clear)
            
            Div("Ficha Rapida")
            .class(.uibtnLarge)
            .width(96.percent)
            .onClick {
                self.createOxxoCard()
            }
            
            Div().class(.clear)
        }
        .custom( "left", "calc(50% - 214px)")
        .custom( "top", "calc(50% - 139px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 7.px)
        .width(400.px)
        .height(250.px)
    }
    .class(.transparantBlackBackGround)
    .hidden(self.$oxxoTypeViewIsHidden)
    .position(.absolute)
    .height(100.percent)
    .width(100.percent)
    .left(0.px)
    .top(0.px)
    
    lazy var oxxoCardImageView = Div()
    
    lazy var oxxoCardView = Div {
        Div{
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.oxxoCardViewIsHidden = true
                    }
                
                H2("Referencia")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Span("Guarda la referencia o tomale foto.").color(.gray)
            
            self.oxxoCardImageView
                .align(.center)
        }
        .custom( "left", "calc(50% - 214px)")
        .custom( "top", "calc(50% - 264px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(500.px)
        .width(400.px)
    }
    .class(.transparantBlackBackGround)
    .hidden(self.$oxxoCardViewIsHidden)
    .position(.absolute)
    .height(100.percent)
    .width(100.percent)
    .left(0.px)
    .top(0.px)
    
    lazy var billsGrid = Div()
        .padding(all: 3.px)
        .margin(all: 3.px)
        .class(.roundBlue)
        .overflow(.auto)
        .height(300.px)
    
    lazy var paymentNotificationView = Div {
        Div{
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.paymentNotificationIsHidden = true
                    }
                
                H2(self.$billDueTimeframe.map{ $0?.description ?? "" })
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Table {
                Tr{
                    Td{
                        
                        H3(self.$billDueTimeframe.map{ $0?.friendlyReminder ?? "" })
                            .marginBottom(7.px)
                            .color(.white)
                            
                        H2(self.$billedBalance.map{ "Saldo pendiente: $\($0.formatMoney)"})
                            .marginBottom(7.px)
                            .color(.darkOrange)
                        
                        Div("ok")
                            .class(.uibtnLarge)
                            .onClick({
                                self.paymentNotificationIsHidden = true
                            })
                    }
                    .verticalAlign(.middle)
                    .align(.center)
                }
            }
            .width(100.percent)
            .height(320.px)
            
        }
        .custom( "top", "calc(50% - 200px)")
        .custom( "left", "calc(50% - 214px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(400.px)
    }
    .class(.transparantBlackBackGround)
    .hidden(self.$paymentNotificationIsHidden)
    .position(.absolute)
    .height(100.percent)
    .width(100.percent)
    .left(0.px)
    .top(0.px)
    
    @DOM public override var body: DOM.Content {
        
        Div{
            Div{
                
                if !self.asMainView {
                    Img()
                        .closeButton(.uiView1)
                        .onClick{
                            self.remove()
                        }
                }
                
                Img()
                    .src("skyline/media/logoTierraCeroLongWhite.svg")
                    .marginLeft(12.px)
                    .marginRight(12.px)
                    .height(34.px)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            .marginTop(7.px)
            Div{
                
                Div{
                    H1(self.$billedBalance.map{ "Balance \($0.formatMoney)" })
                        .hidden(self.$dueBalance.map{ $0 > 0 })
                        .color( .lightBlueText )
                        .marginBottom(12.px)
                        
                    
                    H1(self.$dueBalance.map{ "Saldo vencido \($0.formatMoney)" })
                        .hidden(self.$dueBalance.map{ $0 <= 0 })
                            .color( .crimson)
                            .marginBottom(12.px)
                    
                    H2(self.$billedBalance.map{ "Balance facturado: \($0.formatMoney)" })
                        .marginBottom(12.px)
                        .color(.white)
                    
                    H2(self.$dueBalance.map{ "Balance atrasado: \($0.formatMoney)" })
                        .marginBottom(12.px)
                        .color(.white)
                    
                    H2("Estados de Cuenta")
                        .color(.lightBlueText)
                        .marginBottom(12.px)
                    
                    self.billsGrid
                    
                }
                .height(100.percent)
                .class(.oneHalf)
                
                Div{
                    H3("Haz tu pago en linea")
                        .color(.gray)
                    H2("Transferencia Interbancaria")
                        .color(.lightBlueText)
                    Div{
                        Img()
                            .src("skyline/media/bank_transfer.png")
                            .paddingRight(10.px)
                            .marginTop(7.px)
                            .height(75.px)
                            .float(.left)
                        
                        Div{
                            Span("Banco STP")
                                .color(.lightGray)
                                .marginBottom(3.px)
                                .fontSize(18.px)
                            
                            Div().class(.clear)
                            
                            Strong(self.$spei.map{ $0.isEmpty ? "CLABE:   ------------------" : "CLABE:   \($0)" })
                                .color(.lightGray)
                                .fontSize(22.px)
                                .marginBottom(3.px)
                            
                            Div().class(.clear)
                            
                            Span("Tu pago se registra en un par de minutos.")
                                .fontSize(16.px)
                                .color(.gray)
                        }
                        .custom("width", "calc(100% - 85px)")
                        .float(.left)
                        
                        Div().class(.clear)
                    }
                    .onClick({
                        
                        if self.spei.isEmpty {
                            return
                        }
                        
                        copyToClipbord(self.spei)
                        showSuccess(.operacionExitosa, "CLABE copiada",.short)
                    })
                    .class(.uibtnLarge)
                    .width(100.percent)
                    .height(85.px)
                    
                    H2("Pago con tarjeta")
                        .color(.lightBlueText)
                    Div{
                        Img()
                            .src("skyline/media/payWithCard.png")
                            .borderRadius(all: 12.px)
                            .marginRight(10.px)
                            .marginTop(16.px)
                            .width(75.px)
                            .float(.left)
                        
                        Div{
                            
                            Strong(" Visa, Mastercard, AMEX, Carnet...")
                                .color(.lightGray)
                                .marginBottom(3.px)
                                .fontSize(22.px)
                            
                            Div().class(.clear)
                            
                            Span("Tu pago se registra al instante.")
                                .fontSize(16.px)
                                .color(.gray)
                        }
                        .custom("width", "calc(100% - 85px)")
                        .float(.left)
                        
                        Div().class(.clear)
                    }
                    .onClick({
                        guard let tcaccount else{
                            showError(.generalError, "No se localizo cuenta vueba a cargar.")
                            return
                        }
                        
                        _ = JSObject.global.doAccountPayment!(self.dueBalance, custCatchUrl, tcaccount.mobile, tcaccount.firstName, tcaccount.lastName)
                        
                    })
                    .width(100.percent)
                    .class(.uibtnLarge)
                    .height(85.px)
                    
                    H2("Pagar por Oxxo")
                        .color(.lightBlueText)
                    
                    Div{
                        Img()
                            .src("skyline/media/oxxo.png")
                            .paddingRight(10.px)
                            .marginTop(21.px)
                            .width(75.px)
                            .float(.left)
                        
                        Div{
                            Span("OxxoPay")
                                .color(.lightGray)
                                .marginBottom(3.px)
                                .fontSize(18.px)
                            
                            Div().class(.clear)
                            
                            Strong(self.$oxxo.map{ $0.isEmpty ? "--------------" : $0.formatRefrence })
                                .color(.lightGray)
                                .fontSize(22.px)
                                .marginBottom(3.px)
                            
                            Div().class(.clear)
                            
                            Span("Tu pago se registra en un par de minutos.")
                                .fontSize(16.px)
                                .color(.gray)
                        }
                        .custom("width", "calc(100% - 85px)")
                        .float(.left)
                        
                        Div().class(.clear)
                    }
                    .onClick({
                        self.oxxoTypeViewIsHidden = false
                    })
                    .width(100.percent)
                    .class(.uibtnLarge)
                    .height(85.px)
                    
                }
                .height(100.percent)
                .class(.oneHalf)
                
            }
            .custom("height", "calc(100% - 50px)")
            .marginTop(7.px)
            
        }
        .backgroundColor(self.$asMainView.map{ $0 ? .transparentBlack : .grayBlack })
        .borderRadius(all: 24.px)
        .position(.absolute)
        .height(85.percent)
        .width(90.percent)
        .left(5.percent)
        .top(10.percent)
        
        self.oxxoTypeView
        
        self.oxxoCardView
        
        self.paymentNotificationView
        
        if self.asMainView {
            
            WebApp.current.loadingView
            
            WebApp.current.messageGrid
            
        }
        
    }
    
    public override func buildUI() {
        super.buildUI()
        
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if asMainView {
            backgroundColor(.transparent)
        }
        else{
            backgroundColor(.transparentBlack)
        }
        
        title = "Tierra Cero"
        
        metaDescription = "Hacemos tu empresa más grande"
        
        WebApp.current.document.head.body {
            
            Script()
                .src("skyline/js/main.js")
                .type("text/javascript")
                
            Script()
                .src("https://tierracero.com/dev/core/js/OPayV2.js")
                .type("text/javascript")
                .onLoad {
                    print("https://tierracero.com/dev/core/js/OPayV2.js  🟢")
                }
        }
        
        $bills.listen {
            
            self.billsGrid.innerHTML = ""
            
            $0.forEach { bill in
                self.billsGrid.appendChild(
                    Div{
                        
                        Span(bill.thisMonthBalance.formatMoney)
                            .float(.right)
                        
                        bill.cycleName
                        
                    }
                        .width(97.percent)
                        .class(.uibtnLarge)
                        .onClick({
                            self.downCustBillDoc(id: bill.id)
                        })
                )
            }
            
        }
        
        if self.asMainView {
            loadBasicConfiguration { status in
                
                guard let status else {
                    History.pushState(path: "login")
                    return
                }
                
                if status == .active {
                    History.pushState(path: "work")
                    return
                }
                
                API.custAPIV1.accountBalance { resp in
                    
                    loadingView(show: false)
                    
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
                    
                    self.dueBalance = payload.dueBalance
                    
                    self.billedBalance = payload.billedBalance
                    
                    self.unBilledBalance = payload.unBilledBalance
                    
                    self.oxxo = payload.oxxo
                    
                    self.spei = payload.spei
                    
                    self.bills = payload.bills
                
                }
            }
        }
        else {
            
            API.custAPIV1.accountBalance { resp in
                
                loadingView(show: false)
                
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
                
                self.dueBalance = payload.dueBalance
                
                self.billedBalance = payload.billedBalance
                
                self.unBilledBalance = payload.unBilledBalance
                
                self.oxxo = payload.oxxo
                
                self.spei = payload.spei
                
                self.bills = payload.bills
            
            }
            
        }
        
        if let notification {
            switch notification {
            case .dueAlert(dueIn: let dueIn):
                self.billDueTimeframe = dueIn
                self.paymentNotificationIsHidden = false
            case .message(text: _ ):
                break
            case .alertid(id: _ ):
                break
            }
        }
        
    }
    
    override public func didAddToDOM() {
        super.didAddToDOM()
        
        if let _ = isMobile() {
            History.pushState(path: "app")
            return
        }
        
        if let accountBalance {
            loadBillingData(accountBalance)
        }
        else {
            API.custAPIV1.accountBalance { resp in
                
                loadingView(show: false)
                
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
                
                self.loadBillingData(payload)
            
            }
        }
        
        if let notification {
         
            switch notification {
            case .dueAlert(dueIn: let dueIn):
                break
            case .message(text: let text):
                break
            case .alertid(id: let id):
                break
            }
            
        }
        
    }
    
    func loadBillingData(_ payload: API.custAPIV1.AccountBalanceResponse) {
        
        self.dueBalance = payload.dueBalance
        
        self.billedBalance = payload.billedBalance
        
        self.unBilledBalance = payload.unBilledBalance
        
        self.oxxo = payload.oxxo
        
        self.spei = payload.spei
        
        self.bills = payload.bills
    }
    
    func createOxxoCard(){
        
        let url = baseSkylineAPIUrl(ie: "createOxxoCard") +
        "&code=\(oxxo)" +
        "&amount=\(dueBalance.toString)"
        
        struct CreateOxxoCardRequest: Codable {
            let code: String
            let amount: Int64
        }
        
        struct CreateOxxoCardResponse: Codable {
            let file: String
        }
        
        loadingView(show: true)
        
        sendPost(url, CreateOxxoCardRequest(
            code: self.oxxo,
            amount: self.dueBalance
        )) { data in
            
            loadingView(show: false)
            
            guard let data else {
                showError(.generalError, .serverConextionError)
                return
            }
            
            do{
                let payload = try JSONDecoder().decode(CreateOxxoCardResponse.self, from: data)
                
                self.oxxoCardImageView.innerHTML = ""
                
                self.oxxoCardImageView.appendChild(
                    Img()
                        .src(payload.file)
                        .width(220.px)
                )
                
                self.oxxoTypeViewIsHidden = true
                
                self.oxxoCardViewIsHidden = false
                
            }
            catch {
                showError(.comunicationError, "No se pudo generar referencia ")
                print("🔴  error 🔴")
                print(error)
                
            }
        }
    }
    
    func printOxxoPay(){
        
        _ = JSObject.global.goToURL!(
            baseSkylineAPIUrl(ie: "printOxxoPay") +
            "&code=\(oxxo)" +
            "&amount=\(dueBalance.toString)"
        )
        
        loadingView(show: true)
        
        oxxoTypeViewIsHidden = true
        
        Dispatch.asyncAfter( 1.5) {
            loadingView(show: false)
        }
        
    }
    
    func downCustBillDoc(id: UUID){
        
        _ = JSObject.global.goToURL!(baseSkylineAPIUrl(ie: "downBillDoc") + "&id=\(id.uuidString)")
        
        loadingView(show: true)
        
        Dispatch.asyncAfter( 1.5) {
            loadingView(show: false)
        }
    }
    
}

func baseSkylineAPIUrl(ie: String) -> String {
    
    let _token = (custCatchToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _user = (custCatchUser.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _key = (custCatchKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _mid = (custCatchMid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    return "https://tierracero.com/dev/skyline/api.php?" +
    "token=\(_token)" +
    "&user=\(_user)" +
    "&key=\(_key)" +
    "&mid=\(_mid)" +
    "&ie=\(ie)"
    
}

func baseAPIUrl(_ endpoint: String) -> String {
    
    let _token = (custCatchToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _user = (custCatchUser.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _key = (custCatchKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _mid = (custCatchMid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    var url = "\(endpoint)?" +
    "token=\(_token)" +
    "&user=\(_user)" +
    "&key=\(_key)" +
    "&mid=\(_mid)"
    
    return url
}
