//
// CustAssets+CreateAssetItemView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension CustAssetsView {

    final class CreateAssetItemView: Div {

        override class var name: String { "div" }

        static var viewid: UUID { .init() }

        /// store, warehose, account, subAccount
        let viewType: InitiateAssetItemViewType

        let purchasFiscalDocumentFolio: String

        let asset: CustCommercialAssets

        let department: CustAssetDepsQuick
        
        let categorie: CustAssetCatsQuick?

        // Regulates the primary location, EG: Office 1
        @State var locations: [CustCommercialAssetsLocation]

        // Regulates the secondarie location, EG: cubical 1 (in Office 1)
        @State var subLocations: [CustCommercialAssetsSubLocation]

        let callback: (CustCommercialAssetsItem) -> Void

        let onLocationCreated: (CustCommercialAssetsLocation) -> Void
        
        let onSubLocationCreated: (CustCommercialAssetsSubLocation) -> Void

        init(
            viewType: InitiateAssetItemViewType,
            purchasFiscalDocumentFolio: String,
            asset: CustCommercialAssets,
            department: CustAssetDepsQuick,
            categorie: CustAssetCatsQuick?,
            locations: [CustCommercialAssetsLocation],
            subLocations: [CustCommercialAssetsSubLocation],
            onLocationCreated: @escaping (CustCommercialAssetsLocation) -> Void,
            onSubLocationCreated: @escaping (CustCommercialAssetsSubLocation) -> Void,
            callback: @escaping (CustCommercialAssetsItem) -> Void
        ) {
            self.viewType = viewType
            self.purchasFiscalDocumentFolio = purchasFiscalDocumentFolio
            self.asset = asset
            self.department = department
            self.categorie = categorie
            self.acquisitionCost = asset.initialCost.formatMoney
            self.currentCost = asset.initialCost.formatMoney
            self.locations = locations
            self.subLocations = subLocations
            self.onLocationCreated = onLocationCreated
            self.onSubLocationCreated = onSubLocationCreated
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State private var name = ""
        @State private var serial = ""
        
        @State private var serviceCard = ""
        @State private var acquisitionCost = "0.00"
        @State private var currentCost = "0.00"
        @State private var selectedAvatar = ""
        private var selectedLocationId: UUID?
        private var selectedSubLocationId: UUID?

        private var imageReference: [UUID: ImageGeneralView] = [:]
        private var imageOrder: [UUID] = []

        private lazy var mediaFileInput = InputFile()
            .accept([
                "image/png",
                "image/gif",
                "image/jpeg",
                "image/jpg",
                "image/webp",
                "video/mp4",
                "video/quicktime",
                "video/webm"
            ])
            .multiple(true)
            .display(.none)

        private lazy var mediaGrid = Div()
            .maxHeight(220.px)
            .overflow(.auto)
            .padding(all: 4.px)
            .marginTop(8.px)

        private lazy var locationPicker = AssetLocationPicker(
            title: "Ubicación", addTitle: "Agregar Ubicación",
            onSelect: { [weak self] id in
                guard let self else { return }
                self.selectedLocationId = id
                self.selectedSubLocationId = nil
                self.refreshSections()
            },
            onCreate: { [weak self] name, completion in
                self?.openLocationEditor(initialName: name, completion: completion)
            }
        )

        private lazy var sectionPicker = AssetLocationPicker(
            title: "Sección", addTitle: "Agregar Sección",
            onSelect: { [weak self] id in self?.selectedSubLocationId = id },
            onCreate: { [weak self] name, completion in
                self?.openSubLocationEditor(initialName: name, completion: completion)
            }
        )

        @DOM override var body: DOM.Content {
            
            VPopUp(.fitContent(w: 820)) {
                
                VTitle("Ingresar unidad | \(self.department.name)", icon: "commertial_assets_icon.png") {
                    USmallTitle(self.asset.name)
                } onClose: {
                    self.remove()
                }

                VBodyGrid {

                    VGrid(.half) {
                        VGrid(.full) {
                            self.readOnly("Tipo de ubicación", self.viewType.description)
                        }
                        VGrid(.full) {
                            self.readOnly("Nombre de ubicación", self.viewType.relationName)
                        }

                        VGrid(.full) {
                            VBox(.raised) {

                                Div {
                                    self.readOnly("Nombre", self.asset.name)
                                    self.readOnly("Tipo", self.asset.assetType.description)
                                    self.readOnly("Departamento", self.department.name.lowercased())
                                    self.readOnly("Categoría",self.asset.assetSeccionId?.uuidString.lowercased() ?? "Sin categoría")
                                }
                                .display(.grid)
                                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                                .custom("gap", "8px")
                                .marginTop(8.px)
                            }
                        }
                }

                    VGrid(.half) {
                        VBox(.raised) {

                            Div {
                                Img()
                                    .src("/skyline/media/upload2.png")
                                    .height(18.px)
                                    .marginRight(5.px)

                                Span("Subir Foto/Video")
                                    .fontSize(16.px)
                            }
                            .class(.uibtn)
                            .padding(v: 8.px, h: 12.px)
                            .cursor(.pointer)
                            .float(.right)
                            .onClick {
                                self.mediaFileInput.click()
                            }

                            UTitle("Fotos y videos")

                            self.mediaFileInput


                            self.mediaGrid
                        }
                    }



                    VGrid(.oneForth) {
                        UField("Nombre") {
                            UTextField(self.$name)
                                .placeholder("Nombre de la unidad")
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Número de serie", required: false) {
                            UTextField(self.$serial)
                                .placeholder("Opcional")
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Folio de compra", required: false) {
                            USubTitle(self.purchasFiscalDocumentFolio.isEmpty ? "-- sin folio --" : self.purchasFiscalDocumentFolio)
                                .class(.oneLineText)
                                .color(self.purchasFiscalDocumentFolio.isEmpty ? .gray : .white)
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Tarjeta de servicio", required: false) {

                            Div {
                                Img()
                                    .src("/skyline/media/bar_qr_white.png")
                                    .marginLeft(7.px)
                                    .marginTop(7.px)
                                    .height(20.px)
                                    .cursor(.pointer)
                                    .onClick {
                                        self.addwarrantyCard()
                                    }
                            }
                            .float(.right)

                            UTextField(self.$serviceCard)
                                .placeholder("Opcional")
                                .custom("width", "calc(100% - 28px)")
                            
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Costo de adquisición") {
                            UTextField(self.$acquisitionCost)
                                .placeholder("0.00")
                                .onFocus { field in field.select() }
                        }
                    }

                    VGrid(.oneForth) {
                        UField("Costo actual") {
                            UTextField(self.$currentCost)
                                .placeholder("0.00")
                                .onFocus { field in field.select() }
                        }
                    }

                    VGrid(.oneForth) { self.locationPicker }

                    VGrid(.oneForth) { self.sectionPicker }

                    VGrid(.half) {
                        ULargeButton("Cancelar")
                            .width(100.percent)
                            .onClick { self.remove() }
                    }

                    VGrid(.half) {
                        ULargeButton("Ingresar unidad")
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(100.percent)
                            .onClick { self.create() }

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

            mediaFileInput.$files.listen { files in
                files.forEach { self.uploadMedia($0) }
            }
        }

        override func didAddToDOM() {
            super.didAddToDOM()
            refreshLocations()
        }

        func addwarrantyCard() {

            /*

            let view = AddWarrantyCard(
                orderId: self.orderView.order.id,
                equipmentId: self.equipment.id
            ) { cardCode in
            
                self.warrantyCard = cardCode

                var warrantyCards = self.orderView.order.warrantyCards
                if !warrantyCards.contains(cardCode) {
                    warrantyCards.append(cardCode)
                }

                self.orderView.order.warrantyCards = warrantyCards
                OrderCatchControler.shared.updateParameter(
                    self.orderView.order.id,
                    .warrantyCards(warrantyCards)
                )
            }

            */
            
            // addToDom(view)
            
        }
        private func create() {
            name = name.purgeSpaces.purgeHtml

            guard !name.isEmpty else {
                showError(.requiredField, .requierdValid("Nombre"))
                return
            }


            guard let acquisitionCost = parseCents(acquisitionCost) else {
                showError(.generalError, "Ingrese un costo de adquisición válido")
                return
            }

            guard let currentCost = parseCents(currentCost) else {
                showError(.generalError, "Ingrese un costo actual válido")
                return
            }

            guard let locationId = selectedLocationId else {
                showError(.requiredField, .requierdValid("Ubicación"))
                return
            }

            guard !imageReference.values.contains(where: { !$0.isLoaded || $0.file == nil }) else {
                showError(.generalError, "Espere a que terminen de cargar las fotos y videos.")
                return
            }

            let images = imageOrder.compactMap { imageReference[$0]?.file }
            let coordinates = viewType.assetCoordinates

            loadingView.show()

            var owningAccount: UUID? = nil
            
            var owningSubAccount: UUID? = nil

            var currentLocationId: UUID? = nil

            switch viewType {
            case .account(let account, let store):
                 owningAccount = account.id
                currentLocationId = store.id
            
            case .store(let store):
                currentLocationId = store.id
            
            case .subAccount(let subAccount, let store):
                owningAccount = subAccount.custAcct
                owningSubAccount = subAccount.id
                currentLocationId = store.id
            case .warehose(let warehose):
                currentLocationId = warehose.id
            }

            guard let currentLocationId else {
                return
            }
            
            API.custAssetsV1.createAssettem(
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio.purgeSpaces,
                purchasFiscalDocumentId: nil,
                commercialAssetId: asset.id,
                owningStore: custCatchStore,
                owningAccount: owningAccount,
                currentLocation: .location,
                currentLocationId: currentLocationId,
                department: asset.assetDepartmentId,
                categorie: asset.assetSeccionId,
                subcategorie: locationId,
                section: selectedSubLocationId,
                subSection: nil,
                acquisitionAt: getNow(),
                acquisitionCost: acquisitionCost,
                currentCost: currentCost,
                serial: serial.isEmpty ? nil : serial.purgeSpaces,
                name: name,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                serviceCard: serviceCard.isEmpty ? nil : serviceCard.purgeSpaces,
                images: images
            ) { response in

                guard let response else {
                    loadingView.hide()
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard response.status == .ok else {
                    loadingView.hide()
                    showError(.generalError, response.msg)
                    return
                }

                guard let itemId = response.data?.itemId else {
                    loadingView.hide()
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                loadingView.hide()
                showSuccess(.operacionExitosa, "Unidad ingresada")

                addToDom(
                    AssetItemView(
                        assetItemId: itemId,
                        onLoaded: self.callback
                    )
                )
                self.remove()
            }
            
        }

        private func uploadMedia(_ file: File) {
            let fileSize = file.size / 1000 / 1000

            if (file.type.contains("video") || file.type.contains("image")), fileSize > 30 {
                showError(.generalError, "No se pueden subir archivos de más de 30 MB.")
                return
            }

            let view = ImageGeneralView(
                relation: .assetItem,
                relationId: nil,
                type: file.type.contains("video") ? .vdo : .img,
                mediaId: nil,
                file: nil,
                image: nil,
                descr: "",
                width: 0,
                height: 0,
                selectedAvatar: $selectedAvatar,
                callback: { [weak self] viewId, _, _, originalImage, originalWidth, originalHeight, _ in
                    guard let view = self?.imageReference[viewId] else { return }
                    view.file = originalImage
                    view.width = originalWidth
                    view.height = originalHeight
                },
                imAvatar: { [weak self] _, name in
                    self?.selectedAvatar = name
                },
                removeMe: { [weak self] viewId in
                    self?.imageReference.removeValue(forKey: viewId)
                    self?.imageOrder.removeAll { $0 == viewId }
                }
            )

            imageReference[view.viewId] = view
            imageOrder.append(view.viewId)

            func removeUploadView() {
                imageReference.removeValue(forKey: view.viewId)
                imageOrder.removeAll { $0 == view.viewId }
                view.remove()
            }

            let xhr = XMLHttpRequest()

            xhr.onLoadStart { _ in
                self.mediaGrid.appendChild(view)
            }

            xhr.onError { _ in
                showError(.comunicationError, .serverConextionError)
                removeUploadView()
            }

            xhr.onLoadEnd {
                guard let responseText = xhr.responseText,
                      let data = responseText.data(using: .utf8) else {
                    showError(.generalError, .serverConextionError)
                    removeUploadView()
                    return
                }

                do {
                    let response = try JSONDecoder().decode(
                        APIResponseGeneric<CustComponents.UploadManagerResponse>.self,
                        from: data
                    )

                    guard response.status == .ok else {
                        showError(.generalError, response.msg)
                        removeUploadView()
                        return
                    }

                    guard let process = response.data else {
                        showError(.generalError, "No se pudo cargar el archivo.")
                        removeUploadView()
                        return
                    }

                    switch process {
                    case .processing:
                        view.loadPercent = "Procesando..."
                        view.chekUploadState(wait: 7)
                    case .processed(let payload):
                        view.isLoaded = true
                        view.loadPercent = ""
                        view.mediaId = payload.mediaid
                        view.width = payload.width
                        view.height = payload.height
                        view.file = payload.fileName
                        view.image = payload.avatar
                        view.loadImage(payload.avatar)
                    }
                } catch {
                    showError(.generalError, .serverConextionError)
                    removeUploadView()
                }
            }

            xhr.upload.addEventListener(
                "progress",
                options: EventListenerAddOptions(
                    capture: false,
                    once: false,
                    passive: false,
                    mozSystemGroup: false
                )
            ) { event in
                let progressEvent = ProgressEvent(event.jsEvent)
                guard progressEvent.total > 0 else { return }

                view.loadPercent = "\(((Double(progressEvent.loaded) / Double(progressEvent.total)) * 100).toInt)%"
            }

            let formData = FormData()
            let fileName = safeFileName(name: file.name, to: .assetItem, folio: nil)

            formData.append("file", file, filename: fileName)
            formData.append("eventid", view.viewId.uuidString)
            formData.append("to", ImagePickerTo.assetItem.rawValue)
            formData.append("fileName", fileName)
            formData.append("connid", custCatchChatConnID)
            formData.append("remoteCamera", false.description)

            xhr.open(method: "POST", url: "https://api.tierracero.co/cust/v1/uploadManager")
            xhr.setRequestHeader("Accept", "application/json")
            xhr.setRequestHeader("WSId", custCatchChatConnID)

            if let jsonData = try? JSONEncoder().encode(APIHeader(
                AppID: thisAppID,
                AppToken: thisAppToken,
                url: custCatchUrl,
                user: custCatchUser,
                mid: custCatchMid,
                key: custCatchKey,
                token: custCatchToken,
                tcon: .web,
                applicationType: custCatchAccountType.sessionType
            )),
            let string = String(data: jsonData, encoding: .utf8),
            let encoded = string.data(using: .utf8)?.base64EncodedString() {
                xhr.setRequestHeader("Authorization", encoded)
            }

            xhr.send(formData)
        }

        private func refreshLocations() {
            let available = locations
                .filter {
                    $0.linkType == viewType.relationType &&
                    $0.linkedTo == viewType.relationId
                }
                .map { AssetLocationPicker.PickerOption(id: $0.id, name: $0.name) }
            if let selectedLocationId,
               !available.contains(where: { $0.id == selectedLocationId }) {
                self.selectedLocationId = nil
                self.selectedSubLocationId = nil
            }
            if available.count == 1, selectedLocationId == nil {
                selectedLocationId = available[0].id
            }
            locationPicker.setOptions(available, selectedId: selectedLocationId)
            refreshSections()
        }

        private func refreshSections() {
            let available = subLocations
                .filter { $0.commercialAssetsLocationId == selectedLocationId }
                .map { AssetLocationPicker.PickerOption(id: $0.id, name: $0.name) }
            if let selectedSubLocationId,
               !available.contains(where: { $0.id == selectedSubLocationId }) {
                self.selectedSubLocationId = nil
            }
            if available.count == 1, selectedSubLocationId == nil {
                selectedSubLocationId = available[0].id
            }
            sectionPicker.setOptions(available, selectedId: selectedSubLocationId)
        }

        private func openLocationEditor(
            initialName rawName: String,
            completion: @escaping (AssetLocationPicker.PickerOption?) -> Void
        ) {
            addToDom(
                LocationEditor(
                    relationType: viewType.relationType,
                    relationId: viewType.relationId,
                    initialName: rawName
                ) { location in
                    self.locations = self.locations.filter { $0.id != location.id } + [location]
                    self.onLocationCreated(location)
                    self.selectedLocationId = location.id
                    self.selectedSubLocationId = nil
                    self.refreshLocations()
                    completion(.init(id: location.id, name: location.name))
                }
            )
        }

        private func openSubLocationEditor(
            initialName rawName: String,
            completion: @escaping (AssetLocationPicker.PickerOption?) -> Void
        ) {
            guard let locationId = selectedLocationId,
                  let location = locations.first(where: { $0.id == locationId }) else {
                showError(.requiredField, .requierdValid("Ubicación"))
                completion(nil)
                return
            }

            addToDom(
                SubLocationEditor(
                    location: location,
                    initialName: rawName
                ) { subLocation in
                    self.subLocations = self.subLocations.filter { $0.id != subLocation.id } + [subLocation]
                    self.onSubLocationCreated(subLocation)
                    self.selectedSubLocationId = subLocation.id
                    self.refreshSections()
                    completion(.init(id: subLocation.id, name: subLocation.name))
                }
            )
        }

        private func readOnly(_ title: String, _ value: String) -> Div {
            Div {
                UMinorTitle(title)
                USubTitle(value)
                    .class(.oneLineText)
                    .marginTop(3.px)
            }
            .custom("min-width", "0")
        }

        private func parseCents(_ value: String) -> Int64? {
            Float(
                value
                    .replace(from: ",", to: "")
                    .replace(from: "$", to: "")
            )?.toCents
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $name.removeAllListeners()
            $serial.removeAllListeners()
            $serviceCard.removeAllListeners()
            $acquisitionCost.removeAllListeners()
            $currentCost.removeAllListeners()
            $locations.removeAllListeners()
            $subLocations.removeAllListeners()
            $selectedAvatar.removeAllListeners()
            mediaFileInput.$files.removeAllListeners()
        }
    }
}

extension CustAssetsView.InitiateAssetItemViewType {

    var assetCoordinates: (latitude: Double?, longitude: Double?) {
        func coordinates(from store: CustStore) -> (latitude: Double?, longitude: Double?) {
            (Double(store.lat ?? ""), Double(store.lon ?? ""))
        }

        switch self {
        case .store(let store), .warehose(let store):
            return coordinates(from: store)
        case .account(_, let store), .subAccount(_, let store):
            return coordinates(from: store)
        }
    }
}

extension CustAssetsView {

    final class AssetLocationPicker: Div {

        override class var name: String { "div" }

        struct PickerOption {
            let id: UUID
            let name: String
        }

        private let title: String
        private let addTitle: String
        private let onSelect: (UUID) -> Void
        private let onCreate: (String, @escaping (PickerOption?) -> Void) -> Void

        @State private var query = ""
        @State private var isOpen = false

        @State private var options: [PickerOption] = []
        @State private var displayedOptions: [PickerOption] = []

        private lazy var input = UTextField(self.$query)
            .placeholder("Buscar \(title.lowercased())")
            .width(100.percent)
            .onFocus { _ in
                self.isOpen = true
                self.renderOptions()
            }
            .onBlur {
                Dispatch.asyncAfter(0.25) {
                    self.isOpen = false
                    self.renderOptions()
                }
            }

        private lazy var results = Div()
            .backgroundColor(.grayBlackDark)
            .borderRadius(all: 8.px)
            .padding(all: 5.px)
            .width(100.percent)
            .maxHeight(220.px)
            .overflow(.auto)

        private lazy var addButton = ULargeButton(addTitle)
            .width(100.percent)
            .onClick {
                self.create()
            }

        init(
            title: String,
            addTitle: String,
            onSelect: @escaping (UUID) -> Void,
            onCreate: @escaping (String, @escaping (PickerOption?) -> Void) -> Void
        ) {
            self.title = title
            self.addTitle = addTitle
            self.onSelect = onSelect
            self.onCreate = onCreate
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {

            Div {
                Img()
                    .src("/skyline/media/add.png")
                    .marginRight(3.px)
                    .cursor(.pointer)
                    .float(.right)
                    .width(18.px)
                    .onClick {
                        self.create()
                    }

                Label(self.title)
                .class(.init("tc-u-field-label"))
            }

            Div().clear(.both).height(3.px)

            Div {
                self.input
                self.results
                self.addButton
                .hidden(self.$options.map{ !$0.isEmpty })
                .display(self.$options.map{ !$0.isEmpty ? .none : .block })
            }
            .position(.relative)
        }

        override func buildUI() {
            super.buildUI()
            $query.listen { [weak self] _ in
                self?.renderOptions()
            }
        }

        func setOptions(_ options: [PickerOption], selectedId: UUID?) {
            self.options = options.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }

            if let selectedId,
               let selected = self.options.first(where: { $0.id == selectedId }) {
                query = selected.name
            } else {
                query = ""
            }

            renderOptions()
        }

        private func renderOptions() {
            displayedOptions = options.filter {
                query.purgeSpaces.isEmpty ||
                $0.name.localizedCaseInsensitiveContains(query.purgeSpaces)
            }
            results.innerHTML = ""

            displayedOptions.forEach { option in
                results.appendChild(
                    Div(option.name)
                        .class(.uibtnLarge)
                        .width(100.percent)
                        .onClick {
                            self.query = option.name
                            self.isOpen = false
                            self.onSelect(option.id)
                            self.renderOptions()
                        }
                )
            }

            results.hidden(!isOpen || options.isEmpty || displayedOptions.isEmpty)
            input.hidden(options.isEmpty)
        }

        private func created(_ option: PickerOption?) {
            guard let option else { return }
            query = option.name
            isOpen = false
            onSelect(option.id)
            renderOptions()
        }

        private func create() {
            onCreate(query) { [weak self] option in
                self?.created(option)
            }
        }
    }
}
