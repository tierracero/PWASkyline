//
//  Account+DetailView.swift
//  
//
//  Created by Victor Cantu on 8/30/23.
//
import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

extension AccountView {
    
    class DetailView: Div {
        
        override class var name: String { "div" }
        
        let account: CustAcct
        
        let accountView: AccountView
        
        init(
            account: CustAcct,
            accountView: AccountView
        ) {
            self.account = account
            self.accountView = accountView
            
            self.businessName = account.businessName
            /// cost_a, cost_b cost_c
            self.costType = account.costType.rawValue
            ///personal, empresaFisica, empresaMoral, organizacion
            self.type = account.type.rawValue
            self.thirdPartyService = account.thirdPartyService
            self.isConcessionaire = account.isConcessionaire
            self.sendOrderCommunication = account.sendOrderCommunication
            self.firstName = account.firstName
            self.secondName = account.secondName
            self.lastName = account.lastName
            self.secondLastName = account.secondLastName
            /// male, female
            /// Genders
            self.sexo = account.sexo?.rawValue ?? ""
            
            self.birthDay = account.birthDay?.toString ?? ""
            self.birthMonth = account.birthMonth?.toString ?? ""
            self.birthYear = account.birthYear?.toString ?? ""
            self.rfc = account.rfc
            self.curp = account.curp
            
            /// driversLicens, identification, passport, scholar, votersCard, other
            /// IdentificationTypes
            self.IDType = account.IDType?.rawValue ?? ""
            
            self.IDNum = account.IDNum
            self.telephone = account.telephone
            self.telephone2 = account.telephone2
            self.mobile = account.mobile
            self.mobile2 = account.mobile2
            self.email = account.email
            self.email2 = account.email2
            
            self.street = account.street
            self.colony = account.colony
            self.city = account.city
            self.state = account.state
            self.country = account.country
            self.zip = account.zip
            
            self.mailStreet = account.mailStreet
            self.mailColony = account.mailColony
            self.mailCity = account.mailCity
            self.mailZip = account.mailZip
            self.mailState = account.mailState
            self.mailCountry = account.mailCountry
            
            //If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
            self.fiscalProfile = account.fiscalProfile?.uuidString ?? ""
            self.fiscalProfileName = ""
            self.fiscalRazon = account.fiscalRazon
            self.fiscalRfc = account.fiscalRfc
            self.fiscalRegime = account.fiscalRegime?.rawValue ?? ""
            self.fiscalZip = account.fiscalZip
            
            self.fiscalPOCFirstName = account.fiscalPOCFirstName
            self.fiscalPOCLastName = account.fiscalPOCLastName
            self.fiscalPOCMobile = account.fiscalPOCMobile
            self.fiscalPOCMail = account.fiscalPOCMail
            
            self.cfdiUse = account.cfdiUse?.rawValue ?? ""
            
            self.contacto1 = account.contacto1
            self.contacto2 = account.contacto2
            self.contactTel = account.contactTel
            self.contactMail =  account.contactMail
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var businessName: String
        /// cost_a, cost_b cost_c
        /// CustAcctCostTypes
        @State var costType: String
        /// personal, empresaFisica, empresaMoral, organizacion
        /// CustAcctTypes
        @State var type: String
        
        @State var thirdPartyService: Bool
        
        @State var isConcessionaire: Bool
        
        @State var sendOrderCommunication: Bool

        
        @State var firstName: String
        @State var secondName: String
        @State var lastName: String
        @State var secondLastName: String
        
        /// male, female
        /// Genders
        @State var sexo: String
        @State var birthDay: String
        @State var birthMonth: String
        @State var birthYear: String
        @State var rfc: String
        @State var curp: String
        /// driversLicens, identification, passport, scholar, votersCard, other
        /// IdentificationTypes
        @State var IDType: String
        @State var IDNum: String
        @State var telephone: String
        @State var telephone2: String
        @State var mobile: String
        @State var mobile2: String
        @State var email: String
        @State var email2: String
        
        @State var street: String
        @State var colony: String
        @State var city: String
        @State var state: String
        @State var country: String
        @State var zip: String
        
        @State var mailStreet: String
        @State var mailColony: String
        @State var mailCity: String
        @State var mailState: String
        @State var mailCountry: String
        @State var mailZip: String
        
        ///If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
        @State var fiscalProfile: String = ""
        @State var fiscalProfileName: String = ""
        @State var fiscalRazon: String
        @State var fiscalRfc: String
        
        /// FiscalRegimens
        @State var fiscalRegime: String
        @State var fiscalZip: String
        
        @State var fiscalPOCFirstName: String
        @State var fiscalPOCLastName: String
        
        @State var fiscalPOCMail: String
        
        @State var fiscalPOCMobile: String
        
        /// FiscalUse
        @State var cfdiUse: String
        
        @State var contacto1: String
        @State var contacto2: String
        @State var contactTel: String
        @State var contactMail: String
        
        lazy var businessNameField = InputText(self.$businessName)
            .placeholder("Nombre Negocio")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var typeSelect = Select(self.$type)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
     
        lazy var thirdPartyServiceToggle = InputCheckbox().toggle(self.$thirdPartyService)
        
        lazy var sendOrderCommunicationToggle = InputCheckbox().toggle(self.$sendOrderCommunication)
        
        lazy var isConcessionaireToggle = InputCheckbox().toggle(self.$isConcessionaire)
        
        lazy var costTypeSelect = Select(self.$costType)
             .custom("width","calc(100% - 24px)")
             .class(.textFiledBlackDark)
             .height(31.px)
     
        lazy var firstNameField = InputText(self.$firstName)
            .placeholder(String.firstName)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var secondNameField = InputText(self.$secondName)
            .placeholder(String.secondName)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var lastNameField = InputText(self.$lastName)
            .placeholder(String.lastName)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var secondLastNameField = InputText(self.$secondLastName)
            .placeholder(String.secondLastName)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var sexoSelect = Select(self.$sexo)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var birthDayField = InputText(self.$birthDay)
            .placeholder("24")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var birthMonthField = InputText(self.$birthMonth)
            .placeholder("7")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var birthYearField = InputText(self.$birthYear)
            .placeholder("1980")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var rfcField = InputText(self.$rfc)
            .placeholder("RFC Personal")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var curpField = InputText(self.$curp)
            .placeholder("CURP")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var IDTypeSelect = Select(self.$IDType)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var IDNumField = InputText(self.$IDNum)
            .placeholder("Numero de ID")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var telephoneField = InputText(self.$telephone)
            .placeholder(String.telephone)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var telephone2Field = InputText(self.$telephone2)
            .placeholder(LString(String.telephoneSecondary))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mobileField = InputText(self.$mobile)
            .placeholder(String.mobile)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mobile2Field = InputText(self.$mobile2)
            .placeholder(LString(String.mobileSecondary))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var emailField = InputText(self.$email)
            .placeholder(LString(String.email))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var streetField = InputText(self.$street)
            .placeholder(String.streetNumber)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var colonyField = InputText(self.$colony)
            .placeholder(String.colony)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var cityField = InputText(self.$city)
            .placeholder( .city )
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var stateField = InputText(self.$state)
            .placeholder(.state)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var countryField = InputText(self.$country)
            .placeholder(.country)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var zipField = InputText(self.$zip)
            .placeholder(.zipCode)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mailStreetField = InputText(self.$mailStreet)
            .placeholder(String.streetNumber)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mailColonyField = InputText(self.$mailColony)
            .placeholder(String.colony)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mailCityField = InputText(self.$mailCity)
            .placeholder(String.city)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mailStateField = InputText(self.$mailState)
            .placeholder(String.state)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mailCountryField = InputText(self.$mailCountry)
            .placeholder(String.country)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var mailZipField = InputText(self.$mailZip)
            .placeholder(String.zipCode)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var fiscalProfileSelect = Select(self.$fiscalProfile)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            /*
            .onChange { event, input in
                
                self.fiscalProfile = UUID(uuidString: input.value)
                
                self.fiscalProfileName = ""
                
                guard let fiscalProfile = self.fiscalProfile else {
                    return
                }
                
                fiscalProfiles.forEach { profile in
                    
                    if profile.id == fiscalProfile {
                        self.fiscalProfileName = profile.rfc
                    }
                    
                }
                
            }
            */
        
        lazy var fiscalRazonField = InputText(self.$fiscalRazon)
            .placeholder("Razon Social")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var fiscalRfcField = InputText(self.$fiscalRfc)
            .placeholder("RFC")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var fiscalRegimeSelect = Select(self.$fiscalRegime)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            
        
        lazy var fiscalZipField = InputText(self.$fiscalZip)
            .placeholder(LString(String.cpFiscal))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var fiscalPOCFirstNameField = InputText(self.$fiscalPOCFirstName)
            .class(.oneLineText)
            .placeholder(LString(String.cfName))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var cfdiUseSelect = Select(self.$cfdiUse)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
         lazy var fiscalPOCLastNameField = InputText(self.$fiscalPOCLastName)
             .placeholder(LString(String.cfLastName))
             .custom("width","calc(100% - 24px)")
             .class(.textFiledBlackDark)
             .height(31.px)
     
        lazy var fiscalPOCMobileField = InputText(self.$fiscalPOCMobile)
            .placeholder(LString(String.cfMobile))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
       lazy var fiscalPOCMailField = InputText(self.$fiscalPOCMail)
           .placeholder(LString(String.cfMobile))
           .custom("width","calc(100% - 24px)")
           .class(.textFiledBlackDark)
           .height(31.px)
     
        lazy var contacto1Field = InputText(self.$contacto1)
            .placeholder("Contacto Nombre")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var contacto2Field = InputText(self.$contacto2)
            .placeholder(LString(String.contactLastName))
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var contactTelField = InputText(self.$contactTel)
            .placeholder("Cell Contacto")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var contactMailField = InputText(self.$contactMail)
            .placeholder("Correo Contacto")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
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
                        
                        H2("Editar Cuenta \(self.account.folio)")
                            .color(.lightBlueText)
                            .height(35.px)
                    }
                    
