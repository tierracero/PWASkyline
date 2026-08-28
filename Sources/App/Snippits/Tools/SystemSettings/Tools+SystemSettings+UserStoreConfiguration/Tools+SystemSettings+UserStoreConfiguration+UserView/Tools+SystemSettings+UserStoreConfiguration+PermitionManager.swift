//
//  Tools+SystemSettings+UserStoreConfiguration+PermitionManager.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.UserView {

    /// Permission catalog and add-action flow migrated from `prepareUserPermition()`.
    ///
    /// The catalog is intentionally separate from the user's linked profile. The
    /// parent user view owns the current profile, while this view owns the
    /// category/subcategory/attribute navigation and dispatches additions through
    /// its completion callback.
    class PermitionManager: Div {

        override class var name: String { "div" }

        let cats: [PanelConfigurationCatagoryItem]
        let subCats: [PanelConfigurationSubCatagoryItem]
        let atributes: [PanelConfigurationAtributeItem]

        private let userId: UUID
        private var assignedPermissions: [PanelConfigurationObjects]
        private let onPermissionAdded: (CustComponents.AddUserPermitionResponse) -> Void

        private var categoryButtons: [UUID: Div] = [:]
        private var addPermissionButton: Div?
        private var pendingPermissionButton: Div?
        private var isAddingPermission = false

        private lazy var categoryList: Div = {
            let list = Div()
                .class(Class(TCUserPermissionManagerClass.categoryList))

            if self.cats.isEmpty {
                list.appendChild(emptyState("No hay categorías de permisos disponibles"))
            } else {
                self.cats.forEach { category in
                    let button = self.categoryButton(category)
                    self.categoryButtons[category.id] = button
                    list.appendChild(button)
                }
            }

            return list
        }()

        private lazy var detailView = Div {
            emptyState("Seleccione una categoría para consultar sus permisos")
        }
            .class(Class(TCUserPermissionManagerClass.detail))

        private lazy var permissionWorkspace = Div {
            Div {

            }
                .class(Class(TCUserPermissionManagerClass.sidebar))

            self.detailView
        }
            .class(Class(TCUserPermissionManagerClass.workspace))

        init(
            cats: [PanelConfigurationCatagoryItem],
            subCats: [PanelConfigurationSubCatagoryItem],
            atributes: [PanelConfigurationAtributeItem],
            userId: UUID,
            assignedPermissions: [PanelConfigurationObjects],
            onPermissionAdded: @escaping (CustComponents.AddUserPermitionResponse) -> Void
        ) {
            self.cats = cats
            self.subCats = subCats
            self.atributes = atributes
            self.userId = userId
            self.assignedPermissions = assignedPermissions
            self.onPermissionAdded = onPermissionAdded
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            VPopUp(.custome(w: 900, h: 760)) {

                VTitle("Agregar Permisos", icon: "icon_permition.png") {
                    USmallTitle("Catálogo de accesos")
                } onClose: {
                    self.remove()
                }

                VGrid {

                    Div {

                        Div{

                            Div {

                                Span("Seleccione una categoría")
                                .fontSize(16.px)
                                .float(.right)
                                .color(.gray)
                                
                                H3("Módulos")
                                
                            }

                            Div{
                                self.categoryList
                            }
                            .custom("height", "calc(100% -  48px)")
                            .class(.roundDarkBlue)

                        }
                        .height(100.percent)
                        .padding(all:3.px)

                    }
                    .height(100.percent)
                    .width(40.percent)
                    .float(.left)

                    Div {
                        Div{

                            self.detailView
                            .custom("height", "calc(100% - 23px)")
                        }
                        .height(100.percent)
                        .padding(all:3.px)

                    }
                    .height(100.percent)
                    .width(60.percent)
                    .float(.left)

                }
                .display(.block)
                .custom("height", "calc(100% - 35px)")

            }
                .class(Class(TCUserPermissionManagerClass.popup))
                .custom("filter", "blur(0px) !important")
        }

        override func buildUI() {
            super.buildUI()

            TCUserConfigurationTheme.apply(to: self)
            TCUserPermissionManagerTheme.apply(to: self)

            position(.fixed)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            zIndex(9999999)
        }

        private func categoryButton(_ category: PanelConfigurationCatagoryItem) -> Div {
            let childCount = subCats.filter {
                $0.panelConfigurationCatagory == category.id
            }.count

            return Div {
                Div {
                    Span(category.name)
                }
                    .class(Class(TCUserPermissionManagerClass.itemText))

                Span(childCount == 0 ? "Módulo" : "\(childCount) subcategorías")
                    .class(Class(TCUserPermissionManagerClass.itemMeta))
            }
                .attribute("aria-label", "Ver permisos de \(category.name)")
                .class(Class(TCUserPermissionManagerClass.category))
                .attribute("role", "button")
                .attribute("tabindex", "0")
                .onClick {
                    self.selectCategory(category)
                }
                .onKeyUp { _, event in
                    guard event.code == "Enter" || event.code == "Space" else {
                        return
                    }
                    event.preventDefault()
                    self.selectCategory(category)
                }
        }

        private func selectCategory(_ category: PanelConfigurationCatagoryItem) {
            categoryButtons.values.forEach {
                $0.removeClass(Class(TCUserPermissionManagerClass.selected))
            }
            categoryButtons[category.id]?.class(Class(TCUserPermissionManagerClass.selected))
            renderCategory(category)
        }

        private func renderCategory(_ category: PanelConfigurationCatagoryItem) {
            let children = subCats.filter {
                $0.panelConfigurationCatagory == category.id
            }

            detailView.innerHTML = ""
            addPermissionButton = nil
            detailView.appendChild(
                detailHeader(
                    level: "Categoría",
                    title: category.name,
                    description: category.description,
                    icon: "/skyline/media/panel_service.png"
                )
            )
            appendAddPermissionAction(
                .cat,
                id: category.id,
                code: category.code
            )


            detailView.appendChild(sectionHeader("Subcategorías", children.count.toString))

            children.forEach { subCategory in
                let attributeCount = atributes.filter {
                    $0.panelConfigurationSubCatagory == subCategory.id
                }.count

                detailView.appendChild(
                    permissionOption(
                        title: subCategory.name,
                        subtitle: attributeCount == 0
                            ? "Consultar descripción"
                            : "\(attributeCount) atributos relacionados",
                        icon: "/skyline/media/history_setting_icon_white.png"
                    ) {
                        self.renderSubCategory(subCategory, parent: category)
                    }
                )
            }
        }

        private func renderSubCategory(
            _ subCategory: PanelConfigurationSubCatagoryItem,
            parent: PanelConfigurationCatagoryItem
        ) {
            let attributes = atributes.filter {
                $0.panelConfigurationSubCatagory == subCategory.id
            }

            detailView.innerHTML = ""
            addPermissionButton = nil
            detailView.appendChild(backButton(title: parent.name) {
                self.renderCategory(parent)
            })
            detailView.appendChild(
                detailHeader(
                    level: "Subcategoría",
                    title: subCategory.name,
                    description: subCategory.description,
                    icon: "/skyline/media/history_setting_icon_white.png"
                )
            )
            appendAddPermissionAction(
                .subCat,
                id: subCategory.id,
                code: subCategory.code
            )

            detailView.appendChild(sectionHeader("Atributos", attributes.count.toString))
            attributes.forEach { attribute in
                detailView.appendChild(
                    permissionOption(
                        title: attribute.name,
                        subtitle: "Consultar descripción",
                        icon: "/skyline/media/icon-tools.png"
                    ) {
                        self.renderAttribute(attribute, parent: subCategory, category: parent)
                    }
                )
            }
        }

        private func renderAttribute(
            _ attribute: PanelConfigurationAtributeItem,
            parent: PanelConfigurationSubCatagoryItem,
            category: PanelConfigurationCatagoryItem
        ) {
            detailView.innerHTML = ""
            addPermissionButton = nil
            detailView.appendChild(backButton(title: parent.name) {
                self.renderSubCategory(parent, parent: category)
            })
            detailView.appendChild(
                detailHeader(
                    level: "Atributo",
                    title: attribute.name,
                    description: attribute.description,
                    icon: "/skyline/media/icon-tools.png"
                )
            )
            appendAddPermissionAction(
                .attrib,
                id: attribute.id,
                code: attribute.code
            )
        }

        private func appendAddPermissionAction(
            _ permitType: CustPermitionTypes,
            id permitId: UUID,
            code: PanelConfigurationObjects
        ) {
            guard !assignedPermissions.contains(code) else {
                return
            }

            let button = Div {
                Span("+")
                    .class(Class(TCUserPermissionManagerClass.addIcon))
                Strong("Agregar Permiso")
            }
                .class(Class(TCCrystalSurfaceClass.goodButton))
                .attribute("role", "button")
                .attribute("tabindex", "0")
                .attribute("aria-label", "Agregar permiso")
                .onClick {
                    self.addUserPermition(permitType, permitId)
                }
                .onKeyUp { _, event in
                    guard event.code == "Enter" || event.code == "Space" else {
                        return
                    }
                    event.preventDefault()
                    self.addUserPermition(permitType, permitId)
                }

            addPermissionButton = button
            detailView.appendChild(button)
        }

        func addUserPermition(
            _ permitType: CustPermitionTypes,
            _ permitId: UUID
        ) {
            guard !isAddingPermission else {
                return
            }

            isAddingPermission = true
            pendingPermissionButton = addPermissionButton
            loadingView.show()

            API.custAPIV1.addUserPermition(
                permitType,
                permitId,
                userId: userId
            ) { [weak self] resp in
                loadingView.hide()

                guard let self else {
                    return
                }

                defer {
                    self.isAddingPermission = false
                    self.pendingPermissionButton = nil
                }

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                self.mergeAssignedPermissions(payload)

                let completedButton = self.pendingPermissionButton
                completedButton?.remove()
                if let currentButton = self.addPermissionButton,
                   let completedButton,
                   currentButton === completedButton {
                    self.addPermissionButton = nil
                }

                self.onPermissionAdded(payload)
                showSuccess(.operacionExitosa, "Permiso agregado")
            }
        }

        private func mergeAssignedPermissions(
            _ payload: CustComponents.AddUserPermitionResponse
        ) {
            [payload.catCode, payload.subCatCode, payload.attribCode].forEach { code in
                guard let code, !assignedPermissions.contains(code) else {
                    return
                }
                assignedPermissions.append(code)
            }
        }

        private func detailHeader(
            level: String,
            title: String,
            description: String,
            icon: String
        ) -> Div {
            Div {
                Div {
                    Img()
                        .src(icon)
                        .class(Class(TCUserPermissionManagerClass.detailIcon))

                    Div {
                        Span(level)
                            .class(Class(TCUserPermissionManagerClass.eyebrow))
                        H2(title)
                    }
                }
                    .class(Class(TCUserPermissionManagerClass.detailTitle))

                Div {
                    Span("Descripción")
                        .class(Class(TCUserPermissionManagerClass.descriptionLabel))
                    Div(description.isEmpty ? "Sin descripción" : description)
                        .class(Class(TCUserPermissionManagerClass.description))
                }
                    .class(Class(TCUserPermissionManagerClass.descriptionBox))
            }
                .class(Class(TCUserPermissionManagerClass.detailHeader))
        }

        private func sectionHeader(_ title: String, _ count: String) -> Div {
            Div {
                H3(title)
                Span(count)
                    .class(Class(TCUserPermissionManagerClass.count))
            }
                .class(Class(TCUserPermissionManagerClass.sectionHeader))
        }

        private func permissionOption(
            title: String,
            subtitle: String,
            icon: String,
            action: @escaping () -> Void
        ) -> Div {
            Div {
                Div {
                    Img()
                        .src(icon)
                        .class(Class(TCUserPermissionManagerClass.optionIcon))

                    Div {
                        Strong(title)
                        Span(subtitle)
                    }
                        .class(Class(TCUserPermissionManagerClass.optionText))
                }
                    .class(Class(TCUserPermissionManagerClass.optionMain))

                Span("›")
                    .class(Class(TCUserPermissionManagerClass.optionArrow))
            }
                .class(Class(TCUserPermissionManagerClass.option))
                .attribute("role", "button")
                .attribute("tabindex", "0")
                .onClick {
                    action()
                }
                .onKeyUp { _, event in
                    guard event.code == "Enter" || event.code == "Space" else {
                        return
                    }
                    event.preventDefault()
                    action()
                }
        }

        private func backButton(title: String, action: @escaping () -> Void) -> Div {
            Div("‹ Volver a \(title)")
                .class(Class(TCUserPermissionManagerClass.back))
                .attribute("role", "button")
                .attribute("tabindex", "0")
                .onClick {
                    action()
                }
                .onKeyUp { _, event in
                    guard event.code == "Enter" || event.code == "Space" else {
                        return
                    }
                    event.preventDefault()
                    action()
                }
        }

    }
}

