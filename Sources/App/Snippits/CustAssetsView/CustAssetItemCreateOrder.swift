import Foundation
import TCFundamentals
import TCFireSignal
import Web

/// Confirms a service order for one concrete commercial asset item.
final class CustAssetItemCreateOrder: Div {
    override class var name: String { "div" }

    private let payload: CustAssetsComponents.GetAssetItemResponse
    private let onCreated: (UUID) -> Void
    private var account: CustAcct?
    private var loadId = UUID()
    private var charges: [ChargeObject] = []

    @State private var accountName = "Cargando cuenta propietaria…"
    @State private var descriptionText = ""
    @State private var chargeText = "Sin cargos"
    @State private var message = "Verificando disponibilidad…"
    @State private var canSubmit = false
    @State private var isSubmitting = false

    init(payload: CustAssetsComponents.GetAssetItemResponse, onCreated: @escaping (UUID) -> Void) {
        self.payload = payload
        self.onCreated = onCreated
        super.init()
    }

    required init() { fatalError("Use init(payload:onCreated:)") }

    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 650)) {
            VTitle("Orden de servicio del activo") {
                USmallTitle(self.payload.item.folio)
            } onClose: {
                self.remove()
            }
            VBodyGrid {
                VGrid(.full) {
                    VBox(.raised) {
                        UTitle("Confirmar procesamiento")
                        USubTitle(self.$accountName)
                        USubTitle("Serie: \(self.payload.item.serial ?? "—")")
                        USubTitle("Departamento: \(self.payload.department?.name ?? "Activo Comercial")")
                        USubTitle("Marca: \(self.payload.asset.brand) · Modelo: \(self.payload.asset.model)")
                        UField("Descripción del trabajo", required: true) {
                            UTextArea(self.$descriptionText)
                                .height(110.px)
                                .width(100.percent)
                                .disabled(self.$isSubmitting)
                        }
                        USubTitle(self.$chargeText)
                        ULargeButton("Agregar cargo de servicio")
                            .disabled(self.$isSubmitting)
                            .onClick { self.addCharge() }
                        UMinorTitle(self.$message)
                        Div {
                            ULargeButton("Crear orden")
                                .class(Class(TCCrystalSurfaceClass.goodButton))
                                .disabled(self.$canSubmit.map { !$0 })
                                .onClick { self.submit() }
                        }
                        .display(.flex)
                        .custom("justify-content", "flex-end")
                    }
                }
            }
        }
    }

    override func buildUI() {
        super.buildUI()
        TCCrystalSurfaceTheme.apply(to: self, variant: .assets)
        position(.absolute)
        width(100.percent)
        height(100.percent)
        left(0.px)
        top(0.px)
    }

    override func didAddToDOM() {
        super.didAddToDOM()
        loadPrerequisites()
    }

    private func fail(_ reason: String) {
        canSubmit = false
        message = reason
    }

    private func loadPrerequisites() {
        let item = payload.item
        guard item.status == .active, item.serviceOrder == nil, item.serviceTrip == nil,
              let accountId = item.owningAccount,
              let currentStoreId = item.currentLocationId,
              item.currentLocation == .store || item.currentLocation == .warehouse,
              payload.asset.status == .active else {
            fail("El activo no cumple las condiciones para crear una orden de servicio.")
            return
        }
        let requestId = UUID()
        loadId = requestId
        API.custAPIV1.loadStore(storeId: currentStoreId) { [weak self] locationResponse in
            guard let self, self.isInDOM, self.loadId == requestId else { return }
            guard locationResponse?.status == .ok,
                  let location = locationResponse?.data,
                  location.store.id == currentStoreId,
                  location.config.operationType == .internal else {
                self.fail("La ubicación actual no tiene operación interna.")
                return
            }
            self.loadAccount(accountId, requestId: requestId)
        }
    }

    private func loadAccount(_ accountId: UUID, requestId: UUID) {
        guard isInDOM, loadId == requestId else { return }
        API.custAccountV1.load(id: .id(accountId)) { [weak self] accountResponse in
            guard let self, self.isInDOM, self.loadId == requestId else { return }
            guard accountResponse?.status == .ok,
                  let account = accountResponse?.data?.custAcct,
                  account.id == accountId,
                  account.status == .active else {
                self.fail("No se pudo cargar la cuenta propietaria activa.")
                return
            }
            self.account = account
            self.accountName = account.businessName.isEmpty
                ? "\(account.firstName) \(account.lastName)" : account.businessName
            guard !account.firstName.purgeSpaces.isEmpty,
                  !account.lastName.purgeSpaces.isEmpty else {
                self.fail("Complete el nombre y apellido de contacto en la cuenta antes de crear la orden.")
                return
            }
            self.canSubmit = true
            self.message = "Revise los datos y describa el trabajo solicitado."
        }
    }

    private func addCharge() {
        guard let account, !isSubmitting else { return }
        addToDom(AddChargeFormView(
            accountId: account.id,
            allowManualCharges: false,
            allowWarrantyCharges: false,
            socCanLoadAction: false,
            costType: account.costType,
            authorizationContext: .order,
            currentSOCMasters: charges.compactMap(\.id),
            addPoc: { _, _, _ in showAlert(.alerta, "Seleccione un cargo de servicio.") },
            addSoc: { [weak self] charge, _, _, _ in
                guard let self else { return }
                self.charges.append(charge)
                self.chargeText = "Cargos de servicio: \(self.charges.count)"
            },
            addItem: { _, _ in showAlert(.alerta, "Seleccione un cargo de servicio.") }
        ))
    }

    private func submit() {
        guard canSubmit, !isSubmitting, let account else { return }
        let description = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !description.isEmpty else {
            fail("Ingrese una descripción del trabajo.")
            canSubmit = true
            return
        }
        isSubmitting = true
        canSubmit = false
        message = "Creando orden…"
        let item = payload.item
        guard let storeId = item.currentLocationId else {
            fail("La ubicación actual del activo no está disponible.")
            isSubmitting = false
            return
        }
        let equipment = EquipmentObject(
            type: .assetItem, relId: item.id,
            IDTag1: item.serial ?? "", IDTag2: item.folio,
            tag1: payload.department?.name ?? "Activo Comercial",
            tag2: payload.asset.model, tag3: payload.asset.brand,
            tag4: "", tag5: "", tag6: "",
            tagCheck1: false, tagCheck2: false, tagCheck3: false,
            tagCheck4: false, tagCheck5: false, tagCheck6: false,
            tagDescr: description
        )
        API.custOrderV1.create(
            type: .folio,
            store: storeId,
            custAcct: account.id,
            custSubAcct: item.owningSubAccount,
            workedBy: nil,
            dueDate: nil,
            rentStartAt: nil,
            rentEndAt: nil,
            description: description,
            smallDescription: "",
            lat: nil,
            lon: nil,
            contact: .init(
                firstName: account.firstName,
                secondName: account.secondName,
                lastName: account.lastName,
                secondLastName: account.secondLastName,
                mobile: account.mobile,
                telephone: account.telephone,
                email: account.email
            ),
            address: .init(
                street: account.street,
                colony: account.colony,
                city: account.city,
                zip: account.zip,
                state: account.state,
                country: account.country
            ),
            rentals: [], charges: charges, payment: [], equipments: [equipment], files: []
        ) { [weak self] response in
            guard let self, self.isInDOM else { return }
            self.isSubmitting = false
            self.canSubmit = true
            guard let response else {
                self.message = "No se pudo conectar con el servidor. Intente de nuevo."
                return
            }
            guard response.status == .ok, let orderId = response.id else {
                self.message = response.msg.isEmpty ? "No se pudo crear la orden." : response.msg
                return
            }
            self.remove()
            self.onCreated(orderId)
        }
    }

    override func didRemoveFromDOM() {
        loadId = UUID()
        super.didRemoveFromDOM()
        $accountName.removeAllListeners()
        $descriptionText.removeAllListeners()
        $chargeText.removeAllListeners()
        $message.removeAllListeners()
        $canSubmit.removeAllListeners()
        $isSubmitting.removeAllListeners()
    }
}
