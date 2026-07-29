//
//  TCOrderViewTheme.swift
//

import Foundation
import Web

private typealias OrderRule = CSSRule

enum TCOrderViewClass {
    static let root = "tc-order-view-theme"
    static let shell = "tc-order-shell"
    static let toolbar = "tc-order-toolbar"
    static let content = "tc-order-content"
    static let headerTitle = "tc-order-header-title"
    static let headerStatus = "tc-order-header-status"
    static let statusControl = "tc-order-status-control"
    static let statusMenu = "tc-order-status-menu"
    static let statusOption = "tc-order-status-option"
    static let accountBreadcrumb = "tc-order-account-breadcrumb"
    static let orderBreadcrumb = "tc-order-breadcrumb"
    static let breadcrumbDivider = "tc-order-breadcrumb-divider"
    static let quickTools = "tc-order-quick-tools"
    static let compactActions = "tc-order-compact-actions"
    static let printAction = "tc-order-print-action"
    static let quickSeparator = "tc-order-quick-separator"
    static let activeOrdersAction = "tc-order-active-orders-action"
    static let historyAction = "tc-order-history-action"
    static let newOrderAction = "tc-order-new-action"
    static let windowAction = "tc-order-window-action"
    static let closeAction = "tc-order-close-action"
    static let editAction = "tc-order-edit-action"
    static let handoffAction = "tc-order-handoff-action"

    static let body = "tc-order-body"
    static let mainColumn = "tc-order-main-column"
    static let sideColumn = "tc-order-side-column"
    static let equipmentCard = "tc-order-equipment-card"
    static let communicationsGrid = "tc-order-communications-grid"
    static let notesCard = "tc-order-notes-card"
    static let filesCard = "tc-order-files-card"
    static let chargesCard = "tc-order-charges-card"
    static let summaryScroll = "tc-order-summary-scroll"
    static let summaryHeaderActions = "tc-order-summary-actions"
    static let summaryIdentity = "tc-order-summary-identity"
    static let rewardsCard = "tc-order-rewards-card"
    static let surveysCard = "tc-order-surveys-card"
    static let detailsStack = "tc-order-details-stack"
    static let detailSection = "tc-order-detail-section"
    static let detailHeader = "tc-order-detail-header"
    static let detailBody = "tc-order-detail-body"
    static let addressHeader = "tc-order-address-header"
    static let addressBody = "tc-order-address-body"
    static let outcomeBar = "tc-order-outcome-bar"

    static let equipment = "tc-order-equipment"
    static let equipmentMeta = "tc-order-equipment-meta"
    static let equipmentDetails = "tc-order-equipment-details"
    static let equipmentOverview = "tc-order-equipment-overview"
    static let equipmentChecks = "tc-order-equipment-checks"
    static let equipmentDiagnosis = "tc-order-equipment-diagnosis"
    static let equipmentWorkflow = "tc-order-equipment-workflow"
}

/// Scoped Tierra Cero presentation for the production OrderView.
///
/// Existing OrderView nodes keep ownership of state and behavior. This theme
/// changes only their layout and visual hierarchy while order mode is active.
enum TCOrderViewTheme {
    private static var isInstalled = false

