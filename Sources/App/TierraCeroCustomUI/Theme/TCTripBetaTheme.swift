//
//  TCTripBetaTheme.swift
//

import Foundation
import Web

private typealias Rule = CSSRule

/// Beta-only visual system for views owned by `TripControler`.
///
/// Every selector is rooted at `tc-trip-beta-theme`, so installing the
/// stylesheet does not change views elsewhere in the application.
enum TCTripBetaClass {
    static let root = "tc-trip-beta-theme"
    static let popUp = "tc-v-popup"
    static let popUpPanel = "tc-v-popup-panel"
    static let popUpPanelFitContent = "tc-v-popup-panel-fit-content"
    static let title = "tc-v-title"
    static let titleText = "tc-v-title-text"
    static let titleActions = "tc-v-title-actions"
    static let close = "tc-v-title-close"
    static let bodyGrid = "tc-v-body-grid"
    static let grid = "tc-v-grid"
    static let gridFull = "tc-v-grid-full"
    static let gridOneForth = "tc-v-grid-one-forth"
    static let gridOneThird = "tc-v-grid-one-third"
    static let gridHalf = "tc-v-grid-half"
    static let gridTwoThirds = "tc-v-grid-two-thirds"
    static let gridThreeForths = "tc-v-grid-three-forths"
    static let box = "tc-v-box"
    static let boxStandard = "tc-v-box-standard"
    static let boxRaised = "tc-v-box-raised"
    static let boxInteractive = "tc-v-box-interactive"
    static let uiTitle = "tc-u-title"
    static let uiSubTitle = "tc-u-sub-title"
    static let uiMinorTitle = "tc-u-minor-title"
    static let uiSmallTitle = "tc-u-small-title"
    static let uiButton = "tc-u-button"
    static let uiSmallButton = "tc-u-small-button"
    static let uiLargeButton = "tc-u-large-button"
    static let uiField = "tc-u-field"
    static let uiFieldLabel = "tc-u-field-label"
    static let uiControl = "tc-u-control"
    static let dateTimePicker = "tc-date-time-picker"
}

enum TCTripBetaTheme {
    private static var isInstalled = false

    static func apply(to view: Div) {
        install()
        view.class(Class(TCTripBetaClass.root))
    }

