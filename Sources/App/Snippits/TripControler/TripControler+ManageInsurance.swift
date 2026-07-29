//
// TripControler+ManageInsurance.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

private func tripInsuranceDateInputValue(_ uts: Int64) -> String {
    let date = getDate(uts)
    let month = date.month < 10 ? "0\(date.month)" : date.month.toString
    let day = date.day < 10 ? "0\(date.day)" : date.day.toString

    return "\(date.year)-\(month)-\(day)"
}

private func tripInsuranceDateInputUTS(
    _ value: String,
    endOfDay: Bool = false
) -> Int64? {
    let parts = value.explode("-")

    guard parts.count == 3 else { return nil }
    guard let year = Int(parts[0]) else { return nil }
    guard let month = Int(parts[1]) else { return nil }
    guard let day = Int(parts[2]) else { return nil }

    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = endOfDay ? 23 : 0
    components.minute = endOfDay ? 59 : 0
    components.second = endOfDay ? 59 : 0

    return Calendar.current.date(from: components)?.timeIntervalSince1970.toInt64
}

class TripControlerManageInsurance: Div {

    override class var name: String { "div" }

    /// civil, ambient, payload
    @State var type: ComertialTripInsuranceType

    private var callback: (
        _ item: CallbackType
    ) -> Void

    init(
        type: ComertialTripInsuranceType,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.type = type
        self.callback = callback
        super.init()
    }

    init(
        item: CustCommercialTripInsurance,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.modifiedAt = item.modifiedAt
        self.status = item.status
        self.validAt = item.validAt
        self.expiredAt = item.expiredAt
        self.validAtDate = tripInsuranceDateInputValue(item.validAt)
        self.expiredAtDate = tripInsuranceDateInputValue(item.expiredAt)
        self.type = item.type
        self.policyNumber = item.policyNumber
        self.provider = item.provider
        self.providerPhone = item.providerPhone
        self.insuredAmount = item.insuredAmount.formatMoney
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

    @State var validAt: Int64 = getNow()

    @State var expiredAt: Int64 = getNow() + (60 * 60 * 24 * 365)

    @State var validAtDate: String = tripInsuranceDateInputValue(getNow())

    @State var expiredAtDate: String = tripInsuranceDateInputValue(getNow() + (60 * 60 * 24 * 365))

    @State var policyNumber: String = ""

    @State var provider: String = ""

    @State var providerPhone: String = ""

    @State var insuredAmount: String = ""

    lazy var validAtField = InputDate(self.$validAtDate)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Vigente desde")
        .onFocus { $0.select() }

    lazy var expiredAtField = InputDate(self.$expiredAtDate)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Vigente hasta")
        .onFocus { $0.select() }

    lazy var policyNumberField = InputText(self.$policyNumber)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Numero de Polisa")
        .onFocus { $0.select() }

    lazy var providerField = InputText(self.$provider)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Aseguradora")
        .onFocus { $0.select() }

    lazy var providerPhoneField = InputText(self.$providerPhone)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Telefono")
        .onFocus { $0.select() }

    lazy var insuredAmountField = InputText(self.$insuredAmount)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Monto Asegurado")
        .onFocus { $0.select() }

    @DOM override var body: DOM.Content {
        Div {

            Img()
                .closeButton(.uiView2)
                .onClick {
                    self.remove()
                }

            H2(self.$id.map{ ($0 == nil) ?  "Crear Polisa \(self.type.description)" : "Editar Polisa \(self.type.description)" })
                .color(.lightBlueText)
                .margin(all: 0.px)

            Div().class(.clear)

            Div {
                Div {
                    Label("Aseguradora").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.providerField
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Telefono").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.providerPhoneField
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear).height(7.px)

                Div {
                    Label("Numero de Polisa").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.policyNumberField
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Monto Asegurado").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.insuredAmountField
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear).height(7.px)

                Div {
                    Label("Vigente Desde").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.validAtField
                }
                .width(50.percent)
                .float(.left)

                Div {
                    Label("Vigente Hasta").color(.gray)
                    Div().class(.clear).height(3.px)
                    self.expiredAtField
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear)
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

        $validAtDate.listen { value in
            guard let uts = tripInsuranceDateInputUTS(value) else { return }
            self.validAt = uts
        }

        $expiredAtDate.listen { value in
            guard let uts = tripInsuranceDateInputUTS(value, endOfDay: true) else { return }
            self.expiredAt = uts
        }
    }

    func saveData() {
        guard !provider.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese aseguradora")
            providerField.select()
            return
        }

        guard !providerPhone.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese telefono de aseguradora")
            providerPhoneField.select()
            return
        }

        guard !policyNumber.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese numero de polisa")
            policyNumberField.select()
            return
        }

        guard let amount = Double(insuredAmount.replace(from: "$", to: "").replace(from: ",", to: ""))?.toCents else {
            showError(.requiredField, "Ingrese monto asegurado valido")
            insuredAmountField.select()
            return
        }

        guard let validAt = tripInsuranceDateInputUTS(validAtDate) else {
            showError(.requiredField, "Ingrese vigencia inicial valida")
            validAtField.select()
            return
        }

        guard let expiredAt = tripInsuranceDateInputUTS(expiredAtDate, endOfDay: true) else {
            showError(.requiredField, "Ingrese vigencia final valida")
            expiredAtField.select()
            return
        }

        self.validAt = validAt
        self.expiredAt = expiredAt

        guard validAt < expiredAt else {
            showError(.requiredField, "La vigencia final debe ser mayor a la inicial")
            expiredAtField.select()
            return
        }

        loadingView(show: true)

        if let id {
            API.custCommercialTrips.updateInsurance(
                id: id,
                validAt: validAt,
                expiredAt: expiredAt,
                policyNumber: policyNumber,
                provider: provider,
                providerPhone: providerPhone,
                insuredAmount: amount
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
                    validAt: validAt,
                    expiredAt: expiredAt,
                    type: self.type,
                    policyNumber: self.policyNumber,
                    provider: self.provider,
                    providerPhone: self.providerPhone,
                    insuredAmount: amount,
                    status: self.status
                )))

                self.remove()
            }

            return
        }

        API.custCommercialTrips.createInsurance(
            validAt: validAt,
            expiredAt: expiredAt,
            type: type,
            policyNumber: policyNumber,
            provider: provider,
            providerPhone: providerPhone,
            insuredAmount: amount
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
            title: "Eliminar Polisa",
            message: "Confirme que desea eliminar esta polisa."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView(show: true)

            API.custCommercialTrips.deleteInsurance(insuranceId: id) { resp in
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
        $validAt.removeAllListeners()
        $expiredAt.removeAllListeners()
        $validAtDate.removeAllListeners()
        $expiredAtDate.removeAllListeners()
        $policyNumber.removeAllListeners()
        $provider.removeAllListeners()
        $providerPhone.removeAllListeners()
        $insuredAmount.removeAllListeners()
    }
}

extension TripControlerManageInsurance {

    enum CallbackType {
        case create(CustCommercialTripInsurance)
        case update(CustCommercialTripInsurance)
        case delete(UUID)
    }

}
