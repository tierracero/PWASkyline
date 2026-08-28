//
// CustAssets+DepartmentEditor.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

private let custAssetsEditorAccent = Color(r: 242, g: 166, b: 90)

extension CustAssetsView {

    final class DepartmentEditor: Div {

        override class var name: String { "div" }

        let ws = WS()
        
        let viewId: UUID = .init()

        let accountId: UUID?

        let department: CustAssetDeps?

        let callback: (CustAssetDeps) -> Void

        @State private var name: String
        @State private var smallDescription: String
        @State private var coverLandscape: String
        @State private var assetType: String

        private let descriptionText: String
        private let icon: String
        private let coverPortrait: String

        init(
            accountId: UUID?,
            department: CustAssetDeps? = nil,
            callback: @escaping (CustAssetDeps) -> Void
        ) {
            self.accountId = accountId
            self.department = department
            self.callback = callback
            self.name = department?.name ?? ""
            self.smallDescription = department?.smallDescription ?? ""
            self.assetType = (department?.assetType ?? .utility).rawValue
            self.descriptionText = department?.description ?? ""
            self.icon = department?.icon ?? ""
            self.coverLandscape = department?.coverLandscape ?? ""
            self.coverPortrait = department?.coverPortrait ?? ""
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        lazy var depName = UTextField(self.$name)
            .placeholder("Nombre del Departamento")
            .fontSize(20.px)

        private lazy var assetTypeSelect = USelectField(self.$assetType)
            .width(100.percent)

        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 580)) {
                VTitle(
                    self.department == nil ? "Crear Departamento" : "Editar Departamento"
                ) {
                    Div()
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.twoThirds) {
                        Div {
                            
                            Div(
                                self.department == nil
                                    ? "Crear departamento de activos"
                                    : "Editar \(self.department?.name ?? "departamento")"
                            )
                            .color(custAssetsEditorAccent)
                            .fontWeight(.bold)

                            UField("Tipo de activo") {
                                if self.department == nil {
                                    self.assetTypeSelect
                                } else {
                                    USubTitle(self.department?.assetType.description ?? "")
                                }
                            }

                            UField("Nombre del Departamento") {
                                self.depName
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
                                destination: .assetDepartment,
                                itemId: self.department?.id
                            )

                            ULargeButton(
                                self.department == nil ? "Crear Departamento" : "Guardar Cambios"
                            )
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

            let selectedAssetType: CustCommercialAssetsType

            if let department {
                selectedAssetType = department.assetType
            } else {
                guard let type = CustCommercialAssetsType(rawValue: assetType) else {
                    showError(.requiredField, .requierdValid("Tipo de activo"))
                    return
                }

                selectedAssetType = type
            }

            loadingView.show()

            if let department {
                API.custAssetsV1.updateDepartment(
                    depId: department.id,
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

                    let updated = CustAssetDeps(
                        id: department.id,
                        createdAt: department.createdAt,
                        modifiedAt: getNow(),
                        assetType: department.assetType,
                        accountId: department.accountId,
                        name: self.name,
                        smallDescription: self.smallDescription,
                        description: self.descriptionText,
                        icon: self.icon,
                        coverLandscape: self.coverLandscape,
                        coverPortrait: self.coverPortrait
                    )

                    showSuccess(.operacionExitosa, "Departamento actualizado")
                    self.callback(updated)
                    self.remove()
                }
            }
            else {
                API.custAssetsV1.createDepartment(
                    accountId: accountId,
                    assetType: selectedAssetType,
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

                    showSuccess(.operacionExitosa, "Departamento creado")
                    self.callback(item)
                    self.remove()
                }
            }
        }

        override func didAddToDOM() {
            super.didAddToDOM()

            if department == nil {
                assetTypeSelect.innerHTML = ""

                CustCommercialAssetsType.allCases.forEach { type in
                    assetTypeSelect.appendChild(
                        Option(type.description).value(type.rawValue)
                    )
                }
            }

            depName.select()

        }
        
        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $name.removeAllListeners()
            $smallDescription.removeAllListeners()
            $coverLandscape.removeAllListeners()
            $assetType.removeAllListeners()
        }
    }

}
