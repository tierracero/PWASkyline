//
// TripControler+TripView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripView: Div {

    override class var name: String { "div" }

    let tripId: UUID

    @State var balance: Int64

    @State var fiscalId: UUID?

    private let initialTrip: CustCommercialTripsComponents.GetTripResponse?

    private var loadedTrip: CustCommercialTripsComponents.GetTripItem?

    private var loadedAccount: CustAcctQuick?

    private let statusChangedCallback: (UUID, FiscalTripFollowupStatus) -> ()

    @State private var status = FiscalTripFollowupStatus.pending.rawValue

    init(
        tripId: UUID,
        balance: Int64 = 0,
        statusChangedCallback: @escaping (UUID, FiscalTripFollowupStatus) -> () = { _, _ in }
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
        statusChangedCallback: @escaping (UUID, FiscalTripFollowupStatus) -> () = { _, _ in }
    ) {
        self.tripId = trip.trip.id
        self.balance = trip.trip.balance
        self.initialTrip = trip
        self.statusChangedCallback = statusChangedCallback

        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    lazy var summaryView = Div()
        .custom("box-sizing", "border-box")
        .class(.roundGrayBlackDark)
        .padding(all: 10.px)
        .height(82.px)

    lazy var statusSelect = Select(self.$status)
        .class(.textFiledBlackDark)
        .height(31.px)
        .width(150.px)
        .onChange { _, select in
            self.changeStatus(select.value)
        }

    lazy var operadorPanel = tripPanel(title: "Operador")

    lazy var vehicalPanel = tripPanel(title: "Vehiculo y permiso")

    lazy var insurancePanel = tripPanel(title: "Polizas de seguro")

    lazy var trailerPanel = tripPanel(title: "Remolques")

    lazy var merchandiseGrid = Div()
        .border(width: .thin, style: .solid, color: .dodgerBlue)
        .custom("height", "calc(100% - 40px)")
        .borderRadius(all: 10.px)
        .overflow(.auto)

    lazy var locationGrid = Div()
        .border(width: .thin, style: .solid, color: .dodgerBlue)
        .custom("height", "calc(100% - 40px)")
        .borderRadius(all: 10.px)
        .overflow(.auto)


    @DOM override var body: DOM.Content {
        Div {

            Div {
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        self.remove()
                    }


                Div{
                    self.statusSelect
                }
                    .marginRight(7.px)
                    .float(.right)

                Div("Carta Liberación")
                    .class(.uibtn)
                    .float(.right)
                    .marginRight(7.px)
                    .onClick {
                        self.printReleaseLetter()
                    }

                Div(self.$fiscalId.map{ ($0 == nil) ? "Facturar" :"Ver Factura" })
                    .class(.uibtn)
                    .float(.right)
                    .marginRight(7.px)
                    .onClick {

                        if let fiscalId = self.fiscalId {
                            self.viewFiscalDocument(fiscalId)
                        }
                        else {
                            self.openFiscalTool()
                        }
                    }

                H2("Detalle del Viaje")
                    .color(.lightBlueText)
                    .margin(all: 0.px)

                Div().class(.clear)
            }

            Div().class(.clear).height(8.px)

            self.summaryView

            Div().class(.clear).height(10.px)

            Div {
                self.operadorPanel
                self.vehicalPanel
                self.insurancePanel
                self.trailerPanel
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(4, minmax(0, 1fr))")
            .custom("gap", "10px")
            .height(230.px)

            Div().class(.clear).height(10.px)

            Div {

                VGrid(.oneThird) {
                    H2("Mercancia a trasladar")
                        .marginBottom(4.px)
                        .marginTop(0.px)
                        .color(.white)

                    self.merchandiseGrid
                }
                .float(.left)
                .width(33.percent)

                VGrid(.oneThird) {
                    H2("Ubicaciones")
                        .marginBottom(4.px)
                        .marginTop(0.px)
                        .color(.white)

                    self.locationGrid
                }
                .float(.left)
                .width(33.percent)

                VGrid(.oneThird) {

                }
                .float(.left)
                .width(33.percent)

            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(3, minmax(0, 1fr))")
            .custom("height", "calc(100% - 357px)")
            .custom("gap", "10px")

        }
        .custom("left", "calc(5% - 12px)")
        .custom("top", "calc(10% - 12px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(80.percent)
        .width(90.percent)
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)

        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)

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
        _ response: CustCommercialTripsComponents.GetTripResponse
    ) {
        let trip = response.trip

        loadedTrip = trip
        loadedAccount = response.account
        status = trip.status.rawValue

        balance = trip.balance

        fiscalId = trip.fiscalId

        renderSummary(trip, account: response.account)
        renderOperador(trip.operadorId)
        renderVehical(trip.vehicalId, permit: trip.permitId)
        renderInsurances(trip)
        renderTrailers(trip.remolques)

        merchandiseGrid.innerHTML = ""
        trip.merchandise.forEach { item in
            merchandiseGrid.appendChild(
                CartaPorteMerchendise(
                    merchadise: item,
                    canRemove: false
                ) { _ in }
            )
        }

        locationGrid.innerHTML = ""
        trip.locations.forEach { item in
            locationGrid.appendChild(
                CartaPorteUbicacion(
                    placement: item,
                    canRemove: false
                ) { _ in }
            )
        }
    }

    private func renderSummary(
        _ trip: CustCommercialTripsComponents.GetTripItem,
        account: CustAcctQuick
    ) {
        summaryView.innerHTML = ""

        summaryView.appendChild(
            Div {

                Div {
                    Div {
                        Label("Balance")
                            .color(.gray)

                        InputText("$\(self.balance.formatMoney)")
                            .class(.textFiledBlackDark)
                            .height(31.px)
                            .width(130.px)
                            .disabled(true)
                    }
                    .float(.right)
                    .marginLeft(7.px)
                }
                .float(.right)

                H3(account.businessName)
                    .margin(all: 0.px)
                    .color(.white)

                Div("Cuenta \(account.folio) | Viaje \(String(trip.id.uuidString.prefix(8)).uppercased())")
                    .class(.oneLineText)
                    .color(.gray)

                Div("Creado \(getDate(trip.createdAt).formatedShort) | Actualizado \(getDate(trip.modifiedAt).formatedShort)")
                    .class(.oneLineText)
                    .fontSize(13.px)
                    .color(.gray)
            }
        )
    }

    private func openFiscalTool() {

        guard let trip = loadedTrip, let account = loadedAccount else {
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
            loadType: .comertialTrip(tripId: trip.id, balance: trip.balance, cartaPorte: cartaPorte),
            folio: String(trip.id.uuidString.prefix(8)).uppercased()
        ) { id, folio, pdf, xml in
            self.fiscalId = id
        }

        searchAccountFiscal(term: account.folio) { _, resp in
                if resp.count == 1, let reciver = resp.first {
                    fiscalView.reciver = reciver
                }
        }

        addToDom(fiscalView)
    }

    private func printReleaseLetter() {

        guard let trip = loadedTrip, let account = loadedAccount else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }

        let printBody = TripPrintEngine(
            trip: trip,
            account: account
        ).innerHTML

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

    private func renderOperador(_ item: CustCommercialTripOperador) {
        resetPanel(operadorPanel, title: "Operador")
        operadorPanel.appendChild(detailField("Tipo de Operador", item.operadorType.description))
        operadorPanel.appendChild(detailField("Nombre del Operador", item.operadorName))
        operadorPanel.appendChild(detailField("RFC del Operador", item.operadorRfc))
        operadorPanel.appendChild(detailField("Licencia del Operador", item.operadorLicens))
        operadorPanel.appendChild(detailField("Telefono del Operador", item.operadorMobile))
    }

    private func renderVehical(
        _ item: CustCommercialTripVehical,
        permit: CustCommercialTripPermit
    ) {
        resetPanel(vehicalPanel, title: "Vehiculo y permiso")
        vehicalPanel.appendChild(detailField(
            "Placas / Modelo",
            "\(item.vehicalLicensePlate) / \(item.vehicalYearModel)"
        ))
        vehicalPanel.appendChild(detailField(
            "Tipo de Transporte",
            "\(item.autotransporteCode) \(item.autotransporteName)"
        ))
        vehicalPanel.appendChild(detailField("Tipo de Permiso", permit.permitTypeName))
        vehicalPanel.appendChild(detailField("Numero de Permiso", permit.permitNumber))
    }

    private func renderInsurances(
        _ trip: CustCommercialTripsComponents.GetTripItem
    ) {
        resetPanel(insurancePanel, title: "Polizas de seguro")
        insurancePanel.appendChild(insuranceField("Civil", trip.insuranceCivilId))
        insurancePanel.appendChild(insuranceField("Ambiental", trip.insuranceAmbientId))
        insurancePanel.appendChild(insuranceField("Carga", trip.insurancePayloadId))
    }

    private func renderTrailers(_ items: [FiscalRemolqueItem]) {
        resetPanel(trailerPanel, title: "Remolques")

        guard !items.isEmpty else {
            trailerPanel.appendChild(
                Div("Este vehiculo no requiere remolque")
                    .color(.gray)
                    .fontSize(14.px)
                    .padding(all: 8.px)
            )
            return
        }

        items.enumerated().forEach { index, item in
            trailerPanel.appendChild(detailField(
                "Remolque \(index + 1)",
                "\(item.type.description) | \(item.name) | \(item.licensPlates)"
            ))
        }
    }

    private func insuranceField(
        _ title: String,
        _ item: CustCommercialTripInsurance?
    ) -> Div {
        guard let item else {
            return detailField(title, "Sin poliza")
        }

        return detailField(
            title,
            "\(item.provider) | \(item.policyNumber) | $\(item.insuredAmount.formatMoney)"
        )
    }

    private func tripPanel(title: String) -> Div {
        Div {
            H3(title)
                .color(.lightBlueText)
                .margin(all: 0.px)
        }
        .custom("box-sizing", "border-box")
        .class(.roundGrayBlackDark)
        .padding(all: 8.px)
        .overflow(.auto)
    }

    private func resetPanel(_ panel: Div, title: String) {
        panel.innerHTML = ""
        panel.appendChild(
            H3(title)
                .color(.lightBlueText)
                .margin(all: 0.px)
                .marginBottom(7.px)
        )
    }

    private func demoTransactionRow(
        title: String,
        detail: String,
        subtotal: String,
        isPayment: Bool = false
    ) -> Div {
        Div {
            Div {
                Div("\(isPayment ? "✕" : "✎") \(title)")
                    .color(isPayment ? .red : .white)
                    .class(.oneLineText)

                Div(detail)
                    .fontSize(12.px)
                    .color(.gray)
                    .class(.oneLineText)
            }

            Div(subtotal)
                .color(.gray)
                .align(.right)
        }
        .display(.grid)
        .custom("grid-template-columns", "minmax(0, 1fr) auto")
        .custom("gap", "8px")
        .custom("align-items", "center")
        .paddingTop(5.px)
        .paddingBottom(5.px)
        .custom("border-bottom", "1px solid rgba(255, 255, 255, 0.08)")
    }

    private func demoTotalRow(
        _ title: String,
        value: String,
        emphasized: Bool = false
    ) -> Div {
        Div {
            Div(title)
                .color(emphasized ? .white : .gray)

            Div(value)
                .color(emphasized ? .white : .gray)
                .align(.right)
                .custom("font-weight", emphasized ? "700" : "400")
        }
        .display(.grid)
        .custom("grid-template-columns", "minmax(0, 1fr) auto")
        .custom("gap", "8px")
        .paddingTop(2.px)
        .paddingBottom(2.px)
    }

    private func detailField(_ label: String, _ value: String) -> Div {
        Div {
            Label(label)
                .color(.white)

            Div(value.isEmpty ? "Sin informacion" : value)
                .class(.textFiledBlackDark, .oneLineText)
                .custom("box-sizing", "border-box")
                .custom("width", "100%")
                .custom("padding-left", "8px")
                .custom("padding-right", "8px")
                .height(31.px)
        }
        .marginBottom(7.px)
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
}
