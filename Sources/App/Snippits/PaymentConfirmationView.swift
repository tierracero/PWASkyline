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

    @State var accountMobile: String?
    
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
        accountName: String?,
        accountMobile: String?,
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
        self.accountMobile = accountMobile
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
    
    var customeScripts: [CustomerCustomeScript] = []

    @State var customeScriptListener: String = ""
    
    lazy var customeScriptSelect = Select(self.$customeScriptListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .body {
            Option("Seleccioen Opción")
            .value("")
        }
    
    
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
    .width(45.percent)
    .float(.left)
    
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
 // 
                Div{

                    Div{
                        self.customeScriptSelect
                    }
                    .hidden(self.customeScripts.isEmpty)
                    .width(45.percent)
                    .float(.left)

                    Div {
                        Strong("Imprimir")
                            .fontSize(24.px)
                            .color(.highlighBlue)
                    }
                    .cursor(.pointer)
                        .class(.smallButtonBox)
                        .width(45.percent)
                        .float(.left)
                        .onClick {

                            if !self.customeScriptListener.isEmpty {

                                guard let id = UUID(uuidString: self.customeScriptListener) else {
                                    showError(.generalError, "No se obtuvo id del script.")
                                    return
                                }
                                
                                self.customePrint(scriptId: id, folio: self.saleFolio)

                                return

                            } 
                            
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

                    Div {
                        
                        Img()
                        .src("/skyline/media/whatsapp.png")
                        .marginRight(12.px)
                        .height(24.px)
                        .width(24.px)
                        
                        Strong("Enviar")
                            .fontSize(24.px)
                            .color(.highlighBlue)
                    }
                    .class(.smallButtonBox)
                    .width(45.percent)
                    .cursor(.pointer)
                    .float(.left)
                    .onClick {
                        self.sendSaleByMessage()    
                    }

                    self.fiscalDiv

                    Div().clear(.both)

                }
                
                Div().clear(.both)

                
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
        
        id("paymentConfirmationView")
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if configStore.printPdv.button == .direct {

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

        WebApp.shared.skyline.customeScripts.forEach { script in

            if script.type == .saleCreated {
                customeScripts.append(script)

                customeScriptSelect.appendChild(
                    Option(script.name)
                        .value(script.id.uuidString)
                )
            }

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

                        addToDom(custDataView)
                        
                    }))
            }

            addToDom(view)
            
            return
        }
        
        loadingView.show()
        
        API.custAccountV1.load(id: .id(accountid)) { resp in
            
            loadingView.hide()
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.generalError, "No se obtuvo datos de la cuenta.")
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
        
        loadingView.show()
        
        API.custPDVV1.getSale(saleId: .id(self.saleId)) { resp in
            
            loadingView.hide()
            
            guard let resp else {
                showError(.comunicationError, "No se pudo comunicar con servidor para imprimir documento")
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, "No se pudo comunicar con servidor para imprimir documento")
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

        let view = ConfirmMobilePhone(term: self.accountMobile ?? "" ){ mobile in


            loadingView.show()


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
                .setRequestHeader("WSId", custCatchChatConnID)
            
            if let jsonData = try? JSONEncoder().encode(APIHeader(
                AppID: thisAppID,
                AppToken: thisAppToken,
                url: custCatchUrl,
                user: custCatchUser,
                mid: custCatchMid,
                key: custCatchKey,
                token: custCatchToken,
                tcon: .web, 
                applicationType: custCatchAccountType.sessionType
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

                loadingView.hide()

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

                    addToDom(custDataView)
                    
                }))
        }

        addToDom(view)

    }

    func linkSaleToAccount(accointId: UUID){
        
    }

    func customePrint(scriptId: UUID, folio: String) {

            API.custAPIV1.customePrintEngine(
                storeId: custCatchStore,
                scriptId: scriptId,
                fileName: "venta_\(folio).pdf",
                payload: .saleCreated(saleId)
            ) { resp in

                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, "No se obtuvo datos de la cuenta.")
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpectedMissingPayload)
                    return
                }

                let url = baseAPIUrl("https://api.tierracero.co/cust/v1/customePrintDownloader") +
                "&file=" + payload.fileName
                
                print(url)

                _ = JSObject.global.goToURL!(url)

            }
            
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $saleId.removeAllListeners()
        $saleFolio.removeAllListeners()
        $accountid.removeAllListeners()
        $accountFolio.removeAllListeners()
        $accountName.removeAllListeners()
        $accountMobile.removeAllListeners()
    }
}



