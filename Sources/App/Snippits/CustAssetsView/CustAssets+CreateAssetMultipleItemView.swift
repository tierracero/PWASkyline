//
// CustAssets+CreateAssetMultipleItemView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension CustAssetsView {

    final class CreateAssetMultipleItemView: Div {

        override class var name: String { "div" }

        static var viewid: UUID { .init() }

        @State var requestedUnits: Int

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

        @State var items: [CustAssetsComponents.CreateAssetItemObject] = []

        let callback: ([CustCommercialAssetsItem]) -> Void

        let onSectionCreated: (CustCommercialAssetsSection) -> Void

        let onSubSectionCreated: (CustCommercialAssetsSubSection) -> Void

        init(
            requestedUnits: Int,
            viewType: InitiateAssetItemViewType,
            purchasFiscalDocumentFolio: String,
            asset: CustCommercialAssets,
            department: CustAssetDepsQuick,
            categorie: CustAssetCatsQuick?,
            sections: [CustCommercialAssetsSection],
            subSections: [CustCommercialAssetsSubSection],
            onSectionCreated: @escaping (CustCommercialAssetsSection) -> Void,
            onSubSectionCreated: @escaping (CustCommercialAssetsSubSection) -> Void,
            callback: @escaping ([CustCommercialAssetsItem]) -> Void
        ) {
            self.requestedUnits = requestedUnits
            self.viewType = viewType
            self.purchasFiscalDocumentFolio = purchasFiscalDocumentFolio
            self.asset = asset
            self.department = department
            self.categorie = categorie
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

        private lazy var addItemButton = USmallButton("+ Agregar")
            .class(Class(TCCrystalSurfaceClass.goodButton))
            .hidden(self.$items.map { $0.count >= self.requestedUnits })
            .onClick {
                self.addItem()
            }

        private lazy var itemsGrid = Div()
            .display(.grid)
            .custom("gap", "8px")
            .custom("align-content", "start")
            .maxHeight(430.px)
            .overflow(.auto)
            .marginTop(10.px)


        @DOM override var body: DOM.Content {

            VPopUp(.semiFull) {

                VTitle("Ingresar unidades | \(self.department.name)", icon: "commertial_assets_icon.png") {
                    USmallTitle(self.asset.name)
                } onClose: {
                    self.remove()
                }

                VBodyGrid {

                    VGrid(.oneThird) {
                        VBox(.raised) {
                            UTitle("Información")

                            self.informationRow("Tipo de ubicación", self.viewType.description)
                            self.informationRow("Ubicación", self.viewType.relationName)
                            self.informationRow(
                                "Folio de compra",
                                self.purchasFiscalDocumentFolio.isEmpty
                                    ? "Sin folio"
                                    : self.purchasFiscalDocumentFolio
                            )
                            self.informationRow("Activo comercial", self.asset.name)
                            self.informationRow("Tipo de activo", self.asset.assetType.description)
                        }
                    }

                    VGrid(.twoThirds) {
                        VBox(.raised) {
                            Div {
                                UTitle("Activos Comerciales")

                                Div {
                                    USubTitle(self.$items.map {
                                        "Solicitados: \(self.requestedUnits) · Listos: \($0.count)"
                                    })
                                    .class(.oneLineText)

                                    self.addItemButton
                                }
                                .display(.flex)
                                .custom("align-items", "center")
                                .custom("gap", "10px")
                            }
                            .display(.flex)
                            .custom("align-items", "center")
                            .custom("justify-content", "space-between")
                            .custom("gap", "12px")

                            self.itemsGrid
                        }
                    }

                    VGrid(.half) {
                        // MARK:
                    }

                    VGrid(.half) {
                        ULargeButton("Ingresar unidades")
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(100.percent)
                            .onClick {

                                guard self.requestedUnits == self.items.count else {
                                    showError(
                                        .generalError,
                                        "Complete las \(self.requestedUnits) unidades antes de continuar."
                                    )
                                    return
                                }

                                self.create()
                            }

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
        }

        override func didAddToDOM() {
            super.didAddToDOM()
            renderItems()
            addItem()
        }

        private func addItem() {
            guard items.count < requestedUnits else { return }

            addToDom(
                CreateAssetItemView(
                    createType: .multiItem,
                    viewType: viewType,
                    purchasFiscalDocumentFolio: purchasFiscalDocumentFolio,
                    asset: asset,
                    department: department,
                    categorie: categorie,
                    sections: sections,
                    subSections: subSections,
                    onSectionCreated: { section in
                        self.sections = self.upserting(section, into: self.sections)
                        self.onSectionCreated(section)
                    },
                    onSubSectionCreated: { subSection in
                        self.subSections = self.upserting(subSection, into: self.subSections)
                        self.onSubSectionCreated(subSection)
                    }
                ) { response in
                    guard case .preItem(let item) = response else { return }

                    self.items = self.items + [item]
                    self.renderItems()

                    if self.items.count < self.requestedUnits {
                        self.addItem()
                    }
                }
            )
        }

        private func renderItems() {
            itemsGrid.innerHTML = ""

            guard !items.isEmpty else {
                itemsGrid.appendChild(
                    emptyState(
                        "No hay unidades preparadas",
                        "Agregue la primera unidad para comenzar."
                    )
                )
                return
            }

            items.enumerated().forEach { index, item in
                itemsGrid.appendChild(
                    Div {
                        Div {

                            USubTitle("\(index + 1). \(item.name) \(item.serial ?? "")")
                                .class(.oneLineText)

                        }
                        .custom("min-width", "0")

                        Div {
                            Div(item.currentCost.formatMoney)
                                .fontWeight(.bold)
                            UMinorTitle("\(item.images.count) archivo(s)")
                        }
                        .textAlign(.right)
                    }
                    .display(.flex)
                    .custom("align-items", "center")
                    .custom("justify-content", "space-between")
                    .custom("gap", "12px")
                    .padding(all: 10.px)
                    .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
                    .custom("border-radius", "8px")
                    .custom("background", "rgba(5, 17, 27, 0.42)")
                )
            }
        }

        private func informationRow(_ title: String, _ value: String) -> Div {
            Div {
                UMinorTitle(title)
                USubTitle(value)
                    .class(.oneLineText)
                    .marginTop(3.px)
            }
            .custom("min-width", "0")
            .padding(v: 7.px, h: 0.px)
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

        private func create() {

            loadingView.show()

            API.custAssetsV1.createAssettem(
                type: viewType,
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio.purgeSpaces,
                purchasFiscalDocumentId: nil,
                commercialAssetId: asset.id,
                department: asset.assetDepartmentId,
                categorie: asset.assetSeccionId,
                subcategorie: nil,
                items: items
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

                guard let items = response.data?.items,
                      items.count == self.items.count else {
                    loadingView.hide()
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                loadingView.hide()

                showSuccess(.operacionExitosa, "Unidad ingresada")

                self.callback(items)

                self.remove()
            }

        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $requestedUnits.removeAllListeners()
            $sections.removeAllListeners()
            $subSections.removeAllListeners()
            $items.removeAllListeners()
        }
    }

}
