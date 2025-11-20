//
//  ManageFiscalProfile.swift
//  
//
//  Created by Victor Cantu on 10/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class ManageFiscalProfile: Div {
    
    override class var name: String { "div" }
    
    @State var fiscid: UUID?
    
    @State var packid: UUID?
    
    var socs: [CustTCSOCObject]
    
    private var callback: ((
        _ profile: FiscalEndpointV1.Profile
    ) -> ())
    
    init(
        fiscid: UUID?,
        packid: UUID?,
        socs: [CustTCSOCObject],
        callback: @escaping ((
            _ profile: FiscalEndpointV1.Profile
        ) -> ())
    ) {
        self.fiscid = fiscid
        self.packid = packid
        self.socs = socs
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var eMail: String = ""
    
    /// SOC of selected fiscal package
    @State var rfc: String = ""
    @State var razon: String = ""
    @State var sat_web_pass: String = ""
    
    /// Buisness Name
    @State var nomComercial: String = ""
    
    /// incorporacionFiscal, ingresosPorIntereses, Personas Físicas con Actividades Empresariales y Profesionales
    var regimen: FiscalRegimens? = .personasFisicasConActividadesEmpresarialesYProfesionales
    @State var regimenListener: String = ""
    
    @State var zipCode: String = ""
    
    ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir
    var usoDeFact: FiscalUse? = .gastosEnGeneral
    @State var usoDeFactListener: String = ""
    
    ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
    var tipoDePago: FiscalPaymentCodes? = .transferenciaElectronicaDeFondos
    @State var tipoDePagoListener: String = ""
    
    /// pagoEnUnaSolaExhibicion PUE
    /// pagoEnParcialidadesODiferido PPD
    var methDePago: FiscalPaymentMeths? = .pagoEnUnaSolaExhibicion
    @State var methDePagoListener: String = ""
    
    /// MXN, USD, EUR, CAD ...
    var tipoDeMoneda: FIDocumentCurrency? = .MXN
    @State var tipoDeMonedaListener: String = ""
    
    /// Default Fiscal Units
    @State var fiscUnit: String = ""
    
    /// Default Fiscal Code
    @State var fiscCode: String = ""
    
    @State var fielCer: String? = nil
    
    @State var fielKey: String? = nil
    
    @State var fielPass: String = ""
    
    ///azul, rojo, naranja, verde
    var theme: FIColors? = .azul
    @State var themeListener: String = ""
    
    @State var logo: String? = nil
    
    @State var serie: String = ""
    
    @State var folio: String = ""
    
    @State var logoUploadPercent: String = ""
    
    @State var keyUploadPercent: String = ""
    
    @State var cerUploadPercent: String = ""
    
//    @State var eMail: String = ""
    lazy var eMailSelect = Select(self.$eMail)
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    /// SOC of selected fiscal package
    lazy var rfcField = InputText(self.$rfc)
        .placeholder("RFC")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var razonField = InputText(self.$razon)
        .placeholder("Razon Social")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var satWebPassField = InputText(self.$sat_web_pass)
        .placeholder("Contraseña del portal")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var nomComercialField = InputText(self.$nomComercial)
        .placeholder("Nombre Negocio")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var regimenSelect = Select(self.$regimenListener)
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
//    @State var zipCode: String = ""
    lazy var zipCodeField = InputText(self.$zipCode)
        .placeholder("Codigo Postal")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
//    ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir
//    @State var usoDeFact: FiscalUse = .gastosEnGeneral
    lazy var usoDeFactSelect = Select(self.$usoDeFactListener)
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
    
//    ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
//    @State var tipoDePago: FiscalPaymentCodes = .transferenciaElectronicaDeFondos
    lazy var tipoDePagoSelect = Select(self.$tipoDePagoListener)
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
    
//    /// pagoEnUnaSolaExhibicion PUE
//    /// pagoEnParcialidadesODiferido PPD
//    @State var methDePago: FiscalPaymentMeths = .pagoEnUnaSolaExhibicion
    lazy var methDePagoSelect = Select(self.$methDePagoListener)
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
    
//    /// MXN, USD, EUR, CAD ...
//    @State var tipoDeMoneda: FIDocumentCurrency = .MXN
    lazy var tipoDeMonedaSelect = Select(self.$tipoDeMonedaListener)
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
    
//    /// Default Fiscal Units
//    @State var fiscUnit: String = ""
    lazy var fiscUnitField = FiscUnitField(style: .dark, type: .manual) { data in
        self.fiscUnit = data.c
    }

//    /// Default Fiscal Code
//    @State var fiscCode: String = ""
    lazy var fiscCodeField = FiscCodeField(style: .dark, type: .manual) { data in
        self.fiscCode = data.c
    }
    
//    @State var fielCer: File? = nil
    lazy var cerFile: InputFile = InputFile()
        .id(Id(stringLiteral: "inputFileCer"))
        .accept([".cer"])
        .hidden(true)
        
//    @State var fielKey: File? = nil
    lazy var keyFile: InputFile = InputFile()
        .id(Id(stringLiteral: "inputFileKey"))
        .accept([".key"])
        .hidden(true)
    
//    @State var fielPass: String = ""
    lazy var fielPassField = InputText(self.$fielPass)
        .placeholder("Contraseña Fiel")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
//    ///azul, rojo, naranja, verde
//    @State var theme: FIColors
    lazy var themeSelect = Select(self.$themeListener)
       .custom("width","calc(100% - 18px)")
       .class(.textFiledBlackDark)
    
//    @State var logo: String
    lazy var logoFile: InputFile = InputFile()
        .id(Id(stringLiteral: "inputFileKey"))
        .accept(["image/png", "image/jpeg"])
        .hidden(true)
    
    lazy var logoView = Img().src("/skyline/media/512.png")
        .cursor(.pointer)
        .height(70.px)
        .onClick {
            self.logoFile.click()
        }
    
    
    lazy var serieField = InputText(self.$serie)
        .placeholder("Serie de Factura")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    
    lazy var folioField = InputText(self.$folio)
        .placeholder("Folio de Factura")
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            H2("Datos Generales")
                .color(.white)
            
            Div().class(.clear)
            
            /// Biz Name
            Div{
                Label("Nombre Comercial").color(.lightGray)
                Div{
                    self.nomComercialField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// Razon Social
            Div{
                Label("Razon Social").color(.lightGray)
                Div{
                    self.razonField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// RFC
            Div{
                Label("RFC").color(.lightGray)
                Div{
                    self.rfcField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            H2("Valores pre definidos")
                .color(.white)
            
            Div().class(.clear)
            
            /// Fisc Code
            Div{
                Label("Codigo de producto fiscal").color(.lightGray)
                self.fiscCodeField
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// Fisc Unit
            Div{
                Label("Codigo de unidad fiscal").color(.lightGray)
                self.fiscUnitField
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// regimenSelect
            Div{
                Label("Regimen").color(.lightGray)
                Div{
                    self.regimenSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// usoDeFactSelect
            Div{
                Label("Uso").color(.lightGray)
                Div{
                    self.usoDeFactSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// tipoDePagoSelect
            Div{
                Label("Tipo de Pago").color(.lightGray)
                Div{
                    self.tipoDePagoSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// methDePagoSelect
            Div{
                Label("Metodo de Pago").color(.lightGray)
                Div{
                    self.methDePagoSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// tipoDeMonedaSelect
            Div{
                Label("Codigo Postal").color(.lightGray)
                Div{
                    self.tipoDeMonedaSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// zipCodeField
            Div{
                Label("Codigo Postal").color(.lightGray)
                Div{
                    self.zipCodeField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
        
        }
        .custom("width", "calc(50% - 7px)")
        .marginRight(7.px)
        .float(.left)
        
        Div{
            
            H2("Personalizado")
                .color(.white)
            
            Div().class(.clear)
            
            Div{
                
                Div{
                    Label("Serie").color(.lightGray)
                    Div{
                        self.serieField
                    }
                }.class(.section)
                
            }
            .width(50.percent)
            .float(.left)
            
            Div{
                
                Div{
                    Label("Folio").color(.lightGray)
                    Div{
                        self.folioField
                    }
                }.class(.section)
                
            }
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                Label("Color").color(.lightGray)
                Div{
                    self.themeSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                Label{
                    Span("Logo")
                        .color(.lightGray)
                    Br()
                    Span(self.$logoUploadPercent)
                        .color(.darkOrange)
                }
                Div{
                    self.logoFile
                    
                    self.logoView
                    
                }
            }.class(.section)
            
            H2("Contraseña SAT")
                .color(.white)
            
            Div().class(.clear)
            
            Div{
                Label("www.sat.gob.mx").color(.lightGray)
                Div{
                    self.satWebPassField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            H2("Archivos FIEL")
                .color(.white)
            
            Div().class(.clear)
            
            Div{
                
                Div{
                    Label{
                        Span("FIEL KEY")
                            .color(.lightGray)
                        Br()
                        Span(self.$keyUploadPercent)
                            .color(.darkOrange)
                    }
                    
                    Div{
                        self.keyFile
                        
                        Img()
                            .border(width: .medium, style: .solid, color: self.$fielKey.map{ ($0 == nil) ? .none : .green })
                            .src("/skyline/media/attachment.png")
                            .cursor(.pointer)
                            .width(75.px)
                            .onClick {
                                self.keyFile.click()
                            }
                        
                    }
                }.class(.section)
                
            }
            .width(50.percent)
            .float(.left)
            
            Div{
                Div{
                    
                    Label{
                        Span("FIEL CER")
                            .color(.lightGray)
                        
                        Br()
                        
                        Span(self.$cerUploadPercent)
                            .color(.darkOrange)
                    }
                    
                    Div{
                        self.cerFile
                        
                        Img()
                            .border(width: .medium, style: .solid, color: self.$fielCer.map{ ($0 == nil) ? .none : .green })
                            .src("/skyline/media/attachment.png")
                            .cursor(.pointer)
                            .width(75.px)
                            .onClick {
                                self.cerFile.click()
                            }
                        
                    }
                }.class(.section)
            }
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear).marginTop(3.px)
            
            /// Pass
            Div{
                Label("Contraseña FIEL").color(.lightGray)
                Div{
                    self.fielPassField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            H2("Correo Electronico")
                .color(.white)
            
            Div().class(.clear)
            
            Div{
                Label("Seleccione correo").color(.lightGray)
                Div{
                    self.eMailSelect
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                
                Div(self.$fiscid.map{ ($0 == nil) ? "Crear Perfil" : "Guardar Datos"})
                    .class(.uibtnLargeOrange)
                    .color(.darkOrange)
                    .cursor(.pointer)
                    .fontSize(32.px)
                    .onClick {
                        self.saveProfile()
                    }
                
            }.align(.right)
            
        }
        .width(50.percent)
        .float(.left)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.eMail = userCathByUUID.first?.value.username ?? ""
        
        userCathByUUID.forEach { id, user in
            eMailSelect.appendChild(Option(user.username).value(user.username))
        }
        
        $regimenListener.listen {
            self.regimen = FiscalRegimens(rawValue: $0)
        }
        
        $usoDeFactListener.listen {
            self.usoDeFact = FiscalUse(rawValue: $0)
        }
        
        $tipoDePagoListener.listen {
            self.tipoDePago = FiscalPaymentCodes(rawValue: $0)
        }
        
        $methDePagoListener.listen {
            self.methDePago = FiscalPaymentMeths(rawValue: $0)
        }
        
        $tipoDeMonedaListener.listen {
            self.tipoDeMoneda = FIDocumentCurrency(rawValue: $0)
        }
        
        $themeListener.listen {
            self.theme = FIColors(rawValue: $0)
        }
        
        cerFile.$files.listen {
            if let file = $0.first {
                self.loadMedia(file, .cer)
            }
        }
        keyFile.$files.listen {
            if let file = $0.first {
                self.loadMedia(file, .key)
            }
        }
        logoFile.$files.listen {
            if let file = $0.first {
                self.loadMedia(file, .logo)
            }
        }
        
        /// Load fiscal profile
        if let _ = fiscid {
            
        }
        /// New fiscal profile
        else{
            loadSelectionItems()
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
    func loadSelectionItems(){
        
        FiscalRegimens.allCases.forEach { item in
            let opt = Option("\(item.code) \(item.description)")
                .value(item.code)
            
            if regimen == item {
                opt.selected(true)
            }
            
            regimenSelect.appendChild(opt)
        }
        
        FiscalUse.allCases.forEach { item in
            let opt = Option("\(item.code) \(item.description)")
                .value(item.code)
            
            if usoDeFact == item {
                opt.selected(true)
            }
            
            usoDeFactSelect.appendChild(opt)
        }
        
        FiscalPaymentCodes.allCases.forEach { item in
            let opt = Option("\(item.code) \(item.description)")
                .value(item.code)
            
            if tipoDePago == item {
                opt.selected(true)
            }
            
            tipoDePagoSelect.appendChild(opt)
        }
        
        FiscalPaymentMeths.allCases.forEach { item in
            
            let opt = Option("\(item.code) \(item.description)")
                .value(item.code)
            
            if methDePago == item {
                opt.selected(true)
            }
            
            methDePagoSelect.appendChild(opt)
        }
        
        FIDocumentCurrency.allCases.forEach { item in
            let opt = Option("\(item.rawValue) \(item.description)")
                .value(item.rawValue)
            
            if tipoDeMoneda == item {
                opt.selected(true)
            }
            
            tipoDeMonedaSelect.appendChild(opt)
        }
        
        FIColors.allCases.forEach { item in
            let opt = Option(item.rawValue.capitalizeFirstLetter)
                .value(item.rawValue)
            
            if theme == item {
                opt.selected(true)
            }
            
            themeSelect.appendChild(opt)
        }
        
    }
    
    func loadMedia(_ file: File, _ type: UploadType) {
        
        let xhr = XMLHttpRequest()
        
        xhr.onLoadStart {
            
        }
        
        xhr.onError { jsValue in
            showError(.errorDeCommunicacion, .serverConextionError)
            switch type {
            case .key:
                self.logoUploadPercent = ""
            case .cer:
                self.keyUploadPercent = ""
            case .logo:
                self.cerUploadPercent = ""
            }
        }
        
        xhr.onLoadEnd {
            
            switch type {
            case .key:
                self.logoUploadPercent = ""
            case .cer:
                self.keyUploadPercent = ""
            case .logo:
                self.cerUploadPercent = ""
            }
            
            guard let responseText = xhr.responseText else {
                showError(.errorGeneral, .serverConextionError + " 001")
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.errorGeneral, .serverConextionError + " 002")
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custPOCV1.UploadMediaResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, "No se pudo cargar datos")
                    return
                }
                
                switch type {
                case .key:
                    self.fielKey = data.file
                case .cer:
                    self.fielCer = data.file
                case .logo:
                    self.logoView.src("\(data.url)\(data.avatar)")
                    self.logo = data.file
                }
                
            } catch {
                showError(.errorGeneral, .serverConextionError + " 003")
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            let loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
            
            switch type {
            case .key:
                self.keyUploadPercent = loadPercent
            case .cer:
                self.cerUploadPercent = loadPercent
            case .logo:
                self.logoUploadPercent = loadPercent
            }
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }
        
        let formData = FormData()
        
        formData.append("file", file, filename: file.name)
        
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadMedia")
        
        xhr.setRequestHeader("Accept", "application/json")
        
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
        
        xhr.send(formData)
        
    }
    
    func saveProfile() {
        
        var pack: String? = nil
        
        socs.forEach { soc in
            if soc.id == packid {
                pack = soc.soc
            }
        }
        
        guard let pack else {
            showError(.errorDeCommunicacion, "No se seleccion paquete fiscal")
            return
        }
        
        guard !rfc.isEmpty else {
            showError(.campoRequerido, .requierdValid("RFC"))
            rfcField.select()
            return
        }
        
        guard !razon.isEmpty else {
            showError(.campoRequerido, .requierdValid("RFC"))
            razonField.select()
            return
        }
        
        guard !sat_web_pass.isEmpty else {
            showError(.campoRequerido, .requierdValid("Contraseña SAT"))
            satWebPassField.select()
            return
        }
        
        guard !nomComercial.isEmpty else {
            showError(.campoRequerido, .requierdValid("Contraseña SAT"))
            nomComercialField.select()
            return
        }
        
        guard let regimen else {
            showError(.campoRequerido, "Seleccione Regimen")
            return
        }
        
        guard !zipCode.isEmpty else {
            showError(.campoRequerido, .requierdValid("Codigo Postal"))
            zipCodeField.select()
            return
        }
        
        guard let usoDeFact else {
            showError(.campoRequerido, "Seleccione Uso de factura")
            return
        }
        
        guard let tipoDePago else {
            showError(.campoRequerido, "Seleccione Tipo de pago")
            return
        }
        
        guard let methDePago else {
            showError(.campoRequerido, "Seleccione Metodo de pago")
            return
        }
        
        guard let tipoDeMoneda else {
            showError(.campoRequerido, "Seleccione Tipo de moneda")
            return
        }
        
        guard !fiscUnit.isEmpty else {
            showError(.campoRequerido, .requierdValid("Unidad Fiscal"))
            fiscUnitField.fiscUnitField.select()
            return
        }
        
        guard !fiscCode.isEmpty else {
            showError(.campoRequerido, .requierdValid("Codigo Postal"))
            fiscCodeField.fiscCodeField.select()
            return
        }
        
        guard let fielCer else {
            showError(.campoRequerido, .requierdValid("Ingrese archivo .cer"))
            return
        }
        
        
        guard let fielKey else {
            showError(.campoRequerido, .requierdValid("Ingrese archivo .key"))
            return
        }
        
        
        guard !fielPass.isEmpty else {
            showError(.campoRequerido, .requierdValid("Ingerse contraseña FIEL"))
            fielPassField.select()
            return
        }
        
        guard let theme else {
            showError(.campoRequerido, .requierdValid("Escoja color del tema"))
            return
        }
        
        API.fiscalV1.registerProfile(
            eMail: eMail,
            username: "",
            password: "",
            pack: pack,
            rfc: rfc,
            razon: razon,
            sat_web_pass: sat_web_pass,
            nomComercial: nomComercial,
            regimen: regimen,
            zipCode: zipCode,
            tipoDeFact: .ingreso,
            usoDeFact: usoDeFact,
            tipoDePago: tipoDePago,
            methDePago: methDePago,
            tipoDeMoneda: tipoDeMoneda,
            fiscUnit: fiscUnit,
            fiscCode: fiscCode,
            fiel_sat_cer: fielCer,
            fiel_sat_key: fielKey,
            fiel_sat_pass: fielPass,
            theme: theme,
            serie: serie,
            folio: folio,
            logo: logo ?? ""
        ) { resp in
            
            guard let resp else{
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let profile = resp.data else {
                showError(.unexpectedResult, "No se obtuvo perfirl fiscal")
                return
            }
            
            self.callback(profile)
            
            self.remove()
            
        }
    }
    
}

extension ManageFiscalProfile {
    enum UploadType {
        case key
        case cer
        case logo
    }
}
