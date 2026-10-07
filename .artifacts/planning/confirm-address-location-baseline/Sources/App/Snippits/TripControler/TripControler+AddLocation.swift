//
// TripControler+AddLocation.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerAddLocation: Div {

    override class var name: String { "div" }

    let viewType: ViewType
    let account: CustAcctSearch
    var items: [FiscalLocationBase]
    let titleForItem: (FiscalLocationBase) -> String
    let subtitleForItem: (FiscalLocationBase) -> String
    let avatarForItem: ((FiscalLocationBase) -> String?)?
    let callback: (CustCommercialTripsComponents.TripLocation) -> Void
    let create: () -> Void

    var icon: String { viewType.icon }
    var title: String { viewType.title }

    init(
        viewType: ViewType,
        account: CustAcctSearch,
        items: [FiscalLocationBase],
        titleForItem: @escaping (FiscalLocationBase) -> String,
        subtitleForItem: @escaping (FiscalLocationBase) -> String,
        callback: @escaping (CustCommercialTripsComponents.TripLocation) -> Void,
        create: @escaping () -> Void,
        avatarForItem: ((FiscalLocationBase) -> String?)? = nil
    ) {
        self.viewType = viewType
        self.account = account
        self.items = items
        self.titleForItem = titleForItem
        self.subtitleForItem = subtitleForItem
        self.avatarForItem = avatarForItem
        self.callback = callback
        self.create = create
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    var tabs: [String] = []

    @State private var isActionMenuOpen = false
    private let actionMenuId = "trip-location-actions-\(UUID().uuidString)"

    lazy var actionMenuToggle = Button("▾")
        .attribute("type", "button")
        .attribute("aria-label", "Más opciones de ubicación")
        .attribute("aria-expanded", "false")
        .attribute("aria-controls", actionMenuId)
        .class(
            Class(TCCrystalSurfaceClass.goodButton),
            Class(TCCrystalSurfaceClass.tripPickerCreate),
            Class(TCCrystalSurfaceClass.tripLocationActionToggle)
        )
        .onClick { _, event in
            event.stopPropagation()
            self.setActionMenuOpen(!self.isActionMenuOpen)
        }

    private func setActionMenuOpen(_ open: Bool) {
        isActionMenuOpen = open
        actionMenuToggle.attribute("aria-expanded", open ? "true" : "false")
    }

    func selectStore() {
        let view = SelectStore { store in
            self.renderLocation(store)
        }
        addToDom(view)
    }

    func searchCustomer() {
        addToDom(SearchSubCustomerView(custAcct: account, requierFullAddress: true) { subaccount in
            self.renderLocation(subaccount)
        })
    }

    private func performAction(_ action: () -> Void, dismissPicker: Bool) {
        setActionMenuOpen(false)
        action()
        if dismissPicker {
            remove()
        } else {
            actionMenuToggle.focus()
        }
    }

    private enum ActionMenuIcon {
        case location
        case store
        case search

        var source: String {
            let shapes: String
            switch self {
            case .location:
                shapes = """
                <path d="M12 21s-7-5-7-12a7 7 0 0 1 14 0c0 1.4-.3 2.7-.8 3.8"/>
                <circle cx="12" cy="9" r="2.5"/>
                <path d="M19 15v6m-3-3h6"/>
                """
            case .store:
                shapes = """
                <path d="m3 9 2-6h14l2 6v2a3 3 0 0 1-6 0 3 3 0 0 1-6 0 3 3 0 0 1-6 0V9Zm0 0h18M5 14v7h14v-7M9 21v-6h6v6"/>
                """
            case .search:
                shapes = """
                <circle cx="10.5" cy="10.5" r="7.5"/>
                <path d="m16 16 5 5"/>
                """
            }

            let svg = """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="rgb(73,185,245)" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">\(shapes)</svg>
            """
            return "data:image/svg+xml;base64,\(Data(svg.utf8).base64EncodedString())"
        }
    }

    private func actionMenuItem(
        _ title: String,
        icon: ActionMenuIcon,
        dismissPicker: Bool = false,
        action: @escaping () -> Void
    ) -> Button {
        let button = Button("")
            .attribute("type", "button")
            .class(Class(TCCrystalSurfaceClass.tripLocationActionOption))
            .custom("display", "flex")
            .custom("align-items", "center")
            .custom("gap", "10px")
            .onClick { _, event in
                event.stopPropagation()
                self.performAction(action, dismissPicker: dismissPicker)
            }

        button.appendChild(
            Img()
                .src(icon.source)
                .attribute("alt", "")
                .attribute("aria-hidden", "true")
                .width(18.px)
                .height(18.px)
                .custom("flex-shrink", "0")
        )
        button.appendChild(Span(title))
        return button
    }

    lazy var itemsContainer = Div()
        .class(Class(TCCrystalSurfaceClass.tripPickerList))

    @DOM override var body: DOM.Content {

        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/\(self.icon)")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.title)
                        .class(
                            Class(TCTripBetaClass.titleText),
                            Class(TCCrystalSurfaceClass.tripPickerTitle)
                        )
                }
                .custom("align-items", "center")
                .custom("min-width", "0")
                .custom("gap", "8px")
                .display(.flex)

                Div {
                    Div {
                        Div {
                            Button("+ Agregar")
                                .attribute("type", "button")
                                .class(
                                    Class(TCCrystalSurfaceClass.goodButton),
                                    Class(TCCrystalSurfaceClass.tripPickerCreate),
                                    Class(TCCrystalSurfaceClass.tripLocationActionMain)
                                )
                                .onClick { _, event in
                                    event.stopPropagation()
                                    self.performAction(self.create, dismissPicker: true)
                                }

                            self.actionMenuToggle
                        }
                        .attribute("role", "group")
                        .attribute("aria-label", "Agregar y más opciones")
                        .class(Class(TCCrystalSurfaceClass.tripLocationActionGroup))

                        Div {
                            self.actionMenuItem("Agregar ubicación", icon: .location, dismissPicker: true, action: self.create)
                            self.actionMenuItem("Seleccionar tienda", icon: .store, action: self.selectStore)
                            self.actionMenuItem("Buscar cliente", icon: .search, action: self.searchCustomer)
                        }
                        .attribute("id", self.actionMenuId)
                        .attribute("role", "group")
                        .attribute("aria-label", "Acciones de ubicación")
                        .class(Class(TCCrystalSurfaceClass.tripLocationActionMenu))
                        .hidden(self.$isActionMenuOpen.map { !$0 })
                    }
                    .class(Class(TCCrystalSurfaceClass.tripLocationActions))

                    Img()
                        .closeButton(.uiView2)
                        .class(Class(TCCrystalSurfaceClass.tripPickerClose))
                        .onClick {
                            self.remove()
                        }
                }
                .class(
                    Class(TCTripBetaClass.titleActions),
                    Class(TCCrystalSurfaceClass.tripPickerActions)
                )
            }
            .class(
                Class(TCTripBetaClass.title),
                Class(TCCrystalSurfaceClass.tripPickerHeader)
            )
            .zIndex(1)

            // Pending: wire tabsContainer once the tab state is defined.
            // tabsContainer(selectedValue: State<String>, items: [String], callback: (String) -> Void)

            Div {
                self.itemsContainer
            }
            .class(Class(TCCrystalSurfaceClass.tripPickerBody))
        }
        .class(
            Class(TCTripBetaClass.popUpPanel),
            Class(TCTripBetaClass.popUpPanelFitContent),
            Class(TCCrystalSurfaceClass.tripPickerPanel)
        )
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        self.class(Class(TCCrystalSurfaceClass.tripPicker))
        self.class(Class(TCCrystalSurfaceClass.tripLocationPicker))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")
        self.onClick { _, _ in
            self.setActionMenuOpen(false)
        }
        self.onKeyDown { _, event in
            if event.key == "Escape", self.isActionMenuOpen {
                event.preventDefault()
                event.stopPropagation()
                self.setActionMenuOpen(false)
                self.actionMenuToggle.focus()
            }
        }

        if items.isEmpty {
            itemsContainer.appendChild(
                Div {
                    Div("👾")
                        .class(Class(TCCrystalSurfaceClass.tripPickerEmptyIcon))

                    H2("No hay opciones disponibles")
                        .class(Class(TCCrystalSurfaceClass.tripPickerEmptyTitle))
                }
                .class(Class(TCCrystalSurfaceClass.tripPickerEmpty))
            )
            return
        }

        items.forEach { item in
            itemsContainer.appendChild(
                Div {
                    if let avatarForItem = self.avatarForItem {
                        tripAvatarImage(avatarForItem(item))
                            .width(44.px)
                            .height(44.px)
                            .borderRadius(all: 8.px)
                    }

                    Div {
                        Div(self.titleForItem(item))
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.tripPickerItemTitle)
                            )

                        Div(self.subtitleForItem(item))
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.tripPickerItemSubtitle)
                            )
                    }
                    .custom("min-width", "0")
                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxInteractive),
                    Class(TCCrystalSurfaceClass.tripPickerItem)
                )
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "10px")
                .onClick {

                    self.callback(CustCommercialTripsComponents.TripLocation(
                        placementType: item.placementType,
                        placementId: item.placementId,
                        locationType: .location,
                        locationId: item.id,
                        rfc: item.rfc,
                        razon: item.razon,
                        uts: item.uts,
                        storeName: item.storeName,
                        street: item.street,
                        number: item.number,
                        colonie: item.colonie,
                        refrence: item.refrence,
                        state: item.state,
                        country: item.country,
                        zipCode: item.zipCode,
                        distance: nil,
                        latitude: item.latitude,
                        longitude: item.longitude
                    ))

                    self.remove()

                }
            )
        }
    }

    override func didRemoveFromDOM() {
        setActionMenuOpen(false)
        $isActionMenuOpen.removeAllListeners()
        super.didRemoveFromDOM()
    }

    func renderLocation(_ store: CustStore) {
        
        guard let state = locationState(store.state) else {
            showError(.invalidFormat, "Configure un estado válido para la tienda")
            return
        }

        loadStoreFiscalProfile(store) { [weak self] profile in
            guard let self else { return }
            guard let profile else {
                showError(.requiredField, "Porfavor  configure el perfil fiscal de la cuenta ")
                return
            }

            let (street, number) = extractStreetAndNumber(from:store.street)

            self.callback(CustCommercialTripsComponents.TripLocation(
                placementType: self.viewType == .origin ? .origen : .destino,
                placementId: store.storePrefix + String(store.id.uuidString.suffix(12)),
                locationType: .store,
                locationId: store.id,
                rfc: profile.rfc,
                razon: profile.razon,
                uts: getNow(),
                storeName: store.name,
                street: street,
                number: number ?? "",
                colonie: store.colony,
                refrence: "",
                state: state,
                country: store.country,
                zipCode: store.zip,
                distance: nil,
                latitude: store.lat.flatMap { Double($0.purgeSpaces) },
                longitude: store.lon.flatMap { Double($0.purgeSpaces) }
            ))
            self.remove()
        }
    }

    private func loadStoreFiscalProfile(
        _ store: CustStore,
        callback: @escaping (FiscalComponents.Profile?) -> Void
    ) {
        if let profileId = store.fiscal {
            if let profile = fiscalProfiles.first(where: { $0.id == profileId }) {
                callback(profile)
                return
            }
        } else if let profile = fiscalProfiles.first(where: { $0.type == .account }) {
            callback(profile)
            return
        }

        if let mainProfile = fiscalProfiles.first { $0.id == store.fiscal } {
            callback(mainProfile)
            return
        }

        loadingView.show()
        
        API.fiscalV1.getProfile(type: .general, relation: nil) { response in
            loadingView.hide()

            let mainProfile = fiscalProfiles.first(where: { $0.type == .account })
            guard let response, response.status == .ok, let data = response.data else {
                callback(mainProfile)
                return
            }

            let storeProfile = data.profiles.first { $0.id == store.fiscal }
            callback(storeProfile ?? data.profiles.first(where: { $0.type == .account }) ?? mainProfile)
        }
    }

    func renderLocation(_ subaccount: CustSubAcct) {
        guard subaccount.custAcct == account.id else {
            showError(.invalidFormat, "La subcuenta no pertenece a la cuenta seleccionada")
            return
        }
        guard let state = locationState(subaccount.state) else {
            showError(.invalidFormat, "Configure un estado válido para la subcuenta")
            return
        }

        let personalName = [subaccount.firstName, subaccount.secondName, subaccount.lastName, subaccount.secondLastName]
            .map { $0.purgeSpaces }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        let storeName = subaccount.businessName.purgeSpaces.isEmpty ? personalName : subaccount.businessName

        let (street, number) = extractStreetAndNumber(from: subaccount.street)

        callback(CustCommercialTripsComponents.TripLocation(
            placementType: viewType == .origin ? .origen : .destino,
            placementId: "sa" + String(subaccount.id.uuidString.suffix(12)),
            locationType: .subaccount,
            locationId: subaccount.id,
            rfc: account.fiscalRfc,
            razon: account.fiscalRazon,
            uts: getNow(),
            storeName: storeName,
            street: street,
            number: number ?? "",
            colonie: subaccount.colony,
            refrence: "",
            state: state,
            country: subaccount.country,
            zipCode: subaccount.zip,
            distance: nil,
            latitude: subaccount.latitude,
            longitude: subaccount.longitud
        ))
        remove()
    }

    private func locationState(_ value: String) -> CountryStatesMexico? {
        func normalized(_ text: String) -> String {
            text.pseudo.lowercased().filter { !$0.isWhitespace }
        }

        let stateValue = normalized(value)
        return CountryStatesMexico.allCases.first {
            normalized($0.rawValue) == stateValue ||
            normalized($0.code) == stateValue ||
            normalized($0.description) == stateValue
        }
    }

    private func extractStreetAndNumber(from address: String) -> (street: String, number: String?) {
        let cleanAddress = address
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(
                of: "\\s+",
                with: " ",
                options: .regularExpression
            )

        // Example:
        // "Calle Morelos 123"
        // "Av. Hidalgo 456-B"
        // "16 de Septiembre 1200"
        let numberAtEndPattern = #"^(.*?)\s+(\d+[A-Za-z]?(?:[-\/]\w+)?|S\/N)$"#

        if let regex = try? NSRegularExpression(
            pattern: numberAtEndPattern,
            options: [.caseInsensitive]
        ) {
            let range = NSRange(
                cleanAddress.startIndex..<cleanAddress.endIndex,
                in: cleanAddress
            )

            if let match = regex.firstMatch(
                in: cleanAddress,
                options: [],
                range: range
            ),
            let streetRange = Range(match.range(at: 1), in: cleanAddress),
            let numberRange = Range(match.range(at: 2), in: cleanAddress) {

                let street = String(cleanAddress[streetRange])
                    .trimmingCharacters(in: .whitespaces)

                let number = String(cleanAddress[numberRange])
                    .trimmingCharacters(in: .whitespaces)

                return (
                    street: street,
                    number: number
                )
            }
        }

        return (
            street: cleanAddress,
            number: nil
        )
    }

}


extension TripControlerAddLocation {
    
    enum ViewType {
        case origin
        case destination

        var icon: String {
            switch self {
            case .origin:
                return "icon_origin.png"
            case .destination:
                return "icon_destination.png"
            }
        }

        var title: String {
            switch self {
            case .origin:
                return "Seleccionar Origen"
            case .destination:
                return "Seleccionar Destino"
            }
        }
    }

}