    static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCOrderViewClass.root)"

        // Keep each @Rules block bounded. Large variadic rule builders can
        // overflow the Swift/Wasm runtime while materializing RulesContent.
        WebApp.current.addStylesheet {
            OrderRule(Pointer(root))
                .custom("--tc-order-canvas", "transparent")
                .custom("--tc-order-surface", "rgba(6, 24, 42, 0.40)")
                .custom("--tc-order-surface-raised", "rgba(10, 39, 63, 0.48)")
                .custom("--tc-order-surface-deep", "rgba(3, 21, 38, 0.72)")
                .custom("--tc-order-border", "rgba(102, 184, 236, 0.28)")
                .custom("--tc-order-border-soft", "rgba(122, 148, 168, 0.20)")
                .custom("--tc-order-blue", "#1689e8")
                .custom("--tc-order-blue-soft", "#5cb7ff")
                .custom("--tc-order-orange", "#ff9f0a")
                .custom("--tc-order-green", "#53c653")
                .custom("--tc-order-red", "#f04b3f")
                .custom("--tc-order-ink", "#f3f6f8")
                .custom("--tc-order-muted", "#96a2ad")
                .custom("background", "transparent !important")
                .custom("color", "var(--tc-order-ink)")
                .custom("font-family", "Lucida Grande, Lucida Sans Unicode, Arial, sans-serif")
                .custom("backdrop-filter", "none")
                .custom("-webkit-backdrop-filter", "none")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.shell)"))
                .custom("top", "0 !important")
                .custom("left", "0 !important")
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("padding", "0 !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border)")
                .custom("border-radius", "0 !important")
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 57, 0.28), rgba(3, 17, 32, 0.18)) !important")
                .custom("box-shadow", "0 18px 54px rgba(0, 0, 0, 0.28), inset 0 1px 0 rgba(255, 255, 255, 0.04) !important")
                .custom("backdrop-filter", "blur(8px) saturate(116%)")
                .custom("-webkit-backdrop-filter", "blur(8px) saturate(116%)")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.toolbar)"))
                .position(.relative)
                .custom("height", "62px")
                .custom("min-height", "62px")
                .custom("padding", "0 18px !important")
                .custom("box-sizing", "border-box")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("border-bottom", "1px solid var(--tc-order-border)")
                .custom("background", "#252c3b")
                .custom("box-shadow", "0 8px 24px rgba(0, 0, 0, 0.22)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.toolbar) > .clear"))
                .custom("display", "none")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.toolbar) > div:not(.\(TCOrderViewClass.headerTitle)):not(.\(TCOrderViewClass.quickTools))"))
                .custom("float", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.toolbar) > .\(TCOrderViewClass.accountBreadcrumb), \(root) .\(TCOrderViewClass.toolbar) > .\(TCOrderViewClass.orderBreadcrumb)"))
                .custom("height", "34px")
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("padding", "0 !important")
                .custom("margin", "0 8px 0 0 !important")
                .custom("border", "0")
                .custom("background", "transparent !important")
                .custom("box-shadow", "none !important")
                .custom("font-size", "15px !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.accountBreadcrumb)"))
                .custom("order", "1")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.breadcrumbDivider)"))
                .custom("order", "2")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.orderBreadcrumb)"))
                .custom("order", "3")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.orderBreadcrumb)"))
                .custom("color", "var(--tc-order-blue-soft) !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.breadcrumbDivider)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("height", "34px")
                .custom("margin-right", "8px")
                .custom("color", "var(--tc-order-muted)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.headerTitle)"))
                .position(.absolute)
                .custom("left", "50%")
                .custom("top", "50%")
                .custom("transform", "translate(-50%, -50%)")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "4px")
                .custom("max-width", "36%")
                .custom("white-space", "nowrap")
                .custom("font-size", "22px")
                .custom("font-weight", "700")
                .custom("color", "var(--tc-order-ink)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.headerStatus)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-height", "56px")
                .custom("box-sizing", "border-box")
                .custom("margin-left", "14px")
                .custom("padding", "8px 20px")
                .custom("border-radius", "999px")
                .custom("font-size", "26px")
                .custom("font-weight", "700")
                .custom("line-height", "1")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.08), 0 8px 22px rgba(0, 0, 0, 0.16)")
        }

        WebApp.current.addStylesheet {
            OrderRule(Pointer("\(root) .\(TCOrderViewClass.quickTools)"))
                .custom("order", "10")
                .custom("display", "flex")
                .custom("flex-direction", "row-reverse")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("height", "40px")
                .custom("margin", "0 10px 0 auto !important")
                .custom("overflow", "visible")
                .custom("float", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.quickTools) > *"))
                .custom("float", "none !important")
                .custom("margin", "0 !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.quickTools) .uibtn"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "7px")
                .custom("min-height", "34px")
                .custom("padding", "0 12px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "7px !important")
                .custom("background", "rgba(11, 29, 46, 0.72) !important")
                .custom("background-image", "none !important")
                .custom("color", "var(--tc-order-ink) !important")
                .custom("box-shadow", "none !important")
                .custom("backdrop-filter", "blur(10px)")
                .custom("-webkit-backdrop-filter", "blur(10px)")
                .custom("font-size", "14px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.newOrderAction)"))
                .custom("border-color", "#1473c9 !important")
                .custom("background", "#0d66b9 !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.activeOrdersAction), \(root) .\(TCOrderViewClass.quickSeparator)"))
                .custom("display", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.compactActions)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("gap", "6px")
                .custom("height", "34px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.compactActions) img, \(root) .\(TCOrderViewClass.windowAction)"))
                .custom("width", "32px !important")
                .custom("height", "32px !important")
                .custom("margin", "0 !important")
                .custom("padding", "8px !important")
                .custom("box-sizing", "content-box")
                .custom("object-fit", "contain")
                .custom("border", "1px solid transparent")
                .custom("border-radius", "7px")
                .custom("float", "none !important")
                .custom("transition", "background 140ms ease, border-color 140ms ease")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.compactActions) img:hover, \(root) .\(TCOrderViewClass.windowAction):hover"))
                .custom("border-color", "var(--tc-order-border)")
                .custom("background", "rgba(29, 72, 111, 0.56)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.windowAction)"))
                .custom("margin-left", "2px !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.handoffAction)"))
                .custom("order", "11")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.editAction)"))
                .custom("order", "12")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.closeAction)"))
                .custom("order", "13")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.content)"))
                .custom("height", "calc(100% - 62px) !important")
                .custom("box-sizing", "border-box")
                .custom("background", "transparent")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.content) > div"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("margin", "0 !important")
        }

        WebApp.current.addStylesheet {
            OrderRule(Pointer("\(root) .\(TCOrderViewClass.body)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 2fr) minmax(390px, 1fr)")
                .custom("gap", "10px")
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("padding", "10px")
                .custom("box-sizing", "border-box")
                .custom("background", "transparent")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.mainColumn), \(root) .\(TCOrderViewClass.sideColumn)"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("min-width", "0")
                .custom("margin", "0 !important")
                .custom("padding", "0 !important")
                .custom("float", "none !important")
                .custom("box-sizing", "border-box")
                .custom("border", "0 !important")
                .custom("background", "transparent !important")
                .custom("box-shadow", "none !important")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.mainColumn)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "minmax(220px, 36%) minmax(210px, 37%) minmax(160px, 27%)")
                .custom("gap", "8px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentCard), \(root) .\(TCOrderViewClass.communicationsGrid), \(root) .\(TCOrderViewClass.chargesCard), \(root) .\(TCOrderViewClass.summaryScroll), \(root) .\(TCOrderViewClass.outcomeBar)"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("margin", "0 !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "11px !important")
                .custom("background", "linear-gradient(145deg, var(--tc-order-surface-raised), var(--tc-order-surface)) !important")
                .custom("box-shadow", "0 10px 26px rgba(0, 0, 0, 0.18), inset 0 1px 0 rgba(255, 255, 255, 0.04) !important")
                .custom("backdrop-filter", "blur(9px) saturate(118%)")
                .custom("-webkit-backdrop-filter", "blur(9px) saturate(118%)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentCard)"))
                .custom("padding", "10px !important")
                .overflow(.auto)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.communicationsGrid)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "7fr 3fr")
                .custom("gap", "8px")
                .custom("padding", "0")
                .custom("border", "0 !important")
                .custom("background", "transparent !important")
                .custom("box-shadow", "none !important")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.notesCard), \(root) .\(TCOrderViewClass.filesCard)"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("min-width", "0")
                .custom("margin", "0 !important")
                .custom("padding", "10px")
                .custom("box-sizing", "border-box")
                .custom("float", "none !important")
                .custom("border", "1px solid var(--tc-order-border)")
                .custom("border-radius", "10px")
                .custom("background", "var(--tc-order-surface)")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.03)")
                .custom("backdrop-filter", "blur(10px)")
                .custom("-webkit-backdrop-filter", "blur(10px)")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.notesCard)"))
                .custom("display", "block")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.notesCard) h3, \(root) .\(TCOrderViewClass.filesCard) h3, \(root) .\(TCOrderViewClass.chargesCard) h2"))
                .custom("margin", "0 !important")
                .custom("color", "var(--tc-order-ink) !important")
                .custom("font-size", "17px !important")
                .custom("font-weight", "600")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.notesCard) input, \(root) .\(TCOrderViewClass.notesCard) select, \(root) .\(TCOrderViewClass.filesCard) input"))
                .custom("border-color", "var(--tc-order-border) !important")
                .custom("border-radius", "7px !important")
                .custom("background", "var(--tc-order-surface-deep) !important")
                .custom("color", "var(--tc-order-ink) !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.filesCard) .roundGrayBlackDark"))
                .custom("border", "1px dashed #536472 !important")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(13, 23, 31, 0.54) !important")
                .custom("box-shadow", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.chargesCard)"))
                .custom("padding", "9px 12px")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.chargesCard) table"))
                .custom("border-collapse", "collapse")
                .custom("font-size", "13px !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.chargesCard) td"))
                .custom("padding", "4px 6px")
                .custom("border-bottom", "1px solid var(--tc-order-border-soft)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.chargesCard) .uibtn"))
                .custom("min-height", "32px")
                .custom("padding", "0 10px")
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "7px !important")
                .custom("background", "rgba(11, 29, 46, 0.72) !important")
                .custom("background-image", "none !important")
                .custom("color", "var(--tc-order-ink) !important")
                .custom("box-shadow", "none !important")
        }

        WebApp.current.addStylesheet {
            OrderRule(Pointer("\(root) .\(TCOrderViewClass.sideColumn)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "minmax(0, 1fr) 85px")
                .custom("gap", "8px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryScroll)"))
                .custom("padding", "12px")
                .custom("font-size", "15px !important")
                .overflow(.auto)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryHeaderActions)"))
                .custom("min-height", "34px")
                .custom("padding-bottom", "6px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryHeaderActions) > img"))
                .custom("width", "32px !important")
                .custom("height", "32px !important")
                .custom("padding", "5px !important")
                .custom("margin", "0 3px 0 0 !important")
                .custom("object-fit", "contain")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryHeaderActions) > img:nth-of-type(4)"))
                .custom("display", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryHeaderActions) .uibtn"))
                .custom("min-height", "30px")
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "7px !important")
                .custom("background", "rgba(11, 29, 46, 0.72) !important")
                .custom("background-image", "none !important")
                .custom("box-shadow", "none !important")
                .custom("font-size", "13px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryIdentity)"))
                .custom("padding", "8px 0 10px")
                .custom("border-bottom", "1px solid var(--tc-order-border-soft)")
                .custom("font-size", "18px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryIdentity) .uibtn:not(.\(TCOrderViewClass.statusControl))"))
                .custom("border", "1px solid rgba(83, 198, 83, 0.30) !important")
                .custom("border-radius", "999px !important")
                .custom("background", "rgba(83, 198, 83, 0.08) !important")
                .custom("background-image", "none !important")
                .custom("box-shadow", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.summaryIdentity) .\(TCOrderViewClass.statusControl).uibtn"))
                .custom("display", "inline-flex !important")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "9px")
                .custom("width", "auto !important")
                .custom("max-width", "100%")
                .custom("min-height", "48px")
                .custom("margin", "0 !important")
                .custom("padding", "3px 12px 3px 12px !important")
                .custom("box-sizing", "border-box")
                .custom("float", "right !important")
                .custom("border-radius", "999px !important")
                .custom("background-image", "none !important")
                .custom("font-size", "24px !important")
                .custom("font-weight", "700")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.statusControl) > div:first-child"))
                .custom("width", "auto !important")
                .custom("min-width", "0")
                .custom("float", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.statusControl) > div:nth-child(2)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("width", "28px !important")
                .custom("height", "36px")
                .custom("margin", "0 !important")
                .custom("padding", "0 0 0 12px !important")
                .custom("box-sizing", "content-box")
                .custom("float", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.statusControl) > div:nth-child(2) img"))
                .custom("width", "28px !important")
                .custom("height", "28px !important")
                .custom("padding", "0 !important")
                .custom("opacity", "0.82 !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.statusControl) > .clear"))
                .custom("display", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.statusMenu)"))
                .custom("width", "200px !important")
                .custom("margin", "6px 0 0 auto !important")
                .custom("padding", "5px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border)")
                .custom("border-radius", "11px !important")
                .custom("background", "rgba(3, 18, 32, 0.92) !important")
                .custom("box-shadow", "0 16px 38px rgba(0, 0, 0, 0.38), inset 0 1px 0 rgba(255, 255, 255, 0.04)")
                .custom("backdrop-filter", "blur(14px) saturate(124%)")
                .custom("-webkit-backdrop-filter", "blur(14px) saturate(124%)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.statusMenu) .\(TCOrderViewClass.statusOption).uibtn"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("width", "100% !important")
                .custom("min-height", "30px")
                .custom("margin", "3px 0 !important")
                .custom("padding", "5px 9px !important")
                .custom("box-sizing", "border-box")
                .custom("float", "none !important")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18) !important")
                .custom("border-radius", "8px !important")
                .custom("background", "rgba(8, 30, 48, 0.62) !important")
                .custom("background-image", "none !important")
                .custom("box-shadow", "none !important")
                .custom("font-size", "13px !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.rewardsCard)"))
                .custom("min-height", "74px")
                .custom("margin-top", "8px")
                .custom("padding", "10px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border)")
                .custom("border-radius", "9px")
                .custom("background", "rgba(8, 30, 48, 0.40)")
                .custom("backdrop-filter", "blur(9px)")
                .custom("-webkit-backdrop-filter", "blur(9px)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.rewardsCard) img"))
                .custom("max-height", "58px")
                .custom("object-fit", "contain")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.rewardsCard) .textFiledBlackDark"))
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "7px !important")
                .custom("background", "var(--tc-order-surface-deep) !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.surveysCard)"))
                .custom("margin", "8px 0")
                .custom("padding", "10px 4px")
                .custom("border-top", "1px solid var(--tc-order-border-soft)")
                .custom("border-bottom", "1px solid var(--tc-order-border-soft)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.surveysCard) span"))
                .custom("font-size", "12px !important")
                .custom("color", "var(--tc-order-muted)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.surveysCard) div div div"))
                .custom("max-width", "13px")
                .custom("max-height", "13px")
        }

        WebApp.current.addStylesheet {
            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailsStack)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("gap", "0")
                .custom("margin", "0 0 8px !important")
                .custom("padding", "0 !important")
                .custom("border", "0 !important")
                .custom("background", "transparent !important")
                .custom("box-shadow", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailsStack) > .clear, \(root) .\(TCOrderViewClass.detailSection) > .clear"))
                .custom("display", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailSection)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("gap", "0")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailHeader), \(root) .\(TCOrderViewClass.detailBody), \(root) .\(TCOrderViewClass.addressHeader), \(root) .\(TCOrderViewClass.addressBody)"))
                .custom("margin", "0 0 8px !important")
                .custom("padding", "11px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(8, 30, 48, 0.40) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.03) !important")
                .custom("backdrop-filter", "blur(9px)")
                .custom("-webkit-backdrop-filter", "blur(9px)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailHeader) span, \(root) .\(TCOrderViewClass.addressHeader) h2"))
                .custom("color", "var(--tc-order-ink) !important")
                .custom("font-size", "16px !important")
                .custom("font-weight", "600")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailHeader), \(root) .\(TCOrderViewClass.addressHeader)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("min-height", "48px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailHeader) > div"))
                .custom("order", "2")
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("margin", "0 !important")
                .custom("float", "none !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailHeader) img"))
                .custom("width", "18px !important")
                .custom("height", "18px !important")
                .custom("margin", "0 !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.detailBody)"))
                .custom("height", "auto !important")
                .custom("min-height", "42px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.addressHeader) h2"))
                .custom("margin", "3px 0 0 !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.addressBody)"))
                .overflow(.auto)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.outcomeBar)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "flex-end")
                .custom("padding", "8px")
                .overflow(.hidden)

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.outcomeBar) > div"))
                .custom("width", "100%")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.outcomeBar) .uibtn"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-height", "34px")
                .custom("padding", "0 12px")
                .custom("margin", "0 !important")
                .custom("border", "1px solid var(--tc-order-border) !important")
                .custom("border-radius", "8px !important")
                .custom("background", "rgba(11, 29, 46, 0.66) !important")
                .custom("background-image", "none !important")
                .custom("box-shadow", "none !important")
                .custom("font-size", "14px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.outcomeBar) .uibtn span"))
                .custom("font-size", "15px !important")
                .custom("font-weight", "600")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.outcomeBar) .uibtn img"))
                .custom("width", "17px !important")
                .custom("height", "17px !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.outcomeBar) .uibtn:first-of-type"))
                .custom("border-color", "rgba(83, 198, 83, 0.38) !important")
                .custom("background", "rgba(45, 110, 53, 0.42) !important")
                .custom("color", "#d8f0da !important")
        }

        WebApp.current.addStylesheet {
            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipment)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(220px, 35%) minmax(0, 65%)")
                .custom("gap", "12px")
                .custom("height", "100% !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentMeta), \(root) .\(TCOrderViewClass.equipmentDetails)"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("min-width", "0")
                .custom("float", "none !important")
                .custom("box-sizing", "border-box")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentMeta)"))
                .custom("padding", "8px 14px 8px 2px")
                .custom("border-right", "1px solid var(--tc-order-border)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentOverview)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(240px, 58%) minmax(180px, 42%)")
                .custom("gap", "10px")
                .custom("height", "calc(100% - 58px) !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentChecks), \(root) .\(TCOrderViewClass.equipmentDiagnosis)"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("min-width", "0")
                .custom("float", "none !important")
                .custom("box-sizing", "border-box")
                .custom("padding", "8px")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentDiagnosis)"))
                .custom("border-left", "1px solid var(--tc-order-border)")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentDiagnosis) > div:first-child"))
                .custom("color", "var(--tc-order-orange) !important")

            OrderRule(Pointer("\(root) .\(TCOrderViewClass.equipmentWorkflow)"))
                .custom("height", "48px !important")
                .custom("margin", "4px 0 0 !important")
                .custom("padding", "3px 8px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid var(--tc-order-border)")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(8, 30, 48, 0.40) !important")
                .custom("backdrop-filter", "blur(9px)")
                .custom("-webkit-backdrop-filter", "blur(9px)")

            OrderRule(Pointer("\(root) input, \(root) select, \(root) textarea"))
                .custom("box-sizing", "border-box")
                .custom("border-color", "var(--tc-order-border) !important")
                .custom("border-radius", "7px !important")
                .custom("background", "var(--tc-order-surface-deep) !important")
                .custom("color", "var(--tc-order-ink) !important")

            OrderRule(Pointer("\(root) input:focus, \(root) select:focus, \(root) textarea:focus"))
                .custom("border-color", "var(--tc-order-blue) !important")
                .custom("outline", "2px solid rgba(22, 137, 232, 0.20)")

            MediaRule(.screen.maxWidth(1180.px)) {
                OrderRule(Pointer("\(root) .\(TCOrderViewClass.body)"))
                    .custom("grid-template-columns", "minmax(0, 1fr) 360px")

                OrderRule(Pointer("\(root) .\(TCOrderViewClass.headerTitle)"))
                    .custom("display", "none")

                OrderRule(Pointer("\(root) .\(TCOrderViewClass.communicationsGrid)"))
                    .custom("grid-template-columns", "7fr 3fr")
            }
        }
    }
}
