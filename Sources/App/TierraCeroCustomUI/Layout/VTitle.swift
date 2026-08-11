//
//  VTitle.swift
//

import Foundation
import Web

/// Popup title bar with an action area and a consistent close control.
public final class VTitle: Div {
    public override class var name: String { "div" }

    private let titleContentView = Div()
    private let titleView = Div()
    private let actionsView = Div()
    private let closeButton = Button("×")
    private var icon: String? = nil
    private var onClose: (() -> Void)?

    public init<U>(
        _ title: U,
        icon: String? = nil,
        @DOM actions: @escaping DOM.Block,
        onClose: (() -> Void)? = nil
    ) where U: UniValue, U.UniValue == String {
        self.icon = icon
        self.onClose = onClose
        super.init()

        _ = titleView.innerText(title)
        actionsView.parseDOMItem(actions().domContentItem)
        configure()
    }

    public required init() {
        super.init()
        configure()
    }

    @DOM public override var body: DOM.Content {
        titleContentView
        actionsView
        if let _ = onClose {
            closeButton
        }

    }

    private func configure() {
        self.class(Class(TCTripBetaClass.title))

        if let icon {
            let source = icon.hasPrefix("/") ? icon : "/skyline/media/\(icon)"

            titleContentView.appendChild(
                Img()
                    .src(source)
                    .class(.iconBlue)
                    .height(24.px)
                    .custom("flex", "0 0 auto")
                    .attribute("aria-hidden", "true")
            )
        }

        titleContentView.appendChild(titleView)
        titleContentView
            .display(.flex)
            .custom("align-items", "center")
            .custom("gap", "8px")
            .custom("min-width", "0")

        titleView.class(Class(TCTripBetaClass.titleText))
        actionsView.class(Class(TCTripBetaClass.titleActions))
        closeButton
            .class(Class(TCTripBetaClass.close))
            .attribute("aria-label", "Cerrar")
            .onClick {
                self.onClose?()
            }
    }
}
