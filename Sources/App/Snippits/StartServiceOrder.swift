//
//  StartServiceOrder.swift
//
//
//  Created by Victor Cantu on 3/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web
import XMLHttpRequest

class StartServiceOrder: Div {
    
    override class var name: String { "div" }
    
    var custAcct: CustAcctSearch
    
    @State var acctType: CustAcctTypes
    
    private var callback: ((
        _ id: UUID,
        _ shownHighPriorityNotes: [UUID],
        _ files: [String]
    ) -> ())
    
    init(
        custAcct: CustAcctSearch,
        callback: @escaping ((
            _ id: UUID,
            _ shownHighPriorityNotes: [UUID],
            _ files: [String]
        ) -> ())
    ) {
        self.custAcct = custAcct
        self.acctType = custAcct.type
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var smsTokens: [String] = []
    
    /// The due date the new order will be prommised
    @State var dueAt: Int64? = nil
    /// How many confirmed date do we have  on the select compromised day
    @State var bookedPromises = "--"
    /// What day does the system sugest
    @State var sugestedPromiseDay = "DD/MM/AAAA"
    /// What hour does the system sugest
    @State var sugestedPromiseHour = "HH:MM"
    /// Date that will be passed to calendar view  variable  Format: ``2022/7/19``
    @State var selectedDateStamp: String = ""
    
    @State var _firstName = ""
    @State var _secondName = ""
    @State var _lastName = ""
    @State var _secondLastName = ""
    @State var _email = ""
    @State var _mobile = ""
    
    @State var _idType = ""
    @State var _idNumberCIC = ""
    @State var _idNumberOCR = ""
    
    @State var _street = ""
    @State var _colony = ""
    @State var _city = ""
    @State var _state = ""
    @State var _country = Countries.mexico.description
    @State var _zip = ""
    @State var searchZipCodeString = ""
    
    @State var _bizName = ""
    @State var _razon = ""
    @State var _rfc = ""
    @State var _contacto1 = ""
    @State var _contacto2 = ""
    
    @State var cardId = ""
    
    /// UUID in string representation
    @State var selectedUserID = ""
    
    /// If service address is requiered
    @State var requierServiceAddress: Bool = false
    
    @State var manualAddressInput: Bool = false
    
    @State var foundAddressByZipCode: Bool = false
    
    var idIsValidated = false
    
    var shownHighPriorityNotes: [UUID] = []
    
    @State var postalCodeResults: [PostalCodesMexicoItem] = []
    
    @State var pinOfDevice: String = ""

    lazy var pinOfDeviceField = InputText(self.$pinOfDevice)
        .autocomplete(.off)
        .placeholder("PIN de telefono")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")

    lazy var pinPatternSelect = Select{

        Option("Codigo 3 x 3")
        .value("pinpatern_canvas_3x3.png")


        Option("Codigo 4 x 4")
        .value("pinpatern_canvas_4x4.png")
    }
    .width(95.percent)
    .fontSize(23.px)
    .height(32.px)
    .onChange{ _, select in
        _ = JSObject.global.resetCanvas!()
        _ = JSObject.global.loadImageCanvas!("/skyline/media/\(select.text)")
    }


    lazy var firstName = InputText(self.$_firstName)
        .autocomplete(.off)
        .placeholder("Primer Nombre")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var secondName = InputText(self.$_secondLastName)
        .autocomplete(.off)
        .placeholder("Segundo Nombre")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
        
    lazy var lastName = InputText(self.$_lastName)
        .autocomplete(.off)
        .placeholder("Primer Apellido")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var secondLastName = InputText(self.$_secondLastName)
        .autocomplete(.off)
        .placeholder("Segundo Apellido")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 20px)")
    
    lazy var mobile = InputText(self.$_mobile)
        .disabled(self.$acctType.map{ $0 == .personal })
        .custom("width", "calc(100% - 10px)")
        .class(.textFiledLightLarge)
        .placeholder("Celular")
        .autocomplete(.off)
    
    lazy var email = InputText(self.$_email)
        .autocomplete(.off)
        .placeholder("Correo Electronico")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
    
