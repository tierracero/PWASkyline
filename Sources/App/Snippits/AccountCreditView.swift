//
//  AccountCreditView.swift
//  
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

class AccountCreditView: PageController {
    
    override class var name: String { "div" }
    
    var accountId: UUID
    
    var creditId: UUID
    
    init(
        accountId: UUID,
        creditId: UUID
    ) {
        self.accountId = accountId
        self.creditId = creditId
        
        super.init()
    }
    
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var customerType: CustCreditCustomerType = .personal
    
    @State var creditFolio: String? = nil
    
    /// `--  Credit Data  --`
    
    /// CustCreditType
    /// event, billDate, absoluteBalance
    @State var typeListener: String = ""
    
    /// CreateODS
    /// daily, weekly, monthly, bymester, bymonthly, trimester, forthmester, semester, yearly, manual
    @State var eventTypeListener: String = ""
    
    /// Int?
    /// Fecha de Facturacion
    @State var billDate: String = ""
    
    /// Int64
    /// How many days are given to pay
    @State var daysToPay: String = "0"
    
    /// Int
    @State var downPayment: String = ""
    
    /// Int
    @State var intresRate: String = ""
    
    /// Int64
    @State var creditLimit: String = ""
    
    
    @State var weeklySchedule: String = ""
    
    @State var saturdaySchedule: String = ""
    
    @State var sundaySchedule: String = ""
    
    /*
    Finalcial Data
    */
    /// Person -> Years in Work
    /// Biz -> years in same direccion
    /// Int
    @State var yearsInCurrentWork: String = ""
    
    /// Person -> Years in Home
    /// Biz -> years biz exists
    /// Int
    @State var yearsInCurrentHome: String = ""
    
    /// Int64
    @State var totalIncome: String = ""
    
    
    /// CustCreditCustomerHomeStatus
    /// owner, rent, family
    @State var homeStatusListener: String = CustCreditCustomerHomeStatus.owner.rawValue
    
    /*
    Work data
    */
    @State var workName: String = ""
    
    @State var workPhone: String = ""
    
    @State var workPhoneIsReal: Bool? = nil
    
    @State var workSupervisor: String = ""
    
    /*
    Refrence One
    */
    /// CustCreditRefrenceType
    /// spouce, offspring, parent, siblin, family, freind, workRefrence
    @State var refrenceOneRelationTypeListener: String = ""
    
    @State var refrenceOneNames: String = ""
    
    @State var refrenceOneLastNames: String = ""
    
    /// TelephoneType
    /// mobile, landLine
    @State var refrenceOneTelephoneTypeListener: String = TelephoneType.mobile.rawValue
    
    @State var refrenceOneTelephone: String = ""
    
    @State var refrenceOneTelephonePin: String = ""
    
    @State var refrenceOneTelephoneValidated: Bool? = nil
    
    /*
    Refrence Two
    */
    /// CustCreditRefrenceType
    /// spouce, offspring, parent, siblin, family, freind, workRefrence
    @State var refrenceTwoRelationTypeListener: String = ""
    
    @State var refrenceTwoNames: String = ""
    
    @State var refrenceTwoLastNames: String = ""
    
    /// TelephoneType
    /// mobile, landLine
    @State var refrenceTwoTelephoneTypeListener: String = TelephoneType.mobile.rawValue
    
    @State var refrenceTwoTelephone: String = ""
    
    @State var refrenceTwoTelephonePin: String = ""
    
    @State var refrenceTwoTelephoneValidated: Bool? = nil
    
    /*
    Refrence Three
    */
    /// CustCreditRefrenceType
    /// spouce, offspring, parent, siblin, family, freind, workRefrence
    @State var refrenceThreeRelationTypeListener: String = ""
    
    @State var refrenceThreeNames: String = ""
    
    @State var refrenceThreeLastNames: String = ""
    
    /// TelephoneType
    /// mobile, landLine
    @State var refrenceThreeTelephoneTypeListener: String = TelephoneType.mobile.rawValue
    
    @State var refrenceThreeTelephone: String = ""
    
    @State var refrenceThreeTelephonePin: String = ""
    
    @State var refrenceThreeTelephoneValidated: Bool? = nil
    
    /*
    Documents
    */
    
