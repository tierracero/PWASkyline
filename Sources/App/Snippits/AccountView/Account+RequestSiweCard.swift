//
//  Account+RequestSiweCard.swift
//  
//
//  Created by Victor Cantu on 9/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

extension AccountView {
    
    class RequestSiweCard: Div {
        
        override class var name: String { "div" }
        
        @State var accountId: UUID?
        
        let cc: Countries
        
        @State var mobile: String
        
        private var callback: ((
            _ token: String,
            _ cardId: String,
            _ custAcct: CustAcctSearch?
        ) -> ())
        
        private var bypassProgram: ((
        ) -> ())?
        
        init(
            accountId: UUID?,
            cc: Countries,
            mobile: String,
            callback: @escaping ((
                _ token: String,
                _ cardId: String,
                _ custAcct: CustAcctSearch?
            ) -> ()),
            bypassProgram: ((
            ) -> ())? = nil
        ) {
            self.accountId = accountId
            self.cc = cc
            self.mobile = mobile
            self.callback = callback
            self.bypassProgram = bypassProgram
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var orderCloseInscriptionMode: ConfirmationMode = .notrequired
        
        @State var cardId = ""
        
        var custAcct: CustAcctSearch? = nil
        
        ///Countries
        @State var countriesListener = ""
        
        lazy var cardIdField = InputText(self.$cardId)
            .custom("width", "calc(100% - 80px)")
            .placeholder("Numero de Tarjeta")
            .class(.textFiledBlackDarkLarge)
            .outlineWidth(.init("0"))
            .fontSize(23.px)
            .float(.left)
        
        lazy var mobileField = InputText(self.$mobile)
            .class(.textFiledBlackDarkLarge)
            .placeholder("Celular")
            .width(90.percent)
            .marginRight(7.px)
            .fontSize(23.px)
            .disabled(true)
        
        lazy var countriesSelect = Select(self.$countriesListener)
            .class(.textFiledBlackDarkLarge)
            .borderRadius(12.px)
            .width(95.percent)
            .fontSize(23.px)
            .marginTop(3.px)
        
        // Create Account Detal
        
        @State var firstName: String = ""
        
        @State var lastName: String = ""
        
        lazy var firstNameField = InputText(self.$firstName)
            .custom("width", "calc(100% - 21px)")
            .placeholder("Primer Nombre")
            .class(.textFiledBlackDarkLarge)
            .outlineWidth(.init("0"))
            .fontSize(23.px)
        
        lazy var lastNameField = InputText(self.$lastName)
            .custom("width", "calc(100% - 21px)")
            .placeholder("Primer Apellido")
            .class(.textFiledBlackDarkLarge)
            .outlineWidth(.init("0"))
            .fontSize(23.px)
        
        @State var searchMobileViewIsHidden = true
        
        @State var results: [CustAcctSearch] = []
        
        @State var searchMobileTerm = ""
        
        lazy var searchMobileTermField = InputText(self.$searchMobileTerm)
            .custom("width", "calc(100% - 18px)")
            .placeholder("8001231234")
            .class(.textFiledBlackDarkLarge)
            .outlineWidth(.init("0"))
            .fontSize(36.px)
            .height(52.px)
            .float(.left)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onKeyUp { tf, event in
                
                if ignoredKeys.contains(tf.text) {
                    return
                }
                
                let term = tf.text
                
                Dispatch.asyncAfter(0.3) {
                    if term != tf.text {
                        return
                    }
                    self.searchCustomer()
                }
                
            }
        
        lazy var noResultDiv = Div{
            Table{
                Tr{
                    Td(self.$searchMobileTerm.map{ $0.isEmpty ? "Ingrese busqueda..." : "No hay resultados \"\($0)\"" })
                        .verticalAlign(.middle)
                        .align(.center)
                        .color(.white)
                }
            }
            .width(100.percent)
            .height(100.px)
        }
            .class(.roundDarkBlue)
            .overflow(.hidden)
        
        lazy var resultDiv = Div()
            .class(.roundDarkBlue)
            .overflow(.auto)
            .height(200.px)
        
        lazy var searchView = Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.searchMobileViewIsHidden = true
                    }
                
                H2("⭐️ Activar Recompensas")
                    .color(.yellowTC)
            }
            
