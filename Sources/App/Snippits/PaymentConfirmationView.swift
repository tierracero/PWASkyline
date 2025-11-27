//
//  PaymentConfirmationView.swift
//  
//
//  Created by Victor Cantu on 6/2/22.
//

import Foundation
import TCFundamentals
import Web
import JavaScriptKit
import XMLHttpRequest

class PaymentConfirmationView: Div {
    
    var printaccount = ""
    var printfolio = ""
    var printname = ""
    var printlastname = ""
    
    override class var name: String { "div" }
    
    @State var saleId: UUID
    
    @State var saleFolio: String
    
    @State var accountid: UUID?
    
    @State var accountFolio: String?
    
    @State var accountName: String?
    
    let subTotal: String
    
    let payment: String
    
    let change: String
    
    let kart: [SalePointObject]
    
    let cardex: [CustPOCCardex]
    
    init(
        saleId: UUID,
        saleFolio: String,
        accountid: UUID?,
        accountFolio: String?,
        accountName: String,
        subTotal: String,
        payment: String,
        change: String,
        kart: [SalePointObject],
        cardex: [CustPOCCardex]
    ) {
        self.saleId = saleId
        self.saleFolio = saleFolio
        self.accountid = accountid
        self.accountFolio = accountFolio
        self.accountName = accountName
        self.subTotal = subTotal
        self.payment = payment
        self.change = change
        self.kart = kart
        self.cardex = cardex
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /*
    lazy var itemGrid = Table{
        Tr {
            Td().width(50)
            Td("Marca").width(200)
            Td("Modelo / Nombre")
            Td("Units").width(100)
            Td("C. Uni").width(100)
            Td("S. Total").width(100)
        }
    }
        .width(100.percent)
    */
    
    lazy var fiscalDiv = Div{
        
        Div{
            
            Strong("Facturar")
                .fontSize(24.px)
                .color(.black)
            
        }
        .cursor(.pointer)
        .class(.smallButtonBox)
        .margin(all: 24.px)
        .onClick {
            self.facturar()
        }
        
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .closeButton(.subView)
                .onClick{
                    self.remove()
                }
            
            H1("Venta realizada con exito")
                .color(.lightBlueText)
            
            Div().class(.clear)
            
            Div()
                .class(.clear)
                .marginTop(24.px)
            
            Div {
                
                Img()
                    .src("/skyline/media/checkmark.png")
                    .width(128.px)
                
                Div().clear(.both)

                Div{
                    Strong("Imprimir")
                        .fontSize(24.px)
                        .color(.highlighBlue)
                }
                .cursor(.pointer)
                    .class(.smallButtonBox)
                    .margin(all: 24.px)
                    .onClick {
                        
                        if configStore.printPdv.document == .miniprinter {
                            
                            self.printTicket()
                            
                        }
                        else{
                            
                            let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") +
                            "&ie=printPDVSale&id=" + self.saleId.uuidString
                            
                            print(url)
                            
                            _ = JSObject.global.goToURL!(url)
                            
                        }
                        
                    }
                
                Div().clear(.both)

                Div{
                    
                    Img()
                    .src("/skyline/media/whatsapp.png")
                    .marginRight(12.px)
                    .height(24.px)
                    .width(24.px)
                    
                    Strong("Enviar")
                        .fontSize(24.px)
                        .color(.highlighBlue)
                }
                .cursor(.pointer)
                    .class(.smallButtonBox)
                    .margin(all: 24.px)
                    .onClick {
                        self.sendSaleByMessage()    
                    }
                
                Div().clear(.both)

                self.fiscalDiv
                
            }
            .align(.center)
            .class(.oneHalf)
            
            Div {
                Div{
                    
                    Strong("Cuenta")
                        .color(.highlighBlue)
                        .float(.left)
                    
                    Span(self.$accountFolio.map{ $0 ?? "S/F"})
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
                Div().class(.clear)
                
                Div{
                    Strong("Cliente")
                        .float(.left)
                    
                    Span(self.$accountName.map{ $0 ?? "Publico General" })
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                //
                Div().class(.breaks)
                    .marginTop(7.px)
                    .marginBottom(7.px)
                
                // SubTotal
                Div{
                    Strong("Sub Total")
                    .float(.left)
                    .marginLeft(24.percent)
                    
                    Span(self.subTotal)
                    
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
                // Pago
                Div{
                    Strong("Pago")
                        .float(.left)
                        .marginLeft(24.percent)
                    
                    Span(self.payment)
                    
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
                // cambio
                Div{
                    Strong("Cambio")
                        .float(.left)
                        .marginLeft(24.percent)
                    
                    Span(self.change)
                    
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
                //
                Div().class(.breaks)
                    .marginTop(7.px)
                    .marginBottom(7.px)
                //
                
                // sale folio
                Div{
                    Strong("Orden de Venta")
                        .float(.left)
                    
                    Span(self.saleFolio)
                    
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
            }
            .class(.oneHalf)
            
        }
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 12.px)
        .width(50.percent)
        .left(25.percent)
        .top(20.percent)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        id("paymentConfirmationView")
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if configStore.printPdv.document == .miniprinter {
            
            printTicket()
            
        }
        else{
            
            let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") +
            "&ie=printPDVSale&id=" + self.saleId.uuidString
            
            print(url)
            
            _ = JSObject.global.goToURL!(url)
            
        }
        
    }
    
    func facturar(){
        
        guard let accountid else{
            
            let view = SearchCustomerQuickView { account in
                
                self.accountid = account.id
                self.accountFolio = account.folio
                self.accountName = "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces
                
                self.facturar()
                
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
                            
                            self.accountid = account.id
                            self.accountFolio = account.folio
                            self.accountName = "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces
                            
                            self.facturar()
                            
                        }

                        self.appendChild(custDataView)
                        
                    }))
            }

            addToDom(view)
            
            return
        }
        
        loadingView(show: true)
        
        API.custAccountV1.load(id: .id(accountid)) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, "No se obtuvo datos de la cuenta.")
                return
            }
            