    /// IdentificationTypes
    ///driversLicens, identification, passport, scholar, votersCard, other
    @State var idTypeListener: String = ""
    
    @State var idFront: String = ""
    
    @State var idBack: String = ""
    
    @State var contract: String = ""
    
    @State var documentOne: String = ""
    
    @State var documentTwo: String = ""
    
    @State var documentThree: String = ""
    
    @State var documentFour: String = ""
    
    /*
    legal and contact
    */
    @State var legalRepresentetive: String = ""
    
    @State var legalRepresentetivePin: String = ""
    
    @State var legalRepresentetiveValidated: Bool? = nil
    
    @State var fiscalContactPin: String = ""
    
    @State var fiscalContactValidated: Bool? = nil
    
    /*
    lazy var contacto1Field = InputText(self.$contacto1)
        .placeholder("Contacto Nombre")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    */

    /// `--  Credit Data  --`
    
    /// CustCreditType
    /// event, billDate, absoluteBalance
    lazy var typeSelect = Select(self.$typeListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// CreateODS
    /// daily, weekly, monthly, bymester, bymonthly, trimester, forthmester, semester, yearly, manual
    lazy var eventTypeSelect = Select(self.$eventTypeListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Int?
    /// Fecha de Facturacion
    lazy var billDateField = InputText(self.$billDate)
        .placeholder("Dia de Facturacion")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Int64
    /// How many days are given to pay
    lazy var daysToPayField = InputText(self.$daysToPay)
        .placeholder("Dias para pagar")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Int
    lazy var downPaymentField = InputText(self.$downPayment)
        .placeholder("Enganche (%)")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Int
    lazy var intresRateField = InputText(self.$intresRate)
        .placeholder("Taza de Interes (%)")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Int64
    lazy var creditLimitField = InputText(self.$creditLimit)
        .placeholder("Limite de Credito")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var weeklyScheduleField = InputText(self.$weeklySchedule)
        .placeholder("Lunes a viernes")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var saturdayScheduleField = InputText(self.$saturdaySchedule)
        .placeholder("Sabados")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var sundayScheduleField = InputText(self.$sundaySchedule)
        .placeholder("Domingos")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /*
    Finalcial Data
    */
    /// Person -> Years in Work
    /// Biz -> years in same direccion
    /// Int
    lazy var yearsInCurrentWorkField = InputText(self.$yearsInCurrentWork)
        .placeholder( self.$customerType.map{ ($0 == .empresarial) ? "Antiguedad de la empresa" : "Años en el trabajo"  } )
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Person -> Years in Home
    /// Biz -> years biz exists
    /// Int
    lazy var yearsInCurrentHomeField = InputText(self.$yearsInCurrentHome)
        .placeholder( self.$customerType.map{ ($0 == .empresarial) ? "Años en el mimso domicilio" : "Años en domicilio"  } )
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// Int64
    lazy var totalIncomeField = InputText(self.$totalIncome)
        .placeholder(self.$customerType.map{ $0 == .empresarial ? "Credito Solicitado" : "Total de Ingresos Mensuales"})
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    
    /// CustCreditCustomerHomeStatus
    /// owner, rent, family
    lazy var homeStatusSelect = Select(self.$homeStatusListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /*
    Work data
    */
    lazy var workNameField = InputText(self.$workName)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre del trabajo" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var workPhoneField = InputText(self.$workPhone)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Telefono de la empresa" : "Telefono del trabajo" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    // lazy var workPhoneIsReal: Bool? = nil
    
    lazy var workSupervisorField = InputText(self.$workSupervisor)
        .placeholder("Supervisor Directo")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /*
    Refrence One
    */
    /// CustCreditRefrenceType
    /// spouce, offspring, parent, siblin, family, freind, workRefrence
    lazy var refrenceOneRelationTypeSelect = Select(self.$refrenceOneRelationTypeListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceOneNamesField = InputText(self.$refrenceOneNames)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceOneLastNamesField = InputText(self.$refrenceOneLastNames)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Contacto de la empresa" : "Apellido" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// TelephoneType
    /// mobile, landLine
    lazy var refrenceOneTelephoneTypeSelect = Select(self.$refrenceOneTelephoneTypeListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceOneTelephoneField = InputText(self.$refrenceOneTelephone)
        .placeholder("Telefono de contacto")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceOneTelephonePinField = InputText(self.$refrenceOneTelephonePin)
        .placeholder("PIN")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    //lazy var refrenceOneTelephoneValidated: Bool? = nil
    
    /*
    Refrence Two
    */
    /// CustCreditRefrenceType
    /// spouce, offspring, parent, siblin, family, freind, workRefrence
    lazy var refrenceTwoRelationTypeSelect = Select(self.$refrenceTwoRelationTypeListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceTwoNamesField = InputText(self.$refrenceTwoNames)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceTwoLastNamesField = InputText(self.$refrenceTwoLastNames)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Contacto de la empresa" : "Apellido" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// TelephoneType
    /// mobile, landLine
    lazy var refrenceTwoTelephoneTypeSelect = Select(self.$refrenceTwoTelephoneTypeListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceTwoTelephoneField = InputText(self.$refrenceTwoTelephone)
        .placeholder("Telefono de Contacto")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceTwoTelephonePinField = InputText(self.$refrenceTwoTelephonePin)
        .placeholder("PIN de confirmacion")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    //lazy var refrenceTwoTelephoneValidated: Bool? = nil
    
    /*
    Refrence Three
    */
    /// CustCreditRefrenceType
    /// spouce, offspring, parent, siblin, family, freind, workRefrence
    lazy var refrenceThreeRelationTypeSelect = Select(self.$refrenceThreeRelationTypeListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceThreeNamesField = InputText(self.$refrenceThreeNames)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceThreeLastNamesField = InputText(self.$refrenceThreeLastNames)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Contacto de la empresa" : "Apellido" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// TelephoneType
    /// mobile, landLine
    lazy var refrenceThreeTelephoneTypeSelect = Select(self.$refrenceThreeTelephoneTypeListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceThreeTelephoneField = InputText(self.$refrenceThreeTelephone)
        .placeholder("Telefono de contacto")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var refrenceThreeTelephonePinField = InputText(self.$refrenceThreeTelephonePin)
        .placeholder("PIN de confirmacion")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// IdentificationTypes
    ///driversLicens, identification, passport, scholar, votersCard, other
    lazy var idTypeSelect = Select(self.$idTypeListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    //lazy var idFrontField = InputText(self.$idFront)
    
    //lazy var idBackField = InputText(self.$idBack)
    
    lazy var contractField = InputText(self.$contract)
        .placeholder("xxx")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var documentOneField = InputText(self.$documentOne)
        .placeholder("xxx")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var documentTwoField = InputText(self.$documentTwo)
        .placeholder("xxx")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var documentThreeField = InputText(self.$documentThree)
        .placeholder("xxx")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var documentFourField = InputText(self.$documentFour)
        .placeholder("xxx")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var legalRepresentetiveField = InputText(self.$legalRepresentetive)
        .placeholder(self.$customerType.map{ ($0 == .empresarial) ? "Representante Legal" : "Supervisor Directo" })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var legalRepresentetivePinField = InputText(self.$legalRepresentetivePin)
        .placeholder("Movil")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    //lazy var legalRepresentetiveValidated: Bool? = nil
    
    lazy var fiscalContactPinField = InputText(self.$fiscalContactPin)
        .placeholder("PIN de Confirmatión")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    // lazy var fiscalContactValidated bool
    
    @DOM public override var body: DOM.Content {
        
        Div{
            /// Datos del Credito
            Div{
                Div{
                    H2("Datos del Credito")
                        .marginBottom(7.px)
                        .color(.lightBlueText)
                    
                    Label("Tipo de Credito")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.typeSelect
                    
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        Label("Tipo de Facturacion")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        self.eventTypeSelect
                        
                        Div().height(7.px)
                        
                        Label("Limite de Credito")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        self.creditLimitField
                        
                        Div().height(7.px)
                        
                        Label("Dias de pago")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        self.daysToPayField
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Label("Fecha de facturación")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        self.billDateField
                        
                        Div().height(7.px)

                        Label("Enganche (%)")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        self.downPaymentField
                        
                        Div().height(7.px)

                        Label("Taza de Interes (%)")
                            .marginBottom(3.px)
                            .color(.white)
                        
                        self.intresRateField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().height(7.px)
                    
                }
                .margin(all: 3.px)
            }
            .width(33.percent)
            .float(.left)
            
            /// Información Financiera / Informacion de Trabajo
            Div{
                Div{
                    H2(self.$customerType.map{ ($0 == .empresarial) ? "Información Financiera" : "Informacion de Trabajo"} )
                        .marginBottom(7.px)
                        .color(.lightBlueText)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Años en el mismo domicilio" : "Años en domicilio"})
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.yearsInCurrentHomeField
                    
                    Div().height(7.px)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Antiguedad de la empresa" : "Años en el trabajo"  } )
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.yearsInCurrentWorkField
                    
                    Div().height(7.px)
                    
                    Label(self.$customerType.map{ $0 == .empresarial ? "Credito Solicitado" : "Total de Ingresos Mensuales"})
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.totalIncomeField
                    
                    Div().height(7.px)
                    
                    
                    Label(self.$customerType.map{ $0 == .empresarial ? "Su sucursal matriz (predio)" : "Su hogar es: " })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.homeStatusSelect
                    
                    Div().height(7.px)
                    
                    
                }
                .margin(all: 3.px)
            }
            .width(33.percent)
            .float(.left)
            
            /// Informacion de Operaciones / Information Laboral
            Div{
                Div{
                    H2(self.$customerType.map{ ($0 == .empresarial) ? "Información Operación" : "Information Laboral"} )
                        .marginBottom(7.px)
                        .color(.lightBlueText)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Representante Legal" : "Supervisor Directo" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.legalRepresentetiveField
                    
                    Div().height(7.px)
                    
                    
                    Label("Horario Semanal")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.weeklyScheduleField
                    
                    Div().height(7.px)
                    
                    
                    Label("Horario Sabatino")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.saturdayScheduleField
                    
                    Div().height(7.px)
                    
                    
                    Label("Horario Dominical")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.sundayScheduleField
                    
                    Div().height(7.px)
                    
                }
                .margin(all: 3.px)
            }
            .width(33.percent)
            .float(.left)
            
            Div().clear(.both)
        }
        .paddingBottom(3.px)
        
        Div{
            /// Referencia 1
            Div{
                Div{
                    H2(self.$customerType.map{ ($0 == .empresarial) ? "Referencia Comercial 1" : "Referencia Personal 1" })
                        .marginBottom(7.px)
                        .color(.lightBlueText)
                    
                    Label("Tipo de Referencia")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceOneRelationTypeSelect
                        .disabled(self.$customerType.map{ $0 == .empresarial })
                    
                    Div().height(7.px)
                    
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceOneNamesField
                    
                    Div().height(7.px)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Contacto de la empresa" : "Apellido" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceOneLastNamesField
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        Div{
                            Div{
                                Label("Tipo de Telefono")
                                    .color(.white)
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div{
                                self.refrenceOneTelephoneTypeSelect
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                    }
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        Div{
                            Div{
                                
                                Label("Telefono")
                                    .marginBottom(3.px)
                                    .color(.white)
                                
                                self.refrenceOneTelephoneField
                                
                                Div().height(7.px)
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div{
                                
                                Label("PIN")
                                    .marginBottom(3.px)
                                    .color(.white)
                                
                                self.refrenceOneTelephonePinField
                                
                                Div().height(7.px)
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                    }
                    
                    Div().height(7.px)
                }
                .margin(all: 3.px)
            }
            .width(33.percent)
            .float(.left)
            
            /// Referencia 2
            Div{
                Div{
                    H2(self.$customerType.map{ ($0 == .empresarial) ? "Referencia Comercial 2" : "Referencia Personal 2" })
                        .marginBottom(7.px)
                        .color(.lightBlueText)
                    
                    Label("Tipo de Referencia")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceTwoRelationTypeSelect
                        .disabled(self.$customerType.map{ $0 == .empresarial })
                    
                    Div().height(7.px)
                    
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceTwoNamesField
                    
                    Div().height(7.px)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Contacto de la empresa" : "Apellido" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceTwoLastNamesField
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        Div{
                            Div{
                                Label("Tipo de Telefono")
                                    .color(.white)
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div{
                                self.refrenceTwoTelephoneTypeSelect
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                    }
                    
                    Div().height(7.px)
                    
                    Div{
                    
                        Div{
                            
                            Label("Telefono")
                                .marginBottom(3.px)
                                .color(.white)
                            
                            self.refrenceTwoTelephoneField
                            
                            Div().height(7.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            
                            Label("PIN")
                                .marginBottom(3.px)
                                .color(.white)
                            
                            self.refrenceTwoTelephonePinField
                            
                            Div().height(7.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    
                    Div().height(7.px)
                    
                }
                .margin(all: 3.px)
            }
            .width(33.percent)
            .float(.left)
            
            /// Referencia 3
            Div{
                Div{
                    H2(self.$customerType.map{ ($0 == .empresarial) ? "Referencia Comercial 3" : "Referencia Personal 3" })
                        .marginBottom(7.px)
                        .color(.lightBlueText)
                    
                    Label("Tipo de Referencia")
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceThreeRelationTypeSelect
                        .disabled(self.$customerType.map{ $0 == .empresarial })
                    
                    Div().height(7.px)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Nombre de la empresa" : "Nombre" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceThreeNamesField
                    
                    Div().height(7.px)
                    
                    Label(self.$customerType.map{ ($0 == .empresarial) ? "Contacto de la empresa" : "Apellido" })
                        .marginBottom(3.px)
                        .color(.white)
                    
                    self.refrenceThreeLastNamesField
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        Div{
                            Div{
                                Label("Tipo de Telefono")
                                    .color(.white)
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div{
                                self.refrenceThreeTelephoneTypeSelect
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                    }
                    
                    Div().height(7.px)
                    
                    Div{
                        
                        Div{
                            Div{
                                
                                Label("Telefono")
                                    .marginBottom(3.px)
                                    .color(.white)
                                
                                self.refrenceThreeTelephoneField
                                
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        
                        Div{
                            Div{
                                
                                Label("PIN de Confrimación")
                                    .marginBottom(3.px)
                                    .color(.white)
                                
                                self.refrenceThreeTelephonePinField
                                
                            }
                            .margin(all: 3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    
                    Div().height(7.px)
                    
                }
                .margin(all: 3.px)
            }
            .width(33.percent)
            .float(.left)
            
            Div().clear(.both)
        }
        .paddingBottom(3.px)
    }
    
    public override func buildUI() {
        
        CustCreditType.allCases.forEach { item in
            typeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CreateODS.allCases.forEach { item in
            eventTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        IdentificationTypes.allCases.forEach { item in
            idTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CustCreditCustomerHomeStatus.allCases.forEach { item in
            homeStatusSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CustCreditCustomerHomeStatus.allCases.forEach { item in
            homeStatusSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CustCreditRefrenceType.allCases.forEach { item in
            refrenceOneRelationTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        TelephoneType.allCases.forEach { item in
            refrenceOneTelephoneTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CustCreditRefrenceType.allCases.forEach { item in
            refrenceTwoRelationTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        TelephoneType.allCases.forEach { item in
            refrenceTwoTelephoneTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CustCreditRefrenceType.allCases.forEach { item in
            refrenceThreeRelationTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        TelephoneType.allCases.forEach { item in
            refrenceThreeTelephoneTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
     
        API.custAccountV1.loadCustCredit(
            custAcct: accountId,
            creditid: creditId
        ) { resp in
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
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
            
            self.customerType = payload.customerType
            
            
            self.creditFolio = payload.folio
            
            /// `--  Credit Data  --`
            
            /// CustCreditType
            /// event, billDate, absoluteBalance
            self.typeListener = payload.type.rawValue
            
            /// CreateODS
            /// daily, weekly, monthly, bymester, bymonthly, trimester, forthmester, semester, yearly, manual
            self.eventTypeListener = payload.eventType.rawValue
            
            /// Int?
            /// Fecha de Facturacion
            self.billDate = payload.billDate?.toString ?? ""
            
            /// Int64
            /// How many days are given to pay
            self.daysToPay = payload.daysToPay.toString
            
            /// Int
            self.downPayment = payload.downPayment.toString
            
            /// Int
            self.intresRate = payload.intresRate.toString
            
            /// Int64
            self.creditLimit = payload.creditLimit.toString
            
            self.weeklySchedule = payload.weeklySchedule
            
            self.saturdaySchedule = payload.saturdaySchedule
            
            self.sundaySchedule = payload.sundaySchedule
            
            /*
            Finalcial Data
            */
            /// Person -> Years in Work
            /// Biz -> years in same direccion
            /// Int
            self.yearsInCurrentWork = payload.yearsInCurrentWork.toString
            
            /// Person -> Years in Home
            /// Biz -> years biz exists
            /// Int
            self.yearsInCurrentHome = payload.yearsInCurrentHome.toString
            
            /// Int64
            self.totalIncome = payload.totalIncome.formatMoney
            
            
            /// CustCreditCustomerHomeStatus
            /// owner, rent, family
            self.homeStatusListener = payload.homeStatus.rawValue
            
            /*
            Work data
            */
            self.workName = payload.workName
            
            self.workPhone = payload.workPhone
            
            self.workPhoneIsReal = payload.workPhoneIsReal
            
            self.workSupervisor = payload.workSupervisor
            
            /*
            Refrence One
            */
            /// CustCreditRefrenceType
            /// spouce, offspring, parent, siblin, family, freind, workRefrence
            self.refrenceOneRelationTypeListener = payload.refrenceOneRelationType.rawValue
            
            self.refrenceOneNames = payload.refrenceOneNames
            
            self.refrenceOneLastNames = payload.refrenceOneLastNames
            
            /// TelephoneType
            /// mobile, landLine
            self.refrenceOneTelephoneTypeListener = payload.refrenceOneTelephoneType.rawValue
            
            self.refrenceOneTelephone = payload.refrenceOneTelephone
            
            self.refrenceOneTelephonePin = payload.refrenceOneTelephonePin
            
            self.refrenceOneTelephoneValidated = payload.refrenceOneTelephoneValidated
            
            /*
            Refrence Two
            */
            /// CustCreditRefrenceType
            /// spouce, offspring, parent, siblin, family, freind, workRefrence
            self.refrenceTwoRelationTypeListener = payload.refrenceTwoRelationType.rawValue
            
            self.refrenceTwoNames = payload.refrenceTwoNames
            
            self.refrenceTwoLastNames = payload.refrenceTwoLastNames
            
            /// TelephoneType
            /// mobile, landLine
            self.refrenceTwoTelephoneTypeListener = payload.refrenceTwoTelephoneType.rawValue
            
            self.refrenceTwoTelephone = payload.refrenceTwoTelephone
            
            self.refrenceTwoTelephonePin = payload.refrenceTwoTelephonePin
            
            self.refrenceTwoTelephoneValidated = payload.refrenceTwoTelephoneValidated
            
            /*
            Refrence Three
            */
            /// CustCreditRefrenceType
            /// spouce, offspring, parent, siblin, family, freind, workRefrence
            self.refrenceThreeRelationTypeListener = payload.refrenceThreeRelationType.rawValue
            
            self.refrenceThreeNames = payload.refrenceThreeNames
            
            self.refrenceThreeLastNames = payload.refrenceThreeLastNames
            
            /// TelephoneType
            /// mobile, landLine
            self.refrenceThreeTelephoneTypeListener = payload.refrenceThreeTelephoneType.rawValue
            
            self.refrenceThreeTelephone = payload.refrenceThreeTelephone
            
            self.refrenceThreeTelephonePin = payload.refrenceThreeTelephonePin
            
            self.refrenceThreeTelephoneValidated = payload.refrenceThreeTelephoneValidated
            
            /*
            Documents
            */
            
            /// IdentificationTypes
            ///driversLicens, identification, passport, scholar, votersCard, other
            self.idTypeListener = payload.idType?.rawValue ?? ""
            
            self.idFront = payload.idFront
            
            self.idBack = payload.idBack
            
            self.contract = payload.contract
            
            self.documentOne = payload.documentOne
            
            self.documentTwo = payload.documentTwo
            
            self.documentThree = payload.documentThree
            
            self.documentFour = payload.documentFour
            
            /*
            legal and contact
            */
            
            self.legalRepresentetive = payload.legalRepresentetive
            
            self.legalRepresentetivePin = payload.legalRepresentetivePin
            
            self.legalRepresentetiveValidated = payload.legalRepresentetiveValidated
            
            self.fiscalContactPin = payload.fiscalContactPin
            
            self.fiscalContactValidated = payload.fiscalContactValidated
            
        }
    }
}

