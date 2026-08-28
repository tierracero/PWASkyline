//
//  Tools+HistorySettings+TripProcessing+Settings.swift
//  
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals
import Web

extension ToolsView.HistorySettings.TripProcessing {

    class Settings: Div {

        override class var name: String { "div" }

        var operadors: [CustCommercialTripOperador]

        var insurances: [CustCommercialTripInsurance]

        var permits: [CustCommercialTripPermit]

        var vehicals: [CustCommercialTripVehical]

        var trailers: [CustCommercialTripTrailer]

        var merchendises: [FiscalMercanciaBase]

        var baseLocationsOrigin: [FiscalLocationBase] = []

        var baseLocationsDestination: [FiscalLocationBase] = []

        init(
            operadors: [CustCommercialTripOperador],
            insurances: [CustCommercialTripInsurance],
            permits: [CustCommercialTripPermit],
            vehicals: [CustCommercialTripVehical],
            trailers: [CustCommercialTripTrailer],
            merchendises: [FiscalMercanciaBase],
            locations: [FiscalLocationBase]
        ) {
            self.operadors = operadors
            self.insurances = insurances
            self.permits = permits
            self.vehicals = vehicals
            self.trailers = trailers
            self.merchendises = merchendises
            self.baseLocationsOrigin = locations.filter { $0.placementType == .origen }
            self.baseLocationsDestination = locations.filter { $0.placementType == .destino }

            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        private lazy var operadorItems = Div()
        private lazy var insuranceItems = Div()
        private lazy var permitItems = Div()
        private lazy var vehicalItems = Div()
        private lazy var trailerItems = Div()
        private lazy var merchendiseItems = Div()
        private lazy var originItems = Div()
        private lazy var destinationItems = Div()
        private lazy var summaryItems = Div()

        private var insuranceGrid: VGrid {
            VGrid(.oneThird) {
                Div {
                    Div {

                        Img()
                        .src("/skyline/media/icon_insurance.png")
                        .paddingRight(7.px)
                        .class(.iconBlue)
                        .height(24.px)
                        .float(.left)

                        H2("Seguros")
                            .color(.white)
                            .margin(all: 0.px)
                            .fontSize(18.px)
                            .float(.left)

                        Div {
                            self.insuranceCreateButton(
                                type: .civil,
                                title: ComertialTripInsuranceType.civil.description
                            )

                            self.insuranceCreateButton(
                                type: .ambient,
                                title: ComertialTripInsuranceType.ambient.description
                            )

                            self.insuranceCreateButton(
                                type: .payload,
                                title: ComertialTripInsuranceType.payload.description
                            )
                        }
                        .custom("flex-wrap", "wrap")
                        .custom("gap", "5px")
                        .display(.flex)
                        .float(.right)

                        Div().clear(.both)
                    }
                    .display(.block)
                    .custom("align-items", "center")
                    .custom("justify-content", "space-between")
                    .custom("gap", "8px")
                    .custom("min-height", "36px")

                    Div {
                        self.insuranceItems
                    }
                    .custom("height", "calc(100% - 42px)")
                    .custom("min-height", "0")
                    .overflow(.auto)
                    .marginTop(7.px)
                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxRaised)
                )
                .height(100.percent)
            }
            .height(100.percent)
            .custom("min-width", "0")
        }

