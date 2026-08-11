//
// TripControler+ManageOperator.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerManageOperator: Div {

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
        item: CustCommercialTripOperador,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.modifiedAt = item.modifiedAt
        self.status = item.status
        self.operadorType = item.operadorType
        self.operadorTypeListener = item.operadorType.rawValue
        self.operadorName = item.operadorName
        self.operadorRfc = item.operadorRfc
        self.operadorLicens = item.operadorLicens
        self.operadorMobile = item.operadorMobile
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

    /// operador, propietario, arrendador, notificado
    @State var operadorType: TipoOperador? = .operador
    @State var operadorTypeListener: String = TipoOperador.operador.rawValue

    /// `NombreFigura`
    /// Atributo requerido para registrar el nombre de la figura de transporte que interviene en el traslado de los bienes y/o mercancías.
    @State var operadorName: String = ""

    /// `RFCFigura`
    @State var operadorRfc: String = ""

    /// `NumLicencia`
    @State var operadorLicens: String = ""

    @State var operadorMobile: String = ""

    lazy var operadorTypeSelect = Select(self.$operadorTypeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

    lazy var operadorNameField = InputText(self.$operadorName)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Nombre del Operador")
        .onFocus { $0.select() }

    lazy var operadorRfcField = InputText(self.$operadorRfc)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("RFC del Operador")
        .onFocus { $0.select() }

    lazy var operadorLicensField = InputText(self.$operadorLicens)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Licencia Operador")
        .onFocus { $0.select() }

    lazy var operadorMobileField = InputText(self.$operadorMobile)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Telefono del Operador")
        .onFocus { $0.select() }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_operador.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.$id.map{ ($0 == nil) ?  "Crear Operador" : "Editar Operador" })
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

                Div{

                    Div {
                        Label("Tipo de Operador").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.operadorTypeSelect
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        Label("Nombre del Operador").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.operadorNameField
                    }
                    .width(50.percent)
                    .float(.left)
                }

                Div().class(.clear).height(7.px)

                Div {
                    Div {
                        Label("RFC del Operador").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.operadorRfcField
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        Label("Numero de Licencia").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.operadorLicensField
                    }
                    .width(50.percent)
                    .float(.left)
                }

                Div().class(.clear).height(7.px)

                Div {
                    Label("Telefono del Operador").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.operadorMobileField
                }
                .width(50.percent)

                Div().class(.clear).height(7.px)

            }
            .class(
                Class(TCTripBetaClass.box),
                Class(TCTripBetaClass.boxRaised)
            )
            .padding(all: 3.px)
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

        TipoOperador.allCases.forEach { type in
            operadorTypeSelect.appendChild(
                Option(type.description)
                    .value(type.rawValue)
            )
        }

        $operadorTypeListener.listen { rawValue in
            self.operadorType = TipoOperador(rawValue: rawValue)
        }
    }

    func saveData() {
        guard let operadorType else {
            showError(.requiredField, "Seleccione tipo de operador")
            return
        }

        guard !operadorName.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese nombre del operador")
            operadorNameField.select()
            return
        }

        guard !operadorRfc.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese RFC del operador")
            operadorRfcField.select()
            return
        }

        guard !operadorLicens.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese licencia del operador")
            operadorLicensField.select()
            return
        }

        guard !operadorMobile.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese telefono del operador")
            operadorMobileField.select()
            return
        }

        loadingView(show: true)

        if let id {
            API.custCommercialTrips.updateOperador(
                operadorId: id,
                operadorType: operadorType,
                operadorName: operadorName,
                operadorRfc: operadorRfc,
                operadorLicens: operadorLicens,
                operadorMobile: operadorMobile
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
                    operadorType: operadorType,
                    operadorName: self.operadorName,
                    operadorRfc: self.operadorRfc,
                    operadorLicens: self.operadorLicens,
                    operadorMobile: self.operadorMobile,
                    status: self.status
                )))

                self.remove()
            }

            return
        }

        API.custCommercialTrips.createOperador(
            operadorType: operadorType,
            operadorName: operadorName,
            operadorRfc: operadorRfc,
            operadorLicens: operadorLicens,
            operadorMobile: operadorMobile
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

            self.callback(.create(payload.operador))
            self.remove()
        }
    }

    func deleteItem() {
        guard let id else { return }

        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Eliminar Operador",
            message: "Confirme que desea eliminar este operador."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView(show: true)

            API.custCommercialTrips.deleteOperador(operadorId: id) { resp in
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
        $operadorType.removeAllListeners()
        $operadorTypeListener.removeAllListeners()
        $operadorName.removeAllListeners()
        $operadorRfc.removeAllListeners()
        $operadorLicens.removeAllListeners()
        $operadorMobile.removeAllListeners()
    }
}

extension TripControlerManageOperator {

    enum CallbackType {
        case create(CustCommercialTripOperador)
        case update(CustCommercialTripOperador)
        case delete(UUID)
    }

}
