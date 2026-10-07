import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class ManageSubCustomerAccountView: Div {

    override class var name: String { "div" }

    let searchTerm: String

    let custAcct: CustAcctSearch

    let custSubAcct: CustSubAcct?
    
    let requierFullAddress: Bool

    private let callback: (CustSubAcct) -> Void
    private var savedSubaccount: CustSubAcct?
    private let mapId = "subcustomer_location_map_" + callKey(32)
    private var locationMap: JSObject?
    private var mapRequest = 0

    private var isEditing: Bool { custSubAcct != nil || savedSubaccount != nil }

    init(
        custAcct: CustAcctSearch,
        acctType: CustAcctTypes = .personal,
        searchTerm: String = "",
        requierFullAddress: Bool = false,
        callback: @escaping (CustSubAcct) -> Void
    ) {
        self.searchTerm = searchTerm
        self.custAcct = custAcct
        self.custSubAcct = nil
        self.requierFullAddress = requierFullAddress
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

    init(
        custAcct: CustAcctSearch,
        custSubAcct: CustSubAcct,
        requierFullAddress: Bool,
        callback: @escaping (CustSubAcct) -> Void
    ) {
        self.searchTerm = ""
        self.custAcct = custAcct
        self.custSubAcct = custSubAcct
        self.requierFullAddress = requierFullAddress
        self.callback = callback
        super.init()

        accountType = custSubAcct.type.rawValue
        businessName = custSubAcct.businessName
        username = custSubAcct.username
        title = custSubAcct.title
        firstName = custSubAcct.firstName
        secondName = custSubAcct.secondName
        lastName = custSubAcct.lastName
        secondLastName = custSubAcct.secondLastName
        telephone = custSubAcct.telephone
        mobile = custSubAcct.mobile
        email = custSubAcct.email
        street = custSubAcct.street
        colony = custSubAcct.colony
        city = custSubAcct.city
        state = custSubAcct.state
        country = custSubAcct.country
        zip = custSubAcct.zip
        latitude = custSubAcct.latitude.map { String($0) } ?? ""
        longitud = custSubAcct.longitud.map { String($0) } ?? ""
    }

    required init() {
        fatalError("init() has not been implemented")
    }

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
    @State private var showLocationMap = false

    private lazy var mapContainer = Div {
        Table().noResult(label: "🗺️ Cargar Mapa")
    }
        .id(.init(mapId))
        .borderRadius(10.px)
        .width(100.percent)
        .overflow(.hidden)
        .height(150.px)

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
    

    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 1000)) {
            VTitle(self.isEditing ? "Editar Subcuenta" : "Crear Subcuenta") {
                USmallTitle(self.isEditing ? "Actualizar cuenta relacionada" : "Nueva cuenta relacionada")
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
                            
                            USmallTitle(self.requierFullAddress ? "Coordenadas requeridas" : "Coordenadas (opcionales)")


                        }
                        .display(.block)
                        

                        Div {
                            self.mapContainer
                        }
                        .display(self.$showLocationMap.map { $0 ? .block : .none })

                        UField("Calle y número", required: self.requierFullAddress) { self.streetField }

                        Div().width(100.percent).height(7.px)

                        Div {
                            UField("Colonia / asentamiento", required: self.requierFullAddress) { self.colonyField }
                            UField("Ciudad / municipio", required: self.requierFullAddress) { self.cityField }
                            UField("Estado", required: self.requierFullAddress) { self.stateField }
                            UField("País", required: self.requierFullAddress) { self.countryField }
                            UField("Código postal", required: self.requierFullAddress) { self.zipField }
                        }
                        .class(Class(TCCrystalSurfaceClass.customerFormFields))

                    }
                }
            }

            ULargeButton(self.$isSaving.map {
                if self.isEditing { return $0 ? "Guardando Subcuenta…" : "Guardar Cambios" }
                return $0 ? "Creando Subcuenta…" : "Crear Subcuenta"
            })
                .class(Class(TCCrystalSurfaceClass.goodButton))
                .disabled(self.$isSaving)
                .onClick { self.saveSubAccount() }
        }
    }

    private var parentName: String {
        if !custAcct.businessName.isEmpty { return custAcct.businessName }
        return [custAcct.firstName, custAcct.lastName].filter { !$0.isEmpty }.joined(separator: " ")
    }

    static let fullAddressMessage = "Para utilizar esta subcuenta, se requiere una dirección completa con ubicación (latitud y longitud). Por favor, complete la dirección y seleccione su ubicación."

    static func hasFullAddress(_ item: CustSubAcct) -> Bool {
        hasFullAddress(
            fields: [item.street, item.colony, item.city, item.state, item.country, item.zip],
            latitude: item.latitude,
            longitude: item.longitud
        )
    }

    private static func hasFullAddress(fields: [String], latitude: Double?, longitude: Double?) -> Bool {
        guard fields.allSatisfy({ !$0.purgeSpaces.isEmpty }),
              let latitude, latitude.isFinite, (-90.0...90.0).contains(latitude),
              let longitude, longitude.isFinite, (-180.0...180.0).contains(longitude) else { return false }
        return true
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
    }

    private func loadSearchTermAddress() {
        // 23.710271;;-99.183555

        if searchTerm.contains(";;") {
            let parts = searchTerm.explode(";;")

            guard parts.count == 2,
            let latstr = parts.first,
            let lonstr = parts.last,
            let latitude = Double(latstr), latitude.isFinite, (-90.0...90.0).contains(latitude),
            let longitude = Double(lonstr), longitude.isFinite, (-180.0...180.0).contains(longitude) else {
                return
            }

            // 23.733481;;-99.143840
            addToDom(ManualAddressSearch(.byLocation(
                latitude: latitude,
                longitude: longitude
            )) { [weak self] result in

                guard let self, self.isInDOM else { return }

                self.applyAddress(result)

            })

        }

    }

    override func didAddToDOM() {
        super.didAddToDOM()
        $latitude.listen { [weak self] in self?.scheduleMapRefresh() }
        $longitud.listen { [weak self] in self?.scheduleMapRefresh() }
        scheduleMapRefresh()
        firstNameField.select()
        loadSearchTermAddress()
    }

    private func scheduleMapRefresh() {
        mapRequest += 1
        let request = mapRequest
        // Address lookup assigns latitude and longitude separately; render the final pair.
        Dispatch.asyncAfter(0.1) { [weak self] in
            guard let self, self.isInDOM, self.mapRequest == request else { return }
            self.refreshLocationMap(request: request)
        }
    }

    private func clearLocationMap() {
        if let locationMap {
            _ = locationMap.destroy?()
        }
        locationMap = nil
        mapContainer.innerHTML = ""
    }

    private func refreshLocationMap(request: Int) {
        
        guard let latitude = Double(latitude.purgeSpaces), latitude.isFinite,
              (-90.0...90.0).contains(latitude),
              let longitude = Double(longitud.purgeSpaces), longitude.isFinite,
              (-180.0...180.0).contains(longitude) else {
            showLocationMap = requierFullAddress
            return
        }

        clearLocationMap()

        showLocationMap = true

        mapContainer.appendChild(USmallTitle("Cargando mapa…"))

        API.v1.jwt { [weak self] token in
            guard let self, self.isInDOM, self.mapRequest == request else { return }
            self.mapContainer.innerHTML = ""
            guard let token,
                  let createMap = JSObject.global["createSubCustomerLocationMap"].function else {
                self.mapContainer.appendChild(USmallTitle("No fue posible cargar el mapa. Busque la dirección para intentar de nuevo."))
                return
            }
            self.locationMap = createMap(self.mapId, token, latitude, longitude).object
            if self.locationMap == nil {
                self.mapContainer.appendChild(USmallTitle("No fue posible cargar el mapa. Busque la dirección para intentar de nuevo."))
            }
        }
    }

    private func loadAddress() {

        guard !isSaving else { return }

        if country.purgeSpaces.isEmpty { country = Countries.mexico.description }

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


        let view = ManualAddressSearch(loadBy) { [weak self] result in
            guard let self, self.isInDOM else { return }
            self.applyAddress(result)

        }

        addToDom(view)
    }

    private func applyAddress(_ result: ManualAddressSearch.ResultType) {
        switch result {
        case .address(let address):
            guard !requierFullAddress else {
                showError(.requiredField, Self.fullAddressMessage)
                return
            }
            colony = address.settlement
            city = address.city
            state = address.state
            country = address.country.description
            zip = address.zip
            latitude = ""
            longitud = ""
        case .coordinates(let address):

            Console.clear()

            print(address)

            street = address.street
            colony = address.settlement
            city = address.city
            state = address.state
            country = address.country.description
            zip = address.zip
            latitude = String(address.latitude)
            longitud = String(address.longitude)
        }
        streetField.select()
    }

    private func saveSubAccount() {
        guard !isSaving else { return }
        if let custSubAcct, custSubAcct.custAcct != custAcct.id {
            showError(.unexpectedResult, "La subcuenta no pertenece a la cuenta principal.")
            return
        }
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
                loadAddress()
                return
            }
        }
        if !longitud.purgeSpaces.isEmpty {
            guard let longitudeValue, longitudeValue.isFinite, (-180.0...180.0).contains(longitudeValue) else {
                showError(.invalidField, "Ingrese una longitud válida entre -180 y 180.")
                loadAddress()
                return
            }
        }

        if requierFullAddress, !Self.hasFullAddress(
            fields: [street, colony, city, state, country, zip],
            latitude: latitudeValue,
            longitude: longitudeValue
        ) {
            showError(.requiredField, Self.fullAddressMessage)
            if latitudeValue == nil || longitudeValue == nil { loadAddress() }
            else { streetField.select() }
            return
        }

        isSaving = true
        loadingView.show()
        if let custSubAcct = savedSubaccount ?? custSubAcct {
            API.custSubAcctV1.update(
                id: custSubAcct.id,
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
                longitud: longitudeValue,
                status: custSubAcct.status
            ) { [weak self] response in
                guard let self, self.isInDOM else {
                    loadingView.hide()
                    return
                }
                guard let response else {
                    self.finishSaving()
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                guard response.status == .ok else {
                    self.finishSaving()
                    showError(.generalError, response.msg)
                    return
                }
                self.loadUpdatedSubAccount(id: custSubAcct.id)
            }
            return
        }

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
            guard let self, self.isInDOM else { return }
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

            self.complete(item)
        }
    }

    private func finishSaving() {
        loadingView.hide()
        isSaving = false
    }

    private func loadUpdatedSubAccount(id: UUID) {
        API.custSubAcctV1.load(id: .id(id)) { [weak self] response in
            loadingView.hide()
            guard let self, self.isInDOM else { return }
            self.isSaving = false
            guard let response else {
                showError(.comunicationError, "Los cambios se guardaron, pero no fue posible cargar la subcuenta. Intente guardar de nuevo.")
                return
            }
            guard response.status == .ok else {
                showError(.generalError, response.msg)
                return
            }
            guard let item = response.data?.custSubAcct, item.id == id, item.custAcct == self.custAcct.id else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            self.complete(item)
        }
    }

    private func complete(_ item: CustSubAcct) {
        let wasEditing = isEditing
        savedSubaccount = item
        guard !requierFullAddress || Self.hasFullAddress(item) else {
            showError(.requiredField, Self.fullAddressMessage)
            return
        }
        showSuccess(.operacionExitosa, wasEditing ? "Subcuenta actualizada \(item.folio)" : "Subcuenta creada \(item.folio)")
        callback(item)
        remove()
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        mapRequest += 1
        clearLocationMap()
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
        $showLocationMap.removeAllListeners()
    }
}