        @DOM override var body: DOM.Content {

            Div {
                self.settingsGrid(
                    icon: "icon_operador.png",
                    title: "Operadores",
                    items: self.operadorItems,
                    create: { self.manageOperator() }
                )

                self.insuranceGrid

                self.settingsGrid(
                    icon: "icon_permition.png",
                    title: "Permisos",
                    items: self.permitItems,
                    create: { self.managePermit() }
                )
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(12, minmax(0, 1fr))")
            .custom("grid-auto-rows", "300px")
            .custom("gap", "12px")
            .custom("min-height", "0")

            Div().height(12.px).clear(.both)

            Div {
                self.settingsGrid(
                    icon: "icon_vehical.png",
                    title: "Vehículos",
                    items: self.vehicalItems,
                    create: { self.manageVehical() }
                )

                self.settingsGrid(
                    icon: "icon_trailer.png",
                    title: "Remolques",
                    items: self.trailerItems,
                    create: { self.manageTrailer() }
                )

                self.settingsGrid(
                    icon: "icon_merchandise.png",
                    title: "Mercancías",
                    items: self.merchendiseItems,
                    create: { self.manageMerchendise() }
                )
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(12, minmax(0, 1fr))")
            .custom("grid-auto-rows", "300px")
            .custom("gap", "12px")
            .custom("min-height", "0")

            Div().height(12.px).clear(.both)

            Div {
                self.settingsGrid(
                    icon: "icon_origin.png",
                    title: "Orígenes",
                    items: self.originItems,
                    create: { self.manageLocation(placementType: .origen) }
                )

                self.settingsGrid(
                    icon: "icon_destination.png",
                    title: "Destinos",
                    items: self.destinationItems,
                    create: { self.manageLocation(placementType: .destino) }
                )

            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(12, minmax(0, 1fr))")
            .custom("grid-auto-rows", "300px")
            .custom("gap", "12px")
            .custom("min-height", "0")
        }

        override func buildUI() {
            super.buildUI()

            TCTripBetaTheme.apply(to: self)
            TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

            height(100.percent)
            overflow(.auto)

            renderOperadors()
            renderInsurances()
            renderPermits()
            renderVehicals()
            renderTrailers()
            renderMerchendises()
            renderLocations()
            renderSummary()
        }

        private func settingsGrid(
            icon: String,
            title: String,
            items: Div,
            create: @escaping () -> Void,
            showCreate: Bool = true
        ) -> VGrid {
            VGrid(.oneThird) {
                Div {
                    Div {

                        Img()
                            .src("/skyline/media/\(icon)")
                            .paddingRight(7.px)
                            .class(.iconBlue)
                            .height(24.px)
                            .float(.left)

                        H2(title)
                            .color(.white)
                            .margin(all: 0.px)
                            .fontSize(18.px)
                            .float(.left)

                        if showCreate {
                            Div("+ Agregar")
                            .float(.right)
                                .class(
                                    Class(TCTripBetaClass.uiButton),
                                    Class(TCTripBetaClass.uiSmallButton)
                                )
                                .onClick {
                                    create()
                                }
                        }

                        Div().clear(.both)
                    }
                    .custom("justify-content", "space-between")
                    .custom("align-items", "center")
                    .custom("min-height", "36px")
                    .custom("gap", "8px")
                    .display(.block)

                    Div {
                        items
                    }
                    .custom("height", "calc(100% - 42px)")
                    .custom("min-height", "0")
                    .overflow(.auto)
                    .marginTop(7.px)
                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxRaised)
                )
                .height(100.percent)
            }
            .height(100.percent)
            .custom("min-width", "0")
        }

        private func insuranceCreateButton(
            type: ComertialTripInsuranceType,
            title: String
        ) -> Div {
            Div("+ \(title)")
                .class(
                    Class(TCTripBetaClass.uiButton),
                    Class(TCTripBetaClass.uiSmallButton)
                )
                .onClick {
                    self.manageInsurance(type)
                }
        }

        private func itemCard(
            title: String,
            subtitle: String,
            avatar: String? = nil,
            showAvatar: Bool = false,
            onClick: @escaping () -> Void
        ) -> Div {
            Div {
                if showAvatar {
                    tripAvatarImage(avatar)
                        .width(44.px)
                        .height(44.px)
                        .borderRadius(all: 8.px)
                        .custom("object-fit", "contain")
                }

                Div {
                    Div(title)
                        .class(.oneLineText)
                        .color(.white)
                        .fontSize(15.px)

                    Div(subtitle)
                        .class(.oneLineText)
                        .color(.gray)
                        .fontSize(12.px)
                        .marginTop(3.px)
                }
                .custom("min-width", "0")
            }
            .class(
                Class(TCTripBetaClass.box),
                Class(TCTripBetaClass.boxStandard),
                Class(TCTripBetaClass.boxInteractive)
            )
            .display(.flex)
            .custom("align-items", "center")
            .custom("gap", "10px")
            .padding(top: 10.px, right: 11.px, bottom: 10.px, left: 11.px)
            .marginBottom(7.px)
            .onClick {
                onClick()
            }
        }

        private func renderOperadors() {
            operadorItems.innerHTML = ""

            if operadors.isEmpty {
                operadorItems.appendChild(emptyState("No hay operadores registrados"))
                return
            }

            operadors.forEach { item in
                operadorItems.appendChild(
                    itemCard(
                        title: "\(item.operadorType.description): \(item.operadorName)",
                        subtitle: "RFC \(item.operadorRfc) | Licencia \(item.operadorLicens) | Tel. \(item.operadorMobile)",
                        avatar: item.avatar,
                        showAvatar: true
                    ) {
                        self.manageOperator(item)
                    }
                )
            }
        }

        private func renderInsurances() {
            insuranceItems.innerHTML = ""

            if insurances.isEmpty {
                insuranceItems.appendChild(emptyState("No hay pólizas registradas"))
                return
            }

            insurances.forEach { item in
                insuranceItems.appendChild(
                    itemCard(
                        title: "\(item.type.description): \(item.provider)",
                        subtitle: "Póliza \(item.policyNumber) | Monto \(item.insuredAmount.formatMoney) | Tel. \(item.providerPhone)"
                    ) {
                        self.manageInsurance(item.type, item: item)
                    }
                )
            }
        }

        private func renderPermits() {
            permitItems.innerHTML = ""

            if permits.isEmpty {
                permitItems.appendChild(emptyState("No hay permisos registrados"))
                return
            }

            permits.forEach { item in
                permitItems.appendChild(
                    itemCard(
                        title: item.permitTypeName,
                        subtitle: "\(item.permitName.isEmpty ? "Sin propietario" : item.permitName) | Permiso \(item.permitNumber)"
                    ) {
                        self.managePermit(item)
                    }
                )
            }
        }

        private func renderVehicals() {
            vehicalItems.innerHTML = ""

            if vehicals.isEmpty {
                vehicalItems.appendChild(emptyState("No hay vehículos registrados"))
                return
            }

            vehicals.forEach { item in
                vehicalItems.appendChild(
                    itemCard(
                        title: "\(item.vehicalTypeName) \(item.vehicalType)",
                        subtitle: "Placas \(item.vehicalLicensePlate) | Año \(item.vehicalYear) | Modelo \(item.vehicalModel) | Marca \(item.vehicalMake) | Peso \(item.vehicalWeight)",
                        avatar: item.avatar,
                        showAvatar: true
                    ) {
                        self.manageVehical(item)
                    }
                )
            }
        }

        private func renderTrailers() {
            trailerItems.innerHTML = ""

            if trailers.isEmpty {
                trailerItems.appendChild(emptyState("No hay remolques registrados"))
                return
            }

            trailers.forEach { item in
                trailerItems.appendChild(
                    itemCard(
                        title: item.name,
                        subtitle: "\(item.type.description) | Serie \(item.series)",
                        avatar: item.avatar,
                        showAvatar: true
                    ) {
                        self.manageTrailer(item)
                    }
                )
            }
        }

        private func renderMerchendises() {
            merchendiseItems.innerHTML = ""

            if merchendises.isEmpty {
                merchendiseItems.appendChild(emptyState("No hay mercancías registradas"))
                return
            }

            merchendises.forEach { item in
                merchendiseItems.appendChild(
                    itemCard(
                        title: "\(item.fiscCode) \(item.description)",
                        subtitle: "Unidad \(item.fiscUnitName) | Peso \(item.kilograms.fromCents.toString) kg"
                    ) {
                        self.manageMerchendise(item)
                    }
                )
            }
        }

        private func renderLocations() {
            originItems.innerHTML = ""
            destinationItems.innerHTML = ""

            if baseLocationsOrigin.isEmpty {
                originItems.appendChild(emptyState("No hay ubicaciones de origen"))
            }
            else {
                baseLocationsOrigin.forEach { item in
                    originItems.appendChild(
                        itemCard(
                            title: "\(item.placementId) \(item.storeName)",
                            subtitle: "\(item.colonie) \(item.state) | RFC \(item.rfc)"
                        ) {
                            self.manageLocation(item)
                        }
                    )
                }
            }

            if baseLocationsDestination.isEmpty {
                destinationItems.appendChild(emptyState("No hay ubicaciones de destino"))
            }
            else {
                baseLocationsDestination.forEach { item in
                    destinationItems.appendChild(
                        itemCard(
                            title: "\(item.placementId) \(item.storeName)",
                            subtitle: "\(item.colonie) \(item.state) | RFC \(item.rfc)"
                        ) {
                            self.manageLocation(item)
                        }
                    )
                }
            }
        }

        private func renderSummary() {
            summaryItems.innerHTML = ""

            let summary = [
                "Operadores: \(operadors.count)",
                "Pólizas: \(insurances.count)",
                "Permisos: \(permits.count)",
                "Vehículos: \(vehicals.count)",
                "Remolques: \(trailers.count)",
                "Mercancías: \(merchendises.count)",
                "Ubicaciones: \(baseLocationsOrigin.count + baseLocationsDestination.count)"
            ]

            summary.forEach { item in
                summaryItems.appendChild(
                    Div(item)
                        .color(.white)
                        .fontSize(14.px)
                        .padding(top: 7.px, right: 9.px, bottom: 7.px, left: 9.px)
                        .marginBottom(5.px)
                        .custom("border-left", "3px solid #252c3b")
                )
            }
        }

        private func manageOperator(_ item: CustCommercialTripOperador? = nil) {
            if let item {
                loadingView.show()

                API.custCommercialTrips.getOperador(operadorId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(TripControlerManageOperator(item: payload.item) { result in
                        self.handleOperator(result)
                    })
                }
                return
            }

            addToDom(TripControlerManageOperator { result in
                self.handleOperator(result)
            })
        }

        private func manageInsurance(
            _ type: ComertialTripInsuranceType,
            item: CustCommercialTripInsurance? = nil
        ) {
            if let item {
                loadingView.show()

                API.custCommercialTrips.getInsurance(insuranceId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(TripControlerManageInsurance(item: payload.item) { result in
                        self.handleInsurance(result)
                    })
                }
                return
            }

            addToDom(TripControlerManageInsurance(type: type) { result in
                self.handleInsurance(result)
            })
        }

        private func managePermit(_ item: CustCommercialTripPermit? = nil) {
            if let item {
                loadingView.show()

                API.custCommercialTrips.getPermit(permitId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(TripControlerManagePermit(item: payload.item) { result in
                        self.handlePermit(result)
                    })
                }
                return
            }

            addToDom(TripControlerManagePermit { result in
                self.handlePermit(result)
            })
        }

        private func manageVehical(_ item: CustCommercialTripVehical? = nil) {
            if let item {
                loadingView.show()

                API.custCommercialTrips.getVehical(vehicalId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(TripControlerManageVehical(item: payload.item) { result in
                        self.handleVehical(result)
                    })
                }
                return
            }

            addToDom(TripControlerManageVehical { result in
                self.handleVehical(result)
            })
        }

        private func manageTrailer(_ item: CustCommercialTripTrailer? = nil) {
            if let item {
                loadingView.show()

                API.custCommercialTrips.getTrailer(trailerId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(TripControlerManageTrailer(item: payload.item) { result in
                        self.handleTrailer(result)
                    })
                }
                return
            }

            addToDom(TripControlerManageTrailer { result in
                self.handleTrailer(result)
            })
        }

        private func manageMerchendise(_ item: FiscalMercanciaBase? = nil) {
            if let item {
                loadingView.show()

                API.custCommercialTrips.getMerchandise(merchandiseId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(TripControlerManageMerchendiseBase(item: payload.item) { result in
                        self.handleMerchendise(result)
                    })
                }
                return
            }

            addToDom(TripControlerManageMerchendiseBase { result in
                self.handleMerchendise(result)
            })
        }

        private func manageLocation(
            _ item: FiscalLocationBase? = nil,
            placementType: TipoUbicacion? = nil
        ) {
            let currentPlacementCount: Int

            switch placementType {
            case .origen:
                currentPlacementCount = 0

            case .destino:
                currentPlacementCount = 1

            case nil:
                currentPlacementCount = baseLocationsOrigin.count + baseLocationsDestination.count
            }

            if let item {
                loadingView.show()

                API.custCommercialTrips.getLocation(locationId: item.id) { resp in
                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
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

                    addToDom(ManageLocationBase(
                        item: payload.item,
                        currentPlacementCount: currentPlacementCount
                    ) { result in
                        self.handleLocation(result)
                    })
                }
                return
            }

            addToDom(ManageLocationBase(currentPlacementCount: currentPlacementCount) { result in
                self.handleLocation(result)
            })
        }

        private func handleOperator(
            _ result: TripControlerManageOperator.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                if let index = operadors.firstIndex(where: { $0.id == item.id }) {
                    operadors[index] = item
                }
                else {
                    operadors.append(item)
                }

            case .delete(let id):
                operadors.removeAll { $0.id == id }
            }

            renderOperadors()
            renderSummary()
        }

        private func handleInsurance(
            _ result: TripControlerManageInsurance.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                if let index = insurances.firstIndex(where: { $0.id == item.id }) {
                    insurances[index] = item
                }
                else {
                    insurances.append(item)
                }

            case .delete(let id):
                insurances.removeAll { $0.id == id }
            }

            renderInsurances()
            renderSummary()
        }