            Div().clear(.both).height(7.px)
            
            H2{
                Span("Buscar Clientes")
                    .marginRight(7.px)
                
                Span("Ingrese Celular")
                    .color(.lightGray)
                
            }
                .color(.white)
            
            Div().clear(.both).height(7.px)
            
            // https://www.instagram.com/reel/C2217dHOBgS/?igsh=bzJocXh0NGc1NjB6
            
            self.searchMobileTermField
            
            Div().clear(.both).height(7.px)
            
            self.noResultDiv
                .hidden(self.$results.map{ !$0.isEmpty })
            
            self.resultDiv
                .hidden(self.$results.map{ $0.isEmpty })
            
            Div().clear(.both).height(3.px)
            
            Div{
                
                Div("Crear Cliente")
                    .class(.uibtnLargeOrange)
                    .float(.left)
                    .onClick {
                        self.createCustomer()
                    }
                
                Div("Buscar Cliente")
                    .class(.uibtnLarge)
                    .float(.right)
                    .onClick {
                        self.searchCustomer()
                    }
            }
            
            Div().clear(.both).height(7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 225px)")
        .custom("top", "calc(50% - 150px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(450.px)
        
        @DOM override var body: DOM.Content {
            
            Div{
                Div{
                    
                    /// Header
                    Div {
                        
                        Img()
                            .closeButton(.uiView2)
                            .onClick{
                                self.remove()
                            }
                        
                        H2("Solicitar PIN")
                            .color(.lightBlueText)
                    }
                    
                    Div{
                        
                       Div("Numero de Tarjeta")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        Div{
                            Span("sw-")
                                .marginRight(7.px)
                                .color(.lightGray)
                                .marginLeft(7.px)
                                .marginTop(3.px)
                                .float(.left)
                            
                            self.cardIdField
                            
                            Div().clear(.both)
                        }
                        .class(.textFiledBlackDarkLarge)
                        .borderRadius(12.px)
                        .padding(all: 7.px)
                        .marginRight(7.px)
                        .fontSize(23.px)
                        
                        Div{
                            Div{
                                Div("Primer Nombre")
                                    .marginBottom(3.px)
                                    .color(.white)
                                
                                self.firstNameField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                Div("Primer Apellido")
                                    .marginBottom(3.px)
                                    .color(.white)
                                    
                                self.lastNameField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }
                        .marginTop(7.px)
                        .hidden(self.$accountId.map{ $0 != nil })
                        
                        Div("Confirmar Celular SMS")
                            .marginBottom(3.px)
                            .marginTop(7.px)
                            .color(.white)
                        
                        Div{
                            Div{
                                self.countriesSelect
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                self.mobileField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div{
                            
                            if let bypassProgram = self.bypassProgram {
                                
                                Div{
                                    Div("Continuar")
                                        .fontSize(16.px)
                                    
                                    Div("Sin Recompensa")
                                        .fontSize(14.px)
                                        .color(.gray)
                                }
                                .hidden(self.$orderCloseInscriptionMode.map{ $0 == .required })
                                .class(.uibtnLarge)
                                .textAlign(.center)
                                .marginBottom(3.px)
                                .marginTop(7.px)
                                .float(.left)
                                .onClick {
                                    bypassProgram()
                                    self.remove()
                                }
                            }
                            
                            
                            Div("Enviar SMS")
                                .class(.uibtnLargeOrange)
                                .textAlign(.center)
                                .marginBottom(3.px)
                                .marginTop(7.px)
                                .float(.right)
                                .onClick {
                                    self.solicitarPIN()
                                }
                            
                            Div().clear(.both)
                        }
                        .align(.right)
                            
                    }
                    .padding(all: 7.px)
                    
                }
                .margin(all: 7.px)
            }
            .custom("top", { (self.accountId == nil) ? "calc(50% - 130px)" : "calc(50% - 100px)" }())
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 175px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(350.px)
            
            Div{
                self.searchView
            }
            .hidden(self.$searchMobileViewIsHidden)
            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .left(0.px)
            .top(0.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            Countries.allCases.forEach { country in
                
                countriesSelect.appendChild(
                    Option("+\(country.code) \(country.description)")
                        .value(country.code.toString)
                )
                
            }
            
            countriesListener = "52"
            
            $results.listen {
                
                self.resultDiv.innerHTML = ""
                
                $0.forEach { prof in
                    
                    //
                    
                    self.resultDiv.appendChild(
                        Div{
                            
                            Div{
                                
                                Div("\(prof.fiscalRfc) \(prof.fiscalRazon) \(prof.businessName)".purgeSpaces)
                                    .class(.oneLineText)
                                    .fontSize(18.px)
                                
                                Div("\(prof.firstName) \(prof.lastName)")
                                    .class(.oneLineText)
                                    .fontSize(23.px)
                                
                            }
                            .custom("width", { prof.CardID.isEmpty ? "100%" : "calc(100% - 50px)" }() )
                            .float(.left)
                            
                            if !prof.CardID.isEmpty {
                                
                                Div{
                                    Table{
                                        Tr{
                                            Td{
                                                Img()
                                                    .src("skyline/media/star_yellow.png")
                                                    .width(18.px)
                                            }
                                            .verticalAlign(.middle)
                                            .align(.center)
                                        }
                                    }
                                    .height(100.percent)
                                }
                                .width(50.px)
                                .float(.left)
                                
                            }
                            
                        }
                        .width(96.percent)
                        .class(.uibtnLarge)
                        .onClick {
                            
                            if !prof.CardID.isEmpty {
                                
                                /// Selected customer already has  reward active
                                self.callback(
                                    "",
                                    prof.CardID,
                                    prof
                                )
                                
                                self.remove()
                                
                                return
                                
                            }
                            
                            self.accountId = prof.id
                            
                            self.custAcct = prof
                            
                            self.mobile = prof.mobile
                            
                            self.searchMobileTerm = ""
                            
                            self.results = []
                            
                            self.searchMobileViewIsHidden = true
                            
                            self.cardIdField.select()
                            
                        }
                    )
                }
                
                if $0.isEmpty {
                    self.searchView
                        .custom("top", "calc(50% - 150px)")
                }
                else{
                    self.searchView
                        .custom("top", "calc(50% - 200px)")
                }
                
            }
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            if let _ = accountId {
                self.cardIdField.select()
            }
            else {
                
                self.searchMobileViewIsHidden = false
                
                self.searchMobileTermField.select()
                
            }
            
        }
        
        func solicitarPIN() {
            
            guard let accountId else {
                
                if !self.mobile.isEmpty {
                    
                    if firstName.isEmpty {
                        showError(.errorGeneral, "Ingrese Primer Nombre")
                        return
                    }
                    
                    if lastName.isEmpty {
                        showError(.errorGeneral, "Ingrese Primer Apellido")
                        return
                    }
                    
                    loadingView(show: true)
                    
                    API.custAPIV1.createCustAcct(
                        CardID: "",
                        firstName: firstName.purgeSpaces,
                        secondName: "",
                        lastName: lastName.purgeSpaces,
                        secondLastName: "",
                        email: "",
                        mobile: self.mobile.purgeSpaces,
                        telephone: "",
                        birthDay: nil,
                        birthMonth: nil,
                        birthYear: nil,
                        sexo: nil,
                        IDType: nil,
                        IDNum: "",
                        type: .personal,
                        costType: .cost_a,
                        isConcessionaire: false,
                        contacto1: "",
                        contacto2: "",
                        contactTel: "",
                        contactMail: "",
                        fiscalPOCFirstName: "",
                        fiscalPOCLastName: "",
                        fiscalPOCMobile: "",
                        fiscalPOCMail: "",
                        businessName: "",
                        fiscalRecipt: false,
                        fiscalRazon: "",
                        fiscalRfc: "",
                        street: "",
                        colony: "",
                        city: "",
                        state: "",
                        country: "",
                        zip: "",
                        mailStreet: "",
                        mailColony: "",
                        mailCity: "",
                        mailState: "",
                        mailCountry: "",
                        mailZip: "",
                        mobileIsValidated: false,
                        idIsValidated: false,
                        billDate: nil
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
                        
                        guard let account = resp.data?.custAcct else {
                            showError(.unexpectedResult, .unexpenctedMissingPayload)
                            return
                        }
                        
                        self.accountId = account.id
                        
                        self.custAcct = .init(
                            id: account.id,
                            folio: account.folio,
                            businessName: account.businessName,
                            costType: account.costType,
                            type: account.type,
                            firstName: account.firstName,
                            lastName: account.lastName,
                            mcc: account.mcc,
                            mobile: account.mobile,
                            email: account.email,
                            street: account.street,
                            colony: account.colony,
                            city: account.city,
                            state: account.state,
                            zip: account.zip,
                            country: account.country,
                            autoPaySpei: account.autoPaySpei,
                            autoPayOxxo: account.autoPayOxxo,
                            fiscalProfile: account.fiscalProfile,
                            fiscalRazon: account.fiscalRazon,
                            fiscalRfc: account.fiscalRfc,
                            fiscalRegime: account.fiscalRegime,
                            fiscalZip: account.fiscalZip,
                            cfdiUse: account.cfdiUse,
                            CardID: account.CardID,
                            rewardsLevel: account.rewardsLevel,
                            crstatus: account.crstatus,
                            isConcessionaire: account.isConcessionaire,
                            highPriorityNotes: nil
                        )
                        
                        self.solicitarPIN()
                        
                    }
                    
                }
                else {
                    
                    self.searchMobileViewIsHidden = false
                    
                    self.searchMobileTermField.select()
                    
                    showError(.errorGeneral, "Seleccione cuenta para iniciar")
                    
                }
                
                return
            }
            
            if cardId.isEmpty {
                showError(.errorGeneral, "Ingrese Numero de Tarjeta")
                cardIdField.select()
                return
            }
            
            guard let int = Int(countriesListener) else {
                showError(.errorGeneral, "Seleccione Codigo de Pais")
                return
            }
            
            guard let cc = Countries(rawValue: int) else {
                showError(.errorGeneral, "Seleccione Codigo de Pais Valido")
                return
            }
            
            if mobile.isEmpty {
                showError(.errorGeneral, "Ingrese Numero Movil")
                cardIdField.select()
                return
            }
            
            guard mobile.count == 10 else {
                showError(.errorGeneral, "1ngrese Numero Movil a 10 Digitos")
                return
            }
            
            guard let _ = Int64(mobile) else {
                showError(.errorGeneral, "Ingrese Numero Movil Valido")
                return
            }
            
            var _cardId = cardId
            
            if !_cardId.hasPrefix("sw-") && !_cardId.hasPrefix("SW-") {
                _cardId = "sw-\(_cardId)"
            }
            
            loadingView(show: true)
            
            API.custAccountV1.requestSiweCard(
                custAcct: accountId,
                cardId: _cardId,
                cc: cc,
                mobile: mobile
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else{
                    showError(.errorDeCommunicacion, "Error de comunicación")
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.callback(payload.token, _cardId, self.custAcct)
                
                self.remove()
                
            }
        }
        
        func createCustomer() {
            
            let term = searchMobileTerm.purgeSpaces
            
            if term.isEmpty {
                showError(.formatoInvalido, "Ingrese celular.")
                searchMobileTermField.select()
                return
            }
            
            guard let _ = Int64(term) else {
                showError(.formatoInvalido, "Ingrese celular valido.")
                searchMobileTermField.select()
                return
            }
            
            guard term.count == 10 else {
                showError(.formatoInvalido, "Ingrese celular a 10 digitos.")
                searchMobileTermField.select()
                return
            }
            
            self.mobile = term
            
            self.searchMobileTerm = ""
            
            self.results = []
            
            self.searchMobileViewIsHidden = true
            
            self.cardIdField.select()
            
        }
        
        func searchCustomer(){
            
            let term = searchMobileTerm.purgeSpaces
            
            if term.isEmpty {
                return
            }
            
            if let _ = Int64(term) {
                if term.count < 5 {
                    return
                }
            }
            else{
                if term.count < 4 {
                    return
                }
            }
            
            self.searchMobileTermField
                .class(.isLoading)
            
            searchAccount(term: term) { _term, resp in
                
                self.searchMobileTermField
                    .removeClass(.isLoading)
                
                if self.searchMobileTerm != _term {
                    return
                }
                
                self.results = resp
                
            }
            
        }
        
    }
}