                    Div().clear(.both)
                    
                    Div{
                        
                        /// Datos Generales
                        Div{
                            Div{
                                Div{
                                    
                                    H3("Datos de la cuenta").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Label("Tipo de Cuenta")
                                    Div().marginBottom(3.px)
                                    self.typeSelect
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    /// Servicios a Terceros
                                    Div{
                                        Div("Servicios a Terceros")
                                            .class(.oneLineText)
                                            .width(70.percent)
                                            .float(.left)
                                        
                                        Div{
                                            self.thirdPartyServiceToggle
                                        }
                                        .width(30.percent)
                                        .float(.left)
                                        
                                        Div().clear(.both).marginBottom(7.px)
                                        
                                    }
                                    .hidden(self.$type.map{ $0 == CustAcctTypes.personal.rawValue })
                                    
                                    /// Consecionario
                                    Div {
                                        
                                        Div("Consecionario")
                                            .class(.oneLineText)
                                            .width(70.percent)
                                            .float(.left)
                                        
                                        Div{
                                            self.isConcessionaireToggle
                                        }
                                        .width(30.percent)
                                        .float(.left)
                                        
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .hidden(self.$type.map{ $0 == CustAcctTypes.personal.rawValue })
                                    
                                    /// Mensajes en Ordenes
                                    Div{
                                        Div("Mensajes en Ordenes")
                                            .class(.oneLineText)
                                            .width(70.percent)
                                            .float(.left)
                                        
                                        Div{
                                            self.sendOrderCommunicationToggle
                                        }
                                        .width(30.percent)
                                        .float(.left)
                                        
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .hidden(self.$type.map{ $0 == CustAcctTypes.personal.rawValue })
                                    
                                    Label("Tipo de Costo")
                                    Div().marginBottom(3.px)
                                    self.costTypeSelect
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("Nombre de Negocio")
                                    Div().marginBottom(3.px)
                                    self.businessNameField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    H3("Información Personal").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Label("Primer Nombre")
                                        Div().marginBottom(3.px)
                                        self.firstNameField
                                        Div().clear(.both).marginBottom(7.px)
                                        
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        
                                        Label("Segundo Nombre")
                                        Div().marginBottom(3.px)
                                        self.secondNameField
                                        Div().clear(.both).marginBottom(7.px)
                                        
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        
                                        Label("Primer Apellido")
                                        Div().marginBottom(3.px)
                                        self.lastNameField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        
                                        Label("Segundo Apellido")
                                        Div().marginBottom(3.px)
                                        self.secondLastNameField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        
                                        Label("Sexo")
                                        Div().marginBottom(3.px)
                                    }
                                    .width(33.percent)
                                    .float(.left)
                                    Div{
                                        
                                        self.sexoSelect
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(66.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    
                                    Label("Fecha de Nacimiento")
                                    Div().marginBottom(3.px)
                                    Div{
                                        Label("Diá")
                                        Div().marginBottom(3.px)
                                        self.birthDayField
                                        Div().clear(.both).marginBottom(7.px)
                                        
                                    }
                                    .width(33.percent)
                                    .float(.left)
                                    Div{
                                        Label("Mes")
                                        Div().marginBottom(3.px)
                                        self.birthMonthField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(33.percent)
                                    .float(.left)
                                    Div{
                                        Label("Año")
                                        Div().marginBottom(3.px)
                                        self.birthYearField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(33.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        Label("RFC")
                                        Div().marginBottom(3.px)
                                        self.rfcField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("CURP")
                                        Div().marginBottom(3.px)
                                        self.curpField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Label("Tipo de Identificación")
                                    Div().marginBottom(3.px)
                                    self.IDTypeSelect
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("Numero de Identificación")
                                    Div().marginBottom(3.px)
                                    self.IDNumField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                                Div{
                                    
                                    H3("Direcicon Fisica").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Label("Calle y Numero")
                                    Div().marginBottom(3.px)
                                    self.streetField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Div{
                                        Label("Colonia")
                                        Div().marginBottom(3.px)
                                        self.colonyField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Cuidad")
                                        Div().marginBottom(3.px)
                                        self.cityField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        Label("Estado")
                                        Div().marginBottom(3.px)
                                        self.stateField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Pais")
                                        Div().marginBottom(3.px)
                                        self.countryField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Label("Codigo Postal")
                                    Div().marginBottom(3.px)
                                    self.zipField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    H3("Dirección de Correspondencia").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Label("Calle Y numero")
                                    Div().marginBottom(3.px)
                                    self.mailStreetField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Div{
                                        Label("Colonia")
                                        Div().marginBottom(3.px)
                                        self.mailColonyField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Cudiad")
                                        Div().marginBottom(3.px)
                                        self.mailCityField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        Label("Estado")
                                        Div().marginBottom(3.px)
                                        self.mailStateField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Pais")
                                        Div().marginBottom(3.px)
                                        self.mailCountryField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    
                                    Label("Codigo Postal")
                                    Div().marginBottom(3.px)
                                    self.mailZipField
                                    Div().clear(.both).marginBottom(7.px)
                                }
                                .width(50.percent)
                                .float(.left)
                                Div().clear(.both).marginBottom(3.px)
                            }
                            .margin(all: 7.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div{
                                Div{
                                    
                                    H3("Contacto Personal").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Label("Telefono")
                                        Div().marginBottom(3.px)
                                        self.telephoneField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Tel. Secu.")
                                        Div().marginBottom(3.px)
                                        self.telephone2Field
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        Label("Movil")
                                        Div().marginBottom(3.px)
                                        self.mobileField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Movil Secu.")
                                        Div().marginBottom(3.px)
                                        self.mobile2Field
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Label("Correo Electronico")
                                    Div().marginBottom(3.px)
                                    self.emailField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    /// `Contacto General `
                                    H3("Contacto General").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Label("Nombre")
                                        Div().marginBottom(3.px)
                                        self.contacto1Field
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Apellido")
                                        Div().marginBottom(3.px)
                                        self.contacto2Field
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        Label("Telefono de Contatco")
                                        Div().marginBottom(3.px)
                                        self.contactTelField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Coreo de Contacto")
                                        Div().marginBottom(3.px)
                                        self.contactMailField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                                Div{
                                    
                                    /// `Contacto Fiscal`
                                    H3("Datos Fiscales").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Label("Perfil fiscal")
                                    Div().marginBottom(3.px)
                                    self.fiscalProfileSelect
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("Razon Social")
                                    Div().marginBottom(3.px)
                                    self.fiscalRazonField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("RFC")
                                    Div().marginBottom(3.px)
                                    self.fiscalRfcField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("Regimen Fiscal")
                                    Div().marginBottom(3.px)
                                    self.fiscalRegimeSelect
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("Codigo Postal")
                                    Div().marginBottom(3.px)
                                    self.fiscalZipField
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    Label("")
                                    Div().marginBottom(3.px)
                                    self.cfdiUseSelect
                                    Div().clear(.both).marginBottom(7.px)
                                    
                                    /// `Contacto Fiscal`
                                    H3("Contacto Fiscal").color(.lightBlueText)
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Label("Nombre")
                                        Div().marginBottom(3.px)
                                        self.fiscalPOCFirstNameField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Apellido")
                                        Div().marginBottom(3.px)
                                        self.fiscalPOCLastNameField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                    Div{
                                        Label("Movil")
                                        Div().marginBottom(3.px)
                                        self.fiscalPOCMobileField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div{
                                        Label("Correo")
                                        Div().marginBottom(3.px)
                                        self.fiscalPOCMailField
                                        Div().clear(.both).marginBottom(7.px)
                                    }
                                    .width(50.percent)
                                    .float(.left)
                                    Div().clear(.both)
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                                Div().clear(.both).marginBottom(3.px)
                            }
                            .margin(all: 7.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    .custom("height", "calc(100% - 100px)")
                    .class(.roundDarkBlue)
                    .overflow(.auto)
                    .color(.gray)
                    
                    Div{
                        Div("Guardar Cambios")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                self.saveAccountDetails()
                            }
                    }
                    .align(.right)
                    
                }
                .height(100.percent)
                .margin(all: 7.px)
            }
            .custom("left", "calc(50% - 600px)")
            .custom("top", "calc(50% - 350px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .height(700.px)
            .width(1200.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
             CustAcctCostTypes.allCases.forEach { val in
                 costTypeSelect.appendChild(
                     Option(val.description)
                         .value(val.rawValue)
                 )
             }
             
             CustAcctTypes.allCases.forEach { val in
                 typeSelect.appendChild(
                     Option(val.description)
                         .selected(self.account.type == val)
                         .value(val.rawValue)
                 )
             }
             
             sexoSelect.appendChild(Option("Seleccione Opcion").value(""))
             Genders.allCases.forEach { val in
                 sexoSelect.appendChild(
                     Option(val.description)
                         .selected(self.account.sexo == val)
                         .value(val.rawValue)
                 )
             }
             
             IDTypeSelect.appendChild(Option("Seleccione Opcion").value(""))
             IdentificationTypes.allCases.forEach { val in
                 IDTypeSelect.appendChild(
                     Option(val.description)
                         .selected(self.account.IDType == val)
                         .value(val.rawValue)
                 )
             }
             
             fiscalProfileSelect.appendChild(Option("Seleccione Perfil Fiscal").value(""))
             
             fiscalProfiles.forEach { prof in
                 
                 if self.account.fiscalProfile == prof.id {
                     self.fiscalProfileName = prof.rfc
                 }
                 
                 fiscalProfileSelect.appendChild(
                     Option("\(prof.rfc) \(prof.razon)")
                         .value(prof.id.uuidString)
                         .selected(self.account.fiscalProfile == prof.id)
                 )
             }
             
             fiscalRegimeSelect.appendChild(Option("Seleccione Regimen").value(""))
             FiscalRegimens.allCases.forEach { fisc in
                 if fisc.type == .fisical {
                     fiscalRegimeSelect.appendChild(
                         Option("\(fisc.code) \(fisc.description)")
                             .value(fisc.code)
                             .selected(self.account.fiscalRegime == fisc)
                     )
                 }
             }
             
             FiscalRegimens.allCases.forEach { fisc in
                 if fisc.type == .moral {
                     fiscalRegimeSelect.appendChild(
                         Option("\(fisc.code) \(fisc.description)")
                             .value(fisc.code)
                             .selected(self.account.fiscalRegime == fisc)
                     )
                 }
             }
             
             cfdiUseSelect.appendChild(Option("Seleccione Opcion").value(""))
             FiscalUse.allCases.forEach { use in
                 cfdiUseSelect.appendChild(
                     Option("\(use.code) \(use.description)")
                         .value(use.code)
                         .selected(self.account.cfdiUse == use)
                 )
             }
             
            /*
             GeneralStatus.allCases.forEach { status in
                 statusSelect.appendChild(
                     Option("\(status.rawValue) \(status.description)")
                         .value(status.rawValue)
                         .selected(self.account.status == status)
                 )
             }
             */
        
        }
        
        func saveAccountDetails() {
            
            guard let type = CustAcctTypes(rawValue: self.type) else {
                return
            }
            
            guard let costType = CustAcctCostTypes(rawValue: self.costType) else {
                return
            }
            
            if let fiscalProfile = UUID(uuidString: self.fiscalProfile) {
                
                fiscalProfiles.forEach { profile in
                    
                    if profile.id == fiscalProfile {
                        self.fiscalProfileName = profile.rfc
                    }
                    
                }
            }
            
            switch type {
            case .personal:
                if firstName.isEmpty {
                    showError(.campoRequerido, .requierdValid("Primer nombre"))
                    firstNameField.select()
                    return
                }
                if lastName.isEmpty {
                    showError(.campoRequerido, .requierdValid("Primer apellido"))
                    lastNameField.select()
                    return
                }
            case .empresaFisica, .empresaMoral, .organizacion:
                if businessName.isEmpty {
                    showError(.campoRequerido, .requierdValid("Nombre de la empresa"))
                    businessNameField.select()
                    return
                }
                
                if fiscalRazon.isEmpty {
                    showError(.campoRequerido, .requierdValid("Razon Social"))
                    fiscalRazonField.select()
                    return
                }
                
                if fiscalRfc.isEmpty {
                    showError(.campoRequerido, .requierdValid("RFC"))
                    fiscalRfcField.select()
                    return
                }
            }
            
            API.custAccountV1.update(
                id: account.id,
                custType: type,
                thirdPartyService: thirdPartyService,
                isConcessionaire: isConcessionaire,
                sendOrderCommunication: sendOrderCommunication,
                costType: costType,
                businessName: businessName,
                fiscalProfile: UUID(uuidString: fiscalProfile),
                fiscalProfileName: fiscalProfileName,
                fiscalRazon: fiscalRazon,
                fiscalRfc: fiscalRfc,
                fiscalRegime: FiscalRegimens(rawValue: fiscalRegime),
                fiscalZip: fiscalZip,
                fiscalPOCFirstName: fiscalPOCFirstName,
                fiscalPOCLastName: fiscalPOCLastName,
                fiscalPOCMail: fiscalPOCMail,
                fiscalPOCMobile: fiscalPOCMobile,
                cfdiUse: FiscalUse(rawValue: cfdiUse),
                firstName: firstName,
                secondName: secondName,
                lastName: lastName,
                secondLastName: secondLastName,
                birthDay: Int(birthDay),
                birthMonth: Int(birthMonth),
                birthYear: Int(birthYear),
                curp: curp,
                telephone: telephone,
                telephone2: telephone2,
                email: email,
                email2: email2,
                mobile: mobile,
                mobile2: mobile2,
                contacto1: contacto1,
                contacto2: contacto2,
                contactTel: contactTel,
                street: street,
                colony: colony,
                city: city,
                zip: zip,
                state: state,
                country: country,
                mailStreet: mailStreet,
                mailColony: mailColony,
                mailCity: mailCity,
                mailZip: mailZip,
                mailState: mailState,
                mailCountry: mailCountry,
                IDType: IdentificationTypes(rawValue: IDType),
                IDNum: IDNum,
                sexo: Genders(rawValue: sexo)
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError )
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Datos guardados")
      
                if self.accountView.businessName != self.businessName {
                    self.accountView.businessName = self.businessName
                }
                
                if self.accountView.costType != costType {
                    /// cost_a, cost_b cost_c
                    self.accountView.costType = costType
                }
                
                if self.accountView.type.wrappedValue != type {
                    ///personal, empresaFisica, empresaMoral, organizacion
                    self.accountView.type.wrappedValue = type
                }
                
                if self.accountView.thirdPartyService != self.thirdPartyService {
                    self.accountView.thirdPartyService = self.thirdPartyService
                }
                
                if self.accountView.isConcessionaire != self.isConcessionaire {
                    self.accountView.isConcessionaire = self.isConcessionaire
                }
                
                if self.accountView.sendOrderCommunication != self.sendOrderCommunication {
                    self.accountView.sendOrderCommunication = self.sendOrderCommunication
                }
                
                if self.accountView.firstName != self.firstName {
                    self.accountView.firstName = self.firstName
                }
                
                if self.accountView.secondName != self.secondName {
                    self.accountView.secondName = self.secondName
                }
                
                if self.accountView.lastName != self.lastName {
                    self.accountView.lastName = self.lastName
                }
                
                if self.accountView.secondLastName != self.secondLastName {
                    self.accountView.secondLastName = self.secondLastName
                }
                
                if self.accountView.sexo != Genders(rawValue: self.sexo) {
                    /// male, female
                    /// Genders
                    self.accountView.sexo = Genders(rawValue: self.sexo)
                }
                
                if self.accountView.birthDay != self.birthDay {
                    self.accountView.birthDay = self.birthDay
                }
                
                if self.accountView.birthMonth != self.birthMonth {
                    self.accountView.birthMonth = self.birthMonth
                }
                
                if self.accountView.birthYear != self.birthYear {
                    self.accountView.birthYear = self.birthYear
                }
                
                if self.accountView.rfc != self.rfc {
                    self.accountView.rfc = self.rfc
                }
                
                
                if self.accountView.curp != self.curp {
                    self.accountView.curp = self.curp
                }
                
                if self.accountView.IDType != IdentificationTypes(rawValue: self.IDType) {
                    /// driversLicens, identification, passport, scholar, votersCard, other
                    /// IdentificationTypes
                    self.accountView.IDType = IdentificationTypes(rawValue: self.IDType)
                }
                
                if self.accountView.IDNum != self.IDNum {
                    self.accountView.IDNum = self.IDNum
                }
                
                if self.accountView.telephone != self.telephone {
                    self.accountView.telephone = self.telephone
                }
                
                if self.accountView.telephone2 != self.telephone2 {
                    self.accountView.telephone2 = self.telephone2
                }
                
                if self.accountView.mobile != self.mobile {
                    self.accountView.mobile = self.mobile
                }
                
                if self.accountView.mobile2 != self.mobile2 {
                    self.accountView.mobile2 = self.mobile2
                }
                
                if self.accountView.mobile2 != self.mobile2 {
                    self.accountView.mobile2 = self.email
                }
                
                if self.accountView.email2 != self.email2 {
                    self.accountView.email2 = self.email2
                }
                
                if self.accountView.street != self.street {
                    self.accountView.street = self.street
                }
                
                if self.accountView.colony != self.colony {
                    self.accountView.colony = self.colony
                }
                
                if self.accountView.city != self.city {
                    self.accountView.city = self.city
                }
                
                if self.accountView.state != self.state {
                    self.accountView.state = self.state
                }
                
                if self.accountView.country != self.country {
                    self.accountView.country = self.country
                }
                
                if self.accountView.zip != self.zip {
                    self.accountView.zip = self.zip
                }
                
                if self.accountView.mailStreet != self.mailStreet {
                    self.accountView.mailStreet = self.mailStreet
                }
                
                if self.accountView.mailColony != self.mailColony {
                    self.accountView.mailColony = self.mailColony
                }
                
                if self.accountView.mailCity != self.mailCity {
                    self.accountView.mailCity = self.mailCity
                }
                
                if self.accountView.mailZip != self.mailZip {
                    self.accountView.mailZip = self.mailZip
                }
                
                if self.accountView.mailState != self.mailState {
                    self.accountView.mailState = self.mailState
                }
                
                if self.accountView.mailCountry != self.mailCountry {
                    self.accountView.mailCountry = self.mailCountry
                }
                
                if self.accountView.fiscalProfile != UUID(uuidString: self.fiscalProfile) {
                    self.accountView.fiscalProfile = UUID(uuidString: self.fiscalProfile)
                }
                
                if self.accountView.fiscalProfileName != self.fiscalProfileName {
                    self.accountView.fiscalProfileName = self.fiscalProfileName
                }
                
                if self.accountView.fiscalRazon != self.fiscalRazon {
                    self.accountView.fiscalRazon = self.fiscalRazon
                }
                
                if self.accountView.fiscalRfc != self.fiscalRfc {
                    self.accountView.fiscalRfc = self.fiscalRfc
                }
                
                if self.accountView.fiscalRegime != FiscalRegimens(rawValue: self.fiscalRegime) {
                    self.accountView.fiscalRegime = FiscalRegimens(rawValue: self.fiscalRegime)
                }
                
                if self.accountView.fiscalZip != self.fiscalZip {
                    self.accountView.fiscalZip = self.fiscalZip
                }
                
                if self.accountView.fiscalPOCFirstName != self.fiscalPOCFirstName {
                    self.accountView.fiscalPOCFirstName = self.fiscalPOCFirstName
                }
                
                if self.accountView.fiscalPOCLastName != self.fiscalPOCLastName {
                    self.accountView.fiscalPOCLastName = self.fiscalPOCLastName
                }
                
                if self.accountView.fiscalPOCMobile != self.fiscalPOCMobile {
                    self.accountView.fiscalPOCMobile = self.fiscalPOCMobile
                }
                
                if self.accountView.fiscalPOCMail != self.fiscalPOCMail {
                    self.accountView.fiscalPOCMail = self.fiscalPOCMail
                }
                
                if self.accountView.cfdiUse != FiscalUse(rawValue: self.cfdiUse) {
                    self.accountView.cfdiUse = FiscalUse(rawValue: self.cfdiUse)
                }
                
                if self.accountView.contacto1 != self.contacto1 {
                    self.accountView.contacto1 = self.contacto1
                }
                
                if self.accountView.contacto2 != self.contacto2 {
                    self.accountView.contacto2 = self.contacto2
                }
                
                if self.accountView.contactTel != self.contactTel {
                    self.accountView.contactTel = self.contactTel
                }
                
                if self.accountView.contactMail != self.contactMail {
                    self.accountView.contactMail =  self.contactMail
                }
                
                self.remove()
                
            }
        }
    }
}
