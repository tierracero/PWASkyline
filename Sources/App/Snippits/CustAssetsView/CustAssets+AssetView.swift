//
// CustAssets+AssetView.swift
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

// TODO: LOAD BEFOR VIEW NOT AFTER

extension CustAssetsView {

    final class AssetView: Div {

        override class var name: String { "div" }

        /// store, warehose, account, subAccount
        let viewType: InitiateAssetItemViewType

        let assetId: UUID

        var sections: [CustCommercialAssetsSection]

        var subSections: [CustCommercialAssetsSubSection]

        let onLoaded: ((CustCommercialAssets) -> Void)?

        let onSectionCreated: ((CustCommercialAssetsSection) -> Void)?

        let onSubSectionCreated: ((CustCommercialAssetsSubSection) -> Void)?

        private lazy var statusSelect = USelectField(self.$status)
            .width(100.percent)
            .disabled(true)

        init(
            viewType: InitiateAssetItemViewType,
            assetId: UUID,
            sections: [CustCommercialAssetsSection],
            subSections: [CustCommercialAssetsSubSection],
            onLoaded: ((CustCommercialAssets) -> Void)? = nil,
            onSectionCreated: ((CustCommercialAssetsSection) -> Void)? = nil,
            onSubSectionCreated: ((CustCommercialAssetsSubSection) -> Void)? = nil
        ) {
            self.viewType = viewType
            self.assetId = assetId
            self.sections = sections
            self.subSections = subSections
            self.onLoaded = onLoaded
            self.onSectionCreated = onSectionCreated
            self.onSubSectionCreated = onSubSectionCreated
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State private var title = "Cargando activo…"

        @State private var noteCount = 0

        @State private var productType = ""
        @State private var productSubType = ""
        @State private var fiscCode = ""
        @State private var fiscUnit = ""
        @State private var assetWidth = ""
        @State private var assetHeight = ""
        @State private var assetLength = ""
        @State private var assetWeight = ""
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

        private lazy var fiscCodeField = FiscCodeField(style: .dark, type: .product) { data in
            self.fiscCode = data.c
        }

        private lazy var fiscUnitField = FiscUnitField(style: .dark, type: .product) { data in
            self.fiscUnit = data.c
        }

        private var currentAsset: CustCommercialAssets?

        private var notes: [CustGeneralNotes] = []

        @State var items: [CustAssetsComponents.AssetsItemPayload] = []

        @State var department: CustAssetDepsQuick? = nil
        
        @State var categorie: CustAssetCatsQuick? = nil

        private lazy var contentView = Div()
            .id(.init("contentView_\(callKey(7))"))
            .custom("min-height", "0")
            .height(100.percent)

        private lazy var notesGrid = VGrid(.full) {}
            .custom("min-height", "0")
            .height(100.percent)
            .marginTop(10.px)
            .overflow(.auto)

        private lazy var addAssetButton = USmallButton("+ Ingresar Inventario")
            .onClick {
                self.createAsset()
            }

        @DOM override var body: DOM.Content {

            VPopUp(.full) {

                VTitle(self.$title.map{ "Activo \(self.department?.assetType.description ?? "N/D") | \($0)" }, icon: "commertial_assets_icon.png") {
                    USmallTitle("Editar activo")
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.full) {
                        self.contentView
                    }
                    .height(100.percent)
                    .custom("min-height", "0")
                    .custom("grid-template-rows", "minmax(0, 1fr)")
                    .custom("align-content", "stretch")
                }
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")
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
            fiscCode = item.fiscCode
            fiscUnit = item.fiscUnit
            assetWidth = item.width
            assetHeight = item.height
            assetLength = item.length
            assetWeight = item.weight
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
            notes = payload.notes

            items = payload.items

            renderNotes()

            fiscCodeField.loadFiscalCodeData(item.fiscCode)
            fiscUnitField.loadFiscalCodeData(item.fiscUnit)

            statusSelect.innerHTML = ""
            CustCommercialAssetsStatus.allCases.forEach { value in
                statusSelect.appendChild(
                    Option(value.rawValue.capitalized)
                        .value(value.rawValue)
                )
            }

            contentView.innerHTML = ""


            let editor = VGrid(.full) {
                VGrid(.oneThird) {
                    self.mediaColumn(item)
                }

                VGrid(.twoThirds) {
                    self.productColumn()
                }

                VGrid(.oneThird) {
                    VBox(.raised) {
                        UTitle(self.$noteCount.map { "Notas (\($0))" })
                        self.notesGrid
                    }
                    .height(100.percent)
                    .custom("min-height", "0")
                    .display(.grid)
                    .custom("grid-template-rows", "auto minmax(0, 1fr)")
                }
                .height(100.percent)
                .custom("min-height", "0")
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")

                VGrid(.twoThirds) {
                    VBox(.raised) {
                        Div {
                            
                            UTitle("Inventario")
                            .marginRight(7.px)
                            .float(.left)

                            UTitle(self.$items.map{ $0.count.toString })
                            .color(.white)
                            .float(.left)
                            
                            self.addAssetButton
                            .float(.right)

                            Div().clear(.both)

                        }
                        .display(.block)

                        AssetInventoryController(items: self.$items)
                        .custom("min-height", "0")
                        .height(100.percent)
                        .marginTop(10.px)
                        .overflow(.auto)
                    }
                    .custom("grid-template-rows", "auto minmax(0, 1fr)")
                    .custom("background-color", "rgb(20 22 23) !important")
                    .custom("min-height", "0")
                    .height(100.percent)
                    .display(.grid)
                }
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")
                .custom("min-height", "0")
                .height(100.percent)
            }
            .custom("grid-template-rows", "auto minmax(0, 1fr)")
            .custom("align-content", "stretch")
            .custom("min-height", "0")
            .height(100.percent)

            contentView.appendChild(editor)
        }

        private func mediaColumn(_ item: CustCommercialAssets) -> Div {
            VGrid(.full) {
                VGrid(.half) {
                    VBox(.raised) {
                        UTitle("Fotos y videos")

                        CustAssetsAvatarUploader(
                            avatar: self.$avatar,
                            destination: .asset,
                            itemId: item.id
                        )
                        .marginTop(8.px)
                    }
                }

                VGrid(.half) {

                    VGrid(.full) {

                        UField("Departamento", required: false) {
                            USubTitle(self.$department.map{ $0?.name ?? "" } )
                        }
                        .hidden(self.$department.map { $0 == nil })
                        .display(self.$department.map { $0 == nil ? .none : .block })
                    }

                    VGrid(.full) {
                        UField("Categoria", required: false) {
                            USubTitle(self.$categorie.map{ $0?.name ?? "" } )
                        }
                        .hidden(self.$categorie.map { $0 == nil })
                        .display(self.$categorie.map { $0 == nil ? .none : .block })
                    }

                    VGrid(.full) {
                        UField("Tipo de activo", required: false) {
                            USubTitle(item.assetType.description)
                        }
                    }

                    VGrid(.full) {
                        UField("Estado") {
                            self.statusSelect
                        }
                    }
                }

                VGrid(.full) {
                    VBox(.raised) {

                        UTitle("Estado general")

                        VGrid(.full) {

                            VGrid(.half) {
                                UField("Costo inicial") {
                                    UTextField(self.$initialCost)
                                        .placeholder("0.00")
                                        .onFocus { field in field.select() }
                                }
                            }

                            VGrid(.half) {
                                UField("Depreciación") {
                                    UTextField(self.$depreciationRate)
                                        .placeholder("0")
                                        .onFocus { field in field.select() }
                                }
                            }

                            VGrid(.half) {
                                UField("Tipo de producto") {
                                    UTextField(self.$productType)
                                }
                            }

                            VGrid(.half) {
                                UField("Subtipo", required: false) {
                                    UTextField(self.$productSubType)
                                }
                            }
                        }
                        .marginTop(10.px)
                    }
                }
            }
        }

        private func productColumn() -> Div {
            VBox(.raised) {
                UTitle("Datos del producto")

                VGrid(.full) {
                    VGrid(.oneForth) {
                        UField("Marca", required: false) {
                            UTextField(self.$brand)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Modelo", required: false) {
                            UTextField(self.$model)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("SKU / UPC / POC", required: false) {
                            UTextField(self.$upc)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Pseudo modelo", required: false) {
                            UTextField(self.$pseudoModel)
                        }
                    }

                    VGrid(.half) {
                        UField("Código fiscal", required: false) {
                            self.fiscCodeField
                        }
                    }

                    VGrid(.half) {
                        UField("Unidad fiscal", required: false) {
                            self.fiscUnitField
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Ancho", required: false) {
                            UTextField(self.$assetWidth)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Alto", required: false) {
                            UTextField(self.$assetHeight)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Largo", required: false) {
                            UTextField(self.$assetLength)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Peso", required: false) {
                            UTextField(self.$assetWeight)
                        }
                    }

                    VGrid(.half) {
                        UField("Nombre", required: false) {
                            UTextField(self.$name)
                        }
                    }

                    VGrid(.half) {
                        UField("Descripción corta", required: false) {
                            UTextField(self.$descriptionText)
                        }
                    }
                }
                .marginTop(10.px)

                VGrid(.full) {
                    VGrid(.oneThird) {
                        UField("Descripción General", required: false) {
                            UTextArea(self.$generalDescription)
                                .height(92.px)
                        }
                    }

                    VGrid(.oneThird) {
                        UField("Descripción Comercial", required: false) {
                            UTextArea(self.$commercialDescription)
                                .height(92.px)
                        }
                    }

                    VGrid(.oneThird) {
                        UField("Descripción Técnica", required: false) {
                            UTextArea(self.$technicalDescription)
                                .height(92.px)
                        }
                    }
                }
                .marginTop(10.px)


                VGrid(.full) {

                    VGrid(.half) { }

                    VGrid(.half) {
                        ULargeButton("Guardar cambios")
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(100.percent)
                            .onClick { self.save() }
                    }
                }
                .marginTop(12.px)
            }
        }

        private func renderNotes() {
            noteCount = notes.count
            notesGrid.innerHTML = ""

            if notes.isEmpty {
                notesGrid.appendChild(emptyState("No hay notas registradas para este activo."))
                return
            }

            notes.forEach { note in
                notesGrid.appendChild(noteView(note))
            }
        }

        private func upsertNote(_ note: CustGeneralNotes) {
            notes.removeAll { $0.id == note.id }
            notes.insert(note, at: 0)
            renderNotes()
        }

        private func noteView(_ note: CustGeneralNotes) -> Div {
            VGrid(.full) {
                VBox {
                    Div(note.activity)
                        .custom("white-space", "pre-wrap")
                        .custom("line-height", "1.45")
                    UMinorTitle(note.type.rawValue)
                        .marginTop(5.px)
                }
            }
        }

        private func save() {
            guard let currentAsset else {
                showError(.unexpectedResult, "El activo aún no está disponible.")
                return
            }

            name = name.purgeSpaces.purgeHtml
            productType = productType.purgeSpaces.purgeHtml
            productSubType = productSubType.purgeSpaces.purgeHtml
            fiscCode = fiscCode.purgeSpaces.purgeHtml
            fiscUnit = fiscUnit.purgeSpaces.purgeHtml
            assetWidth = assetWidth.purgeSpaces.purgeHtml
            assetHeight = assetHeight.purgeSpaces.purgeHtml
            assetLength = assetLength.purgeSpaces.purgeHtml
            assetWeight = assetWeight.purgeSpaces.purgeHtml
            upc = upc.purgeSpaces.purgeHtml
            descriptionText = descriptionText.purgeSpaces.purgeHtml
            brand = brand.purgeSpaces.purgeHtml
            model = model.purgeSpaces.purgeHtml
            pseudoModel = pseudoModel.purgeSpaces.purgeHtml
            generalDescription = generalDescription.purgeSpaces.purgeHtml
            commercialDescription = commercialDescription.purgeSpaces.purgeHtml
            technicalDescription = technicalDescription.purgeSpaces.purgeHtml

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
                fiscCode: fiscCode,
                fiscUnit: fiscUnit,
                width: assetWidth,
                height: assetHeight,
                length: assetLength,
                weight: assetWeight,
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

                var updatedAsset = currentAsset
                updatedAsset.modifiedAt = getNow()
                updatedAsset.fiscCode = self.fiscCode
                updatedAsset.fiscUnit = self.fiscUnit
                updatedAsset.width = self.assetWidth
                updatedAsset.height = self.assetHeight
                updatedAsset.length = self.assetLength
                updatedAsset.weight = self.assetWeight
                updatedAsset.productType = self.productType
                updatedAsset.productSubType = self.productSubType
                updatedAsset.upc = self.upc.isEmpty ? nil : self.upc
                updatedAsset.name = self.name
                updatedAsset.description = self.descriptionText
                updatedAsset.brand = self.brand
                updatedAsset.model = self.model
                updatedAsset.pseudoModel = self.pseudoModel
                updatedAsset.generalDescription = self.generalDescription
                updatedAsset.comertialDescription = self.commercialDescription
                updatedAsset.tecnicalDescription = self.technicalDescription
                updatedAsset.initialCost = cost
                updatedAsset.depreciationRate = depreciation
                updatedAsset.avatar = self.avatar.isEmpty ? nil : self.avatar
                updatedAsset.status = selectedStatus

                self.currentAsset = updatedAsset
                self.title = updatedAsset.name
                self.onLoaded?(updatedAsset)

                if let note = response.data {
                    self.upsertNote(note)
                }

                showSuccess(.operacionExitosa, "Activo actualizado")
            }
        }

        private func renderError(_ message: String) {
            contentView.innerHTML = ""
            contentView.appendChild(
                VGrid(.full) {
                    VBox(.raised) {
                        USubTitle("No se pudo cargar el activo")
                        UMinorTitle(message).marginTop(5.px)
                    }
                }
            )
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $title.removeAllListeners()
            $noteCount.removeAllListeners()
            $productType.removeAllListeners()
            $productSubType.removeAllListeners()
            $fiscCode.removeAllListeners()
            $fiscUnit.removeAllListeners()
            $assetWidth.removeAllListeners()
            $assetHeight.removeAllListeners()
            $assetLength.removeAllListeners()
            $assetWeight.removeAllListeners()
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
                            createType: .singleItem,
                            viewType: self.viewType,
                            purchasFiscalDocumentFolio: folio,
                            asset: currentAsset,
                            department: department,
                            categorie: self.categorie,
                            sections: self.sections,
                            subSections: self.subSections,
                            onSectionCreated: { section in
                                self.sections = self.upserting(section, into: self.sections)
                                self.onSectionCreated?(section)
                            },
                            onSubSectionCreated: { subSection in
                                self.subSections = self.upserting(subSection, into: self.subSections)
                                self.onSubSectionCreated?(subSection)
                            }
                        ) { response in
                            switch response {
                            case .createdItems:
                                self.load()
                            case .preItem:
                                break
                            }
                        }
                    )
                }
                else {
                    let view = CreateAssetMultipleItemView(
                        requestedUnits: units,
                        viewType: self.viewType,
                        purchasFiscalDocumentFolio: folio,
                        asset: currentAsset,
                        department: department,
                        categorie: self.categorie,
                        sections: self.sections,
                        subSections: self.subSections,
                        onSectionCreated: { section in
                                self.sections = self.upserting(section, into: self.sections)
                                self.onSectionCreated?(section)
                            },
                            onSubSectionCreated: { subSection in
                                self.subSections = self.upserting(subSection, into: self.subSections)
                                self.onSubSectionCreated?(subSection)
                            }
                        ) { _ in
                            self.load()
                        }
                    addToDom(view)
                }

            })
            
        }

        private func upserting(
            _ section: CustCommercialAssetsSection,
            into values: [CustCommercialAssetsSection]
        ) -> [CustCommercialAssetsSection] {
            var result = values.filter { $0.id != section.id }
            result.append(section)
            return result.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

        private func upserting(
            _ subSection: CustCommercialAssetsSubSection,
            into values: [CustCommercialAssetsSubSection]
        ) -> [CustCommercialAssetsSubSection] {
            var result = values.filter { $0.id != subSection.id }
            result.append(subSection)
            return result.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

    }

}
