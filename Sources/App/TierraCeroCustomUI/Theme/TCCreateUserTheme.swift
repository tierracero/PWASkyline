//
//  TCCreateUserTheme.swift
//

import Foundation
import Web

enum TCCreateUserClass {
    static let root = "tc-create-user"
    static let shell = "tc-create-user-shell"
    static let header = "tc-create-user-header"
    static let headerCopy = "tc-create-user-header-copy"
    static let headerAvailability = "tc-create-user-header-availability"
    static let eyebrow = "tc-create-user-eyebrow"
    static let close = "tc-create-user-close"
    static let content = "tc-create-user-content"
    static let main = "tc-create-user-main"
    static let sidebar = "tc-create-user-sidebar"
    static let card = "tc-create-user-card"
    static let cardWide = "tc-create-user-card-wide"
    static let sectionHeader = "tc-create-user-section-header"
    static let sectionIcon = "tc-create-user-section-icon"
    static let formGrid = "tc-create-user-form-grid"
    static let field = "tc-create-user-field"
    static let fieldWide = "tc-create-user-field-wide"
    static let usernameField = "tc-create-user-username-field"
    static let readOnlyValue = "tc-create-user-read-only"
    static let toggleRow = "tc-create-user-toggle-row"
    static let days = "tc-create-user-days"
    static let day = "tc-create-user-day"
    static let hint = "tc-create-user-hint"
    static let avatarCard = "tc-create-user-avatar-card"
    static let avatarFrame = "tc-create-user-avatar-frame"
    static let summary = "tc-create-user-summary"
    static let summaryRow = "tc-create-user-summary-row"
    static let footer = "tc-create-user-footer"
    static let footerActions = "tc-create-user-footer-actions"
    static let cancelButton = "tc-create-user-cancel"
    static let submitButton = "tc-create-user-submit"
}

enum TCCreateUserTheme {
    private static var isInstalled = false

    static func apply(to view: BaseElement) {
        install()
        view.removeClass(.transparantBlackBackGround)
        view.backgroundColor(.init(r: 0, g: 0, b: 0, a: 0))
        view.custom("backdrop-filter", "none")
        view.custom("-webkit-backdrop-filter", "none")
        view.class(Class(TCCreateUserClass.root))
    }

