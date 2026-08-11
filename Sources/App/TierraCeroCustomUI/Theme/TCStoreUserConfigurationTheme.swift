//
//  TCStoreUserConfigurationTheme.swift
//

import Foundation
import Web

enum TCStoreUserConfigurationClass {
    static let root = "tc-store-user-configuration"
    static let shell = "tc-store-user-configuration-shell"
    static let header = "tc-store-user-configuration-header"
    static let headerCopy = "tc-store-user-configuration-header-copy"
    static let eyebrow = "tc-store-user-configuration-eyebrow"
    static let title = "tc-store-user-configuration-title"
    static let headerMeta = "tc-store-user-configuration-header-meta"
    static let headerActions = "tc-store-user-configuration-header-actions"
    static let action = "tc-store-user-configuration-action"
    static let actionPrimary = "tc-store-user-configuration-action-primary"
    static let close = "tc-store-user-configuration-close"
    static let workspace = "tc-store-user-configuration-workspace"
    static let sidebar = "tc-store-user-configuration-sidebar"
    static let storesPanel = "tc-store-user-configuration-stores-panel"
    static let summaryPanel = "tc-store-user-configuration-summary-panel"
    static let panelTitle = "tc-store-user-configuration-panel-title"
    static let search = "tc-store-user-configuration-search"
    static let storeList = "tc-store-user-configuration-store-list"
    static let storeRow = "tc-store-user-configuration-store-row"
    static let storeSelected = "tc-store-user-configuration-store-selected"
    static let storeIndicator = "tc-store-user-configuration-store-indicator"
    static let storeIcon = "tc-store-user-configuration-store-icon"
    static let storeCopy = "tc-store-user-configuration-store-copy"
    static let storeName = "tc-store-user-configuration-store-name"
    static let storeStatus = "tc-store-user-configuration-store-status"
    static let summaryIcon = "tc-store-user-configuration-summary-icon"
    static let summaryName = "tc-store-user-configuration-summary-name"
    static let summaryRows = "tc-store-user-configuration-summary-rows"
    static let summaryRow = "tc-store-user-configuration-summary-row"
    static let content = "tc-store-user-configuration-content"
    static let toolbar = "tc-store-user-configuration-toolbar"
    static let toolbarTitle = "tc-store-user-configuration-toolbar-title"
    static let advanced = "tc-store-user-configuration-advanced"
    static let storeContainer = "tc-store-user-configuration-store-container"
    static let storeWorkspace = "tc-store-user-configuration-store-workspace"
    static let storeLoading = "tc-store-user-configuration-store-loading"
    static let storeMain = "tc-store-user-configuration-store-main"
    static let storeHero = "tc-store-user-configuration-store-hero"
    static let storeHeroCopy = "tc-store-user-configuration-store-hero-copy"
    static let storeHeroTitle = "tc-store-user-configuration-store-hero-title"
    static let storeHeroStatus = "tc-store-user-configuration-store-hero-status"
    static let metrics = "tc-store-user-configuration-metrics"
    static let metric = "tc-store-user-configuration-metric"
    static let metricIcon = "tc-store-user-configuration-metric-icon"
    static let metricCopy = "tc-store-user-configuration-metric-copy"
    static let metricLabel = "tc-store-user-configuration-metric-label"
    static let metricValue = "tc-store-user-configuration-metric-value"
    static let cards = "tc-store-user-configuration-cards"
    static let card = "tc-store-user-configuration-card"
    static let cardHeader = "tc-store-user-configuration-card-header"
    static let userList = "tc-store-user-configuration-user-list"
    static let userRow = "tc-store-user-configuration-user-row"
    static let userAvatar = "tc-store-user-configuration-user-avatar"
    static let userIdentity = "tc-store-user-configuration-user-identity"
    static let userName = "tc-store-user-configuration-user-name"
    static let userUsername = "tc-store-user-configuration-user-username"
    static let userState = "tc-store-user-configuration-user-state"
    static let rolePill = "tc-store-user-configuration-role-pill"
    static let statusPill = "tc-store-user-configuration-status-pill"
    static let toolsList = "tc-store-user-configuration-tools-list"
    static let toolRow = "tc-store-user-configuration-tool-row"
    static let toolIcon = "tc-store-user-configuration-tool-icon"
    static let toolCopy = "tc-store-user-configuration-tool-copy"
    static let toolName = "tc-store-user-configuration-tool-name"
    static let toolDetail = "tc-store-user-configuration-tool-detail"
    static let toolCount = "tc-store-user-configuration-tool-count"
    static let addAction = "tc-store-user-configuration-add-action"
}

