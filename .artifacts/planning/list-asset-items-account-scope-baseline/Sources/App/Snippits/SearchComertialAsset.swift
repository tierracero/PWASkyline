import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class SearchComertialAsset: Div {
    override class var name: String { "div" }

    let currentLocation: CustAssetsComponents.ListAssetItemsType
    private let items: [CustCommercialAssetsItem]
    private let callback: (CustCommercialAssetsItem) -> Void
    private var didSelect = false

    @State private var term = ""

    // The caller loads available inventory before presenting this view.
    init?(
        currentLocation: CustAssetsComponents.ListAssetItemsType,
        items: [CustCommercialAssetsItem],
        callback: @escaping (CustCommercialAssetsItem) -> Void
    ) {
        let locationType: CustCommercialAssetsLinkedType
        let locationId: UUID
        switch currentLocation {
        case .store(let id):
            locationType = .store
            locationId = id
        case .warehose(let id):
            locationType = .warehouse
            locationId = id
        case .subAccount(let id):
            locationType = .subaccount
            locationId = id
        default:
            return nil
        }
        self.currentLocation = currentLocation
        self.items = items.filter { $0.currentLocation == locationType && $0.currentLocationId == locationId }
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
                USmallTitle("Activos disponibles en el origen del viaje")
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
}
