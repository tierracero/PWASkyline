//
// CustAssets+AssetItemView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class AssetItemView: Div {

        override class var name: String { "div" }

        private enum ItemTab: Equatable {
            case map
            case kardex
        }

        let assetItemId: UUID

        let onLoaded: ((CustCommercialAssetsItem) -> Void)?

        init(
            assetItemId: UUID,
            onLoaded: ((CustCommercialAssetsItem) -> Void)? = nil
        ) {
            self.assetItemId = assetItemId
            self.onLoaded = onLoaded
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State private var title = "Cargando unidad…"

        @State private var activeTab: ItemTab = .map

        @State private var avatar = ""

        @State private var noteCount = 0

        /// active, unavailable, inactive, merm, returned, transit, tomerm
        @State var status: CustCommercialAssetsItemStatus = .unavailable

        private var kardexLoaded = false

        private lazy var contentView = Div()
            .id(.init("assetItemContent_\(callKey(7))"))
            .height(100.percent)
            .custom("min-height", "0")

        private lazy var notesGrid = VGrid(.full) {}
            .custom("min-height", "0")
            .height(100.percent)
            .marginTop(10.px)
            .overflow(.auto)

        private let mapId = "asset_item_map_" + callKey(32)

        private lazy var mapContainer = Div()
            .id(.init(mapId))
            .height(100.percent)
            .custom("min-height", "280px")
            .custom("border-radius", "10px")
            .custom("overflow", "hidden")
            .custom("background", "rgba(3, 18, 32, 0.68)")

        private lazy var kardexGrid = Div()
            .custom("min-height", "0")
            .height(100.percent)
            .overflow(.auto)


        @DOM override var body: DOM.Content {
            VPopUp(.full) {

                VTitle(self.$title, icon: "commertial_assets_icon.png") {
                    USmallTitle("Detalle de inventario")
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

        func load() {

            loadingView.show()

            API.custAssetsV1.getAssetItem(assetItemId: assetItemId) { response in
                loadingView.hide()

                guard let response else {
                    showError(.comunicationError, .serverConextionError)
                    self.renderError("No fue posible consultar la unidad.")
                    return
                }

                guard response.status == .ok else {
                    showError(.generalError, response.msg)
                    self.renderError(response.msg)
                    return
                }

                guard let payload = response.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    self.renderError("El servidor no devolvió el detalle de la unidad.")
                    return
                }

                self.title = "Activo \(payload.department?.assetType.description ?? "N/D") | \(payload.item.name)"
                self.avatar = payload.item.avatar ?? ""
                self.status = payload.item.status
                self.render(payload)
                self.onLoaded?(payload.item)
            }
        }

        private func render(_ payload: CustAssetsComponents.GetAssetItemResponse) {
            contentView.innerHTML = ""
            notesGrid.innerHTML = ""
            kardexGrid.innerHTML = ""
            kardexLoaded = false

            renderNotes(payload.notes)

            let editor = VGrid(.full) {
                VGrid(.oneThird) {
                    self.mediaColumn(payload)
                }

                VGrid(.twoThirds) {
                    self.dataColumn(payload)
                }

                VGrid(.oneThird) {

                    VBox(.raised) {
                        UTitle(self.$noteCount.map { "Notas (\($0))" })
                        self.notesGrid
                    }
                    .custom("grid-template-rows", "auto minmax(0, 1fr)")
                    .custom("min-height", "0")
                    .height(100.percent)
                    .display(.grid)
                }
                .height(100.percent)
                .custom("min-height", "0")
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-content", "stretch")

                VGrid(.twoThirds) {
                    self.activityColumn()
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
            .backgroundColor(.backGroundGraySlate)

            contentView.appendChild(editor)
            loadMap(payload.item)
        }

        private func mediaColumn(_ payload: CustAssetsComponents.GetAssetItemResponse) -> Div {
            VGrid(.full) {
                VGrid(.half) {
                    VBox(.raised) {
                        UTitle("Fotos y videos")

                        CustAssetsAvatarUploader(
                            avatar: self.$avatar,
                            destination: .assetItem,
                            itemId: payload.item.id
                        )
                        .marginTop(8.px)

                        self.mediaGrid(payload.images)
                    }
                }

                VGrid(.half) {
                    self.readOnlyField("Departamento", payload.department?.name)
                    self.readOnlyField("Categoría", payload.categorie?.name)
                    self.readOnlyField("Tipo de ubicación", payload.item.currentLocation.description)
                    self.readOnlyField("Estado", payload.item.status.description.capitalized)
                }

                VGrid(.full) {
                    VBox(.raised) {
                        UTitle("Estado general")

                        VGrid(.full) {
                            VGrid(.half) {
                                self.readOnlyField("Costo de adquisición", payload.item.acquisitionCost.formatMoney)
                            }

                            VGrid(.half) {
                                self.readOnlyField("Costo actual", payload.item.currentCost.formatMoney)
                            }

                            VGrid(.half) {
                                self.readOnlyField("Serie", payload.item.serial)
                            }

                            VGrid(.half) {
                                self.readOnlyField("Folio", payload.item.folio)
                            }
                        }
                        .marginTop(10.px)
                    }
                }
            }
        }

        private func dataColumn(_ payload: CustAssetsComponents.GetAssetItemResponse) -> Div {
            let item = payload.item

            return VBox(.raised) {
                UTitle("Datos de la unidad")

                VGrid(.full) {
                    VGrid(.oneForth) {
                        self.readOnlyField("Folio", item.folio)
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Nombre", item.name)
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Serie", item.serial)
                    }

                    VGrid(.oneForth) {

                        UField("Estado", required: false) {
                        // 
                    
                            Div{
                                
                                Div{
                                    Span(self.$status.map{ $0.description })
                                    .margin(all: 3.px)
                                }
                                    .custom("width", "calc(100% - 38px)")
                                    .class(.oneLineText)
                                    .color(.white)
                                    .float(.left)
                                 
                                 Div{
                                     Img()
                                         .src("/skyline/media/dropDown.png")
                                         .class(.iconWhite)
                                         .opacity(0.8)
                                         .width(18.px)
                                         .marginTop(3.px)
                                 }
                                 .borderLeft(
                                    width: BorderWidthType.thin,
                                    style: .solid,
                                    color: .white
                                 )
                                 .paddingRight(3.px)
                                 .paddingLeft(7.px)
                                 .marginLeft(7.px)
                                 .float(.right)
                                 .width(18.px)
                                
                                 Div().clear(.both)
                                 
                            }
                            .class(.uibtn)
                            .width(150.px)

                        }

                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Folio de compra", item.purchasFiscalDocumentFolio)
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField(
                            "Tarjetas de servicio",
                            item.serviceCard.isEmpty ? nil : item.serviceCard.joined(separator: ", ")
                        )
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Tipo de Ubicación", payload.location.description)
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Nombre de ubicación", payload.location.name)
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Ubicación", payload.section?.name)
                    }

                    VGrid(.oneForth) {
                        self.readOnlyField("Sección", payload.subSection?.name)
                    }

                }
                .marginTop(10.px)
            }
        }

        private func activityColumn() -> Div {
            VBox(.raised) {
                Div {

                    self.tabButton("Mapa", tab: .map)
                    .float(.left)
                    self.tabButton("Kardex", tab: .kardex)
                    .float(.left)
                }
                .custom("justify-content", "space-between")
                .custom("align-items", "center")
                .custom("gap", "10px")

                Div {
                    self.mapContainer
                }
                .hidden(self.$activeTab.map { $0 != .map })
                .custom("min-height", "0")
                .height(100.percent)
                .marginTop(10.px)

                Div {
                    self.kardexGrid
                }
                .hidden(self.$activeTab.map { $0 != .kardex })
                .custom("min-height", "0")
                .height(100.percent)
                .marginTop(10.px)
                .onClick {
                    self.loadKardex()
                }
            }
            .custom("grid-template-rows", "auto minmax(0, 1fr)")
            .custom("min-height", "0")
            .height(100.percent)
            .display(.grid)
        }

        private func mediaGrid(_ images: [CustFiles]) -> Div {
            guard !images.isEmpty else {
                return Div()
            }

            let grid = Div()
                .display(.grid)
                .custom("grid-template-columns", "repeat(auto-fit, minmax(90px, 1fr))")
                .custom("gap", "6px")
                .marginTop(10.px)

            images.forEach { image in
                grid.appendChild(
                    Img()
                        .src(self.imageSource(image))
                        .width(100.percent)
                        .height(92.px)
                        .custom("object-fit", "contain")
                        .custom("border", "1px solid rgba(66, 183, 245, 0.28)")
                        .custom("border-radius", "8px")
                )
            }

            return grid
        }

        private func renderNotes(_ notes: [CustGeneralNotes]) {
            noteCount = notes.count

            if notes.isEmpty {
                notesGrid.appendChild(emptyState("No hay notas registradas para esta unidad."))
                return
            }

            notes.forEach { note in
                notesGrid.appendChild(noteView(note))
            }
        }

        private func noteView(_ note: CustGeneralNotes) -> Div {
            VBox(.raised) {
                Div(note.activity)
                    .custom("white-space", "pre-wrap")
                    .custom("line-height", "1.45")

                UMinorTitle(note.type.rawValue)
                    .marginTop(5.px)
            }
        }

        private func tabButton(_ title: String, tab: ItemTab) -> Div {
            Div(title)
                .padding(v: 7.px, h: 12.px)
                .cursor(.pointer)
                .fontWeight(.bold)
                .color(self.$activeTab.map { $0 == tab ? .white : .gray })
                .backgroundColor(self.$activeTab.map {
                    $0 == tab ? .init(r: 37, g: 90, b: 124, a: 0.82) : .transparent
                })
                .custom("border", "1px solid rgba(102, 184, 236, 0.24)")
                .custom("border-radius", "8px")
                .onClick {
                    self.activeTab = tab

                    if tab == .kardex {
                        self.loadKardex()
                    }
                }
        }

        private func readOnlyField(_ label: String, _ value: String?) -> Div {
            UField(label, required: false) {
                USubTitle(value?.isEmpty == false ? value! : "—")
                    .class(.oneLineText)
            }
        }

        private func imageSource(_ image: CustFiles) -> String {
            let value = image.avatar.isEmpty ? image.file : image.avatar
            let normalized = value.purgeSpaces

            guard !normalized.isEmpty else {
                return "/skyline/media/tierraceroRoundLogoWhite.svg"
            }

            guard !normalized.hasPrefix("/") &&
                    !normalized.hasPrefix("http://") &&
                    !normalized.hasPrefix("https://") else {
                return normalized
            }

            return ImagePickerTo.assetItem.url(
                url: custCatchUrl,
                pDir: pDir,
                isPreRegistration: false,
                accountType: custCatchAccountType
            ) + normalized
        }

        private func loadMap(_ item: CustCommercialAssetsItem) {
            mapContainer.innerHTML = ""

            guard let latitude = item.latitude, let longitude = item.longitude else {
                mapContainer.appendChild(
                    emptyState("No hay coordenadas registradas para esta unidad.")
                )
                return
            }

            API.v1.jwt { token in
                guard let token else {
                    self.mapContainer.appendChild(
                        emptyState("No fue posible cargar el mapa.")
                    )
                    return
                }

                let _ = JSObject.global.initiateSingleMapCord!(
                    self.mapId,
                    token,
                    latitude,
                    longitude,
                    JSClosure { _ in .undefined }.jsValue
                )
            }
        }

        private func loadKardex() {
            guard !kardexLoaded else { return }
            kardexLoaded = true
            kardexGrid.innerHTML = ""
            kardexGrid.appendChild(UMinorTitle("Cargando kardex…"))

            API.custAssetsV1.getAssetItemKardex(assetItemId: assetItemId) { response in
                self.kardexGrid.innerHTML = ""

                guard let response else {
                    self.kardexGrid.appendChild(
                        emptyState("No fue posible consultar el kardex.")
                    )
                    return
                }

                guard response.status == .ok else {
                    self.kardexGrid.appendChild(emptyState(response.msg))
                    return
                }

                guard let payload = response.data, !payload.events.isEmpty else {
                    self.kardexGrid.appendChild(
                        emptyState("No hay movimientos registrados para esta unidad.")
                    )
                    return
                }

                if !payload.currentStateMatchesLatestEvent {
                    self.kardexGrid.appendChild(
                        UMinorTitle("El estado actual difiere del último evento registrado.")
                            .color(.orange)
                            .marginBottom(8.px)
                    )
                }

                payload.events.forEach { event in
                    self.kardexGrid.appendChild(self.kardexEventView(event))
                }
            }
        }

        private func kardexEventView(_ event: CustCommercialAssetsItemKardex) -> Div {
            VBox(.raised) {
                Div {
                    USubTitle(event.eventType.description)
                        .class(.oneLineText)

                    UMinorTitle(getDate(event.createdAt).formatedLong)
                        .class(.oneLineText)
                        .marginTop(2.px)
                }

                Div {
                    self.detail("Ubicación", event.toLinkType?.description)
                    self.detail("ID de ubicación", event.toLinkedTo?.uuidString.lowercased())
                    self.detail("Estado", event.toStatus?.description.capitalized)
                    self.detail("Archivos", event.images.isEmpty ? "—" : String(event.images.count))
                }
                .display(.grid)
                .custom("grid-template-columns", "repeat(auto-fit, minmax(150px, 1fr))")
                .custom("gap", "6px")
                .marginTop(8.px)

                Div {
                    self.detail("Latitud", event.latitude.map { String($0) })
                    self.detail("Longitud", event.longitude.map { String($0) })
                    self.detail("Nota", event.noteId?.uuidString.lowercased())
                }
                .display(.grid)
                .custom("grid-template-columns", "repeat(auto-fit, minmax(150px, 1fr))")
                .custom("gap", "6px")
                .marginTop(6.px)
            }
            .marginBottom(8.px)
        }

        private func detail(_ label: String, _ value: String?) -> Div {
            Div {
                UMinorTitle(label)
                Div(value?.isEmpty == false ? value! : "—")
                    .class(.oneLineText)
                    .marginTop(2.px)
                    .attribute("title", value ?? "")
            }
            .padding(all: 8.px)
            .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
            .custom("border-radius", "8px")
            .custom("background", "rgba(5, 17, 27, 0.42)")
            .custom("min-width", "0")
        }

        private func renderError(_ message: String) {
            contentView.innerHTML = ""
            contentView.appendChild(
                VBox(.raised) {
                    USubTitle("No se pudo cargar la unidad")
                    UMinorTitle(message).marginTop(5.px)
                }
            )
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $title.removeAllListeners()
            $activeTab.removeAllListeners()
            $avatar.removeAllListeners()
        }
    }
}