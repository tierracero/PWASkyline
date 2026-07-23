//
// TripControler+ManageMerchendiseBase.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerManageMerchendiseBase: Div {

    override class var name: String { "div" }

    private let callback: (
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
        item: FiscalMercanciaBase,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.fiscCode = item.fiscCode
        self.fiscCodeName = item.fiscCodeName
        self.fiscUnit = item.fiscUnit
        self.fiscUnitName = item.fiscUnitName
        self.descr = item.description
        self.units = item.units.fromCents.toString
        self.kilograms = item.kilograms.fromCents.toString
        self.isDangerousMaterial = item.isDangerousMatirial == .si
        self.dangerousMaterialCode = item.dangerousMatirialCode
        self.dangerousMaterialName = item.dangerousMatirialName
        self.packagingType = item.packagingType
        self.packagingName = item.packagingName
        self.status = item.status
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var id: UUID? = nil

    var fiscCode: String = ""
    var fiscCodeName: String = ""

    var fiscUnit: String = ""
    var fiscUnitName: String = ""

    @State var descr: String = ""
    @State var units: String = "0"
    @State var kilograms: String = "0"

    @State var isDangerousMaterial: Bool = false
    @State var isDangerousDisabled: Bool = false

    var dangerousMaterialCode: String = ""
    var dangerousMaterialName: String = ""

    var packagingType: String = ""
    var packagingName: String = ""

    var status: BasicStatus = .active

    lazy var descrField = InputText(self.$descr)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Descripcion de la mercancia")
        .onFocus { $0.select() }

    lazy var unitsField = InputText(self.$units)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Unidades")
        .textAlign(.right)
        .onFocus { $0.select() }
        .onKeyDown { _, event in
            guard Float(event.key) != nil else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        }

    lazy var kilogramsField = InputText(self.$kilograms)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Peso en kilogramos")
        .textAlign(.right)
        .onFocus { $0.select() }
        .onKeyDown { _, event in
            guard Float(event.key) != nil else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        }

    lazy var fiscUnitField = FiscUnitPesoField(
        style: .dark,
        type: .product
    ) { data in
        self.fiscUnit = data.c
        self.fiscUnitName = data.v
    }

    lazy var fiscCodeField = FiscCodeField(
        style: .dark,
        type: .product
    ) { data in
        self.fiscCode = data.c
        self.fiscCodeName = data.v

        if let isDangerous = data.t {
            self.isDangerousMaterial = isDangerous
            self.isDangerousDisabled = true
        } else {
            self.isDangerousMaterial = false
            self.isDangerousDisabled = false
        }
    }

    lazy var isDangerousMaterialToggle = InputCheckbox()
        .toggle(
            self.$isDangerousMaterial,
            self.$isDangerousDisabled
        ) { _ in }

    lazy var dangerousMaterialCodeField = FiscDangerousMaterialField(
        style: .dark,
        type: .product
    ) { data in
        self.dangerousMaterialCode = data.c
        self.dangerousMaterialName = data.v
    }

    lazy var packagingTypeField = FiscPackagingField(
        style: .dark,
        type: .product
    ) { data in
        self.packagingType = data.c
        self.packagingName = data.v
    }

    @DOM override var body: DOM.Content {
        Div {

            Img()
                .closeButton(.uiView2)
                .onClick {
                    self.remove()
                }

            H2(self.$id.map {
                $0 == nil ? "Crear Mercancia" : "Editar Mercancia"
            })
            .color(.lightBlueText)
            .margin(all: 0.px)

            Div().class(.clear)

            Div {
                Div {
                    Label("Descripcion").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.descrField
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Unidades").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.unitsField
                }
                .width(25.percent)
                .float(.left)

                Div {
                    Label("Peso (kg)").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.kilogramsField
                }
                .width(25.percent)
                .float(.left)

                Div().class(.clear).height(10.px)

                Div {
                    Label("Unidad Fiscal").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.fiscUnitField
                        .width(96.percent)
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Codigo Fiscal").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.fiscCodeField
                        .width(96.percent)
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear).height(10.px)

                Div {
                    Label("Material Peligroso").color(.gray)
                    Div().class(.clear).height(8.px)
                    self.isDangerousMaterialToggle
                }
                .width(20.percent)
                .float(.left)

                Div {
                    Label("Clave de Material Peligroso").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.dangerousMaterialCodeField
                        .width(96.percent)
                }
                .hidden(self.$isDangerousMaterial.map { !$0 })
                .width(40.percent)
                .float(.left)

                Div {
                    Label("Tipo de Embalaje").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.packagingTypeField
                        .width(96.percent)
                }
                .hidden(self.$isDangerousMaterial.map { !$0 })
                .width(40.percent)
                .float(.left)

                Div().class(.clear)
            }
            .class(.roundBlue)
            .padding(all: 8.px)
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
                    .hidden(self.$id.map { $0 == nil })

                Div(self.$id.map {
                    $0 == nil ? "Agregar" : "Guardar Cambios"
                })
                .class(.uibtnLargeOrange)
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
        .custom("box-sizing", "border-box")
        .width(70.percent)
        .left(15.percent)
        .top(18.percent)
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)

        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)

        fiscCodeField.fiscCodeField.height(31.px)
        fiscUnitField.fiscUnitField.height(31.px)
        dangerousMaterialCodeField.fiscCodeField.height(31.px)
        packagingTypeField.fiscCodeField.height(31.px)

        if !fiscCode.isEmpty {
            fiscCodeField.currentCode = fiscCode
            fiscCodeField.fiscCodeDescription = "\(fiscCode) \(fiscCodeName)"
        }

        if !fiscUnit.isEmpty {
            fiscUnitField.currentCode = fiscUnit
            fiscUnitField.fiscUnitDescription = "\(fiscUnit) \(fiscUnitName)"
        }

        if !dangerousMaterialCode.isEmpty {
            dangerousMaterialCodeField.currentCode = dangerousMaterialCode
            dangerousMaterialCodeField.fiscCodeDescription =
                "\(dangerousMaterialCode) \(dangerousMaterialName)"
        }

        if !packagingType.isEmpty {
            packagingTypeField.currentCode = packagingType
            packagingTypeField.fiscCodeDescription =
                "\(packagingType) \(packagingName)"
        }

        descrField.select()
    }

    func saveData() {
        let description = descr.purgeSpaces

        guard !description.isEmpty else {
            showError(.requiredField, "Ingrese descripcion de la mercancia")
            descrField.select()
            return
        }

        guard let parsedUnits = Float(units)?.toCents,
              parsedUnits > 0 else {
            showError(.requiredField, "Ingrese unidades validas")
            unitsField.select()
            return
        }

        guard let parsedKilograms = Float(kilograms)?.toCents,
              parsedKilograms > 0 else {
            showError(.requiredField, "Ingrese peso valido")
            kilogramsField.select()
            return
        }

        guard !fiscUnit.isEmpty else {
            showError(.requiredField, "Seleccione unidad fiscal")
            fiscUnitField.fiscUnitField.select()
            return
        }

        guard !fiscCode.isEmpty else {
            showError(.requiredField, "Seleccione codigo fiscal")
            fiscCodeField.fiscCodeField.select()
            return
        }

        if isDangerousMaterial {
            guard !dangerousMaterialCode.isEmpty else {
                showError(.requiredField, "Seleccione clave de material peligroso")
                dangerousMaterialCodeField.fiscCodeField.select()
                return
            }

            guard !packagingType.isEmpty else {
                showError(.requiredField, "Seleccione tipo de embalaje")
                packagingTypeField.fiscCodeField.select()
                return
            }
        }

        let dangerousType: IsMaterialPeligroso =
            isDangerousMaterial ? .si : .no

        let dangerousCode =
            isDangerousMaterial ? dangerousMaterialCode : ""
        let dangerousName =
            isDangerousMaterial ? dangerousMaterialName : ""
        let selectedPackagingType =
            isDangerousMaterial ? packagingType : ""
        let selectedPackagingName =
            isDangerousMaterial ? packagingName : ""

        loadingView(show: true)

        if let id {
            API.custCommercialTrips.updateMerchandise(
                id: id,
                fiscCode: fiscCode,
                fiscCodeName: fiscCodeName,
                fiscUnit: fiscUnit,
                fiscUnitName: fiscUnitName,
                description: description,
                units: parsedUnits,
                kilograms: parsedKilograms,
                isDangerousMatirial: dangerousType,
                dangerousMatirialCode: dangerousCode,
                dangerousMatirialName: dangerousName,
                packagingType: selectedPackagingType,
                packagingName: selectedPackagingName
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
                    fiscCode: self.fiscCode,
                    fiscCodeName: self.fiscCodeName,
                    fiscUnit: self.fiscUnit,
                    fiscUnitName: self.fiscUnitName,
                    description: description,
                    units: parsedUnits,
                    kilograms: parsedKilograms,
                    isDangerousMatirial: dangerousType,
                    dangerousMatirialCode: dangerousCode,
                    dangerousMatirialName: dangerousName,
                    packagingType: selectedPackagingType,
                    packagingName: selectedPackagingName,
                    status: self.status
                )))
                showSuccess(.operacionExitosa, "Mercancia actualizada")
                self.remove()
            }

            return
        }

        API.custCommercialTrips.createMerchandise(
            fiscCode: fiscCode,
            fiscCodeName: fiscCodeName,
            fiscUnit: fiscUnit,
            fiscUnitName: fiscUnitName,
            description: description,
            units: parsedUnits,
            kilograms: parsedKilograms,
            isDangerousMatirial: dangerousType,
            dangerousMatirialCode: dangerousCode,
            dangerousMatirialName: dangerousName,
            packagingType: selectedPackagingType,
            packagingName: selectedPackagingName
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
            showSuccess(.operacionExitosa, "Mercancia creada")
            self.remove()
        }
    }

    func deleteItem() {
        guard let id else { return }

        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Eliminar Mercancia Base",
            message: "Confirme que desea eliminar esta mercancia."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView(show: true)

            API.custCommercialTrips.deleteMerchandise(
                merchandiseId: id
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

                self.callback(.delete(id))
                showSuccess(.operacionExitosa, "Mercancia eliminada")
                self.remove()
            }
        })
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()

        $id.removeAllListeners()
        $descr.removeAllListeners()
        $units.removeAllListeners()
        $kilograms.removeAllListeners()
        $isDangerousMaterial.removeAllListeners()
        $isDangerousDisabled.removeAllListeners()
    }
}

extension TripControlerManageMerchendiseBase {

    enum CallbackType {
        case create(FiscalMercanciaBase)
        case update(FiscalMercanciaBase)
        case delete(UUID)
    }
}
