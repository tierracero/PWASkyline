//
// TripControler+TripViewBeta.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/// Beta trip detail distribution built with TierraCeroCustomUI.
///
/// This view intentionally remains separate from `TripView` so it can be
/// evaluated without changing the production trip-detail flow.
final class TripViewBeta: Div {

    override class var name: String { "div" }

    let tripId: UUID

    @State var balance: Int64

    @State var fiscalId: UUID?

    @State private var status = FiscalTripFollowupStatus.pending.rawValue

    private let initialTrip: CustCommercialTripsComponents.GetTripResponse?

    private var loadedTrip: CustCommercialTripsComponents.GetTripResponse?

    private let statusChangedCallback: (UUID, FiscalTripFollowupStatus) -> Void

    init(
        tripId: UUID,
        balance: Int64 = 0,
        statusChangedCallback: @escaping (UUID, FiscalTripFollowupStatus) -> Void = { _, _ in }
    ) {
        self.tripId = tripId
        self.balance = balance
        self.initialTrip = nil
        self.statusChangedCallback = statusChangedCallback
        super.init()
    }

    init(
        trip: CustCommercialTripsComponents.GetTripResponse,
        balance: Int64 = 0,
        statusChangedCallback: @escaping (UUID, FiscalTripFollowupStatus) -> Void = { _, _ in }
    ) {
        self.tripId = trip.id
        self.balance = balance
        self.initialTrip = trip
        self.statusChangedCallback = statusChangedCallback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private lazy var statusSelect = USelectField(self.$status)
        .custom("width", "150px")
        .custom("min-height", "30px")
        .custom("padding", "5px 8px")
        .onChange { _, select in
            self.changeStatus(select.value)
        }

    private lazy var fiscalButton = USmallButton(
        self.$fiscalId.map { $0 == nil ? "Facturar" : "Ver Factura" }
    )
        .custom("background", "var(--tc-beta-orange)")
        .custom("color", "#151719")
        .onClick {
            if let fiscalId = self.fiscalId {
                self.viewFiscalDocument(fiscalId)
            } else {
                self.openFiscalTool()
            }
        }

    private lazy var summaryContent = Div()

    private lazy var routeStopsView = Div()
        .display(.grid)
        .custom("grid-template-columns", "repeat(auto-fit, minmax(260px, 1fr))")
        .custom("gap", "10px")
        .marginTop(12.px)

    private lazy var merchandiseTableView = Div()
        .custom("min-width", "900px")

    private lazy var summaryBox = VBox(.raised) {
        self.summaryContent
    }

    private lazy var routeBox = VBox {
        UTitle("Ruta del viaje")
        self.routeStopsView
    }

    private lazy var merchandiseBox = VBox {
        UTitle("Mercancía a trasladar")
        Div {
            self.merchandiseTableView
        }
        .marginTop(12.px)
        .overflow(.auto)
    }

    private lazy var operatorBox = VBox()

    private lazy var vehicleBox = VBox()

    private lazy var complianceBox = VBox()
    
    /// Charges Grid
    lazy var chargesAndPaymentsDemo = Div {

        Div{

            /*
            /// Payment
            Div{
                
                Div{
                    Img()
                        .src("/skyline/media/coin.png")
                        .marginLeft(7.px)
                        .marginTop(3.px)
                        .height(20.px)
                }
                .float(.left)
                
                Span("Pago")
            }
            .class(.uibtn)
            .float(.right)
            .onClick {
                self.openTripPayment()
            }
            */
            
            /// charge
            
            Div{
                
                Div{
                    Img()
                        .src("/skyline/media/price.png")
                        .marginLeft(7.px)
                        .marginTop(3.px)
                        .height(20.px)
                }
                .float(.left)
                
                Span("Cargo")
            }
            .class(.uibtn)
            .float(.right)
            .onClick { _ in
                self.openTripCharge()
            }
            
            H2("Cargos y pagos")
                .float(.left)
                .color(.gray)
            /*
            Div{
                
                Img()
                    .src("/skyline/media/maximizeWindow.png")
                    .class(.iconWhite)
                    .marginLeft(7.px)
                    .cursor(.pointer)
                    .marginTop(7.px)
                    .height(18.px)
                    
            }
            .float(.left)
            */
            
            Div().clear(.both)
        }
        
        Div().class(.clear).height(3.px)
        
        Div{

            Table {
                
                THead {
                    Tr{
                        Td().width(20.px)
                        Td("Unis").width(50.px)
                        Td("Descripción")
                        Td("CUni").width(70.px)
                        Td("STotal").width(70.px)
                    }
                    .color(.lightGray)
                }

                self.chargesTable
                
            }
            .width(100.percent)
            .fontSize(18.px)
            
        }
        .custom("width", "calc(100% - 240px)")
        .custom("height", "calc(100% - 46px)")
        .class(.roundGrayBlackDark)
        .padding(all: 3.px)
        .overflow(.auto)
        .float(.left)
        
        Div{
            Div{
                Span("T. Cargos")
                    .fontSize(12.px)
                    .color(.white)
                Div().class(.clear).marginTop(7.px)
                
                
                Span("T. Pagos")
                    .fontSize(12.px)
                    .color(.white)
                Div().class(.clear).marginTop(7.px)
                
                Span("Balance")
                    .fontSize(12.px)
                    .fontWeight(.bolder)
                    .color(.white)
                Div().class(.clear).marginTop(7.px)
                
            }
            .align(.right)
            .class(.oneHalf)
            .padding(all: 3.px)
            
            Div{
                Span(self.$tripChargesTotal)
                    .color(.gray)
                Div().class(.clear).marginTop(7.px)

                Span(self.$tripPaymentsTotal)
                    .color(.gray)
                Div().class(.clear).marginTop(7.px)

                Span(self.$tripBalanceTotal)
                    .fontWeight(.bolder)
                    .color(.lightGray)
                Div().class(.clear).marginTop(7.px)
            }
            .align(.left)
            .class(.oneHalf)
            .padding(all: 3.px)
            
            Div().clear(.both)
            
        }
        .float(.right)
        .fontSize(16.px)
        .width(220.px)
        
    }
    .class(Class(TCOrderViewClass.chargesCard))
    .height(23.percent)
    .marginRight(3.px)
    .overflow(.hidden)
    .marginLeft(3.px)
    .overflow(.auto)

    
    @DOM override var body: DOM.Content {
        VPopUp(.full) {
            VTitle("Detalle del Viaje · \(String(self.tripId.uuidString.prefix(8)).uppercased())") {
                USmallButton("Carta Liberación")
                    .onClick {
                        self.printReleaseLetter()
                    }

                self.fiscalButton
                self.statusSelect
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.full) {
                    self.summaryBox
                }

                VGrid(.twoThirds) {

                    self.routeBox

                    self.merchandiseBox

                    self.chargesAndPaymentsDemo
                }

                VGrid(.oneThird) {
                    self.operatorBox
                    self.vehicleBox
                    self.complianceBox
                }
            }
        }
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)

