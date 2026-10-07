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

        /// singleItem, multiItem
        let createType: ViewCreateType

        /// store, warehose, account, subAccount
        let viewType: InitiateAssetItemViewType

        let purchasFiscalDocumentFolio: String

        let asset: CustCommercialAssets

        let department: CustAssetDepsQuick
        
        let categorie: CustAssetCatsQuick?

        // Regulates the primary location, EG: Office 1
        @State var sections: [CustCommercialAssetsSection]

        // Regulates the secondarie location, EG: cubical 1 (in Office 1)
        @State var subSections: [CustCommercialAssetsSubSection]

        let callback: (CallbackType) -> Void

        let onSectionCreated: (CustCommercialAssetsSection) -> Void
        
        let onSubSectionCreated: (CustCommercialAssetsSubSection) -> Void

        var uploadFileControler: [UUID:ImageGeneralView]  = [:]

        let ws = WS()
    
        init(
            createType: ViewCreateType,
            viewType: InitiateAssetItemViewType,
            purchasFiscalDocumentFolio: String,
            asset: CustCommercialAssets,
            department: CustAssetDepsQuick,
            categorie: CustAssetCatsQuick?,
            sections: [CustCommercialAssetsSection],
            subSections: [CustCommercialAssetsSubSection],
            onSectionCreated: @escaping (CustCommercialAssetsSection) -> Void,
            onSubSectionCreated: @escaping (CustCommercialAssetsSubSection) -> Void,
            callback: @escaping (CallbackType) -> Void
        ) {
            self.createType = createType
            self.viewType = viewType
            self.purchasFiscalDocumentFolio = purchasFiscalDocumentFolio
            self.asset = asset
            self.department = department
            self.categorie = categorie
            self.acquisitionCost = asset.initialCost.formatMoney
            self.currentCost = asset.initialCost.formatMoney
            self.sections = sections
            self.subSections = subSections
            self.onSectionCreated = onSectionCreated
            self.onSubSectionCreated = onSubSectionCreated
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
        private var selectedSectionId: UUID?
        private var selectedSubSectionId: UUID?

        private var imageRefrence: [UUID: ImageGeneralView] = [:]
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

        private lazy var sectionPicker = AssetLocationPicker(
            title: "Ubicación", addTitle: "Agregar Ubicación",
            onSelect: { [weak self] id in
                guard let self else { return }
                self.selectedSectionId = id
                self.selectedSubSectionId = nil
                self.refreshSubSections()
            },
            onCreate: { [weak self] name, completion in
                self?.openSectionEditor(initialName: name, completion: completion)
            }
        )

        private lazy var subSectionPicker = AssetLocationPicker(
            title: "Sección", addTitle: "Agregar Sección",
            onSelect: { [weak self] id in self?.selectedSubSectionId = id },
            onCreate: { [weak self] name, completion in
                self?.openSubSectionEditor(initialName: name, completion: completion)
            }
        )

        lazy var serviceCardField = UTextField(self.$serviceCard)
            .placeholder("Opcional")
            .custom("width", "calc(100% - 28px)")

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

                            Div{
                                Img()
                                    .src("/skyline/media/mobileCamara.png")
                                    .class(.iconWhite)
                                    .marginLeft( 3.px)
                                    .cursor(.pointer)
                                    .marginTop(7.px)
                                    .height(28.px)
                                    .onClick {

                                        loadingView.show()

                                        API.custAPIV1.requestMobileCamara(
                                            type: .useCamaraForAssetItem,
                                            connid: custCatchChatConnID,
                                            eventid: nil,
                                            relatedid: nil,
                                            relatedfolio: "",
                                            multipleTakes: true
                                        ) { resp in
                                            
                                            loadingView.hide()
                                            
                                            guard let resp else {
                                                showError(.comunicationError, .serverConextionError)
                                                return
                                            }
                                            
                                            guard resp.status == .ok else {
                                                showError(.generalError, resp.msg)
                                                return
                                            }
                                            
                                            showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
                                            
                                        }

                                    }
                            }
                            .float(.right)



                            UTitle("Fotos")

                            self.mediaFileInput


                        }

                        self.mediaGrid
                    }

                    VGrid(.oneForth) {
                        UField("Nombre", required: false) {
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

                            self.serviceCardField
                            
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

                    VGrid(.oneForth) { self.sectionPicker }

                    VGrid(.oneForth) { self.subSectionPicker }

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


            WebApp.current.wsevent.listen {
                
                if $0.isEmpty { return }
                
                let (event, _) = self.ws.recive($0)
                
                guard let event else {
                    return
                }
                    
                switch event {
                case .requestMobileCamaraComplete:
                    
                    if let payload = self.ws.requestMobileCamaraComplete($0) {
                        
                        if let view = self.imageRefrence[payload.eventid] {
                            
                            view.loadPercent = ""
                            
                            view.mediaId = payload.id
                            
                            view.width = payload.width
                            
                            view.height = payload.height
                            
                            view.file = payload.file
                            
                            view.image = payload.avatar
                            
                            view.loadImage(payload.avatar)
                            
                            var hasAvatar = false
                            
                            self.imageRefrence.forEach { _, view in
                                if view.isAvatar {
                                    hasAvatar = true
                                }
                            }
                            
                            if !hasAvatar {
                                //view.setAsAvatar(image: payload.avatar)
                            }
                            
                        }
                    }

                case .requestMobileCamaraFail:
                    if let payload = self.ws.requestMobileCamaraFail($0) {
                        
                        if  let view = self.imageRefrence[payload.eventid] {
                            self.imageRefrence.removeValue(forKey: view.viewId)
                            view.remove()
                        }
                        
                    }
                case .requestMobileCamaraInitiate:
                    if let payload = self.ws.requestMobileCamaraInitiate($0) {
                        

                        guard let view = self.imageRefrence[payload.eventid] else {
                            
                            let view = ImageGeneralView(
                                        relation: .assetItem,
                                        relationId: nil,
                                        type:  .img,
                                        mediaId: nil,
                                        file: nil,
                                        image: nil,
                                        descr: "",
                                        width: 0,
                                        height: 0,
                                        selectedAvatar: self.$selectedAvatar,
                                        callback: { [weak self] viewId, _, _, originalImage, originalWidth, originalHeight, _ in
                                            guard let view = self?.uploadFileControler[viewId] else { return }
                                            view.file = originalImage
                                            view.width = originalWidth
                                            view.height = originalHeight
                                        },
                                        imAvatar: { [weak self] _, name in
                                            self?.selectedAvatar = name
                                        },
                                        removeMe: { [weak self] viewId in
                                            self?.uploadFileControler.removeValue(forKey: viewId)
                                            self?.imageOrder.removeAll { $0 == viewId }
                                        }
                                    )

                            self.imageOrder.append(view.viewId)

                            self.imageRefrence[payload.eventid] = view

                            self.mediaGrid.appendChild(view)

                            view.loadPercent = "Iniciando Carga..."

                            return
                        }

                        self.mediaGrid.appendChild(view)
                        
                        //_ = JSObject.global.scrollToBottom!("pocImageContainer")
                        
                    }
                case .requestMobileCamaraProgress:
                    
                    guard let payload = self.ws.requestMobileCamaraProgress($0) else {
                        return
                    }
                    
                    guard let view = self.imageRefrence[payload.eventid] else {
                        return
                    }
                    
                    view.loadPercent = "\(payload.percent.toString)%"
                    

                case .requestMobileCamaraCancel:

                    if let payload = self.ws.requestMobileCamaraCancel($0) {
                        
                        if  let view = self.imageRefrence[payload.eventid] {
                            self.imageRefrence.removeValue(forKey: view.viewId)
                            view.remove()
                        }
                        
                    }
                case .requestMobileCamaraSelected:

                    if let payload = self.ws.requestMobileCamaraSelected($0) {

                        guard let view = self.imageRefrence[payload.eventid] else {
                            
                            let view = ImageGeneralView(
                                        relation: .assetItem,
                                        relationId: nil,
                                        type:  .img,
                                        mediaId: nil,
                                        file: nil,
                                        image: nil,
                                        descr: "",
                                        width: 0,
                                        height: 0,
                                        selectedAvatar: self.$selectedAvatar,
                                        callback: { [weak self] viewId, _, _, originalImage, originalWidth, originalHeight, _ in
                                            guard let view = self?.uploadFileControler[viewId] else { return }
                                            view.file = originalImage
                                            view.width = originalWidth
                                            view.height = originalHeight
                                        },
                                        imAvatar: { [weak self] _, name in
                                            self?.selectedAvatar = name
                                        },
                                        removeMe: { [weak self] viewId in
                                            self?.uploadFileControler.removeValue(forKey: viewId)
                                            self?.imageOrder.removeAll { $0 == viewId }
                                        }
                                    )

                            self.imageOrder.append(view.viewId)

                            self.imageRefrence[payload.eventid] = view

                            self.mediaGrid.appendChild(view)

                            view.loadPercent = "Iniciando Carga..."

                            return
                        }
                        
                        view.loadPercent = "Iniciando Carga..."
                    }

                case .asyncFileUpload:
                    
                    if let payload = self.ws.asyncFileUpload($0) {
                        
                        if let view = self.imageRefrence[payload.eventid] {

                            view.isLoaded = true
                            
                            view.loadPercent = ""
                            
                            view.mediaId = payload.mediaid
                            
                            view.width = payload.width
                            
                            view.height = payload.height
                            
                            
                            view.file = payload.fileName
                            
                            view.image = payload.fileName
                            
                            view.loadImage(payload.avatar)
                            
                            
                        }
                    }
                    
                case .asyncFileUpdate:
                    
                    guard let payload = self.ws.asyncFileUpdate($0) else {
                        return
                    }
                    
                    guard let view = self.imageRefrence[payload.eventId] else {
                        return
                    }
                    
                    view.loadPercent = payload.message
                    
                case .asyncFileOCR:
                    break
                case .asyncCropImage:
                    
                    guard let payload = self.ws.asyncCropImage($0) else {
                        return
                    }
                    guard let view = self.imageRefrence[payload.eventid] else {
                        return
                    }
                    
                    view.isLoaded = true
                    
                    view.loadPercent = ""
                    
                    view.file = payload.fileName
                    
                    view.image = payload.fileName
                    
                    view.loadImage( payload.fileName )
                    
                    if view.isAvatar {
                        self.selectedAvatar = payload.fileName
                        view.isAvatar = true
                    }
                default:
                    break
                }
                }
                

        }

        override func didAddToDOM() {
            super.didAddToDOM()
            refreshSections()
        }

        func addwarrantyCard() {

            let view = AddWarrantyCard(
                loadType:.preloadAsset
            ) { cardCode in
            
                self.serviceCard = cardCode

                self.serviceCardField.disabled(true)
                
            }

            addToDom(view)
            
        }
        private func create() {
            name = name.purgeSpaces.purgeHtml

            guard let acquisitionCost = parseCents(acquisitionCost) else {
                showError(.generalError, "Ingrese un costo de adquisición válido")
                return
            }

            guard let currentCost = parseCents(currentCost) else {
                showError(.generalError, "Ingrese un costo actual válido")
                return
            }

            guard let sectionId = selectedSectionId else {
                showError(.requiredField, .requierdValid("Ubicación"))
                return
            }

            guard !uploadFileControler.values.contains(where: { !$0.isLoaded || $0.file == nil }) else {
                showError(.generalError, "Espere a que terminen de cargar las fotos y videos.")
                return
            }

            let images: [CustAssetsComponents.CreateAssetItemFile] = imageOrder.compactMap { viewId in
                guard let view = uploadFileControler[viewId], let fileName = view.file else {
                    return nil
                }

                return .init(
                    fileName: fileName,
                    isAvatar: view.isAvatar || view.image.map { $0 == selectedAvatar } == true
                )
            }

            let item: CustAssetsComponents.CreateAssetItemObject = CustAssetsComponents.CreateAssetItemObject(
                section: sectionId,
                subSection: selectedSubSectionId,
                acquisitionAt: getNow(),
                acquisitionCost: acquisitionCost,
                currentCost: currentCost,
                serial: serial.isEmpty ? nil : serial.purgeSpaces,
                name: name,
                serviceCard: serviceCard.isEmpty ? nil : serviceCard.purgeSpaces,
                images: images
            )

            if createType == .multiItem {
                self.remove()
                self.callback(.preItem(item))
                return
            }

            loadingView.show()

            API.custAssetsV1.createAssettem(
                type: viewType,
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio.purgeSpaces,
                purchasFiscalDocumentId: nil,
                commercialAssetId: asset.id,
                department: asset.assetDepartmentId,
                categorie: asset.assetSeccionId,
                subcategorie: sectionId,
                items: [item]
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

                guard let items = response.data?.items, !items.isEmpty else {
                    loadingView.hide()
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                loadingView.hide()
                showSuccess(.operacionExitosa, "Unidad ingresada")

                self.callback(.createdItems(items))

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
                    guard let view = self?.uploadFileControler[viewId] else { return }
                    view.file = originalImage
                    view.width = originalWidth
                    view.height = originalHeight
                },
                imAvatar: { [weak self] _, name in
                    self?.selectedAvatar = name
                },
                removeMe: { [weak self] viewId in
                    self?.uploadFileControler.removeValue(forKey: viewId)
                    self?.imageOrder.removeAll { $0 == viewId }
                }
            )

            uploadFileControler[view.viewId] = view
            
            imageOrder.append(view.viewId)

            func removeUploadView() {
                uploadFileControler.removeValue(forKey: view.viewId)
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

        private func refreshSections() {
            
            let available = sections
                .filter {
                    $0.linkType == viewType.relationType &&
                    $0.linkedTo == viewType.relationId
                }
                .map { AssetLocationPicker.PickerOption(id: $0.id, name: $0.name) }
            if let selectedSectionId,
               !available.contains(where: { $0.id == selectedSectionId }) {
                self.selectedSectionId = nil
                self.selectedSubSectionId = nil
            }
            if available.count == 1, selectedSectionId == nil {
                selectedSectionId = available[0].id
            }
            sectionPicker.setOptions(available, selectedId: selectedSectionId)
            refreshSubSections()
        }

        private func refreshSubSections() {
            let available = subSections
                .filter { $0.commercialAssetsLocationId == selectedSectionId }
                .map { AssetLocationPicker.PickerOption(id: $0.id, name: $0.name) }
            if let selectedSubSectionId,
               !available.contains(where: { $0.id == selectedSubSectionId }) {
                self.selectedSubSectionId = nil
            }
            if available.count == 1, selectedSubSectionId == nil {
                selectedSubSectionId = available[0].id
            }
            subSectionPicker.setOptions(available, selectedId: selectedSubSectionId)
        }

        private func openSectionEditor(
            initialName rawName: String,
            completion: @escaping (AssetLocationPicker.PickerOption?) -> Void
        ) {
            addToDom(
                LocationEditor(
                    relationType: viewType.relationType,
                    relationId: viewType.relationId,
                    initialName: rawName
                ) { section in
                    self.sections = self.sections.filter { $0.id != section.id } + [section]
                    self.onSectionCreated(section)
                    self.selectedSectionId = section.id
                    self.selectedSubSectionId = nil
                    self.refreshSections()
                    completion(.init(id: section.id, name: section.name))
                }
            )
        }

        private func openSubSectionEditor(
            initialName rawName: String,
            completion: @escaping (AssetLocationPicker.PickerOption?) -> Void
        ) {
            guard let sectionId = selectedSectionId,
                  let section = sections.first(where: { $0.id == sectionId }) else {
                showError(.requiredField, .requierdValid("Ubicación"))
                completion(nil)
                return
            }

            addToDom(
                SubLocationEditor(
                    section: section,
                    initialName: rawName
                ) { subSection in
                    self.subSections = self.subSections.filter { $0.id != subSection.id } + [subSection]
                    self.onSubSectionCreated(subSection)
                    self.selectedSubSectionId = subSection.id
                    self.refreshSubSections()
                    completion(.init(id: subSection.id, name: subSection.name))
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
            $sections.removeAllListeners()
            $subSections.removeAllListeners()
            $selectedAvatar.removeAllListeners()
            mediaFileInput.$files.removeAllListeners()
        }
    }
}

extension CustAssetsView {

    /// singleItem, multiItem
    enum ViewCreateType {

        case singleItem

        case multiItem

    }

    enum CallbackType {

        case createdItems([CustCommercialAssetsItem])

        case preItem(CustAssetsComponents.CreateAssetItemObject)

    }

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
