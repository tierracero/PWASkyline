//
//  AccountView.swift
//
//
//  Created by Victor Cantu on 7/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

class AccountView: PageController {
    
    override class var name: String { "div" }
    
    var account: CustAcct
    
    init(
        account: CustAcct,
        cardId: State<String>,
        acctType: State<CustAcctTypes>
    ) {
        self.account = account
        
        self.folio = account.folio
        self.username = account.username
        self.businessName = account.businessName
        /// cost_a, cost_b cost_c
        self.costType = account.costType
        ///personal, empresaFisica, empresaMoral, organizacion
        self.type = acctType
        
        self.thirdPartyService = account.thirdPartyService
        
        self.isConcessionaire = account.isConcessionaire
        
        self.sendOrderCommunication = account.sendOrderCommunication
        
        self.firstName = account.firstName
        self.secondName = account.secondName
        self.lastName = account.lastName
        self.secondLastName = account.secondLastName
        /// male, female
        self.sexo = account.sexo
        
        self.birthDay = account.birthDay?.toString ?? ""
        self.birthMonth = account.birthMonth?.toString ?? ""
        self.birthYear = account.birthYear?.toString ?? ""
        self.rfc = account.rfc
        self.curp = account.curp
        
        ///driversLicens, identification, passport, scholar, votersCard, other
        self.IDType = account.IDType
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
        
        self.autoPaySpei = account.autoPaySpei
        self.autoPayOxxo = account.autoPayOxxo
        
        //If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
        self.fiscalProfile = account.fiscalProfile
        self.fiscalProfileName = ""
        self.fiscalRazon = account.fiscalRazon
        self.fiscalRfc = account.fiscalRfc
        self.fiscalRegime = account.fiscalRegime
        self.fiscalZip = account.fiscalZip
        
        self.fiscalPOCFirstName = account.fiscalPOCFirstName
        self.fiscalPOCLastName = account.fiscalPOCLastName
        self.fiscalPOCMobile = account.fiscalPOCMobile
        self.fiscalPOCMobileValidaded = account.fiscalPOCMobileValidaded
        
        self.fiscalPOCMail = account.fiscalPOCMail
        self.fiscalPOCMailValidaded = account.fiscalPOCMailValidaded
        
        self.cfdiUse = account.cfdiUse
        self.autoFact = account.autoFact
        
        ///Credit Account
        self.cracct = account.cracct
        
        /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
        self.crstatus = account.crstatus
        
        self.contacto1 = account.contacto1
        self.contacto2 = account.contacto2
        self.contactTel = account.contactTel
        self.contactMail =  account.contactMail
        
        self.validated = account.validated
        //due: Int = account.due
        self.balance = account.balance.toString
        self.CardID = cardId
        cardId.wrappedValue = account.CardID
        self.rewardsLevel = account.rewardsLevel
        self.lat = account.lat
        self.lon = account.lon
        
        self.telegramId = account.telegramId
        
        /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
        self.status = account.status
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var pMode: PanelMode = .serviceOrder
    
    @State var accountEditMode = false
    
    @State var membershipExpire: Int64? = nil
    
    @State var membershipId: UUID? = nil
    
    @State var membershipName: String? = nil
    
    var folio: String
    @State var username: String
    @State var businessName: String
    /// cost_a, cost_b cost_c
    /// CustAcctCostTypes
    @State var costType: CustAcctCostTypes
    ///personal, empresaFisica, empresaMoral, organizacion
    var type: State<CustAcctTypes>
    
    @State var thirdPartyService: Bool
    
    @State var isConcessionaire: Bool
    
    @State var sendOrderCommunication: Bool
    
    @State var firstName: String
    @State var secondName: String
    @State var lastName: String
    @State var secondLastName: String
    
    /// male, female
    @State var sexo: Genders? = .male
    @State var birthDay: String
    @State var birthMonth: String
    @State var birthYear: String
    @State var rfc: String
    @State var curp: String
    
    ///driversLicens, identification, passport, scholar, votersCard, other
    @State var IDType: IdentificationTypes? = nil
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
    
    var mailStreet: String
    var mailColony: String
    var mailCity: String
    var mailState: String
    var mailCountry: String
    var mailZip: String
    
    @State var autoPaySpei: String
    @State var autoPayOxxo: String
    
    ///If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
    @State var fiscalProfile: UUID?
    @State var fiscalProfileName: String
    @State var fiscalRazon: String
    @State var fiscalRfc: String
    @State var fiscalRegime: FiscalRegimens?
    @State var fiscalZip: String
    
    @State var fiscalPOCFirstName: String
    @State var fiscalPOCLastName: String
    @State var fiscalPOCMail: String
    @State var fiscalPOCMobile: String
    @State var fiscalPOCMobileValidaded: Bool
    @State var fiscalPOCMailValidaded: Bool
    @State var cfdiUse: FiscalUse?
    @State var autoFact: Bool
    
    ///Credit Account
    @State var cracct: UUID? = nil
    /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
    @State var crstatus: CustCreditStatus?
    
    @State var contacto1: String
    @State var contacto2: String
    @State var contactTel: String
    @State var contactMail: String
    
    @State var validated: Bool
    //@State var due: Int = account.due
    @State var balance: String
    var CardID: State<String>
    
    @State var rewardsBalanceText: String = "0"
    
    @State var pendingRewardsBalanceText: String = "0"
    
    var rewardsLevel: RewardsProgramType
    
    var lat: String
    var lon: String
    var telegramId: Int64?
    /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
    @State var status: GeneralStatus
    
    /// finance, credit
    @State var currentAccountTab: CurrentAccountTab = .finance
    
    @State var notes: [CustGeneralNotesQuick] = []
    
    @State var bills: [CustAcctBillingQuick] = []
    
    @State var mrcs: [CustAcctChargesQuick] = []
    
    @State var unbilled: [CustAcctChargesQuick] = []
    
    lazy var avatar = Img()
    
    lazy var membershipExpireText = Div(self.$membershipExpire.map{ (($0 ?? 0) < getNow()) ? "Membresia Inactiva" : getDate(($0 ?? 0)).formatedLong})
        .color(self.$membershipExpire.map{ (($0 ?? 0) < getNow()) ? .fireBrick : .chartreuse })
        .class(.oneLineText)
        .textAlign(.center)
        .fontSize(24.px)
    
    lazy var membershipNameText = Div(self.$membershipName.map { ($0 == nil) ? "Sin Membresia" : ($0 ?? "")} )
        .color(self.$membershipName.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .textAlign(.center)
        .fontSize(24.px)
    
    lazy var usernameText = Div(self.$username.map{ $0.isEmpty ? "user@siwe.mx" : $0 })
        .color(self.$username.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var businessNameText = Div(self.$businessName.map{ $0.isEmpty ? "Nombre Negocio" : $0 })
        .color(self.$username.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    /// cost_a, cost_b cost_c
    lazy var costTypeText = Div(self.$costType.map{ $0.description })
        .class(.oneLineText)
        .color(.lightGray)
        .fontSize(24.px)
    
    ///personal, empresaFisica, empresaMoral, organizacion
    lazy var typeText = Div(self.type.map{ $0.description })
        .class(.oneLineText)
        .color(.lightGray)
        .fontSize(24.px)
    
    lazy var firstNameText = Div(self.$firstName.map{ $0.isEmpty ? String.firstName : $0 })
        .color(self.$firstName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var secondNameText = Div(self.$secondName.map{ $0.isEmpty ? String.secondName : $0 })
        .color(self.$secondName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var lastNameText = Div(self.$lastName.map{ $0.isEmpty ? String.lastName : $0 })
        .color(self.$lastName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var secondLastNameText = Div(self.$secondLastName.map{ $0.isEmpty ? String.secondLastName : $0 })
        .color(self.$secondLastName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    /// male, female
    lazy var sexoText = Div(self.$sexo.map{ ($0 == nil) ? "Sexo" : $0!.description })
        .color(self.$sexo.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var birthDayText =  Div(self.$birthDay.map{ $0.isEmpty ? "24" : $0 })
        .color(self.$birthDay.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var birthMonthText = Div(self.$birthMonth.map{ $0.isEmpty ? "7" : $0 })
        .color(self.$birthMonth.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var birthYearText = Div(self.$birthYear.map{ $0.isEmpty ? "1980" : $0 })
        .color(self.$birthYear.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var rfcText = Div(self.$rfc.map{ $0.isEmpty ? "RFC Personal" : $0 })
        .color(self.$rfc.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var curpText = Div(self.$curp.map{ $0.isEmpty ? "CURP" : $0 })
        .color(self.$username.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    ///driversLicens, identification, passport, scholar, votersCard, other
    lazy var IDTypeText = Div(self.$IDType.map{ ($0 == nil) ? "Tipo de ID" : $0!.description })
        .color(self.$IDType.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var IDNumText = Div(self.$IDNum.map{ $0.isEmpty ? "Numero de ID" : $0 })
        .color(self.$IDNum.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var telephoneText = Div(self.$telephone.map{ $0.isEmpty ? String.telephone : $0 })
        .color(self.$telephone.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var telephone2Text = Div(self.$telephone2.map{ $0.isEmpty ? "Telefono Secundario" : $0 })
        .color(self.$telephone2.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var mobileText = Div(self.$mobile.map{ $0.isEmpty ? String.mobile : $0 })
        .color(self.$mobile.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var mobileField = InputText(self.$mobile)
        .custom("width","calc(100% - 18px)")
        .placeholder(String.mobile)
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var mobile2Text = Div(self.$mobile2.map{ $0.isEmpty ? "Telefono Secundario" : $0 })
        .color(self.$mobile2.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var emailText = Div(self.$email.map{ $0.isEmpty ? "Correo Electronico" : $0 })
        .color(self.$email.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var email2Text = Div(self.$email2.map{ $0.isEmpty ? "Correo Secundario" : $0 })
        .color(self.$email2.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var email2Field = InputText(self.$email2)
        .placeholder(LString(String.emailSecondary))
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var streetText = Div(self.$street.map{ $0.isEmpty ? String.streetNumber : $0 })
        .color(self.$street.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var colonyText = Div(self.$colony.map{ $0.isEmpty ? String.colony : $0 })
        .color(self.$colony.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var cityText = Div(self.$city.map{ $0.isEmpty ?.city : $0 })
        .color(self.$city.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var stateText = Div(self.$state.map{ $0.isEmpty ? .state : $0 })
        .color(self.$state.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var countryText = Div( self.$country.map{ $0.isEmpty ? "Pais" : $0 } )
        .color(self.$country.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var zipText = Div(self.$zip.map{ $0.isEmpty ? .zipCode : $0 })
        .color(self.$zip.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var autoPaySpeiText = Div(self.$autoPaySpei.map{ $0.isEmpty ? "SPEI Unico" : $0 })
        .color(self.$autoPaySpei.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var autoPayOxxoText = Div(self.$autoPayOxxo.map{ $0.isEmpty ? "OXXO Pay" : $0 })
        .color(self.$autoPayOxxo.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    ///If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
    lazy var fiscalProfileText = Div(self.$fiscalProfile.map{ ($0 == nil) ? "Perfil Fiscal" : $0!.description })
        .color(self.$fiscalProfile.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalRazonText = Div(self.$fiscalRazon.map{ $0.isEmpty ? "Razon Social" : $0 })
        .color(self.$fiscalRazon.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalRfcText = Div(self.$fiscalRfc.map{ $0.isEmpty ? "RFC" : $0 })
        .color(self.$fiscalRfc.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalRegimeText = Div(self.$fiscalRegime.map{ ($0 == nil) ? "Regimen Fiscal" : $0!.description })
        .color(self.$fiscalRegime.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalZipText = Div(self.$fiscalZip.map{ $0.isEmpty ? "CP Fiscal" : $0 })
        .color(self.$fiscalZip.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalPOCFirstNameText = Div(self.$fiscalPOCFirstName.map{ $0.isEmpty ? "CF Nombre" : $0 })
        .color(self.$fiscalPOCFirstName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalPOCLastNameText = Div(self.$fiscalPOCLastName.map{ $0.isEmpty ? "CF Apellido" : $0 })
        .color(self.$fiscalPOCFirstName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalPOCMobileText = Div(self.$fiscalPOCMobile.map{ $0.isEmpty ? "CF Celular" : $0 })
        .color(self.$fiscalPOCMobile.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalPOCMobileValidadedCheckBox = InputCheckbox(self.$fiscalPOCMobileValidaded)
        .disabled(true)
    
    lazy var fiscalPOCMailText = Div(self.$fiscalPOCMail.map{ $0.isEmpty ? "CF Celular" : $0 })
        .color(self.$fiscalPOCMail.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var fiscalPOCMailValidadedCheckBox = InputCheckbox(self.$fiscalPOCMailValidaded)
        .disabled(true)
    
    lazy var cfdiUseText = Div(self.$cfdiUse.map{ ($0 == nil) ? "Uso CFDI" : $0!.description })
        .color(self.$cfdiUse.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var autoFactToggle = InputCheckbox().toggle(self.$autoFact)
    
    lazy var contacto1Text = Div(self.$contacto1.map{ $0.isEmpty ? "Contacto Nombre" : $0 })
        .color(self.$contacto1.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var contacto2Text = Div(self.$contacto2.map{ $0.isEmpty ? "Contacto Apellido" : $0 })
        .color(self.$contacto2.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var contactTelText = Div(self.$contactTel.map{ $0.isEmpty ? "Cel Contacto" : $0 })
        .color(self.$contactTel.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var contactMailText = Div(self.$contactMail.map{ $0.isEmpty ? "Correo Contacto" : $0 })
        .color(self.$contactMail.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var validatedToggle = InputCheckbox(self.$validated)
        .disabled(true)
    
    lazy var balanceText = Div(self.$balance.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$balance.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var rewardsText = Div{
        Span(self.$rewardsBalanceText.map{ $0.isEmpty ? "0.00" : $0 })
            .color(.yellowTC)
        Span("/")
            .marginRight(3.px)
            .marginLeft(3.px)
            .color(.gray)
        Span(self.$pendingRewardsBalanceText.map{ $0.isEmpty ? "0.00" : $0 })
            .color(.gray)
    }
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var CardIDText = Div(self.CardID.map{ $0.isEmpty ? "Tarjeta de Puntos" : $0 })
        .color(self.CardID.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .class(.oneLineText)
        .fontSize(24.px)
    
    lazy var planAndServiceDiv = Div{
        Table {
            Tr{
                Td("cargando...")
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
    
    lazy var notesDiv = Div{
        Table {
            Tr{
                Td("cargando...")
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
    
    lazy var unbilledDiv = Div{
        Table {
            Tr{
                Td("cargando...")
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
    
    lazy var billingDiv = Div{
        Table {
            Tr{
                Td("cargando...")
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
    
    lazy var creditDetailView = Div()
    
    @State var noteTypeListener = ""
    
    lazy var noteTypeSelect = Select(self.$noteTypeListener)
        .class(.textFiledBlackDarkLarge)
        .fontSize(18.px)
        .width(200.px)
        .height(23.px)
        .float(.right)
        .body {
            Option("Todas")
                .value("")
        }
    
    var smsTokens: [String] = []
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div{
                
                Div{
                    
                    Img()
                        .src( "/skyline/media/pencil.png" )
                        .padding(all: 3.px)
                        .paddingLeft(7.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(24.px)
                        .onClick {
                            
                            let account = CustAcct(
                                id: self.account.id,
                                folio: self.account.folio,
                                createdAt: getNow(),
                                modifiedAt: getNow(),
                                expiredAt: nil,
                                basePlanId: nil,
                                basePlanName: nil,
                                username: "",
                                password: "",
                                pin: 0,
                                businessName: self.businessName,
                                costType: self.costType,
                                type: self.type.wrappedValue,
                                store:  nil,
                                thirdPartyService: self.thirdPartyService,
                                sendOrderCommunication: self.sendOrderCommunication,
                                title: self.title,
                                firstName: self.firstName,
                                secondName: self.secondName,
                                lastName: self.lastName,
                                secondLastName: self.secondLastName,
                                sexo: self.sexo,
                                birthDay: Int(self.birthDay),
                                birthMonth: Int(self.birthDay),
                                birthYear: Int(self.birthDay),
                                rfc: self.rfc,
                                curp: self.curp,
                                nss: self.account.nss,
                                IDType: self.IDType,
                                IDNum: self.IDNum,
                                tcc: "",
                                telephone: self.telephone,
                                t2cc: "",
                                telephone2: self.telephone2,
                                mcc: "",
                                mobile: self.mobile,
                                m2cc: "",
                                mobile2: self.mobile2,
                                email: self.email,
                                email2: self.email2,
                                street: self.street,
                                colony: self.colony,
                                city: self.city,
                                state: self.state,
                                country: self.country,
                                zip: self.zip,
                                mailStreet: self.mailStreet,
                                mailColony: self.mailColony,
                                mailCity: self.mailCity,
                                mailState: self.mailState,
                                mailCountry: self.mailCountry,
                                mailZip: self.mailZip,
                                autoPaySpei: "",
                                autoPayOxxo: "",
                                fiscalProfile: self.fiscalProfile,
                                fiscalRazon: self.fiscalRazon,
                                fiscalRfc: self.fiscalRfc,
                                fiscalRegime: self.fiscalRegime,
                                fiscalZip: self.fiscalZip,
                                fiscalPOCFirstName: self.fiscalPOCFirstName,
                                fiscalPOCLastName: self.fiscalPOCLastName,
                                fmcc: "",
                                fiscalPOCMobile: self.fiscalPOCMobile,
                                fiscalPOCMobileValidaded: self.fiscalPOCMobileValidaded,
                                fiscalPOCMail: self.fiscalPOCMail,
                                fiscalPOCMailValidaded: self.fiscalPOCMailValidaded,
                                cfdiUse: self.cfdiUse,
                                fiscalRecipt: self.account.fiscalRecipt,
                                autoFact: self.autoFact,
                                billDate: nil,
                                cracct: self.cracct,
                                crstatus: self.crstatus,
                                isConcessionaire: self.isConcessionaire,
                                contacto1: self.contacto1,
                                contacto2: self.contacto2,
                                ctcc: "",
                                contactTel: self.contactTel,
                                contactMail: self.contactMail,
                                validated: self.validated,
                                due: 0,
                                balance: 0,
                                CardID: "",
                                rewardsLevel: self.rewardsLevel,
                                rewards: Int(self.rewardsBalanceText) ?? 0,
                                lat: "",
                                lon: "",
                                telegramId: nil,
                                avatar: "",
                                status: self.account.status
                            )
                            
                            addToDom(DetailView(
                                account: account,
                                accountView: self
                            ))
                            
                        }
                    
                    H2("Datos de la Cuenta")
                        .color(.lightBlueText)
                        .class(.oneLineText)
                }
                
                Div().class(.clear).marginBottom(3.px)
                
                Div{
                    
                    Div(self.$status.map{ $0.description })
                        .fontSize(26.px)
                        .float(.right)
                        .color(.white)
                    
                    Label{
                        Span("Cuenta")
                            .marginRight(7.px)
                        
                        Span(self.folio)
                    }
                        .color(.goldenRod)
                        .fontSize(26.px)
                }
                Div().class(.clear).marginBottom(7.px)
                
                /// Tarjeta de Lealtad y usuario
                Div{
                    Div{
                        self.avatar
                            .src("skyline/media/defaultPanda.png")
                            .borderRadius(12.px)
                            .cursor(.pointer)
                            .height(100.px)
                            .width(100.px)
                            .onClick {
                                self.getProfilePicture()
                            }
                    }
                    .class(.oneHalf)
                    .align(.center)
                    
                    Div{
                        
                        Div{
                            Img()
                                .float(.right)
                                .cursor(.pointer)
                                .src("/skyline/media/add.png")
                                .height(18.px)
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .onClick { img, event in
                                    
                                    guard self.type.wrappedValue == .personal else {
                                        showError(.errorGeneral, "Lo sentimos las cuentas \(self.type.wrappedValue.description) aun no es soportado.")
                                        return
                                    }
                                    
                                    addToDom(RequestSiweCard(
                                        accountId: self.account.id,
                                        cc: .mexico,
                                        mobile: self.account.mobile,
                                        callback: { token, cardId, _ in
                                            self.smsTokens.append(token)
                                            
                                            addToDom(ConfimeSiweCard(
                                                custAcct: self.account.id,
                                                cc: .mexico,
                                                mobile: self.account.mobile,
                                                tokens: self.smsTokens,
                                                cardId: cardId,
                                                callback: { cardId in
                                                    self.CardID.wrappedValue = cardId
                                                    self.account.CardID = cardId
                                                }
                                            ))
                                            
                                        }))
                                }
                            
                            Div("Tarjeta de Lealtad")
                                .class(.oneLineText)
                            
                        }
                        
                        Div().class(.clear)
                        
                        self.CardIDText
                        
                        Div("Nombre de Usuario")
                            .class(.oneLineText)
                        
                        Div().class(.clear).paddingTop(2.px)
                        
                        self.usernameText
                    }
                    .marginLeft(1.percent)
                    .class(.oneHalf)
                    Div().class(.clear)
                }
                
                /// Balance y Cuenta
                Div{
                    
                    Div{
                        Label("Balance Cuenta")
                            .fontSize(20.px)
                        Div().class(.clear)
                        
                        self.balanceText
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            
                            Label("Recompensa")
                                .fontSize(20.px)
                            
                            Img()
                                .src("/skyline/media/star_yellow.png")
                                .cursor(.pointer)
                                .float(.right)
                                .width(24.px)
                                .onClick {
                                    
                                    if self.account.CardID.isEmpty {
                                        showError(.errorGeneral, "Este cliente no tiene el programa activo.")
                                        return
                                    }
                                    print("⭐️  ⭐️  self.rewardsBalanceText \(self.rewardsBalanceText)")
                                    
                                    let points = Int(self.rewardsBalanceText) ?? 0
                                    
                                    addToDom(RewardsView(
                                        accountId: self.account.id,
                                        mobile: self.account.mobile,
                                        cardId: self.account.CardID,
                                        points: points
                                    ))
                                }
                            
                        }
                        
                        Div().class(.clear)
                        
                        self.rewardsText
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                }
                
                /// Tipo y Precio de cuenta
                Div{
                    Label("Tipo de Cuenta / Precio")
                    
                    Div().class(.clear)
                    
                    Div{
                        self.typeText
                    }
                    .class(.oneHalf)
                    Div{
                        self.costTypeText
                    }
                    .marginLeft(1.percent)
                    .class(.oneHalf)
                    Div().class(.clear)
                    
                }
                /// Servicios a Terceros
                Div{
                    
                    Div().height(3.px).clear(.both)
                    
                    Div("Servicios a Terceros")
                        .class(.oneLineText)
                        .width(80.percent)
                        .float(.left)
                    
                    Div{
                        InputCheckbox()
                            .toggle(self.$thirdPartyService, true)
                            .opacity(0.5)
                    }
                    .width(20.percent)
                    .float(.left)
                    
                    Div().height(3.px).clear(.both)
                    
                }
                .hidden(self.type.map{ $0 == .personal })
                
                /// Consesionario
                Div{
                    
                    Div().height(3.px).clear(.both)
                    
                    Div("Consesionario")
                        .class(.oneLineText)
                        .width(80.percent)
                        .float(.left)
                    
                    Div{
                        InputCheckbox()
                            .toggle(self.$isConcessionaire, true)
                            .opacity(0.5)
                    }
                    .width(20.percent)
                    .float(.left)
                    
                    Div().height(3.px).clear(.both)
                    
                }
                .hidden(self.type.map{ $0 == .personal })

                /// Mensajes en Ordenes
                Div{
                    
                    Div().height(3.px).clear(.both)
                    
                    Div("Mensajes en Ordenes")
                        .class(.oneLineText)
                        .width(80.percent)
                        .float(.left)
                    
                    Div{
                        InputCheckbox()
                            .toggle(self.$sendOrderCommunication, true)
                            .opacity(0.5)
                    }
                    .width(20.percent)
                    .float(.left)
                    
                    Div().height(3.px).clear(.both)
                    
                }
                .hidden(self.type.map{ $0 == .personal })
                
                if self.pMode == .clubMembership {
                    Div().class(.clear).marginTop( 7.px)
                    
                    Div{
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/star_yellow.png")
                                .marginLeft(7.px)
                                .height(18.px)
                            
                            Span("Renovar")
                        }
                        .marginTop(-7.px)
                        .class(.uibtn)
                        .float(.right)
                        .onClick {
                            
                            addToDom(
                                AccountMembershipControlView(
                                    accountId: self.account.id,
                                    cardId: self.CardID.wrappedValue,
                                    currentMembership: self.membershipId,
                                    currentActivationTime: self.membershipExpire,
                                    billDate: Int64(self.account.billDate ?? 1),
                                    callback: { uts, planid, planName, balance in
                                        
                                        self.membershipExpire = uts
                                        
                                        self.membershipId = planid
                                        
                                        self.membershipName = planName
                                        
                                        self.balance = balance.formatMoney
                                        
                                    }
                                )
                            )
                            
                        }
                        
                        H2("Membresia")
                            .color(.goldenRod)
                    }
                    
                    Div().class(.clear).marginTop( 3.px)
                    
                    Div{
                        
                        Label("Vigencia de Membresia")
                        
                        Div().class(.clear).marginTop( 3.px)
                        
                        self.membershipExpireText
                        
                        Div().class(.clear).marginTop( 7.px)
                        
                        Label("Nombre de Membresia")
                        
                        Div().class(.clear).marginTop( 3.px)
                        
                        self.membershipNameText
                        
                        Div().class(.clear).marginTop( 7.px)
                        
                    }
                    .padding(all: 7.px)
                    .class(.roundBlue)
                    
                }
                
                Div{
                    Img()
                        .float(.right)
                        .cursor(.pointer)
                        .src("/skyline/media/add.png")
                        .height(24.px)
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .onClick { img, event in
                            
                        }
                    
                    H2("Referencias de Pagos")
                }
                
                Div().class(.clear).marginTop( 3.px)
                
                /// OXXO / SPEI Ref
                Div{
                    Label("Refrerencia SPEI")
                    Div().class(.clear).marginTop( 3.px)
                    self.autoPaySpeiText
                    Div().class(.clear).marginTop( 7.px)
                    Label("Refrerencia OXXO")
                    Div().class(.clear).marginTop( 3.px)
                    self.autoPayOxxoText
                }
                .padding(all: 7.px)
                .class(.roundBlue)
                
                Div().class(.clear).marginTop( 7.px)
                /// Names
                Label("Información personal y de contacto")
                    .marginTop(12.px)
                Div{
                    Div{
                        self.firstNameText
                    }
                    .class(.oneHalf)
                    Div{
                        self.secondNameText
                    }
                    .class(.oneHalf)
                    Div().class(.clear)
                }
                
                /// Last Names
                Div{
                    Div{
                        self.lastNameText
                    }
                    .class(.oneHalf)
                    Div{
                        self.secondLastNameText
                    }
                    .class(.oneHalf)
                    Div().class(.clear)
                }
                
                /// DOB / CURP
                Div{
                    Div{
                        Div("Fecha de Nacimineto")
                            .class(.oneLineText)
                        
                        Div().class(.clear)
                        
                        Div{
                            self.birthDayText
                        }
                        .float(.left)
                        .width(30.percent)
                        Div{
                            self.birthMonthText
                        }
                        .float(.left)
                        .width(30.percent)
                        Div{
                            self.birthYearText
                        }
                        .float(.left)
                        .width(40.percent)
                        
                    }
                    .class(.oneHalf)
                    Div{
                        Label("CURP")
                        Div().class(.clear)
                        self.curpText
                    }
                    .class(.oneHalf)
                    Div().class(.clear)
                }
                
                H3("Información de Contacto")
                    .color(.lightBlueText)
                    .class(.oneLineText)
                
                /// Mobiles
                Div{
                    Div{
                        self.mobileText
                    }
                    .class(.oneHalf)
                    Div{
                        self.mobile2Text
                    }
                    .class(.oneHalf)
                    Div().class(.clear)
                }
                
                /// Telephoens
                Div{
                    Div{
                        self.telephoneText
                    }
                    .class(.oneHalf)
                    Div{
                        self.telephone2Text
                    }
                    .class(.oneHalf)
                    Div().class(.clear)
                }
                
                H3("Direccion General")
                    .color(.lightBlueText)
                    .class(.oneLineText)
                
                Div().class(.clear)
                
                Div{
                    Label("Calle y Numero")
                    Div().class(.clear)
                    self.streetText
                    
                    Label("Colonia")
                    Div().class(.clear)
                    self.colonyText
                    
                    Label("Cuidad")
                    Div().class(.clear)
                    self.cityText
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    
                    Label("Estado")
                    Div().class(.clear)
                    self.stateText
                    
                    Label("Pais")
                    Div().class(.clear)
                    self.countryText
                    
                    Label("Codigo Postal")
                    Div().class(.clear)
                    self.zipText
                    
                }
                .width(50.percent)
                .float(.left)
                
                Div().class(.clear).marginBottom(7.px)
                
                H3("Contacto General")
                    .color(.lightBlueText)
                    .class(.oneLineText)
                Div().class(.clear)
                
                Div{
                    Label("Nombre")
                    Div().class(.clear)
                    self.contacto1Text
                    
                    Label("Apellido")
                    Div().class(.clear)
                    self.contacto2Text
                    
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    
                    Label("Movil")
                    Div().class(.clear)
                    self.contactTelText
                    
                    Label("Correo")
                    Div().class(.clear)
                    self.contactMailText
                    
                }
                .width(50.percent)
                .float(.left)
                
                Div().class(.clear).marginBottom(7.px)
                
                H3("Datos y Contacto Fiscal")
                    .color(.lightBlueText)
                    .class(.oneLineText)
                
                Div().class(.clear)
                
                Label("Nombre de la Empresa")
                Div().class(.clear)
                
                self.businessNameText
                
                Div().class(.clear).marginBottom(7.px)
                
                /// fiscalProfileText
                if !fiscalProfiles.isEmpty {
                    Label("Perfil de facturacion")
                    Div().class(.clear)
                    self.fiscalProfileText
                        .marginBottom(7.px)
                }
                
                Div{
                    self.autoFactToggle
                        .float(.right)
                    
                    Label("Auto Facturar")
                        .color(.goldenRod)
                        .fontSize(26.px)
                }
                
                Div().class(.clear).marginBottom(7.px)
                
                Label(LString(String.razon))
                Div().class(.clear)
                self.fiscalRazonText
                Div().class(.clear)
                
                /// RFC / Zip
                Div{
                    Div{
                        Label(LString(String.rfc))
                        Div().class(.clear)
                        self.fiscalRfcText
                    }
                    .class(.oneHalf)
                    Div{
                        Label("Domicilio")
                        Div().class(.clear)
                        self.fiscalZipText
                    }
                    .class(.oneHalf)
                }
                Div().class(.clear)
                
                /// perfil / uso
                Div{
                    
                    Div{
                        Label("Regimen")
                        Div().class(.clear)
                        self.fiscalRegimeText
                    }
                    .class(.oneHalf)
                    
                    Div{
                        Label("Uso CFDI")
                        Div().class(.clear)
                        self.cfdiUseText
                    }
                    .class(.oneHalf)
                }
                Div().class(.clear)
                
                Div().class(.clear).marginBottom(7.px)
                
                H3("Contacto Fiscal")
                    .color(.lightBlueText)
                    .class(.oneLineText)
                
                Div().class(.clear).marginBottom(3.px)
                
                Div{
                    Label("Nombre")
                    Div().class(.clear)
                    self.fiscalPOCFirstNameText
                    
                    Label("Apellido")
                    Div().class(.clear)
                    self.fiscalPOCLastNameText
                    
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    
                    Div{
                        self.fiscalPOCMobileValidadedCheckBox
                            .float(.right)
                        
                        Label("Movil")
                        
                    }
                    
                    Div().class(.clear)
                    self.fiscalPOCMobileText
                    
                    Div{
                        self.fiscalPOCMailValidadedCheckBox
                            .float(.right)
                        
                        Label("Correo")
                    }
                    
                    Div().class(.clear)
                    self.fiscalPOCMailText
                    
                }
                .width(50.percent)
                .float(.left)
                
                Div().class(.clear)
                    .marginBottom(12.px)
                
            }
            .color(.gray)
        }
        .height(100.percent)
        .width(33.percent)
        .float(.left)
        .overflow(.auto)
        
        Div{
            
            Div{
                
                Div{
                    
                    Img()
                        .src("/skyline/media/add.png")
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(18.px)
                        .onClick { img, event in
                            
                            let view = AddServiceFormView(
                                allowManualCharges: false,
                                socCanLoadAction: false,
                                costType: self.costType) { soc in
                                    
                                    guard let id = soc.id else {
                                        showError(.unexpectedResult, "No se localizo id del codigo")
                                        return
                                    }
                                    
                                    loadingView(show: true)
                                    
                                    API.custAccountV1.addCharge(
                                        socid: id,
                                        accountid: self.account.id,
                                        price: soc.price
                                    ) { resp in
                                        
                                        loadingView(show: false)
                                        
                                        guard let resp else {
                                            showError(.errorGeneral, .serverConextionError)
                                            return
                                        }
                                        
                                        guard resp.status == .ok else {
                                            showError(.errorGeneral, resp.msg)
                                            return
                                        }
                                        
                                        guard let soc = resp.data else {
                                            showError(.unexpectedResult, "No se pudo obtener id del cargo")
                                            return
                                        }
                                        
                                        self.mrcs.append(soc)
                                        
                                    }
                                    
                                }
                            
                            addToDom(view)
                        }
                    
                    H3("Planes y Servicios")
                        .color(.lightGray)
                    
                    Div().class(.clear)
                }
                
                self.planAndServiceDiv
                    .custom("height", "calc(100% - 30px)")
                    .class(.roundGrayBlackDark)
                    .overflow(.auto)
                    .marginTop(7.px)
                
            }
            .custom("width", "calc(50% - 12px)")
            .height(40.percent)
            .padding(all: 3.px)
            .margin(all: 3.px)
            .float(.left)
            
            Div{
                Div{
                    Img()
                        .src("/skyline/media/add.png")
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(18.px)
                        .onClick { img, event in
                            
                            addToDom(AddNoteView(
                                relationType: .account,
                                relationId: self.account.id,
                                callback: { note in
                                    self.notes.insert(note, at: 0)
                                }))
                        }
                    
                    self.noteTypeSelect
                    
                    H3("Notas")
                        .color(.lightGray)
                }
                
                Div().clear(.both)
                
                self.notesDiv
                    .custom("height", "calc(100% - 30px)")
                    .class(.roundGrayBlackDark)
                    .overflow(.auto)
                    .marginTop(7.px)
            }
            .custom("width", "calc(50% - 12px)")
            .height(40.percent)
            .padding(all: 3.px)
            .margin(all: 3.px)
            .float(.left)
            
            Div().class(.clear)
            
            Div{
                
                Div{
                    
                    Div("Presupuestos")
                        .margin(all: 1.px)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .class(.uibtn)
                .float(.right)
                .onClick(self.loadBudgets)
                
                Div{
                    
                    Div("Concesiones")
                        .margin(all: 1.px)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .hidden(self.$isConcessionaire.map{ !$0 })
                .class(.uibtn)
                .float(.right)
                .onClick{
                    addToDom(CustConcessionView(account: self.account))
                }
                
                H3("Cargos y Finanzas")
                    .backgroundColor( self.$currentAccountTab.map{$0 == .finance ? .lightBlueText : .transparent})
                    .color( self.$currentAccountTab.map{$0 == .finance ? .white : .lightBlueText})
                    .padding(top: 3.px, right: 7.px, bottom: 3.px, left: 7.px)
                    .borderRadius(all: 12.px)
                    .marginLeft(7.px)
                    .cursor(.pointer)
                    .float(.left)
                    .onClick {
                        self.currentAccountTab = .finance
                    }
                
                H3("Credito")
                    .backgroundColor( self.$currentAccountTab.map{$0 == .credit ? .lightBlueText : .transparent})
                    .color( self.$currentAccountTab.map{$0 == .credit ? .white : .lightBlueText})
                    .padding(top: 3.px, right: 7.px, bottom: 3.px, left: 7.px)
                    .borderRadius(all: 12.px)
                    .marginLeft(7.px)
                    .cursor(.pointer)
                    .float(.left)
                    .onClick {
                        self.currentAccountTab = .credit
                    }
            }
            .height(30.px)
            
            Div{
                Div{
                    Div{
                        /// ``Add payment``
                        Div{
                            
                            Div{
                                Img()
                                    .src("/skyline/media/coin.png")
                                    .height(18.px)
                            }
                            .float(.left)
                            
                            Span("Pago")
                                .fontSize(16.px)
                                .paddingTop(0.px)
                        }
                        .marginRight(0.px)
                        .marginTop(-3.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            
                            let _balance = (Float(self.balance) ?? 0).toCents
                            
                            let paymentView = AddPaymentFormView (
                                accountId: self.account.id,
                                cardId: self.CardID.wrappedValue,
                                currentBalance: _balance
                            ) { code, description, amount, provider, lastFour, auth, uts in
                                
                                loadingView(show: true)
                                
                                API.custAccountV1.addPayment(
                                    accountid: self.account.id,
                                    storeId: custCatchStore,
                                    fiscCode: code,
                                    description: description,
                                    cost: amount,
                                    provider: provider,
                                    lastFour: lastFour,
                                    auth: auth
                                ) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp else{
                                        showError(.errorDeCommunicacion, "No se pudieron cargar detalles de la cuenta.")
                                        return
                                    }
                                    
                                    guard resp.status == .ok else{
                                        showError(.errorGeneral, "No se pudieron cargar detalles de la cuenta.")
                                        return
                                    }
                                    
                                    guard let payload = resp.data else {
                                        showError(.unexpectedResult, "No se obtuvo data de la peticion.")
                                        return
                                    }
                                    
                                    switch self.pMode {
                                    case .serviceOrder:
                                        break
                                    case .dates:
                                        break
                                    case .accounts:
                                        break
                                    case .clubMembership:
                                        self.balance = payload.balance.formatMoney
                                    }
                                    
                                    showSuccess(.operacionExitosa, "Pago exitoso \(payload.paymentFolio)")
                                    
                                }
                                
                            }
                            
                            paymentView.isDownPaymentDisabled = true
                            
                            addToDom(paymentView)
                            
                        }
                        
                        /// ``Add Charges``
                        Div{
                            
                            Div{
                                Img()
                                    .src("/skyline/media/add.png")
                                    .height(18.px)
                            }
                            .float(.left)
                            
                            Span("Cargos")
                                .fontSize(16.px)
                                .paddingTop(0.px)
                        }
                        .marginRight(7.px)
                        .marginTop(-3.px)
                        .float(.right)
                        .class(.uibtn)
                        
                        Img()
                            .src("/skyline/media/spreadsheet.png")
                            .padding(all: 3.px)
                            .marginRight(7.px)
                            .marginTop(-3.px)
                            .cursor(.pointer)
                            .float(.right)
                            .height(18.px)
                            .onClick { img, event in
                                
                            }
                        
                        H3("Cargos")
                            .color(.lightGray)
                    }
                    
                    self.unbilledDiv
                        .custom("height", "calc(100% - 30px)")
                        .class(.roundDarkBlue)
                        .marginTop(7.px)
                        .overflow(.auto)
                }
                .custom("width", "calc(50% - 12px)")
                .custom("height", "calc(100% - 24px)")
                .padding(all: 3.px)
                .margin(all: 3.px)
                .float(.left)
                
                Div{
                    
                    Div{
                        H3("Estados de Cuenta")
                            .color(.lightGray)
                    }
                    
                    self.billingDiv
                        .custom("height", "calc(100% - 30px)")
                        .class(.roundGrayBlackDark)
                        .marginTop(7.px)
                        .overflow(.auto)
                    
                }
                .custom("width", "calc(50% - 12px)")
                .custom("height", "calc(100% - 24px)")
                .padding(all: 3.px)
                .margin(all: 3.px)
                .float(.left)
            }
            .hidden(self.$currentAccountTab.map{ $0 != .finance })
            .custom("height", "calc(60% - 42px)")
            
            self.creditDetailView
                .hidden(self.$currentAccountTab.map{ $0 != .credit })
                .custom("height", "calc(60% - 42px)")
            
        }
        .height(100.percent)
        .width(66.percent)
        .float(.left)
        .overflow(.auto)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.height(100.percent)
        self.marginBottom(7.px)
        self.overflow(.hidden)
        
        if let img = account.avatar {
            self.avatar.load("https://\(custCatchUrl)/contenido/\(img)")
        }
        
        membershipExpire = account.expiredAt
        
        membershipId = account.basePlanId
        
        membershipName = account.basePlanName
        
        if let fiscalProfile {
            
            fiscalProfiles.forEach { profile in
                if profile.id == fiscalProfile {
                    fiscalProfileName = profile.razon
                }
            }
            
        }
        
        /// [CustGeneralNotesQuick]
        $notes.listen {
            
            self.notesDiv.innerHTML = ""
            
            var cc = 0
            
            $0.forEach { item in
                self.notesDiv.appendChild(
                    QuickMessageObject(isEven: cc.isEven, note: item)
                        .hidden(self.$noteTypeListener.map{
                            ( !$0.isEmpty && $0 != item.type.rawValue )
                        })
                    
                )
                cc += 1
            }
            
        }
        
        /// [CustAcctBillingQuick]
        $bills.listen {
            
            self.billingDiv.innerHTML = ""
            
            $0.forEach { item in
                
            }
        }
        
        /// [CustAcctChargesQuick]
        $mrcs.listen {
            self.planAndServiceDiv.innerHTML = ""
            
            $0.forEach { item in
                
                self.planAndServiceDiv.appendChild(
                    Div{
                        
                        Span(item.name)
                            .padding(all: 0.px)
                            .float(.left)
                        
                        Span(item.price.formatMoney)
                            .padding(all: 0.px)
                            .float(.right)
                        
                        Div().class(.clear)
                        
                    }
                        .class(.uibtn)
                        .width(95.percent)
                )
                
            }
        }
        
        /// [CustAcctChargesQuick]
        $unbilled.listen {
            self.unbilledDiv.innerHTML = ""
            
            $0.forEach { item in
                
            }
        }
        
        NoteTypes.allCases.forEach { type in
            if type.readAvailable {
                self.noteTypeSelect.appendChild(Option(type.description)
                    .value(type.rawValue))
            }
        }
        
        if let creditId = account.cracct {
            loadCreditView(creditId)
        }
        else{
            self.creditDetailView = Div{
                Table {
                    Tr{
                        Td{
                            Div("Activar Credito")
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    self.activateCredit()
                                }
                        }
                        .align(.center)
                        .verticalAlign(.middle)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            .height(100.percent)
        }
        
        API.custAccountV1.loadDetails(id: self.account.id) { resp in
            
            guard let resp else{
                showError(.errorDeCommunicacion, "No se pudieron cargar detalles de la cuenta.")
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, "No se pudieron cargar detalles de la cuenta.")
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, "No se obtuvo data de la peticion.")
                return
            }
            
            self.notes = data.notes
            
            self.bills = data.bills
            
            self.mrcs = data.mrcs
            
            self.unbilled = data.unbilled
            
            self.rewardsBalanceText = data.rewardPoints.toString
            
            self.pendingRewardsBalanceText = data.pendingPoints.toString
            
        }
        
        self.pMode = panelMode
        
    }
    
    func getProfilePicture(){
        
        let view = CameraView(type: .picture) { picture in
            
            if picture.isEmpty {
                return
            }
            
            loadingView(show: true)
            
            guard let base64 = picture.explode(";base64,").last else {
                showError(.errorGeneral, "No se obtuvo data de la imagen.")
                return
            }
            
            API.custAccountV1.saveAvatar(accountid: self.account.id, base64: base64) { resp in
                
                loadingView(show: false)
                
                guard let resp else{
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let img = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo data de la peticion")
                    return
                }
                
                self.avatar
                    .load("https://\(custCatchUrl)/contenido/\(img)")
                
            }
            
            
        }
        
        addToDom(view)
        
    }
    
    func loadBudgets(){
        
        addToDom(BudgetHistoricalView(
            accountid: account.id,
            callback: { budget in
                
                let view = SalePointView(loadBy: .budget(.id(budget.id)))
                
                addToDom(view)
                
            }))
        
    }
    
    func activateCredit(){
        
        if account.type == .personal {
            showError(.errorGeneral, "Actualmente no se soporta Creditos Personales")
            return
        }
        
        addToDom(ConfirmationView(
            type: .acceptDeny,
            title: "Alta de Credito",
            message: "¿Desea activar ",
            callback: { isConfirmed, comment in
                self.activateBuissnessCreditFaceOne()
            }
        ))
        
    }
    
    func activateBuissnessCreditFaceOne(){
        
        if self.businessName.isEmpty {
            showError(.errorGeneral, .requierdValid("Nombre del Negocio"))
            return
        }
        
        if self.fiscalRazon.isEmpty {
            showError(.errorGeneral, .requierdValid("Razon Social"))
            return
        }
        
        if self.fiscalRfc.isEmpty {
            showError(.errorGeneral, .requierdValid("RFC Fiscal"))
            return
        }
        
        if self.fiscalPOCFirstName.isEmpty {
            showError(.errorGeneral, .requierdValid("Primer Nombre de contacto fiscal"))
            return
        }
        
        if self.fiscalPOCLastName.isEmpty {
            showError(.errorGeneral, .requierdValid("Primer Apellido de contacto fiscal"))
            return
        }
        
        if self.fiscalPOCMobile.isEmpty {
            showError(.errorGeneral, .requierdValid("Movil de contacto fiscal"))
            return
        }
        
        addToDom(AccountCreditActivationView(
            accountId: self.account.id,
            accountType: self.type.wrappedValue,
            creditId: self.cracct
        ){ creditId in
            self.loadCreditView(creditId)
        })
        
        
        
    }
    
    func loadCreditView(_ creditId: UUID) {
        creditDetailView.appendChild(AccountCreditView(
            accountId: account.id,
            creditId: creditId
        ))
    }

    
    
}
/// finance, credit
extension AccountView {
    enum CurrentAccountTab {
        case finance
        case credit
    }
}