        position(.fixed)
        left(0.px)
        top(0.px)
        width(100.percent)
        height(100.percent)

        FiscalTripFollowupStatus.allCases.forEach { status in
            statusSelect.appendChild(
                Option(status.description)
                    .value(status.rawValue)
            )
        }

        if let initialTrip {
            render(initialTrip)
        } else {
            loadTrip()
        }
    }

    private func loadTrip() {
        loadingView(show: true)

        API.custCommercialTrips.getTrip(tripId: tripId) { resp in
            loadingView(show: false)

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            guard let trip = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            self.render(trip)
        }
    }

    private func render(
        _ trip: CustCommercialTripsComponents.GetTripResponse
    ) {
        loadedTrip = trip
        status = trip.status.rawValue
        balance = trip.balance
        fiscalId = trip.fiscalId

        renderSummary(trip)
        renderRoute(trip.locations)
        renderMerchandise(trip.merchandise)
        renderOperator(trip.operadorId)
        renderVehicle(trip.vehicalId, permit: trip.permitId)
        renderCompliance(trip)
        renderChargesAndPayments(trip)
    }

    private func renderSummary(
        _ trip: CustCommercialTripsComponents.GetTripResponse
    ) {
        summaryContent.innerHTML = ""

        let created = getDate(trip.createdAt).formatedShort
        let updated = getDate(trip.modifiedAt).formatedShort

        summaryContent.appendChild(
            Div {
                Div {
                    H2(trip.accountId.businessName)
                        .margin(all: 0.px)
                        .fontSize(22.px)
                        .color(.white)

                    Div("Cuenta \(trip.accountId.folio)")
                        .marginTop(4.px)
                        .color(.gray)
                }

                self.summaryMetric("Creado", created)
                self.summaryMetric("Actualizado", updated)

                Div {
                    Div("Balance")
                        .fontSize(12.px)
                        .color(.gray)

                    Div("$\(self.balance.formatMoney)")
                        .marginTop(4.px)
                        .fontSize(24.px)
                        .fontWeight(.bold)
                        .color(.white)
                }
                .custom("padding", "10px 16px")
                .custom("background", "var(--tc-beta-surface-deep)")
                .custom("border-radius", "11px")
                .custom("text-align", "right")
            }
            .display(.grid)
            .custom("grid-template-columns", "minmax(240px, 1fr) auto auto auto")
            .custom("align-items", "center")
            .custom("gap", "24px")
        )
    }

    private func summaryMetric(_ label: String, _ value: String) -> Div {
        Div {
            Div(label)
                .fontSize(12.px)
                .color(.gray)

            Div(value)
                .marginTop(4.px)
                .fontSize(15.px)
                .color(.white)
        }
        .custom("min-width", "105px")
    }

    private func renderRoute(_ locations: [FiscalLocationItem]) {
        routeStopsView.innerHTML = ""

        let orderedLocations = locations.sorted { lhs, rhs in
            lhs.position < rhs.position
        }

        guard !orderedLocations.isEmpty else {
            routeStopsView.appendChild(
                emptyState("No hay ubicaciones registradas para este viaje.")
            )
            return
        }

        orderedLocations.enumerated().forEach { index, location in
            routeStopsView.appendChild(
                routeStop(location, index: index + 1)
            )
        }
    }

    private func routeStop(_ location: FiscalLocationItem, index: Int) -> Div {
        let date = getDate(location.uts)
        let address = [
            location.street,
            location.number,
            location.state.description,
            location.zipCode
        ]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")

        return Div {
            Div {
                Div("\(index)")
                    .display(.inlineFlex)
                    .custom("align-items", "center")
                    .custom("justify-content", "center")
                    .width(28.px)
                    .height(28.px)
                    .custom("border-radius", "50%")
                    .custom("background", "rgba(24, 135, 199, 0.17)")
                    .custom("border", "1px solid var(--tc-beta-blue)")
                    .color(.lightBlueText)

                Div {
                    USmallTitle(location.placementType.description)

                    Div(location.placementId)
                        .fontSize(18.px)
                        .fontWeight(.bold)
                        .color(.white)
                }
                .marginLeft(9.px)

                if let distance = location.distance {
                    Div("\(distance.fromCents.toString) km")
                        .custom("margin-left", "auto")
                        .custom("padding", "5px 8px")
                        .custom("border", "1px solid var(--tc-beta-border)")
                        .custom("border-radius", "8px")
                        .fontSize(12.px)
                        .color(.lightBlueText)
                }
            }
            .display(.flex)
            .custom("align-items", "center")

            Div(location.rfc)
                .marginTop(12.px)
                .fontSize(13.px)
                .color(.gray)

            Div(location.razon)
                .marginTop(3.px)
                .fontSize(15.px)
                .color(.white)

            Div(address.isEmpty ? "Sin dirección registrada" : address)
                .marginTop(3.px)
                .fontSize(13.px)
                .color(.gray)

            Div {
                self.inlineMetadata("Fecha", date.formatedShort)
                self.inlineMetadata("Hora", date.time)
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("gap", "8px")
            .marginTop(14.px)
        }
        .custom("padding", "12px")
        .custom("background", "var(--tc-beta-surface-deep)")
        .custom("border", "1px solid var(--tc-beta-border)")
        .custom("border-left", "3px solid var(--tc-beta-blue)")
        .custom("border-radius", "11px")
    }

    private func inlineMetadata(_ label: String, _ value: String) -> Div {
        Div {
            Div(label)
                .fontSize(11.px)
                .color(.gray)

            Div(value)
                .marginTop(2.px)
                .fontSize(13.px)
                .color(.white)
        }
    }

    private func renderMerchandise(_ items: [FiscalMercanciaItem]) {
        merchandiseTableView.innerHTML = ""

        guard !items.isEmpty else {
            merchandiseTableView.appendChild(
                emptyState("No hay mercancía registrada para este viaje.")
            )
            return
        }

        merchandiseTableView.appendChild(
            merchandiseRow(
                [
                    "Descripción",
                    "Unis",
                    "Peso",
                    "Origen",
                    "Destino",
                    "Código Fiscal",
                    "Unidad Fiscal",
                    "Embalaje",
                    "Peligroso"
                ],
                header: true
            )
        )

        items.forEach { item in
            merchandiseTableView.appendChild(
                merchandiseRow([
                    item.description,
                    item.units.fromCents.toString,
                    item.kilograms.fromCents.toString,
                    "\(item.from) \(item.fromStoreName)",
                    "\(item.to) \(item.toStoreName)",
                    "\(item.fiscCode) \(item.fiscCodeName)",
                    "\(item.fiscUnit) \(item.fiscUnitName)",
                    item.packagingName.isEmpty ? "—" : item.packagingName,
                    item.isDangerousMatirial.rawValue
                ])
            )
        }
    }

    private func merchandiseRow(_ values: [String], header: Bool = false) -> Div {
        let row = Div()
            .display(.grid)
            .custom(
                "grid-template-columns",
                "1.35fr .42fr .48fr 1fr 1fr .95fr .9fr .75fr .58fr"
            )
            .custom("gap", "8px")
            .custom("align-items", "center")
            .custom("padding", header ? "8px 10px" : "11px 10px")
            .custom(
                "border-bottom",
                header ? "1px solid var(--tc-beta-border)" : "1px solid rgba(58, 66, 72, 0.62)"
            )

        values.forEach { value in
            row.appendChild(
                Div(value.isEmpty ? "—" : value)
                    .fontSize(header ? 11.px : 13.px)
                    .fontWeight(header ? .bold : .normal)
                    .color(header ? .gray : .white)
            )
        }

        return row
    }

    private func renderOperator(_ item: CustCommercialTripOperador) {
        operatorBox.innerHTML = ""
        operatorBox.appendChild(UTitle("Operador"))
        operatorBox.appendChild(detailRow("Tipo", item.operadorType.description))
        operatorBox.appendChild(detailRow("Nombre", item.operadorName))
        operatorBox.appendChild(detailRow("RFC", item.operadorRfc))
        operatorBox.appendChild(detailRow("Licencia", item.operadorLicens))
        operatorBox.appendChild(detailRow("Teléfono", item.operadorMobile))
    }

    private func renderVehicle(
        _ item: CustCommercialTripVehical,
        permit: CustCommercialTripPermit
    ) {
        vehicleBox.innerHTML = ""
        vehicleBox.appendChild(UTitle("Vehículo y permiso"))
        vehicleBox.appendChild(detailRow(
            "Placas / Modelo",
            "\(item.vehicalLicensePlate) / \(item.vehicalYearModel)"
        ))
        vehicleBox.appendChild(detailRow(
            "Tipo de Transporte",
            "\(item.autotransporteCode) \(item.autotransporteName)"
        ))
        vehicleBox.appendChild(detailRow("Tipo de Permiso", permit.permitTypeName))
        vehicleBox.appendChild(detailRow("Número de Permiso", permit.permitNumber))
        vehicleBox.appendChild(detailRow("Peso bruto", item.vehicalWeight.description))
    }

    private func renderCompliance(
        _ trip: CustCommercialTripsComponents.GetTripResponse
    ) {
        complianceBox.innerHTML = ""
        complianceBox.appendChild(UTitle("Cumplimiento"))
        complianceBox.appendChild(sectionDivider("Pólizas de seguro"))
        complianceBox.appendChild(insuranceRow("Civil", trip.insuranceCivilId))
        complianceBox.appendChild(insuranceRow("Ambiental", trip.insuranceAmbientId))
        complianceBox.appendChild(insuranceRow("Carga", trip.insurancePayloadId))
        complianceBox.appendChild(detailRow(
            "Material peligroso",
            trip.hasDangerousMaterial ? "Sí" : "No"
        ))
        complianceBox.appendChild(sectionDivider("Remolques"))

        if trip.remolques.isEmpty {
            complianceBox.appendChild(
                complianceRow(
                    title: "No requiere remolque",
                    detail: "",
                    status: "OK",
                    positive: true
                )
            )
        } else {
            trip.remolques.enumerated().forEach { index, item in
                complianceBox.appendChild(
                    complianceRow(
                        title: "Remolque \(index + 1)",
                        detail: "\(item.type.description) · \(item.name) · \(item.licensPlates)",
                        status: "Asignado",
                        positive: true
                    )
                )
            }
        }
    }

    private func insuranceRow(
        _ title: String,
        _ item: CustCommercialTripInsurance?
    ) -> Div {
        guard let item else {
            return complianceRow(
                title: title,
                detail: "Sin póliza",
                status: "Sin póliza",
                positive: false
            )
        }

        return complianceRow(
            title: title,
            detail: "\(item.provider) · \(item.policyNumber) · $\(item.insuredAmount.formatMoney)",
            status: "Cubierto",
            positive: true
        )
    }

    private func complianceRow(
        title: String,
        detail: String,
        status: String,
        positive: Bool
    ) -> Div {
        Div {
            Div {
                Div(title)
                    .fontSize(14.px)
                    .color(.white)

                if !detail.isEmpty {
                    Div(detail)
                        .marginTop(3.px)
                        .fontSize(11.px)
                        .color(.gray)
                }
            }

            Div(status)
                .custom("padding", "5px 8px")
                .custom("border-radius", "7px")
                .custom(
                    "background",
                    positive ? "rgba(87, 154, 75, 0.22)" : "rgba(214, 82, 61, 0.22)"
                )
                .custom("color", positive ? "#8bd17f" : "#ff7866")
                .fontSize(11.px)
                .fontWeight(.bold)
        }
        .display(.grid)
        .custom("grid-template-columns", "minmax(0, 1fr) auto")
        .custom("align-items", "center")
        .custom("gap", "10px")
        .custom("padding", "8px 0")
        .custom("border-bottom", "1px solid rgba(58, 66, 72, 0.58)")
    }

    private func sectionDivider(_ title: String) -> Div {
        Div {
            USmallTitle(title)

            Div()
                .height(1.px)
                .custom("background", "var(--tc-beta-border)")
        }
        .display(.grid)
        .custom("grid-template-columns", "auto minmax(20px, 1fr)")
        .custom("align-items", "center")
        .custom("gap", "10px")
        .marginTop(14.px)
    }

    private func detailRow(_ label: String, _ value: String) -> Div {
        Div {
            Div(label)
                .fontSize(12.px)
                .color(.gray)

            Div(value.isEmpty ? "Sin información" : value)
                .fontSize(13.px)
                .color(.white)
                .custom("text-align", "right")
        }
        .display(.grid)
        .custom("grid-template-columns", "minmax(110px, .8fr) minmax(0, 1.2fr)")
        .custom("align-items", "start")
        .custom("gap", "10px")
        .custom("padding", "8px 0")
        .custom("border-bottom", "1px solid rgba(58, 66, 72, 0.58)")
    }

    private func emptyState(_ text: String) -> Div {
        Div(text)
            .custom("padding", "20px")
            .custom("text-align", "center")
            .fontSize(13.px)
            .color(.gray)
    }

    private func openFiscalTool() {
        guard let trip = loadedTrip else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }

        let cartaPorte = CustFiscalCartaPorteItem(
            operadorType: trip.operadorId.operadorType,
            operadorName: trip.operadorId.operadorName,
            operadorRfc: trip.operadorId.operadorRfc,
            operadorLicens: trip.operadorId.operadorLicens,
            vehicalType: trip.vehicalId.vehicalType,
            vehicalTypeName: trip.vehicalId.vehicalTypeName,
            vehicalLicensePlate: trip.vehicalId.vehicalLicensePlate,
            vehicalYearModel: trip.vehicalId.vehicalYearModel,
            vehicalWeight: trip.vehicalId.vehicalWeight,
            permitType: trip.permitId.permitType,
            permitTypeName: trip.permitId.permitTypeName,
            permitNumber: trip.permitId.permitNumber,
            hasDangerousMatirial: trip.hasDangerousMaterial,
            insuranceCivilProvider: trip.insuranceCivilId?.provider ?? "",
            insuranceCivilNumber: trip.insuranceCivilId?.policyNumber ?? "",
            insuranceAmbinetProvider: trip.insuranceAmbientId?.provider ?? "",
            insuranceAmbinetNumber: trip.insuranceAmbientId?.policyNumber ?? "",
            insurancePayloadProvider: trip.insurancePayloadId?.provider ?? "",
            insurancePayloadNumber: trip.insurancePayloadId?.policyNumber ?? "",
            insuranceAmount: trip.insurancePayloadId?.insuredAmount ?? 0,
            remolques: trip.remolques,
            locations: trip.locations,
            merchandise: trip.merchandise,
            status: trip.status
        )

        let fiscalView = ToolFiscal(
            loadType: .comertialTrip(
                tripId: trip.id,
                balance: trip.balance,
                cartaPorte: cartaPorte
            ),
            folio: String(trip.id.uuidString.prefix(8)).uppercased()
        ) { id, _, _, _ in
            self.fiscalId = id
        }

        searchAccountFiscal(term: trip.accountId.folio) { _, resp in
            if resp.count == 1 {
                fiscalView.reciver = resp.first
            }
        }

        addToDom(fiscalView)
    }

    private func printReleaseLetter() {
        guard let trip = loadedTrip else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }

        let printBody = TripPrintEngine(trip: trip).innerHTML

        _ = JSObject.global.renderGeneralPrint!(
            custCatchUrl,
            trip.folio,
            printBody
        )
    }

    private func changeStatus(_ rawValue: String) {
        guard let newStatus = FiscalTripFollowupStatus(rawValue: rawValue) else {
            showError(.unexpectedResult, "Estatus de viaje invalido.")
            return
        }

        guard let currentStatus = loadedTrip?.status else {
            status = newStatus.rawValue
            return
        }

        guard currentStatus != newStatus else {
            return
        }

        loadingView(show: true)

        API.custCommercialTrips.changeTripStatus(
            tripId: tripId,
            status: newStatus
        ) { resp in
            loadingView(show: false)

            guard let resp else {
                self.status = currentStatus.rawValue
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                self.status = currentStatus.rawValue
                showError(.generalError, resp.msg)
                return
            }

            self.loadedTrip?.status = newStatus
            self.status = newStatus.rawValue
            self.statusChangedCallback(self.tripId, newStatus)
            showSuccess(.operacionExitosa, "Estatus actualizado")
        }
    }

    private func viewFiscalDocument(_ id: UUID) {
        loadingView(show: true)

        API.fiscalV1.loadDocument(docid: id) { resp in
            loadingView(show: false)

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data.")
                return
            }

            let view = ToolFiscalViewDocument(
                type: payload.type,
                doc: payload.doc,
                reldocs: payload.reldocs,
                account: payload.account
            ) {
                self.fiscalId = nil
            }

            addToDom(view)
        }
    }

    // MARK: Charges and payments

    @State private var tripChargesTotal = "—"

    @State private var tripPaymentsTotal = "—"

    @State private var tripBalanceTotal = "$0.00"

    private lazy var chargesTable = TBody()

    private func renderChargesAndPayments(
        _ trip: CustCommercialTripsComponents.GetTripResponse
    ) {
        chargesTable.innerHTML = ""
        tripChargesTotal = trip.balance.formatMoney
        tripPaymentsTotal = "$0.00"
        tripBalanceTotal = trip.balance.formatMoney

        chargesTable.appendChild(
            Tr {
                Td("✎")
                    .width(20.px)

                Td("1.0")
                    .width(50.px)

                Td("Costo del viaje")

                Td(trip.balance.formatMoney)
                    .width(70.px)
                    .align(.right)

                Td(trip.balance.formatMoney)
                    .width(70.px)
                    .align(.right)
            }
            .color(.gray)
        )
    }

    private func openTripPayment() {
        guard let trip = loadedTrip else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }

        showAlert(
            .alerta,
            "Los pagos para viajes no están disponibles. Consulte la cuenta \(trip.accountId.folio)."
        )
    }

    private func openTripCharge() {
        guard let trip = loadedTrip else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }

        showAlert(
            .alerta,
            "Los cargos para viajes no están disponibles. Consulte la cuenta \(trip.accountId.folio)."
        )
    }
    
}
