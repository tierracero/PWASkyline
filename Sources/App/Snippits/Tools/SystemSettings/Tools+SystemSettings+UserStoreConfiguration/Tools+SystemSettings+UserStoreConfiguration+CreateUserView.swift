//
//  Tools+SystemSettings+UserStoreConfiguration+CreateUserView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {

    final class CreateUserView: Div {

        override class var name: String { "div" }

        private let store: CustStore
        private let availability: CustUsernameComponents.PreRequestUsernameResponse
        private let onCreated: () -> Void

        @State private var firstName = ""
        @State private var secondName = ""
        @State private var lastName = ""
        @State private var secondLastName = ""
        @State private var mobile = ""
        @State private var email = ""
        @State private var gender = Genders.male.rawValue
        @State private var birthDate = "1990-01-01"
        @State private var nick = ""

        @State private var username = ""
        @State private var password = ""
        @State private var passwordConfirmation = ""
        @State private var pin = ""
        @State private var pinConfirmation = ""
        @State private var role = UsernameRoles.general.rawValue

        @State private var groupId: String
        @State private var activeEmail: Bool
        @State private var mailStorage = ""
        @State private var shiftStart = "09:00"
        @State private var shiftEnd = "18:00"
        @State private var background = "under_water.jpg"

        @State private var sunday = false
        @State private var monday = true
        @State private var tuesday = true
        @State private var wednesday = true
        @State private var thursday = true
        @State private var friday = true
        @State private var saturday = true

        @State private var isSubmitting = false

        init(
            store: CustStore,
            availability: CustUsernameComponents.PreRequestUsernameResponse,
            onCreated: @escaping () -> Void
        ) {
            self.store = store
            self.availability = availability
            self.onCreated = onCreated
            self.groupId = availability.groops.first?.id.uuidString ?? ""
            self.activeEmail = availability.mailaccounts > 0
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        private lazy var firstNameField = InputText(self.$firstName)
            .placeholder("Primer nombre")

        private lazy var secondNameField = InputText(self.$secondName)
            .placeholder("Segundo nombre")

        private lazy var lastNameField = InputText(self.$lastName)
            .placeholder("Primer apellido")

        private lazy var secondLastNameField = InputText(self.$secondLastName)
            .placeholder("Segundo apellido")

        private lazy var mobileField = InputText(self.$mobile)
            .placeholder("10 dígitos")

        private lazy var emailField = InputEmail(self.$email)
            .placeholder("correo@alternativo.com")

        private lazy var genderSelect = Select(self.$gender)

        private lazy var birthDateField = InputDate(self.$birthDate)

        private lazy var nickField = InputText(self.$nick)
            .placeholder("Nombre visible en chat")

        private lazy var usernameField = InputText(self.$username)
            .placeholder("usuario")
            .attribute("autocomplete", "off")

        private lazy var passwordField = InputPassword(self.$password)
            .placeholder("Generar automáticamente")
            .attribute("autocomplete", "new-password")

        private lazy var passwordConfirmationField = InputPassword(self.$passwordConfirmation)
            .placeholder("Confirmar contraseña")
            .attribute("autocomplete", "new-password")

        private lazy var pinField = InputPassword(self.$pin)
            .placeholder("PIN de 4 a 6 dígitos")
            .attribute("autocomplete", "new-password")

        private lazy var pinConfirmationField = InputPassword(self.$pinConfirmation)
            .placeholder("Confirmar PIN")
            .attribute("autocomplete", "new-password")

        private lazy var roleSelect = Select(self.$role)

        private lazy var groupSelect = Select(self.$groupId)

        private lazy var activeEmailToggle = InputCheckbox()
            .toggle(self.$activeEmail, self.availability.mailaccounts <= 0)

        private lazy var mailStorageSelect = Select(self.$mailStorage)
            .disabled(self.availability.mailaccounts <= 0)

        private lazy var shiftStartField = InputTime(self.$shiftStart)

        private lazy var shiftEndField = InputTime(self.$shiftEnd)

        private lazy var backgroundSelect = Select(self.$background)

        @DOM override var body: DOM.Content {
            Div {
                Div {
                    Div {
                        Span("Usuarios y correos electrónicos")
                            .class(Class(TCCreateUserClass.eyebrow))
                        H2("Crear nuevo usuario")
                        Span("Configura identidad, acceso y operación para (self.store.name).")
                    }
                        .class(Class(TCCreateUserClass.headerCopy))

                    Div {
                        Span("USUARIOS (self.availability.useraccount)")
                        Span("CORREOS (self.availability.mailaccounts)")
                    }
                        .class(Class(TCCreateUserClass.headerAvailability))

                    Img()
                        .closeButton(.subView)
                        .class(Class(TCCreateUserClass.close))
                        .onClick {
                            guard !self.isSubmitting else { return }
                            self.remove()
                        }
                }
                    .class(Class(TCCreateUserClass.header))

                Div {
                    Div {
                        Div {
                            self.sectionHeader(icon: "●", title: "Datos personales", subtitle: "Identidad y contacto")
                            Div {
                                self.field("Primer nombre", self.firstNameField, required: true)
                                self.field("Segundo nombre", self.secondNameField)
                                self.field("Primer apellido", self.lastNameField, required: true)
                                self.field("Segundo apellido", self.secondLastNameField)
                                self.field("Móvil con SMS", self.mobileField, required: true)
                                self.field("Correo alternativo", self.emailField)
                                self.field("Sexo", self.genderSelect)
                                self.field("Fecha de nacimiento", self.birthDateField)
                            }
                                .class(Class(TCCreateUserClass.formGrid))
                        }
                            .class(Class(TCCreateUserClass.card))

                        Div {
                            self.sectionHeader(icon: "◆", title: "Datos del usuario", subtitle: "Credenciales y jerarquía")
                            Div {
                                self.field("Nivel operativo", self.roleSelect, required: true)

                                Div {
                                    Label {
                                        Span("Usuario")
                                        Sup("REQUERIDO")
                                    }
                                    Div {
                                        self.usernameField
                                        Span("@\(custCatchUrl)")
                                    }
                                        .class(Class(TCCreateUserClass.usernameField))
                                }
                                    .class(Class(TCCreateUserClass.field))
                                    .class(Class(TCCreateUserClass.fieldWide))

                                self.field("Contraseña", self.passwordField)
                                self.field("Confirmar contraseña", self.passwordConfirmationField)
                                self.field("PIN", self.pinField)
                                self.field("Confirmar PIN", self.pinConfirmationField)
                            }
                                .class(Class(TCCreateUserClass.formGrid))

                            Div {
                                Span("Mínimo 6 caracteres · una minúscula · una MAYÚSCULA")
                                Span("Un número · un símbolo ($ @ # ! % * ? &) · sin incluir el usuario")
                                Span("Si queda vacía, el sistema generará la contraseña y la enviará por SMS.")
                            }
                                .class(Class(TCCreateUserClass.hint))
                        }
                            .class(Class(TCCreateUserClass.card))

                        Div {
                            self.sectionHeader(icon: "↗", title: "Datos operativos", subtitle: "Grupo, correo y horario")
                            Div {
                                self.field("Tienda", self.readOnlyValue(self.store.name))
                                self.field("Grupo operativo", self.groupSelect, required: true)

                                Div {
                                    Div {
                                        Strong("Activar correo corporativo")
                                        Span(self.availability.mailaccounts > 0 ? "Cuentas disponibles: \(self.availability.mailaccounts)" : "Sin cuentas disponibles")
                                    }
                                    self.activeEmailToggle
                                }
                                    .class(Class(TCCreateUserClass.toggleRow))

                                self.field("Capacidad de correo", self.mailStorageSelect)
                                self.field("Inicio de turno", self.shiftStartField)
                                self.field("Fin de turno", self.shiftEndField)

                                Div {
                                    Label("Días de operación")
                                    Div {
                                        self.dayToggle("Dom", self.$sunday)
                                        self.dayToggle("Lun", self.$monday)
                                        self.dayToggle("Mar", self.$tuesday)
                                        self.dayToggle("Mié", self.$wednesday)
                                        self.dayToggle("Jue", self.$thursday)
                                        self.dayToggle("Vie", self.$friday)
                                        self.dayToggle("Sáb", self.$saturday)
                                    }
                                        .class(Class(TCCreateUserClass.days))
                                }
                                    .class(Class(TCCreateUserClass.field))
                                    .class(Class(TCCreateUserClass.fieldWide))
                            }
                                .class(Class(TCCreateUserClass.formGrid))
                        }
                            .class(Class(TCCreateUserClass.card))
                            .class(Class(TCCreateUserClass.cardWide))
                    }
                        .class(Class(TCCreateUserClass.main))

                    Div {
                        Div {
                            Div {
                                Img()
                                    .src("/skyline/media/default_panda.jpeg")
                                    .alt("Avatar predeterminado")
                            }
                                .class(Class(TCCreateUserClass.avatarFrame))
                            Strong(self.$nick.map { $0.isEmpty ? "Nuevo usuario" : $0 })
                            Span("La fotografía puede actualizarse después de crear la cuenta.")
                        }
                            .class(Class(TCCreateUserClass.avatarCard))

                        Div {
                            self.sectionHeader(icon: "✦", title: "Avatar y apodo", subtitle: "Experiencia del perfil")
                            self.field("Apodo", self.nickField, required: true)
                            self.field("Fondo de pantalla", self.backgroundSelect)
                        }
                            .class(Class(TCCreateUserClass.card))

                        Div {
                            Span("Resumen")
                            self.summaryRow("Tienda", self.store.name)
                            self.summaryRow("Usuarios disponibles", self.availability.useraccount.toString)
                            self.summaryRow("Correos disponibles", self.availability.mailaccounts.toString)
                            self.summaryRow("Dominio", "@(custCatchUrl)")
                        }
                            .class(Class(TCCreateUserClass.summary))
                    }
                        .class(Class(TCCreateUserClass.sidebar))
                }
                    .class(Class(TCCreateUserClass.content))

                Div {
                    Div {
                        Strong("Cuenta nueva")
                        Span("Se agregará a (self.store.name) y al grupo seleccionado.")
                    }

                    Div {
                        Div("Cancelar")
                            .class(Class(TCCreateUserClass.cancelButton))
                            .onClick {
                                guard !self.isSubmitting else { return }
                                self.remove()
                            }

                        Div {
                            Span(self.$isSubmitting.map { $0 ? "Creando usuario..." : "+ Crear usuario" })
                        }
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .class(Class(TCCreateUserClass.submitButton))
                            .onClick {
                                self.createUser()
                            }
                    }
                        .class(Class(TCCreateUserClass.footerActions))
                }
                    .class(Class(TCCreateUserClass.footer))
            }
                .class(Class(TCCreateUserClass.shell))
        }

        override func buildUI() {
            super.buildUI()

            TCCrystalSurfaceTheme.apply(to: self, variant: .customerCreation)
            TCCreateUserTheme.apply(to: self)

            position(.fixed)
            width(100.percent)
            height(100.percent)
            left(0.px)
            top(0.px)
            zIndex(9999999)

            Genders.allCases.forEach { value in
                genderSelect.appendChild(
                    Option(value.description)
                        .value(value.rawValue)
                        .selected(value.rawValue == gender)
                )
            }

            UsernameRoles.allCases
                .filter { $0.value < custCatchHerk }
                .forEach { value in
                    roleSelect.appendChild(
                        Option(operationalLevelDescription(value))
                            .value(value.rawValue)
                            .selected(value.rawValue == role)
                    )
                }

            availability.groops.forEach { group in
                groupSelect.appendChild(
                    Option(group.name)
                        .value(group.id.uuidString)
                        .selected(group.id.uuidString == groupId)
                )
            }

            [
                ("Seleccione capacidad", ""),
                ("512 MB", "512"),
                ("1 GB", "1024"),
                ("2 GB", "2048"),
                ("5 GB", "5120"),
                ("Ilimitado", "0")
            ].forEach { label, value in
                mailStorageSelect.appendChild(
                    Option(label)
                        .value(value)
                        .selected(value == mailStorage)
                )
            }

            [
                ("Azul futuro", "under_water.jpg"),
                ("PinkTech", "tech-abstract-12.jpg"),
                ("Dark Beginning", "dark-brgin.jpg"),
                ("Red Me", "red_me.jpg")
            ].forEach { label, value in
                backgroundSelect.appendChild(
                    Option(label)
                        .value(value)
                        .selected(value == background)
                )
            }
        }

        private func field(
            _ label: String,
            _ control: BaseElement,
            required: Bool = false
        ) -> Div {
            Div {
                Label {
                    Span(label)
                    if required {
                        Sup("REQUERIDO")
                    }
                }
                control
            }
                .class(Class(TCCreateUserClass.field))
        }

        private func readOnlyValue(_ value: String) -> Div {
            Div(value)
                .class(Class(TCCreateUserClass.readOnlyValue))
        }

        private func sectionHeader(icon: String, title: String, subtitle: String) -> Div {
            Div {
                Span(icon)
                    .class(Class(TCCreateUserClass.sectionIcon))
                    .attribute("aria-hidden", "true")
                Div {
                    H3(title)
                    Span(subtitle)
                }
            }
                .class(Class(TCCreateUserClass.sectionHeader))
        }

        private func dayToggle(_ label: String, _ value: State<Bool>) -> Div {
            Div {
                InputCheckbox().toggle(value)
                Span(label)
            }
                .class(Class(TCCreateUserClass.day))
        }

        private func summaryRow(_ label: String, _ value: String) -> Div {
            Div {
                Span(label)
                Strong(value)
            }
                .class(Class(TCCreateUserClass.summaryRow))
        }

        private var selectedDays: [Int] {
            var values: [Int] = []
            if sunday { values.append(1) }
            if monday { values.append(2) }
            if tuesday { values.append(3) }
            if wednesday { values.append(4) }
            if thursday { values.append(5) }
            if friday { values.append(6) }
            if saturday { values.append(7) }
            return values
        }

        private func createUser() {
            guard !isSubmitting else { return }

            let firstName = self.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondName = self.secondName.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = self.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondLastName = self.secondLastName.trimmingCharacters(in: .whitespacesAndNewlines)
            let mobile = self.mobile.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let nick = self.nick.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.password
            let passwordConfirmation = self.passwordConfirmation
            let pin = self.pin
            let pinConfirmation = self.pinConfirmation
            let shiftStart = self.shiftStart
            let shiftEnd = self.shiftEnd
            let background = self.background

            guard !firstName.isEmpty else {
                showError(.generalError, "Ingrese el primer nombre")
                return
            }

            guard !lastName.isEmpty else {
                showError(.generalError, "Ingrese el primer apellido")
                return
            }

            print(mobile)

            print(mobile.count)
            
            guard mobile.count == 10 else {
                showError(.generalError, "Ingrese un móvil válido de 10 dígitos")
                return
            }

            guard let _ = Int64(mobile) else {
                showError(.generalError, "Ingrese un móvil válido")
                return
            }

            guard email.isEmpty || isValidEmailAddress(email) else {
                showError(.generalError, "Ingrese un correo alternativo válido")
                return
            }

            guard !nick.isEmpty else {
                showError(.generalError, "Ingrese el apodo del usuario")
                return
            }

            let usernameValue = self.username
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let usernameLocalPart = usernameValue.split(separator: "@").first.map(String.init) ?? ""

            guard !usernameLocalPart.isEmpty,
                  usernameLocalPart.rangeOfCharacter(from: .whitespacesAndNewlines) == nil else {
                showError(.generalError, "Ingrese un nombre de usuario válido")
                return
            }

            let fullUsername = "\(usernameLocalPart)@\(custCatchUrl)".lowercased()

            guard let role = UsernameRoles(rawValue: self.role), role.value < custCatchHerk else {
                showError(.generalError, "Seleccione un nivel operativo menor al suyo")
                return
            }

            guard let group = availability.groops.first(where: { $0.id.uuidString == self.groupId }) else {
                showError(.generalError, "Seleccione un grupo operativo válido")
                return
            }

            guard let gender = Genders(rawValue: self.gender) else {
                showError(.generalError, "Seleccione el sexo del usuario")
                return
            }

            guard let birthday = birthdayPayload else {
                showError(.generalError, "Seleccione una fecha de nacimiento válida")
                return
            }

            let scheduleDays = selectedDays
            guard !scheduleDays.isEmpty else {
                showError(.generalError, "Seleccione al menos un día de operación")
                return
            }

            let corporateMailIsActive = activeEmail && availability.mailaccounts > 0
            let selectedMailStorage: Int
            if corporateMailIsActive {
                guard !mailStorage.isEmpty, let storage = Int(mailStorage) else {
                    showError(.generalError, "Seleccione almacenamiento para el correo corporativo")
                    return
                }
                selectedMailStorage = storage
            } else {
                selectedMailStorage = 0
            }

            if !password.isEmpty {
                guard password == passwordConfirmation else {
                    showError(.generalError, "Las contraseñas no coinciden")
                    return
                }

                let validation = passwordValidation(password, fullUsername)
                guard validation.0 else {
                    showError(.generalError, validation.2.joined(separator: "\n"))
                    return
                }
            } else if !passwordConfirmation.isEmpty {
                showError(.generalError, "Ingrese la contraseña antes de confirmarla")
                return
            }

            if !pin.isEmpty || !pinConfirmation.isEmpty {
                guard pin == pinConfirmation else {
                    showError(.generalError, "Los PIN no coinciden")
                    return
                }

                guard (4...6).contains(pin.count), Int(pin) != nil else {
                    showError(.generalError, "El PIN debe contener entre 4 y 6 números")
                    return
                }
            }

            isSubmitting = true
            loadingView.show()

            API.custUsernameV1.chekeFreeCustUsername(username: fullUsername) { response in
                guard let response else {
                    self.finishSubmitting()
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard response.status == .ok else {
                    self.finishSubmitting()
                    showError(.generalError, response.msg)
                    return
                }

                API.custUsernameV1.create(
                    store: self.store.id,
                    storeName: self.store.name,
                    groop: group.id,
                    groopSupervisor: group.supervisor,
                    groopName: group.name,
                    username: fullUsername,
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
                    bday: birthday,
                    avatar: "",
                    nick: nick,
                    activeEmail: corporateMailIsActive,
                    mailStorage: selectedMailStorage,
                    inicioDeTurno: shiftStart,
                    finDeTurno: shiftEnd,
                    dayOfService: scheduleDays,
                    backGround: background,
                    profile: [],
                    role: role
                ) { response in
                    self.finishSubmitting()

                    guard let response else {
                        showError(.comunicationError, .serverConextionError)
                        return
                    }

                    guard response.status == .ok else {
                        showError(.generalError, response.msg)
                        return
                    }

                    showSuccess(.operacionExitosa, "Usuario \(fullUsername) creado")
                    self.onCreated()
                    self.remove()
                }
            }
        }

        private var birthdayPayload: String? {
            let parts = birthDate.split(separator: "-")
            guard parts.count == 3,
                  let year = Int(parts[0]),
                  let month = Int(parts[1]),
                  let day = Int(parts[2]),
                  (1...12).contains(month),
                  (1...31).contains(day),
                  year >= Date().year - 80,
                  year <= Date().year - 14 else {
                return nil
            }
            return "\(day)/\(month)/\(year)"
        }

        private func operationalLevelDescription(_ role: UsernameRoles) -> String {
            switch role {
            case .general:
                return "Operativo"
            case .supervisor:
                return "Supervisor"
            case .manager:
                return "Supervisor General"
            case .gmanager:
                return "Gerente"
            case .owner:
                return "Presidente"
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

        private func finishSubmitting() {
            isSubmitting = false
            loadingView.hide()
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $firstName.removeAllListeners()
            $secondName.removeAllListeners()
            $lastName.removeAllListeners()
            $secondLastName.removeAllListeners()
            $mobile.removeAllListeners()
            $email.removeAllListeners()
            $gender.removeAllListeners()
            $birthDate.removeAllListeners()
            $nick.removeAllListeners()
            $username.removeAllListeners()
            $password.removeAllListeners()
            $passwordConfirmation.removeAllListeners()
            $pin.removeAllListeners()
            $pinConfirmation.removeAllListeners()
            $role.removeAllListeners()
            $groupId.removeAllListeners()
            $activeEmail.removeAllListeners()
            $mailStorage.removeAllListeners()
            $shiftStart.removeAllListeners()
            $shiftEnd.removeAllListeners()
            $background.removeAllListeners()
            $sunday.removeAllListeners()
            $monday.removeAllListeners()
            $tuesday.removeAllListeners()
            $wednesday.removeAllListeners()
            $thursday.removeAllListeners()
            $friday.removeAllListeners()
            $saturday.removeAllListeners()
            $isSubmitting.removeAllListeners()
        }
    }
}
