//
// CustAssets+LocationEditor.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

private let custAssetsLocationEditorAccent = Color(r: 242, g: 166, b: 90)

extension CustAssetsView {

    final class LocationEditor: Div {

        override class var name: String { "div" }

        let relationType: CustCommercialAssetsLocationLinkedType
        let relationId: UUID
        let callback: (CustCommercialAssetsLocation) -> Void

        @State private var name: String
        @State private var avatar = ""

        init(
            relationType: CustCommercialAssetsLocationLinkedType,
            relationId: UUID,
            initialName: String = "",
            callback: @escaping (CustCommercialAssetsLocation) -> Void
        ) {
            self.relationType = relationType
            self.relationId = relationId
            self.name = initialName
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 580)) {
                VTitle("Crear Ubicación", icon: "commertial_assets_icon.png") {
                    USmallTitle("Nueva ubicación de activos")
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.twoThirds) {
                        Div {
                            Div("Crear ubicación de activos")
                                .color(custAssetsLocationEditorAccent)
                                .fontWeight(.bold)

                            UField("Nombre de Ubicación") {
                                UTextField(self.$name)
                                    .placeholder("Nombre de la ubicación")
                                    .fontSize(20.px)
                            }

                            UField("Tipo de ubicación", required: false) {
                                USubTitle(self.relationType.description)
                            }
                        }
                        .display(.flex)
                        .custom("flex-direction", "column")
                        .custom("gap", "8px")
                    }

                    VGrid(.oneThird) {
                        Div {
                            CustAssetsAvatarUploader(
                                avatar: self.$avatar,
                                destination: .assetLocation
                            )

                            ULargeButton("Crear Ubicación")
                                .class(Class(TCCrystalSurfaceClass.goodButton))
                                .width(100.percent)
                                .onClick { self.save() }
                        }
                        .display(.flex)
                        .custom("flex-direction", "column")
                        .custom("gap", "8px")
                        .height(100.percent)
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

        private func save() {
            name = name.purgeSpaces.purgeHtml.capitalizeFirstLetter

            guard !name.isEmpty else {
                showError(.requiredField, .requierdValid("Nombre"))
                return
            }

            loadingView.show()
            API.custAssetsV1.createAssetLocation(
                linkType: relationType,
                linkedTo: relationId,
                name: name,
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

                guard let item = response.data?.item else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                showSuccess(.operacionExitosa, "Ubicación creada")
                self.callback(item)
                self.remove()
            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $name.removeAllListeners()
            $avatar.removeAllListeners()
        }
    }
}