private enum TCUserPermissionManagerClass {
    static let popup = "tc-user-permission-manager-popup"
    static let workspace = "tc-user-permission-manager-workspace"
    static let sidebar = "tc-user-permission-manager-sidebar"
    static let panelHeader = "tc-user-permission-manager-panel-header"
    static let categoryList = "tc-user-permission-manager-category-list"
    static let category = "tc-user-permission-manager-category"
    static let selected = "tc-user-permission-manager-selected"
    static let itemText = "tc-user-permission-manager-item-text"
    static let itemMeta = "tc-user-permission-manager-item-meta"
    static let detail = "tc-user-permission-manager-detail"
    static let detailHeader = "tc-user-permission-manager-detail-header"
    static let detailTitle = "tc-user-permission-manager-detail-title"
    static let detailIcon = "tc-user-permission-manager-detail-icon"
    static let eyebrow = "tc-user-permission-manager-eyebrow"
    static let descriptionBox = "tc-user-permission-manager-description-box"
    static let descriptionLabel = "tc-user-permission-manager-description-label"
    static let description = "tc-user-permission-manager-description"
    static let sectionHeader = "tc-user-permission-manager-section-header"
    static let count = "tc-user-permission-manager-count"
    static let option = "tc-user-permission-manager-option"
    static let optionMain = "tc-user-permission-manager-option-main"
    static let optionIcon = "tc-user-permission-manager-option-icon"
    static let optionText = "tc-user-permission-manager-option-text"
    static let optionArrow = "tc-user-permission-manager-option-arrow"
    static let back = "tc-user-permission-manager-back"
    static let addIcon = "tc-user-permission-manager-add-icon"
}

