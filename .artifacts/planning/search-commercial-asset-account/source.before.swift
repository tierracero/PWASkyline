import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class SearchComertialAsset: Div {

    override class var name: String { "div" }

    let account: CustAcctSearch

    /// store, warehose, account, subAccount
    let currentLocation: CustAssetsComponents.ListAssetItemsType
    
    private let items: [CustCommercialAssetsItem]
    
    private let callback: (CustCommercialAssetsItem) -> Void
    
    private var didSelect = false

    @State private var term = ""

    // The caller loads available inventory before presenting this view.
    init?(
        account: CustAcctSearch,
        currentLocation: CustAssetsComponents.ListAssetItemsType,
        items: [CustCommercialAssetsItem],
        callback: @escaping (CustCommercialAssetsItem) -> Void
    ) {
        let scopedItems: [CustCommercialAssetsItem]
        
        switch currentLocation {
        case .store(let id, let account):
            scopedItems = items.filter {
                $0.currentLocation == .store && $0.currentLocationId == id && $0.owningAccount == account
            }
        case .warehose(let id, let account):
            scopedItems = items.filter {
                $0.currentLocation == .warehouse && $0.currentLocationId == id && $0.owningAccount == account
            }
        case .subAccount(let id):
            scopedItems = items.filter { $0.owningSubAccount == id }
        default:
            return nil
        }
        self.account = account
        self.currentLocation = currentLocation
        self.items = scopedItems
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private lazy var searchField = UTextField(self.$term)
        .placeholder("Buscar por folio, nombre o serie")
        .width(100.percent)

    private lazy var itemsContainer = Div()
        .class(Class(TCCrystalSurfaceClass.tripPickerList))
        .custom("max-height", "440px")
        .custom("overflow-y", "auto")

    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 800)) {
            VTitle("Buscar Activo", icon: "icon_merchandise.png") {
                
                if self.currentLocation == .subAccount {
                     USmallButton("+ Activo")
                        .onClick {
                            self.createAsset()
                        }

                }

            } onClose: {
                self.remove()
            }
            VBodyGrid {
                VGrid(.full) {
                    VBox {
                        UField("Buscar", required: false) { self.searchField }
                        self.itemsContainer
                    }
                }
            }
        }
    }

    override func buildUI() {
        super.buildUI()
        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        // The animated host makes this root the containing block for VPopUp.
        position(.absolute)
        top(0.px)
        left(0.px)
        width(100.percent)
        height(100.percent)
        attribute("role", "dialog")
        attribute("aria-modal", "true")
        $term.listen { [weak self] in self?.renderItems() }
        renderItems()
    }

    override func didAddToDOM() {
        super.didAddToDOM()
        searchField.select()
    }

    private func renderItems() {
        itemsContainer.innerHTML = ""
        let query = term.purgeSpaces.pseudo
        let matches = items.filter {
            query.isEmpty || [$0.folio, $0.name, $0.serial ?? ""].joined(separator: " ").pseudo.contains(query)
        }
        guard !matches.isEmpty else {
            itemsContainer.appendChild(USmallTitle(items.isEmpty
                ? "No hay activos disponibles para agregar en este origen."
                : "No hay activos que coincidan con la búsqueda."))
            return
        }

        matches.forEach { item in
            itemsContainer.appendChild(
                Button {
                    Div("\(item.folio) · \(item.name)")
                        .class(Class(TCCrystalSurfaceClass.tripPickerItemTitle))
                    Div("Serie: \(item.serial ?? "Sin serie")")
                        .class(Class(TCCrystalSurfaceClass.tripPickerItemSubtitle))
                }
                .attribute("type", "button")
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxInteractive),
                    Class(TCCrystalSurfaceClass.tripPickerItem)
                )
                .width(100.percent)
                .textAlign(.left)
                .onClick { [weak self] in
                    guard let self, !self.didSelect else { return }
                    self.didSelect = true
                    self.callback(item)
                    self.remove()
                }
            )
        }
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $term.removeAllListeners()
    }

    func createAsset () { 

        loadingView.show()

        API.custAssetsV1.listStoreArchitecture(
            relationId: account.id
        ) { response in
            
            loadingView.hide()

            guard let response else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard response.status == .ok else {
                showError(.generalError, response.msg)
                return
            }

            guard let payload = response.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            guard let store: CustStore = stores[custCatchStore] else {
                showError(.unexpectedResult, "No se localizo tienda propia")
                return
            }
            
            addToDom(CustAssetsView.CustAssetsQuickDepartmentView(
                viewType: .account(account: .init(
                    id: UUID,
                    folio: String,
                    createdAt: Int64,
                    modifiedAt: Int64,
                    expiredAt: Int64?,
                    basePlanId: UUID?,
                    basePlanName: String?,
                    username: String,
                    password: String,
                    pin: Int,
                    businessName: String,
                    costType: CustAcctCostTypes,
                    type: CustAcctTypes,
                    store: UUID?,
                    thirdPartyService: Bool,
                    sendOrderCommunication: Bool,
                    title: String,
                    firstName: String,
                    secondName: String,
                    lastName: String,
                    secondLastName: String,
                    sexo: Genders?,
                    birthDay: Int?,
                    birthMonth: Int?,
                    birthYear: Int?,
                    rfc: String,
                    curp: String,
                    nss: Int?,
                    IDType: IdentificationTypes?,
                    IDNum: String,
                    tcc: String,
                    telephone: String,
                    t2cc: String,
                    telephone2: String,
                    mcc: String,
                    mobile: String,
                    m2cc: String,
                    mobile2: String,
                    email: String,
                    email2: String,
                    street: String,
                    colony: String,
                    city: String,
                    state: String,
                    country: String,
                    zip: String,
                    mailStreet: String,
                    mailColony: String,
                    mailCity: String,
                    mailState: String,
                    mailCountry: String,
                    mailZip: String,
                    autoPaySpei: String,
                    autoPayOxxo: String,
                    fiscalProfile: UUID?,
                    fiscalRazon: String,
                    fiscalRfc: String,
                    fiscalRegime: FiscalRegimens?,
                    fiscalZip: String,
                    fiscalPOCFirstName: String,
                    fiscalPOCLastName: String,
                    fmcc: String,
                    fiscalPOCMobile: String,
                    fiscalPOCMobileValidaded: Bool,
                    fiscalPOCMail: String,
                    fiscalPOCMailValidaded: Bool,
                    cfdiUse: FiscalUse?,
                    fiscalRecipt: Bool,
                    autoFact: Bool,
                    billDate: Int?,
                    cracct: UUID?,
                    crstatus: CustCreditStatus?,
                    isConcessionaire: Bool,
                    isolateWorkspace: Bool,
                    favorite: Bool,
                    contacto1: String,
                    contacto2: String,
                    ctcc: String,
                    contactTel: String,
                    contactMail: String,
                    validated: Bool,
                    due: Int,
                    balance: Float,
                    CardID: String,
                    rewardsLevel: RewardsProgramType,
                    rewards: Int,
                    lat: String,
                    lon: String,
                    telegramId: Int64?,
                    avatar: String?,
                    status: GeneralStatus
                ), store: store),
                departments: payload.departments,
                sections: payload.locations,
                subSections: payload.subLocations
            ))

        }
    }
    


}
