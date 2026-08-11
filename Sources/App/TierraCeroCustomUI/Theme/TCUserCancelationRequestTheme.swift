//
//  TCUserCancelationRequestTheme.swift
//

import Foundation
import Web

enum TCUserCancelationRequestClass {
    static let root = "tc-user-cancelation-request"
    static let shell = "tc-user-cancelation-request-shell"
    static let header = "tc-user-cancelation-request-header"
    static let headerCopy = "tc-user-cancelation-request-header-copy"
    static let eyebrow = "tc-user-cancelation-request-eyebrow"
    static let close = "tc-user-cancelation-request-close"
    static let content = "tc-user-cancelation-request-content"
    static let warning = "tc-user-cancelation-request-warning"
    static let warningIcon = "tc-user-cancelation-request-warning-icon"
    static let statusReady = "tc-user-cancelation-request-status-ready"
    static let statusError = "tc-user-cancelation-request-status-error"
    static let card = "tc-user-cancelation-request-card"
    static let sectionTitle = "tc-user-cancelation-request-section-title"
    static let details = "tc-user-cancelation-request-details"
    static let detail = "tc-user-cancelation-request-detail"
    static let conflictGrid = "tc-user-cancelation-request-conflict-grid"
    static let conflictItem = "tc-user-cancelation-request-conflict-item"
    static let conflictCopy = "tc-user-cancelation-request-conflict-copy"
    static let conflictValue = "tc-user-cancelation-request-conflict-value"
    static let blockerCard = "tc-user-cancelation-request-blocker-card"
    static let custodianSelector = "tc-user-cancelation-request-custodian-selector"
    static let selectBadge = "tc-user-cancelation-request-select-badge"
    static let emptyState = "tc-user-cancelation-request-empty-state"
    static let footer = "tc-user-cancelation-request-footer"
    static let footerActions = "tc-user-cancelation-request-footer-actions"
    static let closeAction = "tc-user-cancelation-request-close-action"
    static let proceedAction = "tc-user-cancelation-request-proceed-action"
    static let actionDisabled = "tc-user-cancelation-request-action-disabled"
}

enum TCUserCancelationRequestTheme {
    private static var isInstalled = false

    static func apply(to view: BaseElement) {
        install()
        view.removeClass(.transparantBlackBackGround)
        view.backgroundColor(.init(r: 0, g: 0, b: 0, a: 0))
        view.custom("backdrop-filter", "none")
        view.custom("-webkit-backdrop-filter", "none")
        view.class(Class(TCUserCancelationRequestClass.root))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }
        isInstalled = true

