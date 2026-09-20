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
                    .attribute("aria-hidden", "true")
                    .custom("flex", "0 0 auto")
                    .class(.iconBlue)
                    .height(24.px)
                    .src(source)
            )
        }

        titleContentView.appendChild(titleView)
        titleContentView
            .custom("align-items", "center")
            .custom("min-width", "0")
            .custom("gap", "8px")
            .display(.flex)

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