    lazy var street = InputText(self.$_street)
        .autocomplete(.off)
        .placeholder(.streetNumber)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 18px)")
    
    lazy var streetResultField = InputText(self.$_street)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.streetNumber)
        .autocomplete(.off)
    
    lazy var colony = InputText(self.$_colony)
        .autocomplete(.off)
        .placeholder(.colony)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 18px)")
    
    lazy var colonyResultSelect = Select(self.$_colony)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .height(37.px)
        .body {
            Option("Seleccione Colonia")
                .value("")
        }
    
    lazy var city = InputText(self.$_city)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .placeholder(.city)
    
    lazy var cityResultField = InputText(self.$_city)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .placeholder(.city)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var state = InputText(self.$_state)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.state)
        .autocomplete(.off)
    
    lazy var stateResultField = InputText(self.$_state)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.state)
        .autocomplete(.off)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var country = InputText(self.$_country)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.country)
        .autocomplete(.off)
    
    lazy var countryResultField = InputText(self.$_country)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder(.country)
        .autocomplete(.off)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var zip = InputText(self.$_zip)
        .custom("width", "calc(100% - 18px)")
        .placeholder("Codigo Postal")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
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
            self.searchPostalCode()
        }
    
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
            self.searchPostalCode()
        }
    
    lazy var zipResultField = InputText(self.$_zip)
        .custom("width", "calc(100% - 18px)")
        .placeholder("Codigo Postal")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .cursor(.pointer)
        .cursor(.default)
        .disabled(true)
    
    lazy var contacto1 = InputText(self.$_contacto1)
        .autocomplete(.off)
        .placeholder("Nombre Contacto")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
    
    lazy var contacto2 = InputText(self.$_contacto2)
        .autocomplete(.off)
                .placeholder("Apellido Contacto")
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
    
    lazy var cardIdField = Div(self.$cardId.map{ $0.isEmpty ? "sw-23AB1234" : $0 })
        .custom("width", "calc(100% - 64px)")
        .class(.textFiledLightLarge)
        .cursor(.pointer)
        .color(.gray)
        .onClick {
            self.activateRewards()
        }
    
    lazy var dateDay = Strong(self.$sugestedPromiseDay)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .color(self.$sugestedPromiseDay.map{$0 == "DD/MM/AAAA" ? .lightGray : .orangeRed})
        .onClick {
            self.selectDate()
        }
    
    lazy var dateHour = Strong(self.$sugestedPromiseHour)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .color(self.$sugestedPromiseHour.map{$0 == "HH:MM" ? .lightGray : .orangeRed})
        .onClick {
            self.selectDate()
        }
    
    lazy var selectUser = Select(self.$selectedUserID)
        .class(.textFiledLightLarge)
        .width(99.percent)
        .fontSize(23.px)
        .height(38.px)
    
    @State var ttotal = "$0.00"
    
    lazy var chargesTable = Table {
        Tr{
            Td().width(20.px)
            Td("Unis").width(50.px)
            Td("Description")
            Td("CUni").width(70.px)
            Td("STotal").width(70.px)
        }
        .color(.black)
    }.width(100.percent)
    
    /**  `` General Input Items `` */
    
    @State var selectEquipmentField = ""
    
    @State var _idTag1: String = ""
    @State var _idTag2: String = ""
    @State var _tag1: String = ""
    @State var _tag2: String = ""
    @State var _tag3: String = ""
    @State var _tag4: String = ""
    @State var _tag5: String = ""
    @State var _tag6: String = ""
    @State var _descr: String = ""
    @State var _checkTag1: Bool = false
    @State var _checkTag2: Bool = false
    @State var _checkTag3: Bool = false
    @State var _checkTag4: Bool = false
    @State var _checkTag5: Bool = false
    @State var _checkTag6: Bool = false
    
    lazy var idTag1 = InputText(self.$_idTag1)
        .autocomplete(.off)
        .placeholder(configServiceTags.idTagPlaceholder)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
        .onFocus {
            self.selectEquipmentField = "idTag1"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var idTag2 = InputText(self.$_idTag2)
        .autocomplete(.off)
        .placeholder(configServiceTags.secondIDTagPlaceholder)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
        .onFocus {
            self.selectEquipmentField = "idTag2"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    var tag3CurrentSeleccionList: [UUID] = []
    
    var tag1CurrentSeleccionList: [UUID] = []
    
    var tag2CurrentSeleccionList: [UUID] = []
    
    @State var curOrderManagerBrand: [CustOrderManagerBrand] = []
    
    @State var curOrderManagerType: [CustOrderManagerType] = []
    
    @State var curOrderManagerModel: [CustOrderManagerModel] = []
    
    /// Brand
    @State var tag1PreSelctedItemID: UUID? = nil
    @State var tag1SelctedItemID: UUID? = nil
    
    /// Type eg:  X Box Play station iPhone Celular iPad Tablet Refrigerador...
    @State var tag3isDisabeld = true
    @State var tag3PreSelctedItemID: UUID? = nil
    @State var tag3SelctedItemID: UUID? = nil
    
    /// Model
    @State var tag2isDisabeld = true
    @State var tag2PreSelctedItemID: UUID? = nil
    @State var tag2SelctedItemID: UUID? = nil
    
    lazy var tag1Label = Label(configServiceTags.tag1Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag1" ? 18.px : 12.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag1" ? .black : .gray })
        .float(.left)
    
    lazy var tag1 = InputText(self.$_tag1)
        .placeholder(configServiceTags.tag1Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .autocomplete(.off)
        .onFocus {
            self.selectEquipmentField = "tag1"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag1Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .marginBottom(7.px)
                        .color(.gray)
                    
                    Div().class(.clear)
                    
                    Span{
                        Img()
                            .src("/skyline/media/add.png")
                            .paddingRight(12.px)
                            .padding(all: 3.px)
                            .height(18.px)
                            
                        Label("Agregar")
                            .cursor(.pointer)
                            .fontSize(32.px)
                            .color(.black)
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.addOrderManagerBrand()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            
            }
        }
        .width(100.percent)
        .height(130.px)
    }
    .maxHeight(300.px)
    .overflow(.auto)
    
    lazy var tag1ResultsView = Div{
        self.tag1Results
        Div(" + Agregar ")
            .padding(all: 12.px)
            .fontWeight(.bolder)
            .cursor(.pointer)
            .fontSize(24.px)
            .cursor(.pointer)
            .marginTop(7.px)
            .align(.center)
            .color(.black)
            .onClick(self.addOrderManagerBrand)
        
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    .position(.absolute)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    
    lazy var tag2Label = Label(configServiceTags.tag2Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag2" ? 18.px : 12.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag2" ? .black : .gray })
        .float(.left)

    lazy var tag2 = InputText(self.$_tag2)
        .placeholder(configServiceTags.tag2Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .autocomplete(.off)
        .onFocus {
            self.selectEquipmentField = "tag2"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag2Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
                    Span{
                        Img()
                            .src("/skyline/media/add.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(12.px)
                            
                        
                        Label("Agregar")
                            .fontSize(32.px)
                            .color(.black)
                            .cursor(.pointer)
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.addOrderManagerModel()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .width(100.percent)
        .height(130.px)
    }
        .maxHeight(300.px)
        .overflow(.auto)
    
    lazy var tag2ResultsView = Div{
        self.tag2Results
        
        Div(" + Agregar")
            .padding(all: 12.px)
            .fontWeight(.bolder)
            .cursor(.pointer)
            .cursor(.pointer)
            .marginTop(7.px)
            .fontSize(24.px)
            .align(.center)
            .color(.black)
            .onClick{
                self.addOrderManagerModel()
            }
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    .position(.absolute)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    
    lazy var tag3Label = Label(configServiceTags.tag3Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag3" ? 18.px : 12.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag3" ? .black : .gray })
        .float(.left)
    
    lazy var tag3 = InputText(self.$_tag3)
        .placeholder(configServiceTags.tag3Placeholder)
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag3"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag3Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .marginBottom(7.px)
                        .color(.gray)
                    
                    Div().class(.clear)
                    
                    Span{
                        Img()
                            .src("/skyline/media/add.png")
                            .paddingRight(12.px)
                            .padding(all: 3.px)
                            .height(18.px)
                            
                        Label("Agregar")
                            .cursor(.pointer)
                            .fontSize(32.px)
                            .color(.black)
                        
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.addOrderManagerType()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .width(100.percent)
        .height(130.px)
    }
    .maxHeight(300.px)
    .overflow(.auto)
    
    lazy var tag3ResultsView = Div{
        
        self.tag3Results
        
        Div(" + Agregar ")
            .padding(all: 12.px)
            .fontWeight(.bolder)
            .cursor(.pointer)
            .cursor(.pointer)
            .marginTop(7.px)
            .fontSize(24.px)
            .align(.center)
            .color(.black)
            .onClick(self.addOrderManagerType)
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    .position(.absolute)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    
    lazy var tag4 = InputText(self.$_tag4)
        .placeholder(configServiceTags.tag4Placeholder)
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag4"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag5 = InputText(self.$_tag5)
        .placeholder(configServiceTags.tag5Placeholder)
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag5"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag6 = InputText(self.$_tag6)
        .placeholder(configServiceTags.tag6Placeholder)
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag6"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var descr = TextArea(self.$_descr)
        .placeholder(configServiceTags.tagDescrPlaceholder)
        .custom("width", "calc(100% - 10px)")
        .class(.textFiledLightLarge)
        .width(100.percent)
        .height(90.px)
    
    lazy var checkTag1 = InputCheckbox().toggle(self.$_checkTag1)
    
    lazy var checkTag2 = InputCheckbox().toggle(self.$_checkTag2)

    lazy var checkTag3 = InputCheckbox().toggle(self.$_checkTag3)
    
    lazy var checkTag4 = InputCheckbox().toggle(self.$_checkTag4)
    
    lazy var checkTag5 = InputCheckbox().toggle(self.$_checkTag5)
    
    lazy var checkTag6 = InputCheckbox().toggle(self.$_checkTag6)
    
    /**  `` /General Input Items `` */
    
    @State var total:Int64 = 0
    
    @State var charges: [ChargeObject] = []
    
    @State var payments: [PaymentObject] = []
    
    @State var equipments: [EquipmentObject] = []
    
    var payChargeRef: [ UUID : OldChargeTrRow ] = [:]
    
    @DOM override var body: DOM.Content {
        Div{
            
            Div {
                
                H3("Orden de Servicio")
                    .color(.lightBlueText)
                
                Div().marginTop(7.px).class(.clear)
                
                /// Account number && Account Data
                Div{
                    
                    /// Account number
                    Div{
                        
                        Label("Cuenta")
                            .color(.gray)
                            .fontSize(16.px)
                        
                        Div().class(.clear)
                        
                        Strong(self.custAcct.folio)
                        
                        Div().class(.clear)
                        
                    }
                    .width(33.percent)
                    .float(.left)
                    
                    /// Account Data
                    Div{
                        
                        Label("Tipo de Cuenta")
                            .color(.gray)
                            .fontSize(16.px)
                        
                        Div().class(.clear)
                        
                        Strong("\(self.custAcct.type.description) \\ \(self.custAcct.costType.description)")
                        
                        Div().class(.clear)
                    }
                    .width(66.percent)
                    .float(.left)
                    
                }
                
                Div().clear(.both)
                
                Div{
                    
                    if self.custAcct.type == .personal {
                        
                        /// Account Contact
                        Div {
                            
                            Label("Nombre del Clientes")
                                .color(.gray)
                                .fontSize(16.px)
                            
                            Div().class(.clear)
                            
                            Strong("\(self.custAcct.firstName) \(self.custAcct.lastName)")
                            
                            Div().class(.clear)
                            
                            
                        }
                        .width(50.percent)
                        .float(.left)
                    }
                    else{
                        
                        /// Account Contact
                        Div {
                            
                            Label("Nombre dela empresa")
                                .color(.gray)
                                .fontSize(16.px)
                            
                            Div().class(.clear)
                            
                            Strong(self.custAcct.businessName)
                            
                            Div().class(.clear)
                            
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    
                    Div{
                        
                        Label("Telefono / Correo")
                            .color(.gray)
                            .fontSize(16.px)
                        
                        Div().class(.clear)
                        
                        Strong("\(self.custAcct.mobile) \(self.custAcct.email)")
                        
                        Div().class(.clear)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                Div().clear(.both).marginTop(7.px)
                
                H3("Datos de Contacto")
                    .color(.lightBlueText)
                
                // Contact First Name
                Div{
                    Span("Nombre")
                        .color(.red)
                    
                    self.firstName
                        .onBlur({ input, event in
                            self._firstName = input.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.secondName.select()
                        }
                }
                .class(.oneTwo)
                
                // Contact Second Name
                Div{
                    Span("Apellido")
                        .color(.red)
                    self.lastName
                        .tabIndex(3)
                        .onBlur({ tf in
                            tf.text = tf.text.purgeSpaces.capitalizingFirstLetters
                        })
                        .onEnter {
                            self.secondLastName.select()
                        }
                }
                .class(.oneTwo)
                
                Div().class(.clear)
                
                /// Mobile
                Div{
                    
                    Span("Celular")
                        .color(.red)

                    self.mobile
                        .autocomplete(.off)
                        .tabIndex(9)
                        .onKeyUp { tf in
                            tf
                                .removeClass(.isNok)
                                .removeClass(.isOk)
                                //.removeClass(.isLoading)
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
                                tf
                                    .removeClass(.isOk)
                                    .class(.isNok)
                                return
                            }
                            
                            tf
                                .removeClass(.isNok)
                                .class(.isOk)
                            
                        }
                }
                .class(.oneTwo)
                
                /// Contact Email
                Div {
                    
                    Span("Correo")

                    self.email
                        .autocomplete(.off)
                        .tabIndex(5)
                        .onEnter {
                            
                        }
                        .onKeyUp { tf in
                            tf
                                .removeClass(.isNok)
                                .removeClass(.isOk)
                                //.removeClass(.isLoading)
                        }
                        .onBlur { tf in
                            
                            var term = tf.text
                            
                            term = term.purgeSpaces
                            
                            if term.isEmpty {
                                return
                            }
                            
                            guard isValidEmail(term) else {
                                tf
                                    .removeClass(.isOk)
                                    .class(.isOk)
                                
                                showError(.invalidFormat, "Ingrese un correo valido")
                                return
                            }
                            
                            tf
                                .removeClass(.isNok)
                                .class(.isOk)
                        }
                }
                .class(.oneTwo)
               
                Div().class(.clear)
                    .height(3.px)
                
                /// Promises Day an WorkLoad
                Div {
                    
                    H3(self.$bookedPromises)
                        .float(.right)
                        .color(self.$bookedPromises.map{ $0 == "--" ? .gray : .red})
                        .hidden(self.$bookedPromises.map{ $0 == "searching" })
                    
                    Img()
                        .src("images/loader.gif")
                        .height(24.px)
                        .width(24.px)
                        .float(.right)
                        .hidden(self.$bookedPromises.map{ $0 != "searching" })
                    
                    H3("Ordenes:")
                        .marginRight(3.px)
                        .color(.gray)
                        .float(.right)
                    
                    H3(configServiceTags.typeOfServiceObject.dateTag.capitalizeFirstLetter)
                        .color(.orangeRed)
                    
                    Div().class(.clear)
                        .height(3.px)
                    
                    Div{
                        self.dateDay
                    }
                    .class(.twoThird)
                    
                    Div{
                        self.dateHour
                    }
                    .class(.oneThird)
                }
                
                Div().class(.clear)
                    .height(7.px)
                
                /// User
                Div{
                    
                    Div{
                        H3("Seleccione Usuario")
                            .color(.gray)
                    }
                    .width(33.percent)
                    .float(.left)
                    
                    Div{
                        self.selectUser
                    }
                    .width(66.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                
                Div().class(.clear).height(7.px)
                
                // Direccion Title
                Div{
                    
                    Div{
                        
                        Img()
                            .src(self.$requierServiceAddress.map{ $0 ? "/skyline/media/cross.png" : "/skyline/media/add.png"})
                            .marginLeft(3.px)
                            .cursor(.pointer)
                            .marginTop(3.px)
                            .height(18.px)
                            .onClick {
                                self.requierServiceAddress = !self.requierServiceAddress
                            }
                        
                    }
                    .float(.right)
                    
                    /*
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
                                self.searchPostalCode()
                            }
                        Div().clear(.both)
                        
                    }
                    .hidden(self.$requierServiceAddress.map { !$0 })
                    .marginRight(3.px)
                    .marginTop(1.px)
                    .class(.uibutton)
                    .float(.right)
                    
                    self.zipSearchField
                        .hidden(self.$requierServiceAddress.map { !$0 })
                        .marginRight(3.px)
                        .float(.right)
                    */
                    
                    Div{
                        H3("Direccion de Servicio")
                            .color(.lightBlueText)
                            .marginTop(3.px)
                    }
                    .float(.left)
                    
                    Div().clear(.both)
                }
                
                // Direccion Body
                Div{
                    
                    Div().class(.clear).marginTop(3.px)
                    
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
                                                    self.searchPostalCode()
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
                                
                                guard let country = Countries(rawValue: self._country), country == .mexico else {
                                    showError(.invalidField, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
                                    return
                                }
                                
                                let view = ManualAddressSearch(.byCountry(.mexico)) { settelment, city, state, zip, country in
                                    
                                    self._colony = settelment
                                    
                                    self._city = city
                                    
                                    self._state = state
                                    
                                    self._zip = zip
                                    
                                    self._country = country.description
                                    
                                    self.manualAddressInput = true
                                    
                                    self.street.select()
                                    
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
                                        
                                        self._colony = ""
                                        
                                        self._state = ""
                                        
                                        self._city = ""
                                        
                                        self._zip = ""
                                        
                                        self.foundAddressByZipCode = false
                                        
                                        self.zipSearchField.select()
                                        
                                    }
                            }
                            
                            self.streetResultField
                                .onBlur({ input, event in
                                    self._street = input.text.purgeSpaces.capitalizingFirstLetters
                                })
                                .onEnter {
                                    self.colony.select()
                                }
                            
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
                        
                        Div{
                            
                            /// Street
                            Span("Calle y numero")
                            
                            self.street
                                .onBlur({ input, event in
                                    self._street = input.text.purgeSpaces.capitalizingFirstLetters
                                })
                                .onEnter {
                                    self.colony.select()
                                }
                            
                            Div().class(.clear)
                            
                            /// Colony
                            Div{
                                Span("Colonia")
                                
                                self.colony
                                    .onBlur({ input, event in
                                        self._colony = input.text.purgeSpaces.capitalizingFirstLetters
                                    })
                                    .onEnter {
                                        self.city.select()
                                    }
                                
                            }
                            .class(.oneHalf)
                            
                            /// City
                            Div{
                                Span("Cuidad")
                                self.city
                                    .onBlur({ input, event in
                                        self._city = input.text.purgeSpaces.capitalizingFirstLetters
                                    })
                                    .onEnter {
                                        self.state.select()
                                    }
                            }
                            .class(.oneHalf)
                            
                            Div().class(.clear)
                            
                            /// State
                            Div{
                                Span("Estado")
                                self.state
                                    .onBlur({ input, event in
                                        self._state = input.text.purgeSpaces.capitalizingFirstLetters
                                    })
                                    .onEnter {
                                        self.country.select()
                                    }
                            }
                            .width(33.percent)
                            .float(.left)
                            
                            /// Codigo Postal
                            Div{
                                Span("C.P.")
                                self.zip
                                    .onBlur({ input, event in
                                        self._zip = input.text.purgeSpaces.capitalizingFirstLetters
                                    })
                                    .onEnter {
                                        self.firstName.select()
                                    }
                            }
                            .width(33.percent)
                            .float(.left)
                            
                            /// Country
                            Div{
                                Span("Pais")
                                
                                self.country
                                    .onBlur({ input, event in
                                        self._country = input.text.purgeSpaces.capitalizingFirstLetters
                                    })
                                    .onEnter {
                                        self.zip.select()
                                    }
                            }
                            .width(33.percent)
                            .float(.left)
                        }
                        
                        Div().clear(.both)
                        
                        Div{
                            Div("Buscar por Codigo Postal")
                                .class(.smallButtonBox)
                                .color(.gray)
                                .onClick {
                                    self.manualAddressInput = false
                                }
                        }
                        .padding(all: 7.px)
                        .align(.center)
                        
                    }
                    .hidden(self.$manualAddressInput.map{ !$0 })
                    
                    Div().class(.clear)
                
                }
                .hidden(self.$requierServiceAddress.map{!$0})
                
            }
            .custom("width", "calc(33% - 7px)")
            .height(100.percent)
            .marginRight(7.px)
            .overflow(.auto)
            .float(.left)
            
            // Charges, Rewards and Equipments
            Div{
                
                // Charges and Payments
                Div{
                    /// Charges
                    Div{
                        
                        /// Rewards Programe
                        if configStoreProcessing.rewardsPrograme != nil {
                            
                            Div{
                                
                                H3("Recompensas Premier")
                                    .color(.lightBlueText)
                                
                                Div()
                                    .marginTop(3.px)
                                    .class(.clear)
                                
                                Img()
                                    .src(self.$cardId.map{ $0.isEmpty ? "/skyline/media/rewards_unactive.png" : "/skyline/media/rewards_active.png" })
                                    .custom("width", "calc(100% - 24px)")
                                
                                Div()
                                    .marginTop(3.px)
                                    .class(.clear)
                                
                                Div{
                                    
                                    Img()
                                        .src("skyline/media/add.png")
                                        .paddingRight(7.px)
                                        .height(32.px)
                                        .float(.right)
                                        .onClick {
                                            self.activateRewards()
                                        }
                                    
                                    self.cardIdField
                                    
                                    Div()
                                        .marginTop(3.px)
                                        .class(.clear)
                                    
                                    Span("Recibira puntos por cada compra o servicio. Aplican TyC.")
                                        .color(.darkOrange)
                                    
                                }
                                .hidden(self.$cardId.map{ !$0.isEmpty })
                                
                                Div(self.$cardId.map{ $0.isEmpty ? "sw-23AB1234" : $0 })
                                    .hidden(self.$cardId.map{ $0.isEmpty })
                                    .custom("width", "calc(100% - 64px)")
                                    .class(.textFiledLightLarge)
                                    .cursor(.pointer)
                                
                                Div()
                                    .marginTop(7.px)
                                    .class(.clear)
                                
                            }
                        }
                        else {
                            // TODO: Add meth to ivite to join rewards programe
                        }
                        
                        H3("Cargos y Pagos")
                            .color(.lightBlueText)
                        
                        Div()
                            .marginTop(7.px)
                            .class(.clear)
                        
                        Div{
                            self.chargesTable
                        }
                        .class(.roundGrayBlackDark)
                        .height(200.px)
                        .paddingTop( 3.px)
                        .overflow(.auto)
                        
                        Div{
                            
                            /// charge
                            Div{
                                Img()
                                    .src("/skyline/media/price.png")
                                    .height(16.px)
                                    .marginRight(3.px)
                                
                                Span("Cargo")
                                .fontSize(16.px)
                                
                            }
                            .class(.uibutton)
                            .float(.left)
                            .onClick { _ in
                                self.addCharge()
                            }
                        
                            /// payment
                            Div{
                                
                                Img()
                                    .src("/skyline/media/coin.png")
                                    .height(16.px)
                                    .marginRight(3.px)
                                
                                Span("Pago")
                                    .fontSize(16.px)
                            }
                            .class(.uibutton)
                            .float(.left)
                            .onClick {
                                self.addPayment()
                            }
                                
                            Span(self.$ttotal)
                                .fontWeight(.bolder)
                                .fontSize(32.px)
                                .float(.right)
                                .color(.black)
                            
                        }
                        
                        Div().marginTop(7.px)
                        
                        /// Special Item


                    }
                    .overflow(.auto)
                }
                .custom("width", "calc(50% - 12px)")
                .height(100.percent)
                .marginRight(7.px)
                .overflow(.auto)
                .float(.left)
                
                // Equipments
                
                Div{
                    Div{
                    
                        Div{
                        
                            Img()
                                .closeButton(.view)
                                .marginRight(0.px)
                                .onClick{
                                    self.appendChild(ConfirmView(
                                        type: .yesNo,
                                        title: "Confirme Salida",
                                        message: "¿Quiere salir? Se perderan todos los datos.",
                                        callback: { resp, _ in
                                            if resp {
                                                //$keyUp.removeAllListeners() CKME
                                                _ = JSObject.global.deinitiateCanvas!()
                                                self.remove()
                                            }
                                        })
                                    )
                                }
                            
                            H3("Datos del orden")
                                .color(.lightBlueText)
                            
                            Div().clear(.both)
                                
                        }
                        
                        /// `idTag1`
                        Div(configServiceTags.idTagName)
                            .fontSize(self.$selectEquipmentField.map{ $0 == "idTag1" ? 18.px : 12.px })
                            .color(self.$selectEquipmentField.map{ $0 == "idTag1" ? .black : .gray })
                        
                        Div().class(.clear)
                        
                        self.idTag1
                        
                        Div().class(.clear)
                        
                        /// `idTag2`
                        Div{
                            Div(configServiceTags.secondIDTagName)
                                .fontSize(self.$selectEquipmentField.map{ $0 == "idTag2" ? 18.px : 12.px })
                                .color(self.$selectEquipmentField.map{ $0 == "idTag2" ? .black : .gray })
                                .float(.right)
                               
                            self.idTag2
                            
                        }.hidden(!configServiceTags.secondIDTagRequiered)
                        Div().class(.clear)
                        
                        // brandmode 023
                        
                        if configServiceTags.useBrandModelMode {
                            
                            ///`tag1`
                            Div{
                                
                                Div{
                                    
                                    self.tag1Label
                                    
                                    Label("*")
                                        .fontWeight(.bolder)
                                        .marginLeft(7.px)
                                        .fontSize(16.px)
                                        .color(.red)
                                        
                                }
                                
                                Div().class(.clear)
                                
                                self.tag1
                                    .onBlur({
                                        
                                        Dispatch.asyncAfter(0.3) {
                                            if let id = self.tag1SelctedItemID {
                                                orderManagerBrand.forEach { brand in
                                                    if brand.id == id {
                                                        self._tag1 = brand.name
                                                    }
                                                }
                                            }
                                        }
                                        
                                    })
                                    .onKeyUp({ tf, event in
                                        print(event.key)
                                        
                                        let key = event.key
                                        
                                        if (key == "ArrowUp") {
                                            
                                            if let id = self.tag1PreSelctedItemID {
                                                
                                                var cc = 0
                                                var curentSelected = 0
                                                
                                                self.tag1CurrentSeleccionList.forEach { _id in
                                                    if id == _id {
                                                        curentSelected += cc
                                                    }
                                                    cc += 1
                                                }
                                                
                                                print("current selected [up] \(curentSelected)")
                                                
                                                if curentSelected == 0 { return }
                                                
                                                self.tag1PreSelctedItemID = self.tag1CurrentSeleccionList[(curentSelected - 1)]
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        if (key == "ArrowDown") {
                                            
                                            if let id = self.tag1PreSelctedItemID {
                                                
                                                var cc = 0
                                                var curentSelected = 0
                                                
                                                self.tag1CurrentSeleccionList.forEach { _id in
                                                    if id == _id {
                                                        curentSelected += cc
                                                    }
                                                    cc += 1
                                                }
                                                
                                                print("current selected [down] \(curentSelected)")
                                                
                                                if (curentSelected + 1) == self.tag1CurrentSeleccionList.count { return }
                                                
                                                self.tag1PreSelctedItemID = self.tag1CurrentSeleccionList[(curentSelected + 1)]
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        if ignoredKeys.contains(key) { return }
                                        
                                        if (key == "Enter" || key == "NumpadEnter") {
                                            
                                            if let id = self.tag1PreSelctedItemID {
                                                
                                                orderManagerBrand.forEach { brand in
                                                    if brand.id == id {
                                                        if self.tag1SelctedItemID != brand.id {
                                                            /// change name to selected TYPE
                                                            self._tag1 = brand.name
                                                            self.tag1SelctedItemID = nil
                                                            self.tag1SelctedItemID = brand.id
                                                            self._tag3 = ""
                                                        }
                                                        
                                                        // Preforme Focus Acctions
                                                        self.tag3.select()
                                                        self.tag3Focus()
                                                    }
                                                }
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        /// if any other key
                                        self.tag1SelctedItemID = nil
                                        
                                        self.tag1Focus()
                                        
                                    })
                                    .onClick({ _, event in
                                        self.tag1Focus()
                                        event.stopPropagation()
                                    })
                                
                                self.tag1ResultsView
                                
                            }
                            
                            Div().class(.clear)
                            
                            ///`tag3`
                            Div{

                                Div{
                                    
                                    self.tag3Label
                                    
                                    Label("*").color(.red)
                                        .fontWeight(.bolder)
                                        .marginLeft(7.px)
                                        .fontSize(16.px)
                                        .float(.left)
                                    
                                }

                                Div().class(.clear)
                            
                                self.tag3
                                    .opacity(0.3)
                                    .disabled(true)
                                    .onBlur({
                                        
                                        Dispatch.asyncAfter(0.3) {
                                            if let id = self.tag3SelctedItemID {
                                                orderManagerType.forEach { type in
                                                    if type.id == id {
                                                        self._tag3 = type.name
                                                    }
                                                }
                                            }
                                        }
                                        
                                    })
                                    .onKeyUp({ tf, event in
                                        print(event.key)
                                        
                                        let key = event.key
                                        
                                        if (key == "ArrowUp") {
                                            
                                            if let id = self.tag3PreSelctedItemID {
                                                
                                                var cc = 0
                                                var curentSelected = 0
                                                
                                                self.tag3CurrentSeleccionList.forEach { _id in
                                                    if id == _id {
                                                        curentSelected += cc
                                                    }
                                                    cc += 1
                                                }
                                                
                                                print("current selected [up] \(curentSelected)")
                                                
                                                if curentSelected == 0 { return }
                                                
                                                self.tag3PreSelctedItemID = self.tag3CurrentSeleccionList[(curentSelected - 1)]
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        if (key == "ArrowDown") {
                                            
                                            if let id = self.tag3PreSelctedItemID {
                                                
                                                var cc = 0
                                                var curentSelected = 0
                                                
                                                self.tag3CurrentSeleccionList.forEach { _id in
                                                    if id == _id {
                                                        curentSelected += cc
                                                    }
                                                    cc += 1
                                                }
                                                
                                                print("current selected [down] \(curentSelected)")
                                                
                                                if (curentSelected + 1) == self.tag3CurrentSeleccionList.count { return }
                                                
                                                self.tag3PreSelctedItemID = self.tag3CurrentSeleccionList[(curentSelected + 1)]
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        if ignoredKeys.contains(key) { return }
                                        
                                        if (key == "Enter" || key == "NumpadEnter") {
                                            
                                            if let id = self.tag3PreSelctedItemID {
                                                
                                                orderManagerType.forEach { type in
                                                    if type.id == id {
                                                        
                                                        if self.tag3SelctedItemID != type.id {
                                                            /// change name to selected TYPE
                                                            self._tag3 = type.name
                                                            self.tag3SelctedItemID = nil
                                                            self.tag3SelctedItemID = type.id
                                                            self._tag2 = ""
                                                        }
                                                        
                                                        // Preforme Focus Acctions
                                                        self.tag2.select()
                                                        self.tag2Focus()
                                                    }
                                                }
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        /// if any other key
                                        self.tag3SelctedItemID = nil
                                        
                                        self.tag3Focus()
                                        
                                    })
                                    .onClick({ _, event in
                                        self.tag3Focus()
                                        event.stopPropagation()
                                    })
                                
                                self.tag3ResultsView
                                
                            }
                            
                            Div().class(.clear)
                            
                            ///`tag2`
                            Div{
                                Div{
                                    self.tag2Label
                                    
                                    Label("*").color(.red)
                                        .fontWeight(.bolder)
                                        .marginLeft(7.px)
                                        .fontSize(16.px)
                                        .float(.left)
                                        
                                }
                                
                                Div().class(.clear)
                                
                                self.tag2
                                    .disabled(true)
                                    .opacity(0.3)
                                    .onBlur({
                                        
                                        Dispatch.asyncAfter(0.3) {
                                            if let id = self.tag2SelctedItemID {
                                                orderManagerModel.forEach { model in
                                                    if model.id == id {
                                                        self._tag2 = model.name
                                                    }
                                                }
                                            }
                                        }
                                        
                                    })
                                    .onKeyUp({ tf, event in
                                        print(event.key)
                                        
                                        let key = event.key
                                        
                                        if (key == "ArrowUp") {
                                            
                                            if let id = self.tag2PreSelctedItemID {
                                                
                                                var cc = 0
                                                var curentSelected = 0
                                                
                                                self.tag2CurrentSeleccionList.forEach { _id in
                                                    if id == _id {
                                                        curentSelected += cc
                                                    }
                                                    cc += 1
                                                }
                                                
                                                print("current selected [up] \(curentSelected)")
                                                
                                                if curentSelected == 0 { return }
                                                
                                                self.tag2PreSelctedItemID = self.tag2CurrentSeleccionList[(curentSelected - 1)]
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        if (key == "ArrowDown") {
                                            
                                            if let id = self.tag2PreSelctedItemID {
                                                
                                                var cc = 0
                                                var curentSelected = 0
                                                
                                                self.tag2CurrentSeleccionList.forEach { _id in
                                                    if id == _id {
                                                        curentSelected += cc
                                                    }
                                                    cc += 1
                                                }
                                                
                                                print("current selected [down] \(curentSelected)")
                                                
                                                if (curentSelected + 1) == self.tag2CurrentSeleccionList.count { return }
                                                
                                                self.tag2PreSelctedItemID = self.tag2CurrentSeleccionList[(curentSelected + 1)]
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        if ignoredKeys.contains(key) { return }
                                        
                                        if (key == "Enter" || key == "NumpadEnter") {
                                            
                                            if let id = self.tag2PreSelctedItemID {
                                                
                                                orderManagerModel.forEach { brand in
                                                    if brand.id == id {
                                                        /// change name to selected TYPE
                                                        self._tag2 = brand.name
                                                        //self.tag3SelctedItem = type.name
                                                        self.tag2SelctedItemID = nil
                                                        self.tag2SelctedItemID = brand.id
                                                    }
                                                }
                                                
                                                self.tag1ResultsView.hidden(true)
                                                self.tag3ResultsView.hidden(true)
                                                self.tag2ResultsView.hidden(true)
                                                
                                            }
                                            
                                            return
                                        }
                                        
                                        /// if any other key
                                        self.tag2SelctedItemID = nil
                                        
                                        self.tag2Focus()
                                        
                                    })
                                    .onClick({ _, event in
                                        
                                        self.selectEquipmentField = "tag2"
                                        self.tag1ResultsView.hidden(true)
                                        self.tag3ResultsView.hidden(true)
                                        self.tag2ResultsView.hidden(false)
                                        
                                        event.stopPropagation()
                                    })
                                
                                self.tag2ResultsView
                            }
                            
                            Div().class(.clear)
                            
                        }
                        else {
                            
                            ///`tag1`
                            Div{
                                
                                self.tag1Label
                                
                                Div().class(.clear)
                                
                                self.tag1
                                
                            }.hidden(!configServiceTags.tag1)
                            
                            Div().class(.clear)
                            
                            ///`tag3`
                            Div{
                                self.tag3Label
                                
                                Div().class(.clear)
                                
                                self.tag3
                                
                            }.hidden(!configServiceTags.tag3)
                            
                            Div().class(.clear)
                            
                            ///`tag2`
                            Div{
                                self.tag2Label
                                
                                Div().class(.clear)
                                
                                self.tag2
                            }
                            .hidden(!configServiceTags.tag2)
                            
                            Div().class(.clear)
                            
                        }
                        
                        ///`tag4`
                        Div{
                            Label(configServiceTags.tag4Name)
                                .float(.right)
                                .color(self.$selectEquipmentField.map{ $0 == "tag4" ? .black : .gray })
                                .fontSize(self.$selectEquipmentField.map{ $0 == "tag4" ? 18.px : 12.px })

                            Div().class(.clear)
                            self.tag4
                        }.hidden(!configServiceTags.tag4)
                        Div().class(.clear)
                        
                        ///`tag5`
                        Div{
                            Label(configServiceTags.tag5Name)
                                .float(.right)
                                .color(self.$selectEquipmentField.map{ $0 == "tag5" ? .black : .gray })
                                .fontSize(self.$selectEquipmentField.map{ $0 == "tag5" ? 18.px : 12.px })

                            Div().class(.clear)
                            self.tag5
                        }.hidden(!configServiceTags.tag5)
                        Div().class(.clear)
                        
                        ///`tag6`
                        Div{
                            Label(configServiceTags.tag6Name)
                                .float(.right)
                                .color(self.$selectEquipmentField.map{ $0 == "tag6" ? .black : .gray })
                                .fontSize(self.$selectEquipmentField.map{ $0 == "tag6" ? 18.px : 12.px })

                            Div().class(.clear)
                            self.tag6
                        }.hidden(!configServiceTags.tag6)
                        Div().class(.clear)

                        H3("Descripcion de la orden")
                            .color(.lightBlueText)
                        
                        self.descr
                        
                        Div().class(.clear)
                        
                        /// Quick Checks
                        Div{
                            /// checkTag1
                            Div{
                                Div{
                                    self.checkTag1
                                }
                                .width(70.px)
                                .float(.left)
                                
                                Div(configServiceTags.checkTag1Name)
                                .class( .oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                            }
                            .hidden(!configServiceTags.checkTag1)
                            .class(.oneHalf)
                            
                            /// checkTag2
                            Div{
                                Div{
                                    self.checkTag2
                                }
                                .width(70.px)
                                .float(.left)
                                
                                Div(configServiceTags.checkTag2Name)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                                Div().class(.clear)
                            }
                            .hidden(!configServiceTags.checkTag2)
                            .class(.oneHalf)
                            
                            /// checkTag3
                            Div{
                                Div{
                                    self.checkTag3
                                }
                                .width(70.px)
                                .float(.left)
                                Div(configServiceTags.checkTag3Name)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                                Div().class(.clear)
                            }
                            .hidden(!configServiceTags.checkTag3)
                            .class(.oneHalf)
                            
                            /// checkTag4
                            Div{
                                Div{
                                    self.checkTag4
                                }
                                .width(70.px)
                                .float(.left)
                                
                                Div(configServiceTags.checkTag4Name)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                                Div().class(.clear)
                            }
                            .hidden(!configServiceTags.checkTag4)
                            .class(.oneHalf)
                            
                            /// checkTag5
                            Div{
                                Div{
                                    self.checkTag5
                                }
                                .width(70.px)
                                .float(.left)
                                Div(configServiceTags.checkTag5Name)
                                .class( .oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                                Div().class(.clear)
                            }
                            .hidden(!configServiceTags.checkTag5)
                            .class(.oneHalf)
                            
                            /// checkTag6
                            Div{
                                Div{
                                    self.checkTag6
                                }
                                .width(70.px)
                                .float(.left)
                                Div(configServiceTags.checkTag6Name)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                                Div().class(.clear)
                            }
                            .hidden(!configServiceTags.checkTag6)
                            .class(.oneHalf)
                            
                        }
                        
                        Div().class(.clear)
                        
                        ForEach(self.$equipments) { equipment in
                            Div{
                                
                                Img()
                                    .src("/skyline/media/cross.png")
                                    .marginRight(3.px)
                                    .cursor(.pointer)
                                    .float(.right)
                                    .onClick {
                                        var _equipments: [EquipmentObject] = []
                                        
                                        self.equipments.forEach { _equipment in
                                            
                                            if equipment.refid == _equipment.refid {
                                                return
                                            }
                                            
                                            _equipments.append(_equipment)
                                            
                                        }
                                        
                                        self.equipments = _equipments
                                        
                                    }
                                
                                Div("\(equipment.tag1) \(equipment.tag2) \(equipment.tag3) \(equipment.tag4)".purgeSpaces)
                                    .custom("width", "calc(100% - 35px)")
                                    .class(.oneLineText, .uibtnLarge)
                                    
                            }
                            .width(97.percent)
                        }
                        
                        Div().class(.clear)
                        
                        /// PIN  Pattrn 

                        if configStore.print.image == .pinpattern {

                            Div{
                                H2("PATRON / PIN de  Accesso")
                            }

                            Div().clear(.both).height(7.px)

                            Div{

                                Div()
                                .custom("width", "calc(50% - 7px)")
                                .class(.roundGrayBlackDark)
                                .id(.init("pinpatterCanvas"))
                                .position(.static)
                                .height(100.percent)
                                .marginRight(3.px)
                                .float(.left)

                                Div{
                                    Div{
                                        Label("Tipo de patron")

                                        Div().height(3.px).clear(.both)

                                        self.pinPatternSelect

                                        Div().height(7.px).clear(.both)

                                        Div("Resetear")
                                        .custom("width", "calc(100% - 20px)")
                                        .class(.uibutton)
                                        .onClick{
                                            
                                            _ = JSObject.global.resetCanvas!()
                                            
                                            let select = self.pinPatternSelect

                                            _ = JSObject.global.loadImageCanvas!("/skyline/media/\(select.text.isEmpty ? "pinpatern_canvas_3x3.png" : select.text)")

                                        }

                                        Div().height(7.px).clear(.both)

                                        Label("PIN / Contraseña")

                                        Div().height(3.px).clear(.both)

                                        self.pinOfDeviceField

                                    }
                                    .margin(all:3.px)

                                }
                                .height(100.percent)
                                .width(50.percent)
                                .float(.left)

                            }
                            .width(100.percent)
                            .height(200.px)

                            Div().height(12.px).clear(.both)

                        }

                        Div{
                            
                            Img()
                                .src("skyline/media/add.png")
                                .paddingRight(7.px)
                                .height(24.px)
                            
                            Span("Agregar \(configServiceTags.typeOfServiceObject.description) Adicional")
                        }
                        .fontSize(20.px)
                        .align(.center)
                        .class(.smallButtonBox)
                        .onClick{
                            addToDom(StartServiceOrderEquipmentView(
                                equipment: nil,
                                callback: { equipment in
                                    self.equipments.append(equipment)
                                }))
                        }
                         
                    }
                    .padding(all: 7.px)
                }
                .custom("width", "calc(50% - 0px)")
                .height(100.percent)
                .overflow(.auto)
                .float(.left)
            
                Div{
                    Div("Crear Orden")
                        .fontSize(18.px)
                        .class(.uibutton)
                        .onClick{ _, event in
                            self.createOrder()
                            event.preventDefault()
                            
                        }
                }
                .border(width: .thin, style: .solid, color: .white)
                .backgroundColor(h: 0, s: 0, l: 0, a: 0.5)
                .padding(v: 7.px, h: 12.px)
                .borderRadius(all: 12.px)
                .paddingBottom(7.px)
                .position(.fixed)
                .bottom(25.px)
                .right(25.px)
            }
            .height(100.percent)
            .width(66.percent)
            .float(.left)
            
        }
        .custom("height", "calc(100% - 85px)")
        .custom("left", "calc(5% - 12px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .padding(all: 12.px)
        .position(.absolute)
        .width(90.percent)
        .top(36.px)
        .onClick {
            
            Dispatch.asyncAfter(0.1) {
                self.tag1ResultsView.hidden(true)
                self.tag2ResultsView.hidden(true)
                self.tag3ResultsView.hidden(true)
            }
            
        }
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        switch custAcct.type {
        case .personal:
        
            cardId = custAcct.CardID
            
            _firstName = custAcct.firstName
            _lastName = custAcct.lastName
            
            _mobile = custAcct.mobile
            _email = custAcct.email
            
            _street = custAcct.street
            _colony = custAcct.colony
            _city = custAcct.city
            _state = custAcct.state
            
            if !custAcct.country.isEmpty {
                _country = custAcct.country
            }
            
            _zip = custAcct.zip
            
            if !_zip.isEmpty {
                searchZipCodeString = _zip
                searchPostalCode( _colony.isEmpty ? nil : _colony )
            }
            
            
        case .empresaFisica, .empresaMoral, .organizacion:
            break
        }
        
        self.requierServiceAddress = configContactTags.requierServiceAddress
        
        self.$dueAt.listen {
            if let _uts = $0 {
                let newDate = Date(timeIntervalSince1970: TimeInterval(_uts))
                
                self.sugestedPromiseDay = "\(newDate.day)/\(newDate.month)/\(newDate.year)"
                self.sugestedPromiseHour = "\(newDate.time)"
                self.getBookedPromises(day: newDate.day, month: newDate.month, year: newDate.year)
                self.selectedDateStamp = "\(newDate.year)/\(newDate.month)/\(newDate.day)"
            }
            else{
                self.sugestedPromiseDay = "DD/MM/AAAA"
                self.sugestedPromiseHour = "HH:MM"
                self.selectedDateStamp = ""
            }
        }
        
        self.selectUser.appendChild(
            Option("Seleccione Usuario")
                .value("")
        )
        
        userCathByUUID.forEach { _, user in
            self.selectUser.appendChild(
                Option(user.username)
                    .value(user.id.uuidString)
            )
        }
        
        if configGeneral.autoCalculateOfDates {
            
            API.custOrderV1.getWorkLoadPromis(storeid: custCatchStore) { resp in
                
                guard let resp = resp else {
                    return
                }
                
                guard resp.status == .ok else{
                    return
                }
                
                if let uts = resp.data?.sugestedPromis {
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(uts))
                    
                    var components = DateComponents()
                    components.day = date.day
                    components.month = date.month
                    components.year = date.year
                    components.hour = 16
                    components.minute = 0
                    
                    guard let now = Calendar.current.date(from: components)?.timeIntervalSince1970 else {
                        return
                    }
                    
                    self.dueAt = Int64(now)
                    
                }
            }
        }
        
        if configServiceTags.useBrandModelMode {
            
            $tag1SelctedItemID.listen {
                if let _ = $0 {
                    self.tag3isDisabeld = false
                    self.tag1.class(.isOk)
                }
                else{
                    self.tag3isDisabeld = true
                    self._tag3 = ""
                    self.tag3SelctedItemID = nil
                    self.tag1.removeClass(.isOk)
                }
            }
            
            $tag3SelctedItemID.listen {
                
                if let _ = $0 {
                    self.tag2isDisabeld = false
                    self.tag3.class(.isOk)
                }
                else {
                    
                    self.tag2isDisabeld = true
                    self._tag2 = ""
                    self.tag2SelctedItemID = nil
                    self.tag3.removeClass(.isOk)
                }
            }
            
            $tag2SelctedItemID.listen {
                if let _ = $0 {
                    self.tag2.class(.isOk)
                }
                else{
                    self.tag2.removeClass(.isOk)
                }
            }
            
            $tag3isDisabeld.listen {
                if $0 {
                    self.tag3.disabled(true)
                    self.tag3.opacity(0.3)
                }
                else{
                    self.tag3.disabled(false)
                    self.tag3.opacity(1.0)
                }
            }
            
            $tag2isDisabeld.listen {
                if $0 {
                    self.tag2.disabled(true)
                    self.tag2.opacity(0.3)
                }
                else{
                    self.tag2.disabled(false)
                    self.tag2.opacity(1.0)
                }
            }
        }
         
        custAcct.highPriorityNotes?.forEach({ note in
            
            if shownHighPriorityNotes.contains(note.id) {
                return
            }
            
            shownHighPriorityNotes.append(note.id)
            
            addToDom(ViewHighPriorityNote(
                type: .account,
                note: note,
                folio: self.custAcct.folio,
                name: self.custAcct.firstName
            ))
        })
    
    }
    
    override func didAddToDOM(){
        super.didAddToDOM()

        print("🟢  configStore.print.image")
        print(configStore.print.image)

        if configStore.print.image == .pinpattern {
            _ = JSObject.global.initiateCanvas!()
        }

    }

    override func didRemoveFromDOM(){
        print("⚠️  didRemoveFromDOM")
        super.didRemoveFromDOM()
        _ = JSObject.global.deinitiateCanvas!()
    }

    func activateRewards(){
        
        guard custAcct.type == .personal else {
          showError(.generalError, "Lo sentimos las cuentas \(self.custAcct.type.description) aun no es soportado.")
          return
        }

        addToDom(AccountView.RequestSiweCard(
            accountId: self.custAcct.id,
            cc: .mexico,
            mobile: self.custAcct.mobile,
            callback: { token, cardId, _ in
                self.smsTokens.append(token)

                addToDom(AccountView.ConfimeSiweCard(
                    custAcct: self.custAcct.id,
                    cc: .mexico,
                    mobile: self.custAcct.mobile,
                    tokens: self.smsTokens,
                    cardId: cardId,
                    callback: { cardId in
                        self.cardId = cardId
                        self.custAcct.CardID = cardId
                    }
                ))
            })
        )
    }
    
    func selectDate() {
        self.appendChild(
            SelectCalendarDate(
                type: .folio,
                selectedDateStamp: self.selectedDateStamp,
                currentSelectedDates: []
            ) { _, uts, _ in
                self.dueAt = Int64(uts)
            }
        )
    }
    
    func getBookedPromises(day: Int, month: Int, year: Int){
        
        self.bookedPromises = "searching"
        
        API.custOrderV1.getWorkLoadDay(
            type: .folio,
            day: day,
            month: month,
            year: year
        ) { resp in
            self.bookedPromises = "--"
            
            guard let resp = resp else {
                return
            }
            
            guard resp.status == .ok else {
                return
            }
            
            guard let  orders = resp.data?.orders else {
                return
            }

            if orders > 0 {
                self.bookedPromises = orders.toString
            }
        }
    }
    
    func calcBalance(){
        
        total = 0
        
        charges.forEach { obj in
            total += ((obj.price * obj.units) / 100)
        }
        
        payments.forEach { obj in
            total -= obj.amount
        }
        
        self.ttotal = total.formatMoney
        
    }
    
    func createOrder(_ force: Bool = false){
        
        if _firstName.isEmpty {
            showError(.requiredField, .requierdValid(.firstName))
            firstName.select()
            return
        }
        
        if _lastName.isEmpty {
            showError(.requiredField, .requierdValid(.lastName))
            lastName.select()
            return
        }
        
        if _mobile.isEmpty {
            showError(.requiredField, .requierdValid(.mobile))
            mobile.select()
            return
        }
        
        if !postalCodeResults.isEmpty && !manualAddressInput {
            
            if _street.isEmpty {
                showError(.requiredField, .requierdValid(.streetNumber))
                streetResultField.select()
                return
            }
            
            if _colony.isEmpty {
                showError(.requiredField, .requierdValid(.colony))
                return
            }
        }
        
        if configServiceTags.useBrandModelMode {
            
            if tag1SelctedItemID == nil {
                showError(.requiredField, .requierdValid(configServiceTags.tag1Name))
                tag1.select()
                return
            }
            
            if tag3SelctedItemID == nil {
                showError(.requiredField, .requierdValid(configServiceTags.tag3Name))
                tag3.select()
                return
            }
            
            if tag2SelctedItemID == nil {
                showError(.requiredField, .requierdValid(configServiceTags.tag2Name))
                tag2.select()
                return
            }
        }
        
        if _descr.isEmpty {
            showError(.requiredField, .requierdValid("Description"))
            return
        }
        
        var _equipments: [EquipmentObject] = []
        
        _equipments.append(.init(
            IDTag1: self._idTag1,
            IDTag2: self._idTag2,
            tag1: self._tag1,
            tag2: self._tag2,
            tag3: self._tag3,
            tag4: self._tag4,
            tag5: self._tag5,
            tag6: self._tag6,
            tagCheck1: self._checkTag1,
            tagCheck2: self._checkTag2,
            tagCheck3: self._checkTag3,
            tagCheck4: self._checkTag4,
            tagCheck5: self._checkTag5,
            tagCheck6: self._checkTag6,
            tagDescr: self._descr + (pinOfDevice.isEmpty ? "" : "\nPIN / CONTRASEñA: \(pinOfDevice)")
        ))
        
        _equipments.append(contentsOf: self.equipments)
        
        if let orderOpenInscriptionMode = configStoreProcessing.rewardsPrograme?.orderOpenInscriptionMode {
            if custAcct.type == .personal {
                switch orderOpenInscriptionMode {
                case .required:
                    if self.cardId.isEmpty {
                        self.activateRewards()
                        showError(.generalError, "Se requiere que incriba al cliente en el sistema de recompensas")
                        return
                    }
                case .recomended:
                    if self.cardId.isEmpty {
                        if !force {
                            
                            addToDom(AccountView.RequestSiweCard(
                                accountId: self.custAcct.id,
                                cc: .mexico,
                                mobile: self.custAcct.mobile,
                                callback: { token, cardId, _ in
                                    self.smsTokens.append(token)

                                    addToDom(AccountView.ConfimeSiweCard(
                                        custAcct: self.custAcct.id,
                                        cc: .mexico,
                                        mobile: self.custAcct.mobile,
                                        tokens: self.smsTokens,
                                        cardId: cardId,
                                        callback: { cardId in
                                            self.cardId = cardId
                                            self.custAcct.CardID = cardId
                                        }
                                    ))
                                },
                                bypassProgram: {
                                    self.createOrder(true)
                                }
                            ))
                            
                            return
                        }
                    }
                case .notrequired:
                    break
                case .optional:
                    break
                }
            }
        }
        
        loadingView(show: true)
        
        self.loadPinPattern { error in
            showError(.generalError, error)
            loadingView(show: false)
        } success: { fileName in

            var files: [String] = []

            if let fileName {
                files.append(fileName)
            }

            API.custOrderV1.create(
                type: .folio,
                store: custCatchStore,
                custAcct: self.custAcct.id,
                custSubAcct: nil,
                workedBy: UUID(uuidString: self.selectedUserID),
                dueDate: self.dueAt,
                rentStartAt: nil,
                rentEndAt: nil,
                description: self._descr,
                ///  insted of server  do small descr here ??
                smallDescription: "",
                lat: nil,
                lon: nil,
                contact: .init(
                    firstName: self._firstName,
                    secondName: self._secondName,
                    lastName: self._lastName,
                    secondLastName: self._secondLastName,
                    mobile: self._mobile,
                    telephone: "",
                    email: self._email
                ),
                address: .init(
                    street: self._street,
                    colony: self._colony,
                    city: self._city,
                    zip: self._zip,
                    state: self._state,
                    country: self._country
                ),
                rentals: [],
                charges: self.charges,
                payment: self.payments,
                equipments: _equipments,
                files: files
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let id = resp.id else {
                    showError(.generalError, .unexpectedMissingValue("id de folio"))
                    return
                }
                
                if let folio = resp.folio {
                    showSuccess(.operacionExitosa, "Folio: \(folio) creado con exito")
                }
                else{
                    showSuccess(.operacionExitosa, "Folio creado con exito")
                }
            
                self.callback(id, self.shownHighPriorityNotes,files)
            
                self.remove()
                
            }
        
        }
    }
    
    func loadPinPattern(failure: @escaping ((
        _ error: String
    ) -> ()), success: @escaping((
        _ fileName: String?
    ) -> ())) {

        let xhr = XMLHttpRequest()
        
        guard (JSObject.global.canvasHasPattern.boolean ?? false) else {
            success(nil)
            return
        }

        guard let base64String = JSObject.global.getImageCanvas!().string else {
            failure("🔴 Coult not load base 64")
            return
        }

        let fileName =  "img_\(callKey(7))_\(getNow()).png"

        let formData = FormData()

        //let byteArray: [UInt8] = [UInt8](data)

        let jsValue = JSObject.global.dataURLtoFile!(base64String, fileName).jsValue
        
        let file = File(jsValue)

        formData.append("event", UUID().uuidString)

        formData.append("file", file, filename: fileName)

        xhr.onLoadStart { event in
            print("🟢 UPLOAD START")
        }
        
        xhr.onError { jsValue in
            showError(.comunicationError, .serverConextionError)
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            
            let event = ProgressEvent(_event.jsEvent)
            
            let progress = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
            
        }
        
        xhr.onProgress { event in
            print("⭐️ onProgress 002-A")
            print(event.loaded)
            print(event.total)
        }
        
        xhr.onLoadEnd {
            print("⭐️ onLoadEnd 001")

            guard let responseText = xhr.responseText else {
                failure("Error de Conexción")
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                failure("No se pudo decodifocar respuesta [DATA]")
                return
            }
            
            do {

                let resp = try JSONDecoder().decode(ApiResponse.self, from: data)

                guard resp.status == .ok else {
                    failure(resp.msg)
                    return
                }

                success(fileName)

            }
            catch {
                failure("No se pudo decodifocar respuesta [DECODER] \(String(describing: error))")
            }
            
        }

        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/preUploadManager")
        
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

    /// brand
    func addOrderManagerBrand(){
        
        self.tag1ResultsView.hidden(true)
        
        let view = AddOrderManagerBrand(
            term: self._tag1
        ){ brand in
            
            /// add to local catch
            orderManagerBrand.append(brand)
            /// change name to selected TYPE
            self._tag1 = brand.name
            
            /// Clear Current Data
            self.tag1SelctedItemID = nil
            
            /// load new data
            self.tag1SelctedItemID = brand.id
            
            // Preforme Focus Acctions
            self.tag3.select()
            self.tag3Focus()
            
        }
        
        self.appendChild(view)
        
        view.termInput.select()
    }
    
    /// type
    func addOrderManagerType(){
        
        self.tag3ResultsView.hidden(true)
        
        guard let brandId = self.tag1SelctedItemID else {
            showError(.generalError, "No se pudo cargar el id de la marca")
            return
        }
        
        let view = AddOrderManagerType(
            brandId: brandId,
            term: self._tag3
        ) { type in
            /// add to local catch
            orderManagerType.append(type)
            /// change name to selected TYPE
            
            print("nde type added")
            
            print(type)
            
            self._tag3 = type.name
            
            self.tag3SelctedItemID = nil
            
            self.tag3SelctedItemID = type.id
            
            // Preforme Focus Acctions
            self.tag2.select()
            self.tag2Focus()
        }
        
        self.appendChild(view)
        
        view.termInput.select()
        
    }
    
    /// model
    func addOrderManagerModel(){
        
        self.tag2ResultsView.hidden(true)
        
        guard let typeId = self.tag3SelctedItemID else{
            showError(.unexpectedResult, "No se localizo \(configServiceTags.tag3Name) seleccionado, Contacte a Soporte TC")
            return
        }
        
        guard let brandId = self.tag1SelctedItemID else{
            showError(.unexpectedResult, "No se localizo \(configServiceTags.tag3Name) seleccionado, Contacte a Soporte TC")
            return
        }
        
        var brandName = ""
        
        orderManagerBrand.forEach { brand in
            if brandId == brand.id {
                brandName = brand.name
            }
        }
        
        let view = AddOrderManagerModel(
            term: self._tag2,
            typeId: typeId,
            brandId: brandId,
            brandName: brandName
        ){ model in
            /// add to local catch
            orderManagerModel.append(model)
            /// change name to selected TYPE
            self._tag2 = model.name
            
            self.tag2SelctedItemID = nil
            
            self.tag2SelctedItemID = model.id
        }
        
        self.appendChild(view)
        
        view.termInput.select()
    }
    
    /// brand
    func tag1Focus(){
        
        self.selectEquipmentField = "tag1"
        
        if orderManagerBrand.isEmpty {
            
            /// No brands  available  to `TYPE`
            self.tag1ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.addOrderManagerBrand()
            
            return
        }
        else {
            
            self.tag1Results.innerHTML = ""
            
            self.tag1CurrentSeleccionList.removeAll()
            
            /// This means their has already been a selection  on bulr will default back is selction remaind valid
            if let _ = tag1SelctedItemID {
                self._tag1 = ""
            }
            
            /// Strat filtering proces is applied
            if self._tag1.isEmpty{
                self.curOrderManagerBrand = orderManagerBrand
            }
            else {
                /// term to search
                let term = self._tag1.purgeSpaces.pseudo
                
                /// Refrecne to avoid duplicate results
                var included:[UUID] = []
                
                self.curOrderManagerBrand.removeAll()
                
                ///prase results with `PREFIX`
                orderManagerBrand.forEach { type in
                    if type.pseudo.hasPrefix(term){
                        included.append(type.id)
                        self.curOrderManagerBrand.append(type)
                    }
                }
                
                ///prase results with `CONTAINS` && not in `included` list
                orderManagerBrand.forEach { type in
                    if type.pseudo.contains(term) && !included.contains(type.id){
                        included.append(type.id)
                        self.curOrderManagerBrand.append(type)
                    }
                }
                
            }
            
            if let id = self.tag1SelctedItemID {
                
                /// Verify is the id that has been selected is included in the list to be viewed
                var idIsIncluded = false
                self.curOrderManagerBrand.forEach { brand in
                    if brand.id == id {
                        idIsIncluded = true
                    }
                }
                
                if idIsIncluded{
                    self.tag1PreSelctedItemID = id
                }
                else{
                    self.tag1PreSelctedItemID = self.curOrderManagerBrand.first?.id
                }
                
            }
            else {
                self.tag1PreSelctedItemID = self.curOrderManagerBrand.first?.id
            }
            
            self.curOrderManagerBrand.forEach { brand in
            
                self.tag1CurrentSeleccionList.append(brand.id)
                
                let view = OrderManagerItem(
                    id: brand.id,
                    name: brand.name,
                    preSelectID: self.$tag1PreSelctedItemID
                ){ id, name in
                    
                    if self.tag1SelctedItemID != id {
                        /// change name to selected TYPE
                        self._tag1 = name
                        self.tag1SelctedItemID = nil
                        self.tag1SelctedItemID = id
                        self._tag3 = ""
                    }
                    
                    // Preform Focus Accion
                    self.tag3.select()
                    
                    Dispatch.asyncAfter(0.25) {
                        self.tag3Focus()
                    }
                }
                
                self.tag1Results.appendChild(view)
            }
            
            self.tag1ResultsView.hidden(false)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            
        }
        
    }
    
    /// type
    func tag3Focus(){
        
        self.selectEquipmentField = "tag3"
        
        /// Empty the id of the viewd list
        self.tag3CurrentSeleccionList.removeAll()
        
        /// Empty the viewed list
        self.curOrderManagerType.removeAll()
        
        /// List preloader
        var _curOrderManagerType: [CustOrderManagerType] = []
        
        guard let brandId = self.tag1SelctedItemID else {
            showError(.generalError, "Seleccione \(configServiceTags.idTagName.uppercased())")
            return
        }
        
        orderManagerType.forEach { type in
            if type.custOrderManagerBrand != brandId {
                return
            }
            _curOrderManagerType.append(type)
        }
        
        if _curOrderManagerType.isEmpty {
            self.tag1ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.addOrderManagerType()
            return
        }
        
        self.tag3Results.innerHTML = ""
        
        /// This means their has already been a selection  on bulr will default back is selction remaind valid
        if let _ = tag3SelctedItemID {
            self._tag3 = ""
        }
        
        if self._tag3.isEmpty {
            curOrderManagerType = _curOrderManagerType
        }
        else{
            /// term to search
            let term = self._tag3.purgeSpaces.pseudo
            /// Refrecne to avoid duplicate results
            var included:[UUID] = []
            ///prase results with `PREFIX`
            _curOrderManagerType.forEach { type in
                if type.pseudo.hasPrefix(term){
                    included.append(type.id)
                    self.curOrderManagerType.append(type)
                }
            }
            ///prase results with `CONTAINS` && not in `included` list
            _curOrderManagerType.forEach { type in
                if type.pseudo.contains(term) && !included.contains(type.id){
                    included.append(type.id)
                    self.curOrderManagerType.append(type)
                }
            }
            
        }
        
        if let id = self.tag3SelctedItemID {
            
            /// Verify is the id that has been selected is included in the list to be viewed
            var idIsIncluded = false
            self.curOrderManagerType.forEach { type in
                if type.id == id {
                    idIsIncluded = true
                }
            }
            
            if idIsIncluded{
                self.tag3PreSelctedItemID = id
            }
            else{
                self.tag3PreSelctedItemID = curOrderManagerType.first?.id
            }
            
        }
        else {
            self.tag3PreSelctedItemID = curOrderManagerType.first?.id
        }
        
        self.curOrderManagerType.forEach { type in
        
            self.tag3CurrentSeleccionList.append(type.id)
            
            let view = OrderManagerItem(
                id: type.id,
                name: type.name,
                preSelectID: self.$tag3PreSelctedItemID
            ){ id, name in
                
                if self.tag3SelctedItemID != id {
                    /// change name to selected TYPE
                    self._tag3 = name
                    // self.tag3SelctedItem = type.name
                    self.tag3SelctedItemID = nil
                    self.tag3SelctedItemID = id
                    self._tag2 = ""
                }
                // Preform Focus Accion
                self.tag2.select()
                
                Dispatch.asyncAfter(0.25) {
                    self.tag2Focus()
                }
            }
            
            self.tag3Results.appendChild(view)
        }
        
        self.tag1ResultsView.hidden(true)
        self.tag3ResultsView.hidden(false)
        self.tag2ResultsView.hidden(true)
        
    }
    
    /// model
    func tag2Focus(){
        
        self.selectEquipmentField = "tag2"
        
        self.curOrderManagerModel.removeAll()
        
        /// Pre resutls, loads all  the `Models` of the `Brands` no filtering aplied till next step
        var _curOrderManagerModel: [CustOrderManagerModel] = []
        
        guard let typeId = self.tag3SelctedItemID else {
            showError(.generalError, "Seleccione tipo objeto")
            return
        }
        
        /// Populate `curOrderManagerBrand` base on the id of the select `TYPE`
        orderManagerModel.forEach { model in
            if typeId != model.custOrderTypeManager { return }
            _curOrderManagerModel.append(model)
        }
        
        if _curOrderManagerModel.isEmpty {
            /// No brands  available  to `TYPE`
            self.tag1ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.addOrderManagerModel()
            
            return
        }
        else {
            
            self.tag2Results.innerHTML = ""
            
            self.tag2CurrentSeleccionList.removeAll()
            
            /// This means their has already been a selection  on bulr will default back is selction remaind valid
            if let _ = tag2SelctedItemID {
                self._tag2 = ""
            }
            
            /// Strat filtering proces is applied
            if self._tag2.isEmpty {
                curOrderManagerModel = _curOrderManagerModel
            }
            else{
               
                /// term to search
                let term = self._tag2.purgeSpaces.pseudo
                /// Refrecne to avoid duplicate results
                var included:[UUID] = []
                ///prase results with `PREFIX`
                _curOrderManagerModel.forEach { type in
                    if type.pseudo.hasPrefix(term){
                        included.append(type.id)
                        self.curOrderManagerModel.append(type)
                    }
                }
                ///prase results with `CONTAINS` && not in `included` list
                _curOrderManagerModel.forEach { type in
                    if type.pseudo.contains(term) && !included.contains(type.id){
                        included.append(type.id)
                        self.curOrderManagerModel.append(type)
                    }
                }
                
            }
            
            if let id = self.tag2SelctedItemID {
                
                /// Verify is the id that has been selected is included in the list to be viewed
                var idIsIncluded = false
                self.curOrderManagerModel.forEach { brand in
                    if brand.id == id {
                        idIsIncluded = true
                    }
                }
                
                if idIsIncluded{
                    self.tag2PreSelctedItemID = id
                }
                else{
                    self.tag2PreSelctedItemID = self.curOrderManagerModel.first?.id
                }
                
            }
            else {
                self.tag2PreSelctedItemID = self.curOrderManagerModel.first?.id
            }
            
            self.curOrderManagerModel.forEach { model in
            
                self.tag2CurrentSeleccionList.append(model.id)
                
                let view = OrderManagerItem(
                    id: model.id,
                    name: model.name,
                    preSelectID: self.$tag2PreSelctedItemID
                ){ id, name in
                    /// change name to selected TYPE
                    self._tag2 = name
                    self.tag2SelctedItemID = nil
                    self.tag2SelctedItemID = id
                }
                
                self.tag2Results.appendChild(view)
            }
            
            self.tag1ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.tag2ResultsView.hidden(false)
            
        }
    }
    
    func searchPostalCode(_ currentSettlement: String? = nil){
        
        let code = searchZipCodeString.purgeSpaces
        
        if code.count < 4 {
            showError(.invalidField, "Ingrese un codigo postal minimo de cuatro digitos")
            return
        }
        
        guard let country = Countries(rawValue: _country), country == .mexico else {
            showError(.invalidField, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
            return
        }
        
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
                 showError(.generalError, .unexpenctedMissingPayload)
                 return
             }
             
            if data.isEmpty {
                showError(.generalError, "No se localizo información, intente unn codigo nuevo o un ingreso manual.")
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
            
            var itemsRrefrence: [String:PostalCodesMexicoItem] = [:]
            
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
            
            self._colony = ""
            
            if let currentSettlement {
                
                var purgedParts: [String] = []
                
                let ignoreList = ["de","la","los","las", "del", "el"]
                
                // los olivos de mamá
                let parts = currentSettlement.pseudo.purgeSpaces.explode(" ")
                
                // olivos mama
                parts.forEach { part in
                    if ignoreList.contains(part) {
                        return
                    }
                    purgedParts.append(part)
                }
                
                /// Parse Items, each item is a settelment
                items.forEach { item in
                    
                    let purgedItem = item.pseudo.purgeSpaces
                    
                    /// Purged parts of the current settment that i have EG: ["olivos", ["mama"]]
                    purgedParts.forEach { purgedPart in
                        if purgedItem.contains(purgedPart) {
                            guard let code = itemsRrefrence[item] else {
                                return
                            }
                            self._colony = "\(code.settlementType) \(code.settlement)"
                        }
                    }
                }
            }
            
            self._state = state.description
            
            self._city = codes.first?.city ?? ""
            
            self._zip = code
            
            self.foundAddressByZipCode = true
            
            self.streetResultField.select()
            
        }
    }
    
    func addCharge() {
                
        var socIds: [UUID] = []
        
        charges.forEach { charge in
            
            guard charge.type == .service else {
                return
            }
            
            guard let id = charge.id else {
                return
            }
            
            socIds.append(id)
        }
        
        let addChargeFormView = AddChargeFormView(
            accountId: custAcct.id,
            allowManualCharges: true,
            allowWarrantyCharges: true,
            socCanLoadAction: true,
            costType: custAcct.costType,
            currentSOCMasters: socIds
        ) { pocid, isWarenty, internalWarenty in
            
            var selectedInventoryIDs: [UUID] = []
            
            self.charges.forEach { item in
                selectedInventoryIDs.append(contentsOf: item.ids)
            }
            
            let view = ConfirmProductView(
                accountId: self.custAcct.id,
                costType: self.custAcct.costType,
                pocid: pocid,
                selectedInventoryIDs: selectedInventoryIDs
            ) { poc, price, costType, units, items, storeid, isWarenty, internalWarenty, generateRepositionOrder, soldObjectFrom in
                
                let _poc: ChargeObject = .init(
                    refid: .init(),
                    id: poc.id,
                    fiscCode: poc.fiscCode,
                    fiscUnit: poc.fiscUnit,
                    code: poc.upc,
                    units: units,
                    price: price,
                    description: "\(poc.brand) \(poc.model) \(poc.name)",
                    type: .product,
                    cost: poc.cost,
                    productionTime: 0,
                    ids: items.map{ $0.id },
                    saleAction: [],
                    serviceAction: [],
                    isWarenty: isWarenty,
                    internalWarenty: internalWarenty,
                    generateRepositionOrder: generateRepositionOrder
                )
                
                self.charges.append(_poc)
                
                let id = _poc.refid
                
                let currentUnits = items.count.toFloat.toCents
                
                if currentUnits > 0 {
                    
                    let tr = OldChargeTrRow(
                        preCharge: true,
                        isCharge: true,
                        id: id,
                        name: "\(poc.brand) \(poc.model) \(poc.name)",
                        cuant: units,
                        price: price,
                        puerchaseOrder: (units / 100) != items.map{ $0.id }.count
                    ) { viewId in
                        
                        if let tf = self.payChargeRef[viewId] {
                            tf.remove()
                        }
                        
                        var _charges: [ChargeObject] = []
                        
                        self.charges.forEach { charge in
                            
                            if charge.refid == viewId {
                                return
                            }
                            
                            _charges.append(charge)
                        }
                        
                        self.charges = _charges
                        
                        self.calcBalance()
                        
                    }
                    .color(.gray)
                    
                    self.payChargeRef[tr.viewId] = tr
                    
                    self.chargesTable.appendChild(tr)
                    
                }
                
                self.calcBalance()
                
            }
            
            self.appendChild(view)
            
        }
        addSoc: { soc, codeType, isWarenty, internalWarenty in
            
            self.charges.append(soc)
            
            let id = soc.refid
            
            var price = soc.price
            
            if codeType == .adjustment{
                price = (price * -1)
            }
            
            let tr = OldChargeTrRow(
                preCharge: true,
                isCharge: true,
                id: id,
                name: soc.description,
                cuant: soc.units,
                price: price,
                puerchaseOrder: false
            ) {viewId in
                
                if let tf = self.payChargeRef[viewId] {
                    tf.remove()
                }
                
                var _charges: [ChargeObject] = []
                
                self.charges.forEach { charge in
                    
                    if charge.refid == id {
                        return
                    }
                    
                    _charges.append(charge)
                }
                
                self.charges = _charges
                
                print(_charges)
                
                self.calcBalance()
                
            }
            .color(.gray)
            
            self.payChargeRef[tr.viewId] = tr
            
            self.chargesTable.appendChild(tr)
            
            self.calcBalance()
            
        }
        addItem: { item, warenty in
            
        }
        
        addToDom(addChargeFormView)
        
        addChargeFormView.searchTermInput.select()
        
    }

    func addPayment(){

                                let pv = AddPaymentFormView (
                                    accountId: self.custAcct.id,
                                    cardId: self.cardId,
                                    currentBalance: self.total
                                ) { code, description, amount, provider, lastFour, auth, uts in
                                    
                                    let refid: UUID = .init()
                                    
                                    self.payments.append(
                                        .init(
                                            refid: refid,
                                            fiscCode: code,
                                            description: description,
                                            amount: amount,
                                            reference: "",
                                            provider: provider,
                                            lastFour: lastFour,
                                            auth: auth
                                        )
                                    )
                                    
                                    let id = refid
                                
                                    let tr = OldChargeTrRow(
                                        preCharge: true,
                                        isCharge: false,
                                        id: id,
                                        name: description,
                                        cuant: 100.toInt64,
                                        price: amount,
                                        puerchaseOrder: false
                                    ) { viewId in
                                        
                                        if let tf = self.payChargeRef[viewId] {
                                            tf.remove()
                                        }
                                        
                                        var _payments: [PaymentObject] = []
                                        
                                        self.payments.forEach { pay in
                                            if pay.refid == id {
                                                return
                                            }
                                            _payments.append(pay)
                                        }
                                        
                                        self.payments = _payments
                                        
                                        print(_payments)
                                        
                                        self.calcBalance()
                                        
                                    }
                                    
                                    self.payChargeRef[tr.viewId] = tr
                                    
                                    self.chargesTable.appendChild(tr)
                                    
                                    self.calcBalance()
                                    
                                }
                                
                                self.appendChild(pv)
                                
                                if self.total <= 0 {
                                    pv.paymentDescription.select()
                                }
                                else{
                                    pv.paymentInput.select()
                                }
                                
    }

}