private enum TCUserPermissionManagerTheme {
    private static var isInstalled = false

    static func apply(to view: Div) {
        install()
        view.class(Class("tc-user-permission-manager"))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }

        isInstalled = true
        let root = ".tc-user-permission-manager"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("--tc-permission-blue", "rgb(73, 185, 245)")
                .custom("--tc-permission-muted", "rgb(168, 190, 208)")
                .custom("--tc-permission-surface", "rgba(6, 24, 42, 0.78)")
                .custom("--tc-permission-raised", "rgba(10, 39, 63, 0.84)")
                .custom("--tc-permission-border", "rgba(102, 184, 236, 0.28)")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.popup)"))
                .custom("background", "transparent !important")
                .custom("backdrop-filter", "none !important")
                .custom("-webkit-backdrop-filter", "none !important")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.popUpPanel)"))
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 57, 0.94), rgba(2, 13, 26, 0.92)) !important")
                .custom("border", "1px solid var(--tc-permission-border) !important")
                .custom("box-shadow", "0 34px 100px rgba(0, 0, 0, 0.62), inset 0 1px 0 rgba(255, 255, 255, 0.06)")
                .custom("backdrop-filter", "blur(28px) saturate(138%)")
                .custom("-webkit-backdrop-filter", "blur(28px) saturate(138%)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.title)"))
                .custom("background", "#252c3b !important")
                .custom("border-left", "4px solid var(--tc-permission-blue)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.bodyGrid)"))
                .custom("min-height", "0")
                .custom("background", "transparent !important")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.workspace)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(220px, 0.34fr) minmax(0, 0.66fr)")
                .custom("gap", "12px")
                .custom("height", "100%")
                .custom("min-height", "0")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.sidebar), \(root) .\(TCUserPermissionManagerClass.detail)"))
                .custom("min-width", "0")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("background", "var(--tc-permission-surface)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("border-radius", "14px")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.035), 0 14px 34px rgba(0, 0, 0, 0.22)")
                .custom("backdrop-filter", "blur(16px) saturate(122%)")
                .custom("-webkit-backdrop-filter", "blur(16px) saturate(122%)")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.sidebar)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.detail)"))
                .custom("padding", "16px")
                .custom("overflow", "auto")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.panelHeader), \(root) .\(TCUserPermissionManagerClass.sectionHeader)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "10px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.panelHeader)"))
                .custom("padding", "14px 14px 12px")
                .custom("background", "#252c3b")
                .custom("border-bottom", "1px solid rgba(102, 184, 236, 0.2)")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.panelHeader) h3"))
                .custom("margin", "0")
                .custom("color", "var(--tc-permission-blue)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.panelHeader) span"))
                .custom("color", "var(--tc-permission-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.categoryList)"))
                .custom("display", "grid")
                .custom("align-content", "start")
                .custom("gap", "8px")
                .custom("padding", "10px")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.category)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "10px")
                .custom("min-height", "48px")
                .custom("padding", "9px 10px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid transparent")
                .custom("border-radius", "11px")
                .custom("background", "rgba(37, 44, 59, 0.72)")
                .custom("color", "rgb(237, 247, 255)")
                .custom("cursor", "pointer")
                .custom("transition", "border-color 160ms ease, background 160ms ease, transform 160ms ease")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.category):hover, \(root) .\(TCUserPermissionManagerClass.category):focus-visible, \(root) .\(TCUserPermissionManagerClass.selected)"))
                .custom("border-color", "var(--tc-permission-blue)")
                .custom("background", "rgba(16, 79, 117, 0.5)")
                .custom("outline", "none")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.category):hover"))
                .custom("transform", "translateX(2px)")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.itemText), \(root) .\(TCUserPermissionManagerClass.optionMain)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("min-width", "0")
                .custom("gap", "9px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.itemText) img"))
                .custom("width", "20px !important")
                .custom("height", "20px !important")
                .custom("object-fit", "contain")
                .custom("opacity", "0.82")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.itemText) span"))
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.itemMeta)"))
                .custom("color", "var(--tc-permission-muted)")
                .custom("font-size", "10px")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.detailHeader)"))
                .custom("display", "grid")
                .custom("gap", "16px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.detailTitle)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("padding-bottom", "13px")
                .custom("border-bottom", "1px solid rgba(102, 184, 236, 0.16)")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.detailIcon)"))
                .custom("width", "34px !important")
                .custom("height", "34px !important")
                .custom("object-fit", "contain")
                .custom("opacity", "0.86")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.eyebrow)"))
                .custom("display", "block")
                .custom("margin-bottom", "3px")
                .custom("color", "rgb(242, 166, 90)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.12em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.detailTitle) h2"))
                .custom("margin", "0")
                .custom("color", "var(--tc-permission-blue)")
                .custom("font-size", "clamp(20px, 2vw, 28px)")
                .custom("line-height", "1.12")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.descriptionBox)"))
                .custom("display", "grid")
                .custom("gap", "7px")
                .custom("padding", "13px")
                .custom("background", "rgba(37, 44, 59, 0.62)")
                .custom("border-left", "3px solid #252c3b")
                .custom("border-radius", "10px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.descriptionLabel)"))
                .custom("color", "var(--tc-permission-muted)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.1em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.description)"))
                .custom("color", "rgb(215, 232, 245)")
                .custom("font-size", "13px")
                .custom("line-height", "1.55")
                .custom("white-space", "pre-wrap")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.sectionHeader)"))
                .custom("margin", "22px 0 9px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.sectionHeader) h3"))
                .custom("margin", "0")
                .custom("color", "var(--tc-permission-blue)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.count)"))
                .custom("min-width", "22px")
                .custom("padding", "3px 7px")
                .custom("box-sizing", "border-box")
                .custom("border-radius", "999px")
                .custom("background", "rgba(73, 185, 245, 0.18)")
                .custom("color", "var(--tc-permission-blue)")
                .custom("font-size", "10px")
                .custom("text-align", "center")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.option)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "12px")
                .custom("margin-top", "8px")
                .custom("padding", "11px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.17)")
                .custom("border-radius", "10px")
                .custom("background", "rgba(4, 22, 39, 0.78)")
                .custom("cursor", "pointer")
                .custom("transition", "border-color 160ms ease, background 160ms ease")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.option):hover, \(root) .\(TCUserPermissionManagerClass.option):focus-visible"))
                .custom("border-color", "var(--tc-permission-blue)")
                .custom("background", "rgba(16, 79, 117, 0.42)")
                .custom("outline", "none")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.optionIcon)"))
                .custom("width", "22px !important")
                .custom("height", "22px !important")
                .custom("object-fit", "contain")
                .custom("opacity", "0.78")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.optionText)"))
                .custom("display", "grid")
                .custom("gap", "3px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.optionText) strong"))
                .custom("overflow", "hidden")
                .custom("color", "rgb(237, 247, 255)")
                .custom("font-size", "13px")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.optionText) span"))
                .custom("color", "var(--tc-permission-muted)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.optionArrow)"))
                .custom("color", "var(--tc-permission-blue)")
                .custom("font-size", "24px")
                .custom("line-height", "1")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.back)"))
                .custom("display", "inline-block")
                .custom("margin-bottom", "12px")
                .custom("color", "var(--tc-permission-blue)")
                .custom("font-size", "12px")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.back):hover, \(root) .\(TCUserPermissionManagerClass.back):focus-visible"))
                .custom("text-decoration", "underline")
                .custom("outline", "none")

            CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.goodButton)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "8px")
                .custom("width", "100%")
                .custom("min-height", "44px")
                .custom("margin-top", "16px")
                .custom("padding", "9px 18px")
                .custom("box-sizing", "border-box")
                .custom("border", "2px solid #245a7c")
                .custom("border-radius", "13px")
                .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.95), rgba(5, 27, 48, 0.95))")
                .custom("color", "rgb(237, 247, 255)")
                .custom("font-size", "15px")
                .custom("font-weight", "700")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.08), 0 10px 24px rgba(0, 0, 0, 0.24)")
                .custom("cursor", "pointer")
                .custom("transition", "transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease")

            CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.goodButton):hover, \(root) .\(TCCrystalSurfaceClass.goodButton):focus-visible"))
                .custom("border-color", "rgb(73, 185, 245)")
                .custom("box-shadow", "0 12px 30px rgba(0, 0, 0, 0.32), 0 0 18px rgba(73, 185, 245, 0.16)")
                .custom("outline", "none")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.addIcon)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "20px")
                .custom("height", "20px")
                .custom("border", "1px solid rgb(73, 185, 245)")
                .custom("border-radius", "50%")
                .custom("color", "rgb(73, 185, 245)")
                .custom("font-size", "17px")
                .custom("line-height", "1")

        }

        WebApp.current.addStylesheet {
            MediaRule(.screen.maxWidth(760.px)) {
                CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.workspace)"))
                    .custom("grid-template-columns", "1fr")
                    .custom("grid-template-rows", "minmax(190px, 0.45fr) minmax(0, 1fr)")

                CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.categoryList)"))
                    .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) .\(TCUserPermissionManagerClass.category), \(root) .\(TCUserPermissionManagerClass.option)"))
                    .custom("transition", "none")
            }
        }
    }
}
