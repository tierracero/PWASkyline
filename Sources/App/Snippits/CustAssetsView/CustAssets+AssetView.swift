import Foundation
import TCFundamentals
import TCFireSignal
import Web

// TODO: LOAD BEFOR VIEW NOT AFTER

extension CustAssetsView {

    final class AssetView: Div {

        override class var name: String { "div" }

        private enum AssetTab: Equatable {
            case inventory
            case notes
        }

        /// store, warehose, account, subAccount
        let viewType: InitiateAssetItemViewType

        let assetId: UUID

        var locations: [CustCommercialAssetsLocation]

        var subLocations: [CustCommercialAssetsSubLocation]

        let onLoaded: ((CustCommercialAssets) -> Void)?
        let onLocationCreated: ((CustCommercialAssetsLocation) -> Void)?
        let onSubLocationCreated: ((CustCommercialAssetsSubLocation) -> Void)?

        private lazy var statusSelect = USelectField(self.$status)
            .width(100.percent)

        init(
            viewType: InitiateAssetItemViewType,
            assetId: UUID,
            locations: [CustCommercialAssetsLocation],
            subLocations: [CustCommercialAssetsSubLocation],
            onLoaded: ((CustCommercialAssets) -> Void)? = nil,
            onLocationCreated: ((CustCommercialAssetsLocation) -> Void)? = nil,
            onSubLocationCreated: ((CustCommercialAssetsSubLocation) -> Void)? = nil
        ) {
            self.viewType = viewType
            self.assetId = assetId
            self.locations = locations
            self.subLocations = subLocations
            self.onLoaded = onLoaded
            self.onLocationCreated = onLocationCreated
            self.onSubLocationCreated = onSubLocationCreated
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State private var title = "Cargando activo…"

        @State private var activeTab: AssetTab = .inventory

        @State private var productType = ""
        @State private var productSubType = ""
        @State private var upc = ""
        @State private var name = ""
        @State private var descriptionText = ""
        @State private var brand = ""
        @State private var model = ""
        @State private var pseudoModel = ""
        @State private var generalDescription = ""
        @State private var commercialDescription = ""
        @State private var technicalDescription = ""
        @State private var initialCost = "0.00"
        @State private var depreciationRate = "0"
        @State private var avatar = ""
        @State private var status = CustCommercialAssetsStatus.active.rawValue

        private var currentAsset: CustCommercialAssets?

        @State var department: CustAssetDepsQuick? = nil
        
        @State var categorie: CustAssetCatsQuick? = nil

        private lazy var contentView = Div()
        .id(.init("contentView_\(callKey(7))"))
        .height(100.percent)

        private lazy var addAssetButton = USmallButton("+ Ingresar Inventario")
            .marginTop(-9.px)
            .float(.right)
            .onClick {
                self.createAsset()
            }

            /// CustCommercialAssetsType

        @DOM override var body: DOM.Content {

            VPopUp(.full) {
                VTitle(self.$title.map{ "Activo \(self.department?.assetType.description ?? "N/D") | \($0)" }, icon: "commertial_assets_icon.png") {
                    USmallTitle("Editar activo")
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    /*
                    VGrid(.full) {
                        self.contentView
                    }
                    .height(100.percent)
                    .display(.block)
                    */

                    self.contentView
                }
                .display(.block)
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
            load()
        }

        private func load() {

            loadingView.show()

            API.custAssetsV1.getAsset(assetId: assetId) { response in
                loadingView.hide()

                guard let response else {
                    showError(.comunicationError, .serverConextionError)
                    self.renderError("No fue posible consultar el activo.")
                    return
                }

                guard response.status == .ok else {
                    showError(.generalError, response.msg)
                    self.renderError(response.msg)
                    return
                }

                guard let payload = response.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    self.renderError("El servidor no devolvió el detalle del activo.")
                    return
                }

                self.title = payload.item.name
                self.render(payload)
                self.onLoaded?(payload.item)
            }
        }

        private func render(_ payload: CustAssetsComponents.GetAssetResponse) {
            let item = payload.item
            currentAsset = item

            productType = item.productType
            productSubType = item.productSubType
            upc = item.upc ?? ""
            name = item.name
            descriptionText = item.description
            brand = item.brand
            model = item.model
            commercialDescription = item.comertialDescription
            depreciationRate = String(item.depreciationRate)
            technicalDescription = item.tecnicalDescription
            generalDescription = item.generalDescription
            initialCost = item.initialCost.formatMoney
            pseudoModel = item.pseudoModel
            status = item.status.rawValue
            avatar = item.avatar ?? ""
            department = payload.department
            categorie = payload.categorie

            statusSelect.innerHTML = ""
            CustCommercialAssetsStatus.allCases.forEach { value in
                statusSelect.appendChild(
                    Option(value.rawValue.capitalized)
                        .value(value.rawValue)
                )
            }

            contentView.innerHTML = ""

            let editor = Div {
                
                Div{
                    self.mediaColumn(item)
                }
                .marginRight(1.percent)
                .width(33.percent)
                .float(.left)

                Div{
                    self.productColumn(item)
                }
                .float(.left)
                .width(66.percent)

                Div().clear(.both)
                
                Div {
                    UTitle("Notas")

                    Div().clear(.both)

                    VBox(.raised) {
                        self.notesList(payload.notes)
                    }
                    .custom("height","calc(100% - 35px)")
                    .marginTop(10.px)

                }
                .custom("height","calc(100% - 505px)")
                .marginRight(1.percent)
                .width(33.percent)
                .float(.left)

                Div {
                    Div {
                        self.addAssetButton
                        UTitle("Inventario")
                    }

                    Div().clear(.both)

                    AssetInventoryController(items: payload.items) { item in
                        addToDom(
                            AssetItemView(assetItemId: item.id) { _ in
                                self.load()
                            }
                        )
                    }
                        .marginTop(3.px)
                        .custom("height","calc(100% - 35px)")
                }
                .custom("height","calc(100% - 505px)")
                .width(66.percent)
                .float(.left)

                Div().clear(.both)

            }
            .height(100.percent)

            contentView.appendChild(
                Div {
                    editor
                }
                .custom("max-height", "calc(100vh - 105px)")
                .custom("box-sizing", "border-box")
                .custom("overflow", "auto")
                .custom("width", "100%")
                .height(100.percent)

            )
        }

        private func mediaColumn(_ item: CustCommercialAssets) -> Div {
            Div {

                VBox(.raised) {
                    UTitle("Fotos y videos")

                    CustAssetsAvatarUploader(
                        avatar: self.$avatar,
                        destination: .asset,
                        itemId: item.id
                    )
                    .marginTop(8.px)
                }

                VBox(.raised) {

                    UTitle("Estado General")

                    Div {
                        Div {

                            UField("Estado") {
                                self.statusSelect
                            }
                        }
                        .margin(all: 3.px)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        Div {
                            UField("Tipo de activo") {
                                USubTitle(item.assetType.description)
                            }
                        }
                        .margin(all: 3.px)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().clear(.both)

                    Div {

                        Div {
                            UField("Costo inicial") {
                                UTextField(self.$initialCost)
                                    .placeholder("0.00")
                                    .onFocus { field in field.select() }
                            }
                        }
                        .margin(all: 3.px)

                    }
                    .width(50.percent)
                    .float(.left)

                    Div {

                        Div {
                            UField("Depreciación") {
                                UTextField(self.$depreciationRate)
                                    .placeholder("0")
                                    .onFocus { field in field.select() }
                            }
                        }
                        .margin(all: 3.px)

                    }
                    .width(50.percent)
                    .float(.left)

                    Div().clear(.both)

                    Div {
                        
                        Div {
                            UField("Tipo de producto") {
                                UTextField(self.$productType)
                            }                            
                        }
                        .margin(all: 3.px)

                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        
                        Div {
                            UField("Subtipo", required: false) {
                                UTextField(self.$productSubType)
                            }   
                        }
                        .margin(all: 3.px)

                    }
                    .width(50.percent)
                    .float(.left)

                    Div().clear(.both)

                }
                .marginTop(12.px)
            }
            .display(.flex)
            .custom("flex-direction", "column")
            .custom("gap", "12px")
        }

        private func productColumn(_ item: CustCommercialAssets) -> Div {
            VBox(.raised) {
                Div {
                    UTitle("Datos del producto")

                    Div {

                        UField("Marca", required: false) {
                            UTextField(self.$brand)
                        }

                        UField("Modelo", required: false) {
                            UTextField(self.$model)
                        }

                        UField("SKU / UPC / POC", required: false) {
                            UTextField(self.$upc)
                        }

                        UField("Pseudo modelo", required: false) {
                            UTextField(self.$pseudoModel)
                        }

                        UField("Nombre") {
                            UTextField(self.$name)
                        }
                        .custom("grid-column", "1 / -1")

                        UField("Descripción corta", required: false) {
                            UTextField(self.$descriptionText)
                        }
                        .custom("grid-column", "1 / -1")
                    }
                    .display(.grid)
                    .custom("grid-template-columns", "repeat(4, minmax(0, 1fr))")
                    .custom("gap", "8px 12px")
                    .marginTop(8.px)

                    UTitle("Descripciones")
                        .marginTop(14.px)

                    Div {
                        UField("General", required: false) {
                            UTextArea(self.$generalDescription)
                                .height(92.px)
                        }

                        UField("Comercial", required: false) {
                            UTextArea(self.$commercialDescription)
                                .height(92.px)
                        }

                        UField("Técnica", required: false) {
                            UTextArea(self.$technicalDescription)
                                .height(92.px)
                        }
                    }
                    .display(.grid)
                    .custom("grid-template-columns", "repeat(3, minmax(0, 1fr))")
                    .custom("gap", "8px 12px")
                    .marginTop(8.px)
                }

                Div {

                    UMinorTitle(self.$department.map{ "Departamento: \( $0?.name ?? "N/D" )" })
                    .marginRight(7.px)
                    .float(.left)

                    UMinorTitle(self.$categorie.map{ "Categoría: \( $0?.name ?? "N/D" )" })
                        .marginTop(3.px)
                        .float(.left)
                        .hidden(self.$categorie.map{ $0 == nil })
                        
                }
                .marginTop(12.px)

                Div {
                    ULargeButton("Cerrar")
                        .onClick { self.remove() }

                    ULargeButton("Guardar cambios")
                        .class(Class(TCCrystalSurfaceClass.goodButton))
                        .onClick { self.save() }
                }
                .display(.flex)
                .custom("justify-content", "flex-end")
                .custom("gap", "8px")
                .marginTop(12.px)
            }
        }

        private func tabButton(_ title: String, tab: AssetTab) -> Div {
            Div(title)
                .padding(v: 8.px, h: 14.px)
                .cursor(.pointer)
                .fontWeight(.bold)
                .color(self.$activeTab.map { $0 == tab ? .white : .gray })
                .backgroundColor(self.$activeTab.map {
                    $0 == tab ? .init(r: 37, g: 90, b: 124, a: 0.82) : .transparent
                })
                .custom("border", "1px solid rgba(102, 184, 236, 0.24)")
                .custom("border-bottom", "0")
                .custom("border-radius", "8px 8px 0 0")
                .onClick {
                    self.activeTab = tab
                }
        }

        private func notesList(_ notes: [CustGeneralNotes]) -> Div {
            let list = Div()
                .display(.grid)
                .custom("gap", "8px")
                .marginTop(8.px)

            if notes.isEmpty {
                list.appendChild(emptyState("No hay notas registradas para este activo."))
                return list
            }

            notes.forEach { note in
                list.appendChild(
                    VBox(.raised) {
                        Div(note.activity)
                            .custom("white-space", "pre-wrap")
                            .custom("line-height", "1.45")
                        UMinorTitle(note.type.rawValue)
                            .marginTop(5.px)
                    }
                )
            }

            return list
        }

        private func save() {
            guard let currentAsset else {
                showError(.unexpectedResult, "El activo aún no está disponible.")
                return
            }

            name = name.purgeSpaces.purgeHtml
            productType = productType.purgeSpaces.purgeHtml
            productSubType = productSubType.purgeSpaces.purgeHtml

            guard !name.isEmpty else {
                showError(.requiredField, .requierdValid("Nombre"))
                return
            }

            guard !productType.isEmpty else {
                showError(.requiredField, .requierdValid("Tipo de producto"))
                return
            }

            guard let cost = Float(
                initialCost
                    .replace(from: ",", to: "")
                    .replace(from: "$", to: "")
            )?.toCents else {
                showError(.generalError, "Ingrese un costo inicial válido")
                return
            }

            guard let depreciation = Double(depreciationRate), depreciation >= 0 else {
                showError(.generalError, "Ingrese una depreciación válida")
                return
            }

            guard let selectedStatus = CustCommercialAssetsStatus(rawValue: status) else {
                showError(.requiredField, .requierdValid("Estado"))
                return
            }

            loadingView.show()

            API.custAssetsV1.updateAsset(
                assetId: currentAsset.id,
                assetType: currentAsset.assetType,
                assetDepartmentId: currentAsset.assetDepartmentId,
                assetSeccionId: currentAsset.assetSeccionId,
                custAcct: currentAsset.custAcct,
                productType: productType,
                productSubType: productSubType,
                upc: upc.isEmpty ? nil : upc,
                name: name,
                description: descriptionText,
                brand: brand,
                model: model,
                pseudoModel: pseudoModel,
                generalDescription: generalDescription,
                comertialDescription: commercialDescription,
                tecnicalDescription: technicalDescription,
                initialCost: cost,
                depreciationRate: depreciation,
                avatar: avatar.isEmpty ? nil : avatar,
                status: selectedStatus
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

                showSuccess(.operacionExitosa, "Activo actualizado")
                self.load()
            }
        }

        private func renderError(_ message: String) {
            contentView.innerHTML = ""
            contentView.appendChild(
                VBox(.raised) {
                    USubTitle("No se pudo cargar el activo")
                    UMinorTitle(message).marginTop(5.px)
                }
            )
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $title.removeAllListeners()
            $activeTab.removeAllListeners()
            $productType.removeAllListeners()
            $productSubType.removeAllListeners()
            $upc.removeAllListeners()
            $name.removeAllListeners()
            $descriptionText.removeAllListeners()
            $brand.removeAllListeners()
            $model.removeAllListeners()
            $pseudoModel.removeAllListeners()
            $generalDescription.removeAllListeners()
            $commercialDescription.removeAllListeners()
            $technicalDescription.removeAllListeners()
            $initialCost.removeAllListeners()
            $depreciationRate.removeAllListeners()
            $avatar.removeAllListeners()
            $status.removeAllListeners()
        }

        func createAsset() {

            switch viewType {
                case .account(_, let store):
                
                guard let lat: String = store.lat, let lon: String = store.lon, let _ = Double(lat), let _ = Double(lon) else {
                    showError(.unexpectedResult, "Tu tienda base \(store.name.capitalized), requeire cargar mapa")
                    return
                }

                case .subAccount(_, let store):
                
                guard let lat: String = store.lat, let lon: String = store.lon, let _ = Double(lat), let _ = Double(lon) else {
                    showError(.unexpectedResult, "Tu tienda base \(store.name.capitalized), requeire cargar mapa")
                    return
                }

                case .store(let store):
                
                guard let lat: String = store.lat, let lon: String = store.lon, let _ = Double(lat), let _ = Double(lon) else {
                    showError(.unexpectedResult, "La tienda \(store.name.capitalized), requeire cargar mapa")
                    return
                }
                
                case .warehose(let store):
                
                guard let lat: String = store.lat, let lon: String = store.lon, let _ = Double(lat), let _ = Double(lon) else {
                    showError(.unexpectedResult, "La tienda \(store.name.capitalized), requeire cargar mapa")
                    return
                }
                
            }

            guard let currentAsset else {
                showError(.unexpectedResult, "El activo aún no está disponible.")
                return
            }

            guard let department else {
                showError(.unexpectedResult, "El departamento aún no está disponible.")
                return
            }

            addToDom(InitiateAssetItemView(
                viewType: viewType
            ){ folio, units in

                if units == 1 {
                    addToDom(
                        CreateAssetItemView(
                            viewType: self.viewType,
                            purchasFiscalDocumentFolio: folio,
                            asset: currentAsset,
                            department: department,
                            categorie: self.categorie,
                            locations: self.locations,
                            subLocations: self.subLocations,
                            onLocationCreated: { location in
                                self.locations = self.upserting(location, into: self.locations)
                                self.onLocationCreated?(location)
                            },
                            onSubLocationCreated: { subLocation in
                                self.subLocations = self.upserting(subLocation, into: self.subLocations)
                                self.onSubLocationCreated?(subLocation)
                            }
                        ) { _ in
                            self.load()
                        }
                    )
                }
                else {

                }

            })
            
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

}
