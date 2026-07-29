//
//  TCMessageObjectTheme.swift
//

import Foundation
import Web

enum TCMessageObjectClass {
    static let root = "tc-message-object"
    static let dark = "tc-message-object-dark"
    static let customer = "tc-message-object-customer"
    static let user = "tc-message-object-user"
    static let general = "tc-message-object-general"
    static let meta = "tc-message-object-meta"
    static let bubble = "tc-message-object-bubble"
    static let media = "tc-message-object-media"
    static let avatar = "tc-message-object-avatar"
    static let actions = "tc-message-object-actions"
    static let highPriority = "tc-message-object-high-priority"
}

/// Scoped dark-crystal presentation for an individual order message.
///
/// MessageObject retains ownership of message direction, media, reactions,
/// delivery status, and actions. This theme only replaces its dark-mode
/// presentation.
enum TCMessageObjectTheme {
    private static var isInstalled = false

    static func apply(to view: Div) {
        install()
        view.class(Class(TCMessageObjectClass.root))
    }

    private static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCMessageObjectClass.root).\(TCMessageObjectClass.dark)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("--tc-message-ink", "#edf7ff")
                .custom("--tc-message-muted", "#9fb5c7")
                .custom("--tc-message-border", "rgba(102, 184, 236, 0.28)")
                .custom("width", "100%")
                .custom("padding", "5px 8px")
                .custom("box-sizing", "border-box")
                .custom("background", "transparent !important")
                .custom("color", "var(--tc-message-ink)")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.meta)"))
                .custom("color", "var(--tc-message-muted) !important")
                .custom("font-size", "12px !important")
                .custom("line-height", "1.25")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.meta) strong"))
                .custom("color", "var(--tc-message-ink) !important")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.bubble)"))
                .custom("box-sizing", "border-box")
                .custom("padding", "9px 12px !important")
                .custom("border", "1px solid var(--tc-message-border) !important")
                .custom("border-radius", "14px !important")
                .custom("color", "var(--tc-message-ink) !important")
                .custom("font-size", "15px !important")
                .custom("line-height", "1.35")
                .custom("box-shadow", "0 8px 20px rgba(0, 0, 0, 0.18), inset 0 1px 0 rgba(255, 255, 255, 0.035)")
                .custom("backdrop-filter", "blur(10px) saturate(122%)")
                .custom("-webkit-backdrop-filter", "blur(10px) saturate(122%)")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.customer) .\(TCMessageObjectClass.bubble)"))
                .custom("border-left", "3px solid rgba(73, 185, 245, 0.78) !important")
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 57, 0.72), rgba(3, 17, 32, 0.62)) !important")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.user) .\(TCMessageObjectClass.bubble)"))
                .custom("border-right", "3px solid rgba(73, 185, 245, 0.86) !important")
                .custom("background", "linear-gradient(145deg, rgba(13, 63, 96, 0.76), rgba(5, 31, 52, 0.68)) !important")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.general) .\(TCMessageObjectClass.bubble)"))
                .custom("border-left", "3px solid #252c3b !important")
                .custom("background", "rgba(8, 30, 48, 0.58) !important")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.media)"))
                .custom("overflow", "hidden")
                .custom("background", "rgba(3, 21, 38, 0.72) !important")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.media) img, \(root) .\(TCMessageObjectClass.media) video"))
                .custom("max-width", "100%")
                .custom("border-radius", "9px")
                .custom("object-fit", "contain")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.avatar)"))
                .custom("border", "1px solid rgba(102, 184, 236, 0.42) !important")
                .custom("background", "#252c3b !important")
                .custom("box-shadow", "0 4px 12px rgba(0, 0, 0, 0.28)")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.highPriority)"))
                .custom("border-color", "rgba(255, 102, 82, 0.5) !important")
                .custom("border-left", "4px solid #ff6652 !important")
                .custom("background", "linear-gradient(145deg, rgba(72, 26, 31, 0.7), rgba(25, 17, 27, 0.64)) !important")
                .custom("color", "#ffb1a5 !important")
                .custom("font-size", "18px !important")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.actions)"))
                .custom("padding", "4px 35px 0")

            CSSRule(Pointer("\(root) .\(TCMessageObjectClass.actions) .uibtn"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("min-height", "30px")
                .custom("padding", "5px 10px")
                .custom("border", "1px solid rgba(245, 160, 64, 0.32) !important")
                .custom("border-radius", "8px !important")
                .custom("background", "rgba(83, 48, 18, 0.38) !important")
                .custom("color", "#f5b05b !important")
                .custom("font-size", "13px")
                .custom("box-shadow", "none !important")

            CSSRule(Pointer("\(root) audio"))
                .custom("max-width", "100%")
                .custom("height", "34px")
        }
    }
}
