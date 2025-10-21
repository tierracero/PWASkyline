//
//  Tools+SystemSettings+UserStoreConfiguration+StoreDetailView.swift
//
//
//  Created by Victor Cantu on 6/8/24.
//

import Foundation 
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class StoreDetailView: Div {
        
        override class var name: String { "div" }
        
        /* MARK: Store details */

        @State var id: UUID?
        
        @State var createdAt: Int64?
        
        @State var modifiedAt: Int64?
        
        @State var storeName: String
        
        var mainStore: Bool
        
        /// UUID
        var supervisorId: UUID?
        
        @State var supervisor: CustUsername?

        @State var telephone: String
        
        @State var mobile: String
        
        @State var email: String
        
        @State var street: String
        
        @State var colony: String
        
        @State var city: String
        
        @State var state: String
        
        @State var country: String
        
        @State var zip: String
        
        @State var isFiscalable: Bool
        
        @State var isPublic: Bool
        
        ///  UUID?
        @State var fiscalProfileListener: String
        
        @State var location: GeoLocation?

        @State var balance: String
        
        @State var storePrefix: String
        
        /// GeneralStatus
        /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
        @State var statusListener: String

        /* MARK: ConfigStore */
        	
        /// Defiene printing configuration of store ORDERS
        // public var print: ConfigStorePrinting
        // CustStorePrintButtonType
        // direct, multiple
        @State var orderButtonListener: String
        
        // CustStorePrintButtonOptions
        // letter, halfLetter, miniprinter, pdf
        @State var orderDocumentListener: String

        // CustStorePrintDocumentImage
        //  none, pinpattern, location
        @State var orderImageListener:  String
        
        // Int
        @State var orderLineBreak:  String
        
        // Defiene printing configuration of store SALE POINT
        // public var printPdv: ConfigStorePrinting
        // CustStorePrintButtonType
        // direct, multiple
        @State var posButtonListener: String
        
        // letter, halfLetter, miniprinter, pdf
        @State var posDocumentListener: String

        // CustStorePrintDocumentImage
        //  none, pinpattern, location
        @State var posImageListener:  String

        // Int        
        @State var posLineBreak: String
        
        // Int64
        @State var priceModifierPdv: String
        
        // Int64
        @State var priceModifierOrder: String
        
        // StoreOperationType
        /// internal, external
        @State var operationTypeListener: String
        
        // if is operationType is StoreOperationType.external, declares the store on witch is depended
        //  UUID?
        @State var oporationStoreListener: String
        
        ///  Locked inventory to only use inventorie associeted to store
        @State var lockedInventory: Bool

        /* Refrences */

        var store: CustStore?

        @State var mails: [String]

        @State var inventory: [CustUserInventoryObject]

        var stores: [CustStoreRef]
        
        var config: ConfigStore?

        var fiscal: [FIAccountsQuick]

        @State var bodegas: [CustStoreBodegasQuick]


        /* INITILIZER */
        init(
            store: CustStore?,
            mails: [String],
            inventory: [CustUserInventoryObject],
            stores: [CustStoreRef],
            config: ConfigStore?,
            fiscal: [FIAccountsQuick],
            bodegas: [CustStoreBodegasQuick]
        ) {

            self.id = store?.id
            
            self.createdAt = store?.createdAt
            
            self.modifiedAt = store?.modifiedAt
            
            self.storeName = store?.name ?? ""
            
            self.mainStore = store?.mainStore ?? false
            
            /// CustUsername.id
            self.supervisorId = store?.custUsername

            /// CustUsername
            self.supervisor = nil

            self.telephone = store?.telephone ?? ""
            
            self.mobile = store?.mobile ?? ""
            
            self.email = store?.email ?? ""
            
            self.street = store?.street ?? ""
            
            self.colony = store?.colony ?? ""
            
            self.city = store?.city ?? ""
            
            self.state = store?.state ?? ""
            
            self.country = store?.country ?? ""
            
            self.zip = store?.zip ?? ""
            
            self.isFiscalable = store?.isFiscalable ?? false
            
            self.isPublic = store?.isPublic ?? false
            
            ///  UUID?
            self.fiscalProfileListener = ""
            
            if let lat = store?.lat, let lon = store?.lon  {
                self.location = try? .init(latitud: lat, longitud: lon)
            }

            self.balance = store?.balance.formatMoney ?? "0"
            
            self.storePrefix = store?.storePrefix ?? ""
            
            /// GeneralStatus
            /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
            self.statusListener = GeneralStatus.active.rawValue

            /* MARK: ConfigStore */
                
            /// Defiene printing configuration of store ORDERS
            // public var print: ConfigStorePrinting
            // CustStorePrintButtonType
            // direct, multiple
            self.orderButtonListener = ""
            
            // CustStorePrintButtonOptions
            // letter, halfLetter, miniprinter, pdf
            self.orderDocumentListener = ""

            // CustStorePrintDocumentImage
            //  none, pinpattern, location
            self.orderImageListener = ""
            
            // Int
            self.orderLineBreak = config?.print.lineBreak.toString ?? ""
            
            // Defiene printing configuration of store SALE POINT
            // public var printPdv: ConfigStorePrinting
            // CustStorePrintButtonType
            // direct, multiple
            self.posButtonListener = ""
            
            // letter, halfLetter, miniprinter, pdf
            self.posDocumentListener = ""

            // CustStorePrintDocumentImage
            //  none, pinpattern, location
            self.posImageListener = ""

            // Int        
            self.posLineBreak = config?.printPdv.lineBreak.toString ?? ""
            
            // Int64
            self.priceModifierPdv = config?.priceModifierPdv.formatMoney ?? "0"
            
            // Int64
            self.priceModifierOrder = config?.priceModifierOrder.formatMoney ?? "0"
            
            // StoreOperationType
            /// internal, external
            self.operationTypeListener = ""
            
            // if is operationType is StoreOperationType.external, declares the store on witch is depended
            //  UUID?
            self.oporationStoreListener = ""
            
            ///  Locked inventory to only use inventorie associeted to store
            self.lockedInventory = config?.lockedInventory ?? false

            if let config {
                self.sundayScheduleObjectView = .init(day: .sunday, schedule: config.schedule.sunday)
                self.mondayScheduleObjectView = .init(day: .monday, schedule: config.schedule.monday)
                self.tuesdayScheduleObjectView = .init(day: .tuesday, schedule: config.schedule.tuesday)
                self.wednesdayScheduleObjectView = .init(day: .wednesday, schedule: config.schedule.wednesday)
                self.thursdayScheduleObjectView = .init(day: .thursday, schedule: config.schedule.thursday)
                self.fridayScheduleObjectView = .init(day: .friday, schedule: config.schedule.friday)
                self.saturdayScheduleObjectView = .init(day: .saturday, schedule: config.schedule.saturday)
            }
            else {
                self.sundayScheduleObjectView = .init(day: .sunday, schedule: .init())
                self.mondayScheduleObjectView = .init(day: .monday, schedule: .init())
                self.tuesdayScheduleObjectView = .init(day: .tuesday, schedule: .init())
                self.wednesdayScheduleObjectView = .init(day: .wednesday, schedule: .init())
                self.thursdayScheduleObjectView = .init(day: .thursday, schedule: .init())
                self.fridayScheduleObjectView = .init(day: .friday, schedule: .init())
                self.saturdayScheduleObjectView = .init(day: .saturday, schedule: .init())
            }

            self.store = store
            self.mails = mails
            self.inventory = inventory
            self.stores = stores
            self.config = config
            self.fiscal = fiscal
            self.bodegas = bodegas

            super.init()

        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        /* MARK: Inputs */

        // Int64?
        lazy var createdAtField = InputText(self.$createdAt.map{
            if let uts = $0 {
                return getDate(uts).formatedLong
            }
            return ""
         })
        .placeholder("Creacion de Tienda")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // Int64?
        lazy var modifiedAtField = InputText(self.$modifiedAt.map{
            if let uts = $0 {
                return getDate(uts).formatedLong
            }
            return ""
         })
        .placeholder("Ultima Modificación")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var storeNameField = InputText(self.$storeName)
        .placeholder("Nombre de la sucurdsal")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .onBlur {
            self.storeName = self.storeName.capitalizingFirstLetters()
        }

        lazy var mainStoreToggle = InputCheckbox().toggle(self.mainStore, true)
        .opacity(0.5)
        
        // Based on username list
        lazy var supervisorField = InputText(self.$supervisor.map{ $0?.username ?? "" })
        .placeholder("Seleccione Supervisor")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var telephoneField = InputText(self.$telephone)
        .placeholder("Telefono Fijo")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var mobileField = InputText(self.$mobile)
        .placeholder("Telefono Celular")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var emailField = InputText(self.$email)
        .placeholder("Correo de contacto")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var streetField = InputText(self.$street)
        .placeholder("Calle y numero")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var colonyField = InputText(self.$colony)
        .placeholder("Colonia")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var cityField = InputText(self.$city)
        .placeholder("Cuidad")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var stateField = InputText(self.$state)
        .placeholder("Estado")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var countryField = InputText(self.$country)
        .placeholder("Pais")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var zipField = InputText(self.$zip)
        .placeholder("Codigi Psotal")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var isFiscalableToggle = InputCheckbox().toggle(self.$isFiscalable)
                        .marginRight(7.px)

        lazy var isPublicToggle = InputCheckbox().toggle(self.$isPublic)
                        .marginRight(7.px)
            
        // based on available fiscal profiles
        lazy var fiscalProfileSelect = Select(self.$fiscalProfileListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        
        // lat
        // lon
        // location: GeoLocation 

        // READ_ONLY
        // String
        lazy var balanceField = InputText(self.$balance)
        .placeholder("Balance")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // READ_ONLY      
        // String  
        lazy var storePrefixField = InputText(self.$storePrefix)
        .placeholder("Prefijo Tienda")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // GeneralStatus.active //GeneralStatus.suspended
        lazy var statusSelect = Select(self.$statusListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // mails: [String]

        // inventory: [CustUserInventoryObject]

        // bodegas: [CustStoreBodegasQuick]

        // CustStorePrintButtonType
        lazy var orderButtonSelect = Select(self.$orderButtonListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // CustStorePrintButtonOptions
        lazy var orderDocumentSelect = Select(self.$orderDocumentListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // CustStorePrintDocumentImage
        lazy var orderImageSelect = Select(self.$orderImageListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // Str
        // CustStorePrintButtonType
        lazy var posButtonSelect = Select(self.$posButtonListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // CustStorePrintButtonOptions
        lazy var posDocumentSelect = Select(self.$posDocumentListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // CustStorePrintDocumentImage
        lazy var posImageSelect = Select(self.$posImageListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var posLineBreakField = InputText(self.$posLineBreak)
        .placeholder("Lineas de brinco en el recibo")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var priceModifierOrderField = InputText(self.$priceModifierOrder)
        .placeholder("Porcentaje de aumento en ordenes")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // String
        lazy var priceModifierPdvField = InputText(self.$priceModifierPdv)
        .placeholder("Porcentaje de aumento en PDV")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        // StoreOperationType
        lazy var operationTypeSelect = Select(self.$operationTypeListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        /// Store Select
        lazy var oporationStoreSelect = Select(self.$oporationStoreListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var lockedInventoryToggle = InputCheckbox().toggle(self.$lockedInventory)
                        .marginRight(7.px)

        /*MARK: Schedule Views*/

        var sundayScheduleObjectView: ScheduleObjectView

        var mondayScheduleObjectView: ScheduleObjectView

        var tuesdayScheduleObjectView: ScheduleObjectView

        var wednesdayScheduleObjectView: ScheduleObjectView

        var thursdayScheduleObjectView: ScheduleObjectView

        var fridayScheduleObjectView: ScheduleObjectView

        var saturdayScheduleObjectView: ScheduleObjectView

        @DOM override var body: DOM.Content {
            
            Div{
                
                /* MARK: HEADER*/
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }

                    H2(self.$storeName.map{ $0.isEmpty ? "Crear Tienda" : $0 })
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                .marginBottom(3.px)
                
                Div{
                    /*   */
                    Div{

                        Div{
                            Div{

                                H2("Informacion de la empresa")

                                Div().clear(.both).height(3.px)

                                // Nombre de la tienda // mainStoreToggle
                                Div{
                                    
                                    Div {

                                        Label("Nombre de la tienda")
                                        
                                        Div().clear(.both).height(3.px)

                                        self.storeNameField

                                    }
                                    .custom("width", "calc(100% - 70px)")
                                    .float(.left)

                                    Div{

                                        Label("Matriz")
                                        
                                        Div().clear(.both).height(3.px)

                                        self.mainStoreToggle
                                        .float(.none)
                                    }
                                    .width(70.px)
                                    .align(.right)
                                    .float(.left)
                                    
                                    Div().clear(.both)
                                }
                                .marginBottom(7.px)

                                // telephoneField
                                Div{

                                    Label("Telefono")
                                    
                                    Div().clear(.both).height(3.px)

                                    self.telephoneField

                                }
                                .marginBottom(7.px)
                            }
                            .margin(all: 3.px)
                        }
                        .width(33.percent)
                        .float(.left)

                        Div{

                            Div{

                                H2("Mapa")

                                Div().clear(.both).height(3.px)

                            }
                            .margin(all: 3.px)
                            
                        }
                        .width(67.percent)
                        .float(.left)

                    }

                    Div().clear(.both).height(3.px)

                    Div{

                    }
                }
                .custom("height", "calc(100% - 35px)")
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .height(90.percent)
            .width(90.percent)
            .padding(all: 7.px)
            .color(.white)
            .custom("left", "calc(5% - 14px)")
            .custom("top", "calc(5% - 14px)")
            
        }
        
        override func buildUI() {
            super.buildUI()

            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

            if let userId = supervisorId {
                getUserRefrence(id: .id(userId)) {user in
                    self.supervisor = user
                }
            }

            fiscal.forEach { profile in
                fiscalProfileSelect.appendChild(
                    Option("\(profile.rfc) \(profile.razon)")
                    .value(profile.id.uuidString)
                )
            }

            CustStorePrintButtonType.allCases.forEach{ item in
                orderButtonSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            CustStorePrintButtonOptions.allCases.forEach { item in
                orderImageSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            CustStorePrintButtonOptions.allCases.forEach { item in
                orderDocumentSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            CustStorePrintButtonType.allCases.forEach { item in
                posButtonSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            CustStorePrintButtonOptions.allCases.forEach { item in
                posDocumentSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            CustStorePrintDocumentImage.allCases.forEach { item in
                posImageSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            StoreOperationType.allCases.forEach { item in
                operationTypeSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            stores.forEach{ item in

                if let store, store.id == item.id {
                    return
                }

                oporationStoreSelect.appendChild(
                    Option(item.name)
                    .value(item.id.uuidString)
                )
            }
            
            if let store {
                self.fiscalProfileListener = store.fiscal?.uuidString ?? ""
                self.statusListener = store.status.rawValue
            }

            if let config {
                self.orderButtonListener = config.print.button.rawValue
                self.orderDocumentListener = config.print.document.rawValue
                self.orderImageListener = config.print.image.rawValue
                self.orderImageListener = config.print.image.rawValue
                self.posButtonListener = config.printPdv.button.rawValue
                self.posDocumentListener = config.printPdv.document.rawValue
                self.posImageListener = config.printPdv.image.rawValue
                self.operationTypeListener = config.operationType.rawValue
                self.oporationStoreListener = config.oporationStore?.uuidString ?? ""
            }

        }
    }
}

extension ToolsView.SystemSettings.UserStoreConfiguration.StoreDetailView {
    
    class ScheduleObjectView: Div {

        override class var name: String { "div" }

        let day: Weekdays

        @State var workDay: Bool

        /// followed, broken
        @State var type: CustUserProfileScheduleDayTypes

        @State var start: Int

        @State var lucheStart: Int

        @State var lucheEnd: Int

        @State var end: Int

        init(
            day: Weekdays,
            schedule: ConfigStoreScheduleObject
        ) {
            self.day = day
            self.workDay = schedule.workDay
            self.type = schedule.type
            self.start = schedule.start
            self.lucheStart = schedule.lucheStart
            self.lucheEnd = schedule.lucheEnd
            self.end = schedule.end
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            H2(self.day.documentableName)
        }


        override func buildUI() {
            super.buildUI()
            print("🟢 execute build")
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
        }

    }
}