    static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCTripBetaClass.root)"

        // Keep rule batches intentionally small. Building this entire theme in one
        // RulesContent closure can exhaust the Swift/WASM bridge while Work is
        // being constructed directly from an existing session.
        WebApp.current.addStylesheet {
            Rule(Pointer(root))
                .custom("--tc-beta-ink", "#f7f8fa")
                .custom("--tc-beta-muted", "#99a0aa")
                .custom("--tc-beta-surface", "#1f2326")
                .custom("--tc-beta-surface-raised", "#292e32")
                .custom("--tc-beta-surface-deep", "#141719")
                .custom("--tc-beta-border", "#3a4248")
                .custom("--tc-beta-blue", "#1887c7")
                .custom("--tc-beta-blue-deep", "#172671")
                
                .custom("--tc-beta-orange-light", "#ffa500")
                .custom("--tc-beta-orange", "#ff7704")
                .custom("--tc-beta-orange-hot", "#f6530f")
                .custom("--tc-beta-orange-soft", "#f9be70")
                .custom("color", "var(--tc-beta-ink)")
                .custom("font-family", "Lucida Grande, Lucida Sans Unicode, Arial, sans-serif")

            Rule(Pointer("\(root).\(TCTripBetaClass.popUp)"))
                .position(.fixed)
                .left(0.px)
                .top(0.px)
                .width(100.percent)
                .height(100.percent)
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("padding", "14px")
                .custom("box-sizing", "border-box")
                //.custom("background", "rgba(1, 0, 19, 0.82)")
                //.custom("backdrop-filter", "blur(3px)")
                .zIndex(999999998)

            Rule(Pointer("\(root) .\(TCTripBetaClass.popUpPanel)"))
                .width(100.percent)
                .custom("max-width", "100%")
                .custom("max-height", "calc(100vh - 28px)")
                .custom("box-sizing", "border-box")
                .custom("background", "linear-gradient(145deg, #292e32 0%, #1f2326 72%)")
                .custom("border", "1px solid var(--tc-beta-border)")
                .custom("border-radius", "18px")
                .custom("box-shadow", "0 18px 55px rgba(0, 0, 0, 0.56)")
                .overflow(.hidden)

            Rule(Pointer("\(root) .\(TCTripBetaClass.popUpPanelFitContent)"))
                .custom("height", "auto")

            Rule(Pointer("\(root) .\(TCTripBetaClass.popUpPanelFitContent) .\(TCTripBetaClass.bodyGrid)"))
                .custom("height", "auto")
                .custom("max-height", "calc(100vh - 76px)")

            Rule(Pointer("\(root) .\(TCTripBetaClass.title)"))
                .display(.grid)
                .custom("grid-template-columns", "minmax(0, 1fr) auto auto")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("min-height", "48px")
                .custom("padding", "6px 10px 6px 16px")
                .custom("box-sizing", "border-box")
                .custom("background", "#181c1f")

            Rule(Pointer("\(root) .\(TCTripBetaClass.titleText)"))
                .custom("min-width", "0")
                .custom("overflow", "hidden")
                .custom("text-overflow", "ellipsis")
                .custom("white-space", "nowrap")
                .custom("color", "var(--tc-beta-ink)")
                .custom("font-size", "22px")
                .custom("font-weight", "700")

            Rule(Pointer("\(root) .\(TCTripBetaClass.titleActions)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "flex-end")
                .custom("gap", "6px")
                .custom("min-width", "0")

            Rule(Pointer("\(root) .\(TCTripBetaClass.close)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "34px")
                .custom("height", "34px")
                .custom("border", "0")
                .custom("border-radius", "9px")
                .custom("background", "transparent")
                .custom("color", "var(--tc-beta-orange-hot)")
                .custom("font-size", "42px")
                .custom("line-height", "1")
                .cursor(.pointer)

            Rule(Pointer("\(root) .\(TCTripBetaClass.close):hover"))
                .custom("background", "rgba(246, 83, 15, 0.14)")
                .custom("color", "var(--tc-beta-orange-blue)")

            // Keep title-bar action controls visibly tied to the orange accent.
            // The close icon remains borderless by design.
            Rule(Pointer("\(root) .\(TCTripBetaClass.title) button:not(.\(TCTripBetaClass.close)), \(root) .\(TCTripBetaClass.title) select"))
                .custom("border", "1px solid var(--tc-beta-orange-light) !important")

            Rule(Pointer("\(root) .\(TCTripBetaClass.bodyGrid)"))
                .display(.grid)
                .custom("grid-template-columns", "repeat(12, minmax(0, 1fr))")
                .custom("gap", "12px")
                .custom("align-content", "start")
                .custom("padding", "12px")
                .custom("box-sizing", "border-box")
                .custom("height", "calc(100% - 48px)")
                .overflow(.auto)
        }

        WebApp.current.addStylesheet {
            // VGrid is deliberately layout-only. Do not add card visuals here.
            Rule(Pointer("\(root) .\(TCTripBetaClass.grid)"))
                .position(.relative)
                .width(100.percent)
                .custom("min-width", "0")
                .custom("box-sizing", "border-box")
                .display(.grid)
                .custom("grid-template-columns", "repeat(12, minmax(0, 1fr))")
                .custom("gap", "10px")
                .custom("align-content", "start")

            Rule(Pointer("\(root) .\(TCTripBetaClass.grid) > :not(.\(TCTripBetaClass.grid))"))
                .custom("grid-column", "1 / -1")
                .custom("min-width", "0")

            Rule(Pointer("\(root) .\(TCTripBetaClass.gridFull)"))
                .custom("grid-column", "span 12")

            Rule(Pointer("\(root) .\(TCTripBetaClass.gridOneForth)"))
                .custom("grid-column", "span 3")

            Rule(Pointer("\(root) .\(TCTripBetaClass.gridOneThird)"))
                .custom("grid-column", "span 4")

            Rule(Pointer("\(root) .\(TCTripBetaClass.gridHalf)"))
                .custom("grid-column", "span 6")

            Rule(Pointer("\(root) .\(TCTripBetaClass.gridTwoThirds)"))
                .custom("grid-column", "span 8")

            Rule(Pointer("\(root) .\(TCTripBetaClass.gridThreeForths)"))
                .custom("grid-column", "span 9")

            Rule(Pointer("\(root) .\(TCTripBetaClass.box)"))
                .width(100.percent)
                .custom("height", "auto")
                .custom("grid-column", "1 / -1")
                .custom("box-sizing", "border-box")
                .custom("padding", "14px")
                .custom("overflow", "hidden")
                .custom("background", "var(--tc-beta-surface)")
                // .custom("border", "1px solid var(--tc-beta-border)")
                .custom("border-radius", "13px")
                .custom("color", "var(--tc-beta-ink)")

            Rule(Pointer("\(root) .\(TCTripBetaClass.boxStandard)"))
                .custom("box-shadow", "0 2px 7px rgba(0, 0, 0, 0.28)")

            Rule(Pointer("\(root) .\(TCTripBetaClass.boxRaised)"))
                .custom("background", "var(--tc-beta-surface-raised)")
                .custom("box-shadow", "0 10px 24px rgba(0, 0, 0, 0.42)")

            Rule(Pointer("\(root) .\(TCTripBetaClass.boxInteractive)"))
                .cursor(.pointer)
                .custom("transition", "transform 140ms ease, border-color 140ms ease, background 140ms ease, box-shadow 140ms ease")

            Rule(Pointer("\(root) .\(TCTripBetaClass.boxInteractive):hover"))
                .custom("background", "#272c30")
                .custom("border-color", "var(--tc-beta-blue)")
                .custom("box-shadow", "0 10px 24px rgba(0, 0, 0, 0.42)")
                .custom("transform", "translateY(-1px)")

            Rule(Pointer("\(root) .\(TCTripBetaClass.boxInteractive):focus-visible"))
                .custom("outline", "3px solid rgba(24, 135, 199, 0.7)")
                .custom("outline-offset", "2px")

            Rule(Pointer("\(root) .\(TCTripBetaClass.boxInteractive):active"))
                .custom("transform", "translateY(1px)")
                .custom("box-shadow", "0 3px 10px rgba(0, 0, 0, 0.38)")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCTripBetaClass.uiTitle)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-beta-blue)")
                .custom("font-size", "22px")
                .custom("font-weight", "700")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiSubTitle)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-beta-orange-soft)")
                .custom("font-size", "18px")
                .custom("font-weight", "700")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiMinorTitle)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-beta-muted)")
                .custom("font-size", "15px")
                .custom("font-weight", "600")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiSmallTitle)"))
                .custom("margin", "0")
                .custom("color", "var(--tc-beta-orange)")
                .custom("font-size", "11px")
                .custom("font-weight", "600")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiButton)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("border", "0")
                .custom("border-radius", "9px")
                .custom("background", "#1b1f22")
                .custom("color", "var(--tc-beta-orange-soft)")
                .custom("font-weight", "700")
                .custom("line-height", "1.15")
                .custom("transition", "background 140ms ease, color 140ms ease, transform 140ms ease")
                .cursor(.pointer)

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiButton):hover"))
                .custom("background", "var(--tc-beta-blue)")
                .custom("color", "#101214")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiButton):focus-visible"))
                .custom("outline", "3px solid rgba(24, 135, 199, 0.72)")
                .custom("outline-offset", "2px")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiButton):active"))
                .custom("transform", "translateY(1px)")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiSmallButton)"))
                .custom("min-height", "30px")
                .custom("padding", "6px 10px")
                .custom("font-size", "13px")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiLargeButton)"))
                .custom("min-height", "40px")
                .custom("padding", "9px 16px")
                .custom("font-size", "17px")
        }

        WebApp.current.addStylesheet {
            Rule(Pointer("\(root) .\(TCTripBetaClass.uiField)"))
                .display(.grid)
                .custom("gap", "4px")
                .custom("min-width", "0")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiFieldLabel)"))
                .custom("color", "var(--tc-beta-ink)")
                .custom("font-size", "15px")
                .custom("font-weight", "700")

            Rule(Pointer("\(root) .\(TCTripBetaClass.uiControl), \(root) input, \(root) select, \(root) textarea"))
                .custom("width", "100%")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid #343b41")
                .custom("border-radius", "8px")
                .custom("background", "#171b1f")
                .custom("color", "var(--tc-beta-ink)")
                .custom("padding", "7px 9px")
                .custom("font-size", "15px")

            Rule(Pointer("\(root) input:focus, \(root) select:focus, \(root) textarea:focus"))
                .custom("border-color", "#07202e")
                .custom("outline", "2px solid rgba(255, 119, 4, 0.18)")

            Rule(Pointer("\(root) input::placeholder, \(root) textarea::placeholder"))
                .custom("color", "#747c85")
        }

        WebApp.current.addStylesheet {
            // Re-skin legacy TripController controls while the beta migration is incremental.
            Rule(Pointer("\(root) .uibtn, \(root) .uibtnLarge, \(root) .uibtnLargeOrange"))
                .custom("border-radius", "9px !important")
                .custom("background", "#1b1f22 !important")
                .custom("background-image", "none !important")
                .custom("color", "var(--tc-beta-orange-soft) !important")
                .custom("box-shadow", "none !important")

            Rule(Pointer("\(root) .uibtn:hover, \(root) .uibtnLarge:hover, \(root) .uibtnLargeOrange:hover"))
                .custom("background", "#07202e !important")
                .custom("color", "#ffffff !important")

            Rule(Pointer("\(root) .textFiledBlackDark"))
                .custom("background", "#171b1f !important")
                .custom("border-color", "#343b41 !important")
                .custom("color", "var(--tc-beta-ink) !important")

            Rule(Pointer("\(root) .roundGrayBlackDark, \(root) .roundGray, \(root) .roundBlue"))
                .custom("border-color", "var(--tc-beta-border) !important")

            MediaRule(.screen.maxWidth(760.px)) {
                Rule(Pointer("\(root) .\(TCTripBetaClass.gridOneForth), \(root) .\(TCTripBetaClass.gridOneThird), \(root) .\(TCTripBetaClass.gridHalf), \(root) .\(TCTripBetaClass.gridTwoThirds), \(root) .\(TCTripBetaClass.gridThreeForths)"))
                    .custom("grid-column", "span 12")

                Rule(Pointer("\(root) .\(TCTripBetaClass.title)"))
                    .custom("grid-template-columns", "minmax(0, 1fr) auto")

                Rule(Pointer("\(root) .\(TCTripBetaClass.titleActions)"))
                    .custom("grid-column", "1 / -1")
                    .custom("grid-row", "2")
                    .custom("justify-content", "flex-start")
                    .custom("overflow-x", "auto")
            }
        }
    }
}
