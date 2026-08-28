//
// CustAssets+CategoryEditor.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

private let custAssetsEditorAccent = Color(r: 242, g: 166, b: 90)

extension CustAssetsView {

    final class CategoryEditor: Div {

        override class var name: String { "div" }

        let department: CustAssetDeps
        let callback: (CustAssetCats) -> Void

        @State private var name = ""
        @State private var smallDescription = ""
        @State private var coverLandscape = ""

        private let descriptionText = ""
        private let icon = ""
        private let coverPortrait = ""

        init(
            department: CustAssetDeps,
            callback: @escaping (CustAssetCats) -> Void
        ) {
            self.department = department
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 580)) {
                VTitle("Crear Categoría") {
                    Div()
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.twoThirds) {
                        Div {
                            Div("Crear categoría en \(self.department.name.uppercased())")
                                .color(custAssetsEditorAccent)
                                .fontWeight(.bold)

                            UField("Nombre de Categoría") {
                                UTextField(self.$name)
                                    .placeholder("Nombre de la Categoría")
                                    .fontSize(20.px)
                            }

                            UField("Descripción corta", required: false) {
                                UTextArea(self.$smallDescription)
                                    .placeholder("Lista, marcas, o pequeña descripción")
                                    .height(92.px)
                            }
                        }
                        .display(.flex)
                        .custom("flex-direction", "column")
                        .custom("gap", "8px")
                    }

                    VGrid(.oneThird) {
                        Div {
                            CustAssetsAvatarUploader(
                                avatar: self.$coverLandscape,
                                destination: .assetCategorie
                            )

                            ULargeButton("Crear Categoría")
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
            smallDescription = smallDescription.purgeSpaces.purgeHtml

            guard !name.isEmpty else {
                showError(.requiredField, .requierdValid("Nombre"))
                return
            }

            loadingView.show()

            API.custAssetsV1.createCategorie(
                custAssetDeps: department.id,
                name: name,
                smallDescription: smallDescription,
                description: descriptionText,
                icon: icon,
                coverLandscape: coverLandscape,
                coverPortrait: coverPortrait
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

                showSuccess(.operacionExitosa, "Categoría creada")
                self.callback(item)
                self.remove()
            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $name.removeAllListeners()
            $smallDescription.removeAllListeners()
            $coverLandscape.removeAllListeners()
        }
    }
}
