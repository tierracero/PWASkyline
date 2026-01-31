//
//  CreateNewCustomerDataView.swift
//
//
//  Created by Victor Cantu on 2/27/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateNewCustomerDataView: Div {
    
    override class var name: String { "div" }
    
    var searchTerm: String
    
    ///personal, empresaFisica, empresaMoral, organizacion
    @State var acctType: CustAcctTypes
    
    /// general, business
    let custType: CreateNewCusomerType
    
    /// order, rental, date, account
    let orderType: CustOrderProfiles?
    
    private var callback: ((
        _ custAcct: CustAcctSearch
    ) -> ())
    
    init(
        acctType: CustAcctTypes,
        custType: CreateNewCusomerType,
        orderType: CustOrderProfiles?,
        searchTerm: String,
        callback: @escaping ((
            _ custAcct: CustAcctSearch
        ) -> ())
    ) {
        
        self.searchTerm = searchTerm
        self.acctType = acctType
        self.custType = custType
        self.orderType = orderType
        self.callback = callback
        
        super.init()
        
        if isValidEmail(searchTerm) {
            self.emailField.class(.isOk)
            self.email = searchTerm
        }
        else if isValidRFC(searchTerm) {
            self.rfcField.class(.isOk)
            self.rfc = searchTerm
        }
        else if Int64(searchTerm) != nil {
            self.mobileField.class(.isOk)
            self.mobile = searchTerm
        }
        else if searchTerm.contains(" ") {
            
            let parts = searchTerm.explode(" ")
            
            self.firstName = parts[0]
            
            if parts.count > 1 {
                self.lastName = parts[1]
            }
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var token = ""
    
    @State var confirmationButtonText = ""
    
    /// strict, recomended, unrecomended
    @State var mobileIsRequierd: ConfirmationMode = .optional
    
    /// strict, recomended, unrecomended
    @State var idIsRequierd: ConfirmationMode = .optional
    
    @State var pinCode = ""
    
    @State var confirmViewPINisHidden = true
    
    var mobileIsValidated = false
    
    /// Account Holder Data
    @State var firstName = ""
    @State var secondName = ""
    @State var lastName = ""
    @State var seconLastName = ""
    @State var email = ""
    @State var mobile = ""
    
    @State var idType = ""
    @State var idNumberCIC = ""
    @State var idNumberOCR = ""
    
    /// Service Address
    @State var street = ""
    @State var colony = ""
    @State var city = ""
    @State var state = ""
    @State var country = Countries.mexico.description
    @State var zip = ""
    @State var searchZipCodeString = ""
    
    /// Buisness Info
    @State var bizName = ""
    @State var razon = ""
    @State var rfc = ""
    
    // Contacto general
    @State var contacto1 = ""
    @State var contacto2 = ""
    @State var contactTel = ""
    @State var contactMail = ""
    
    // contacto Fiscal
    @State var fiscalPOCFirstName = ""
    @State var fiscalPOCLastName = ""
    @State var fiscalPOCMobile = ""
    @State var fiscalPOCMail = ""
    
    @State var selectBillDate = ""
    
    /// If service address is requiered
    @State var requierServiceAddress: Bool = false
    
    @State var manualAddressInput: Bool = false
    
    @State var foundAddressByZipCode: Bool = false
    
    @State var postalCodeResults: [PostalCodesMexicoItem] = []
    
    var idIsValidated = false
    
    lazy var firstNameField = InputText(self.$firstName)
        .autocomplete(.off)
        .placeholder("Primer Nombre")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 30px)")
    
    lazy var secondNameField = InputText(self.$secondName)
        .autocomplete(.off)
        .placeholder("Segundo Nombre")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 30px)")
        
    lazy var lastNameField = InputText(self.$lastName)
        .autocomplete(.off)
        .placeholder("Primer Apellido")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 30px)")
    
    lazy var secondLastNameField = InputText(self.$seconLastName)
        .autocomplete(.off)
        .placeholder("Segundo Apellido")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 30px)")
    
    lazy var mobileField = InputText(self.$mobile)
        .custom("width", "calc(100% - 20px)")
        .class(.textFiledLightLarge)
        .placeholder("Celular")
        .autocomplete(.off)
    
    lazy var emailField = InputText(self.$email)
        .custom("width", "calc(100% - 20px)")
        .class(.textFiledLightLarge)
        .placeholder("Correo Emectronico Pricipal")
        .autocomplete(.off)
        .onEnter {
            self.idTypeSelect.click()
        }
    
    lazy var pinField = InputText()
        .custom("width", "calc(100% - 20px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .placeholder("PIN")
        .pattern("\\d*")
    
    lazy var bizNameField = InputText(self.$bizName)
        .autocomplete(.off)
        .placeholder("Nombre del Negocio")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var razonField = InputText(self.$razon)
        .autocomplete(.off)
        .placeholder("Razon Social")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var rfcField = InputText(self.$rfc)
        .autocomplete(.off)
        .placeholder("RFC")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var idTypeSelect = Select(self.$idType)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .height(40.px)
    
    lazy var idNumberField = InputText(self.$idNumberOCR)
        .autocomplete(.off)
        .placeholder("EG: Numero de id")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var idNumberCICField = InputText(self.$idNumberCIC)
        .placeholder("Numero de ID (CIC)")
        .autocomplete(.off)
        .placeholder("EG: Numero de id")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 40px)")
    
    lazy var idNumberOCRField = InputText(self.$idNumberOCR)
        .placeholder("Numero de ID (OCR)")
        .autocomplete(.off)
        .placeholder("EG: Numero de id")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 40px)")
    
    lazy var pinTextFiled = InputNumber(self.$pinCode)
        .placeholder("Ingrese PIN")
        .class(.textFiledLightLarge)
        .onEnter {
            self.confirmMobileConfirmation()
        }
    
    lazy var streetField = InputText(self.$street)
        .autocomplete(.off)
        .placeholder("Calle y Numero")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var streetResultField = InputText(self.$street)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.streetNumber)
        .autocomplete(.off)
    
    lazy var colonyField = InputText(self.$colony)
        .autocomplete(.off)
        .placeholder("Colonia")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    
    lazy var colonyResultSelect = Select(self.$colony)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .height(37.px)
        .body {
            Option("Seleccione Colonia")
                .value("")
        }
    
    lazy var cityField = InputText(self.$city)
        .autocomplete(.off)
        .placeholder("Cuidad")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var cityResultField = InputText(self.$city)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .placeholder(.city)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var stateField = InputText(self.$state)
        .autocomplete(.off)
        .placeholder("Estado")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var stateResultField = InputText(self.$state)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.state)
        .autocomplete(.off)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var countryField = InputText(self.$country)
        .autocomplete(.off)
        .placeholder("Pais")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var countryResultField = InputText(self.$country)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.country)
        .autocomplete(.off)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var zipField = InputText(self.$zip)
        .autocomplete(.off)
        .placeholder("Codigo Postal")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var zipSearchField = InputText(self.$searchZipCodeString)
        .placeholder("Codigo Postal")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .width(120.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
        .onEnter {
            self.searchZipCode()
        }
    
    lazy var zipResultField = InputText(self.$zip)
        .custom("width", "calc(100% - 18px)")
        .placeholder("Codigo Postal")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    
    /**
        ``Contacto Operativo``
     */
    lazy var contacto1Field = InputText(self.$contacto1)
        .autocomplete(.off)
        .placeholder("Nombre de Contacto")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var contacto2Field = InputText(self.$contacto2)
        .placeholder("Apellido de Contacto")
        .custom("width", "calc(100% - 20px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
    
    lazy var contactTelField = InputText(self.$contactTel)
        .custom("width", "calc(100% - 20px)")
        .class(.textFiledLightLarge)
        .placeholder("Movil")
        .autocomplete(.off)
    
    lazy var contactMailField = InputText(self.$contactMail)
        .custom("width", "calc(100% - 20px)")
        .class(.textFiledLightLarge)
        .placeholder("Correo Logistica")
        .autocomplete(.off)
    
    /**
        ``Fiscal Contact``
     */
    
    lazy var fiscalPOCFirstNameField = InputText(self.$fiscalPOCFirstName)
        .custom("width", "calc(100% - 20px)")
        .placeholder("Primer Nombre")
        .class(.textFiledLightLarge)
    
    lazy var fiscalPOCLastNameField = InputText(self.$fiscalPOCLastName)
        .custom("width", "calc(100% - 20px)")
        .placeholder("Primer Apellido")
        .class(.textFiledLightLarge)
    
    lazy var fiscalPOCMobileField = InputText(self.$fiscalPOCMobile)
        .custom("width", "calc(100% - 20px)")
        .placeholder("Movil Fiscal")
        .class(.textFiledLightLarge)
    
    lazy var fiscalPOCMailField = InputText(self.$fiscalPOCMail)
        .custom("width", "calc(100% - 20px)")
        .placeholder("Correo Fiscal")
        .class(.textFiledLightLarge)
    
    lazy var billDateSelect = Select(self.$selectBillDate)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .height(40.px)
    
    @State var bizOwner: Bool = false
    
    @DOM override var body: DOM.Content {
        
        /// Personal Account
        if self.acctType == .personal {
            Div{
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .hidden(self.$requierServiceAddress)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Datos del Cliente")
                        .color(.lightBlueText)
                    
                    Div()
                        .marginTop(3.px)
                        .class(.clear)
                    
                    Div{
                        
                        Span("Primer Nombre")
                            .color(.red)
                        
                        self.firstNameField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.firstName = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.secondNameField.select()
                            }
                        
                        Div().class(.clear)
                        
                        Span("Primer Apellido")
                            .color(.red)
                        
                        self.lastNameField
                            .tabIndex(3)
                            .onBlur({ tf in
                                tf.text = tf.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.secondLastNameField.select()
                            }
                        
                        Div().class(.clear)
                    }
                    .class(.oneTwo)
                    
                    Div{
                        Span("Segundo Nombre")
                        
                        self.secondNameField
                            .tabIndex(2)
                            .onBlur({ tf in
                                tf.text = tf.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.lastNameField.select()
                            }
                        
                        Div().class(.clear)
                        
                        Span("Segundo Apellido")
                        
                        self.secondLastNameField
                            .tabIndex(4)
                            .onBlur({ tf in
                                tf.text = tf.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.emailField.select()
                            }
                        
                        Div().class(.clear)
                    }
                    .class(.oneTwo)
                    
                    Div().class(.clear)
                    
                    if panelMode == .accounts {
                        Div{
                            Label("Fecha de Corte")
                                .fontWeight(.bolder)
                            
                            Div{
                                self.billDateSelect
                            }
                        }
                        .class(.section)
                        
                        Div().class(.clear)
                    }
                    
                    Span("Correo Eletronico")

                    self.emailField
                        .autocomplete(.off)
                        .tabIndex(5)
                        .onEnter {
                            self.idTypeSelect.click()
                        }
                    
                    Div().class(.clear)

                    Span("Tipo de Identificación")
                        .color(self.$idIsRequierd.map{ ($0 == .required) ? .red : .black })
                        .hidden(self.$idIsRequierd.map{ $0 == .notrequired })
                    
                    self.idTypeSelect
                        .tabIndex(6)
                        .hidden(self.$idIsRequierd.map{ $0 == .notrequired })
                    
                    Div{
                        Div{
                            Label("Numero de ID (CIC)")
                            
                            Div().class(.clear)
                            
                            self.idNumberCICField
                                .tabIndex(7)
                        }
                        .class(.oneHalf)
                        
                        Div{
                            Label("Numero de ID (OCR)")
                            
                            Div().class(.clear)
                            
                            self.idNumberOCRField
                                .tabIndex(8)
                        }
                        .class(.oneHalf)
                    }
                    .hidden(self.$idType.map{ return ($0 != IdentificationTypes.identification.rawValue)})

                    Div{
                        Label("Numero de ID")
                        
                        Div().class(.clear)
                        
                        self.idNumberField
                            .tabIndex(8)
                    }
                    .hidden(self.$idType.map{$0 == "" || $0 == IdentificationTypes.identification.rawValue})
                    
                    Div().class(.clear)
                    
                    Span("Telefono Movil")
                        .color(self.$mobileIsRequierd.map{ ($0 == .required) ? .red : .black })

                    self.mobileField
                        .autocomplete(.off)
                        .tabIndex(9)
                        .onKeyUp { tf in
                            tf
                                .removeClass(.isLoading)
                                .removeClass(.isNok)
                                .removeClass(.isOk)
                        }
                        .onEnter {
                            
                        }
                        .onBlur { tf in
                            
                            var term = tf.text
                            
                            term = term.purgeSpaces
                            
                            if term.isEmpty {
                                return
                            }
                            
                            let (isValid,conflict) = isValidPhone(term)
                            
                            guard isValid else {
                                showError(.invalidFormat, conflict)
                                return
                            }
                            
                            tf
                                .removeClass(.isNok)
                                .removeClass(.isOk)
                                .class(.isLoading)
                            
                            API.custAPIV1.custFreeTerm(term: term, type: .mobile, custAcct: nil) { resp in
                                
                                tf
                                    .removeClass(.isNok)
                                    .removeClass(.isOk)
                                    .removeClass(.isLoading)
                                
                                guard let resp else {
                                    showAlert(.alerta, "Error de Comunicacion")
                                    return
                                }
                                
                                
                                guard let data = resp.data else {
                                    showError( .generalError, .unexpenctedMissingPayload)
                                    return
                                }
                                
                                
                                if data.conflict.isEmpty {
                                    tf.class(.isOk)
                                }
                                else{
                                    tf.class(.isNok)
                                }
                                
                            }
                            
                        }
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                }
                .class(self.$requierServiceAddress.map{
                    $0 ? .oneHalf : .fullWidth
                })
                
                Div{
                    
                    // Direccion Title
                    Div{
                        
                        Div{
                            Img()
                                .hidden(self.$requierServiceAddress.map{ !$0 })
                                .closeButton(.view)
                                .onClick{
                                    self.remove()
                                }
                            
                            H2("Direccion de Servicio")
                                .color(.lightBlueText)
                        }
                        
                        Div().class(.clear).marginTop(3.px)
                        
                    }
                    
                    Div {
                        
                        Div{
                            
                            Div{
                                Div{
                                
                                    Div{
                                        H3("Buscar Codigo Postal")
                                            .color(.orangeRed)
                                            .marginTop(12.px)
                                    }
                                    .width(45.percent)
                                    .float(.left)
                                    
                                    Div{
                                        self.zipSearchField
                                            .marginTop(6.px)
                                    }
                                    .width(30.percent)
                                    .float(.left)
                                    
                                    Div{
                                        Div{
                                            
                                            Div{
                                                Img()
                                                    .src("/skyline/media/zoom.png")
                                                    .marginRight(3.px)
                                                    .height(16.px)
                                            }
                                            .float(.left)
                                            
                                            Span("Buscar")
                                                .fontSize(16.px)
                                                .onClick {
                                                    self.searchZipCode()
                                                }
                                            
                                            Div().clear(.both)
                                            
                                        }
                                        .class(.uibutton)
                                        .marginTop(7.px)
                                    }
                                    .width(25.percent)
                                    .align(.right)
                                    .float(.left)
                                    
                                    Div().clear(.both)
                                    
                                }
                                .padding(all: 3.px)
                            }
                            .class(.roundDarkBlue)
                            
                            Div{
                                Div("Busqueda Manual")
                                    .class(.smallButtonBox)
                                    .color(.gray)
                            }
                            .padding(all: 7.px)
                            .align(.center)
                            .onClick {
                                
                                guard let country = Countries(rawValue: self.country), country == .mexico else {
                                    showError(.invalidField, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
                                    return
                                }
                                
                                let view = ManualAddressSearch(.byCountry(.mexico)) { settelment, city, state, zip, country in
                                    
                                    self.colony = settelment
                                    
                                    self.city = city
                                    
                                    self.state = state
                                    
                                    self.zip = zip
                                    
                                    self.country = country.description
                                    
                                    self.manualAddressInput = true
                                    
                                    self.streetField.select()
                                    
                                }
                                
                                addToDom(view)
                                
                            }
                            
                        }
                        .hidden(self.$foundAddressByZipCode)
                        
                        Div{
                            /// Street
                            Div{
                                
                                Span("Calle y numero")
                                    .fontSize(24.px)
                                    .color(.red)
                                
                                Div("Buscar de nuevo")
                                    .class(.uibutton)
                                    .float(.right)
                                    .onClick {
                                        
                                        self.postalCodeResults.removeAll()
                                        
                                        self.colonyResultSelect.innerHTML = ""
                                        
                                        self.colonyResultSelect.appendChild(Option("Seleccione Colonia").value(""))
                                        
                                        self.colony = ""
                                        
                                        self.state = ""
                                        
                                        self.city = ""
                                        
                                        self.zip = ""
                                        
                                        self.foundAddressByZipCode = false
                                        
                                        self.zipSearchField.select()
                                        
                                    }
                            }
                            
                            self.streetResultField
                                .onBlur({ input, event in
                                    self.street = input.text.purgeSpaces.capitalizingFirstLetters
                                })
                            
                            /// Colony
                            Div{
                                Span("Colonia")
                                    .color(.red)
                                
                                self.colonyResultSelect
                            }
                            .class(.oneHalf)
                        
                            /// City
                            Div{
                                Span("Cuidad")
                                self.cityResultField
                                    .borderColor(.ghostWhite)
                                    .backgroundColor(.white)
                            }
                            .class(.oneHalf)
                            
                            Div().class(.clear)
                            
                            /// State
                            Div{
                                Span("Estado")
                                self.stateResultField
                                    .borderColor(.ghostWhite)
                                    .backgroundColor(.white)
                            }
                            .width(33.percent)
                            .float(.left)
                            
                            /// Codigo Postal
                            Div{
                                Span("C.P.")
                                self.zipResultField
                                    .borderColor(.ghostWhite)
                                    .backgroundColor(.white)
                            }
                            .width(33.percent)
                            .float(.left)
                            
                            /// Country
                            Div{
                                Span("Pais")
                                self.countryResultField
                                    .borderColor(.ghostWhite)
                                    .backgroundColor(.white)
                            }
                            .width(33.percent)
                            .float(.left)
                            
                        }
                        .hidden(self.$foundAddressByZipCode.map{ !$0 })
                        
                        Div().clear(.both)
                        
                        Div{
                            Div("Ingreso Manual")
                                .class(.smallButtonBox)
                                .color(.gray)
                                .onClick {
                                    self.manualAddressInput = true
                                }
                        }
                        .padding(all: 7.px)
                        .align(.center)
                    }
                    .hidden(self.$manualAddressInput)
                    
                    Div {
                        
                        /// Street
                        Span("Calle y Numero")

                        self.streetField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.street = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.colonyField.select()
                            }
                        
                        Div().class(.clear)
                        
                        /// Colony
                        Span("Colonia")
                        
                        self.colonyField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.colony = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.cityField.select()
                            }
                        
                        Div().class(.clear)
                        
                        /// City
                        Span("Cuidad")
                        
                        self.cityField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.city = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.stateField.select()
                            }
                        
                        Div().class(.clear)
                        
                        /// State
                        Span("Estado")
                        
                        self.stateField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.state = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.countryField.select()
                            }
                        
                        Div().class(.clear)
                        
                        /// country
                        Span("Pais")
                        
                        self.countryField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.country = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.zipField.select()
                            }
                        
                        Div().class(.clear)
                        
                        /// zip
                        Span("Codigo postal")
                        
                        self.zipField
                            .tabIndex(1)
                            .onBlur({ input, event in
                                self.zip = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.firstNameField.select()
                            }
                        
                    }
                    .hidden(self.$manualAddressInput.map{ !$0 })
                    
                    Div().class(.clear)
                }
                .hidden(self.$requierServiceAddress.map{!$0})
                .class(.oneHalf)
                
                Div()
                    .marginTop(7.px)
                    .class(.clear)
                
                Div{
                    
                    Div(self.$confirmationButtonText)
                        .custom("width", "calc(100% - 20px)")
                        .class(.smallButtonBox)
                        .marginBottom(7.px)
                        .textAlign(.center)
                        .fontSize(28.px)
                        .align(.center)
                        .align(.left)
                        .onClick {
                            self.preCreateAccount()
                        }
                }
                .align(.right)
                
                Div()
                    .marginTop(7.px)
                    .class(.clear)
                
            }
            .padding(all: 12.px)
            .width(self.$requierServiceAddress.map{
                $0 ? 70.percent : 40.percent
            })
            .left(self.$requierServiceAddress.map{
                $0 ? 15.percent : 30.percent
            })
            .borderRadius(all: 24.px)
            .backgroundColor(.white)
            .position(.absolute)
            .top(10.percent)
            
        }
        /// Buisness Account
        else {

            Div{
                
                Div{
                    Img()
                        .hidden(self.$requierServiceAddress)
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Datos de la empresa")
                        .color(.lightBlueText)
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                    /// Nombre del Negocio
                    Span("Nomre del empresa")
                        .color(.red)
                    
                    self.bizNameField
                        .onBlur({ input, event in
                            self.bizName = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.countryField.select()
                        }
                    
                    Div().class(.clear)
                    
                    /// Razon Social
                    Div{
                        Span("Razon Social")
                        
                        self.razonField
                            .onBlur({ input, event in
                                self.razon = input.text.purgeSpaces.capitalizingFirstLetters
                            })
                            .onEnter {
                                self.rfcField.select()
                            }
                    }
                    .class(.oneTwo)
                    /// RFC Fiscal
                    Div{
                        Span("RFC Fiscal")
                        
                        self.rfcField
                            .onBlur({ input, event in
                                self.rfc = input.text.purgeSpaces.uppercased()
                            })
                            .onEnter {
                                self.contacto1Field.select()
                            }
                    }
                    .class(.oneTwo)
                    
                    Div().class(.clear)
                    
                    /// Account Owner Data
                    Div{
                        
                        Div{
                            
                            H2("Dueño de la cuenta")
                                .color(.lightBlueText)
                            
                            Span("Dueño de la empresa (Opcional)")
                                .fontSize(14.px)
                                .color(.gray)

                            Div{
                                self.firstNameField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                self.secondNameField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().class(.clear).marginBottom(3.px)
                            
                            Div{
                                self.lastNameField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                self.secondLastNameField
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().class(.clear).marginBottom(3.px)
                            
                            H2("Contacto principal")
                                .color(.lightBlueText)
                            
                            if panelMode == .accounts {
                                
                                Div().class(.clear).marginTop(7.px)
                                
                                Div{
                                    Label("Fecha de Corte")
                                        .fontWeight(.bolder)
                                    
                                    Div{
                                        self.billDateSelect
                                    }
                                }
                                .class(.section)
                                
                            }
                            
                            Div().class(.clear).marginTop(7.px)
                            
                            Span("Correo Eletronico")
                            
                            Div().class(.clear)
                            
                            self.emailField
                            
                            Div().class(.clear).marginTop(7.px)
                            
                            Span("Telefono Principal")
                                .color(.red)
                            
                            Div().class(.clear)
                            
                            self.mobileField
                                .autocomplete(.off)
                                .onKeyUp { tf in
                                    tf
                                        .removeClass(.isNok)
                                        .removeClass(.isOk)
                                        .removeClass(.isLoading)
                                }
                                .onEnter {
                                    
                                }
                                .onBlur { tf in
                                    
                                    var term = tf.text
                                    
                                    term = term.purgeSpaces
                                    
                                    if term.isEmpty {
                                        return
                                    }
                                    
                                    let (isValid,conflict) = isValidPhone(term)
                                    
                                    guard isValid else {
                                        showError(.invalidFormat, conflict)
                                        return
                                    }
                                    
                                    tf
                                        .removeClass(.isNok)
                                        .removeClass(.isOk)
                                        .class(.isLoading)
                                    
                                    API.custAPIV1.custFreeTerm(term: term, type: .mobile, custAcct: nil) { resp in
                                        
                                        tf
                                            .removeClass(.isNok)
                                            .removeClass(.isOk)
                                            .removeClass(.isLoading)
                                        
                                        guard let resp else {
                                            showAlert(.alerta, "Error de Comunicacion")
                                            return
                                        }
                                        
                                        
                                        guard let data = resp.data else {
                                            showError( .generalError, .unexpenctedMissingPayload)
                                            return
                                        }
                                        
                                        
                                        if data.conflict.isEmpty {
                                            tf.class(.isOk)
                                        }
                                        else{
                                            tf.class(.isNok)
                                        }
                                        
                                    }
                                    
                                }
                            
                            Div().class(.clear).marginTop(7.px)
                        }
                        .margin(all: 7.px)
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    /// Fiscal Contact
                    Div{
                        
                        Div{
                            
                            Div{
                                H2("Contacto Fiscal")
                                    .color(.lightBlueText)
                            }
                            
                            Span("Encargado de pagos/facturación")
                                .fontSize(14.px)
                                .color(.gray)
                            
                            
                            Div().class(.clear).marginTop(7.px)
                            
                            Span("Nombre de contacto (Fiscal)")
                            
                            self.fiscalPOCFirstNameField
                            
                            Div().class(.clear).marginTop(3.px)
                            
                            Span("Apellido de contacto (Fiscal)")
                            
                            self.fiscalPOCLastNameField
                            
                            Div().class(.clear).marginTop(3.px)
                         
                            Span("Telefno de contacto (Fiscal)")
                            
                            self.fiscalPOCMobileField
                            
                            Div().class(.clear).marginTop(3.px)
                         
                            Span("Correo de contacto (Fiscal)")
                            
                            self.fiscalPOCMailField
                            
                        }
                        .margin(all: 3.px)
                    }
                    .width(30.percent)
                    .float(.left)
                    
                    /// Operational Contact
                    Div{
                        Div{
                            
                            Div{
                                H2("Contacto Logistica")
                                    .color(.lightBlueText)
                            }
                            
                            Span("Cordinador trabajos y servicios")
                                .fontSize(14.px)
                                .color(.gray)
                            
                            Div().class(.clear).marginTop(7.px)
                            
                            Span("Nombre de contacto (Logistica)")
                            
                            self.contacto1Field
                                .onBlur({ input, event in
                                    self.contacto1 = input.text.purgeSpaces.capitalizingFirstLetters
                                })
                                .onEnter {
                                    self.contacto2Field.select()
                                }
                        
                            Div().class(.clear).marginTop(3.px)
                        
                            Span("Apellido de contacto (Logistica)")
                            
                            self.contacto2Field
                                .onBlur({ input, event in
                                    self.contacto2 = input.text.purgeSpaces.capitalizingFirstLetters
                                })
                                .onEnter {
                                    
                                }
                            
                            Div().class(.clear).marginTop(3.px)
                         
                            Span("Telefono de contacto (Logistica)")
                            
                            self.contactTelField
                            
                            Div().class(.clear).marginTop(3.px)
                         
                            Span("Correo de contacto (Logistica)")
                            
                            self.contactMailField
                         
                        }
                        .margin(all: 3.px)
                    }
                    .width(30.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginTop(7.px)
                    
                }
                .class(self.$requierServiceAddress.map{
                    $0 ? .twoThird : .fullWidth
                })
                
                Div{
                    
                    Div{
                        Img()
                            .hidden(self.$requierServiceAddress.map{ $0 })
                            .closeButton(.view)
                            .onClick{
                                self.remove()
                            }
                        
                        H2("Direccion de Serivicio")
                            .color(.lightBlueText)
                        
                    }
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                    /// Street
                    Span("Calle y Numero")
                    
                    self.streetField
                        .tabIndex(1)
                        .onBlur({ input, event in
                            self.street = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.colonyField.select()
                        }
                    
                    Div().class(.clear)
                    
                    /// Colony
                    Span("Colonia")
                    
                    self.colonyField
                        .tabIndex(1)
                        .onBlur({ input, event in
                            self.street = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.cityField.select()
                        }
                    
                    Div().class(.clear)
                    
                    /// City
                    Span("Cuidad")
                    
                    self.cityField
                        .tabIndex(1)
                        .onBlur({ input, event in
                            self.street = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.stateField.select()
                        }
                    
                    Div().class(.clear)
                    
                    /// State
                    self.stateField
                        .tabIndex(1)
                        .onBlur({ input, event in
                            self.street = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.countryField.select()
                        }
                    
                    Div().class(.clear)
                    
                    /// country
                    Span("Pais")
                    
                    self.countryField
                        .tabIndex(1)
                        .onBlur({ input, event in
                            self.street = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.zipField.select()
                        }
                    
                    Div().class(.clear)
                    
                    /// zip
                    Span("Codigo Postal")
                    
                    self.zipField
                        .tabIndex(1)
                        .onBlur({ input, event in
                            self.street = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.firstNameField.select()
                        }
                    
                    Div().class(.clear)
                }
                .class(.oneThird)
                .hidden(self.$requierServiceAddress.map{!$0})
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
                Div{
                    
                    Div(self.$confirmationButtonText)
                        .class(.smallButtonBox)
                        .marginBottom(7.px)
                        .fontSize(28.px)
                        .align(.center)
                        .float(.right)
                        .onClick {
                            self.preCreateAccount()
                        }
                }
                .align(.right)
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
            }
            .padding(all: 12.px)
            .position(.absolute)
            .custom("width", "60% - 24px")
            .width(self.$requierServiceAddress.map{
                $0 ? 90.percent : 60.percent
            })
            .left(self.$requierServiceAddress.map{
                $0 ? 5.percent : 20.percent
            })
            .top(10.percent)
            .backgroundColor(.white)
            .borderRadius(all: 24.px)
        }
        
        Div{
            Div{
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick{
                            self.confirmViewPINisHidden = true
                        }
                    
                    H2("Confirmar PIN")
                        .color(.lightBlueText)
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                    Div{
                        self.pinTextFiled
                    }
                    .align(.center)
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                    Div("Crear Cuenta")
                        .custom("width", "calc(100% - 20px)")
                        .align(.left)
                        .fontSize(28.px)
                        .class(.smallButtonBox)
                        .marginBottom(7.px)
                        .align(.center)
                        .onClick {
                            self.confirmMobileConfirmation()
                        }
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                    
                    Div()
                        .class(.clear)
                        .marginTop(3.px)
                    
                    Div{
                        Strong("Continuar sin verificación")
                            .fontSize(18.px)
                            .color(.highlighBlue)
                    }
                    .padding(all: 12.px)
                    .align(.center)
                    .onClick {
                        self.continueWithoutVerification()
                    }
                    
                }
                .padding(all: 12.px)
            }
            .position(.absolute)
            .width(30.percent)
            .left(35.percent)
            .height(25.percent)
            .top(30.percent)
            .backgroundColor(.white)
            .borderRadius(all: 24.px)
        }
        .backgroundColor(.transparentBlack)
        .hidden($confirmViewPINisHidden)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        self.idTypeSelect.appendChild(
            Option("Seleccione Tipo de Identificación")
                .value("")
        )
        
        IdentificationTypes.allCases.forEach { idt in
            self.idTypeSelect.appendChild(
                Option("\(idt.description)")
                    .value(idt.rawValue)
            )
        }
        
        self.$idType.listen {
            guard let idt = IdentificationTypes(rawValue: $0) else { return }
            Dispatch.asyncAfter(0.10) {
                switch idt {
                case .identification:
                    self.idNumberCICField.select()
                    
                case .driversLicens, .passport, .scholar, .votersCard, .other:
                    self.idNumberField.select()
                }
            }
        }
        
        self.billDateSelect.appendChild(
            Option("Agregue fecha de corte...")
                .value("")
        )
        
        if panelMode == .accounts {
            
            let today = getDate(nil).day
            
            for i in 1...28 {
                
                let option = Option(i.toString)
                    .value(i.toString)
                
                if today == i {
                    option.selected(true)
                    self.selectBillDate = i.toString
                }
                
                self.billDateSelect.appendChild(option)
            }
            
        }
        
        self.requierServiceAddress = configContactTags.requierServiceAddress
       
        if let orderType = self.orderType {
            switch orderType {
            case .order:
                mobileIsRequierd = configStoreProcessing.orderMobileConfirmationMode
                idIsRequierd = configStoreProcessing.orderIdConfirmationMode
            case .rental:
                mobileIsRequierd = configStoreProcessing.rentalMobileConfirmationMode
                idIsRequierd = configStoreProcessing.rentalIdConfirmationMode
            case .date:
                mobileIsRequierd = configStoreProcessing.dateMobileConfirmationMode
                idIsRequierd = configStoreProcessing.dateIdConfirmationMode
            case .account:
                mobileIsRequierd = configStoreProcessing.accountMobileConfirmationMode
                idIsRequierd = configStoreProcessing.accountIdConfirmationMode
            }
        }
        
        if (mobileIsRequierd == .recomended || mobileIsRequierd == .required) {
            confirmationButtonText = "Confirmar Movil"
        }
        else{
            confirmationButtonText = "Crear Cuenta"
        }
        
        super.buildUI()
    }
    
    override func didAddToDOM() {
        
        if self.acctType == .personal {
            
            if self.requierServiceAddress {
                self.streetField.select()
            }
            else{
                self.firstNameField.select()
            }
        }
        else{
            self.bizNameField.select()
        }
        
    }
    
    func preCreateAccount(){
        if ( mobileIsRequierd == .required ) {
            requestMobileConfirmation()
        }
        else {
            continueWithoutVerification()
        }
    }
    
    func requestMobileConfirmation(){
        
        if firstName.isEmpty {
            showError(.requiredField, "Primer nombre requerido.")
            firstNameField.select()
            return
        }
        
        if lastName.isEmpty {
            showError(.requiredField, "Primer apellido requerido.")
            lastNameField.select()
            return
        }
        
        if idType.isEmpty {
            switch self.idIsRequierd {
            case .required:
                showError(.requiredField, "Seleccione tipo de identidad.")
                return
            case .recomended:
                break
            case .optional:
                break
            case .notrequired:
                break
            }
        }
        
        if let idt = IdentificationTypes(rawValue: idType) {
            
            switch idt {
            case .identification:
                
                if idNumberCIC.isEmpty {
                    showError(.requiredField, "Ingrese CIC de Identificación")
                    idNumberCICField.select()
                    return
                }
                
                if idNumberOCR.isEmpty {
                    showError(.requiredField, "Ingrese OCR de Identificación")
                    idNumberOCRField.select()
                    return
                }
                
            case .driversLicens, .passport, .scholar, .votersCard, .other:
                
                if idNumberOCR.isEmpty {
                    showError(.requiredField, "Ingrese OCR de Identificación")
                    idNumberOCRField.select()
                    return
                }
                
            }
            
        }
        
        var term = mobile
        
        term = term.purgeSpaces
        
        if term.isEmpty {
            showError(.requiredField, "Ingrese Numero de Celular")
            mobileField.select()
            return
        }
        
        let (isValid,conflict) = isValidPhone(term)
        
        guard isValid else {
            showError(.invalidFormat, conflict)
            return
        }
        
        print("⭐️ phone is valid")
        
        loadingView(show: true)
        
        mobileField
            .removeClass(.isNok)
            .removeClass(.isOk)
            .class(.isLoading)
        
        API.custAPIV1.custFreeTerm(term: term, type: .mobile, custAcct: nil) { resp in
            
            self.mobileField
                .removeClass(.isNok)
                .removeClass(.isOk)
                .removeClass(.isLoading)
            
            guard let resp else {
                // TODO By pass bc no conn
                loadingView(show: false)
                showAlert(.alerta, "Error de Comunicacion")
                return
            }
            
            guard let data = resp.data else {
                showError( .generalError, .unexpenctedMissingPayload)
                return
            }
            
            print("⭐️ data.conflict")
            print(data.conflict)
            
            if data.conflict.isEmpty {
                
                self.mobileField.class(.isOk)
                
                self.token = ""//callKey(28)
                
                API.v1.requestMobileAuth(mobile: self.mobile, token: self.token) { resp in
                    
                    guard let resp = resp else {
                        // TODO By pass bc no conn
                        loadingView(show: false)
                        showAlert(.alerta, "Error de Comunicacion")
                        return
                    }
                    
                    print("⭐️ auth mobile")
                    print(resp)
                    
                    if resp.status != .ok {
                        // TODO By pass bc no conn
                        loadingView(show: false)
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    loadingView(show: false)
                    
                    // show enter pin view
                    
                    self.confirmViewPINisHidden = false
                    self.pinTextFiled.select()
                    
                    print("⭐️ show pin view")
                    
                }
                
            }
            else{
                self.mobileField.class(.isNok)
                loadingView(show: false)
                showError(.generalError, "El telefono ya esta regustrado en otra cuenta ")
            }
        }
    }
    
    func confirmMobileConfirmation(){
        
        if pinCode.isEmpty {
            showError(.requiredField, "Ingrese PIN para contunuar")
            return
        }
        
        loadingView(show: true)
        
        API.v1.confirmMobileAuth(token: token, pin: pinCode) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else{
                showError(.comunicationError, "No se pudo contactar con el servidor.")
                return
            }
            
            if resp.status != .ok {
                showError(.generalError, resp.msg)
                return
            }
            
            self.mobileIsValidated = true
            
            self.createAccount()
            
        }
    }
    
    func continueWithoutVerification(){
        createAccount()
    }
    
    func createAccount(){
        
        var idNum = ""
        var idt: IdentificationTypes? = nil
        
        if acctType == .personal {
            
            if firstName.isEmpty {
                showError(.requiredField, "Primer nombre requerido.")
                firstNameField.select()
                return
            }
            
            if lastName.isEmpty {
                showError(.requiredField, "Primer apellido requerido.")
                lastNameField.select()
                return
            }
            
        }
        
        
        if idType.isEmpty {
            
            switch self.idIsRequierd {
            case .required:
                showError(.requiredField, "Seleccione tipo de identidad.")
                return
            case .recomended:
                break
            case .optional:
                break
            case .notrequired:
                break
            }
            
            if let _idt = IdentificationTypes(rawValue: idType) {
                
                idt = _idt
                
                switch _idt {
                case .identification:
                    
                    if idNumberCIC.isEmpty {
                        showError(.requiredField, "Ingrese CIC de Identificación")
                        idNumberCICField.select()
                        return
                    }
                    
                    if idNumberOCR.isEmpty {
                        showError(.requiredField, "Ingrese OCR de Identificación")
                        idNumberOCRField.select()
                        return
                    }
                    
                    idNum = "\(idNumberCIC)-\(idNumberOCR)"
                    
                case .driversLicens, .passport, .scholar, .votersCard, .other:
                    
                    if idNumberOCR.isEmpty {
                        showError(.requiredField, "Ingrese OCR de Identificación")
                        idNumberOCRField.select()
                        return
                    }
                    
                    idNum = "\(idNumberOCR)"
                    
                }
            }
        }
        
        if acctType == .personal {
            if mobile.purgeSpaces.isEmpty {
                showError(.requiredField, "Ingrese Numero de Celular")
                mobileField.select()
                return
            }
            
        }
        else {
            if self.rfc.isEmpty && mobile.isEmpty {
                showError(.requiredField, "Ingrese Numero de Celular o RFC para crear cuenta")
                return
            }
        }
        
        if !mobile.isEmpty {
            
            let (isValid,conflict) = isValidPhone(mobile.purgeSpaces)
            
            guard isValid else {
                showError(.invalidFormat, conflict)
                return
            }
        }
        
        loadingView(show: true)
        
        API.custAPIV1.createCustAcct(
            CardID: "",
            firstName: self.firstName,
            secondName: self.secondName,
            lastName: self.lastName,
            secondLastName: self.seconLastName,
            email: self.email,
            mobile: self.mobile,
            telephone: "",
            birthDay: nil,
            birthMonth: nil,
            birthYear: nil,
            sexo: .male,
            IDType: idt,
            IDNum: idNum,
            type: self.acctType,
            costType: .cost_a,
            isConcessionaire: false,
            
            contacto1: self.contacto1,
            contacto2: self.contacto2,
            contactTel: self.contactTel,
            contactMail: self.contactTel,
            
            fiscalPOCFirstName: self.fiscalPOCFirstName,
            fiscalPOCLastName: self.fiscalPOCLastName,
            fiscalPOCMobile: self.fiscalPOCMobile,
            fiscalPOCMail: self.fiscalPOCMail,
            
            businessName: self.bizName,
            fiscalRecipt: false,
            fiscalRazon: self.razon,
            fiscalRfc: self.rfc,
            street: self.street,
            colony: self.colony,
            city: self.city,
            state: self.state,
            country: self.country,
            zip: self.zip,
            mailStreet: "",
            mailColony: "",
            mailCity: "",
            mailState: "",
            mailCountry: "",
            mailZip: "",
            mobileIsValidated: self.mobileIsValidated,
            idIsValidated: self.idIsValidated,
            billDate: Int(self.selectBillDate)
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, "Error al conecatar al servidor")
                return
            }
            
            print("⭐️ create account ok")
            print(resp)
            
            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError( .generalError, .unexpenctedMissingPayload)
                return
            }
            
            guard let custAcct = data.custAcct else{
                showError(.comunicationError, "Error al obtener cuenta contacte a Soporte TC")
                return
            }
            
            
            showSuccess(.operacionExitosa, "Cuenta creada \(custAcct.folio)")
                
            self.callback(
                .init(
                    id: custAcct.id,
                    folio: custAcct.folio,
                    businessName: custAcct.businessName,
                    costType: custAcct.costType,
                    type: custAcct.type,
                    firstName: custAcct.firstName,
                    lastName: custAcct.lastName,
                    mcc: custAcct.mcc,
                    mobile: custAcct.mobile,
                    email: custAcct.email,
                    street: custAcct.street,
                    colony: custAcct.colony,
                    city: custAcct.city,
                    state: custAcct.state,
                    zip: custAcct.zip,
                    country: custAcct.country,
                    autoPaySpei: custAcct.autoPaySpei,
                    autoPayOxxo: custAcct.autoPayOxxo,
                    fiscalProfile: custAcct.fiscalProfile,
                    fiscalRazon: custAcct.fiscalRazon,
                    fiscalRfc: custAcct.fiscalRfc,
                    fiscalRegime: custAcct.fiscalRegime,
                    fiscalZip: custAcct.fiscalZip,
                    cfdiUse: custAcct.cfdiUse,
                    CardID: custAcct.CardID, 
                    rewardsLevel: custAcct.rewardsLevel,
                    crstatus: custAcct.crstatus, 
                    isConcessionaire: custAcct.isConcessionaire,
                    highPriorityNotes: []
                )
            )
            
            self.remove()
            
        }
    }
    
    func searchZipCode(){
        
        let code = searchZipCodeString.purgeSpaces
        
        if code.count < 4 {
            showError(.invalidField, "Ingrese un codigo postal minimo de cuatro digitos")
            return
        }
        
        guard let country = Countries(rawValue: country), country == .mexico else {
            showError(.invalidField, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
            return
        }
        
        loadingView(show: true)
        
        API.v1.searchZipCode(
            code: code,
            country: country
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
            
            guard let data = resp.data else {
                showError( .generalError, .unexpenctedMissingPayload)
                return
            }
            
            if data.isEmpty {
                showError(.generalError, "No se localizo información, intente unn codigo nuevo o un ingreso manual.")
                return
            }
            
            self.searchZipCodeString = ""
            
            let codes = data
            
            guard let state = codes.first?.state else {
                showError(.generalError, "Se le localizo el estado en la peticion")
                return
            }
            
            self.postalCodeResults = codes
            
            self.colonyResultSelect.innerHTML = ""
            
            self.colonyResultSelect.appendChild(Option("Seleccione Colonia").value(""))
            
            var items: [String] = []
            
            var itemsRrefrence: [ String : PostalCodesMexicoItem ] = [:]
            
            codes.forEach { code in
                
                if items.contains(code.settlement) {
                    return
                }
                
                items.append(code.settlement)
                
                itemsRrefrence[code.settlement] = code
            }
            
            items.sort()
            
            items.forEach { item in
                guard let code = itemsRrefrence[item] else {
                    return
                }
                self.colonyResultSelect.appendChild(
                    Option(code.settlement)
                        .value("\(code.settlementType) \(code.settlement)")
                )
            }
            
            self.colony = ""
            
            self.state = state.description
            
            self.city = codes.first?.city ?? ""
            
            self.zip = code
            
            self.foundAddressByZipCode = true
            
            self.streetResultField.select()
            
        }



    }


    
}
