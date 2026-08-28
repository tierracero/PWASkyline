import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class CreateAssetItemView: Div {

        override class var name: String { "div" }

        let asset: CustCommercialAssets

        let callback: (CustCommercialAssetsItem) -> Void

        let department: CustAssetDepsQuick
        
        let categorie: CustAssetCatsQuick?

        @State private var name = ""
        @State private var serial = ""
        @State private var purchasFiscalDocumentFolio = ""
        @State private var serviceCard = ""
        @State private var acquisitionCost = "0.00"
        @State private var currentCost = "0.00"
        @State private var linkType = CustCommercialAssetsLinkedType.storage.rawValue
        @State private var linkedTo = ""
        @State private var latitude = ""
        @State private var longitude = ""

        private lazy var linkTypeSelect = USelectField(self.$linkType)
            .width(100.percent)

        init(
            asset: CustCommercialAssets,
            department: CustAssetDepsQuick,
            categorie: CustAssetCatsQuick?,
            callback: @escaping (CustCommercialAssetsItem) -> Void
        ) {
            self.asset = asset
            self.department = department
            self.categorie = categorie
            self.callback = callback
            self.acquisitionCost = asset.initialCost.formatMoney
            self.currentCost = asset.initialCost.formatMoney
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 820)) {
                VTitle("\(self.department.name) Ingresar unidad", icon: "commertial_assets_icon.png") {
                    USmallTitle(self.asset.name)
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.full) {
                        VBox(.raised) {

                            Div {
                                self.readOnly("Nombre", self.asset.name)
                                self.readOnly("Tipo", self.asset.assetType.description)
                                self.readOnly("Departamento", self.asset.assetDepartmentId.uuidString.lowercased())
                                self.readOnly(
                                    "Categoría",
                                    self.asset.assetSeccionId?.uuidString.lowercased() ?? "Sin categoría"
                                )
                            }
                            .display(.grid)
                            .custom("grid-template-columns", "repeat(4, minmax(0, 1fr))")
                            .custom("gap", "8px")
                            .marginTop(8.px)
                        }
                    }

                    VGrid(.half) {
                        UField("Nombre") {
                            UTextField(self.$name)
                                .placeholder("Nombre de la unidad")
                        }
                    }

                    VGrid(.half) {
                        UField("Número de serie", required: false) {
                            UTextField(self.$serial)
                                .placeholder("Opcional")
                        }
                    }

                    VGrid(.half) {
                        UField("Folio de compra", required: false) {
                            UTextField(self.$purchasFiscalDocumentFolio)
                                .placeholder("Folio o referencia")
                        }
                    }

                    VGrid(.half) {
                        UField("Tarjeta de servicio", required: false) {
                            UTextField(self.$serviceCard)
                                .placeholder("Opcional")
                        }
                    }

                    VGrid(.half) {
                        UField("Costo de adquisición") {
                            UTextField(self.$acquisitionCost)
                                .placeholder("0.00")
                                .onFocus { field in field.select() }
                        }
                    }

                    VGrid(.half) {
                        UField("Costo actual") {
                            UTextField(self.$currentCost)
                                .placeholder("0.00")
                                .onFocus { field in field.select() }
                        }
                    }

                    VGrid(.half) {
                        UField("Tipo de ubicación") {
                            self.linkTypeSelect
                        }
                    }

                    VGrid(.half) {
                        UField("ID de ubicación") {
                            UTextField(self.$linkedTo)
                                .placeholder("UUID del destino")
                        }
                    }

                    VGrid(.half) {
                        UField("Latitud", required: false) {
                            UTextField(self.$latitude)
                                .placeholder("Opcional")
                        }
                    }

                    VGrid(.half) {
                        UField("Longitud", required: false) {
                            UTextField(self.$longitude)
                                .placeholder("Opcional")
                        }
                    }

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
        }

        override func didAddToDOM() {
            super.didAddToDOM()

            linkTypeSelect.appendChild(
                Option("Seleccion Ubicación")
                    .value("")
            )

            CustCommercialAssetsLinkedType.allCases.forEach { value in
                linkTypeSelect.appendChild(
                    Option(value.description)
                        .value(value.rawValue)
                )
            }
        }

        private func create() {
            name = name.purgeSpaces.purgeHtml
            linkedTo = linkedTo.purgeSpaces

            guard !name.isEmpty else {
                showError(.requiredField, .requierdValid("Nombre"))
                return
            }

            guard let linkedToId = UUID(uuidString: linkedTo) else {
                showError(.requiredField, "Ingrese un UUID válido para la ubicación")
                return
            }

            guard let selectedLinkType = CustCommercialAssetsLinkedType(rawValue: linkType) else {
                showError(.requiredField, .requierdValid("Tipo de ubicación"))
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

            let latitude = optionalDouble(latitude)
            let longitude = optionalDouble(longitude)

            loadingView.show()

            API.custAssetsV1.createAssettem(
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio.purgeSpaces,
                purchasFiscalDocumentId: nil,
                commercialAssetsId: asset.id,
                linkType: selectedLinkType,
                linkedTo: linkedToId,
                department: asset.assetDepartmentId,
                categorie: asset.assetSeccionId,
                subcategorie: nil,
                acquisitionAt: getNow(),
                acquisitionCost: acquisitionCost,
                currentCost: currentCost,
                serial: serial.isEmpty ? nil : serial.purgeSpaces,
                name: name,
                latitude: latitude,
                longitude: longitude,
                serviceCard: serviceCard.isEmpty ? nil : serviceCard.purgeSpaces,
                images: []
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

                guard let itemId = response.data?.itemId else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

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

        private func optionalDouble(_ value: String) -> Double? {
            let normalized = value.purgeSpaces
            return normalized.isEmpty ? nil : Double(normalized)
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $name.removeAllListeners()
            $serial.removeAllListeners()
            $purchasFiscalDocumentFolio.removeAllListeners()
            $serviceCard.removeAllListeners()
            $acquisitionCost.removeAllListeners()
            $currentCost.removeAllListeners()
            $linkType.removeAllListeners()
            $linkedTo.removeAllListeners()
            $latitude.removeAllListeners()
            $longitude.removeAllListeners()
        }
    }
}
