//
// TripControler+ManageVehical.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

class TripControlerManageVehical: Div {

    override class var name: String { "div" }

    private var callback: (
        _ item: CallbackType
    ) -> Void

    let viewId: UUID = .init()
    let ws = WS()

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
        self.vehicalYear = item.vehicalYear
        self.vehicalModel = item.vehicalModel
        self.vehicalMake = item.vehicalMake
        self.vehicalWeight = item.vehicalWeight.toString
        self.requierTrailer = item.requierTrailer
        self.insurancePolicy = item.insurancePolicy
        self.avatar = item.avatar
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
    @State var vehicalYear: String = ""

    /// MODELO
    @State var vehicalModel: String = ""

    /// MARCA
    @State var vehicalMake: String = ""

    /// `PesoBrutoVehicular`
    @State var vehicalWeight: String = ""

    @State var requierTrailer: Bool = false

    var insurancePolicy: String? = nil

    @State var avatar: String? = nil

    @State var uploadPercent: String? = nil

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

    lazy var vehicalYearField = InputText(self.$vehicalYear)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Año")
        .onFocus { $0.select() }

    lazy var vehicalModelField = InputText(self.$vehicalModel)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Modelo")
        .onFocus { $0.select() }

    lazy var vehicalMakeField = InputText(self.$vehicalMake)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Marca")
        .onFocus { $0.select() }

    lazy var vehicalWeightField = InputText(self.$vehicalWeight)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Peso Bruto Vehicular")
        .onFocus { $0.select() }

    lazy var requierTrailerToggle = InputCheckbox().toggle(self.$requierTrailer)
    .float(.right)

    lazy var fileLoader: InputFile = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"])
        .hidden(true)

    lazy var imgAvatar = tripAvatarImage(nil)
        .custom("aspect-ratio", "1 / 1")
        .width(100.percent)
        .height(150.px)
        .cursor(.pointer)
        .onClick {
            self.fileLoader.click()
        }

