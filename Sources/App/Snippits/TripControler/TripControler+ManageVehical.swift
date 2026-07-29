//
// TripControler+ManageVehical.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerManageVehical: Div {

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
        item: CustCommercialTripVehical,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.modifiedAt = item.modifiedAt
        self.status = item.status
        self.autotransporteCode = item.autotransporteCode
        self.autotransporteName = item.autotransporteName
        self.vehicalType = item.vehicalType
        self.vehicalTypeName = item.vehicalTypeName
        self.vehicalLicensePlate = item.vehicalLicensePlate
        self.vehicalYearModel = item.vehicalYearModel
        self.vehicalWeight = item.vehicalWeight.toString
        self.requierTrailer = item.requierTrailer
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

    @State var autotransporteCode: String = ""

    @State var autotransporteName: String = ""

    /// Vehiculo ``IdentificacionVehicular``
    /// `ConfigVehicular`
    @State var vehicalType: String = ""

    /// Numero econimico
    @State var vehicalTypeName: String = ""

    /// `PlacaVM`
    @State var vehicalLicensePlate: String = ""

    /// `AnioModeloVM`
    @State var vehicalYearModel: String = ""

    /// `PesoBrutoVehicular`
    @State var vehicalWeight: String = ""

    @State var requierTrailer: Bool = false

    lazy var autotransporteField = FiscAutotrasportTypeField(style: .dark, type: .product) { code in
        self.autotransporteCode = code.c
        self.autotransporteName = code.v
        self.requierTrailer = code.t ?? false

        if self.vehicalType.isEmpty {
            self.vehicalType = code.c
        }

    }

    lazy var vehicalTypeField = InputText(self.$vehicalType)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Tipo de Vehiculo")
        .onFocus { $0.select() }

    lazy var vehicalTypeNameField = InputText(self.$vehicalTypeName)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Nombre / Numero Economico")
        .onFocus { $0.select() }

    lazy var vehicalLicensePlateField = InputText(self.$vehicalLicensePlate)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Placas")
        .onFocus { $0.select() }

    lazy var vehicalYearModelField = InputText(self.$vehicalYearModel)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Año Modelo")
        .onFocus { $0.select() }

    lazy var vehicalWeightField = InputText(self.$vehicalWeight)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Peso Bruto Vehicular")
        .onFocus { $0.select() }

    lazy var requierTrailerToggle = InputCheckbox().toggle(self.$requierTrailer)
    .float(.right)

    @DOM override var body: DOM.Content {
        Div {

            Img()
                .closeButton(.uiView2)
                .onClick {
                    self.remove()
                }

            H2(self.$id.map{ ($0 == nil) ?  "Crear Vehiculo" : "Editar Vehiculo" })
                .color(.lightBlueText)
                .margin(all: 0.px)

            Div().class(.clear)

            Div {
                Div{

                    Div {
                        Label("Autotransporte").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.autotransporteField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{

                        Div().class(.clear).height(18.px)

                        self.requierTrailerToggle
                            .marginRight(7.px)

                        Label("Requiere Remolque")
                            .color(.white)
                            .float(.right)
                    }
                    .width(50.percent)
                    .float(.left)
                    .align(.right)
                    
                }

                Div().class(.clear).height(7.px)

                Div {
                    Label("Tipo de Vehiculo").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.vehicalTypeField
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Nombre / Numero Economico").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.vehicalTypeNameField
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear).height(7.px)

                Div {
                    Label("Placas").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.vehicalLicensePlateField
                }
                .width(33.percent)
                .float(.left)

                Div {
                    Label("Año Modelo").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.vehicalYearModelField
                }
                .width(33.percent)
                .float(.left)

                Div {
                    Label("Peso (TONELADAS)").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.vehicalWeightField
                }
                .width(34.percent)
                .float(.left)

                Div().class(.clear).height(7.px)

            }
            .class(.roundBlue)
            .padding(all: 10.px)
            .marginTop(10.px)
            .marginBottom(10.px)

            Div {

                Div("Eliminar")
                    .class(.uibtn)
                    .color(.coral)
                    .float(.left)
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
            .align(.right)

        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(46.percent)
        .left(27.percent)
        .top(12.percent)
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)

        autotransporteField.fiscUnitField.height(31.px)

        if !autotransporteCode.isEmpty {
            autotransporteField.loadFiscalCodeData(autotransporteCode)
        }
    }

    func saveData() {
        guard !autotransporteCode.purgeSpaces.isEmpty else {
            showError(.requiredField, "Seleccione autotransporte")
            autotransporteField.fiscUnitField.select()
            return
        }

        guard !vehicalType.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese tipo de vehiculo")
            vehicalTypeField.select()
            return
        }

        guard !vehicalTypeName.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese nombre o numero economico")
            vehicalTypeNameField.select()
            return
        }

        guard !vehicalLicensePlate.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese placas del vehiculo")
            vehicalLicensePlateField.select()
            return
        }

        guard !vehicalYearModel.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese año modelo")
            vehicalYearModelField.select()
            return
        }
        
        guard let weight = Double(vehicalWeight.replace(from: ",", to: "")) else {
            showError(.requiredField, "Ingrese peso valido")
            vehicalWeightField.select()
            return
        }

        loadingView(show: true)

        if let id {
            API.custCommercialTrips.updateVehical(
                vehicalId: id,
                autotransporteCode: autotransporteCode,
                autotransporteName: autotransporteName,
                vehicalType: vehicalType,
                vehicalTypeName: vehicalTypeName,
                vehicalLicensePlate: vehicalLicensePlate,
                vehicalYearModel: vehicalYearModel,
                vehicalWeight: weight,
                requierTrailer: requierTrailer
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
                    autotransporteCode: self.autotransporteCode,
                    autotransporteName: self.autotransporteName,
                    vehicalType: self.vehicalType,
                    vehicalTypeName: self.vehicalTypeName,
                    vehicalLicensePlate: self.vehicalLicensePlate,
                    vehicalYearModel: self.vehicalYearModel,
                    vehicalWeight: weight,
                    requierTrailer: self.requierTrailer,
                    status: self.status
                )))

                self.remove()
            }

            return
        }

        API.custCommercialTrips.createVehical(
            autotransporteCode: autotransporteCode,
            autotransporteName: autotransporteName,
            vehicalType: vehicalType,
            vehicalTypeName: vehicalTypeName,
            vehicalLicensePlate: vehicalLicensePlate,
            vehicalYearModel: vehicalYearModel,
            vehicalWeight: weight,
            requierTrailer: requierTrailer
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
            title: "Eliminar Vehiculo",
            message: "Confirme que desea eliminar este vehiculo."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView(show: true)

            API.custCommercialTrips.deleteVehical(vehicalId: id) { resp in
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
        $autotransporteCode.removeAllListeners()
        $autotransporteName.removeAllListeners()
        $vehicalType.removeAllListeners()
        $vehicalTypeName.removeAllListeners()
        $vehicalLicensePlate.removeAllListeners()
        $vehicalYearModel.removeAllListeners()
        $vehicalWeight.removeAllListeners()
        $requierTrailer.removeAllListeners()
    }
}

extension TripControlerManageVehical {

    enum CallbackType {
        case create(CustCommercialTripVehical)
        case update(CustCommercialTripVehical)
        case delete(UUID)
    }

}
