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

        @State var supervisorListener: String = ""

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

        @State var groopName: String = ""

        @State var bodega: String = ""

        @State var bodegaDescr: String = ""

        @State var seccion: String = ""


        /* Refrences */

        var store: CustStore?

        @State var inventory: [CustUserInventoryObject]

        @State var bodegas: [CustStoreBodegasQuick]
        
        var stores: [CustStoreRef]
        
        var config: ConfigStore

        var fiscal: [FIAccountsQuick]

        var userRefrence: [UUID:CustUsername] = [:]

        /* INITILIZER */
        init(
            store: CustStore?,
            inventory: [CustUserInventoryObject],
            stores: [CustStoreRef],
            config: ConfigStore,
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
            
            self.isFiscalable = store?.isFiscalable ??  false
            
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
            self.orderLineBreak = config.print.lineBreak.toString
            
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
            self.posLineBreak = config.printPdv.lineBreak.toString
            
            // Int64
            self.priceModifierPdv = config.priceModifierPdv.formatMoney
            
            // Int64
            self.priceModifierOrder = config.priceModifierOrder.formatMoney
            
            // StoreOperationType
            /// internal, external
            self.operationTypeListener = ""
            
            // if is operationType is StoreOperationType.external, declares the store on witch is depended
            //  UUID?
            self.oporationStoreListener = ""
            
            ///  Locked inventory to only use inventorie associeted to store
            self.lockedInventory = config.lockedInventory

            self.sundayScheduleObjectView = .init(day: .sunday, schedule: config.schedule.sunday)
            self.mondayScheduleObjectView = .init(day: .monday, schedule: config.schedule.monday)
            self.tuesdayScheduleObjectView = .init(day: .tuesday, schedule: config.schedule.tuesday)
            self.wednesdayScheduleObjectView = .init(day: .wednesday, schedule: config.schedule.wednesday)
            self.thursdayScheduleObjectView = .init(day: .thursday, schedule: config.schedule.thursday)
            self.fridayScheduleObjectView = .init(day: .friday, schedule: config.schedule.friday)
            self.saturdayScheduleObjectView = .init(day: .saturday, schedule: config.schedule.saturday)

            self.store = store
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
            return getDate($0).formatedLong
         })
        .placeholder("Creacion de Tienda")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)

        // Int64?
        lazy var modifiedAtField = InputText(self.$modifiedAt.map{
            return getDate($0).formatedLong
         })
        .placeholder("Ultima Modificación")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
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
        .disabled(true)
        .height(31.px)
        .hidden(self.$id.map{ $0 == nil })

        lazy var supervisorSelect = Select(self.$supervisorListener)
        .body{
            Option("Seleccione Opcion")
                .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .hidden(self.$id.map{ $0 != nil })


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
        .disabled(self.$id.map{ $0 != nil })
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
        .disabled(true)
        .height(31.px)

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

         lazy var orderLineBreakField = InputText(self.$orderLineBreak)
        .placeholder("Prefijo Tienda")
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
        
        lazy var groopNameField = InputText(self.$groopName)
        .placeholder("Nombre del grupo")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var bodegaField = InputText(self.$bodega)
        .placeholder("Nombre de la bodega")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        
        lazy var bodegaDescrField = InputText(self.$bodegaDescr)
        .placeholder("Descripcion de la bodega")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        
        lazy var seccionField = InputText(self.$seccion)
        .placeholder("Nombre de la seccion")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        
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
                    /*  Info basica  y mapa  */
                    Div{

                        Div{
                            Div{

                                H2("Información de la empresa")
                                .color(.darkGoldenRod)

                                Div().clear(.both).height(3.px)

                                // Nombre de la tienda // mainStoreToggle
                                Div{
                                    
                                    Div {

                                        Div("Nombre de la tienda")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.storeNameField

                                    }
                                    .custom("width", "calc(100% - 70px)")
                                    .float(.left)

                                    Div{

                                        Div("Matriz")
                                        .class(.oneLineText)
                                        
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

                                // telephone / mobile
                                Div{

                                    Div{

                                        Div("Telefono")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.telephoneField

                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{

                                        Div("Movil")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.mobileField
                                        
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                // correo / Supervisor
                                Div{

                                    Div{

                                        Div("Correo Electronico")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.emailField

                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{

                                        Div("Supervisor")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.supervisorField

                                        self.supervisorSelect
                                        
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                H2("Direccion Fisica")
                                .color(.darkGoldenRod)

                                Div().clear(.both).height(3.px)

                                // Calle y nuemro

                                Div("Calle y numero")
                                .class(.oneLineText)
                                
                                Div().clear(.both).height(3.px)

                                self.streetField

                                Div().clear(.both).height(7.px)

                                // colonia  / cuidad
                                Div{

                                    Div{

                                        Div("Colonia")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.colonyField

                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{

                                        Div("Cuidad")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.cityField
                                        
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                // colonia  / cuidad
                                Div{

                                    Div{

                                        Div("Estado")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.stateField

                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{

                                        Div("Codigo Postal")
                                        .class(.oneLineText)
                                        
                                        Div().clear(.both).height(3.px)

                                        self.zipField
                                        
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                // Pais

                                Div("Pais")
                                .class(.oneLineText)
                                
                                Div().clear(.both).height(3.px)

                                self.countryField

                                Div().clear(.both).height(7.px)

                            }
                            .margin(all: 3.px)
                        }
                        .width(25.percent)
                        .float(.left)

                        Div{

                            Div{

                                Div {
                                    Div("🗺️ Cargar Map")
                                    .class(.uibtn)
                                    .float(.right)
                                    .onClick {
                                        self.searchMap()
                                    }
                                    H2("Mapa")
                                }

                                Div().clear(.both).height(3.px)

                                Div{
                                    
                                    Table().noResult(label: #"🗺️ Agregue direccion y  "Cargue mapa" para ver el mapa y ajustar la ubicación"#)
                                    .hidden( self.$location.map{ $0 != nil})

                                    Div()
                                    .id(.init("mapkitjs"))
                                    .hidden( self.$location.map{ $0 == nil})
                                    .height(100.percent)
                                }
                                .custom("height", "calc(100% - 32px)")

                            }
                            .custom("height", "calc(100% - 6px)")
                            .margin(all: 3.px)
                            
                        }
                        .width(75.percent)
                        .height(500.px)
                        .float(.left)

                    }

                    Div().clear(.both).height(3.px)

                    Div{
                        // Información adicional
                        Div{

                            H2("Información adicional")
                            .color(.darkGoldenRod)

                            Div().clear(.both).height(3.px)

                            // creado  / modificado
                            Div{

                                Div{

                                    Div("Fecha de creacion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.createdAtField

                                }
                                .width(50.percent)
                                .float(.left)

                                Div{

                                    Div("Ultima Modificacion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.modifiedAtField
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            // balance / puede facturar
                            Div{

                                Div{

                                    Div("Balance")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    self.balanceField

                                }
                                .width(50.percent)
                                .float(.left)

                                Div{

                                    Div("Prefijo")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.storePrefixField
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            Div{

                                Div("Tienda Publica")
                                .marginRight(7.px)
                                .fontSize(26.px)
                                .float(.left)
                                
                                self.isPublicToggle
                                .marginRight(7.px)
                                .float(.right)

                                Div().clear(.both)
                            }
                            .marginBottom(7.px)

                            Div{

                                Div("Puede Facturar")
                                .class(.oneLineText)
                                .marginRight(7.px)
                                .fontSize(26.px)
                                .float(.left)
                                
                                self.isFiscalableToggle
                                .marginRight(7.px)
                                .float(.right)

                                Div().clear(.both)
                                
                            }
                            .marginBottom(7.px)

                            Div{

                                Div("Inventario Bloqueado")
                                .class(.oneLineText)
                                .marginRight(7.px)
                                .fontSize(26.px)
                                .float(.left)
                                
                                self.lockedInventoryToggle
                                .marginRight(7.px)
                                .float(.right)

                                Div().clear(.both)
                                
                            }
                            .marginBottom(7.px)

                            Div{

                                Div("Perfil fiscal por defecto")
                                .class(.oneLineText)
                                
                                Div().clear(.both).height(3.px)

                                self.fiscalProfileSelect

                            }
                            .marginBottom(7.px)

                            // status
                            Div{

                                Div{

                                    Div("Status")
                                    .class(.oneLineText)
                                    .fontSize(26.px)
                                    .float(.left)

                                }
                                .width(50.percent)
                                .float(.left)

                                Div{

                                    self.statusSelect
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                        }
                        .width(25.percent)
                        .float(.left)

                        // Impresiones 
                        Div{

                            Div().height(30.px)
                            
                            // Tipo de  Operacion
                            Div{

                                Div{

                                    Div("Tipo de Operacion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.operationTypeSelect

                                }
                                .width(50.percent)
                                .float(.left)

                                Div{

                                    Div("Tienda de Operaciones")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.oporationStoreSelect
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            H2("Impresion de Ordenes")
                            .color(.darkGoldenRod)

                            Div().clear(.both).height(3.px)

                            Div{

                                Div{

                                    Div("Boton de Impresion")
                                    .class(.oneLineText)
                                    .marginRight(7.px)
                                    
                                    self.orderButtonSelect

                                }
                                .width(50.percent)
                                .align(.left)
                                .float(.left)

                                Div{

                                    Div("Opcion de Impresion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.orderDocumentSelect
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            Div{

                                Div{

                                    Div("Salto de impresion")
                                    .class(.oneLineText)
                                    .marginRight(7.px)
                                    
                                    self.orderLineBreakField

                                }
                                .width(50.percent)
                                .align(.left)
                                .float(.left)

                                Div{

                                    Div("Opcion de Impresion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.orderImageSelect
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            H2("Impresion de PDV")
                            .color(.darkGoldenRod)

                            Div().clear(.both).height(3.px)

                            Div{

                                Div{

                                    Div("Boton de Impresion")
                                    .class(.oneLineText)
                                    .marginRight(7.px)
                                    
                                    self.posButtonSelect

                                }
                                .width(50.percent)
                                .align(.left)
                                .float(.left)

                                Div{

                                    Div("Opcion de Impresion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.posDocumentSelect
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            Div{

                                Div{

                                    Div("Salto de impresion")
                                    .class(.oneLineText)
                                    .marginRight(7.px)
                                    
                                    self.posLineBreakField
                                    
                                }
                                .width(50.percent)
                                .align(.left)
                                .float(.left)

                                Div{

                                    Div("Opcion de Impresion")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.posImageSelect
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                        }
                        .width(25.percent)
                        .float(.left)
                        /// mas config y bodegas 
                        Div{
                            Div{
                                H2("Modificadores de Precios")
                                .color(.darkGoldenRod)
                            }.class(.oneLineText)
                            
                            Div().clear(.both).height(3.px)

                            Div{

                                Div{

                                    Div("Precio en Orden")
                                    .class(.oneLineText)
                                    .marginRight(7.px)
                                    
                                    self.priceModifierOrderField

                                }
                                .width(50.percent)
                                .align(.left)
                                .float(.left)

                                Div{

                                    Div("Precio en Mostrador")
                                    .class(.oneLineText)
                                    
                                    Div().clear(.both).height(3.px)

                                    self.priceModifierPdvField
                                    
                                }
                                .width(50.percent)
                                .float(.left)

                                Div().clear(.both)

                            }
                            .marginBottom(7.px)

                            H2("Bodegas")
                            .color(.darkGoldenRod)

                            Div().clear(.both).height(3.px)

                            Div{
                                Div{
                                    Table().noResult(label: "🪑 No hay bodegas")
                                    .hidden(self.$bodegas.map{ !$0.isEmpty })

                                    ForEach(self.$bodegas) { item in
                                        Div(item.name)
                                        .custom("width", "calc(100% - 14px)")
                                        .class(.uibtnLargeOrange)
                                        .onClick {

                                        }
                                    }
                                    .hidden(self.$bodegas.map{ $0.isEmpty })

                                }
                                .custom("height", "calc(100% - 6px)")
                                .overflow(.auto)
                                .padding(all: 3.px)
                            }
                            .class(.roundDarkBlue)
                            .height(210.px)
                            .hidden(self.$id != nil)

                            Div{

                                Div{

                                    Div{
                                        Div("Nombre del Equipo (Grupo)")
                                        .class(.oneLineText)
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{
                                        self.groopNameField
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                Div{

                                    Div{
                                        Div("Nombre de la Bodega")
                                        .class(.oneLineText)
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{
                                        self.bodegaField
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                Div{

                                    Div{
                                        Div("Descripción de la bodega")
                                        .class(.oneLineText)
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{
                                        self.bodegaDescrField
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)

                                Div{

                                    Div{
                                        Div("Nombre de la seccion")
                                        .class(.oneLineText)
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div{
                                        self.seccionField
                                    }
                                    .width(50.percent)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .marginBottom(7.px)
                            }
                            .class(.roundDarkBlue)
                            .height(210.px)
                            .hidden(self.$id == nil)

                            Div("+ Agregar Bodega")
                            .custom("width", "calc(100% - 14px)")
                            .class(.uibtnLargeOrange)
                            .align(.center)

                        }
                        .width(25.percent)
                        .float(.left)

                        // Activos de la tienda
                        Div{
                            Div{

                                H2("Activos de la tienda")
                                .color(.darkGoldenRod)

                                Div().clear(.both).height(3.px)

                                Div{
                                    Div{

                                        Table().noResult(label: "🪑 No hay activos")
                                        .hidden(self.$inventory.map{ !$0.isEmpty })

                                        ForEach(self.$inventory) { item in
                                            H2("hola")
                                        }
                                        .hidden(self.$inventory.map{ $0.isEmpty })

                                    }
                                    .custom("height", "calc(100% - 6px)")
                                    .overflow(.auto)
                                    .padding(all: 3.px)
                                }
                                .class(.roundDarkBlue)
                                .height(300.px)

                                Div("+ Agregar Activo")
                                .custom("width", "calc(100% - 14px)")
                                .class(.uibtnLargeOrange)
                                .align(.center)

                            }
                            .margin(all: 3.px)
                        }
                        .width(25.percent)
                        .float(.left)

                    }

                    Div().clear(.both).height(3.px)

                    Div {

                        H2("Horario")
                        .color(.darkGoldenRod)

                        Div().clear(.both).height(3.px)
                        
                        Div{

                            self.sundayScheduleObjectView

                            Div().clear(.both).height(3.px)

                            self.mondayScheduleObjectView

                            Div().clear(.both).height(3.px)

                            self.tuesdayScheduleObjectView

                            Div().clear(.both).height(3.px)

                            self.wednesdayScheduleObjectView

                        }
                        .width(50.percent)
                        .float(.left)

                        Div{

                            self.thursdayScheduleObjectView

                            Div().clear(.both).height(3.px)

                            self.fridayScheduleObjectView

                            Div().clear(.both).height(3.px)

                            self.saturdayScheduleObjectView


                        }
                        .width(50.percent)
                        .float(.left)
                            
                    }
                    .width(50.percent)
                    .float(.left)

                }
                .custom("height", "calc(100% - 82px)")
                .overflow(.auto)
                
                Div{
                    Div(self.$id.map{ $0 != nil ? "Guardar Cambios" : "Crear Tienda" })
                    .class(.uibtnLargeOrange)
                }
                .align(.right)

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
            else {

                getUsers(storeid: nil, onlyActive: true) { users in

                    self.userRefrence = Dictionary(uniqueKeysWithValues: users.map{ ($0.id, $0) })

                    users.forEach{ user in
                        self.supervisorSelect.appendChild(
                            Option(user.username)
                                .value(user.id.uuidString)
                        )
                    }
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
  
            CustStorePrintDocumentImage.allCases.forEach { item in
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

            GeneralStatus.allCases.forEach { item in

                if item != .active  && item != .suspended {
                    return
                }

                statusSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            stores.forEach{ item in

                if store?.id == item.id {
                    return
                }

                oporationStoreSelect.appendChild(
                    Option(item.name)
                    .value(item.id.uuidString)
                )
            }

            self.fiscalProfileListener = store?.fiscal?.uuidString ?? ""
            self.statusListener = store?.status.rawValue ?? GeneralStatus.active.rawValue
            self.orderButtonListener = config.print.button.rawValue
            self.orderDocumentListener = config.print.document.rawValue
            self.orderImageListener = config.print.image.rawValue
            self.orderImageListener = config.print.image.rawValue
            self.posButtonListener = config.printPdv.button.rawValue
            self.posDocumentListener = config.printPdv.document.rawValue
            self.posImageListener = config.printPdv.image.rawValue
            self.operationTypeListener = config.operationType.rawValue
            self.oporationStoreListener = config.operationStore?.uuidString ?? ""

            $supervisorListener.listen {

                guard let userId = UUID(uuidString: $0) else {
                    return
                }

                guard let selectedUser = self.userRefrence[userId] else {
                    return
                }

                self.supervisorId = userId

                self.supervisor =  selectedUser

            }

        }

        override func didAddToDOM() {
            super.didAddToDOM()

            if let location {
                _ = JSObject.global.activateMap!("mapkitjs", location, WebApp.shared.window.location.hostname == "localhost" ?  "\(WebApp.shared.window.location.hostname):\(WebApp.shared.window.location.port)" : WebApp.shared.window.location.hostname, stores, JSClosure { jresp in

                    guard jresp.count == 2 else {
                        return .undefined
                    }

                    guard let  lat = jresp[0].number else {
                        return .undefined
                    }

                    guard let  lon = jresp[1].number else {
                        return .undefined
                    }

                    self.location = .init(latitud: lat, longitud: lon)

                    return .undefined
                    
                })
            }

        }
    
        func searchMap(){
            
            _ = JSObject.global.searchMap!(
                "mapkitjs",
                WebApp.shared.window.location.hostname == "localhost" ?  "\(WebApp.shared.window.location.hostname):\(WebApp.shared.window.location.port)" : WebApp.shared.window.location.hostname,
                street,
                city,
                state,
                zip,
                country,
                JSClosure { jresp in

                guard jresp.count == 2 else {
                    return .undefined
                }

                guard let  lat = jresp[0].number else {
                    return .undefined
                }

                guard let  lon = jresp[1].number else {
                    return .undefined
                }

                self.location = .init(latitud: lat, longitud: lon)

                return .undefined
                
            })
        }

        func saveStore() {

            if storePrefix.isEmpty {
                showError(.campoRequerido, "")
                storePrefixField.select()
                return
            }

            if storeName.isEmpty {
                showError(.campoRequerido, "")
                storeNameField.select()
                return
            }

            if telephone.isEmpty {
                showError(.campoRequerido, "")
                telephoneField.select()
                return
            }

            if email.isEmpty {
                showError(.campoRequerido, "")
                emailField.select()
                return
            }

            if street.isEmpty {
                showError(.campoRequerido, "")
                streetField.select()
                return
            }

            if colony.isEmpty {
                showError(.campoRequerido, "")
                colonyField.select()
                return
            }

            if city.isEmpty {
                showError(.campoRequerido, "")
                cityField.select()
                return
            }

            if state.isEmpty {
                showError(.campoRequerido, "")
                stateField.select()
                return
            }

            if country.isEmpty {
                showError(.campoRequerido, "")
                countryField.select()
                return
            }

            if zip.isEmpty {
                showError(.campoRequerido, "")
                zipField.select()
                return
            }

            if isFiscalable {
                if fiscalProfile == nil {
                    showError(.campoRequerido, "")
                    return
                }
            }

            guard let location else {
                showError(.campoRequerido, "")
                return
            }

            guard let button = CustStorePrintButtonType(rawValue: orderButtonListener) else {
                showError(.campoRequerido, "")
                return
            }

            guard let document = CustStorePrintButtonOptions(rawValue: orderDocumentListener) else {
                showError(.campoRequerido, "")
                return
            }

            guard let image = CustStorePrintDocumentImage(rawValue: orderImageListener) else {
                showError(.campoRequerido, "")
                return
            }

            guard let lineBreak = Int(orderLineBreak) else {
                showError(.campoRequerido, "")
                return
            }

            guard let buttonPdv = CustStorePrintButtonType(rawValue: posButtonListener) else {
                showError(.campoRequerido, "")
                return
            }

            guard let documentPdv = CustStorePrintButtonOptions(rawValue: posDocumentListener) else {
                showError(.campoRequerido, "")
                return
            }

            guard let imagePdv = CustStorePrintDocumentImage(rawValue: posImageListener) else {
                showError(.campoRequerido, "")
                return
            }

            guard let lineBreakPdv = Int(posLineBreak) else {
                showError(.campoRequerido, "")
                return
            }

            guard let priceModifierPdv = Double(priceModifierPdv) else {
                showError(.campoRequerido, "")
                return
            }

            guard let priceModifierOrder = Double(priceModifierOrder) else {
                showError(.campoRequerido, "")
                return
            }

            guard let operationType = StoreOperationType(rawValue: operationTypeListener) else {
                showError(.campoRequerido, "")
                return
            }

            let operationStore = UUID(uuidString: oporationStoreListener)
            
            if operationType == .external {
                if operationStore == nil {
                    showError(.campoRequerido, "")
                    return
                }
            }

            let sunday: ConfigStoreScheduleObject = .init(
                workDay: sundayScheduleObjectView.workDay,
                type: sundayScheduleObjectView.type,
                start: Int(sundayScheduleObjectView.start) ?? 0,
                lucheStart: Int(sundayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(sundayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(sundayScheduleObjectView.end) ?? 0
            )

            let monday: ConfigStoreScheduleObject = .init(
                workDay: mondayScheduleObjectView.workDay,
                type: mondayScheduleObjectView.type,
                start: Int(mondayScheduleObjectView.start) ?? 0,
                lucheStart: Int(mondayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(mondayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(mondayScheduleObjectView.end) ?? 0
            )

            let tuesday: ConfigStoreScheduleObject = .init(
                workDay: tuesdayScheduleObjectView.workDay,
                type: tuesdayScheduleObjectView.type,
                start: Int(tuesdayScheduleObjectView.start) ?? 0,
                lucheStart: Int(tuesdayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(tuesdayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(tuesdayScheduleObjectView.end) ?? 0
            )

            let wednesday: ConfigStoreScheduleObject = .init(
                workDay: wednesdayScheduleObjectView.workDay,
                type: wednesdayScheduleObjectView.type,
                start: Int(wednesdayScheduleObjectView.start) ?? 0,
                lucheStart: Int(wednesdayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(wednesdayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(wednesdayScheduleObjectView.end) ?? 0
            )

            let thursday: ConfigStoreScheduleObject = .init(
                workDay: thursdayScheduleObjectView.workDay,
                type: thursdayScheduleObjectView.type,
                start: Int(thursdayScheduleObjectView.start) ?? 0,
                lucheStart: Int(thursdayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(thursdayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(thursdayScheduleObjectView.end) ?? 0
            )

            let friday: ConfigStoreScheduleObject = .init(
                workDay: fridayScheduleObjectView.workDay,
                type: fridayScheduleObjectView.type,
                start: Int(fridayScheduleObjectView.start) ?? 0,
                lucheStart: Int(fridayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(fridayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(fridayScheduleObjectView.end) ?? 0
            )

            let saturday: ConfigStoreScheduleObject = .init(
                workDay: saturdayScheduleObjectView.workDay,
                type: saturdayScheduleObjectView.type,
                start: Int(saturdayScheduleObjectView.start) ?? 0,
                lucheStart: Int(saturdayScheduleObjectView.lucheStart) ?? 0,
                lucheEnd: Int(saturdayScheduleObjectView.lucheEnd) ?? 0,
                end: Int(saturdayScheduleObjectView.end) ?? 0
            )

            loadingView(show: true)

            switch sunday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Domingo. \(error)")
                return
            case .valid:
                break
            }

            switch monday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Lunes. \(error)")
                return
            case .valid:
                break
            }

            switch tuesday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Martes. \(error)")
                return
            case .valid:
                break
            }

            switch wednesday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Miercoles. \(error)")
                return
            case .valid:
                break
            }

            switch thursday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Jueves. \(error)")
                return
            case .valid:
                break
            }

            switch friday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Viernes. \(error)")
                return
            case .valid:
                break
            }

            switch saturday.validate()  {
            case .invalid(let error):
                showError(.errorGeneral, "Error de configuracion de horario: Sabado. \(error)")
                return
            case .valid:
                break
            }

            if let storeId = id {

                API.custAPIV1.saveStore(
                    storeId: storeId,
                    name: storeName,
                    telephone: telephone,
                    mobile: mobile,
                    email: email,
                    street: street,
                    colony: colony,
                    city: city,
                    state: state,
                    country: country,
                    zip: zip,
                    isPublic: isPublic,
                    isFiscalable: isFiscalable,
                    fiscalProfileId: UUID(uuidString: fiscalProfileListener),
                    fiscalProfileName: fiscalProfileSelect.text,
                    lat: location.latitud,
                    lon: location.longitud,
                    button: button,
                    document: document,
                    image: image,
                    lineBreak: lineBreak,
                    buttonPdv: buttonPdv,
                    documentPdv: documentPdv,
                    imagePdv: imagePdv,
                    lineBreakPdv: lineBreakPdv,
                    priceModifierPdv: priceModifierPdv,
                    priceModifierOrder: priceModifierOrder,
                    operationType: operationType,
                    operationStore: operationStore,
                    sunday: sunday,
                    monday: monday,
                    tuesday: tuesday,
                    wednesday: wednesday,
                    thursday: thursday,
                    friday: friday,
                    saturday: saturday, 
                    lockedInventory: lockedInventory
                ) { resp in

                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                }

            }
            else {

            }
            

        }

        //XD

    }
}