        let root = ".\(TCUserCancelationRequestClass.root)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("padding", "3vh 3vw")
                .custom("color", "#edf7ff")
                .custom("font-family", "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif")
                .custom("--tc-cancel-blue", "#49b9f5")
                .custom("--tc-cancel-orange", "#f2a65a")
                .custom("--tc-cancel-ink", "#edf7ff")
                .custom("--tc-cancel-muted", "#a8bed0")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.shell)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr) auto")
                .custom("gap", "12px")
                .custom("width", "min(1056px, 94vw)")
                .custom("height", "min(94vh, 912px)")
                .custom("padding", "12px")
                .custom("box-sizing", "border-box")
                .custom("background", "radial-gradient(circle at 8% 0%, rgba(73, 185, 245, 0.14), transparent 34%), linear-gradient(145deg, rgba(8, 34, 57, 0.94), rgba(2, 13, 26, 0.91))")
                .custom("border", "1px solid rgba(102, 184, 236, 0.28)")
                .custom("border-radius", "22px")
                .custom("box-shadow", "0 34px 100px rgba(0, 0, 0, 0.58), inset 0 1px 0 rgba(255, 255, 255, 0.055)")
                .custom("backdrop-filter", "blur(28px) saturate(138%)")
                .custom("-webkit-backdrop-filter", "blur(28px) saturate(138%)")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.header)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("min-height", "70px")
                .custom("padding", "10px 12px 10px 18px")
                .custom("box-sizing", "border-box")
                .custom("background", "#252c3b")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "3px solid #49b9f5")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.headerCopy)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.eyebrow)"))
                .custom("color", "var(--tc-cancel-orange)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.13em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.headerCopy) h2"))
                .custom("margin", "0")
                .custom("color", "var(--tc-cancel-ink)")
                .custom("font-size", "clamp(21px, 2vw, 28px)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.headerCopy) > span:last-child"))
                .custom("color", "var(--tc-cancel-muted)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.close)"))
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

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.content)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "12px")
                .custom("min-height", "0")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "36px minmax(0, 1fr)")
                .custom("align-items", "center")
                .custom("gap", "11px")
                .custom("grid-column", "1 / -1")
                .custom("padding", "12px")
                .custom("background", "rgba(91, 56, 24, 0.52)")
                .custom("border", "1px solid rgba(242, 166, 90, 0.42)")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warningIcon)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "34px")
                .custom("height", "34px")
                .custom("border", "1px solid rgba(242, 166, 90, 0.58)")
                .custom("border-radius", "50%")
                .custom("color", "var(--tc-cancel-orange)")
                .custom("font-weight", "900")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning) strong, \(root) .\(TCUserCancelationRequestClass.warning) span"))
                .custom("display", "block")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning) span"))
                .custom("margin-top", "3px")
                .custom("color", "#d7c1a8")
                .custom("font-size", "11px")
                .custom("line-height", "1.45")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning).\(TCUserCancelationRequestClass.statusReady)"))
                .custom("background", "rgba(35, 83, 57, 0.52)")
                .custom("border-color", "rgba(100, 211, 145, 0.42)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning).\(TCUserCancelationRequestClass.statusReady) .\(TCUserCancelationRequestClass.warningIcon)"))
                .custom("border-color", "rgba(100, 211, 145, 0.58)")
                .custom("color", "#83e3aa")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning).\(TCUserCancelationRequestClass.statusReady) span"))
                .custom("color", "#b9ddc8")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning).\(TCUserCancelationRequestClass.statusError)"))
                .custom("background", "rgba(91, 36, 40, 0.58)")
                .custom("border-color", "rgba(255, 112, 103, 0.48)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning).\(TCUserCancelationRequestClass.statusError) .\(TCUserCancelationRequestClass.warningIcon)"))
                .custom("border-color", "rgba(255, 112, 103, 0.62)")
                .custom("color", "#ff8f87")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning).\(TCUserCancelationRequestClass.statusError) span"))
                .custom("color", "#efbeb9")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.card)"))
                .custom("min-width", "0")
                .custom("padding", "15px")
                .custom("background", "rgba(9, 32, 52, 0.74)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-radius", "14px")
                .custom("backdrop-filter", "blur(14px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(14px) saturate(120%)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.sectionTitle)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("margin-bottom", "12px")
                .custom("padding-bottom", "8px")
                .custom("border-bottom", "1px solid rgba(73, 185, 245, 0.16)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.sectionTitle) strong"))
                .custom("color", "var(--tc-cancel-blue)")
                .custom("font-size", "15px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.sectionTitle) span"))
                .custom("color", "var(--tc-cancel-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.details)"))
                .custom("display", "grid")
                .custom("gap", "1px")
                .custom("background", "rgba(102, 184, 236, 0.14)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.16)")
                .custom("border-radius", "10px")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.detail)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("gap", "12px")
                .custom("padding", "8px 10px")
                .custom("background", "rgba(3, 18, 33, 0.86)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.detail) span"))
                .custom("color", "var(--tc-cancel-muted)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.detail) strong"))
                .custom("overflow-wrap", "anywhere")
                .custom("text-align", "right")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.conflictGrid)"))
                .custom("display", "grid")
                .custom("gap", "1px")
                .custom("background", "rgba(102, 184, 236, 0.14)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.16)")
                .custom("border-radius", "10px")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.conflictItem)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("min-height", "54px")
                .custom("padding", "9px 10px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(3, 18, 33, 0.86)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.conflictCopy)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.conflictCopy) strong"))
                .custom("color", "var(--tc-cancel-ink)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.conflictCopy) span"))
                .custom("color", "var(--tc-cancel-muted)")
                .custom("font-size", "9px")
                .custom("line-height", "1.35")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.conflictValue)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-width", "30px")
                .custom("max-width", "150px")
                .custom("padding", "5px 8px")
                .custom("border", "1px solid rgba(242, 166, 90, 0.38)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(242, 166, 90, 0.09)")
                .custom("color", "var(--tc-cancel-orange)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.blockerCard)"))
                .custom("border-color", "rgba(255, 112, 103, 0.42)")
                .custom("background", "linear-gradient(145deg, rgba(73, 26, 34, 0.72), rgba(9, 32, 52, 0.76))")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.blockerCard) .\(TCUserCancelationRequestClass.sectionTitle) strong"))
                .custom("color", "#ff8f87")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.blockerCard) .\(TCUserCancelationRequestClass.conflictValue)"))
                .custom("border-color", "rgba(255, 112, 103, 0.48)")
                .custom("background", "rgba(255, 112, 103, 0.1)")
                .custom("color", "#ff9b94")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.custodianSelector)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("margin-top", "10px")
                .custom("padding", "10px 12px")
                .custom("background", "linear-gradient(145deg, rgba(15, 57, 84, 0.9), rgba(5, 27, 46, 0.9))")
                .custom("border", "1px solid #245a7c")
                .custom("border-radius", "10px")
                .custom("cursor", "pointer")
                .custom("transition", "border-color 160ms ease, transform 160ms ease, background 160ms ease")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.custodianSelector):hover"))
                .custom("border-color", "rgba(73, 185, 245, 0.82)")
                .custom("background", "linear-gradient(145deg, rgba(20, 75, 108, 0.94), rgba(7, 36, 61, 0.94))")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.custodianSelector) > div"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.custodianSelector) > div span:first-child"))
                .custom("color", "var(--tc-cancel-orange)")
                .custom("font-size", "9px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.08em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.custodianSelector) strong"))
                .custom("color", "var(--tc-cancel-ink)")
                .custom("font-size", "12px")
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.custodianSelector) > div span:last-child"))
                .custom("color", "var(--tc-cancel-muted)")
                .custom("font-size", "9px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.selectBadge)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-width", "82px")
                .custom("padding", "6px 10px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.46)")
                .custom("border-radius", "999px")
                .custom("color", "var(--tc-cancel-blue)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.emptyState)"))
                .custom("display", "grid")
                .custom("gap", "5px")
                .custom("grid-column", "1 / -1")
                .custom("padding", "22px")
                .custom("background", "rgba(35, 83, 57, 0.38)")
                .custom("border", "1px solid rgba(100, 211, 145, 0.3)")
                .custom("border-radius", "14px")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.emptyState) strong"))
                .custom("color", "#83e3aa")
                .custom("font-size", "15px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.emptyState) span"))
                .custom("color", "#b9ddc8")
                .custom("font-size", "11px")
                .custom("line-height", "1.45")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.footer)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "12px")
                .custom("padding", "10px 12px")
                .custom("background", "#252c3b")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.footer) strong, \(root) .\(TCUserCancelationRequestClass.footer) span"))
                .custom("display", "block")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.footer) span"))
                .custom("margin-top", "2px")
                .custom("color", "var(--tc-cancel-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.footerActions)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "flex-end")
                .custom("gap", "8px")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.closeAction)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "auto !important")
                .custom("min-width", "110px")
                .custom("min-height", "38px")
                .custom("padding", "8px 14px")
                .custom("border", "1px solid #245a7c")
                .custom("border-radius", "9px")
                .custom("background", "linear-gradient(145deg, rgba(23, 102, 149, 0.96), rgba(8, 48, 78, 0.96))")
                .custom("color", "var(--tc-cancel-ink)")
                .custom("font-size", "11px")
                .custom("font-weight", "800")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.proceedAction)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "auto !important")
                .custom("min-width", "190px")
                .custom("min-height", "38px")
                .custom("padding", "8px 16px")
                .custom("box-sizing", "border-box")
                .custom("border-radius", "9px")
                .custom("font-size", "11px")
                .custom("font-weight", "800")
                .custom("cursor", "pointer")

            CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.proceedAction).\(TCUserCancelationRequestClass.actionDisabled)"))
                .custom("opacity", "0.42")
                .custom("filter", "grayscale(0.45)")
                .custom("cursor", "not-allowed")
                .custom("pointer-events", "none")
        }

        WebApp.current.addStylesheet {
            MediaRule(.screen.maxWidth(700.px)) {
                CSSRule(Pointer(root))
                    .custom("padding", "0")
                    .custom("align-items", "stretch")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.shell)"))
                    .custom("width", "100vw")
                    .custom("height", "100vh")
                    .custom("padding", "8px")
                    .custom("border-radius", "0")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.content)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.warning)"))
                    .custom("grid-column", "auto")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.footer)"))
                    .custom("align-items", "stretch")
                    .custom("flex-direction", "column")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.closeAction)"))
                    .custom("width", "100% !important")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.footerActions)"))
                    .custom("width", "100%")
                    .custom("flex-direction", "column")

                CSSRule(Pointer("\(root) .\(TCUserCancelationRequestClass.proceedAction)"))
                    .custom("width", "100% !important")
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) *"))
                    .custom("transition", "none !important")
            }
        }
    }
}
