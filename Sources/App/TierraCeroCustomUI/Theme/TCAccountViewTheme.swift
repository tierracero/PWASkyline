//
//  TCAccountViewTheme.swift
//

import Foundation
import Web

private typealias AccountRule = CSSRule

enum TCAccountViewVariant {
    case overview
    case detail

    fileprivate var className: String {
        switch self {
        case .overview:
            return TCAccountViewClass.overview
        case .detail:
            return TCAccountViewClass.detail
        }
    }
}

enum TCAccountViewClass {
    static let root = "tc-account-view-theme"
    static let overview = "tc-account-overview"
    static let detail = "tc-account-detail"
    static let overviewHost = "tc-account-overview-host"
    static let overviewTab = "tc-account-overview-tab"
    static let overviewTabActive = "tc-account-overview-tab-active"
    static let overviewActions = "tc-account-overview-actions"

    static let summary = "tc-account-summary"
    static let summaryBody = "tc-account-summary-body"
    static let content = "tc-account-content"
    static let header = "tc-account-header"
    static let identity = "tc-account-identity"
    static let panel = "tc-account-panel"
    static let panelHeader = "tc-account-panel-header"
    static let financeToolbar = "tc-account-finance-toolbar"

    static let editorShell = "tc-account-editor-shell"
    static let editorFrame = "tc-account-editor-frame"
    static let editorHeader = "tc-account-editor-header"
    static let editorBody = "tc-account-editor-body"
    static let editorActions = "tc-account-editor-actions"
}

/// Scoped translucent presentation for account overview and edit surfaces.
///
/// Account state, bindings, and actions remain owned by the existing views.
/// This layer changes only presentation and preserves the translucent
/// workspace -> shell -> content composition used across Tierra Cero UI.
enum TCAccountViewTheme {
    private static var isInstalled = false

    static func apply(to view: BaseElement, variant: TCAccountViewVariant) {
        install()
        view.class(Class(TCAccountViewClass.root))
        view.class(Class(variant.className))
    }