        private func handlePermit(
            _ result: TripControlerManagePermit.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                if let index = permits.firstIndex(where: { $0.id == item.id }) {
                    permits[index] = item
                }
                else {
                    permits.append(item)
                }

            case .delete(let id):
                permits.removeAll { $0.id == id }
            }

            renderPermits()
            renderSummary()
        }

        private func handleVehical(
            _ result: TripControlerManageVehical.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                if let index = vehicals.firstIndex(where: { $0.id == item.id }) {
                    vehicals[index] = item
                }
                else {
                    vehicals.append(item)
                }

            case .delete(let id):
                vehicals.removeAll { $0.id == id }
            }

            renderVehicals()
            renderSummary()
        }

        private func handleTrailer(
            _ result: TripControlerManageTrailer.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                if let index = trailers.firstIndex(where: { $0.id == item.id }) {
                    trailers[index] = item
                }
                else {
                    trailers.append(item)
                }

            case .delete(let id):
                trailers.removeAll { $0.id == id }
            }

            renderTrailers()
            renderSummary()
        }

        private func handleMerchendise(
            _ result: TripControlerManageMerchendiseBase.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                if let index = merchendises.firstIndex(where: { $0.id == item.id }) {
                    merchendises[index] = item
                }
                else {
                    merchendises.append(item)
                }

            case .delete(let id):
                merchendises.removeAll { $0.id == id }
            }

            renderMerchendises()
            renderSummary()
        }

        private func handleLocation(
            _ result: ManageLocationBase.CallbackType
        ) {
            switch result {
            case .create(let item), .update(let item):
                baseLocationsOrigin.removeAll { $0.id == item.id }
                baseLocationsDestination.removeAll { $0.id == item.id }

                if item.placementType == .origen {
                    baseLocationsOrigin.append(item)
                }
                else {
                    baseLocationsDestination.append(item)
                }

            case .delete(let id):
                baseLocationsOrigin.removeAll { $0.id == id }
                baseLocationsDestination.removeAll { $0.id == id }
            }

            renderLocations()
            renderSummary()
        }

    }

}
