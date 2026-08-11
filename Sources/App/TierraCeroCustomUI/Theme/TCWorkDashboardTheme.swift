//
//  TCWorkDashboardTheme.swift
//

import Foundation
import Web

private typealias Rule = CSSRule

enum TCWorkDashboardClass {
    static let root = "tc-work-dashboard"
    static let background = "tc-work-background"
    static let topBar = "tc-work-top-bar"
    static let topIdentity = "tc-work-top-identity"
    static let topIcon = "tc-work-top-icon"
    static let actionPlus = "tc-work-action-plus"
    static let searchBox = "tc-work-search-box"
    static let workspace = "tc-work-workspace"
    static let toolbar = "tc-work-toolbar"
    static let toolbarPrimary = "tc-work-toolbar-primary"
    static let toolbarPrimaryActive = "tc-work-toolbar-primary-active"
    static let toolbarPrimaryInactive = "tc-work-toolbar-primary-inactive"
    static let stats = "tc-work-stats"
    static let statCard = "tc-work-stat-card"
    static let statLabel = "tc-work-stat-label"
    static let statValue = "tc-work-stat-value"
    static let statIcon = "tc-work-stat-icon"
    static let orderGrid = "tc-work-order-grid"
    static let orderColumn = "tc-work-order-column"
    static let leftRail = "tc-work-left-rail"
    static let brand = "tc-work-brand"
    static let navigation = "tc-work-navigation"
    static let navItem = "tc-work-nav-item"
    static let navItemActive = "tc-work-nav-item-active"
    static let navIcon = "tc-work-nav-icon"
    static let navFooter = "tc-work-nav-footer"
    static let user = "tc-work-user"
    static let messages = "tc-work-messages"
    static let messageTabs = "tc-work-message-tabs"
    static let messageBody = "tc-work-message-body"
    static let messageAction = "tc-work-message-action"
    static let messageCard = "tc-work-message-card"
    static let messageChannel = "tc-work-message-channel"
    static let messageChannelIcon = "tc-work-message-channel-icon"
    static let messageFolio = "tc-work-message-folio"
    static let messageContent = "tc-work-message-content"
    static let messageHeader = "tc-work-message-header"
    static let messageSender = "tc-work-message-sender"
    static let messageTime = "tc-work-message-time"
    static let messagePreview = "tc-work-message-preview"
    static let messageDismiss = "tc-work-message-dismiss"
    static let startupRoot = "tc-work-starting"
    static let startupOverlay = "tc-work-startup-overlay"
    static let startupComplete = "tc-work-startup-complete"
    static let startupCore = "tc-work-startup-core"
    static let startupEmblem = "tc-work-startup-emblem"
    static let startupRing = "tc-work-startup-ring"
    static let startupTitle = "tc-work-startup-title"
    static let startupCopy = "tc-work-startup-copy"
    static let startupStatuses = "tc-work-startup-statuses"
    static let startupStatus = "tc-work-startup-status"
    static let startupState = "tc-work-startup-state"
    static let startupStateWaiting = "tc-work-startup-state-waiting"
    static let startupStateLoading = "tc-work-startup-state-loading"
    static let startupStateOnline = "tc-work-startup-state-online"
    static let startupStateFailed = "tc-work-startup-state-failed"
    static let startupStateSkipped = "tc-work-startup-state-skipped"
    static let startupIndicator = "tc-work-startup-indicator"
    static let startupProgress = "tc-work-startup-progress"
    static let startupProgressFill = "tc-work-startup-progress-fill"
    static let startupScan = "tc-work-startup-scan"
}

enum TCWorkDashboardTheme {
    private static var isInstalled = false

