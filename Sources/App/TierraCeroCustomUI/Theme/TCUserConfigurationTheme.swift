//
//  TCUserConfigurationTheme.swift
//

import Foundation
import Web

enum TCUserConfigurationClass {
    static let root = "tc-user-configuration"
    static let shell = "tc-user-configuration-shell"
    static let header = "tc-user-configuration-header"
    static let eyebrow = "tc-user-configuration-eyebrow"
    static let headerMeta = "tc-user-configuration-header-meta"
    static let headerActions = "tc-user-configuration-header-actions"
    static let actionButton = "tc-user-configuration-action-button"
    static let saveAction = "tc-user-configuration-save-action"
    static let secondaryAction = "tc-user-configuration-secondary-action"
    static let dangerAction = "tc-user-configuration-danger-action"
    static let credentialActions = "tc-user-configuration-credential-actions"
    static let close = "tc-user-configuration-close"
    static let workspace = "tc-user-configuration-workspace"
    static let sidebar = "tc-user-configuration-sidebar"
    static let avatar = "tc-user-configuration-avatar"
    static let avatarImage = "tc-user-configuration-avatar-image"
    static let avatarBadge = "tc-user-configuration-avatar-badge"
    static let profileName = "tc-user-configuration-profile-name"
    static let profileUsername = "tc-user-configuration-profile-username"
    static let profilePills = "tc-user-configuration-profile-pills"
    static let rolePill = "tc-user-configuration-role-pill"
    static let statusPill = "tc-user-configuration-status-pill"
    static let profileSummary = "tc-user-configuration-profile-summary"
    static let summaryRow = "tc-user-configuration-summary-row"
    static let profileSection = "tc-user-configuration-profile-section"
    static let colorRow = "tc-user-configuration-color-row"
    static let permissionHeader = "tc-user-configuration-permission-header"
    static let permissionList = "tc-user-configuration-permission-list"
    static let permissionItem = "tc-user-configuration-permission-item"
    static let permissionItemHeader = "tc-user-configuration-permission-item-header"
    static let permissionChildren = "tc-user-configuration-permission-children"
    static let permissionChild = "tc-user-configuration-permission-child"
    static let permissionCount = "tc-user-configuration-permission-count"
    static let permissionAddIcon = "tc-user-configuration-permission-add-icon"
    static let content = "tc-user-configuration-content"
    static let metrics = "tc-user-configuration-metrics"
    static let metric = "tc-user-configuration-metric"
    static let metricLabel = "tc-user-configuration-metric-label"
    static let metricValue = "tc-user-configuration-metric-value"
    static let metricDetail = "tc-user-configuration-metric-detail"
    static let cards = "tc-user-configuration-cards"
    static let card = "tc-user-configuration-card"
    static let cardWide = "tc-user-configuration-card-wide"
    static let sectionTitle = "tc-user-configuration-section-title"
    static let sectionTitleIcon = "tc-user-configuration-section-title-icon"
    static let sectionTitleCopy = "tc-user-configuration-section-title-copy"
    static let formGrid = "tc-user-configuration-form-grid"
    static let field = "tc-user-configuration-field"
    static let fieldWide = "tc-user-configuration-field-wide"
    static let accessDetails = "tc-user-configuration-access-details"
    static let toggleRow = "tc-user-configuration-toggle-row"
    static let accessGroup = "tc-user-configuration-access-group"
    static let tagList = "tc-user-configuration-tag-list"
    static let tag = "tc-user-configuration-tag"
    static let emptyInline = "tc-user-configuration-empty-inline"
    static let summaryGrid = "tc-user-configuration-summary-grid"
    static let inventoryGrid = "tc-user-configuration-inventory-grid"
    static let inventoryItem = "tc-user-configuration-inventory-item"
    static let inventoryIcon = "tc-user-configuration-inventory-icon"
    static let inventoryText = "tc-user-configuration-inventory-text"
    static let inventoryType = "tc-user-configuration-inventory-type"
    static let emptyState = "tc-user-configuration-empty-state"
}

