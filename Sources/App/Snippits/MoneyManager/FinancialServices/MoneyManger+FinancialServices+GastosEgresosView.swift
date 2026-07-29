//
//  MoneyManger+FinancialServices+GastosEgresosView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.FinancialServicesView {

    final class GastosEgresosView: Div {

        override class var name: String { "div" }

        private enum Mode {
            case create
            case edit(UUID)
        }

        private let mode: Mode

        @State private var ownerType: CustGastosEgresosType

        private let owner: UUID

        @State private var descriptionText: String

        @State private var vendorId: UUID?

        @State private var vendorName: String

        @State private var receiptType: GastosEgresoReciptType

        @State private var receiptTypeValue: String

        @State private var receiptSeries: String

        @State private var receiptAmount: String

        @State private var receiptAudited: Bool

        @State private var status: BillingStatus

        @State private var statusValue: String

        @State private var billedStatus: BillingPaidStatus

        @State private var billedStatusValue: String


        private var callback: (
            _ charge: CustGastosEgresos
        ) -> ()
        // Edit
        init(
            _ gasto: CustGastosEgresos,
            callback: @escaping (
                _ charge: CustGastosEgresos
            ) -> ()
        ) {
            self.mode = .edit(gasto.id)
            self.ownerType = gasto.ownerType
            self.owner = gasto.owner
            self.descriptionText = gasto.description
            self.vendorId = gasto.vendorId
            self.vendorName = gasto.vendorId?.uuidString ?? ""
            self.receiptType = gasto.receiptType
            self.receiptTypeValue = gasto.receiptType.rawValue
            self.receiptSeries = gasto.receiptSeries
            self.receiptAmount = (gasto.receiptAmount.toDouble / 100).fixDecimal
            self.receiptAudited = gasto.receiptAudited
            self.status = gasto.status
            self.statusValue = gasto.status.rawValue
            self.billedStatus = gasto.billedStatus
            self.billedStatusValue = gasto.billedStatus.rawValue
            self.callback = callback
            super.init()
        }

        // Create
        init(
            ownerType: CustGastosEgresosType,
            owner: UUID,
            callback: @escaping (
                _ charge: CustGastosEgresos
            ) -> ()
        ) {
            self.mode = .create
            self.ownerType = ownerType
            self.owner = owner
            self.descriptionText = ""
            self.vendorId = nil
            self.vendorName = ""
            self.receiptType = .recibo
            self.receiptTypeValue = GastosEgresoReciptType.recibo.rawValue
            self.receiptSeries = ""
            self.receiptAmount = "0.00"
            self.receiptAudited = false
            self.status = .inrevice
            self.statusValue = BillingStatus.inrevice.rawValue
            self.billedStatus = .unpaid
            self.billedStatusValue = BillingPaidStatus.unpaid.rawValue
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        private var isEditing: Bool {
            if case .edit = mode {
                return true
            }
            return false
        }

        private var gastoId: UUID? {
            if case .edit(let id) = mode {
                return id
            }
            return nil
        }

        private lazy var descriptionField = InputText(self.$descriptionText)
            .placeholder("Descripción o motivo del gasto")
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)

        private lazy var amountField = InputText(self.$receiptAmount)
            .placeholder("0.00")
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
            .textAlign(.right)
            .onFocus { field in
                field.select()
            }

        private lazy var receiptTypeSelect = Select(self.$receiptTypeValue)
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
            .onChange { _, select in
                guard let value = GastosEgresoReciptType(rawValue: select.value) else {
                    return
                }
                self.receiptType = value
            }

        private lazy var receiptSeriesField = InputText(self.$receiptSeries)
            .placeholder("SERIE / FOLIO")
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)

        private lazy var statusSelect = Select(self.$statusValue)
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
            .onChange { _, select in
                guard let value = BillingStatus(rawValue: select.value) else {
                    return
                }
                self.status = value
            }

        private lazy var billedStatusSelect = Select(self.$billedStatusValue)
            .class(Class(TCTripBetaClass.uiControl))
            .width(100.percent)
            .height(42.px)
            .onChange { _, select in
                guard let value = BillingPaidStatus(rawValue: select.value) else {
                    return
                }
                self.billedStatus = value
            }

        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 900)) {
                VTitle(self.isEditing ? "Editar gasto / egreso | \(self.ownerType.description)" : "Registrar gasto / egreso | \(self.ownerType.description)") {
                    USmallTitle(self.isEditing ? "Edición" : "Nuevo")
                        .class(Class(TCMoneyManagerClass.badge))
                } onClose: {
                    self.remove()
                }
                .backgroundColor(.init(r: 37, g: 44, b: 59))

                VBodyGrid {

                    VGrid(.full) {
                        VBox(.standard) {
                            Div {
                                Div {
                                    USubTitle("Proveedor")
                                    .marginRight(7.px)
                                    .float(.left)

                                    UMinorTitle("(opcional)")
                                        .marginTop(4.px)
                                        .float(.left)
                                }
                                .custom("min-width", "0")

                                USmallButton(
                                    self.$vendorId.map { $0 == nil ? "Buscar proveedor" : "Cambiar" }
                                )
                                .onClick {
                                    addToDom(SearchVendorView(loadBy: nil) { vendor in
                                        self.vendorId = vendor.id
                                        self.vendorName = vendor.razon
                                    })
                                }
                            }
                            .display(.grid)
                            .custom("grid-template-columns", "minmax(0, 1fr) auto")
                            .custom("align-items", "center")
                            .custom("gap", "12px")

                            Div("No se seleccionó proveedor.")
                                .class(Class(TCMoneyManagerClass.hint))
                                .marginTop(14.px)
                                .hidden(self.$vendorId.map { $0 != nil })

                            Div {
                                Div {
                                    USmallTitle("Proveedor seleccionado")
                                    USubTitle(self.$vendorName)
                                        .marginTop(4.px)
                                        .class(.oneLineText)
                                    UMinorTitle(self.$vendorId.map { $0?.uuidString ?? "" })
                                        .marginTop(4.px)
                                        .class(.oneLineText)
                                }
                                .custom("grid-column", "span 10")

                                USmallButton("Quitar")
                                    .custom("grid-column", "span 2")
                                    .onClick {
                                        self.vendorId = nil
                                        self.vendorName = ""
                                    }
                            }
                            .class(Class(TCMoneyManagerClass.userSummary))
                            .marginTop(14.px)
                            .hidden(self.$vendorId.map { $0 == nil })
                        }
                        .class(Class(TCMoneyManagerClass.formCard))
                    }

                    VGrid(.half) {
                        UField("Serie / folio", required: false) {
                            self.receiptSeriesField
                        }
                    }

                    if !self.isEditing {
                        VGrid(.half) {
                            UField("Estado de pago", required: true) {
                                self.billedStatusSelect
                            }
                        }
                    }

                    

                    VGrid(.half) {
                        UField("Descripción o motivo", required: true) {
                            self.descriptionField
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Importe", required: true) {
                            self.amountField
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Tipo comprobante", required: true) {
                            self.receiptTypeSelect
                        }
                    }


                    if self.isEditing {
                        VGrid(.full) {
                            VBox(.standard) {
                                USubTitle("Control administrativo")
                                UMinorTitle(
                                    "Los estados se actualizan por separado para conservar la trazabilidad."
                                )
                                .marginTop(4.px)

                                Div {
                                    UField("Estado del gasto", required: true) {
                                        self.statusSelect
                                    }

                                    USmallButton("Actualizar estado")
                                        .class(Class(TCMoneyManagerClass.primaryButton))
                                        .custom("align-self", "end")
                                        .custom("min-height", "42px")
                                        .onClick {
                                            self.updateStatus()
                                        }

                                    UField("Estado de pago", required: true) {
                                        self.billedStatusSelect
                                    }

                                    USmallButton("Actualizar pago")
                                        .class(Class(TCMoneyManagerClass.primaryButton))
                                        .custom("align-self", "end")
                                        .custom("min-height", "42px")
                                        .onClick {
                                            self.updateBilledStatus()
                                        }
                                }
                                .display(.grid)
                                .custom(
                                    "grid-template-columns",
                                    "minmax(0, 1fr) auto minmax(0, 1fr) auto"
                                )
                                .custom("align-items", "end")
                                .custom("gap", "12px")
                                .marginTop(14.px)
                            }
                            .class(Class(TCMoneyManagerClass.formCard))
                        }
                    }

                    if self.isEditing {
                        VGrid(.oneThird) {
                            ULargeButton("Eliminar")
                                .width(100.percent)
                                .custom("border", "1px solid rgba(255, 104, 96, 0.55)")
                                .custom("background", "rgba(94, 29, 27, 0.38)")
                                .color(.init(r: 255, g: 138, b: 130))
                                .onClick {
                                    self.confirmDelete()
                                }
                        }

                        VGrid(.oneThird) {
                            ULargeButton("Cancelar")
                                .width(100.percent)
                                .onClick {
                                    self.remove()
                                }
                        }

                        VGrid(.oneThird) {
                            ULargeButton("Guardar cambios")
                                .width(100.percent)
                                .class(Class(TCMoneyManagerClass.primaryButton))
                                .onClick {
                                    self.save()
                                }
                        }
                    } else {
                        VGrid(.half) {
                            ULargeButton("Cancelar")
                                .width(100.percent)
                                .onClick {
                                    self.remove()
                                }
                        }

                        VGrid(.half) {
                            ULargeButton("Registrar gasto")
                                .width(100.percent)
                                .class(Class(TCMoneyManagerClass.primaryButton))
                                .onClick {
                                    self.save()
                                }
                        }
                    }
                }
            }
            .class(Class(TCMoneyManagerClass.popup))
        }

        override func buildUI() {
            super.buildUI()

            TCMoneyManagerTheme.apply(to: self)

            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

            GastosEgresoReciptType.allCases.forEach { type in
                receiptTypeSelect.appendChild(
                    Option(receiptTypeDescription(type))
                        .value(type.rawValue)
                )
            }

            BillingStatus.allCases.forEach { status in
                statusSelect.appendChild(
                    Option(status.description)
                        .value(status.rawValue)
                )
            }

            [
                BillingPaidStatus.unpaid,
                BillingPaidStatus.paid
            ].forEach { status in
                billedStatusSelect.appendChild(
                    Option(billedStatusDescription(status))
                        .value(status.rawValue)
                )
            }

            receiptTypeValue = receiptType.rawValue
            statusValue = status.rawValue
            billedStatusValue = billedStatus.rawValue
        }

        private func save() {
            guard let payload = validatedPayload() else {
                return
            }

            switch mode {
            case .create:
                create(payload)
            case .edit(let gastoId):
                update(gastoId: gastoId, payload: payload)
            }
        }

        private func validatedPayload() -> (
            description: String,
            receiptAmount: Int64
        )? {
            let description = descriptionText.purgeSpaces

            guard !description.isEmpty else {
                showError(.requiredField, "Ingrese la descripción del gasto.")
                return nil
            }

            let normalizedAmount = receiptAmount
                .replace(from: "$", to: "")
                .replace(from: ",", to: "")

            guard
                let amount = Double(normalizedAmount)?.toCents,
                amount > 0
            else {
                showError(.generalError, "Ingrese un importe válido.")
                amountField.select()
                return nil
            }

            return (description, amount)
        }

        private func create(
            _ payload: (
                description: String,
                receiptAmount: Int64
            )
        ) {
            loadingView(show: true)

            API.custAPIV1.createGastosEgresos(
                ownerType: ownerType,
                owner: owner,
                description: payload.description,
                vendorId: vendorId,
                receiptType: receiptType,
                receiptSeries: receiptSeries.purgeSpaces,
                receiptAmount: payload.receiptAmount,
                receiptAudited: receiptAudited,
                billedStatus: billedStatus
            ) { resp in

                loadingView(show: false)

                guard let gasto = self.validateMutationResponse(resp) else {
                    return
                }

                self.callback(gasto)

                showSuccess(.operacionExitosa, "Gasto registrado.")

                self.remove()
            }
        }

        private func update(
            gastoId: UUID,
            payload: (
                description: String,
                receiptAmount: Int64
            )
        ) {
            loadingView(show: true)

            API.custAPIV1.updateGastosEgresos(
                gastoId: gastoId,
                ownerType: ownerType,
                owner: owner,
                description: payload.description,
                vendorId: vendorId,
                receiptType: receiptType,
                receiptSeries: receiptSeries.purgeSpaces,
                receiptAmount: payload.receiptAmount,
                receiptAudited: receiptAudited
            ) { resp in
                loadingView(show: false)

                guard self.validateMutationResponse(resp) != nil else {
                    return
                }

                showSuccess(.operacionExitosa, "Gasto actualizado.")
                self.remove()
            }
        }

        private func updateStatus() {
            guard let gastoId else {
                return
            }

            loadingView(show: true)

            API.custAPIV1.updateGastosEgresosStatus(
                gastoId: gastoId,
                status: status
            ) { resp in
                loadingView(show: false)

                guard let gasto = self.validateMutationResponse(resp) else {
                    return
                }

                self.status = gasto.status
                self.statusValue = gasto.status.rawValue
                showSuccess(.operacionExitosa, "Estado del gasto actualizado.")
            }
        }

        private func updateBilledStatus() {
            guard let gastoId else {
                return
            }

            loadingView(show: true)

            API.custAPIV1.updateGastosEgresosBilledStatus(
                gastoId: gastoId,
                billedStatus: billedStatus
            ) { resp in
                loadingView(show: false)

                guard let gasto = self.validateMutationResponse(resp) else {
                    return
                }

                self.billedStatus = gasto.billedStatus
                self.billedStatusValue = gasto.billedStatus.rawValue
                showSuccess(.operacionExitosa, "Estado de pago actualizado.")
            }
        }

        private func confirmDelete() {
            guard gastoId != nil else {
                return
            }

            addToDom(
                ConfirmView(
                    type: .yesNo,
                    title: "Eliminar gasto",
                    message: "¿Confirma que desea eliminar este gasto?"
                ) { confirmed, _ in
                    guard confirmed else {
                        return
                    }
                    self.delete()
                }
            )
        }

        private func delete() {
            guard let gastoId else {
                return
            }

            loadingView(show: true)

            API.custAPIV1.deleteGastosEgresos(gastoId: gastoId) { resp in
                loadingView(show: false)

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                showSuccess(.operacionExitosa, "Gasto eliminado.")
                self.remove()
            }
        }

        private func validateMutationResponse(
            _ resp: APIResponseGeneric<CustGastosEgresos>?
        ) -> CustGastosEgresos? {
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return nil
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return nil
            }

            guard let gasto = resp.data else {
                showError(.generalError, .unexpenctedMissingPayload)
                return nil
            }

            return gasto
        }

        private func receiptTypeDescription(
            _ type: GastosEgresoReciptType
        ) -> String {
            switch type {
            case .previuosPurchase:
                return "Compra anterior"
            case .recibo:
                return "Recibo"
            case .factura:
                return "Factura"
            case .credito:
                return "Crédito"
            }
        }

        private func billedStatusDescription(
            _ status: BillingPaidStatus
        ) -> String {
            switch status {
            case .unpaid:
                return "Pendiente de pago"
            case .paid:
                return "Pagado"
            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()

            $ownerType.removeAllListeners()
            $descriptionText.removeAllListeners()
            $vendorId.removeAllListeners()
            $vendorName.removeAllListeners()
            $receiptType.removeAllListeners()
            $receiptTypeValue.removeAllListeners()
            $receiptSeries.removeAllListeners()
            $receiptAmount.removeAllListeners()
            $receiptAudited.removeAllListeners()
            $status.removeAllListeners()
            $statusValue.removeAllListeners()
            $billedStatus.removeAllListeners()
            $billedStatusValue.removeAllListeners()
        }
    }
}