    lazy var avatarPanel = Div {
        self.fileLoader

        Label("Avatar").color(.gray)

        Div {
            self.imgAvatar

            Img()
                .src("/skyline/media/upload2.png")
                .height(30.px)
                .position(.absolute)
                .right(6.px)
                .bottom(6.px)
                .cursor(.pointer)
                .onClick {
                    self.fileLoader.click()
                }

            Div {
                Table {
                    Tr {
                        Td(self.$uploadPercent.map { $0 ?? "" })
                            .verticalAlign(.middle)
                            .fontSize(18.px)
                            .align(.center)
                            .color(.white)
                    }
                }
                .backgroundColor(.init(r: 0, g: 0, b: 0, a: 0.5))
                .height(100.percent)
                .width(100.percent)
            }
            .hidden(self.$uploadPercent.map { $0 == nil })
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .overflow(.hidden)
            .left(0.px)
            .top(0.px)
        }
        .position(.relative)
        .width(100.percent)
        .align(.center)
    }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_vehical.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.$id.map{ ($0 == nil) ?  "Crear Vehiculo" : "Editar Vehiculo" })
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
                    .width(25.percent)
                    .float(.left)

                    Div {
                        Label("Año").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.vehicalYearField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div {
                        Label("Modelo").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.vehicalModelField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div {
                        Label("Marca").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.vehicalMakeField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div().class(.clear).height(7.px)

                    Div {
                        Label("Peso (TONELADAS)").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.vehicalWeightField
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().class(.clear).height(7.px)

                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxRaised)
                )
                .padding(all: 10.px)
                .marginTop(10.px)
                .marginBottom(10.px)
                .width(72.percent)
                .float(.left)

                self.avatarPanel
                    .width(25.percent)
                    .float(.right)

                Div().class(.clear)

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
        .custom("max-width", "720px !important")
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

        self.class(Class(TCTripBetaClass.popUp))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")

        if let avatar {
            imgAvatar.load(tripAvatarSource(avatar))
        }

        fileLoader.$files.listen {
            $0.forEach { self.loadMedia($0) }
        }

        WebApp.current.wsevent.listen {
            guard !$0.isEmpty else { return }

            let (event, _) = self.ws.recive($0)

            guard let event else { return }

            switch event {
            case .asyncFileUpload:
                guard let payload = self.ws.asyncFileUpload($0), payload.eventid == self.viewId else {
                    return
                }

                self.uploadPercent = nil
                self.avatar = payload.avatar
                self.imgAvatar.load(tripAvatarSource(payload.avatar))
                self.notifyAvatarUpdated()

            case .asyncFileUpdate:
                guard let payload = self.ws.asyncFileUpdate($0), payload.eventId == self.viewId else {
                    return
                }

                self.uploadPercent = payload.message

            default:
                break
            }
        }

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

        guard !vehicalYear.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese año del vehiculo")
            vehicalYearField.select()
            return
        }
        
        guard let weight = Double(vehicalWeight.replace(from: ",", to: "")) else {
            showError(.requiredField, "Ingrese peso valido")
            vehicalWeightField.select()
            return
        }

        loadingView.show()

        if let id {
            API.custCommercialTrips.updateVehical(
                vehicalId: id,
                autotransporteCode: autotransporteCode,
                autotransporteName: autotransporteName,
                vehicalType: vehicalType,
                vehicalTypeName: vehicalTypeName,
                vehicalLicensePlate: vehicalLicensePlate,
                vehicalYear: vehicalYear,
                vehicalModel: vehicalModel,
                vehicalMake: vehicalMake,
                vehicalWeight: weight,
                requierTrailer: requierTrailer,
                insurancePolicy: insurancePolicy,
                avatar: avatar
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
                    autotransporteCode: self.autotransporteCode,
                    autotransporteName: self.autotransporteName,
                    vehicalType: self.vehicalType,
                    vehicalTypeName: self.vehicalTypeName,
                    vehicalLicensePlate: self.vehicalLicensePlate,
                    vehicalYear: self.vehicalYear,
                    vehicalModel: self.vehicalModel,
                    vehicalMake: self.vehicalMake,
                    vehicalWeight: weight,
                    requierTrailer: self.requierTrailer,
                    insurancePolicy: self.insurancePolicy,
                    avatar: self.avatar,
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
            vehicalYear: vehicalYear,
            vehicalModel: vehicalModel,
            vehicalMake: vehicalMake,
            vehicalWeight: weight,
            requierTrailer: requierTrailer,
            insurancePolicy: insurancePolicy,
            avatar: avatar
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

            loadingView.show()

            API.custCommercialTrips.deleteVehical(vehicalId: id) { resp in
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
        $autotransporteCode.removeAllListeners()
        $autotransporteName.removeAllListeners()
        $vehicalType.removeAllListeners()
        $vehicalTypeName.removeAllListeners()
        $vehicalLicensePlate.removeAllListeners()
        $vehicalYear.removeAllListeners()
        $vehicalModel.removeAllListeners()
        $vehicalMake.removeAllListeners()
        $vehicalWeight.removeAllListeners()
        $requierTrailer.removeAllListeners()
        $avatar.removeAllListeners()
        $uploadPercent.removeAllListeners()
    }

    private func loadMedia(_ file: File) {
        uploadTripAvatar(
            file: file,
            eventId: viewId,
            id: id,
            to: .tripVehical,
            progress: { self.uploadPercent = $0 },
            completed: { avatar in
                self.avatar = avatar
                self.imgAvatar.load(tripAvatarSource(avatar))
                self.notifyAvatarUpdated()
            }
        )
    }

    private func notifyAvatarUpdated() {
        guard let item = currentItem(weight: Double(vehicalWeight.replace(from: ",", to: ""))) else {
            return
        }

        callback(.update(item))
    }

    private func currentItem(weight: Double?) -> CustCommercialTripVehical? {
        guard let id, let weight else {
            return nil
        }

        return .init(
            id: id,
            createdAt: createdAt,
            modifiedAt: getNow(),
            autotransporteCode: autotransporteCode,
            autotransporteName: autotransporteName,
            vehicalType: vehicalType,
            vehicalTypeName: vehicalTypeName,
            vehicalLicensePlate: vehicalLicensePlate,
            vehicalYear: vehicalYear,
            vehicalModel: vehicalModel,
            vehicalMake: vehicalMake,
            vehicalWeight: weight,
            requierTrailer: requierTrailer,
            insurancePolicy: insurancePolicy,
            avatar: avatar,
            status: status
        )
    }
}

extension TripControlerManageVehical {

    enum CallbackType {
        case create(CustCommercialTripVehical)
        case update(CustCommercialTripVehical)
        case delete(UUID)
    }

}
