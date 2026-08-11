//
// TripControler+ManageTrailer.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerManageTrailer: Div {

    override class var name: String { "div" }

    private var callback: (
        _ item: CallbackType
    ) -> Void

    init(
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.callback = callback
        super.init()
    }

    init(
        item: CustCommercialTripTrailer,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.modifiedAt = item.modifiedAt
        self.status = item.status
        self.type = item.type
        self.typeListener = item.type.rawValue
        self.series = item.series
        self.name = item.name
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var id: UUID? = nil

    var createdAt: Int64 = getNow()
    var modifiedAt: Int64 = getNow()
    var status: BasicStatus = .active

    /// caballete, caja, cajaAbierta, cajaCerrada
    @State var type: TipoRemolque? = nil
    @State var typeListener: String = ""

    @State var series: String = ""

    @State var name: String = ""

    lazy var typeSelect = Select(self.$typeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

    lazy var nameField = InputText(self.$name)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Nombre del Remolque")
        .onFocus { $0.select() }

    lazy var seriesField = InputText(self.$series)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Serie / Placas")
        .onFocus { $0.select() }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_trailer.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.$id.map{ ($0 == nil) ?  "Crear Remolque" : "Editar Remolque" })
                        .margin(all: 0.px)
                        .class(Class(TCTripBetaClass.titleText))
                }
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-width", "0")

                Img()
                    .closeButton(.uiView2)
                    .class(Class(TCTripBetaClass.close))
                    .onClick {
                        self.remove()
                    }
            }
            .class(Class(TCTripBetaClass.title))

            Div {
            Div {
                Div {
                    Label("Tipo de Remolque").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.typeSelect
                }
                .class(.section)

                Div().class(.clear).height(7.px)

                Div {
                    Label("Nombre").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.nameField
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Serie / Placas").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.seriesField
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear)
            }
            .class(
                Class(TCTripBetaClass.box),
                Class(TCTripBetaClass.boxRaised)
            )
            .padding(all: 10.px)
            .marginTop(10.px)
            .marginBottom(10.px)

            Div {

                Div("Eliminar")
                    .class(.uibtn)
                    .onClick {
                        self.deleteItem()
                    }
                    .hidden(self.$id.map{ ($0 == nil) })

                Div(self.$id.map{ ($0 == nil) ?  "Agregar" : "Guardar Cambios" })
                    .class(.uibtn)
                    .onClick {
                        self.saveData()
                    }
            }
            .class(Class(TCTripBetaClass.titleActions))
            .custom("margin-top", "12px")

            }
            .custom("display", "flex")
            .custom("flex-direction", "column")
            .custom("gap", "12px")
            .custom("min-height", "0")
            .custom("overflow", "auto")
            .custom("box-sizing", "border-box")
            .padding(all: 12.px)
        }
        .class(
            Class(TCTripBetaClass.popUpPanel),
            Class(TCTripBetaClass.popUpPanelFitContent)
        )
        .custom("max-width", "620px !important")
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

        self.class(Class(TCTripBetaClass.popUp))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")

        typeSelect.appendChild(
            Option("Seleccione")
                .value("")
        )

        TipoRemolque.allCases.forEach { type in
            typeSelect.appendChild(
                Option(type.description)
                    .value(type.rawValue)
            )
        }

        $typeListener.listen { rawValue in
            self.type = TipoRemolque(rawValue: rawValue)

            if self.name.isEmpty {
                self.name = self.type?.description ?? ""
            }
        }
    }

    func saveData() {
        guard let type else {
            showError(.requiredField, "Seleccione tipo de remolque")
            return
        }

        guard !name.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese nombre del remolque")
            nameField.select()
            return
        }

        guard !series.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese serie o placas del remolque")
            seriesField.select()
            return
        }

        loadingView(show: true)

        if let id {
            API.custCommercialTrips.updateTrailer(
                trailerId: id,
                trailerType: type.rawValue,
                trailerTypeName: name,
                trailerLicensePlate: series
            ) { resp in
                loadingView(show: false)

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.callback(.update(.init(
                    id: id,
                    createdAt: self.createdAt,
                    modifiedAt: getNow(),
                    type: type,
                    series: self.series,
                    name: self.name,
                    status: self.status
                )))

                self.remove()
            }

            return
        }

        API.custCommercialTrips.createTrailer(
            trailerType: type.rawValue,
            trailerTypeName: name,
            trailerLicensePlate: series
        ) { resp in
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
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            self.callback(.create(payload.item))
            self.remove()
        }
    }

    func deleteItem() {
        guard let id else { return }

        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Eliminar Remolque",
            message: "Confirme que desea eliminar este remolque."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView(show: true)

            API.custCommercialTrips.deleteTrailer(trailerId: id) { resp in
                loadingView(show: false)

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.callback(.delete(id))
                self.remove()
            }
        })
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()

        $id.removeAllListeners()
        $type.removeAllListeners()
        $typeListener.removeAllListeners()
        $series.removeAllListeners()
        $name.removeAllListeners()
    }
}

extension TripControlerManageTrailer {

    enum CallbackType {
        case create(CustCommercialTripTrailer)
        case update(CustCommercialTripTrailer)
        case delete(UUID)
    }

}
