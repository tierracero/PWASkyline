//
//  Tools+SystemSettings+UserStoreConfiguration+UserView.swift
//
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {

    class UserView: Div {

        override class var name: String { "div" }

        let store: CustStore

        let userCard: UserCard

        let data: CustComponents.GetUserResponse

        init(
            store: CustStore,
            userCard: UserCard,
            data: CustComponents.GetUserResponse
        ) {
            self.store = store
            self.userCard = userCard
            self.data = data
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        var cats: [PanelConfigurationCatagoryItem] = []
        
        var subCats: [PanelConfigurationSubCatagoryItem] = []
        
        var atributes: [PanelConfigurationAtributeItem] = []
        
        @State var notes: [CustGeneralNotesQuick] = []
        
        @State var storeName = ""

        @State var groopName = "N/A"

        @State var supervisorName = "N/A"

        @State var userMid = ""

        /// UsernameRoles: general, supervisor, manager, gmanager, owner
        @State var roleListener: String = UsernameRoles.general.rawValue

        @State var username: String = ""

        /// Password and PIN values are intentionally never initialized from the response.
        @State var password: String = ""

        @State var passwordConfirm: String = ""

        @State var pin: String = ""

        @State var pinConfirm: String = ""

        @State var title: String = ""

        @State var firstName: String = ""

        @State var secondName: String = ""

        @State var lastName: String = ""

        @State var secondLastName: String = ""

        @State var birthDay: String = ""

        @State var birthMonth: String = ""

        @State var birthYear: String = ""

        @State var rfc: String = ""

        @State var curp: String = ""

        @State var nss: String = ""

        @State var telephone: String = ""

        @State var mobile: String = ""

        @State var email: String = ""

        @State var street: String = ""

        @State var colony: String = ""

        @State var city: String = ""

        @State var state: String = ""

        @State var country: String = ""

        @State var zip: String = ""

        @State var linkedProfile: [PanelConfigurationObjects] = []

        @State var herkListener: String = "0"

        @State var herk: Int = 0

        @State var preformanceRankListener = "1"

        @State var nick: String = ""

        @State var colorCode: String = "#000000"

        @State var sexo: String = ""

        @State var meta: String = ""

        @State var corporateMailIsActive: Bool = false

        @State var corporateMailAliases: [String] = []

        @State var productionProfile: [CustProductionProfile] = []

        @State var status: UsernameStatus = .active

        @State var isActive: Bool = true

        @State var permitionItems: [Div] = []

        @State var noteTypeListener = ""

        @State private var isProcessingUserAction = false

        lazy var firstNameField = InputText(self.$firstName)
            .placeholder("Primer nombre")

        lazy var secondNameField = InputText(self.$secondName)
            .placeholder("Segundo nombre")

        lazy var lastNameField = InputText(self.$lastName)
            .placeholder("Primer apellido")

        lazy var secondLastNameField = InputText(self.$secondLastName)
            .placeholder("Segundo apellido")

        lazy var nickField = InputText(self.$nick)
            .placeholder("Nombre corto")

        lazy var titleField = InputText(self.$title)
            .placeholder("Título o puesto")

        lazy var mobileField = InputText(self.$mobile)
            .placeholder("Teléfono móvil")

        lazy var telephoneField = InputText(self.$telephone)
            .placeholder("Teléfono fijo")

        lazy var emailField = InputEmail(self.$email)
            .placeholder("Correo alternativo")

        lazy var streetField = InputText(self.$street)
            .placeholder("Calle y número")

        lazy var colonyField = InputText(self.$colony)
            .placeholder("Colonia")

        lazy var cityField = InputText(self.$city)
            .placeholder("Ciudad")

        lazy var stateField = InputText(self.$state)
            .placeholder("Estado")

        lazy var countryField = InputText(self.$country)
            .placeholder("País")

        lazy var zipField = InputText(self.$zip)
            .placeholder("Código postal")

        lazy var birthDayField = InputText(self.$birthDay)
            .placeholder("Día")

        lazy var birthMonthField = InputText(self.$birthMonth)
            .placeholder("Mes")

        lazy var birthYearField = InputText(self.$birthYear)
            .placeholder("Año")

        lazy var rfcField = InputText(self.$rfc)
            .placeholder("RFC")

        lazy var curpField = InputText(self.$curp)
            .placeholder("CURP")

        lazy var nssField = InputText(self.$nss)
            .placeholder("NSS")

        lazy var usernameField = InputEmail(self.$username)
            .placeholder("Correo corporativo")
            .disabled(true)

        lazy var roleSelect = Select(self.$roleListener)

        lazy var genderSelect = Select(self.$sexo)

        lazy var statusToggle = InputCheckbox().toggle(self.$isActive)
        
        lazy var passwordField = InputPassword(self.$password)
            .placeholder("Nueva contraseña")

        lazy var passwordConfirmField = InputPassword(self.$passwordConfirm)
            .placeholder("Confirmar contraseña")

        lazy var pinField = InputPassword(self.$pin)
            .placeholder("Nuevo PIN")

        lazy var pinConfirmField = InputPassword(self.$pinConfirm)
            .placeholder("Confirmar PIN")

        lazy var corporateMailToggle = InputCheckbox()
            .toggle(self.$corporateMailIsActive)

        private var fullName: String {
            let values = [
                data.userData.title,
                data.userData.firstName,
                data.userData.secondName,
                data.userData.lastName,
                data.userData.secondLastName
            ].filter { !$0.isEmpty }
            return values.isEmpty ? data.userData.username : values.joined(separator: " ")
        }

        private var avatarSource: String {
            
            if !data.userData.avatar.isEmpty {
                return "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/\(data.userData.avatar)"
            }
            return "/skyline/media/default_panda.jpeg"
        }

        private var mailAliases: [String] {
            var aliases: [String] = []
            (data.relMailbox + data.userData.corporateMailAliases).forEach { alias in
                guard !alias.isEmpty, !aliases.contains(alias) else {
                    return
                }
                aliases.append(alias)
            }
            return aliases
        }

        private var scheduleDays: String {
            guard let days = data.meta?.schedule?.days, !days.isEmpty else {
                return "Sin días configurados"
            }
            let names = [
                1: "Dom",
                2: "Lun",
                3: "Mar",
                4: "Mié",
                5: "Jue",
                6: "Vie",
                7: "Sáb"
            ]
            return days.compactMap { names[$0] }.joined(separator: " · ")
        }

        private var canManageUser: Bool {
            custCatchHerk >= data.userData.herk && data.userData.status != .canceled
        }

        lazy var noteTypeSelect = Select(self.$noteTypeListener)
            .class(.textFiledBlackDarkLarge)
            .custom("margin-right","7px !important")
            .custom("font-size","16px !important")
            .custom("width","200px !important")
            .custom("height","32px !important")
            .custom("float","right !important")
            .body {
                Option("Todas")
                    .value("")
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
        @DOM override var body: DOM.Content {
            Div {
                Div {
                    Div {
                        Span("Configuración de usuario")
                            .class(Class(TCUserConfigurationClass.eyebrow))
                        H2(self.fullName)
                        Div {
                            Span(self.$userMid)
                            Span("•")
                            Span(self.$username)
                        }
                            .class(Class(TCUserConfigurationClass.headerMeta))
                    }

                    Div {

                        if self.canManageUser {
                            Button("Solicitar cancelación")
                                .class(Class(TCUserConfigurationClass.actionButton))
                                .class(Class(TCUserConfigurationClass.dangerAction))
                                .disabled(self.$isProcessingUserAction)
                                .onClick {
                                    self.preDelUser()
                                }

                            Button("Guardar cambios")
                                .class(Class(TCCrystalSurfaceClass.goodButton))
                                .class(Class(TCUserConfigurationClass.actionButton))
                                .class(Class(TCUserConfigurationClass.saveAction))
                                .disabled(self.$isProcessingUserAction)
                                .onClick {
                                    self.saveUser()
                                }
                        }

                        Img()
                            .closeButton(.subView)
                            .class(Class(TCUserConfigurationClass.close))
                            .onClick {
                                self.remove()
                            }
                    }
                        .class(Class(TCUserConfigurationClass.headerActions))
                }
                    .class(Class(TCUserConfigurationClass.header))

                Div {
                    Div {
                        Div {
                            Img()
                                .src(self.avatarSource)
                                .class(Class(TCUserConfigurationClass.avatarImage))
                            Div {
                                Span("ID")
                                Strong(self.$userMid)
                            }
                                .class(Class(TCUserConfigurationClass.avatarBadge))
                        }
                            .class(Class(TCUserConfigurationClass.avatar))

                        H3(self.fullName)
                            .class(Class(TCUserConfigurationClass.profileName))
                        Span(self.$username)
                            .class(Class(TCUserConfigurationClass.profileUsername))

                        Div {
                            Span(self.$roleListener.map { self.roleDescription($0) })
                                .class(Class(TCUserConfigurationClass.rolePill))
                            Span(self.$status.map { $0.description })
                                .class(Class(TCUserConfigurationClass.statusPill))
                        }
                            .class(Class(TCUserConfigurationClass.profilePills))

                        Div {
                            self.summaryRow("Tienda", self.$storeName)
                            self.summaryRow("Grupo", self.$groopName)
                            self.summaryRow("Supervisor", self.$supervisorName)
                            self.summaryRow("Rango operativo", self.$herk)
                            self.summaryRow("Rendimiento", self.$preformanceRankListener)
                        }
                            .class(Class(TCUserConfigurationClass.profileSummary))

                        Div {
                            Div {
                                Span("Color de identificación")
                                InputColor(self.$colorCode)
                            }
                                .class(Class(TCUserConfigurationClass.colorRow))
                        }
                            .class(Class(TCUserConfigurationClass.profileSection))

                        Div {
                            Div {
                                H3("Permisos")
                                Span("Accesos vinculados")
                            }
                                .class(Class(TCUserConfigurationClass.permissionHeader))

                            Div {
                                ForEach(self.$permitionItems) {
                                    $0
                                }

                                if custCatchHerk > self.herk {

                                    Div {
                                        Span("+")
                                            .class(Class(TCUserConfigurationClass.permissionAddIcon))

                                        Strong("Agregar Permiso")
                                    }
                                    .class(Class(TCCrystalSurfaceClass.goodButton))
                                    .attribute("role", "button")
                                    .attribute("tabindex", "0")
                                    .attribute("aria-label", "Agregar permiso")
                                    .onClick {
                                        self.addPermitToUser()
                                    }
                                    .onKeyUp { _, event in
                                        guard event.code == "Enter" || event.code == "Space" else {
                                            return
                                        }
                                        event.preventDefault()
                                        self.addPermitToUser()
                                    }

                                }

                            }
                                .class(Class(TCUserConfigurationClass.permissionList))
                        }
                            .class(Class(TCUserConfigurationClass.profileSection))
                    }
                        .class(Class(TCUserConfigurationClass.sidebar))

                    Div {
                        Div {
                            self.metric("Balance", "$\(self.data.balance.formatMoney)", "Cuenta del usuario")
                            self.metric("Tareas", self.data.tasks.count.toString, "Actividades registradas")
                            self.metric("Inventario", self.data.inventory.count.toString, "Artículos en posesión")
                            self.metric("Notas", self.data.notes.count.toString, "Seguimiento disponible")
                        }
                            .class(Class(TCUserConfigurationClass.metrics))

                        Div {

                            Div {
                                self.sectionTitle("Credenciales y acceso", "Cuenta, seguridad y correo corporativo", icon: "⚿")
                                Div {
                                    self.formField("Usuario", self.usernameField)
                                    //self.formField("Estado", self.statusToggle)

                                    Div {
                                        Label("Estado")
                                        Div {
                                            self.statusToggle
                                            Div {

                                            }
                                            .position(.absolute)
                                            .height(100.percent)
                                            .width(100.percent)
                                            .bottom(0.px)
                                            .top(0.px)
                                            .cursor(.pointer)
                                            .onClick {
                                                self.changeStatus()
                                            }
                                        }
                                        .position(.relative)
                                    }
                                        .class(Class(TCUserConfigurationClass.field))
                                        

                                    self.formField("Nueva contraseña", self.passwordField)
                                    self.formField("Confirmar contraseña", self.passwordConfirmField)

                                    if self.canManageUser {
                                        Div {
                                            Button("Reenviar contraseña")
                                                .class(Class(TCUserConfigurationClass.actionButton))
                                                .class(Class(TCUserConfigurationClass.secondaryAction))
                                                .disabled(self.$isProcessingUserAction)
                                                .onClick {
                                                    self.resendPassword()
                                                }

                                            Button("Restablecer contraseña")
                                                .class(Class(TCUserConfigurationClass.actionButton))
                                                .class(Class(TCUserConfigurationClass.dangerAction))
                                                .disabled(self.$isProcessingUserAction)
                                                .onClick {
                                                    self.resetPassword()
                                                }
                                        }
                                            .class(Class(TCUserConfigurationClass.credentialActions))
                                    }

                                    self.formField("Nuevo PIN", self.pinField)
                                    self.formField("Confirmar PIN", self.pinConfirmField)
                                    Div().clear(.both).height(7.px)
                                }
                                    .class(Class(TCUserConfigurationClass.formGrid))

                                Div {
                                    Div {
                                        self.corporateMailToggle
                                        Div {
                                            Strong("Correo corporativo")
                                            Span("Habilita el acceso a buzón empresarial")
                                        }
                                    }
                                        .class(Class(TCUserConfigurationClass.toggleRow))

                                    Div {
                                        Span("Perfiles productivos")
                                        Div {
                                            if self.data.userData.productionProfile.isEmpty {
                                                Span("Sin perfiles")
                                                    .class(Class(TCUserConfigurationClass.emptyInline))
                                            } else {
                                                ForEach(self.data.userData.productionProfile) { profile in
                                                    Span(profile.rawValue.capitalized)
                                                        .class(Class(TCUserConfigurationClass.tag))
                                                }
                                            }
                                        }
                                            .class(Class(TCUserConfigurationClass.tagList))
                                    }
                                        .class(Class(TCUserConfigurationClass.accessGroup))

                                    Div {
                                        Span("Buzones y alias")
                                        Div {
                                            if self.mailAliases.isEmpty {
                                                Span("Sin correos alternativos")
                                                    .class(Class(TCUserConfigurationClass.emptyInline))
                                            } else {
                                                ForEach(self.mailAliases) { alias in
                                                    Span(alias)
                                                        .class(Class(TCUserConfigurationClass.tag))
                                                }
                                            }
                                        }
                                            .class(Class(TCUserConfigurationClass.tagList))
                                    }
                                        .class(Class(TCUserConfigurationClass.accessGroup))
                                }
                                    .class(Class(TCUserConfigurationClass.accessDetails))
                            }
                                .class(Class(TCUserConfigurationClass.card))
                                .height(445.px)

                            // MARK: NOTE
                            Div{
                                Div{
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .padding(all: 3.px)
                                        .paddingRight(0.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .height(22.px)
                                        .onClick { img, event in
                                            
                                            addToDom(AddNoteView(
                                                relationType: .user,
                                                relationId: self.data.userData.id,
                                                callback: { note in
                                                    self.notes.insert(note, at: 0)
                                                }))
                                        }
                                    
                                    self.noteTypeSelect
                                    
                                    H2("Notas")
                                        .color(.lightGray)
                                }
                                .class(Class(TCAccountViewClass.panelHeader))
                                
                                Div().clear(.both)

                                Div {
                                    self.notesDiv
                                }
                                .custom("height", "calc(100% - 37px)")
                                .class(.roundDarkBlue)
                                .overflow(.auto)
                                .marginTop(7.px)
                            }
                            .class(Class(TCUserConfigurationClass.card))
                            .height(445.px)
                            
                            Div {
                                self.sectionTitle("Contacto y ubicación", "Canales alternativos y domicilio", icon: "⌖")
                                Div {
                                    self.formField("Móvil", self.mobileField)
                                    self.formField("Teléfono", self.telephoneField)
                                    self.formField("Correo alternativo", self.emailField, wide: true)
                                    self.formField("Calle", self.streetField, wide: true)
                                    self.formField("Colonia", self.colonyField)
                                    self.formField("Ciudad", self.cityField)
                                    self.formField("Estado", self.stateField)
                                    self.formField("País", self.countryField)
                                    self.formField("Código postal", self.zipField)
                                }
                                    .class(Class(TCUserConfigurationClass.formGrid))
                            }
                                .class(Class(TCUserConfigurationClass.card))

                            Div {
                                self.sectionTitle("Información personal", "Identidad y datos generales", icon: "◉")
                                Div {
                                    self.formField("Primer nombre", self.firstNameField)
                                    self.formField("Segundo nombre", self.secondNameField)
                                    self.formField("Primer apellido", self.lastNameField)
                                    self.formField("Segundo apellido", self.secondLastNameField)
                                    self.formField("Nombre corto", self.nickField)
                                    self.formField("Título o puesto", self.titleField)
                                    self.formField("Rol", self.roleSelect)
                                    self.formField("Sexo", self.genderSelect)
                                    self.formField("Día", self.birthDayField)
                                    self.formField("Mes", self.birthMonthField)
                                    self.formField("Año", self.birthYearField)
                                }
                                    .class(Class(TCUserConfigurationClass.formGrid))
                            }
                                .class(Class(TCUserConfigurationClass.card))
                                
                            Div {
                                self.sectionTitle("Documentación", "Identificadores laborales y fiscales", icon: "▤")
                                Div {
                                    self.formField("RFC", self.rfcField)
                                    self.formField("CURP", self.curpField)
                                    self.formField("NSS", self.nssField)
                                }
                                    .class(Class(TCUserConfigurationClass.formGrid))
                            }
                                .class(Class(TCUserConfigurationClass.card))

                            Div {
                                self.sectionTitle("Operación y desempeño", "Actividad vinculada al usuario", icon: "↗")
                                Div {
                                    self.summaryRow("Vacantes", self.data.jobs.count.toString)
                                    self.summaryRow("Tareas", self.data.tasks.count.toString)
                                    self.summaryRow("Asistencias", self.data.assistanceRecord.count.toString)
                                    self.summaryRow("Incidencias", self.data.incidenceRecord.count.toString)
                                    self.summaryRow("Puntos de producción", self.data.productionPointManager.count.toString)
                                    self.summaryRow("Reportes QA", self.data.QAReport.count.toString)
                                    self.summaryRow("Contratos", self.data.contracts.count.toString)
                                    self.summaryRow("Notas", self.data.notes.count.toString)
                                }
                                    .class(Class(TCUserConfigurationClass.summaryGrid))
                            }
                                .class(Class(TCUserConfigurationClass.card))

                            Div {
                                self.sectionTitle("Horario y experiencia móvil", "Preferencias operativas del perfil", icon: "◷")
                                Div {
                                    self.summaryRow("Días de operación", self.scheduleDays)
                                    self.summaryRow("Ubicación requerida", self.data.profile.requiereLocation ? "Sí" : "No")
                                    self.summaryRow("Solo órdenes propias", self.data.profile.onlyMyOrdersInMobile ? "Sí" : "No")
                                    self.summaryRow("Vista de órdenes", self.data.profile.orderViewType.rawValue)
                                    self.summaryRow("Fondo", self.data.profile.background ?? "Predeterminado")
                                }
                                    .class(Class(TCUserConfigurationClass.profileSummary))
                            }
                                .class(Class(TCUserConfigurationClass.card))

                            Div {
                                self.sectionTitle("Servicios financieros", "Resumen de movimientos y obligaciones", icon: "$")
                                Div {
                                    self.summaryRow("Balance", "$\(self.data.balance.formatMoney)")
                                    self.summaryRow("Servicios financieros", self.data.finace.count.toString)
                                    self.summaryRow("Gastos y egresos", self.data.gastos.count.toString)
                                    self.summaryRow("Contratos", self.data.contracts.count.toString)
                                }
                                    .class(Class(TCUserConfigurationClass.summaryGrid))
                            }
                                .class(Class(TCUserConfigurationClass.card))

                            Div {
                                self.sectionTitle("Inventario en posesión", "Productos y herramientas relacionados", icon: "▦")
                                Div {
                                    if self.data.inventory.isEmpty {
                                        Div {
                                            Img()
                                                .src("/skyline/media/panel_product.png")
                                            Strong("Sin inventario asignado")
                                            Span("Los artículos relacionados con este usuario aparecerán aquí.")
                                        }
                                            .class(Class(TCUserConfigurationClass.emptyState))
                                    } else {
                                        ForEach(self.data.inventory) { item in
                                            Div {
                                                Div {
                                                    Img()
                                                        .src(item.type == .product ? "/skyline/media/price.png" : "/skyline/media/icon-tools.png")
                                                }
                                                    .class(Class(TCUserConfigurationClass.inventoryIcon))
                                                Div {
                                                    Strong(item.name)
                                                    Span(item.description.isEmpty ? "Sin descripción" : item.description)
                                                }
                                                    .class(Class(TCUserConfigurationClass.inventoryText))
                                                Span(item.type == .product ? "Producto" : "Herramienta")
                                                    .class(Class(TCUserConfigurationClass.inventoryType))
                                            }
                                                .class(Class(TCUserConfigurationClass.inventoryItem))
                                        }
                                    }
                                }
                                    .class(Class(TCUserConfigurationClass.inventoryGrid))
                            }
                                .class(Class(TCUserConfigurationClass.card))
                                .class(Class(TCUserConfigurationClass.cardWide))
                        }
                            .class(Class(TCUserConfigurationClass.cards))
                    }
                        .class(Class(TCUserConfigurationClass.content))
                }
                    .class(Class(TCUserConfigurationClass.workspace))
            }
                .class(Class(TCUserConfigurationClass.shell))
        }

        override func buildUI() {
            super.buildUI()

            TCUserConfigurationTheme.apply(to: self)

            position(.fixed)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            zIndex(9999999)


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
            storeName = store.name
            userMid = data.userData.MID
            roleListener = data.userData.role.rawValue
            username = data.userData.username
            title = data.userData.title
            firstName = data.userData.firstName
            secondName = data.userData.secondName
            lastName = data.userData.lastName
            secondLastName = data.userData.secondLastName
            birthDay = data.userData.birthDay?.toString ?? ""
            birthMonth = data.userData.birthMonth?.toString ?? ""
            birthYear = data.userData.birthYear?.toString ?? ""
            rfc = data.userData.rfc
            curp = data.userData.curp
            nss = data.userData.nss
            telephone = data.userData.telephone
            mobile = data.userData.mobile
            email = data.userData.email
            street = data.userData.street
            colony = data.userData.colony
            city = data.userData.city
            state = data.userData.state
            country = data.userData.country
            zip = data.userData.zip
            herk = data.userData.herk
            linkedProfile = data.userData.linkedProfile
            preformanceRankListener = data.userData.preformanceRank.toString
            nick = data.userData.nick
            sexo = data.userData.sexo?.rawValue ?? ""
            meta = data.userData.meta
            corporateMailIsActive = data.userData.corporateMailIsActive
            corporateMailAliases = data.userData.corporateMailAliases
            productionProfile = data.userData.productionProfile
            status = data.userData.status
            isActive = data.userData.status == .active
            notes = data.notes

            $isActive.listen {

                if $0 {
                    self.status = .active
                }
                else {
                    self.status = .suspended
                }
                
            }

            if let color = data.userData.colorCode {
                colorCode = color.hasPrefix("#") ? color : "#\(color)"
            }

            UsernameRoles.allCases.forEach { role in
                roleSelect.appendChild(
                    Option(role.description)
                        .value(role.rawValue)
                )
            }

            Genders.allCases.forEach { gender in
                genderSelect.appendChild(
                    Option(gender.description)
                        .value(gender.rawValue)
                )
            }

            NoteTypes.allCases.forEach { type in
                if type.readAvailable {
                    self.noteTypeSelect.appendChild(Option(type.description)
                        .value(type.rawValue))
                }
            }
            
            getUserRefrence(id: .id(data.userData.supervisor)) { user in
                if let uname = user?.username.explode("@").first {
                    self.supervisorName = "@\(uname)"
                } else {
                    self.supervisorName = user?.username ?? "N/D"
                }
            }

            API.custAPIV1.getGroups(storeId: self.store.id) { resp in
                guard let resp else {
                    return
                }
                resp.data?.forEach { group in
                    if self.data.userData.workGroop == group.id {
                        self.groopName = group.meta2
                    }
                }
            }

            loadPermissions()
        }

        private func roleDescription(_ value: String) -> String {
            UsernameRoles(rawValue: value)?.description ?? value
        }

        private func formField(
            _ label: String,
            _ field: BaseElement,
            wide: Bool = false
        ) -> Div {
            let view = Div {
                Label(label)
                field
            }
                .class(Class(TCUserConfigurationClass.field))
            if wide {
                view.class(Class(TCUserConfigurationClass.fieldWide))
            }
            return view
        }

        private func metric(
            _ label: String,
            _ value: String,
            _ detail: String
        ) -> Div {
            Div {
                Span(label)
                    .class(Class(TCUserConfigurationClass.metricLabel))
                Strong(value)
                    .class(Class(TCUserConfigurationClass.metricValue))
                Span(detail)
                    .class(Class(TCUserConfigurationClass.metricDetail))
            }
                .class(Class(TCUserConfigurationClass.metric))
        }

        private func summaryRow(_ label: String, _ value: String) -> Div {
            Div {
                Span(label)
                Strong(value)
            }
                .class(Class(TCUserConfigurationClass.summaryRow))
        }

        private func summaryRow(_ label: String, _ value: State<String>) -> Div {
            Div {
                Span(label)
                Strong(value)
            }
                .class(Class(TCUserConfigurationClass.summaryRow))
        }

        private func summaryRow(_ label: String, _ value: Int) -> Div {
            Div {
                Span(label)
                Strong(value.toString)
            }
                .class(Class(TCUserConfigurationClass.summaryRow))
        }

        private func summaryRow(_ label: String, _ value: State<Int>) -> Div {
            Div {
                Span(label)
                Strong(value.map{ $0.toString })
            }
                .class(Class(TCUserConfigurationClass.summaryRow))
        }

        private func sectionTitle(_ title: String, _ subtitle: String, icon: String) -> Div {
            Div {

                Span(subtitle)
                .marginRight(7.px)
                .textAlign(.right)
                .fontSize(14.px)
                .width(180.px)
                .float(.right)
                .color(.gray)

                Span(icon)
                    .class(Class(TCUserConfigurationClass.sectionTitleIcon))
                    .attribute("aria-hidden", "true")
                    .float(.left)

                H2(title)
                .color(.white)
                .float(.left)

                Div().clear(.both).height(7.px)

            }
        }

        private func loadPermissions() {

            API.custAPIV1.prepareUserPermition { resp in

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor para obtener permisos")
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

                self.cats = payload.cats
                
                self.subCats = payload.subCats
                
                self.atributes = payload.atributes

                var subCats: [UUID: [PanelConfigurationSubCatagoryItem]] = [:]
                payload.subCats.forEach { subCat in
                    subCats[subCat.panelConfigurationCatagory, default: []].append(subCat)
                }

                self.permitionItems = []

                payload.cats.forEach { cat in
                    guard self.linkedProfile.contains(cat.code) else {
                        return
                    }

                    let inner = Div()
                        .class(Class(TCUserConfigurationClass.permissionChildren))

                    let visibleSubCats = (subCats[cat.id] ?? []).filter {
                        self.linkedProfile.contains($0.code)
                    }

                    visibleSubCats.forEach { subCat in
                        inner.appendChild(
                            Div {
                                Span(subCat.name)
                                Img()
                                    .src("/skyline/media/history_setting_icon_white.png")
                            }
                                .class(Class(TCUserConfigurationClass.permissionChild))
                        )
                    }

                    let item = Div {
                        Div {
                            Div {
                                Img()
                                    .src("/skyline/media/panel_service.png")
                                Strong(cat.name)
                            }
                            Span(visibleSubCats.count.toString)
                                .class(Class(TCUserConfigurationClass.permissionCount))
                        }
                            .class(Class(TCUserConfigurationClass.permissionItemHeader))
                        inner
                    }
                        .class(Class(TCUserConfigurationClass.permissionItem))

                    self.permitionItems.append(item)
                }

                if self.permitionItems.isEmpty {

                    self.permitionItems = [
                        Div("Sin permisos vinculados")
                            .class(Class(TCUserConfigurationClass.emptyInline))
                    ]
                }
            }
        }

        func addPermitToUser() {

            let view = PermitionManager(
                cats: cats,
                subCats: subCats,
                atributes: atributes,
                userId: data.userData.id,
                assignedPermissions: linkedProfile
            ) { [weak self] payload in
                guard let self else {
                    return
                }

                var permissions = self.linkedProfile
                [payload.catCode, payload.subCatCode, payload.attribCode].forEach { code in
                    guard let code, !permissions.contains(code) else {
                        return
                    }
                    permissions.append(code)
                }

                self.linkedProfile = permissions
                self.loadPermissions()
            }

            addToDom(view)

        }

        func resendPassword() {
            guard canManageUser else {
                showError(.generalError, "No tiene permiso para administrar este usuario")
                return
            }

            guard !isProcessingUserAction else {
                return
            }

            beginUserAction()

            API.custUsernameV1.resendPassword(id: data.userData.id) { resp in
                self.finishUserAction()

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor")
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                showSuccess(.operacionExitosa, "La contraseña fue reenviada al usuario")
            }
        }

        func resetPassword() {
            guard canManageUser else {
                showError(.generalError, "No tiene permiso para administrar este usuario")
                return
            }

            guard !isProcessingUserAction else {
                return
            }

            let confirmation = ConfirmationView(
                type: .yesNo,
                title: "Restablecer contraseña",
                message: "Se generará una contraseña nueva y la contraseña actual dejará de funcionar. ¿Desea continuar?"
            ) { isConfirmed, _ in
                guard isConfirmed else {
                    return
                }
                self.resetPasswordAction()
            }

            addToDom(confirmation, presentation: .glass)
        }

        private func resetPasswordAction() {
            guard canManageUser else {
                showError(.generalError, "No tiene permiso para administrar este usuario")
                return
            }

            guard !isProcessingUserAction else {
                return
            }

            beginUserAction()

            API.custUsernameV1.resetPassword(id: data.userData.id) { resp in
                self.finishUserAction()

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor")
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.password = ""
                self.passwordConfirm = ""
                showSuccess(.operacionExitosa, "Se generó y envió una contraseña nueva")
            }
        }

        func preDelUser() {

            guard canManageUser else {
                showError(.generalError, "No tiene permiso para administrar este usuario")
                return
            }

            guard !isProcessingUserAction else {
                return
            }

            beginUserAction()

            API.custUsernameV1.requestUserCancelation(
                userId: data.userData.id
            ) { resp in
                self.finishUserAction()

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor")
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

                let view = UserCancelationRequestView(
                    store: self.store,
                    user: self.data.userData,
                    payload: payload
                ) {
                    self.userCard.status = .canceled
                    self.remove()
                }

                addToDom(view, presentation: .glass)
            }
        }

        func saveUser() {
            guard canManageUser else {
                showError(.generalError, "No tiene permiso para administrar este usuario")
                return
            }

            guard !isProcessingUserAction else {
                return
            }

            let firstName = self.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondName = self.secondName.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = self.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondLastName = self.secondLastName.trimmingCharacters(in: .whitespacesAndNewlines)
            let nick = self.nick.trimmingCharacters(in: .whitespacesAndNewlines)
            let mobile = self.mobile.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !firstName.isEmpty else {
                showError(.requiredField, "Primer nombre requerido")
                return
            }

            guard !lastName.isEmpty else {
                showError(.requiredField, "Primer apellido requerido")
                return
            }

            guard !nick.isEmpty else {
                showError(.requiredField, "Nombre corto requerido")
                return
            }

            guard mobile.count == 10, mobile.allSatisfy({ $0.isNumber }) else {
                showError(.generalError, "El teléfono móvil debe contener 10 números")
                return
            }

            guard email.isEmpty || isValidEmailAddress(email) else {
                showError(.generalError, "El correo alternativo tiene un formato incorrecto")
                return
            }

            guard let role = UsernameRoles(rawValue: roleListener),
                  role.value <= custCatchHerk else {
                showError(.generalError, "No tiene permiso para asignar este nivel operativo")
                return
            }

            guard let gender = Genders(rawValue: sexo) else {
                showError(.requiredField, "Seleccione el sexo del usuario")
                return
            }

            guard let birthDay = Int(self.birthDay), (1...31).contains(birthDay),
                  let birthMonth = Int(self.birthMonth), (1...12).contains(birthMonth),
                  let birthYear = Int(self.birthYear),
                  birthYear >= Date().year - 80,
                  birthYear <= Date().year - 14 else {
                showError(.generalError, "Ingrese una fecha de nacimiento válida")
                return
            }

            if !password.isEmpty {
                guard password == passwordConfirm else {
                    showError(.generalError, "Las contraseñas no coinciden")
                    return
                }

                let validation = passwordValidation(password, username)
                guard validation.0 else {
                    showError(.generalError, validation.2.joined(separator: "\n"))
                    return
                }
            } else if !passwordConfirm.isEmpty {
                showError(.generalError, "Ingrese la contraseña antes de confirmarla")
                return
            }

            if !pin.isEmpty || !pinConfirm.isEmpty {
                guard pin == pinConfirm else {
                    showError(.generalError, "Los PIN no coinciden")
                    return
                }

                guard (4...6).contains(pin.count), pin.allSatisfy({ $0.isNumber }) else {
                    showError(.generalError, "El PIN debe contener entre 4 y 6 números")
                    return
                }
            }

            beginUserAction()

            API.custUsernameV1.update(
                id: data.userData.id,
                password: password,
                pin: pin,
                herk: role.value,
                firstName: firstName,
                secondName: secondName,
                lastName: lastName,
                secondLastName: secondLastName,
                sexo: gender,
                mobile: mobile,
                email: email,
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear: birthYear,
                nick: nick,
                inicioDeTurno: "09:00",
                finDeTurno: "18:00",
                dayOfService: data.meta?.schedule?.days ?? [],
                backGround: data.meta?.backGround ?? data.profile.background ?? "under_water.jpg",
                profile: linkedProfile
            ) { resp in
                self.finishUserAction()

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor")
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.firstName = firstName
                self.secondName = secondName
                self.lastName = lastName
                self.secondLastName = secondLastName
                self.nick = nick
                self.mobile = mobile
                self.email = email
                self.herk = role.value
                self.password = ""
                self.passwordConfirm = ""
                self.pin = ""
                self.pinConfirm = ""
                self.userCard.nick = nick
                self.userCard.role = role

                showSuccess(.operacionExitosa, "Usuario actualizado")
            }
        }

        private func isValidEmailAddress(_ value: String) -> Bool {
            guard value.rangeOfCharacter(from: .whitespacesAndNewlines) == nil else {
                return false
            }

            let parts = value.split(separator: "@", omittingEmptySubsequences: false)
            guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else {
                return false
            }

            let domain = String(parts[1])
            return domain.contains(".") && !domain.hasPrefix(".") && !domain.hasSuffix(".")
        }

        private func beginUserAction() {
            isProcessingUserAction = true
            loadingView(show: true)
        }

        private func finishUserAction() {
            loadingView(show: false)
            isProcessingUserAction = false
        }

        func changeStatus() {
            let view = ConfirmationView(
                type: .yesNo,
                title: self.isActive ? "Suspender Accesso" : "REactivar Accesso",
                message: "Confirme cambio de estado del usuario",
                callback: { isConfirmed, comment in
                    if isConfirmed {
                        self.changeStatusAction()
                    }
                }
            )
        }

        func changeStatusAction() {

            if status == .canceled {
                return
            }

            loadingView(show: true)

            API.custUsernameV1.changeStatus(
                id: data.userData.id,
                status: isActive ? .suspended : .active
            ) { resp in

                loadingView(show: false)

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor para obtener permisos")
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.isActive = !self.isActive

                self.userCard.status = self.status

            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $storeName.removeAllListeners()
            $groopName.removeAllListeners()
            $supervisorName.removeAllListeners()
            $userMid.removeAllListeners()
            $roleListener.removeAllListeners()
            $username.removeAllListeners()
            $password.removeAllListeners()
            $passwordConfirm.removeAllListeners()
            $pin.removeAllListeners()
            $pinConfirm.removeAllListeners()
            $title.removeAllListeners()
            $firstName.removeAllListeners()
            $secondName.removeAllListeners()
            $lastName.removeAllListeners()
            $secondLastName.removeAllListeners()
            $birthDay.removeAllListeners()
            $birthMonth.removeAllListeners()
            $birthYear.removeAllListeners()
            $rfc.removeAllListeners()
            $curp.removeAllListeners()
            $nss.removeAllListeners()
            $telephone.removeAllListeners()
            $mobile.removeAllListeners()
            $email.removeAllListeners()
            $street.removeAllListeners()
            $colony.removeAllListeners()
            $city.removeAllListeners()
            $state.removeAllListeners()
            $country.removeAllListeners()
            $zip.removeAllListeners()
            $herk.removeAllListeners()
            $linkedProfile.removeAllListeners()
            $preformanceRankListener.removeAllListeners()
            $nick.removeAllListeners()
            $colorCode.removeAllListeners()
            $sexo.removeAllListeners()
            $meta.removeAllListeners()
            $corporateMailIsActive.removeAllListeners()
            $corporateMailAliases.removeAllListeners()
            $productionProfile.removeAllListeners()
            $status.removeAllListeners()
            $permitionItems.removeAllListeners()
            $noteTypeListener.removeAllListeners()
            $isActive.removeAllListeners()
            $isProcessingUserAction.removeAllListeners()
        }
    }
}
