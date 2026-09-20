import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class CreateAssetView: Div {

        override class var name: String { "div" }

        let viewType: InitiateAssetItemViewType

        let department: CustAssetDeps

        let category: CustAssetCats?

        let callback: (CustCommercialAssets) -> Void

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

        init(
            viewType: InitiateAssetItemViewType,
            department: CustAssetDeps,
            category: CustAssetCats?,
            callback: @escaping (CustCommercialAssets) -> Void
        ) {
            self.viewType = viewType
            self.department = department
            self.category = category
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            
            VPopUp(.fitContent(w: 900)) {
                
                VTitle("Crear Activo", icon: "commertial_assets_icon.png") {
                    USmallTitle(
                        self.category.map { "\(self.department.name) · \($0.name)" } ?? self.department.name
                    )
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    
                    VGrid(.full) {

                        VGrid(.oneThird) {
                          VBox(.raised) {
                                UMinorTitle("Departamento")
                                USubTitle(self.department.name).marginTop(3.px)
                            }
                        }

                        VGrid(.oneThird) {

                            VBox(.raised) {
                                UMinorTitle("Categoría")
                                USubTitle(self.category?.name ?? "Sin categoría").marginTop(3.px)
                            }
                            
                        }

                        VGrid(.oneThird) {
                            VBox(.raised) {
                                UField("Tipo de activo", required: false) {
                                    USubTitle(self.department.assetType.description)
                                }
                            }
                        }
                    }

                    VGrid(.full) {
                        VGrid(.oneThird) {
                            CustAssetsAvatarUploader(
                                avatar: self.$avatar,
                                destination: .asset
                            )
                        }
                        VGrid(.twoThirds) {

                            VGrid(.half) {
                                UField("Tipo de producto") {
                                    UTextField(self.$productType).placeholder("Ej. Equipo")
                                }
                            }

                            VGrid(.half) {
                                UField("Subtipo", required: false) {
                                    UTextField(self.$productSubType).placeholder("Ej. Cómputo")
                                }
                            }

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
                                UField("Marca", required: false) {
                                    UTextField(self.$brand).placeholder("Marca")
                                }
                            }

                            VGrid(.half) {
                                UField("Modelo", required: false) {
                                    UTextField(self.$model).placeholder("Modelo")
                                }
                            }

                        }
                    }
                    
                    VGrid(.twoThirds) {
                        UField("Nombre") {
                            UTextField(self.$name).placeholder("Nombre del activo")
                        }
                    }

                    VGrid(.oneThird) {
                        UField("UPC / SKU", required: false) {
                            UTextField(self.$upc).placeholder("Opcional")
                        }
                    }

                    VGrid(.full) {
                        UField("Descripción", required: false) {
                            UTextField(self.$descriptionText).placeholder("Descripción corta")
                        }
                    }

                    VGrid(.oneThird) {
                        UField("Descripción general", required: false) {
                            UTextArea(self.$generalDescription).height(100.px)
                        }
                    }

                    VGrid(.oneThird) {
                        UField("Descripción comercial", required: false) {
                            UTextArea(self.$commercialDescription).height(100.px)
                        }
                    }

                    VGrid(.oneThird) {
                        UField("Descripción técnica", required: false) {
                            UTextArea(self.$technicalDescription).height(100.px)
                        }
                    }

                    VGrid(.half) {
                        ULargeButton("Cancelar")
                            .width(100.percent)
                            .onClick { self.remove() }
                    }

                    VGrid(.half) {
                        ULargeButton("Crear Activo")
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

        private func create() {

            name = name.purgeSpaces.purgeHtml.capitalizeFirstLetter

            productType = productType.purgeSpaces.purgeHtml.capitalizeFirstLetter

            productSubType = productSubType.purgeSpaces.purgeHtml.capitalizeFirstLetter

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

            loadingView.show()

            API.custAssetsV1.createAsset(
                assetType: department.assetType,
                assetDepartmentId: department.id,
                assetSeccionId: category?.id,
                custAcct: viewType.relationId,
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
                avatar: avatar.isEmpty ? nil : avatar
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

                guard let assetId = response.data?.itemId else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                let createdAsset = CustCommercialAssets(
                    id: assetId,
                    assetType: self.department.assetType,
                    assetDepartmentId: self.department.id,
                    assetSeccionId: self.category?.id,
                    custAcct: self.viewType.relationId,
                    productType: self.productType,
                    productSubType: self.productSubType,
                    upc: self.upc.isEmpty ? nil : self.upc,
                    name: self.name,
                    description: self.descriptionText,
                    brand: self.brand,
                    model: self.model,
                    pseudoModel: self.pseudoModel,
                    generalDescription: self.generalDescription,
                    comertialDescription: self.commercialDescription,
                    tecnicalDescription: self.technicalDescription,
                    initialCost: cost,
                    depreciationRate: depreciation,
                    avatar: self.avatar.isEmpty ? nil : self.avatar
                )

                self.callback(createdAsset)

                showSuccess(.operacionExitosa, "Activo creado")

                self.remove()
            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
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
        }
    }
}
