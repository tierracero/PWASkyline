import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class CreateNewSubCustomerDataView: Div {

    override class var name: String { "div" }

    let searchTerm: String

    let custAcct: CustAcctSearch

    private let callback: (CustSubAcct) -> Void

    init(
        custAcct: CustAcctSearch,
        acctType: CustAcctTypes = .personal,
        searchTerm: String = "",
        requierFullAddress: Bool,
        callback: @escaping (CustSubAcct) -> Void
    ) {
        self.searchTerm = searchTerm
        self.custAcct = custAcct
        self.callback = callback
        super.init()
        accountType = acctType.rawValue

        let term = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(term) {
            email = term
        } else if !term.isEmpty, Int64(term) != nil {
            mobile = term
        } else if acctType != .personal {
            businessName = term
        } else {

            if !searchTerm.contains(";;") {

                let names = term.split(separator: " ", maxSplits: 1)
                
                firstName = names.first.map(String.init) ?? ""
                
                lastName = names.count > 1 ? String(names[1]) : ""

            }

        }
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State private var subaccountId: UUID? = nil

    @State private var accountType = CustAcctTypes.personal.rawValue
    @State private var businessName = ""
    @State private var username = ""
    @State private var title = ""
    @State private var firstName = ""
    @State private var secondName = ""
    @State private var lastName = ""
    @State private var secondLastName = ""
    @State private var telephone = ""
    @State private var mobile = ""
    @State private var email = ""
    @State private var street = ""
    @State private var colony = ""
    @State private var city = ""
    @State private var state = ""
    @State private var country = Countries.mexico.description
    @State private var zip = ""
    @State private var latitude = ""
    @State private var longitud = ""
    @State private var isSaving = false

    private lazy var typeField = USelectField(self.$accountType)
    private lazy var businessNameField = UTextField(self.$businessName).placeholder("Nombre del negocio")
    private lazy var usernameField = UTextField(self.$username).placeholder("Nombre de usuario")
    private lazy var titleField = UTextField(self.$title).placeholder("Título o nombre de la ubicación")
    private lazy var firstNameField = UTextField(self.$firstName).placeholder("Primer nombre")
    private lazy var secondNameField = UTextField(self.$secondName).placeholder("Segundo nombre")
    private lazy var lastNameField = UTextField(self.$lastName).placeholder("Primer apellido")
    private lazy var secondLastNameField = UTextField(self.$secondLastName).placeholder("Segundo apellido")
    private lazy var telephoneField = UTextField(self.$telephone).placeholder("Teléfono")
    private lazy var mobileField = UTextField(self.$mobile).placeholder("Celular")
    private lazy var emailField = UTextField(self.$email).placeholder("Correo electrónico")
    private lazy var streetField = UTextField(self.$street).placeholder("Calle y número")
    private lazy var colonyField = UTextField(self.$colony).placeholder("Colonia / asentamiento")
    private lazy var cityField = UTextField(self.$city).placeholder("Ciudad / municipio")
    private lazy var stateField = UTextField(self.$state).placeholder("Estado")
    private lazy var countryField = UTextField(self.$country).placeholder("País")
    private lazy var zipField = UTextField(self.$zip).placeholder("Código postal")
    
    private lazy var latitudeField = UTextField(self.$latitude)
    .placeholder("Latitud (opcional)")
    .disabled(true)

    private lazy var longitudField = UTextField(self.$longitud)
    .placeholder("Longitud (opcional)")
    .disabled(true)

    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 1000)) {
            VTitle("Crear Subcuenta") {
                USmallTitle("Nueva cuenta relacionada")
            } onClose: {
                if !self.isSaving { self.remove() }
            }

            VBodyGrid {
                VGrid(.full) {
                    VBox {
                        UField("Cuenta principal", required: false) {
                            USubTitle("\(self.custAcct.folio) | \(self.parentName)")
                        }
                    }
                }

                VGrid(.half) {
                    VBox {
                        USubTitle("Datos de la subcuenta")
                        USmallTitle(self.$accountType.map {
                            $0 == CustAcctTypes.personal.rawValue
                                ? "Primer nombre y primer apellido requeridos."
                                : "Nombre del negocio requerido."
                        })
                        Div {
                            UField("Tipo de cuenta") { self.typeField }
                            UField("Nombre del negocio", required: false) { self.businessNameField }
                            // UField("Usuario", required: false) { self.usernameField }
                            // UField("Título / ubicación", required: false) { self.titleField }
                            UField("Primer nombre", required: false) { self.firstNameField }
                            UField("Segundo nombre", required: false) { self.secondNameField }
                            UField("Primer apellido", required: false) { self.lastNameField }
                            UField("Segundo apellido", required: false) { self.secondLastNameField }
                        }
                        .class(Class(TCCrystalSurfaceClass.customerFormFields))

                        USubTitle("Contacto")
                        Div {
                            UField("Teléfono", required: false) { self.telephoneField }
                            UField("Celular", required: false) { self.mobileField }
                            UField("Correo electrónico", required: false) { self.emailField }
                        }
                        .class(Class(TCCrystalSurfaceClass.customerFormFields))
                    }
                }

                VGrid(.half) {
                    VBox {

                        Div{

                            USmallButton("Buscar Dirección")
                                .class(Class(TCCrystalSurfaceClass.goodButton))
                                .disabled(self.$isSaving)
                                .float(.right)
                                .onClick { self.loadAddress() }

                            USubTitle("Dirección de servicio")

                        }
                        .display(.block)
                        
                        UField("Calle y número", required: false) { self.streetField }

                        Div().width(100.percent).height(7.px)

                        Div {
                            UField("Colonia / asentamiento", required: false) { self.colonyField }
                            UField("Ciudad / municipio", required: false) { self.cityField }
                            UField("Estado", required: false) { self.stateField }
                            UField("País", required: false) { self.countryField }
                            UField("Código postal", required: false) { self.zipField }
                        }
                        .class(Class(TCCrystalSurfaceClass.customerFormFields))

                        USubTitle("Coordenadas (opcionales)")
                        .hidden(self.$latitude.map{ $0.isEmpty })

                        Div {
                            UField("Latitud", required: false) { self.latitudeField }
                            UField("Longitud", required: false) { self.longitudField }
                        }
                        .display(self.$latitude.map{ $0.isEmpty ? .none : .block })
                        .class(Class(TCCrystalSurfaceClass.customerFormFields))
                        .hidden(self.$latitude.map{ $0.isEmpty })
                    }
                }
            }

            ULargeButton(self.$isSaving.map { $0 ? "Creando Subcuenta…" : "Crear Subcuenta" })
                .class(Class(TCCrystalSurfaceClass.goodButton))
                .disabled(self.$isSaving)
                .onClick { self.createSubAccount() }
        }
    }

    private var parentName: String {
        if !custAcct.businessName.isEmpty { return custAcct.businessName }
        return [custAcct.firstName, custAcct.lastName].filter { !$0.isEmpty }.joined(separator: " ")
    }

    override func buildUI() {
        super.buildUI()
        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .customerData)
        position(.absolute)
        width(100.percent)
        height(100.percent)
        left(0.px)
        top(0.px)
        attribute("role", "dialog")
        attribute("aria-modal", "true")

        CustAcctTypes.allCases.forEach { type in
            typeField.appendChild(Option(type.description).value(type.rawValue).selected(type.rawValue == accountType))
        }
        // 23.710271;;-99.183555

        if searchTerm.contains(";;") {
            let parts = searchTerm.explode(";;")

            guard parts.count == 2,
            let latstr = parts.first,
            let lonstr = parts.last,
            let latitude = Double(latstr),
            let longitude = Double(lonstr) else {
                return
            }

            addToDom(ManualAddressSearch(.byLocation(
                latitude: latitude,
                longitude: longitude
            )) { [weak self] result in

                guard let self, self.isInDOM else { return }

                switch result {
                case .address(let address):
                    self.colony = address.settlement
                    self.city = address.city
                    self.state = address.state
                    self.country = address.country.description
                    self.zip = address.zip
                    self.latitude = ""
                    self.longitud = ""
                case .coordinates(let address):
                    self.street = address.street
                    self.colony = address.settlement
                    self.city = address.city
                    self.state = address.state
                    self.country = address.country.description
                    self.zip = address.zip
                    self.latitude = String(address.latitude)
                    self.longitud = String(address.longitude)
                }

                self.streetField.select()

            })

        }

    }

    override func didAddToDOM() {
        super.didAddToDOM()
        firstNameField.select()
    }

    private func loadAddress() {

        guard !isSaving else { return }

        guard country.purgeSpaces.pseudo == Countries.mexico.description.pseudo ||
                country.purgeSpaces.pseudo == Countries.mexico.rawValue.pseudo else {
            showError(.invalidField, "La búsqueda de dirección está disponible para México. Puede capturar los campos manualmente.")
            return
        }

        let loadBy: ManualAddressSearch.LoadType = state.isEmpty ? .byCountry(.mexico) : .byAddress(.init(
            orderId: custAcct.id,
            colony: colony,
            city: city,
            state: state,
            country: country
        ))

        addToDom(ManualAddressSearch(loadBy) { [weak self] result in
            guard let self, self.isInDOM else { return }
            switch result {
            case .address(let address):
                self.colony = address.settlement
                self.city = address.city
                self.state = address.state
                self.country = address.country.description
                self.zip = address.zip
                self.latitude = ""
                self.longitud = ""
            case .coordinates(let address):
                self.street = address.street
                self.colony = address.settlement
                self.city = address.city
                self.state = address.state
                self.country = address.country.description
                self.zip = address.zip
                self.latitude = String(address.latitude)
                self.longitud = String(address.longitude)
            }
            self.streetField.select()
        })
    }

    private func createSubAccount() {
        guard !isSaving else { return }
        guard let acctType = CustAcctTypes(rawValue: accountType) else {
            showError(.requiredField, "Seleccione un tipo de cuenta válido.")
            return
        }
        if acctType == .personal {
            guard !firstName.purgeSpaces.isEmpty, !lastName.purgeSpaces.isEmpty else {
                showError(.requiredField, "Ingrese primer nombre y primer apellido.")
                (firstName.purgeSpaces.isEmpty ? firstNameField : lastNameField).select()
                return
            }
        } else if businessName.purgeSpaces.isEmpty {
            showError(.requiredField, "Ingrese el nombre del negocio.")
            businessNameField.select()
            return
        }

        if !email.purgeSpaces.isEmpty, !isValidEmail(email.purgeSpaces) {
            showError(.invalidFormat, "Ingrese un correo electrónico válido.")
            emailField.select()
            return
        }
        for phone in [mobile, telephone] where !phone.purgeSpaces.isEmpty {
            let (valid, conflict) = isValidPhone(phone.purgeSpaces)
            guard valid else {
                showError(.invalidFormat, conflict)
                return
            }
        }

        let latitudeValue = Double(latitude.purgeSpaces)
        let longitudeValue = Double(longitud.purgeSpaces)
        if !latitude.purgeSpaces.isEmpty {
            guard let latitudeValue, latitudeValue.isFinite, (-90.0...90.0).contains(latitudeValue) else {
                showError(.invalidField, "Ingrese una latitud válida entre -90 y 90.")
                latitudeField.select()
                return
            }
        }
        if !longitud.purgeSpaces.isEmpty {
            guard let longitudeValue, longitudeValue.isFinite, (-180.0...180.0).contains(longitudeValue) else {
                showError(.invalidField, "Ingrese una longitud válida entre -180 y 180.")
                longitudField.select()
                return
            }
        }

        isSaving = true
        loadingView.show()
        API.custSubAcctV1.create(
            custAcct: custAcct.id,
            type: acctType,
            businessName: businessName.purgeSpaces,
            username: username.purgeSpaces,
            title: title.purgeSpaces,
            firstName: firstName.purgeSpaces,
            secondName: secondName.purgeSpaces,
            lastName: lastName.purgeSpaces,
            secondLastName: secondLastName.purgeSpaces,
            telephone: telephone.purgeSpaces,
            mobile: mobile.purgeSpaces,
            email: email.purgeSpaces,
            street: street.purgeSpaces,
            colony: colony.purgeSpaces,
            city: city.purgeSpaces,
            state: state.purgeSpaces,
            country: country.purgeSpaces,
            zip: zip.purgeSpaces,
            latitude: latitudeValue,
            longitud: longitudeValue
        ) { [weak self] response in
            loadingView.hide()
            guard let self else { return }
            self.isSaving = false

            guard let response else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            guard response.status == .ok else {
                showError(.generalError, response.msg)
                return
            }
            guard let payload = response.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            guard payload.status == .ok else {
                showError(.generalError, payload.msg)
                return
            }
            guard let item = payload.custSubAcct, item.custAcct == self.custAcct.id else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            showSuccess(.operacionExitosa, "Subcuenta creada \(item.folio)")
            self.callback(item)
            self.remove()
        }
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $accountType.removeAllListeners()
        $businessName.removeAllListeners()
        $username.removeAllListeners()
        $title.removeAllListeners()
        $firstName.removeAllListeners()
        $secondName.removeAllListeners()
        $lastName.removeAllListeners()
        $secondLastName.removeAllListeners()
        $telephone.removeAllListeners()
        $mobile.removeAllListeners()
        $email.removeAllListeners()
        $street.removeAllListeners()
        $colony.removeAllListeners()
        $city.removeAllListeners()
        $state.removeAllListeners()
        $country.removeAllListeners()
        $zip.removeAllListeners()
        $latitude.removeAllListeners()
        $longitud.removeAllListeners()
        $isSaving.removeAllListeners()
    }
}
