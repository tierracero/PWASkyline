import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class AssetItemView: Div {

        override class var name: String { "div" }

        private enum ItemTab: Equatable {
            case overview
            case notes
        }

        let assetItemId: UUID
        let onLoaded: ((CustCommercialAssetsItem) -> Void)?

        @State private var title = "Cargando unidad…"
        @State private var activeTab: ItemTab = .overview

        private lazy var contentView = Div()
            .height(100.percent)

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

        @DOM override var body: DOM.Content {
            VPopUp(.full) {
                VTitle(self.$title.map { "Unidad | \($0)" }, icon: "commertial_assets_icon.png") {
                    USmallTitle("Detalle de inventario")
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.full) {
                        self.contentView
                    }
                    .height(100.percent)
                    .display(.block)
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

            API.custAssetsV1.getAssettem(assetItemId: assetItemId) { response in
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

                self.title = payload.item.name
                self.render(payload)
                self.onLoaded?(payload.item)
            }
        }

        private func render(_ payload: CustAssetsComponents.GetAssettemResponse) {
            let item = payload.item
            contentView.innerHTML = ""

            let overview = Div {
                self.imagesPanel(payload.images)
                self.dataPanel(item)
            }
            .display(.grid)
            .custom("grid-template-columns", "minmax(220px, 0.78fr) minmax(0, 1.9fr)")
            .custom("gap", "12px")
            .custom("align-items", "start")

            let tabs = Div {
                self.tabButton("Resumen", tab: .overview)
                self.tabButton("Notas", tab: .notes)
            }
            .display(.flex)
            .custom("gap", "4px")
            .custom("border-bottom", "1px solid rgba(102, 184, 236, 0.25)")
            .marginTop(14.px)

            let overviewPanel = Div { overview }
                .hidden(self.$activeTab.map { $0 != .overview })
                .marginTop(10.px)

            let notesPanel = VBox(.raised) {
                UTitle("Notas (" + String(payload.notes.count) + ")")
                self.notesList(payload.notes)
            }
            .hidden(self.$activeTab.map { $0 != .notes })
            .marginTop(10.px)

            contentView.appendChild(
                Div {
                    tabs
                    overviewPanel
                    notesPanel
                }
                .custom("box-sizing", "border-box")
                .custom("width", "100%")
                .custom("max-height", "calc(100vh - 110px)")
                .custom("overflow", "auto")
                .height(100.percent)
                .padding(all: 2.px)
            )
        }

        private func imagesPanel(_ images: [CustFiles]) -> Div {
            let panel = VBox(.raised) {
                UTitle("Fotos y videos")
            }

            if images.isEmpty {
                panel.appendChild(
                    emptyState("No hay archivos registrados para esta unidad.")
                        .marginTop(8.px)
                )
                return panel
            }

            let imageGrid = Div()
                .display(.grid)
                .custom("grid-template-columns", "repeat(auto-fit, minmax(130px, 1fr))")
                .custom("gap", "8px")
                .marginTop(8.px)

            images.forEach { image in
                imageGrid.appendChild(
                    Img()
                        .src(self.imageSource(image))
                        .width(100.percent)
                        .height(150.px)
                        .custom("object-fit", "contain")
                        .custom("border", "1px solid rgba(66, 183, 245, 0.28)")
                        .custom("border-radius", "10px")
                )
            }

            panel.appendChild(imageGrid)
            return panel
        }

        private func dataPanel(_ item: CustCommercialAssetsItem) -> Div {
            VBox(.raised) {
                UTitle("Datos de la unidad")

                Div {
                    self.detail("Nombre", item.name)
                    self.detail("Estado", item.status.rawValue.capitalized)
                    self.detail("Serie", item.serial ?? "—")
                    self.detail("Folio de compra", item.purchasFiscalDocumentFolio)
                    self.detail("Tarjeta de servicio", item.serviceCard ?? "—")
                    self.detail("Tipo de ubicación", item.linkType.rawValue.capitalized)
                    self.detail("ID de ubicación", item.linkedTo?.uuidString.lowercased() ?? "—")
                    self.detail("Costo de adquisición", item.acquisitionCost.formatMoney)
                    self.detail("Costo actual", item.currentCost.formatMoney)
                    self.detail("Latitud", item.latitude.map { String($0) } ?? "—")
                    self.detail("Longitud", item.longitude.map { String($0) } ?? "—")
                    self.detail("Creado", getDate(item.createdAt).formatedLong)
                }
                .display(.grid)
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "8px")
                .marginTop(8.px)
            }
        }

        private func tabButton(_ title: String, tab: ItemTab) -> Div {
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
                list.appendChild(emptyState("No hay notas registradas para esta unidad."))
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

        private func detail(_ label: String, _ value: String) -> Div {
            Div {
                UMinorTitle(label)
                Div(value)
                    .class(.oneLineText)
                    .marginTop(2.px)
                    .attribute("title", value)
            }
            .padding(all: 9.px)
            .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
            .custom("border-radius", "8px")
            .custom("background", "rgba(5, 17, 27, 0.42)")
            .custom("min-width", "0")
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
        }
    }
}
