//
//  SearchVendorView.swift
//  
//
//  Created by Victor Cantu on 11/21/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/// Searches and registes vendors
class SearchVendorView: Div {
    
    override class var name: String { "div" }
    
    @State var id : UUID?
    
    var vendor: CustVendorsQuick?
    
    private var callback: (
        (_ account: CustVendorsQuick) -> ()
    )
    
    init(
        loadBy: SearchVendorViewLoader?,
        callback: @escaping ((
            _ account: CustVendorsQuick
        ) -> ())
    ) {
       
        if let loadBy {
            
            print("⭐️ sill try to loadBy")
            switch loadBy {
            case .id(let id):
                print("⭐️ id ")
                self.id = id
                self.vendor = nil
            case .account(let vendor):
                print("⭐️ vendor ")
                self.id = vendor.id
                self.vendor = vendor
            }
        }
        else{
            
            print("🤯 no loadBy provided")
            
            self.id = nil
            self.vendor = nil
        }
        
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""
    
    @State var results: [CustVendorsQuick] = []
    
    @State var createAccountViewIsHidden: Bool = true
    
    @State var businessName: String = ""
    
    @State var firstName: String = ""
    
    @State var lastName: String = ""
    
    @State var rfc: String = ""
    
    @State var razon: String = ""
    
    @State var email: String = ""
    
    @State var fiscalPOCMobile: String = ""
    
    @State var mobile: String = ""
    
    @State var creditDays: String = "0"
    
    lazy var seachVendorField = InputText(self.$term)
        .custom("width","calc(100% - 210px)")
        .placeholder("Mobile, RFC, correo, razon...")
        .class(.textFiledBlackDark)
        .marginRight(7.px)
        .height(29.px)
        .float(.left)
        .onKeyUp { tf, event in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.search()
            }
        }
    
    lazy var noResultDiv = Div{
        Table{
            Tr{
                Td(self.$term.map{ $0.isEmpty ? "Ingrese busqueda..." : "No hay resultados \"\($0)\"" })
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.white)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
        .custom("height","calc(100% - 70px)")
        .class(.roundDarkBlue)
        .overflow(.hidden)
    
    lazy var resultDiv = Div()
        .custom("height","calc(100% - 70px)")
        .class(.roundDarkBlue)
        .overflow(.auto)
    
    lazy var businessNameInput = InputText(self.$businessName)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Nombre de la empresa")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
    
    lazy var firstNameInput = InputText(self.$firstName)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Nombre (contacto)")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
    
    lazy var lastNameInput = InputText(self.$lastName)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Apellido (contacto)")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
    
    lazy var emailInput = InputText(self.$email)
        .class(.textFiledBlackDarkLarge)
        .placeholder("contacto@corro.com")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
        .onBlur { tf in
            
            self.email = self.email.purgeSpaces.lowercased()
            
            if tf.text.isEmpty {
                
                tf
                    .removeClass(.isOk)
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                return
            }
            
            tf
                .removeClass(.isOk)
                .removeClass(.isNok)
                .class(.isLoading)
            
            API.custAPIV1.checkFreeVendorEmail(
                email: tf.text,
                accountid: nil
            ) { resp in
                
                tf.removeClass(.isLoading)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, "No se recivio payload")
                    return
                }
                
                if data.free {
                    tf.class(.isOk)
                }
                else{
                    tf.class(.isNok)
                }
                
            }
            
        }

    lazy var rfcInput = InputText(self.$rfc)
        .class(.textFiledBlackDarkLarge)
        .placeholder("RFC")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
        .onBlur { tf in
            
            self.rfc = self.rfc.purgeSpaces.uppercased()
            
            if tf.text.isEmpty {
                
                tf
                    .removeClass(.isOk)
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                return
            }
            
            tf
                .removeClass(.isOk)
                .removeClass(.isNok)
                .class(.isLoading)
            
            API.custAPIV1.checkFreeVendorRFC(
                rfc: tf.text,
                accountid: nil
            ) { resp in
                
                tf.removeClass(.isLoading)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, "No se recivio payload")
                    return
                }
                
