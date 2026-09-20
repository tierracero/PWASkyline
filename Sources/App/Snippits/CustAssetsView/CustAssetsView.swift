import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class CustAssetsView: Div {

    override class var name: String { "div" }

    let viewType: InitiateAssetItemViewType

    @State private var departments: [CustAssetDeps]

    @State private var locations: [CustCommercialAssetsLocation]

    @State private var subLocations: [CustCommercialAssetsSubLocation]

    @State private var selectedDepartment: CustAssetDeps?

    init(
        viewType: InitiateAssetItemViewType,
        departments: [CustAssetDeps],
        locations: [CustCommercialAssetsLocation],
        subLocations: [CustCommercialAssetsSubLocation]
    ) {

        self.viewType = viewType
        self.departments = departments
        self.locations = locations
        self.subLocations = subLocations
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var isLoading: Bool = false

    @State var selectedCategory: CustAssetCats?

    @State var categories: [CustAssetCats] = []

    @State var assets: [CustCommercialAssets] = []

    private var pendingDepartmentLoads = 0

    private var departmentLoadToken = UUID()

    private lazy var departmentList = Div {

        emptyState(
            "No hay departamentos",
            "Agregue un departamento antes de crear activos."
        )
        .display(self.$departments.map{ !$0.isEmpty ? .none : .grid })
        .hidden(self.$departments.map{ !$0.isEmpty })
        .custom("height", "calc(100% - 42px)")

        Div {

            ForEach(self.$departments) { department in

                VBox(.interactive) {
                        Div {
                            Div(department.name)
                                .class(.oneLineText)
                                .fontWeight(.bold)

                            UMinorTitle(
                                department.smallDescription.isEmpty
                                    ? "Sin descripción"
                                    : department.smallDescription
                            )
                            .class(.oneLineText)
                            .marginTop(2.px)
                        }
                        .custom("min-width", "0")

                        Span( self.$selectedDepartment.map{ ($0?.id == department.id) ? "●" : "›" })
                            .color(self.$selectedDepartment.map{ ($0?.id == department.id) ? .lightBlue : .gray })

                    }
                    .backgroundColor(
                        self.$selectedDepartment.map {
                            ($0?.id == department.id)
                                ? Color(r: 10, g: 78, b: 119, a: 0.55).important
                                : Color(r: 10, g: 22, b: 34, a: 0.6).important
                        }
                    )
                    .borderColor(
                        self.$selectedDepartment.map {
                            ($0?.id == department.id)
                                ? Color(r: 24, g: 135, b: 199).important
                                : Color(r: 66, g: 183, b: 245, a: 0.2).important
                        }
                    )
                    .custom("justify-content", "space-between")
                    .custom("align-items", "center")
                    .custom("gap", "8px")
                    .display(.flex)
                    .onClick {
                        self.loadDepartment(department)
                    }
            
                Div().height(7.px)
            }

        }
        .display(self.$departments.map{ $0.isEmpty ? .none : .block })
        .hidden(self.$departments.map{ $0.isEmpty })
        .custom("height", "calc(100% - 42px)")

    }
        .custom("height", "calc(100% - 42px)")
        .custom("align-content", "start")
        .custom("gap", "12px")

    private lazy var categoryList = Div{

        Div {
            UMinorTitle("Seleccione un departamento para consultar sus categorías.")
        }
        .height(100.percent)
        .hidden(self.$selectedDepartment.map{ $0 != nil })
        .display(self.$selectedDepartment.map{ ($0 != nil) ? .none : .block })

        Div {

            UMinorTitle("Cargando categorías…").hidden(self.$isLoading.map{ !$0 })

            Div {

                self.categoryButton(title: "Todos", category: nil)

                ForEach(self.$categories) { category in
                    self.categoryButton(title: category.name, category: category)
                }

            }
            .hidden(self.$isLoading)

        }
        .height(100.percent)
        .hidden(self.$selectedDepartment.map{ $0 == nil })
        .display(self.$selectedDepartment.map{ ($0 == nil) ? .none : .block })

    }
        .display(.flex)
        .custom("gap", "7px")
        .custom("flex-wrap", "wrap")

    private lazy var assetList = Div {
        emptyState(
            "Seleccione un departamento",
            "No se puede crear un activo sin departamento."
        )
        .custom("height", "calc(100% - 42px)")
        .display(.grid)
    }
        .custom("height", "calc(100% - 98px)")
        .custom("align-content", "start")
        .custom("gap", "8px")
        
    private lazy var addCategoryButton = USmallButton("+ Agregar categoría")
        .display(.none)
        .onClick {
            self.createCategory()
        }

    private lazy var addAssetButton = USmallButton("+ Crear activo")
        .display(.none)
        .onClick {
            self.createAsset()
        }

    @DOM override var body: DOM.Content {

        VPopUp(.semiFull) {

            VTitle("Control de Activos", icon: "commertial_assets_icon.png") {
                USmallTitle("Activos \(self.viewType.relationType.description)")
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.oneThird) {
                    VBox(.raised) {
                        Div {
                            UTitle("Departamentos")
                            USmallButton("+ Agregar")
                                .onClick {
                                    self.createDepartment()
                                }
                        }
                        .display(.flex)
                        .custom("align-items", "center")
                        .custom("justify-content", "space-between")
                        .custom("gap", "10px")

                        self.departmentList
                            .marginTop(12.px)
                    }
                    .custom("height", "calc(100% - 45px)")
                    // .height(100.percent)
                    .overflow(.auto)
                }
                .height(100.percent)
                .custom("min-height", "0")
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")

                VGrid(.twoThirds) {
                    VBox {

                        Div {

                            Div {
                                
                                USubTitle(self.$selectedDepartment.map{
                                    guard let department = $0 else {
                                        return "Seleccione un departamento"
                                    }

                                    return department.name

                                })

                                UMinorTitle(self.$selectedDepartment.map{
                                    guard let department = $0 else {
                                        return "Los activos y categorías se muestran al entrar a un departamento."
                                    }

                                    return department.smallDescription ?? "Departamento de activos"

                                }).marginTop(3.px)
                                
                            }
                            .custom("min-width", "0")

                            USmallButton("Editar departamento")
                            .hidden(self.$selectedDepartment.map{ $0 == nil})
                            .display(self.$selectedDepartment.map{ ($0 == nil) ? .none : .block})
                            .onClick {
                                self.editSelectedDepartment()
                            }
                        }
                        .custom("justify-content", "space-between")
                        .custom("align-items", "center")
                        
                        .custom("gap", "12px")
                        .display(.flex)


                            

                        /*
                        TOOD: ADD 
                        Div {
                            UTitle("Categorías")
                            self.addCategoryButton
                        }
                        .display(.flex)
                        .custom("align-items", "center")
                        .custom("justify-content", "space-between")
                        .custom("gap", "10px")
                        .marginTop(18.px)

                        self.categoryList
                            .marginTop(9.px)
                        */

                        Div {
                            UTitle("Activos")
                            self.addAssetButton
                        }
                        .custom("justify-content", "space-between")
                        .custom("align-items", "center")
                        .custom("gap", "10px")
                        .marginTop(20.px)
                        .display(.flex)

                        self.assetList
                            .marginTop(9.px)
                            
                    }
                    .custom("height", "calc(100% - 45px)")
                    // .height(100.percent)
                    .overflow(.auto)
                }
                .height(100.percent)
                .custom("min-height", "0")
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")
            }
            .height(100.percent)
            .custom("min-height", "0")
            .custom("grid-template-rows", "minmax(0, 1fr)")
            .custom("align-content", "stretch")
            .custom("align-items", "stretch")
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
        renderCategories()
        renderAssets()
    }

    private func loadDepartment(_ department: CustAssetDeps) {
        guard selectedDepartment?.id != department.id else { return }

        selectedDepartment = department
        selectedCategory = nil
        categories = []
        assets = []
        
        addCategoryButton.display(.inlineBlock)
        addAssetButton.display(.inlineBlock)

        renderCategories(isLoading: true)
        renderAssets(isLoading: true)

        pendingDepartmentLoads = 2
        let loadToken = UUID()
        departmentLoadToken = loadToken
        loadingView.show()

        API.custAssetsV1.listCategories(depid: department.id) { response in
            defer {
                if self.departmentLoadToken == loadToken {
                    self.finishDepartmentLoad()
                }
            }

            guard self.selectedDepartment?.id == department.id else { return }

            guard let response else {
                showError(.comunicationError, .serverConextionError)
                self.renderCategories()
                return
            }

            guard response.status == .ok else {
                showError(.generalError, response.msg)
                self.renderCategories()
                return
            }

            guard let payload = response.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                self.renderCategories()
                return
            }

            self.categories = payload.items
            self.renderCategories()
        }

        loadAssets(
            department: department,
            category: nil,
            tracksDepartmentLoad: true,
            departmentLoadToken: loadToken
        )
    }

    private func loadAssets(
        department: CustAssetDeps,
        category: CustAssetCats?,
        tracksDepartmentLoad: Bool = false,
        departmentLoadToken: UUID? = nil
    ) {
        if !tracksDepartmentLoad {
            loadingView.show()
            renderAssets(isLoading: true)
        }

        API.custAssetsV1.listAssets(
            assetDepartmentId: department.id,
            assetSeccionId: category?.id,
            relationId: viewType.relationId,
            status: nil
        ) { response in
            if tracksDepartmentLoad {
                if let departmentLoadToken,
                   self.departmentLoadToken == departmentLoadToken {
                    self.finishDepartmentLoad()
                }
            }

            guard self.selectedDepartment?.id == department.id,
                  self.selectedCategory?.id == category?.id else {
                return
            }

            if !tracksDepartmentLoad {
                loadingView.hide()
            }

            guard let response else {
                showError(.comunicationError, .serverConextionError)
                self.assets = []
                self.renderAssets()
                return
            }

            guard response.status == .ok else {
                showError(.generalError, response.msg)
                self.assets = []
                self.renderAssets()
                return
            }

            guard let payload = response.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                self.assets = []
                self.renderAssets()
                return
            }

            self.assets = payload.items
            self.renderAssets()
        }
    }

    private func finishDepartmentLoad() {
        pendingDepartmentLoads = max(0, pendingDepartmentLoads - 1)
        if pendingDepartmentLoads == 0 {
            loadingView.hide()
        }
    }

    private func renderCategories(isLoading: Bool = false) {
        categoryList.innerHTML = ""

        if isLoading {
            categoryList.appendChild(UMinorTitle("Cargando categorías…"))
            return
        }

        categoryList.appendChild(categoryButton(title: "Todos", category: nil))

        categories.forEach { category in
            categoryList.appendChild(
                categoryButton(title: category.name, category: category)
            )
        }
    }

    private func categoryButton(
        title: String,
        category: CustAssetCats?
    ) -> Button {
        let isSelected = selectedCategory?.id == category?.id

        return USmallButton(title)
            .custom(
                "border-color",
                isSelected ? "var(--tc-beta-orange-hot)" : "rgba(66, 183, 245, 0.35)"
            )
            .custom(
                "background",
                isSelected ? "rgba(37, 44, 59, 0.96)" : "rgba(7, 25, 39, 0.72)"
            )
            .onClick {
                guard let department = self.selectedDepartment else { return }
                self.selectedCategory = category
                self.renderCategories()
                self.loadAssets(department: department, category: category)
            }
    }

    private func renderAssets(isLoading: Bool = false) {
        assetList.innerHTML = ""

        if isLoading {
            assetList.appendChild(UMinorTitle("Cargando activos…"))
            return
        }

        guard selectedDepartment != nil else {
            assetList.appendChild(
                emptyState(
                    "Seleccione un departamento",
                    "No se puede crear un activo sin departamento."
                )
                .custom("height", "calc(100% - 35px)")
            )
            return
        }

        guard !assets.isEmpty else {
            assetList.appendChild(
                emptyState(
                    "No hay activos",
                    selectedCategory == nil
                        ? "Este departamento todavía no contiene activos."
                        : "Esta categoría todavía no contiene activos."
                )
                .custom("height", "calc(100% - 35px)")
            )
            return
        }

        assets.forEach { asset in
            let row = VBox(.interactive) {
                Div {
                    USubTitle(asset.name)
                        .class(.oneLineText)

                    UMinorTitle(
                        [asset.brand, asset.model]
                            .filter { !$0.isEmpty }
                            .joined(separator: " · ")
                    )
                    .class(.oneLineText)
                    .marginTop(2.px)
                }
                .custom("min-width", "0")

                Div {
                    Div(asset.assetType.description)
                        .fontSize(12.px)
                        .color(.lightBlue)

                    Div(asset.initialCost.formatMoney)
                        .fontWeight(.bold)
                        .color(.white)
                }
                .textAlign(.right)
                .custom("flex", "0 0 auto")
            }
            .custom("justify-content", "space-between")
            .custom("align-items", "center")
            .custom("gap", "12px")
            .display(.flex)
            .onClick {
                addToDom(
                    CustAssetsView.AssetView(
                        viewType: self.viewType,
                        assetId: asset.id,
                        locations: self.locations,
                        subLocations: self.subLocations,
                        onLoaded: { updated in
                            guard self.selectedDepartment?.id == updated.assetDepartmentId,
                                  self.selectedCategory?.id == updated.assetSeccionId else {
                                return
                            }

                            if let index = self.assets.firstIndex(where: { $0.id == updated.id }) {
                                self.assets[index] = updated
                            } else {
                                self.assets.append(updated)
                            }

                            self.renderAssets()
                        },
                        onLocationCreated: { location in
                            self.locations = self.upserting(location, into: self.locations)
                        },
                        onSubLocationCreated: { subLocation in
                            self.subLocations = self.upserting(subLocation, into: self.subLocations)
                        }
                    )
                )
            }

            assetList.appendChild(row)

            assetList.appendChild(Div().height(7.px))
        }
    }

    private func createDepartment() {
        addToDom(
            DepartmentEditor(
                relationType: viewType.relationType,
                relationId: viewType.relationId
            ) { department in
                self.departments.append(department)
                self.loadDepartment(department)
            }
        )
    }

    private func editSelectedDepartment() {
        guard let department = selectedDepartment else { return }

        addToDom(
            DepartmentEditor(
                relationType: viewType.relationType,
                relationId: viewType.relationId, 
                department: department
            ) { updated in
                self.departments = self.departments.map { $0.id == updated.id ? updated : $0 }
                self.selectedDepartment = updated
            }
        )
    }

    private func createCategory() {
        guard let department = selectedDepartment else {
            showError(.requiredField, "Seleccione un departamento")
            return
        }

        addToDom(
            CategoryEditor(department: department) { category in
                self.categories.append(category)
                self.selectedCategory = category
                self.renderCategories()
                self.loadAssets(department: department, category: category)
            }
        )
    }

    private func createAsset() {

        guard let department = selectedDepartment else {
            showError(.requiredField, "Seleccione un departamento antes de crear un activo")
            return
        }

        addToDom(
            CreateAssetView(
                viewType: viewType,
                department: department,
                category: selectedCategory
            ) { asset in

                guard self.selectedDepartment?.id == asset.assetDepartmentId,
                      self.selectedCategory?.id == asset.assetSeccionId else {
                    return
                }

                if let index = self.assets.firstIndex(where: { $0.id == asset.id }) {
                    self.assets[index] = asset
                } else {
                    self.assets.append(asset)
                }

                self.renderAssets()

                addToDom(CustAssetsView.AssetView(
                    viewType: self.viewType,
                    assetId: asset.id,
                    locations: self.locations,
                    subLocations:  self.subLocations,
                    onLocationCreated: { location in
                        self.locations = self.upserting(location, into: self.locations)
                    },
                    onSubLocationCreated: { subLocation in
                        self.subLocations = self.upserting(subLocation, into: self.subLocations)
                    }
                ))


            }
        )
    }

    private func upserting(
        _ location: CustCommercialAssetsLocation,
        into values: [CustCommercialAssetsLocation]
    ) -> [CustCommercialAssetsLocation] {
        var result = values.filter { $0.id != location.id }
        result.append(location)
        return result.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private func upserting(
        _ subLocation: CustCommercialAssetsSubLocation,
        into values: [CustCommercialAssetsSubLocation]
    ) -> [CustCommercialAssetsSubLocation] {
        var result = values.filter { $0.id != subLocation.id }
        result.append(subLocation)
        return result.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

}

extension CustAssetsView {

    /// store, warehose, account, subAccount
    enum InitiateAssetItemViewType {

        case store(CustStore)

        case warehose(CustStore)
        
        case account(account: CustAcct, store: CustStore)

        case subAccount(subAccount: CustSubAcct, store: CustStore )

        var description: String {
            switch self {    
            case .store:
            return "Tienda"
            case .warehose:
            return "Bodega"
            case .account:
            return "Cuenta"
            case .subAccount:
            return "Sub Cliente"
            }
        }

        var relationName: String {

            switch self {    
            case .store(let item):
            return item.name
            case .warehose(let item):
            return item.name
            case .account(let item, let store):
                if item.type == .personal {
                    return "\(item.folio) \(item.firstName) \(item.lastName)"
                }
                else {
                    return "\(item.folio) \(item.businessName) \(item.fiscalRfc) \(item.fiscalRazon)"
                }
            case .subAccount(let item, let store):
            if item.type == .personal {
                    return "\(item.folio) \(item.firstName) \(item.lastName)"
                }
                else {
                    return "\(item.folio) \(item.businessName)"
                }
            }
        }

        var relationId: UUID {

            switch self {    
            case .store(let item):
            return item.id
            case .warehose(let item):
            return item.id
            case .account(let item, _):
            return item.id
            case .subAccount(let item, _):
            return item.custAcct
            }

        }

        var relationType: CustCommercialAssetsLocationLinkedType {
            switch self {    
            case .store:
            return .store
            case .warehose:
            return .warehose
            case .account, .subAccount:
            return .customer
            }
        }
        
    }
    
}