    static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCWorkDashboardClass.root)"

        // Keep each RulesContent builder bounded. A single builder containing
        // the complete dashboard theme can overflow the Swift/Wasm runtime
        // while the stylesheet is materialized during login.
        WebApp.current.addStylesheet {
            Rule(Pointer(root))
                .custom("--tc-work-blue", "#4da3ff")
                .custom("--tc-work-orange", "#ff9f0a")
                .custom("--tc-work-green", "#72d84a")
                .custom("--tc-work-ink", "#f4f7fb")
                .custom("--tc-work-muted", "#97a4b4")
                .custom("--tc-work-border", "rgba(117, 151, 184, 0.24)")
                .custom("--tc-work-panel", "rgba(8, 23, 39, 0.88)")
                .custom("--tc-work-panel-soft", "rgba(12, 30, 48, 0.78)")
                .custom("background", "#020916")
                .custom("color", "var(--tc-work-ink)")
                .custom("font-family", "Lucida Grande, Lucida Sans Unicode, Arial, sans-serif")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.background)"))
                .custom("filter", "none")
                .custom("opacity", "0.72")
                .custom("background-position", "center")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topBar)"))
                .custom("left", "178px")
                .custom("width", "calc(100% - 178px)")
                .custom("height", "70px")
                .custom("box-sizing", "border-box")
                .custom("padding", "8px 14px")
                .custom("background", "rgba(3, 14, 29, 0.92)")
                .custom("border-bottom", "1px solid var(--tc-work-border)")
                .custom("box-shadow", "0 8px 24px rgba(0, 0, 0, 0.25)")
                .custom("text-shadow", "none")
                .custom("backdrop-filter", "blur(12px)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topBar) .topBarButton"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("gap", "6px")
                .custom("height", "40px")
                .custom("line-height", "40px")
                .custom("margin", "7px 0 0 8px")
                .custom("padding", "0 12px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(13, 31, 49, 0.82)")
                .custom("background-image", "none")
                .custom("color", "var(--tc-work-ink)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topBar) .topBarButton:hover"))
                .custom("border-color", "var(--tc-work-blue)")
                .custom("background", "rgba(29, 72, 111, 0.78)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topBar) .topBarButton span"))
                .custom("color", "var(--tc-work-ink)")
                .custom("font-size", "14px")
                .custom("height", "auto")
                .custom("margin-top", "0")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topIdentity)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("height", "54px")
                .custom("float", "right")
                .custom("margin-left", "14px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topIcon)"))
                .custom("width", "28px")
                .custom("height", "28px")
                .custom("object-fit", "contain")
                .custom("cursor", "pointer")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.actionPlus)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "22px !important")
                .custom("height", "30px !important")
                .custom("margin", "0 !important")
                .custom("padding", "0 !important")
                .custom("background", "none !important")
                .custom("color", "var(--tc-work-blue) !important")
                .custom("font-size", "27px !important")
                .custom("font-weight", "400")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.searchBox)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "38px minmax(180px, 1fr) 38px")
                .custom("align-items", "center")
                .custom("width", "350px")
                .custom("height", "42px")
                .custom("margin", "7px 6px 0 0")
                .custom("box-sizing", "border-box")
                .custom("float", "right")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(13, 31, 49, 0.86)")
                .custom("overflow", "hidden")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.searchBox) input"))
                .custom("width", "100%")
                .custom("height", "40px")
                .custom("margin", "0")
                .custom("padding", "0 7px")
                .custom("box-sizing", "border-box")
                .custom("float", "none")
                .custom("border", "0")
                .custom("border-radius", "0")
                .custom("outline", "none")
                .custom("background", "transparent")
                .custom("color", "var(--tc-work-ink)")
                .custom("font-size", "17px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.searchBox) input[type=button], \(root) .\(TCWorkDashboardClass.searchBox) img"))
                .custom("width", "24px")
                .custom("height", "24px")
                .custom("margin", "0 auto")
                .custom("padding", "0")
                .custom("float", "none")
                .custom("border", "0")
                .custom("background-color", "transparent")
                .custom("object-fit", "contain")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.workspace)"))
                .custom("left", "178px")
                .custom("top", "70px")
                .custom("width", "calc(100% - 458px)")
                .custom("height", "calc(100% - 70px)")
                .custom("box-sizing", "border-box")
                .custom("border", "0")
                .custom("border-radius", "0")
                .custom("background", "transparent")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.toolbar)"))
                .position(.relative)
                .custom("height", "64px")
                .custom("box-sizing", "border-box")
                .custom("padding", "14px 12px 8px")
                .custom("background", "rgba(4, 18, 34, 0.74)")
                .custom("border-bottom", "1px solid var(--tc-work-border)")
                .custom("overflow", "visible")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.toolbar) .uibtn"))
                .custom("background", "rgba(11, 29, 46, 0.9)")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "8px")
                .custom("color", "var(--tc-work-ink)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.toolbarPrimary)"))
                .custom("display", "inline-flex")
                .custom("flex-direction", "column")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "62px")
                .custom("height", "54px")
                .custom("margin", "-9px 12px 0 0")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid transparent")
                .custom("border-bottom", "2px solid transparent")
                .custom("border-radius", "8px 8px 0 0")
                .custom("background", "transparent")
                .custom("cursor", "pointer")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.toolbarPrimaryActive)"))
                .custom("border-color", "rgba(77, 163, 255, 0.2)")
                .custom("border-bottom-color", "var(--tc-work-blue)")
                .custom("background", "rgba(35, 82, 129, 0.34)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.toolbarPrimary) img"))
                .custom("width", "28px")
                .custom("height", "28px")
                .custom("object-fit", "contain")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.toolbarPrimary) span"))
                .custom("color", "#dce7f3")
                .custom("font-size", "10px")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.stats)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(4, minmax(0, 1fr))")
                .custom("gap", "14px")
                .custom("height", "112px")
                .custom("box-sizing", "border-box")
                .custom("padding", "16px 12px 10px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statCard)"))
                .custom("position", "relative")
                .custom("min-width", "0")
                .custom("padding", "16px 18px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "12px")
                .custom("background", "linear-gradient(145deg, rgba(14, 34, 53, 0.92), rgba(6, 21, 36, 0.84))")
                .custom("box-shadow", "0 10px 24px rgba(0, 0, 0, 0.18)")
                .custom("backdrop-filter", "blur(10px)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statLabel)"))
                .custom("color", "var(--tc-work-muted)")
                .custom("font-size", "14px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statValue)"))
                .custom("margin-top", "8px")
                .custom("font-size", "29px")
                .custom("line-height", "1")
                .custom("font-weight", "700")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statIcon)"))
                .custom("position", "absolute")
                .custom("right", "18px")
                .custom("top", "25px")
                .custom("width", "34px")
                .custom("height", "34px")
                .custom("object-fit", "contain")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderGrid)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "8px")
                .custom("height", "calc(100% - 176px)")
                .custom("box-sizing", "border-box")
                .custom("padding", "0 12px 12px")
                .custom("overflow", "hidden")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn)"))
                .custom("width", "100%")
                .custom("min-width", "0")
                .custom("height", "100%")
                .custom("box-sizing", "border-box")
                .custom("float", "none")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "12px")
                .custom("background", "rgba(7, 24, 41, 0.82)")
                .custom("backdrop-filter", "blur(9px)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn) h2"))
                .custom("font-size", "18px")
                .custom("margin", "12px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn) .smallButtonBox"))
                .custom("border-radius", "9px")
                .custom("border-color", "rgba(117, 151, 184, 0.26)")
                .custom("background", "rgba(8, 24, 40, 0.92) !important")
                .custom("box-shadow", "none !important")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn) .smallButtonBox .smallButtonBox"))
                .custom("background", "rgba(14, 32, 48, 0.88) !important")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn) .smallButtonBox div, \(root) .\(TCWorkDashboardClass.orderColumn) .smallButtonBox strong"))
                .custom("color", "var(--tc-work-ink) !important")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn) .smallButtonBox .oneLineText"))
                .custom("font-size", "15px !important")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.leftRail)"))
                .custom("left", "0")
                .custom("top", "0")
                .custom("width", "178px")
                .custom("height", "100%")
                .custom("box-sizing", "border-box")
                .custom("padding", "18px 10px")
                .custom("background", "rgba(3, 20, 35, 0.94)")
                .custom("border-right", "1px solid var(--tc-work-border)")
                .custom("backdrop-filter", "blur(14px)")
                .custom("overflow", "hidden")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.brand)"))
                .custom("height", "72px")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("padding", "0 8px")
                .custom("box-sizing", "border-box")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.brand) img"))
                .custom("width", "145px")
                .custom("max-height", "52px")
                .custom("object-fit", "contain")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.navigation)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("gap", "8px")
                .custom("height", "calc(100% - 210px)")
                .custom("padding-top", "18px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.navItem)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("min-height", "54px")
                .custom("padding", "8px 12px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid transparent")
                .custom("border-radius", "9px")
                .custom("color", "#d7dee8")
                .custom("cursor", "pointer")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.navItem):hover"))
                .custom("background", "rgba(35, 82, 129, 0.35)")
                .custom("border-color", "var(--tc-work-border)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.navItemActive)"))
                .custom("background", "rgba(39, 87, 141, 0.45)")
                .custom("border-color", "rgba(77, 163, 255, 0.25)")
                .custom("color", "#ffffff")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.navIcon)"))
                .custom("width", "30px")
                .custom("height", "30px")
                .custom("object-fit", "contain")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.navFooter)"))
                .custom("position", "absolute")
                .custom("left", "10px")
                .custom("right", "10px")
                .custom("bottom", "12px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.user)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("height", "64px")
                .custom("margin-top", "8px")
                .custom("padding", "8px")
                .custom("box-sizing", "border-box")
                .custom("border-top", "1px solid var(--tc-work-border)")
                .custom("cursor", "pointer")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messages)"))
                .custom("right", "0")
                .custom("top", "70px")
                .custom("width", "280px")
                .custom("height", "calc(100% - 70px)")
                .custom("box-sizing", "border-box")
                .custom("padding", "18px 12px 12px")
                .custom("background", "rgba(4, 20, 35, 0.94)")
                .custom("border-left", "1px solid var(--tc-work-border)")
                .custom("backdrop-filter", "blur(14px)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageTabs)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(3, 1fr)")
                .custom("margin", "16px 0 10px")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "8px")
                .custom("overflow", "hidden")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageTabs) > div"))
                .custom("padding", "9px 4px")
                .custom("text-align", "center")
                .custom("font-size", "13px")
                .custom("cursor", "pointer")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageTabs) > div:first-child"))
                .custom("background", "rgba(45, 102, 163, 0.45)")
                .custom("color", "#ffffff")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageBody)"))
                .custom("height", "calc(100% - 224px)")
                .overflow(.auto)

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageBody) .communicationBox"))
                .custom("width", "100%")
                .custom("height", "auto")
                .custom("transition", "none")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageCard)"))
                .custom("position", "relative")
                .custom("display", "grid")
                .custom("grid-template-columns", "38px minmax(0, 1fr)")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("min-height", "76px")
                .custom("margin", "0 0 7px")
                .custom("padding", "9px 10px")
                .custom("box-sizing", "border-box")
                .custom("overflow", "hidden")
                .custom("border", "1px solid rgba(117, 151, 184, 0.12)")
                .custom("border-radius", "10px")
                //.custom("background", "rgba(42, 46, 55, 0.94)")
                .custom("background", "linear-gradient(145deg, rgba(14, 34, 53, 0.92), rgba(6, 21, 36, 0.84))")
                .custom("box-shadow", "0 5px 14px rgba(0, 0, 0, 0.16)")
                .custom("transition", "border-color 160ms ease, background 160ms ease, transform 160ms ease")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageCard):hover"))
                .custom("border-color", "rgba(77, 163, 255, 0.52)")
                .custom("background", "rgba(48, 54, 65, 0.98)")
                .custom("transform", "translateY(-1px)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageChannel)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "5px")
                .custom("min-width", "0")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageChannelIcon)"))
                .custom("width", "28px")
                .custom("height", "28px")
                .custom("object-fit", "contain")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageFolio)"))
                .custom("display", "block")
                .custom("max-width", "38px")
                .custom("font-size", "10px")
                .custom("line-height", "1")
                .custom("text-align", "center")
                .custom("color", "var(--tc-work-muted)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageContent)"))
                .custom("min-width", "0")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageHeader)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("padding-right", "16px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageSender)"))
                .custom("min-width", "0")
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")
                .custom("font-size", "13px")
                .custom("font-weight", "600")
                .custom("color", "#dfe7f1")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageTime)"))
                .custom("font-size", "11px")
                .custom("white-space", "nowrap")
                .custom("color", "var(--tc-work-muted)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messagePreview)"))
                .custom("display", "-webkit-box")
                .custom("-webkit-box-orient", "vertical")
                .custom("-webkit-line-clamp", "2")
                .custom("overflow", "hidden")
                .custom("margin-top", "4px")
                .custom("font-size", "16px")
                .custom("line-height", "1.25")
                .custom("color", "#ffffff")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageDismiss)"))
                .custom("position", "absolute")
                .custom("top", "8px")
                .custom("right", "8px")
                .custom("width", "14px")
                .custom("height", "14px")
                .custom("opacity", "0.72")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageDismiss):hover"))
                .custom("opacity", "1")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageAction)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("height", "40px")
                .custom("margin-top", "7px")
                .custom("padding", "0 14px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-work-border)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(9, 28, 45, 0.72)")
                .custom("cursor", "pointer")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messageAction):hover"))
                .custom("border-color", "var(--tc-work-blue)")
                .custom("background", "rgba(27, 65, 99, 0.72)")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.background)"))
                .custom("transition", "opacity 520ms ease, transform 760ms ease, filter 620ms ease")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.topBar)"))
                .custom("transition", "opacity 420ms ease 120ms, transform 620ms cubic-bezier(0.22, 1, 0.36, 1) 120ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.leftRail)"))
                .custom("transition", "opacity 460ms ease 220ms, transform 680ms cubic-bezier(0.22, 1, 0.36, 1) 220ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.messages)"))
                .custom("transition", "opacity 460ms ease 420ms, transform 680ms cubic-bezier(0.22, 1, 0.36, 1) 420ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.workspace)"))
                .custom("transition", "opacity 520ms ease 340ms, transform 760ms cubic-bezier(0.22, 1, 0.36, 1) 340ms, filter 520ms ease 340ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.orderColumn)"))
                .custom("transition", "opacity 460ms ease 620ms, transform 640ms cubic-bezier(0.22, 1, 0.36, 1) 620ms, border-color 220ms ease")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statCard)"))
                .custom("transition", "opacity 420ms ease 720ms, transform 560ms cubic-bezier(0.22, 1, 0.36, 1) 720ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statCard):nth-child(2)"))
                .custom("transition-delay", "800ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statCard):nth-child(3)"))
                .custom("transition-delay", "880ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.statCard):nth-child(4)"))
                .custom("transition-delay", "960ms")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.background)"))
                .custom("opacity", "0.08")
                .custom("transform", "scale(1.04)")
                .custom("filter", "blur(8px) brightness(0.45)")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.topBar)"))
                .custom("opacity", "0")
                .custom("transform", "translateY(-26px)")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.leftRail)"))
                .custom("opacity", "0")
                .custom("transform", "translateX(-34px)")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.messages)"))
                .custom("opacity", "0")
                .custom("transform", "translateX(34px)")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.workspace)"))
                .custom("opacity", "0")
                .custom("transform", "translateY(18px) scale(0.985)")
                .custom("filter", "blur(5px)")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.orderColumn)"))
                .custom("opacity", "0")
                .custom("transform", "translateY(20px)")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.statCard)"))
                .custom("opacity", "0")
                .custom("transform", "translateY(18px) scale(0.97)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupOverlay)"))
                .position(.fixed)
                .left(0.px)
                .top(0.px)
                .width(100.percent)
                .height(100.percent)
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("overflow", "hidden")
                .custom("pointer-events", "none")
                .custom("background", "radial-gradient(circle at center, rgba(8, 35, 58, 0.52), rgba(2, 8, 17, 0.82) 58%, rgba(1, 5, 12, 0.94))")
                .custom("opacity", "1")
                .custom("transition", "opacity 460ms ease")
                .zIndex(999999999)

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupOverlay).\(TCWorkDashboardClass.startupComplete)"))
                .custom("opacity", "0")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupScan)"))
                .position(.absolute)
                .left(0.px)
                .custom("top", "calc(100% + 8px)")
                .width(100.percent)
                .height(1.px)
                .custom("background", "linear-gradient(90deg, transparent, rgba(77, 163, 255, 0.9), rgba(114, 216, 74, 0.58), transparent)")
                .custom("box-shadow", "0 0 18px rgba(77, 163, 255, 0.68)")
                .custom("transition", "top 1650ms cubic-bezier(0.3, 0.1, 0.2, 1) 80ms")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.startupScan)"))
                .custom("top", "-8px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupCore)"))
                .custom("width", "min(420px, calc(100vw - 40px))")
                .custom("padding", "26px 30px")
                .custom("box-sizing", "border-box")
                .custom("background", "linear-gradient(145deg, rgba(8, 31, 50, 0.88), rgba(3, 14, 28, 0.72))")
                .custom("border", "1px solid rgba(77, 163, 255, 0.42)")
                .custom("clip-path", "polygon(18px 0, 100% 0, 100% calc(100% - 18px), calc(100% - 18px) 100%, 0 100%, 0 18px)")
                .custom("box-shadow", "0 28px 80px rgba(0, 0, 0, 0.58), 0 0 42px rgba(41, 126, 205, 0.14), inset 0 1px 0 rgba(255, 255, 255, 0.07)")
                .custom("backdrop-filter", "blur(18px) saturate(125%)")
                .custom("opacity", "1")
                .custom("transform", "scale(1)")
                .custom("transition", "opacity 380ms ease, transform 460ms ease")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupOverlay).\(TCWorkDashboardClass.startupComplete) .\(TCWorkDashboardClass.startupCore)"))
                .custom("opacity", "0")
                .custom("transform", "scale(1.035)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupEmblem)"))
                .position(.relative)
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .width(94.px)
                .height(94.px)
                .custom("margin", "0 auto")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupRing)"))
                .position(.absolute)
                .left(6.px)
                .top(6.px)
                .width(80.px)
                .height(80.px)
                .custom("box-sizing", "border-box")
                .custom("border", "2px solid rgba(77, 163, 255, 0.25)")
                .custom("border-top-color", "var(--tc-work-blue)")
                .custom("border-right-color", "var(--tc-work-green)")
                .borderRadius(all: 50.percent)
                .custom("opacity", "1")
                .custom("transform", "rotate(270deg) scale(1)")
                .custom("transition", "opacity 620ms ease 160ms, transform 1100ms cubic-bezier(0.22, 1, 0.36, 1) 160ms")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.startupRing)"))
                .custom("opacity", "0.18")
                .custom("transform", "rotate(-90deg) scale(0.82)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupEmblem) img"))
                .width(44.px)
                .height(44.px)
                .custom("object-fit", "contain")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupTitle)"))
                .custom("margin-top", "12px")
                .custom("color", "var(--tc-work-ink)")
                .custom("font-size", "22px")
                .custom("font-weight", "700")
                .custom("letter-spacing", "0.13em")
                .custom("text-align", "center")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupCopy)"))
                .custom("margin-top", "7px")
                .custom("color", "var(--tc-work-muted)")
                .custom("font-size", "11px")
                .custom("letter-spacing", "0.18em")
                .custom("text-align", "center")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStatuses)"))
                .custom("display", "grid")
                .custom("gap", "7px")
                .custom("margin-top", "22px")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStatus)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("min-height", "27px")
                .custom("padding", "0 8px")
                .custom("border-left", "2px solid rgba(77, 163, 255, 0.62)")
                .custom("color", "#dfe9f3")
                .custom("font-size", "11px")
                .custom("letter-spacing", "0.08em")
                .custom("opacity", "1")
                .custom("transform", "translateX(0)")
                .custom("transition", "opacity 360ms ease 560ms, transform 460ms cubic-bezier(0.22, 1, 0.36, 1) 560ms")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.startupStatus)"))
                .custom("opacity", "0.18")
                .custom("transform", "translateX(-10px)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStatus):nth-child(2)"))
                .custom("transition-delay", "760ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStatus):nth-child(3)"))
                .custom("transition-delay", "960ms")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupIndicator)"))
                .width(7.px)
                .height(7.px)
                .backgroundColor(.green)
                .borderRadius(all: 50.percent)
                .custom("box-shadow", "0 0 9px rgba(114, 216, 74, 0.82)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupProgress)"))
                .height(3.px)
                .custom("margin-top", "20px")
                .custom("overflow", "hidden")
                .custom("background", "rgba(77, 163, 255, 0.12)")
                .borderRadius(all: 2.px)

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupProgressFill)"))
                .width(100.percent)
                .height(100.percent)
                .custom("transform-origin", "left center")
                .custom("transform", "scaleX(0)")
                .custom("background", "linear-gradient(90deg, #1379f4, #22c5ff, #72d84a)")
                .custom("box-shadow", "0 0 12px rgba(34, 197, 255, 0.62)")
                .custom("transition", "transform 1650ms cubic-bezier(0.2, 0.8, 0.2, 1) 120ms")

            Rule(Pointer("\(root).\(TCWorkDashboardClass.startupRoot) .\(TCWorkDashboardClass.startupProgressFill)"))
                .custom("transform", "scaleX(0)")

            MediaRule(.all.prefersReducedMotion) {
                Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupOverlay)"))
                    .display(.none)

                Rule(Pointer("\(root) .\(TCWorkDashboardClass.background), \(root) .\(TCWorkDashboardClass.topBar), \(root) .\(TCWorkDashboardClass.leftRail), \(root) .\(TCWorkDashboardClass.messages), \(root) .\(TCWorkDashboardClass.workspace), \(root) .\(TCWorkDashboardClass.orderColumn), \(root) .\(TCWorkDashboardClass.statCard)"))
                    .custom("transition", "none")
                    .custom("opacity", "1 !important")
                    .custom("transform", "none !important")
                    .custom("filter", "none !important")
            }
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupState)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "7px")
                .custom("font-weight", "600")
                .custom("transition", "color 180ms ease")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateWaiting)"))
                .custom("color", "var(--tc-work-muted)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateWaiting) .\(TCWorkDashboardClass.startupIndicator)"))
                .custom("background", "#66798b")
                .custom("box-shadow", "0 0 7px rgba(102, 121, 139, 0.46)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateLoading)"))
                .custom("color", "#4da3ff")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateLoading) .\(TCWorkDashboardClass.startupIndicator)"))
                .custom("background", "#4da3ff")
                .custom("box-shadow", "0 0 10px rgba(77, 163, 255, 0.9)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateOnline)"))
                .custom("color", "#72d84a")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateOnline) .\(TCWorkDashboardClass.startupIndicator)"))
                .custom("background", "#72d84a")
                .custom("box-shadow", "0 0 9px rgba(114, 216, 74, 0.82)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateFailed)"))
                .custom("color", "#ff6b62")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateFailed) .\(TCWorkDashboardClass.startupIndicator)"))
                .custom("background", "#ff5b52")
                .custom("box-shadow", "0 0 9px rgba(255, 91, 82, 0.78)")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateSkipped)"))
                .custom("color", "#d4a75f")

            Rule(Pointer("\(root) .\(TCWorkDashboardClass.startupStateSkipped) .\(TCWorkDashboardClass.startupIndicator)"))
                .custom("background", "#9b7d4d")
                .custom("box-shadow", "0 0 7px rgba(155, 125, 77, 0.5)")
        }
    }
}