enum TCStoreUserConfigurationTheme {
    private static var isInstalled = false

    static func apply(to view: BaseElement) {
        install()
        view.removeClass(.transparantBlackBackGround)
        view.backgroundColor(.init(r: 0, g: 0, b: 0, a: 0))
        view.custom("backdrop-filter", "none")
        view.custom("-webkit-backdrop-filter", "none")
        view.class(Class(TCStoreUserConfigurationClass.root))
    }

    static func applyStoreWorkspace(to view: BaseElement) {
        install()
        view.class(Class(TCStoreUserConfigurationClass.storeWorkspace))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }
        isInstalled = true

        let root = ".\(TCStoreUserConfigurationClass.root)"
        let goodButton = ".\(TCCrystalSurfaceClass.goodButton)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("padding", "2.5vh 2.5vw")
                .custom("color", "#edf7ff")
                .custom("font-family", "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif")
                .custom("--tc-store-panel", "rgba(9, 28, 45, 0.84)")
                .custom("--tc-store-raised", "rgba(11, 38, 61, 0.86)")
                .custom("--tc-store-border", "rgba(102, 184, 236, 0.28)")
                .custom("--tc-store-blue", "#49b9f5")
                .custom("--tc-store-ink", "#edf7ff")
                .custom("--tc-store-muted", "#a8bed0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.shell)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("width", "min(1520px, 94vw)")
                .custom("height", "min(94vh, 980px)")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("padding", "10px")
                .custom("gap", "8px")
                .custom("background", "rgba(4, 20, 34, 0.78)")
                .custom("border", "1px solid var(--tc-store-border)")
                .custom("border-radius", "18px")
                .custom("box-shadow", "0 22px 60px rgba(0, 0, 0, 0.42), inset 0 1px 0 rgba(255, 255, 255, 0.035)")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.header)"))
                .custom("display", "block")
                .custom("min-height", "72px")
                .custom("padding", "10px 12px 10px 18px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(10, 31, 49, 0.72)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "3px solid #49b9f5")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.header)::after"))
                .custom("display", "block")
                .custom("clear", "both")
                .custom("content", "''")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.headerCopy)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.eyebrow)"))
                .custom("color", "#f2a65a")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.14em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.title)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-store-ink) !important")
                .custom("font-size", "clamp(21px, 2vw, 29px)")
                .custom("line-height", "1.08")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.headerMeta)"))
                .custom("color", "var(--tc-store-muted)")
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.headerActions)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "flex-end")
                .custom("gap", "8px")
                .custom("flex-wrap", "wrap")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.action), \(root) .\(TCStoreUserConfigurationClass.actionPrimary)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "7px")
                .custom("min-height", "38px")
                .custom("padding", "7px 12px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.34) !important")
                .custom("border-radius", "8px")
                .custom("background", "rgba(5, 22, 38, 0.78) !important")
                .custom("color", "#dcecf8 !important")
                .custom("font-size", "12px")
                .custom("font-weight", "700")
                .custom("cursor", "pointer")
                .custom("transition", "background 140ms ease, border-color 140ms ease, box-shadow 140ms ease, transform 140ms ease")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.action):hover, \(root) .\(TCStoreUserConfigurationClass.actionPrimary):hover"))
                .custom("border-color", "#22b8ff !important")
                .custom("background", "linear-gradient(180deg, rgba(15, 52, 80, 0.9), rgba(5, 27, 48, 0.94)) !important")
                .custom("box-shadow", "0 0 0 1px rgba(34, 184, 255, 0.24), 0 0 14px rgba(34, 184, 255, 0.32), inset 0 1px 0 rgba(255, 255, 255, 0.08)")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.action):active, \(root) .\(TCStoreUserConfigurationClass.actionPrimary):active"))
                .custom("transform", "translateY(0)")
                .custom("box-shadow", "0 0 0 1px rgba(34, 184, 255, 0.18), 0 0 8px rgba(34, 184, 255, 0.2), inset 0 1px 2px rgba(0, 0, 0, 0.24)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.action):focus-visible, \(root) .\(TCStoreUserConfigurationClass.actionPrimary):focus-visible"))
                .custom("outline", "2px solid rgba(34, 184, 255, 0.72)")
                .custom("outline-offset", "2px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.actionPrimary)"))
                .custom("border-color", "#49b9f5 !important")
                .custom("background", "#0b659d !important")
                .custom("color", "#f4fbff !important")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.close)"))
                .custom("position", "static !important")
                .custom("width", "34px !important")
                .custom("height", "34px !important")
                .custom("margin", "0 !important")
                .custom("padding", "5px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.26)")
                .custom("border-radius", "9px")
                .custom("background", "rgba(2, 14, 27, 0.58)")
                .custom("filter", "brightness(2.2)")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.header) > .\(TCStoreUserConfigurationClass.title)"))
                .custom("float", "left !important")
                .custom("margin", "10px 0 0 7px !important")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.header) > .\(TCStoreUserConfigurationClass.action), \(root) .\(TCStoreUserConfigurationClass.header) > .\(TCStoreUserConfigurationClass.actionPrimary), \(root) .\(TCStoreUserConfigurationClass.header) > .\(TCStoreUserConfigurationClass.close)"))
                .custom("float", "right !important")
                .custom("margin-top", "7px !important")
                .custom("margin-left", "8px !important")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.workspace)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(240px, 280px) minmax(0, 1fr)")
                .custom("gap", "10px")
                .custom("min-height", "0")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.sidebar)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "minmax(0, 1fr) auto")
                .custom("gap", "8px")
                .custom("min-height", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storesPanel), \(root) .\(TCStoreUserConfigurationClass.summaryPanel), \(root) .\(TCStoreUserConfigurationClass.content), \(root) .\(TCStoreUserConfigurationClass.card), \(root) .\(TCStoreUserConfigurationClass.metric), \(root) .\(TCStoreUserConfigurationClass.toolbar)"))
                .custom("background", "var(--tc-store-panel)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-radius", "12px")
                .custom("box-sizing", "border-box")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storesPanel)"))
                .custom("min-height", "0")
                .custom("padding", "12px")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.summaryPanel)"))
                .custom("padding", "12px")
                .custom("min-height", "150px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.panelTitle)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("margin", "0 0 10px")
                .custom("color", "var(--tc-store-blue)")
                .custom("font-size", "14px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.05em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.search)"))
                .custom("width", "100% !important")
                .custom("height", "38px !important")
                .custom("margin", "0 0 10px !important")
                .custom("padding", "8px 10px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid #245a7c !important")
                .custom("border-radius", "8px !important")
                .custom("background", "rgba(3, 21, 38, 0.78) !important")
                .custom("color", "#edf7ff !important")
                .custom("font-size", "13px !important")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeList)"))
                .custom("display", "grid")
                .custom("gap", "6px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeRow)"))
                .custom("position", "relative")
                .custom("display", "grid")
                .custom("grid-template-columns", "32px minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "9px")
                .custom("min-height", "58px")
                .custom("padding", "7px 9px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("border-radius", "9px")
                .custom("background", "rgba(5, 23, 39, 0.5)")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeSelected)"))
                .custom("border", "2px solid var(--tc-store-blue) !important")
                .custom("background", "linear-gradient(135deg, rgba(14, 73, 108, 0.72), rgba(5, 31, 54, 0.82)) !important")
                .custom("box-shadow", "0 0 0 1px rgba(73, 185, 245, 0.18), 0 0 18px rgba(73, 185, 245, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.06)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeIndicator)"))
                .custom("position", "absolute")
                .custom("left", "-1px")
                .custom("top", "7px")
                .custom("bottom", "7px")
                .custom("width", "3px")
                .custom("border-radius", "0 3px 3px 0")
                .custom("background", "var(--tc-store-blue)")
                .custom("box-shadow", "0 0 12px rgba(73, 185, 245, 0.7)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeIcon), \(root) .\(TCStoreUserConfigurationClass.summaryIcon)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "32px")
                .custom("height", "32px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(73, 185, 245, 0.28)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(9, 46, 72, 0.7)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeIcon) img, \(root) .\(TCStoreUserConfigurationClass.summaryIcon) img"))
                .custom("width", "20px !important")
                .custom("height", "20px !important")
                .custom("object-fit", "contain")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeCopy)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeName)"))
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "13px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeStatus), \(root) .\(TCStoreUserConfigurationClass.storeHeroStatus), \(root) .\(TCStoreUserConfigurationClass.statusPill)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-height", "20px")
                .custom("padding", "2px 7px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(114, 216, 74, 0.35)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(52, 107, 43, 0.34)")
                .custom("color", "#c9f5b7")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.summaryPanel) h3"))
                .custom("margin", "0")
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.summaryName)"))
                .custom("display", "block")
                .custom("margin", "3px 0 10px")
                .custom("color", "var(--tc-store-muted)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.summaryRows)"))
                .custom("display", "grid")
                .custom("gap", "1px")
                .custom("overflow", "hidden")
                .custom("border", "1px solid rgba(102, 184, 236, 0.16)")
                .custom("border-radius", "8px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.summaryRow)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("gap", "8px")
                .custom("padding", "5px 7px")
                .custom("background", "rgba(3, 18, 33, 0.72)")
                .custom("color", "var(--tc-store-muted)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.summaryRow) strong"))
                .custom("color", "var(--tc-store-ink)")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.content)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("gap", "8px")
                .custom("min-width", "0")
                .custom("min-height", "0")
                .custom("padding", "8px")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolbar)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("min-height", "58px")
                .custom("padding", "8px 10px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolbarTitle)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "20px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.advanced)"))
                .custom("min-height", "36px")
                .custom("padding", "7px 11px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.72)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(8, 52, 82, 0.76)")
                .custom("color", "#dff5ff")
                .custom("font-size", "12px")
                .custom("font-weight", "700")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeContainer)"))
                .custom("position", "relative")
                .custom("min-width", "0")
                .custom("min-height", "0")
                .custom("height", "100% !important")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeWorkspace)"))
                .custom("position", "absolute")
                .custom("inset", "0")
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("width", "100%")
                .custom("height", "100% !important")
                .custom("min-height", "0")
                .custom("overflow", "hidden")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeLoading)"))
                .custom("height", "100%")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("color", "var(--tc-store-muted)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeMain)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto auto minmax(0, 1fr)")
                .custom("gap", "8px")
                .custom("height", "100%")
                .custom("min-height", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeHero)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("padding", "10px 12px")
                .custom("background", "rgba(7, 28, 46, 0.72)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-radius", "10px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeHeroCopy)"))
                .custom("display", "grid")
                .custom("gap", "3px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.storeHeroTitle)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "20px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metrics)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(3, minmax(0, 1fr))")
                .custom("gap", "8px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metric)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "36px minmax(0, 1fr)")
                .custom("align-items", "center")
                .custom("gap", "9px")
                .custom("min-height", "64px")
                .custom("padding", "8px 10px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metricIcon), \(root) .\(TCStoreUserConfigurationClass.toolIcon)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "36px")
                .custom("height", "36px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.28)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(9, 46, 72, 0.74)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metricIcon) img, \(root) .\(TCStoreUserConfigurationClass.toolIcon) img"))
                .custom("width", "22px !important")
                .custom("height", "22px !important")
                .custom("object-fit", "contain")
                .custom("filter", "brightness(1.75)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metricCopy)"))
                .custom("display", "grid")
                .custom("gap", "1px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metricLabel)"))
                .custom("color", "var(--tc-store-muted)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.08em")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.metricValue)"))
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "22px")
                .custom("line-height", "1")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.cards)"))
                .custom("display", "grid")
                .custom("flex", "1 1 0")
                .custom("grid-template-columns", "minmax(0, 1.35fr) minmax(280px, 1fr)")
                .custom("grid-template-rows", "minmax(0, 1fr)")
                .custom("align-items", "stretch")
                .custom("gap", "8px")
                .custom("width", "100%")
                .custom("height", "auto !important")
                .custom("min-height", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.card)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("height", "100% !important")
                .custom("min-width", "0")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("padding", "10px")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.cardHeader)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-height", "32px")
                .custom("margin-bottom", "8px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.cardHeader) h2"))
                .custom("margin", "0")
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userList), \(root) .\(TCStoreUserConfigurationClass.toolsList)"))
                .custom("flex", "1 1 auto")
                .custom("min-height", "0")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userList)"))
                .custom("display", "grid")
                .custom("align-content", "start")
                .custom("gap", "5px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userRow)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "42px minmax(0, 1fr) auto auto")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-height", "58px")
                .custom("padding", "7px 8px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(5, 23, 39, 0.62)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18)")
                .custom("border-radius", "8px")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userAvatar)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "42px")
                .custom("height", "42px")
                .custom("padding", "0")
                .custom("overflow", "hidden")
                .custom("border", "1px solid rgba(73, 185, 245, 0.3)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(9, 46, 72, 0.7)")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userAvatar) img"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("object-fit", "cover")
                .custom("border-radius", "7px !important")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userIdentity)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userName)"))
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "12px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userUsername)"))
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")
                .custom("color", "var(--tc-store-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userState)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "5px")
                .custom("color", "#c9f5b7")
                .custom("font-size", "10px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.rolePill)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("min-height", "22px")
                .custom("padding", "3px 7px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.32)")
                .custom("border-radius", "6px")
                .custom("background", "rgba(14, 73, 108, 0.42)")
                .custom("color", "#dff5ff")
                .custom("font-size", "10px")
                .custom("font-weight", "700")
        }

        WebApp.current.addStylesheet {

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolsList)"))
                .custom("display", "grid")
                .custom("align-content", "start")
                .custom("gap", "6px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolRow)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "36px minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-height", "54px")
                .custom("padding", "7px 8px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(5, 23, 39, 0.62)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18)")
                .custom("border-radius", "8px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolCopy)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolName)"))
                .custom("color", "var(--tc-store-ink)")
                .custom("font-size", "12px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolDetail)"))
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")
                .custom("color", "var(--tc-store-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolCount)"))
                .custom("min-width", "24px")
                .custom("padding", "3px 6px")
                .custom("border-radius", "999px")
                .custom("background", "rgba(73, 185, 245, 0.14)")
                .custom("color", "var(--tc-store-blue)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.addAction), \(root) \(goodButton)"))
                .custom("width", "100%")
                .custom("min-height", "38px")
                .custom("margin-top", "8px")
                .custom("border-radius", "8px")
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) \(goodButton)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "7px")
                .custom("box-sizing", "border-box")
                .custom("padding", "7px 10px")
                .custom("border", "1px solid #2eaeed !important")
                .custom("background", "linear-gradient(135deg, #0b6faa, #0b4572) !important")
                .custom("color", "var(--tc-store-ink) !important")
                .custom("font-weight", "700")
                .custom("cursor", "pointer")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.content) > .\(TCStoreUserConfigurationClass.storeContainer)"))
                .custom("height", "100% !important")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.userRow) > *:last-child"))
                .custom("justify-self", "end")

            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.toolRow) img"))
                .custom("width", "20px !important")
                .custom("height", "20px !important")
                .custom("object-fit", "contain")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCStoreUserConfigurationClass.sidebar), \(root) .\(TCStoreUserConfigurationClass.cards)"))
                .custom("overflow", "hidden")
        }

    }
}