            guard let account = resp.data?.custAcct else {
                showError(.unexpectedResult, "No se localizo cuenta")
                return
            }
            
            let view = ToolFiscal(
                loadType: .sale(id: self.saleId),
                folio: self.saleFolio,
                callback: { id, folio, pdf, xml in
                    
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
    }
    
    func printTicket(){
        
        loadingView(show: true)
        
        API.custPDVV1.getSale(saleId: .id(self.saleId)) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, "No se pudo comunicar con servidor para imprimir documento")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, "No se pudo comunicar con servidor para imprimir documento")
                return
            }
            
            guard let payload = resp.data else {
                return
            }
            
            let printBody = PDVPrintEngine(
                custAcct: payload.custAcct,
                custSale: payload.custSale,
                custPOCInventory: payload.custPOCInventory,
                custPurchesOrder: payload.custPurchesOrder,
                custPickUpOrder: payload.custPickUpOrder,
                pocs: payload.pocs,
                inventory: payload.inventory,
                charges: payload.charges,
                cardex: payload.cardex
            ).innerHTML
            
            var purRefs = "{}"
            var _purRefs: [String:String] = [:]
            
            var pickRef = "{}"
            var _pickRef: [String:String] = [:]
            
            payload.custPurchesOrder.forEach { item in
                _purRefs[item.id.uuidString] = item.folio
            }
            
            payload.custPickUpOrder.forEach { item in
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
            _ = JSObject.global.renderSalePrint!(custCatchUrl, payload.custSale.folio, printBody, purRefs, pickRef)

        }
        
    }
    
    func sendSaleByMessage(){

        /*
        guard accountid != nil else {
            searchAccount()
            return
        }
        */

        let view = ConfirmMobilePhone(term: "" ){ mobile in


            loadingView(show: true)


            let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") +
                    "&ie=sendPDVSale" +
                    "&id=" + self.saleId.uuidString + 
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

    func searchAccount(){

        let view = SearchCustomerQuickView { account in
            self.accountid = account.id
            self.accountFolio = account.folio
            self.accountName =  "\(account.businessName) \(account.firstName) \(account.firstName)"
            self.sendSaleByMessage()
        } create: { term in
            // No customer, create customer.
            addToDom(CreateNewCusomerView(
                searchTerm: term,
                custType: .general,
                callback: { acctType, custType, searchTerm in
                    
                    let custDataView = CreateNewCustomerDataView(
                        acctType: acctType,
                        custType: custType,
                        orderType: nil,
                        searchTerm: searchTerm
                    ) { account in

                        self.accountid = account.id
                        self.accountFolio = account.folio
                        self.accountName =  "\(account.businessName) \(account.firstName) \(account.firstName)"

                        self.linkSaleToAccount(accointId: account.id)

                    }

                    self.appendChild(custDataView)
                    
                }))
        }

        addToDom(view)

    }

    func linkSaleToAccount(accointId: UUID){
        
    }



}
