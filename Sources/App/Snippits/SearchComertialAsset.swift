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
            scopedItems = items.filter {
                $0.currentLocation == .subaccount && $0.currentLocationId == id &&
                $0.owningAccount == account.id && $0.status == .unavailable
            }
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
                    id: self.account.id,
                    folio: self.account.folio,
                    businessName: self.account.businessName,
                    costType: self.account.costType,
                    type: self.account.type,
                    store: nil,
                    firstName: self.account.firstName,
                    secondName: "",
                    lastName: self.account.lastName,
                    secondLastName: "",
                    sexo: nil,
                    birthDay: nil,
                    birthMonth: nil,
                    birthYear: nil,
                    telephone: "",
                    mcc: self.account.mcc,
                    mobile: self.account.mobile,
                    email: self.account.email,
                    street: self.account.street,
                    colony: self.account.colony,
                    city: self.account.city,
                    state: self.account.state,
                    country: self.account.country,
                    zip: self.account.zip,
                    autoPaySpei: self.account.autoPaySpei,
                    autoPayOxxo: self.account.autoPayOxxo,
                    fiscalProfile: self.account.fiscalProfile,
                    fiscalRazon: self.account.fiscalRazon,
                    fiscalRfc: self.account.fiscalRfc,
                    fiscalRegime: self.account.fiscalRegime,
                    fiscalZip: self.account.fiscalZip,
                    cfdiUse: self.account.cfdiUse,
                    crstatus: self.account.crstatus,
                    isConcessionaire: self.account.isConcessionaire,
                    CardID: self.account.CardID,
                    rewardsLevel: self.account.rewardsLevel,
                    lat: "",
                    lon: "",
                    avatar: nil
                ), store: store),
                departments: payload.departments,
                sections: payload.locations,
                subSections: payload.subLocations
            ))

        }
    }
}