                if data.free {
                    tf.class(.isOk)
                }
                else{
                    tf.class(.isNok)
                }
                
            }
            
        }
    
    lazy var razonInput = InputText(self.$razon)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Razon Social")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
    
    lazy var fiscalPOCMobileInput = InputText(self.$fiscalPOCMobile)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Telefono de contacto fiscal")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
    
    lazy var mobileInput = InputText(self.$mobile)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Telefono de contacto general")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
        .onBlur { tf in
            
            self.mobile = self.mobile.purgeSpaces
            
            if tf.text.isEmpty {
                
                tf
                    .removeClass(.isOk)
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                return
            }
            
            tf
                .removeClass(.isOk)
                .removeClass(.isNok)
                .class(.isLoading)
            
            API.custAPIV1.checkFreeVendorMobile(
                mobile: tf.text,
                accountid: nil
            ) { resp in
                
                tf.removeClass(.isLoading)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, "No se recivio payload")
                    return
                }
                
                if data.free {
                    tf.class(.isOk)
                }
                else{
                    tf.class(.isNok)
                }
                
            }
            
        }
    
    lazy var creditDaysField = InputText(self.$creditDays)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Dias de credito")
        .width(95.percent)
        .fontSize(24.px)
        .height(36.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Buscar Proveedor")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            /// Tool
            Div {
                
                self.seachVendorField
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/zoom.png")
                            .paddingRight(0.px)
                            .height(18.px)
                    }
                    .marginRight(7.px)
                    .float(.left)
                    
                    Label("Buscar")
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    self.search()
                }
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .paddingRight(0.px)
                            .height(18.px)
                    }
                    .marginRight(7.px)
                    .float(.left)
                    
                    Label("Crear")
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    self.createAccountViewIsHidden = false
                    self.businessNameInput.select()
                }
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            self.noResultDiv
                .hidden(self.$results.map{ !$0.isEmpty })
            
            self.resultDiv
                .hidden(self.$results.map{ $0.isEmpty })
             
        }
        .hidden(self.$createAccountViewIsHidden.map{ !$0 })
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(50.percent)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        if let _ = self.id {
                            self.remove()
                        }
                        else{
                            self.createAccountViewIsHidden = true
                        }
                    }
                
                H2(self.$id.map{ ($0 == nil) ? "Registrar Provedor" : "Editar Proveedor" })
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
                
            }
            .marginBottom(7.px)
            
            Div {
                Div {
                    Label("Nombre de la empresa")
                        .color(.goldenRod)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.businessNameInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Primer nombre de contacto")
                        .color(.white)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.firstNameInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Primer apellido de contacto")
                        .color(.white)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.lastNameInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Correo electronico principal")
                        .color(.white)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.emailInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Dias de credito")
                        .color(.white)
                    
                    Div().class(.clear)
                    
                    self.creditDaysField
                    
                    Div().class(.clear).marginTop(7.px)
                }
                .class(.oneHalf)
                
                Div {
                    
                    Label("RFC")
                        .color(.goldenRod)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.rfcInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Razon Social")
                        .color(.goldenRod)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.razonInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Movil contacto general")
                        .color(.white)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.mobileInput
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Label("Movil contacto fiscal")
                        .color(.white)
                    
                    Div().class(.clear)
                    
                    self.fiscalPOCMobileInput
                    
                    Div().class(.clear).marginTop(24.px)
                    
                    Div {
                        Div(self.$id.map{ ($0 == nil) ? "Registrar Proveedor" : "Guardar Cambios" })
                            .onClick({
                                self.create()
                            })
                            .class(.uibtnLargeOrange, .oneLineText)
                    }
                    .align(.right)

                }
                .class(.oneHalf)
                
                Div().class(.clear)
                
            }
            .custom("height","calc(100% - 40px)")
            .class(.roundDarkBlue)
            .overflow(.auto)
            
        }
        .hidden(self.$createAccountViewIsHidden)
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(50.percent)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
         
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        super.buildUI()
        
        $results.listen {
            
            self.resultDiv.innerHTML = ""
            
            $0.forEach { prof in
                
                self.resultDiv.appendChild(
                    Div{
                        Div("\(prof.rfc) \(prof.razon) \(prof.businessName)")
                            .class(.oneLineText)
                            .fontSize(18.px)
                        
                        Div("\(prof.firstName) \(prof.lastName)")
                            .class(.oneLineText)
                            .fontSize(23.px)
                    }
                        .width(96.percent)
                        .class(.uibtnLarge)
                        .onClick {
                            self.callback(prof)
                            self.remove()
                        })
                
            }
        }
        
        if let vendor {
            
            createAccountViewIsHidden = false
            
            self.businessName = vendor.businessName
            
            self.firstName = vendor.firstName
            
            self.lastName = vendor.lastName
            
            self.rfc = vendor.rfc
            
            self.razon = vendor.razon
            
            self.email = vendor.email
            
            self.fiscalPOCMobile = vendor.fiscalPOCMobile
            
            self.mobile = vendor.mobile
            
            self.creditDays = vendor.creditDays.toString
            
        }
        else if let vendorid = id {
            
            createAccountViewIsHidden = false
            
            loadingView(show: true)
            
            API.custAPIV1.getVendor(id: vendorid) { resp in
                
                loadingView(show: false)
                
                guard let resp else{
                    showError(.errorDeCommunicacion, .serverConextionError)
                    self.remove()
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.remove()
                    return
                }
                
                guard let vendor = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                    self.remove()
                    return
                }
                
                self.businessName = vendor.businessName
                
                self.firstName = vendor.firstName
                
                self.lastName = vendor.lastName
                
                self.rfc = vendor.rfc
                
                self.razon = vendor.razon
                
                self.email = vendor.email
                
                self.fiscalPOCMobile = vendor.fiscalPOCMobile
                
                self.mobile = vendor.mobile
                
                self.creditDays = vendor.creditDays.toString
                
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        seachVendorField.select()
    }
    
    func search(){
        
        term = term.purgeSpaces
        
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
        
        self.seachVendorField
            .class(.isLoading)
        
        searchVendor(term: term) { _term, resp in
        
            self.seachVendorField
                .removeClass(.isLoading)
            
            if self.term != _term {
                return
            }
            
            self.results = resp
            
        }
        
    }
    
    func create(){
        
        if businessName.isEmpty {
            showError(.campoRequerido, .requierdValid("Nombre de la empresa"))
            businessNameInput.select()
            return
        }
        
        if rfc.isEmpty {
            showError(.campoRequerido, .requierdValid("RFC"))
            rfcInput.select()
            return
        }
        
        if razon.isEmpty {
            showError(.campoRequerido, .requierdValid("Razon Social"))
            razonInput.select()
            return
        }
        
        guard let creditDays = Int64(self.creditDays) else{
            showError(.campoRequerido, .requierdValid("Dias de Credito"))
            creditDaysField.select()
            return
        }
        
        loadingView(show: true)
        
        if let id {
            
            API.custAPIV1.saveVendor(
                id: id,
                businessName: self.businessName,
                firstName: self.firstName,
                lastName: self.lastName,
                rfc: self.rfc,
                razon: self.razon,
                email: self.email,
                mobile: self.mobile,
                fiscalPOCMobile: self.fiscalPOCMobile,
                creditDays: creditDays
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Proveedor Registrado")
                
                self.callback(.init(
                    id: id,
                    folio: self.vendor?.folio ?? "",
                    username: self.vendor?.username ?? "",
                    businessName: self.businessName,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    rfc: self.rfc,
                    razon: self.razon,
                    mobile: self.mobile,
                    email: self.email,
                    fiscalPOCMobile: self.fiscalPOCMobile,
                    contactTel: self.vendor?.contactTel ?? "",
                    lastDataAudit: self.vendor?.lastDataAudit,
                    creditActive: self.vendor?.creditActive ?? false,
                    creditLimit: self.vendor?.creditLimit ?? 0,
                    creditDays: creditDays
                ))
                
                self.remove()
                
            }
        }
        else{
            
            API.custAPIV1.createVendor(
                businessName: self.businessName,
                firstName: self.firstName,
                lastName: self.lastName,
                rfc: self.rfc,
                razon: self.razon,
                email: self.email,
                mobile: self.mobile,
                fiscalPOCMobile: self.fiscalPOCMobile,
                creditDays: creditDays
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let vendor = resp.data else{
                    showError(.errorGeneral, "No se recivio payload")
                    return
                }
                
                showSuccess(.operacionExitosa, "Proveedor Registrado")
                
                self.callback(vendor)
                
                self.remove()
                
            }
        }
        
    }
    
}

extension SearchVendorView {
    
    enum SearchVendorViewLoader {
        case id(UUID)
        case account(CustVendorsQuick)
    }
}
