//
// TripControler+ManagePermit.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerManagePermit: Div {

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
        item: CustCommercialTripPermit,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.modifiedAt = item.modifiedAt
        self.status = item.status
        self.permitType = item.permitType
        self.permitTypeListener = item.permitType.rawValue
        self.permitTypeName = item.permitTypeName
        self.permitNumber = item.permitNumber
        self.permitName = item.permitName
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

    /// autotransporteFederalDeCargaGeneral, transportePrivadoDeCarga...
    @State var permitType: TipoPermiso? = nil
    @State var permitTypeListener: String = ""

    @State var permitTypeName: String = ""

    @State var permitNumber: String = ""

    @State var permitName: String = ""

    lazy var permitTypeSelect = Select(self.$permitTypeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

    lazy var permitNumberField = InputText(self.$permitNumber)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Numero de Permiso")
        .onFocus { $0.select() }

    lazy var permitNameField = InputText(self.$permitName)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Propietario del Permiso")
        .onFocus { $0.select() }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_permition.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.$id.map{ ($0 == nil) ?  "Crear Permiso" : "Editar Permiso" })
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
                    Label("Tipo de Permiso / Transporte").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.permitTypeSelect
                }
                .class(.section)

                Div().class(.clear).height(7.px)

                Div {
                    Label("Propietario del Permiso").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.permitNameField
                }
                .class(.section)

                Div().class(.clear).height(7.px)

                Div {
                    Label("Numero de Permiso").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.permitNumberField
                }
                .class(.section)
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

        permitTypeSelect.appendChild(
            Option("Seleccione")
                .value("")
        )

        TipoPermiso.allCases.forEach { type in
            permitTypeSelect.appendChild(
                Option(type.description)
                    .value(type.rawValue)
            )
        }

        $permitTypeListener.listen { rawValue in
            self.permitType = TipoPermiso(rawValue: rawValue)
            self.permitTypeName = self.permitType?.description ?? ""
        }
    }

    func saveData() {
        guard let permitType else {
            showError(.requiredField, "Seleccione tipo de transporte")
            return
        }

        guard !permitNumber.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese numero de permiso")
            permitNumberField.select()
            return
        }

        guard !permitName.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese propietario del permiso")
            permitNameField.select()
            return
        }

        let permitTypeName = permitType.description
        let permitName = self.permitName.pseudo.purgeSpaces.uppercased()

        loadingView.show()

        if let id {
            API.custCommercialTrips.updatePermit(
                permitId: id,
                permitType: permitType,
                permitTypeName: permitTypeName,
                permitNumber: permitNumber,
                permitName: permitName
            ) { resp in
                loadingView.hide()

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
                    permitType: permitType,
                    permitTypeName: permitTypeName,
                    permitNumber: self.permitNumber,
                    permitName: permitName,
                    status: self.status
                )))

                self.remove()
            }

            return
        }

        API.custCommercialTrips.createPermit(
            permitType: permitType,
            permitTypeName: permitTypeName,
            permitNumber: permitNumber,
            permitName: permitName
        ) { resp in
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

            self.callback(.create(payload.permit))
            self.remove()
        }
    }

    func deleteItem() {
        guard let id else { return }

        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Eliminar Permiso",
            message: "Confirme que desea eliminar este permiso."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView.show()

            API.custCommercialTrips.deletePermit(permitId: id) { resp in
                loadingView.hide()

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
        $permitType.removeAllListeners()
        $permitTypeListener.removeAllListeners()
        $permitTypeName.removeAllListeners()
        $permitNumber.removeAllListeners()
        $permitName.removeAllListeners()
    }
}

extension TripControlerManagePermit {

    enum CallbackType {
        case create(CustCommercialTripPermit)
        case update(CustCommercialTripPermit)
        case delete(UUID)
    }

}
