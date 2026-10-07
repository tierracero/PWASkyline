import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class ConfirmAdddressLocationView: Div {

    override class var name: String { "div" }

    let store: CustStore
    private let sessionId = custCatchID
    private let callback: (CustStore) -> Void
    private var addressSearch: ManualAddressSearch?
    private let mapId = "confirm_address_location_map_" + callKey(32)
    private var locationMap: JSObject?
    private var mapRequest = 0

    init(store: CustStore, callback: @escaping (CustStore) -> Void) {
        self.store = store
        self.callback = callback
        super.init()
        street = store.street
        colony = store.colony
        city = store.city
        state = store.state
        country = store.country
        zip = store.zip
        latitude = store.lat ?? ""
        longitude = store.lon ?? ""
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State private var street = ""
    @State private var colony = ""
    @State private var city = ""
    @State private var state = ""
    @State private var country = ""
    @State private var zip = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var isSaving = false

    private lazy var streetField = UTextField(self.$street).placeholder("Calle y número").disabled(self.$isSaving)
    private lazy var colonyField = UTextField(self.$colony).placeholder("Colonia / asentamiento").disabled(self.$isSaving)
    private lazy var cityField = UTextField(self.$city).placeholder("Ciudad / municipio").disabled(self.$isSaving)
    private lazy var stateField = UTextField(self.$state).placeholder("Estado").disabled(self.$isSaving)
    private lazy var countryField = UTextField(self.$country).placeholder("País").disabled(self.$isSaving)
    private lazy var zipField = UTextField(self.$zip).placeholder("Código postal").disabled(self.$isSaving)
    private lazy var latitudeField = UTextField(self.$latitude).placeholder("Latitud").disabled(self.$isSaving)
    private lazy var longitudeField = UTextField(self.$longitude).placeholder("Longitud").disabled(self.$isSaving)

    private lazy var mapContainer = Div {
        USmallTitle("Busque la dirección o capture latitud y longitud para mostrar la ubicación.")
    }
        .id(.init(mapId))
        .borderRadius(10.px)
        .width(100.percent)
        .overflow(.hidden)
        .height(150.px)

    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 800)) {
            VTitle("Confirmar dirección y ubicación") {
                USmallTitle(self.store.name)
            } onClose: {
                if !self.isSaving { self.remove() }
            }

            VBodyGrid {
                VGrid(.half) {
                    VBox {
                        Div {
                            USmallButton("Buscar Dirección")
                                .class(Class(TCCrystalSurfaceClass.goodButton))
                                .disabled(self.$isSaving)
                                .float(.right)
                                .onClick { self.loadAddress() }
                            USubTitle("Dirección de servicio")
                            USmallTitle("Complete todos los campos para continuar.")
                        }
                        .display(.block)

                        UField("Calle y número") { self.streetField }
                        UField("Colonia / asentamiento") { self.colonyField }
                        UField("Ciudad / municipio") { self.cityField }
                        UField("Estado") { self.stateField }
                        UField("País") { self.countryField }
                        UField("Código postal") { self.zipField }
                    }
                }
                VGrid(.half) {
                    VBox {
                        USubTitle("Ubicación")
                        USmallTitle("Latitud y longitud requeridas")
                        self.mapContainer
                        UField("Latitud") { self.latitudeField }
                        UField("Longitud") { self.longitudeField }
                    }
                }
            }

            ULargeButton(self.$isSaving.map { $0 ? "Guardando dirección…" : "Guardar y continuar" })
                .class(Class(TCCrystalSurfaceClass.goodButton))
                .disabled(self.$isSaving)
                .onClick { self.saveAddress() }
        }
    }

    static func hasFullAddress(_ store: CustStore) -> Bool {
        hasFullAddress(
            fields: [store.street, store.colony, store.city, store.state, store.country, store.zip],
            state: store.state,
            latitude: store.lat.flatMap { Double($0.purgeSpaces) },
            longitude: store.lon.flatMap { Double($0.purgeSpaces) }
        )
    }

    static func locationState(_ value: String) -> CountryStatesMexico? {
        func normalized(_ text: String) -> String {
            text.pseudo.lowercased().filter { !$0.isWhitespace }
        }
        let state = normalized(value)
        return CountryStatesMexico.allCases.first {
            normalized($0.rawValue) == state ||
            normalized($0.code) == state ||
            normalized($0.description) == state
        }
    }

    private static func hasFullAddress(
        fields: [String], state: String, latitude: Double?, longitude: Double?
    ) -> Bool {
        fields.allSatisfy { !$0.purgeSpaces.isEmpty } &&
            locationState(state) != nil && validCoordinates(latitude: latitude, longitude: longitude)
    }

    private static func validCoordinates(latitude: Double?, longitude: Double?) -> Bool {
        guard let latitude, latitude.isFinite, (-90.0...90.0).contains(latitude),
              let longitude, longitude.isFinite, (-180.0...180.0).contains(longitude) else { return false }
        return true
    }

    override func buildUI() {
        super.buildUI()
        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        position(.absolute)
        width(100.percent)
        height(100.percent)
        left(0.px)
        top(0.px)
        attribute("role", "dialog")
        attribute("aria-modal", "true")
    }

    override func didAddToDOM() {
        super.didAddToDOM()
        $latitude.listen { [weak self] in self?.scheduleMapRefresh() }
        $longitude.listen { [weak self] in self?.scheduleMapRefresh() }
        scheduleMapRefresh()
        streetField.select()
    }

    private func loadAddress() {
        guard !isSaving, addressSearch == nil else { return }
        if country.purgeSpaces.isEmpty { country = Countries.mexico.description }
        guard country.purgeSpaces.pseudo == Countries.mexico.description.pseudo ||
                country.purgeSpaces.pseudo == Countries.mexico.rawValue.pseudo else {
            showError(.invalidField, "La búsqueda de dirección está disponible para México. Puede capturar los campos manualmente.")
            return
        }

        let loadBy: ManualAddressSearch.LoadType
        let latitudeValue = Double(latitude.purgeSpaces)
        let longitudeValue = Double(longitude.purgeSpaces)
        if Self.validCoordinates(latitude: latitudeValue, longitude: longitudeValue),
           let latitudeValue, let longitudeValue {
            loadBy = .byLocation(latitude: latitudeValue, longitude: longitudeValue)
        } else if state.purgeSpaces.isEmpty {
            loadBy = .byCountry(.mexico)
        } else {
            loadBy = .byAddress(.init(
                orderId: store.id, colony: colony, city: city, state: state, country: country
            ))
        }

        let view = ManualAddressSearch(loadBy) { [weak self] result in
            guard let self, self.isInDOM, !self.isSaving else { return }
            switch result {
            case .address:
                showError(.requiredField, "Seleccione una dirección con latitud y longitud para continuar.")
            case .coordinates(let address):
                self.street = address.street
                self.colony = address.settlement
                self.city = address.city
                self.state = address.state
                self.country = address.country.description
                self.zip = address.zip
                self.latitude = String(address.latitude)
                self.longitude = String(address.longitude)
                self.streetField.select()
            }
        }
        addressSearch = view
        view.onDidRemoveFromDOM { [weak self] in self?.addressSearch = nil }
        addToDom(view)
    }

    private func scheduleMapRefresh() {
        mapRequest += 1
        let request = mapRequest
        Dispatch.asyncAfter(0.1) { [weak self] in
            guard let self, self.isInDOM, self.mapRequest == request else { return }
            self.refreshMap(request: request)
        }
    }

    private func clearMap() {
        if let locationMap { _ = locationMap.destroy?() }
        locationMap = nil
        mapContainer.innerHTML = ""
    }

    private func refreshMap(request: Int) {
        clearMap()
        let latitudeValue = Double(latitude.purgeSpaces)
        let longitudeValue = Double(longitude.purgeSpaces)
        guard Self.validCoordinates(latitude: latitudeValue, longitude: longitudeValue),
              let latitudeValue, let longitudeValue else {
            mapContainer.appendChild(USmallTitle("Busque la dirección o capture latitud y longitud para mostrar la ubicación."))
            return
        }
        mapContainer.appendChild(USmallTitle("Cargando mapa…"))
        API.v1.jwt { [weak self] token in
            guard let self, self.isInDOM, self.mapRequest == request else { return }
            self.mapContainer.innerHTML = ""
            guard let token, let createMap = JSObject.global["createSubCustomerLocationMap"].function else {
                self.mapContainer.appendChild(USmallTitle("No fue posible cargar el mapa. Busque la dirección para intentar de nuevo."))
                return
            }
            self.locationMap = createMap(self.mapId, token, latitudeValue, longitudeValue).object
            if self.locationMap == nil {
                self.mapContainer.appendChild(USmallTitle("No fue posible cargar el mapa. Busque la dirección para intentar de nuevo."))
            }
        }
    }

    private func saveAddress() {
        guard !isSaving, custCatchID == sessionId else { return }
        guard Self.hasFullAddress(
            fields: [street, colony, city, state, country, zip], state: state,
            latitude: Double(latitude.purgeSpaces), longitude: Double(longitude.purgeSpaces)
        ) else {
            showError(.requiredField, "Complete la dirección, seleccione un estado válido e ingrese latitud y longitud válidas para continuar.")
            return
        }

        var address = store
        address.street = street.purgeSpaces
        address.colony = colony.purgeSpaces
        address.city = city.purgeSpaces
        address.state = state.purgeSpaces
        address.country = country.purgeSpaces
        address.zip = zip.purgeSpaces
        address.lat = latitude.purgeSpaces
        address.lon = longitude.purgeSpaces
        isSaving = true
        loadingView.show()

        // saveStore also writes configuration: carry forward the current server values.
        API.custAPIV1.loadStore(storeId: store.id) { [weak self] response in
            guard let self, self.isInDOM, custCatchID == self.sessionId else { loadingView.hide(); return }
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
            guard let data = response.data, data.store.id == self.store.id else {
                self.finishSaving()
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            self.saveAddress(address, preserving: data)
        }
    }

    private func saveAddress(_ address: CustStore, preserving data: CustComponents.LoadStoreResponse) {
        let current = data.store
        let config = data.config
        let sessionId = self.sessionId
        let profileName = data.fiscal.first(where: { $0.id == current.fiscal })
            .map { "\($0.rfc) \($0.razon)" } ?? ""
        API.custAPIV1.saveStore(
            storeId: current.id,
            name: current.name,
            telephone: current.telephone,
            mobile: current.mobile,
            email: current.email,
            street: address.street,
            colony: address.colony,
            city: address.city,
            state: address.state,
            country: address.country,
            zip: address.zip,
            isPublic: current.isPublic,
            isFiscalable: current.isFiscalable,
            fiscalProfileId: current.fiscal,
            fiscalProfileName: profileName,
            lat: address.lat.flatMap { Double($0) },
            lon: address.lon.flatMap { Double($0) },
            button: config.print.button,
            document: config.print.document,
            image: config.print.image,
            lineBreak: config.print.lineBreak,
            buttonPdv: config.printPdv.button,
            documentPdv: config.printPdv.document,
            imagePdv: config.printPdv.image,
            lineBreakPdv: config.printPdv.lineBreak,
            priceModifierPdv: Double(config.priceModifierPdv) / 100.0,
            priceModifierOrder: Double(config.priceModifierOrder) / 100.0,
            operationType: config.operationType,
            operationStore: config.operationStore,
            sunday: config.schedule.sunday,
            monday: config.schedule.monday,
            tuesday: config.schedule.tuesday,
            wednesday: config.schedule.wednesday,
            thursday: config.schedule.thursday,
            friday: config.schedule.friday,
            saturday: config.schedule.saturday,
            lockedInventory: config.lockedInventory
        ) { [weak self] response in
            guard custCatchID == sessionId else { loadingView.hide(); return }
            guard let response else {
                loadingView.hide()
                self?.isSaving = false
                if self?.isInDOM == true { showError(.comunicationError, .serverConextionError) }
                return
            }
            guard response.status == .ok else {
                loadingView.hide()
                self?.isSaving = false
                if self?.isInDOM == true { showError(.generalError, response.msg) }
                return
            }
            // Refresh server-owned caches even if the dialog was removed while saving.
            Self.reloadSavedStore(id: current.id, sessionId: sessionId) { [weak self] savedStore in
                guard let self, self.isInDOM else { return }
                self.isSaving = false
                guard let savedStore else {
                    showError(.comunicationError, "La dirección se guardó, pero no fue posible cargar la tienda. Intente guardar de nuevo.")
                    return
                }
                guard Self.hasFullAddress(savedStore) else {
                    showError(.requiredField, "La tienda guardada aún requiere una dirección completa y coordenadas válidas.")
                    return
                }
                self.remove()
                self.callback(savedStore)
            }
        }
    }

    private func finishSaving() {
        loadingView.hide()
        isSaving = false
    }

    private static func reloadSavedStore(id: UUID, sessionId: UUID, callback: @escaping (CustStore?) -> Void) {
        API.custAPIV1.loadStore(storeId: id) { response in
            loadingView.hide()
            guard custCatchID == sessionId,
                  let response, response.status == .ok, let data = response.data, data.store.id == id else {
                callback(nil)
                return
            }
            let store = data.store
            stores[id] = store

            let basic = CustStoreBasic(
                id: store.id, name: store.name, mainStore: store.mainStore,
                telephone: store.telephone, mobile: store.mobile, email: store.email,
                street: store.street, colony: store.colony, city: store.city, state: store.state,
                schedulea: store.schedulea, scheduleb: store.scheduleb, schedulec: store.schedulec,
                lat: store.lat, lon: store.lon
            )
            let orderCache = OrderCatchControler.shared
            if let index = orderCache.stores.firstIndex(where: { $0.id == id }) {
                var updated = orderCache.stores
                updated[index] = basic
                orderCache.stores = updated
            }
            if orderCache.selectedStore?.id == id { orderCache.selectedStore = basic }
            callback(store)
        }
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        addressSearch?.remove()
        addressSearch = nil
        mapRequest += 1
        clearMap()
        $street.removeAllListeners()
        $colony.removeAllListeners()
        $city.removeAllListeners()
        $state.removeAllListeners()
        $country.removeAllListeners()
        $zip.removeAllListeners()
        $latitude.removeAllListeners()
        $longitude.removeAllListeners()
        $isSaving.removeAllListeners()
    }
}