// {"fileName":"venta_sabo01-5003_1792511438.pdf","configGeneral":{"docuGoodbye":"despues de 30 dias no nos hacemos responsables por aparatos que no sean reclamados en su momento A","thirdPDFBg":"","docuWelcome":"Gracias por tu enorme confianza, recuerda darnos un like en facebook.com\/TierraCero Recuerda ver bien el diseño ya que autorizado e impreso no podrá haber devoluciones.","followUpMail":"default","techPDFBg":"","defaultEmail":"no-responder@tierracero.com","autoFileOrderDays":30,"sendSMSSale":true,"autoCalculatePrepareDays":2,"autoCalculateAverage":90,"autoCalculateSaleUnits":6,"pdfColor":"azul","thirdPage":true,"docuMail":"Gracias por tu enorme confianza, recuerda darnos un like en facebook.com\/TierraCero Recuerda ver bien el diseño ya que autorizado e impreso no podrá haber devoluciones.","autoCalculateOfDates":true,"sendSecondaryMail":false,"custPDFBg":"","autoCalculateOrderUnits":6,"promoPage":true,"autoCalculateAdminUnits":6,"autoCalculateRentalUnits":6,"autoFileOrder":true,"sendSMSNewOrder":true,"sendSMSWaitingForReplacement":true,"pdfType":"customerCopy","promoPDFBg":"","sendSMSContinieFRomReplacement":true,"docuThirdTerm":"","sendSMSFinishedOrder":true,"docuSecondTerm":"","imageWaterMark":"","docuMoreTerm":true,"docuFirstTerm":""},"configContactTags":{"requireInstituteTag":true,"salesContact":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D","requirePhysicalAddress":false,"instituteTag":"none","requierMailingAddrees":false,"customerType":"customer","requierServiceAddress":false,"sendNewBusinessAccountComunication":true,"operationalContact":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D","finacialContact":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D"},"cardex":[],"logos":{"logoIndexIcon":{"objectType":"logoIndexIcon","file":"iconjgjvobkog320190919.png","lang":"Spanish","modifiedAt":1601863351,"isAvatar":true,"description":"","id":"544283F6-36E8-486C-B664-704177D9DCD2","createdAt":1601863351,"avatar":"iconjgjvobkog320190919.png","files":"[\"iconjgjvobkog320190919.png\"]","type":"img","height":799,"descr_en":"","width":797},"logoIndexWhiteTrans":{"objectType":"logoIndexWhiteTrans","file":"logo_black_trans2me-bwek8-20190919.png","lang":"Spanish","modifiedAt":1601863351,"isAvatar":true,"description":"","id":"5B3BF29F-73F9-4C8E-8297-0CB696C6B2F9","createdAt":1601863351,"avatar":"logo_black_trans2me-bwek8-20190919.png","files":"[\"logo_black_trans2me-bwek8-20190919.png\"]","type":"img","height":129,"descr_en":"","width":808},"logoIndexMain":{"objectType":"logoIndexMain","file":"logo_black8gwi-xk7w220190919.png","lang":"Spanish","modifiedAt":1601863351,"isAvatar":true,"description":"","id":"CC8258C3-0C0E-4E7D-BA08-6514F3F8ABDA","createdAt":1601863351,"avatar":"logo_black8gwi-xk7w220190919.png","files":"[\"logo_black8gwi-xk7w220190919.png\"]","type":"img","height":119,"descr_en":"","width":751},"logoIndexBlack":{"objectType":"logoIndexBlack","file":"logo_whiteif7wz-sglb20190919.png","lang":"Spanish","modifiedAt":1601863351,"isAvatar":true,"description":"","id":"6DF99DA7-11E0-43F2-B863-C0C8E475D1D6","createdAt":1601863351,"avatar":"logo_whiteif7wz-sglb20190919.png","files":"[\"logo_whiteif7wz-sglb20190919.png\"]","type":"img","height":120,"descr_en":"","width":751},"logoIndexBlackTrans":{"objectType":"logoIndexBlackTrans","file":"logo_white_transux_nccisqc20190919.png","lang":"Spanish","modifiedAt":1601863351,"isAvatar":true,"description":"","id":"40553385-B4B6-490C-8684-D3558804C277","createdAt":1601863351,"avatar":"logo_white_transux_nccisqc20190919.png","files":"[\"logo_white_transux_nccisqc20190919.png\"]","type":"img","height":119,"descr_en":"","width":751},"logoIndexWhite":{"objectType":"logoIndexWhite","file":"logo_black_nsahyztp220190919.png","lang":"Spanish","modifiedAt":1601863351,"isAvatar":true,"description":"","id":"F743A14F-593D-4402-8EA6-E1290AFC2132","createdAt":1601863351,"avatar":"logo_black_nsahyztp220190919.png","files":"[\"logo_black_nsahyztp220190919.png\"]","type":"img","height":119,"descr_en":"","width":751}},"commissions":[{"createdBy":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D","rel":"87024841-5E9D-4D76-9FAA-DA3CE64F621B","type":"poc","groop":"5ADAC259-ECC6-41D8-AFA1-4530F27BEEFB","createdAt":1792511415,"payableAt":1792511415,"owner":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D","modifiedAt":1792511415,"store":"4BD7A2F9-F304-4543-A1C8-57B3C1EB83AA","id":"8F0338EE-74A0-4297-935E-F611EC4F9378","status":"unpaid","saleType":"pos","amount":588,"saleRelacion":"2CD9DEFB-C1DE-42C8-A0A6-0BC31A803F18"}],"pocs":{"87024841-5E9D-4D76-9FAA-DA3CE64F621B":{"reqSeries":true,"tagTwo":"Bbbb","status":"active","pseudoName":"camion ejemplo modelo4a q25-4-lypdpkyl","inCredit":false,"name":"Camion","pricecr":1000,"pricec":4900,"tagOne":"Aaa","pricea":5900,"fiscCode":"60131001","id":"87024841-5E9D-4D76-9FAA-DA3CE64F621B","pseudoModel":"Q25-4-LYPDPKYL","upc":"102030A","fiscUnit":"H87","cost":1000,"priceb":5900,"brand":"Ejemplo","avatar":"unnamed_1744421171.jpg","tagThree":"Ccc","model":"MODELO4A"}},"charges":[],"store":{"id":"4BD7A2F9-F304-4543-A1C8-57B3C1EB83AA","schedulec":"","telephone":"33180000077","city":"victoria","lon":"-99.18412284849258","email":"nomail@uahoo.cpm","schedulea":"","state":"tamaulipas","zip":"87060","status":"active","custUsername":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D","scheduleb":"","isPublic":false,"mobile":"","modifiedAt":1790873686,"balance":0,"name":"Coca Cola","mainStore":false,"colony":"luis echeveria","storePrefix":"bo01","isFiscalable":false,"country":"mexico","storeType":"warehouse","createdAt":1789499846,"lat":"23.711529920472767","street":"Arroyo Carizal m12 l 230"},"inventory":{"43FBCFD3-A69B-4CD4-9062-69DACCC45B29":{"soldAt":1792511415,"soldType":"pdv","modifiedAt":1792511415,"warentSelfTo":1835711415,"series":"","premierPoints":0,"warentFabricTo":3140351415,"POC":"87024841-5E9D-4D76-9FAA-DA3CE64F621B","fiscCode":"60131001","id":"43FBCFD3-A69B-4CD4-9062-69DACCC45B29","custFolio":"2CD9DEFB-C1DE-42C8-A0A6-0BC31A803F18","cost":1000,"fiscUnit":"H87","custStoreBodegas":"CF529CF8-14BA-4DBA-B5A8-62674AC417D5","comision":0,"custStore":"4BD7A2F9-F304-4543-A1C8-57B3C1EB83AA","custStoreSecciones":"B280B707-E112-4FE6-B5D7-42CA321316CA","points":0,"taxes":"{\"trasladado\":{\"iva\":{\"code\":\"002\",\"amount\":0.16}}}","soldPrice":5900}},"account":{"sms":150,"street":"C. Rio Carrizal","deposit":200,"oriSEO":false,"identificationNumber":"pend","oriApps":false,"lastName":"Cantu","curp":"","modifiedAt":1696946368,"agent":"7E8EAC9D-3F10-4A8A-B372-788321DDE73A","status":"active","mobile":"4939598690","folio":"79086","city":"Ciudad Victoria","lon":"","fiscType":0,"nombreNegocio":"Tierra Cero","mrc":98,"razonSocial":"Victor Alejandro Cantu Martinez","sitio":"tierrace_tcs_tierracero_com","fiscContactFirstName":"","title":"","zip":"Tamaulipas","genContactFirstName":"","genContactLastName":"","colony":"Col. Luis Echeverria","fiscContactLastName":"","balance":10,"asl":300,"secondLastName":"Martinez","subType":"","pwa":"base","genContactMobile":"","genContactTitle":"","typeOfDevelopment":"general","reqFiscal":false,"credits":99,"store":"1E29B564-A982-4200-84BF-5CA4E0A65999","pin":"2872","payCode":"","accountType":"buisness","username":"vcantu01@tierracero.com","url":"tierracero.com","rfc":"CAMV840323AJ6","typeOfTechnology":"appSwiftPhp","lat":"","pDir":"kviU","firstName":"Victor","country":"Mexico","accountsType":"buisness","identification":"votersCard","id":"026C9814-DB27-4E65-9FB8-D2C62B65E888","rfc_personal":"CAMV840323","fiscal":"5486D349-241E-4360-BFFB-9489D7FCCDF1","vip":false,"email":"alex_mar@msn.com","createdAt":1368936000,"nss":"","oriDesighn":false,"sexo":"male","mode":"serviceOrder","fiscContactMobile":"","telephone":"4939598690","password":"","secondName":"Victor","idFront":"","subdomain":"tierracero.com","state":"84060","type":"Servicios","fiscContactTitle":"","storage":0,"idBack":"","billDate":25,"customerValue":10,"payDate":1492041599},"type":"saleCreated","custPOCInventory":[{"soldAt":1792511415,"soldType":"pdv","modifiedAt":1792511415,"warentSelfTo":1835711415,"series":"","premierPoints":0,"warentFabricTo":3140351415,"POC":"87024841-5E9D-4D76-9FAA-DA3CE64F621B","fiscCode":"60131001","id":"43FBCFD3-A69B-4CD4-9062-69DACCC45B29","custFolio":"2CD9DEFB-C1DE-42C8-A0A6-0BC31A803F18","cost":1000,"fiscUnit":"H87","custStoreBodegas":"CF529CF8-14BA-4DBA-B5A8-62674AC417D5","comision":0,"custStore":"4BD7A2F9-F304-4543-A1C8-57B3C1EB83AA","custStoreSecciones":"B280B707-E112-4FE6-B5D7-42CA321316CA","points":0,"taxes":"{\"trasladado\":{\"iva\":{\"code\":\"002\",\"amount\":0.16}}}","soldPrice":5900}],"configStore":{"print":{"button":"direct","document":"letter","image":"none","lineBreak":0},"operationType":"internal","schedule":{"sunday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900},"tuesday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900},"friday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900},"saturday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900},"wednesday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900},"monday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900},"thursday":{"type":"followed","start":830,"lucheEnd":1500,"workDay":true,"lucheStart":1400,"end":1900}},"printPdv":{"button":"direct","document":"letter","image":"none","lineBreak":0},"priceModifierOrder":0,"priceModifierPdv":0,"lockedInventory":true},"custSale":{"saleType":"pos","custAcct":"9C232055-432D-4397-83A6-36EDF0425308","comments":"","total":5900,"balance":0,"status":"unbilled","modifiedAt":1792511415,"alerted":false,"pickupOrder":[],"id":"2CD9DEFB-C1DE-42C8-A0A6-0BC31A803F18","createdAt":1792511415,"folio":"sabo01-5003","createdBy":"1B277792-CD7F-4D3B-B534-F8AA078BEE4D","fiscalDocumentStatus":"unrequest","custStore":"4BD7A2F9-F304-4543-A1C8-57B3C1EB83AA","highPriority":false,"fiscalDocumentBalance":0,"pendingPickup":false}}