enum TCUserConfigurationTheme {
    private static var isInstalled = false

    static func apply(to view: BaseElement) {
        install()
        view.removeClass(.transparantBlackBackGround)
        view.backgroundColor(.init(r: 0, g: 0, b: 0, a: 0))
        view.custom("backdrop-filter", "none")
        view.custom("-webkit-backdrop-filter", "none")
        view.class(Class(TCUserConfigurationClass.root))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }
        isInstalled = true

        let root = ".\(TCUserConfigurationClass.root)"
        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("padding", "3vh 3vw")
                .custom("color", "#edf7ff")
                .custom("font-family", "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif")
                .custom("--tc-user-surface", "rgba(6, 24, 42, 0.78)")
                .custom("--tc-user-raised", "rgba(10, 39, 63, 0.84)")
                .custom("--tc-user-border", "rgba(102, 184, 236, 0.28)")
                .custom("--tc-user-blue", "#49b9f5")
                .custom("--tc-user-ink", "#edf7ff")
                .custom("--tc-user-muted", "#a8bed0")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.shell)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("width", "min(1520px, 94vw)")
                .custom("height", "min(94vh, 980px)")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("padding", "12px")
                .custom("gap", "12px")
                .custom("background", "radial-gradient(circle at 7% 0%, rgba(73, 185, 245, 0.16), transparent 34%), linear-gradient(145deg, rgba(8, 34, 57, 0.92), rgba(2, 13, 26, 0.88))")
                .custom("border", "1px solid var(--tc-user-border)")
                .custom("border-radius", "24px")
                .custom("box-shadow", "0 34px 100px rgba(0, 0, 0, 0.62), inset 0 1px 0 rgba(255, 255, 255, 0.06)")
                .custom("backdrop-filter", "blur(28px) saturate(138%)")
                .custom("-webkit-backdrop-filter", "blur(28px) saturate(138%)")
                .overflow(.hidden)

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.header)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "16px")
                .custom("min-height", "72px")
                .custom("padding", "10px 12px 10px 20px")
                .custom("box-sizing", "border-box")
                .custom("background", "#252c3b")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "4px solid #49b9f5")
                .custom("border-radius", "14px")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.045), 0 10px 24px rgba(0, 0, 0, 0.2)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.header) h2"))
                .custom("margin", "2px 0 3px")
                .custom("color", "var(--tc-user-blue)")
                .custom("font-size", "clamp(21px, 2vw, 29px)")
                .custom("line-height", "1.08")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.eyebrow)"))
                .custom("display", "block")
                .custom("color", "#f2a65a")
                .custom("font-size", "11px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.14em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.headerMeta)"))
                .custom("display", "flex")
                .custom("gap", "8px")
                .custom("align-items", "center")
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "13px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.headerActions)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "flex-end")
                .custom("flex-wrap", "wrap")
                .custom("gap", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.actionButton)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "auto !important")
                .custom("min-width", "0")
                .custom("min-height", "36px !important")
                .custom("height", "36px !important")
                .custom("margin", "0 !important")
                .custom("padding", "7px 12px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid #245a7c")
                .custom("border-radius", "9px")
                .custom("background", "linear-gradient(145deg, rgba(13, 55, 84, 0.94), rgba(4, 24, 43, 0.94))")
                .custom("color", "var(--tc-user-ink)")
                .custom("font-size", "11px")
                .custom("font-weight", "800")
                .custom("line-height", "1")
                .custom("white-space", "nowrap")
                .custom("cursor", "pointer")
                .custom("transition", "border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.actionButton):hover, \(root) .\(TCUserConfigurationClass.actionButton):focus-visible"))
                .custom("border-color", "var(--tc-user-blue)")
                .custom("box-shadow", "0 0 0 3px rgba(73, 185, 245, 0.12)")
                .custom("outline", "none")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.actionButton):disabled"))
                .custom("opacity", "0.5")
                .custom("cursor", "wait")
                .custom("transform", "none")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.saveAction)"))
                .custom("border-color", "rgba(73, 185, 245, 0.68)")
                .custom("background", "linear-gradient(145deg, rgba(23, 102, 149, 0.96), rgba(8, 48, 78, 0.96))")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.secondaryAction)"))
                .custom("border-color", "rgba(102, 184, 236, 0.34)")
                .custom("color", "#d9eefb")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.dangerAction)"))
                .custom("border-color", "rgba(255, 112, 103, 0.54)")
                .custom("background", "linear-gradient(145deg, rgba(91, 36, 40, 0.9), rgba(46, 19, 26, 0.94))")
                .custom("color", "#ffaaa4")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.credentialActions)"))
                .custom("display", "flex")
                .custom("justify-content", "flex-end")
                .custom("flex-wrap", "wrap")
                .custom("gap", "8px")
                .custom("grid-column", "1 / -1")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.close)"))
                .custom("position", "static !important")
                .custom("width", "34px !important")
                .custom("height", "34px !important")
                .custom("margin", "0 !important")
                .custom("padding", "5px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.26)")
                .custom("border-radius", "10px")
                .custom("background", "rgba(2, 14, 27, 0.64)")
                .custom("filter", "brightness(2.2)")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.workspace)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(270px, 320px) minmax(0, 1fr)")
                .custom("gap", "12px")
                .custom("min-height", "0")
                .overflow(.hidden)

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sidebar), \(root) .\(TCUserConfigurationClass.card), \(root) .\(TCUserConfigurationClass.metric)"))
                .custom("background", "linear-gradient(145deg, rgba(9, 38, 62, 0.86), rgba(3, 19, 35, 0.78))")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.035), 0 14px 34px rgba(0, 0, 0, 0.22)")
                .custom("backdrop-filter", "blur(16px) saturate(122%)")
                .custom("-webkit-backdrop-filter", "blur(16px) saturate(122%)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sidebar)"))
                .custom("min-height", "0")
                .custom("padding", "16px")
                .custom("box-sizing", "border-box")
                .custom("border-radius", "16px")
                .overflow(.auto)

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.avatar)"))
                .custom("position", "relative")
                .custom("width", "min(100%, 250px)")
                .custom("aspect-ratio", "1 / 1")
                .custom("margin", "0 auto 16px")
                .custom("padding", "5px")
                .custom("box-sizing", "border-box")
                .custom("background", "linear-gradient(145deg, rgba(18, 92, 138, 0.76), rgba(4, 25, 44, 0.9))")
                .custom("border", "1px solid rgba(73, 185, 245, 0.48)")
                .custom("border-radius", "22px")
                .custom("box-shadow", "0 18px 46px rgba(0, 0, 0, 0.36), 0 0 38px rgba(73, 185, 245, 0.08)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.avatarImage)"))
                .custom("display", "block")
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("object-fit", "cover")
                .custom("border-radius", "17px")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.avatarBadge)"))
                .custom("position", "absolute")
                .custom("right", "12px")
                .custom("bottom", "12px")
                .custom("display", "flex")
                .custom("gap", "7px")
                .custom("align-items", "center")
                .custom("padding", "7px 10px")
                .custom("background", "rgba(2, 15, 28, 0.88)")
                .custom("border", "1px solid rgba(73, 185, 245, 0.42)")
                .custom("border-radius", "9px")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.profileName)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-user-ink)")
                .custom("font-size", "21px")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.profileUsername)"))
                .custom("display", "block")
                .custom("margin", "5px 0 12px")
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "13px")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.profilePills), \(root) .\(TCUserConfigurationClass.tagList)"))
                .custom("display", "flex")
                .custom("flex-wrap", "wrap")
                .custom("gap", "7px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.profilePills)"))
                .custom("justify-content", "center")
                .custom("margin-bottom", "14px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.rolePill), \(root) .\(TCUserConfigurationClass.statusPill), \(root) .\(TCUserConfigurationClass.tag), \(root) .\(TCUserConfigurationClass.inventoryType)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("min-height", "24px")
                .custom("padding", "3px 9px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(73, 185, 245, 0.34)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(16, 79, 117, 0.42)")
                .custom("color", "#dff5ff")
                .custom("font-size", "11px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.statusPill)"))
                .custom("border-color", "rgba(114, 216, 74, 0.46)")
                .custom("background", "rgba(52, 107, 43, 0.4)")
                .custom("color", "#c9f5b7")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.profileSummary)"))
                .custom("display", "grid")
                .custom("gap", "1px")
                .custom("margin", "0 0 14px")
                .custom("background", "rgba(102, 184, 236, 0.16)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18)")
                .custom("border-radius", "12px")
                .overflow(.hidden)

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.summaryRow)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) minmax(0, auto)")
                .custom("gap", "12px")
                .custom("align-items", "center")
                .custom("min-height", "38px")
                .custom("padding", "8px 11px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(3, 18, 33, 0.84)")
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.summaryRow) > span"))
                .custom("color", "var(--tc-user-muted)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.summaryRow) > strong"))
                .custom("color", "var(--tc-user-ink)")
                .custom("text-align", "right")
                .custom("overflow-wrap", "anywhere")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.profileSection)"))
                .custom("margin-top", "12px")
                .custom("padding-top", "12px")
                .custom("border-top", "1px solid rgba(102, 184, 236, 0.16)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.colorRow), \(root) .\(TCUserConfigurationClass.permissionHeader), \(root) .\(TCUserConfigurationClass.permissionItemHeader), \(root) .\(TCUserConfigurationClass.permissionChild)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.colorRow)"))
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.colorRow) input"))
                .custom("width", "48px !important")
                .custom("height", "34px !important")
                .custom("padding", "3px !important")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionHeader) h3"))
                .custom("margin", "0")
                .custom("color", "var(--tc-user-blue)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionHeader) span"))
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionList)"))
                .custom("display", "grid")
                .custom("gap", "8px")
                .custom("margin-top", "10px")

            CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.goodButton)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "8px")
                .custom("width", "100%")
                .custom("min-height", "42px")
                .custom("padding", "9px 12px")
                .custom("box-sizing", "border-box")
                .custom("border", "2px solid #245a7c")
                .custom("border-radius", "11px")
                .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.95), rgba(5, 27, 48, 0.95))")
                .custom("color", "var(--tc-user-ink)")
                .custom("font-size", "13px")
                .custom("font-weight", "700")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.08), 0 8px 20px rgba(0, 0, 0, 0.24)")
                .custom("cursor", "pointer")
                .custom("transition", "transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease")

            CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.goodButton):hover, \(root) .\(TCCrystalSurfaceClass.goodButton):focus-visible"))
                .custom("border-color", "var(--tc-user-blue)")
                .custom("box-shadow", "0 10px 26px rgba(0, 0, 0, 0.3), 0 0 16px rgba(73, 185, 245, 0.15)")
                .custom("outline", "none")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionAddIcon)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "19px")
                .custom("height", "19px")
                .custom("border", "1px solid var(--tc-user-blue)")
                .custom("border-radius", "50%")
                .custom("color", "var(--tc-user-blue)")
                .custom("font-size", "16px")
                .custom("line-height", "1")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionItem)"))
                .custom("padding", "9px")
                .custom("background", "rgba(4, 22, 39, 0.78)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.17)")
                .custom("border-radius", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionItemHeader) > div"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionItemHeader) img, \(root) .\(TCUserConfigurationClass.permissionChild) img"))
                .custom("width", "18px !important")
                .custom("height", "18px !important")
                .custom("object-fit", "contain")
                .custom("opacity", "0.78")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionItemHeader) strong"))
                .custom("font-size", "12px")
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionCount)"))
                .custom("min-width", "22px")
                .custom("padding", "3px 6px")
                .custom("border-radius", "999px")
                .custom("background", "rgba(73, 185, 245, 0.18)")
                .custom("color", "var(--tc-user-blue)")
                .custom("font-size", "10px")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionChildren)"))
                .custom("display", "grid")
                .custom("gap", "5px")
                .custom("margin-top", "7px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.permissionChild)"))
                .custom("min-height", "28px")
                .custom("padding", "5px 7px 5px 10px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(37, 44, 59, 0.72)")
                .custom("border-radius", "7px")
                .custom("color", "#d7e8f5")
                .custom("font-size", "11px")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.content)"))
                .custom("min-width", "0")
                .custom("min-height", "0")
                .custom("padding-right", "4px")
                .custom("box-sizing", "border-box")
                .overflow(.auto)

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metrics)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(4, minmax(0, 1fr))")
                .custom("gap", "10px")
                .custom("margin-bottom", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metric)"))
                .custom("display", "grid")
                .custom("gap", "3px")
                .custom("min-height", "94px")
                .custom("padding", "13px 14px")
                .custom("box-sizing", "border-box")
                .custom("border-left", "3px solid #49b9f5")
                .custom("border-radius", "13px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metricLabel)"))
                .custom("color", "#f2a65a")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.09em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metricValue)"))
                .custom("color", "var(--tc-user-blue)")
                .custom("font-size", "24px")
                .custom("line-height", "1.12")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metricDetail)"))
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.cards)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "12px")
                .custom("padding-bottom", "4px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.card)"))
                .custom("min-width", "0")
                .custom("padding", "15px")
                .custom("box-sizing", "border-box")
                .custom("border-radius", "15px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.cardWide)"))
                .custom("grid-column", "1 / -1")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sectionTitle)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "30px minmax(0, 1fr)")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("margin", "-2px -2px 14px")
                .custom("padding", "8px 10px")
                .custom("background", "#252c3b")
                .custom("border-left", "3px solid #49b9f5")
                .custom("border-radius", "9px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sectionTitleIcon)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "30px")
                .custom("height", "30px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(242, 166, 90, 0.42)")
                .custom("border-radius", "9px")
                .custom("background", "rgba(242, 166, 90, 0.10)")
                .custom("color", "#f2a65a")
                .custom("font-size", "18px")
                .custom("font-weight", "800")
                .custom("line-height", "1")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sectionTitleCopy)"))
                .custom("display", "grid")
                .custom("gap", "3px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sectionTitleCopy) > h3"))
                .custom("margin", "0 0 3px")
                .custom("color", "var(--tc-user-blue)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sectionTitleCopy) > span"))
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.formGrid), \(root) .\(TCUserConfigurationClass.summaryGrid)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.field)"))
                .custom("display", "grid")
                .custom("gap", "5px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.fieldWide)"))
                .custom("grid-column", "1 / -1")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.field) label, \(root) .\(TCUserConfigurationClass.accessGroup) > span"))
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "10px")
                .custom("font-weight", "700")
                .custom("letter-spacing", "0.04em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) input, \(root) select"))
                .custom("width", "100% !important")
                .custom("height", "40px !important")
                .custom("margin", "0 !important")
                .custom("padding", "8px 10px !important")
                .custom("box-sizing", "border-box")
                .custom("float", "none !important")
                .custom("border", "1px solid #245a7c !important")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(2, 16, 29, 0.8) !important")
                .custom("color", "var(--tc-user-ink) !important")
                .custom("font-size", "13px !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.025)")

            CSSRule(Pointer("\(root) input:focus, \(root) select:focus"))
                .custom("border-color", "rgba(73, 185, 245, 0.76) !important")
                .custom("box-shadow", "0 0 0 3px rgba(73, 185, 245, 0.13) !important")

            CSSRule(Pointer("\(root) input:disabled"))
                .custom("opacity", "0.72")
                .custom("cursor", "not-allowed")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.accessDetails)"))
                .custom("display", "grid")
                .custom("gap", "10px")
                .custom("margin-top", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.toggleRow)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "auto minmax(0, 1fr)")
                .custom("gap", "10px")
                .custom("align-items", "center")
                .custom("padding", "10px")
                .custom("background", "rgba(3, 19, 34, 0.72)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.16)")
                .custom("border-radius", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.toggleRow) strong, \(root) .\(TCUserConfigurationClass.toggleRow) span"))
                .custom("display", "block")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.toggleRow) strong"))
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.toggleRow) span"))
                .custom("margin-top", "2px")
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.accessGroup)"))
                .custom("display", "grid")
                .custom("gap", "7px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.emptyInline)"))
                .custom("display", "block")
                .custom("padding", "8px")
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "11px")
                .custom("font-style", "italic")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryGrid)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(auto-fit, minmax(250px, 1fr))")
                .custom("gap", "9px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryItem)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "42px minmax(0, 1fr) auto")
                .custom("gap", "10px")
                .custom("align-items", "center")
                .custom("min-height", "66px")
                .custom("padding", "10px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(3, 20, 36, 0.76)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18)")
                .custom("border-radius", "11px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryIcon)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "42px")
                .custom("height", "42px")
                .custom("background", "rgba(73, 185, 245, 0.1)")
                .custom("border", "1px solid rgba(73, 185, 245, 0.22)")
                .custom("border-radius", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryIcon) img"))
                .custom("width", "24px !important")
                .custom("height", "24px !important")
                .custom("object-fit", "contain")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryText)"))
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryText) strong, \(root) .\(TCUserConfigurationClass.inventoryText) span"))
                .custom("display", "block")
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryText) strong"))
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryText) span"))
                .custom("margin-top", "3px")
                .custom("color", "var(--tc-user-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.emptyState)"))
                .custom("grid-column", "1 / -1")
                .custom("display", "grid")
                .custom("justify-items", "center")
                .custom("gap", "6px")
                .custom("min-height", "150px")
                .custom("padding", "24px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(3, 19, 34, 0.58)")
                .custom("border", "1px dashed rgba(102, 184, 236, 0.26)")
                .custom("border-radius", "12px")
                .custom("color", "var(--tc-user-muted)")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.emptyState) img"))
                .custom("width", "46px !important")
                .custom("height", "46px !important")
                .custom("object-fit", "contain")
                .custom("opacity", "0.72")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.emptyState) strong"))
                .custom("color", "var(--tc-user-ink)")
                .custom("font-size", "14px")

            CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.emptyState) span"))
                .custom("font-size", "11px")
        }

        WebApp.current.addStylesheet {
            MediaRule(.screen.maxWidth(1080.px)) {
                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.workspace)"))
                    .custom("grid-template-columns", "260px minmax(0, 1fr)")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metrics)"))
                    .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.cards)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.cardWide)"))
                    .custom("grid-column", "auto")
            }

            MediaRule(.screen.maxWidth(760.px)) {
                CSSRule(Pointer(root))
                    .custom("padding", "0")
                    .custom("align-items", "stretch")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.shell)"))
                    .custom("width", "100vw")
                    .custom("height", "100vh")
                    .custom("padding", "8px")
                    .custom("border-radius", "0")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.header)"))
                    .custom("min-height", "64px")
                    .custom("padding", "8px 8px 8px 13px")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.header) h2"))
                    .custom("font-size", "19px")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.headerActions) > .\(TCUserConfigurationClass.statusPill)"))
                    .custom("display", "none")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.workspace)"))
                    .custom("display", "block")
                    .overflow(.auto)

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.sidebar)"))
                    .custom("margin-bottom", "10px")
                    .overflow(.visible)

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.content)"))
                    .custom("padding-right", "0")
                    .overflow(.visible)

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.avatar)"))
                    .custom("width", "190px")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.formGrid), \(root) .\(TCUserConfigurationClass.summaryGrid)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.fieldWide)"))
                    .custom("grid-column", "auto")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryItem)"))
                    .custom("grid-template-columns", "42px minmax(0, 1fr)")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.inventoryType)"))
                    .custom("grid-column", "2")
                    .custom("justify-self", "start")
            }

            MediaRule(.screen.maxWidth(420.px)) {
                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.metrics)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCUserConfigurationClass.headerMeta)"))
                    .custom("display", "none")
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) *"))
                    .custom("scroll-behavior", "auto !important")
                    .custom("transition", "none !important")
            }
        }
    }
}