    private static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCAccountViewClass.root)"
        let overview = "\(root).\(TCAccountViewClass.overview)"
        let detail = "\(root).\(TCAccountViewClass.detail)"
        let detailModalHost = ".transparantBlackBackGround:has(> \(detail))"

        // Keep rule-builder blocks compact. Large RulesContent closures can
        // put avoidable pressure on the Swift/Wasm runtime.
        WebApp.current.addStylesheet {
            AccountRule(Pointer(root))
                .custom("--tc-account-surface", "rgba(6, 24, 42, 0.44)")
                .custom("--tc-account-surface-raised", "rgba(10, 39, 63, 0.52)")
                .custom("--tc-account-surface-deep", "rgba(3, 21, 38, 0.74)")
                .custom("--tc-account-header", "#252c3b")
                .custom("--tc-account-border", "rgba(102, 184, 236, 0.30)")
                .custom("--tc-account-border-soft", "rgba(122, 148, 168, 0.20)")
                .custom("--tc-account-blue", "#49b9f5")
                .custom("--tc-account-orange", "#ff9f0a")
                .custom("--tc-account-ink", "#edf7ff")
                .custom("--tc-account-muted", "#a8bed0")
                .custom("color", "var(--tc-account-ink)")
                .custom("box-sizing", "border-box")

            AccountRule(Pointer("\(root), \(root) *"))
                .custom("box-sizing", "border-box")

            AccountRule(Pointer("\(root) input, \(root) select, \(root) textarea"))
                .custom("background", "rgba(2, 16, 29, 0.74) !important")
                .custom("border", "1px solid rgba(36, 90, 124, 0.92) !important")
                .custom("color", "var(--tc-account-ink) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.03)")

            AccountRule(Pointer("\(root) input:focus, \(root) select:focus, \(root) textarea:focus"))
                .custom("border-color", "rgba(73, 185, 245, 0.78) !important")
                .custom("box-shadow", "0 0 0 3px rgba(73, 185, 245, 0.13) !important")

            AccountRule(Pointer("\(root) .uibtn, \(root) .uibtnLarge, \(root) .uibtnLargeOrange"))
                .custom("border", "1px solid rgba(94, 173, 220, 0.34) !important")
                .custom("border-radius", "8px !important")
                .custom("background", "linear-gradient(135deg, rgba(11, 53, 83, 0.80), rgba(5, 27, 46, 0.74)) !important")
                .custom("color", "var(--tc-account-ink) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.05), 0 8px 20px rgba(0, 0, 0, 0.18)")

            AccountRule(Pointer("\(root) .uibtn:hover, \(root) .uibtnLarge:hover, \(root) .uibtnLargeOrange:hover"))
                .custom("border-color", "rgba(73, 185, 245, 0.70) !important")
                .custom("box-shadow", "0 12px 28px rgba(0, 0, 0, 0.26), 0 0 20px rgba(73, 185, 245, 0.10)")
        }

        WebApp.current.addStylesheet {
            AccountRule(Pointer(overview))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("min-height", "100dvh")
                .custom("margin", "0 !important")
                .custom("padding", "4px")
                .custom("background", "rgba(3, 17, 29, 0.72) !important")
                .custom("backdrop-filter", "blur(8px) saturate(108%)")
                .custom("-webkit-backdrop-filter", "blur(8px) saturate(108%)")
                .custom("color", "var(--tc-account-ink)")
                .custom("overflow", "hidden")

            AccountRule(Pointer("\(overview) > .\(TCAccountViewClass.summary), \(overview) > .\(TCAccountViewClass.content)"))
                .custom("height", "100% !important")
                .custom("border", "1px solid rgba(122, 148, 168, 0.18)")
                .custom("border-radius", "8px")
                .custom("background", "rgba(7, 27, 45, 0.48) !important")
                .custom("box-shadow", "none")

            AccountRule(Pointer("\(overview) > .\(TCAccountViewClass.summary)"))
                .custom("width", "calc(33% - 3px) !important")
                .custom("margin-right", "6px")

            AccountRule(Pointer("\(overview) > .\(TCAccountViewClass.content)"))
                .custom("width", "calc(67% - 3px) !important")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.summaryBody)"))
                .custom("padding", "6px")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.header)"))
                .custom("min-height", "36px")
                .custom("padding", "6px 9px")
                .custom("margin-bottom", "6px")
                .custom("border-bottom", "1px solid rgba(73, 185, 245, 0.28)")
                .custom("border-radius", "6px")
                .custom("background", "rgba(37, 44, 59, 0.72) !important")
                .custom("box-shadow", "none")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.header) h2"))
                .custom("margin", "0 !important")
                .custom("color", "var(--tc-account-blue) !important")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.identity)"))
                .custom("padding", "6px 9px")
                .custom("margin-bottom", "6px")
                .custom("border-left", "2px solid var(--tc-account-blue)")
                .custom("border-radius", "5px")
                .custom("background", "rgba(10, 39, 63, 0.42)")
        }

        WebApp.current.addStylesheet {
            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.panel)"))
                .custom("padding", "5px !important")
                .custom("border", "1px solid var(--tc-account-border-soft)")
                .custom("border-radius", "7px")
                .custom("background", "rgba(6, 24, 42, 0.34) !important")
                .custom("box-shadow", "none")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.panelHeader)"))
                .custom("min-height", "30px")
                .custom("padding", "4px 7px")
                .custom("margin-bottom", "6px")
                .custom("border-radius", "5px")
                .custom("background", "rgba(37, 44, 59, 0.68) !important")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.panelHeader) h3"))
                .custom("margin", "0 !important")
                .custom("color", "var(--tc-account-blue) !important")

            AccountRule(Pointer("\(overview) .\(TCAccountViewClass.financeToolbar)"))
                .custom("min-height", "34px")
                .custom("height", "auto !important")
                .custom("padding", "4px 6px")
                .custom("margin", "5px 3px 6px")
                .custom("border-radius", "5px")
                .custom("background", "rgba(37, 44, 59, 0.68)")

            AccountRule(Pointer("\(overview) .roundDarkBlue, \(overview) .roundGrayBlackDark, \(overview) .roundGrayBlack"))
                .custom("border", "1px solid var(--tc-account-border-soft) !important")
                .custom("background", "rgba(3, 21, 38, 0.52) !important")
                .custom("box-shadow", "none")

            AccountRule(Pointer("\(overview) label"))
                .custom("color", "var(--tc-account-muted)")

            AccountRule(Pointer("\(overview) h2, \(overview) h3"))
                .custom("letter-spacing", "0.1px")
        }

        WebApp.current.addStylesheet {
            AccountRule(Pointer(detailModalHost))
                .custom("background", "rgba(1, 8, 17, 0.18) !important")
                .custom("backdrop-filter", "blur(8px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(8px) saturate(120%)")

            AccountRule(Pointer(detail))
                .custom("background", "rgba(1, 8, 17, 0.18) !important")
                .custom("backdrop-filter", "blur(8px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(8px) saturate(120%)")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorShell)"))
                .custom("left", "50% !important")
                .custom("top", "50% !important")
                .custom("transform", "translate(-50%, -50%)")
                .custom("width", "min(1200px, calc(100% - 40px)) !important")
                .custom("height", "min(700px, calc(100% - 40px)) !important")
                .custom("padding", "0")
                .custom("border", "1px solid var(--tc-account-border)")
                .custom("border-radius", "18px !important")
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 57, 0.62), rgba(3, 17, 32, 0.38)) !important")
                .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.56), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(22px) saturate(132%)")
                .custom("-webkit-backdrop-filter", "blur(22px) saturate(132%)")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorFrame)"))
                .custom("height", "calc(100% - 20px) !important")
                .custom("margin", "10px !important")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorHeader)"))
                .custom("min-height", "44px")
                .custom("padding", "8px 12px")
                .custom("margin-bottom", "12px")
                .custom("border", "1px solid var(--tc-account-border)")
                .custom("border-radius", "10px")
                .custom("background", "var(--tc-account-header) !important")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorHeader) h2"))
                .custom("height", "auto !important")
                .custom("margin", "0 !important")
                .custom("color", "var(--tc-account-blue) !important")
        }

        WebApp.current.addStylesheet {
            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorBody)"))
                .custom("height", "calc(100% - 112px) !important")
                .custom("padding", "10px")
                .custom("border", "1px solid var(--tc-account-border-soft) !important")
                .custom("border-radius", "12px !important")
                .custom("background", "var(--tc-account-surface) !important")
                .custom("color", "var(--tc-account-muted) !important")
                .custom("backdrop-filter", "blur(12px)")
                .custom("-webkit-backdrop-filter", "blur(12px)")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorBody) h3"))
                .custom("padding", "7px 10px")
                .custom("margin", "8px 0 12px !important")
                .custom("border-left", "3px solid var(--tc-account-blue)")
                .custom("border-radius", "7px")
                .custom("background", "rgba(21, 23, 25, 0.72)")
                .custom("color", "var(--tc-account-blue) !important")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorBody) label"))
                .custom("color", "var(--tc-account-ink)")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorActions)"))
                .custom("min-height", "48px")
                .custom("padding", "8px 0 0")

            AccountRule(Pointer("\(detail) .\(TCAccountViewClass.editorActions) .uibtnLargeOrange"))
                .custom("min-height", "38px")
                .custom("padding", "8px 18px")
                .custom("border-color", "rgba(73, 185, 245, 0.50) !important")
                .custom("background", "linear-gradient(135deg, rgba(18, 100, 156, 0.92), rgba(7, 50, 86, 0.90)) !important")
        }
    }
}
