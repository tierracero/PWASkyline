//
// CustAssets+SubLocationEditor.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

private let custAssetsSubLocationEditorAccent = Color(r: 242, g: 166, b: 90)

extension CustAssetsView {

    final class SubLocationEditor: Div {

        override class var name: String { "div" }

        let section: CustCommercialAssetsSection
        let callback: (CustCommercialAssetsSubSection) -> Void

        @State private var name: String
        @State private var avatar = ""

        init(
            section: CustCommercialAssetsSection,
            initialName: String = "",
            callback: @escaping (CustCommercialAssetsSubSection) -> Void
        ) {
            self.section = section
            self.name = initialName
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 580)) {
                VTitle("Crear Sección", icon: "commertial_assets_icon.png") {
                    USmallTitle(self.section.name)
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.twoThirds) {
                        Div {
                            Div("Crear sección en \(self.section.name)")
                                .color(custAssetsSubLocationEditorAccent)
                                .fontWeight(.bold)

                            UField("Nombre de Sección") {
                                UTextField(self.$name)
                                    .placeholder("Nombre de la sección")
                                    .fontSize(20.px)
                            }

                            UField("Ubicación principal", required: false) {
                                USubTitle(self.section.name)
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
                                destination: .assetSubLocation
                            )

                            ULargeButton("Crear Sección")
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
            API.custAssetsV1.createAssetSubLocation(
                commercialAssetsLocationId: section.id,
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

                showSuccess(.operacionExitosa, "Sección creada")
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