    private static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCCreateUserClass.root)"
        let submit = "\(root) .\(TCCreateUserClass.submitButton).\(TCCrystalSurfaceClass.goodButton)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("padding", "3vh 3vw")
                .custom("color", "#edf7ff")
                .custom("font-family", "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif")
                .custom("--tc-create-blue", "#49b9f5")
                .custom("--tc-create-orange", "#f2a65a")
                .custom("--tc-create-ink", "#edf7ff")
                .custom("--tc-create-muted", "#a8bed0")
                .custom("--tc-create-border", "rgba(102, 184, 236, 0.28)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.shell)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr) auto")
                .custom("width", "min(1380px, 95vw)")
                .custom("height", "min(94vh, 920px)")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("padding", "12px")
                .custom("gap", "12px")
                .custom("background", "radial-gradient(circle at 8% 0%, rgba(73, 185, 245, 0.15), transparent 34%), linear-gradient(145deg, rgba(8, 34, 57, 0.93), rgba(2, 13, 26, 0.9))")
                .custom("border", "1px solid var(--tc-create-border)")
                .custom("border-radius", "22px")
                .custom("box-shadow", "0 34px 100px rgba(0, 0, 0, 0.58), inset 0 1px 0 rgba(255, 255, 255, 0.055)")
                .custom("backdrop-filter", "blur(28px) saturate(138%)")
                .custom("-webkit-backdrop-filter", "blur(28px) saturate(138%)")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.header)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto auto")
                .custom("align-items", "center")
                .custom("gap", "14px")
                .custom("min-height", "72px")
                .custom("padding", "10px 12px 10px 18px")
                .custom("box-sizing", "border-box")
                .custom("background", "#252c3b")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "3px solid #49b9f5")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.headerCopy)"))
                .custom("display", "grid")
                .custom("gap", "2px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.eyebrow)"))
                .custom("color", "var(--tc-create-orange)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.13em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.headerCopy) h2"))
                .custom("margin", "0")
                .custom("color", "var(--tc-create-ink)")
                .custom("font-size", "clamp(21px, 2vw, 28px)")
                .custom("line-height", "1.08")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.headerCopy) > span:last-child"))
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "11px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.headerAvailability)"))
                .custom("display", "flex")
                .custom("gap", "7px")
                .custom("flex-wrap", "wrap")
                .custom("justify-content", "flex-end")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.headerAvailability) span"))
                .custom("padding", "5px 8px")
                .custom("border", "1px solid rgba(242, 166, 90, 0.32)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(242, 166, 90, 0.08)")
                .custom("color", "var(--tc-create-orange)")
                .custom("font-size", "9px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.07em")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.close)"))
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

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.content)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) 310px")
                .custom("gap", "12px")
                .custom("min-height", "0")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.main)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("align-content", "start")
                .custom("gap", "12px")
                .custom("min-height", "0")
                .custom("padding-right", "4px")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.sidebar)"))
                .custom("display", "grid")
                .custom("align-content", "start")
                .custom("gap", "12px")
                .custom("min-height", "0")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.card), \(root) .\(TCCreateUserClass.avatarCard), \(root) .\(TCCreateUserClass.summary)"))
                .custom("min-width", "0")
                .custom("padding", "15px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(9, 32, 52, 0.72)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-radius", "14px")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.03)")
                .custom("backdrop-filter", "blur(14px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(14px) saturate(120%)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.cardWide)"))
                .custom("grid-column", "1 / -1")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.sectionHeader)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "18px minmax(0, 1fr)")
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("margin", "0 0 13px")
                .custom("padding", "0 0 8px")
                .custom("border-bottom", "1px solid rgba(73, 185, 245, 0.16)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.sectionIcon)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "18px")
                .custom("height", "18px")
                .custom("color", "var(--tc-create-orange)")
                .custom("font-size", "15px")
                .custom("font-weight", "800")
                .custom("line-height", "1")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.sectionHeader) > div"))
                .custom("display", "flex")
                .custom("align-items", "baseline")
                .custom("flex-wrap", "wrap")
                .custom("gap", "3px 8px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.sectionHeader) h3"))
                .custom("margin", "0")
                .custom("color", "var(--tc-create-blue)")
                .custom("font-size", "14px")
                .custom("line-height", "1.2")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.sectionHeader) > div > span"))
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.formGrid)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "10px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.field)"))
                .custom("display", "grid")
                .custom("gap", "5px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.fieldWide)"))
                .custom("grid-column", "1 / -1")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.field) > label"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "7px")
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "10px")
                .custom("font-weight", "700")
                .custom("letter-spacing", "0.04em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.field) sup"))
                .custom("color", "var(--tc-create-orange)")
                .custom("font-size", "7px")
                .custom("letter-spacing", "0.08em")

            CSSRule(Pointer("\(root) input:not([type='checkbox']), \(root) select"))
                .custom("width", "100% !important")
                .custom("height", "40px !important")
                .custom("margin", "0 !important")
                .custom("padding", "8px 10px !important")
                .custom("box-sizing", "border-box")
                .custom("float", "none !important")
                .custom("border", "1px solid #245a7c !important")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(2, 16, 29, 0.82) !important")
                .custom("color", "var(--tc-create-ink) !important")
                .custom("font-size", "13px !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.025)")

            CSSRule(Pointer("\(root) input:not([type='checkbox']):focus, \(root) select:focus"))
                .custom("border-color", "rgba(73, 185, 245, 0.78) !important")
                .custom("box-shadow", "0 0 0 3px rgba(73, 185, 245, 0.13) !important")
                .custom("outline", "none")

            CSSRule(Pointer("\(root) input::placeholder"))
                .custom("color", "rgba(168, 190, 208, 0.56)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.usernameField)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("border", "1px solid #245a7c")
                .custom("border-radius", "9px")
                .custom("background", "rgba(2, 16, 29, 0.82)")
                .custom("overflow", "hidden")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.usernameField) input"))
                .custom("border", "0 !important")
                .custom("border-radius", "0 !important")
                .custom("background", "transparent !important")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.usernameField) > span"))
                .custom("padding", "0 10px")
                .custom("color", "var(--tc-create-blue)")
                .custom("font-size", "12px")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.readOnlyValue)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("min-height", "40px")
                .custom("padding", "8px 10px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18)")
                .custom("border-radius", "9px")
                .custom("background", "rgba(37, 44, 59, 0.58)")
                .custom("color", "var(--tc-create-ink)")
                .custom("font-size", "13px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.toggleRow)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "12px")
                .custom("min-height", "54px")
                .custom("padding", "8px 10px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.18)")
                .custom("border-radius", "9px")
                .custom("background", "rgba(37, 44, 59, 0.46)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.toggleRow) > div"))
                .custom("display", "grid")
                .custom("gap", "3px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.toggleRow) strong"))
                .custom("color", "var(--tc-create-ink)")
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.toggleRow) span"))
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "9px")

            CSSRule(Pointer("\(root) .switch"))
                .custom("float", "none !important")
                .custom("flex", "0 0 auto")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.days)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(7, minmax(58px, 1fr))")
                .custom("gap", "6px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.day)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "5px")
                .custom("min-height", "34px")
                .custom("padding", "5px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(2, 16, 29, 0.64)")
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.day) .switch"))
                .custom("transform", "scale(0.72)")
                .custom("transform-origin", "center")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.hint)"))
                .custom("display", "grid")
                .custom("gap", "3px")
                .custom("margin-top", "10px")
                .custom("padding", "8px 10px")
                .custom("border-left", "2px solid #f2a65a")
                .custom("background", "rgba(242, 166, 90, 0.06)")
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "9px")
                .custom("line-height", "1.4")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.avatarCard)"))
                .custom("display", "grid")
                .custom("justify-items", "center")
                .custom("gap", "8px")
                .custom("text-align", "center")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.avatarFrame)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "118px")
                .custom("height", "118px")
                .custom("padding", "5px")
                .custom("box-sizing", "border-box")
                .custom("border", "2px solid rgba(73, 185, 245, 0.55)")
                .custom("border-radius", "50%")
                .custom("background", "linear-gradient(145deg, rgba(16, 79, 117, 0.72), rgba(3, 20, 36, 0.9))")
                .custom("box-shadow", "0 0 22px rgba(73, 185, 245, 0.14)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.avatarFrame) img"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("border-radius", "50%")
                .custom("object-fit", "cover")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.avatarCard) > strong"))
                .custom("color", "var(--tc-create-blue)")
                .custom("font-size", "16px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.avatarCard) > span"))
                .custom("max-width", "230px")
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "10px")
                .custom("line-height", "1.4")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.summary) > span"))
                .custom("display", "block")
                .custom("margin-bottom", "8px")
                .custom("color", "var(--tc-create-orange)")
                .custom("font-size", "10px")
                .custom("font-weight", "800")
                .custom("letter-spacing", "0.1em")
                .custom("text-transform", "uppercase")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.summaryRow)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "10px")
                .custom("padding", "8px 0")
                .custom("border-bottom", "1px solid rgba(102, 184, 236, 0.12)")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.summaryRow) span"))
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.summaryRow) strong"))
                .custom("max-width", "170px")
                .custom("color", "var(--tc-create-ink)")
                .custom("font-size", "11px")
                .custom("text-align", "right")
                .custom("overflow-wrap", "anywhere")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.footer)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "14px")
                .custom("min-height", "62px")
                .custom("padding", "9px 12px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(37, 44, 59, 0.86)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.footer) > div:first-child"))
                .custom("display", "grid")
                .custom("gap", "2px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.footer) strong"))
                .custom("color", "var(--tc-create-ink)")
                .custom("font-size", "12px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.footer) span"))
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "10px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.footerActions)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "8px")

            CSSRule(Pointer("\(root) .\(TCCreateUserClass.cancelButton)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-height", "42px")
                .custom("padding", "9px 16px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(102, 184, 236, 0.3)")
                .custom("border-radius", "11px")
                .custom("background", "rgba(2, 16, 29, 0.72)")
                .custom("color", "var(--tc-create-muted)")
                .custom("font-size", "12px")
                .custom("font-weight", "700")
                .custom("cursor", "pointer")

            CSSRule(Pointer(submit))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-height", "42px")
                .custom("padding", "9px 18px")
                .custom("box-sizing", "border-box")
                .custom("border", "2px solid #245a7c !important")
                .custom("border-radius", "13px !important")
                .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.95), rgba(5, 27, 48, 0.95)) !important")
                .custom("color", "#edf7ff !important")
                .custom("font-size", "14px")
                .custom("font-weight", "700")
                .custom("cursor", "pointer")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.08), 0 10px 24px rgba(0, 0, 0, 0.24)")
                .custom("transition", "transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease")

            CSSRule(Pointer("\(submit):hover"))
                .custom("border-color", "#49b9f5 !important")
                .custom("box-shadow", "0 12px 30px rgba(0, 0, 0, 0.32), 0 0 18px rgba(73, 185, 245, 0.16)")
                .custom("transform", "translateY(-1px)")
        }

        WebApp.current.addStylesheet {
            MediaRule(.screen.maxWidth(1080.px)) {
                CSSRule(Pointer("\(root) .\(TCCreateUserClass.content)"))
                    .custom("grid-template-columns", "minmax(0, 1fr) 270px")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.main)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.cardWide)"))
                    .custom("grid-column", "auto")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.days)"))
                    .custom("grid-template-columns", "repeat(4, minmax(58px, 1fr))")
            }

            MediaRule(.screen.maxWidth(760.px)) {
                CSSRule(Pointer(root))
                    .custom("padding", "0")
                    .custom("align-items", "stretch")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.shell)"))
                    .custom("width", "100vw")
                    .custom("height", "100vh")
                    .custom("padding", "8px")
                    .custom("border-radius", "0")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.header)"))
                    .custom("grid-template-columns", "minmax(0, 1fr) auto")
                    .custom("min-height", "64px")
                    .custom("padding", "8px 8px 8px 13px")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.headerAvailability)"))
                    .custom("display", "none")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.content)"))
                    .custom("display", "block")
                    .custom("overflow", "auto")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.main), \(root) .\(TCCreateUserClass.sidebar)"))
                    .custom("display", "grid")
                    .custom("overflow", "visible")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.sidebar)"))
                    .custom("margin-top", "12px")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.formGrid)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.fieldWide)"))
                    .custom("grid-column", "auto")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.footer)"))
                    .custom("display", "grid")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.footerActions)"))
                    .custom("justify-content", "stretch")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.footerActions) > div"))
                    .custom("flex", "1")
            }

            MediaRule(.screen.maxWidth(480.px)) {
                CSSRule(Pointer("\(root) .\(TCCreateUserClass.days)"))
                    .custom("grid-template-columns", "repeat(2, minmax(58px, 1fr))")

                CSSRule(Pointer("\(root) .\(TCCreateUserClass.footer) > div:first-child"))
                    .custom("display", "none")
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) *"))
                    .custom("transition", "none !important")
            }
        }
    }
}
