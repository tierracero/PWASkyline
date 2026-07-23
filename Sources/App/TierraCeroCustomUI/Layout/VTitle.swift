//
//  VTitle.swift
//

import Foundation
import Web

/// Popup title bar with an action area and a consistent close control.
public final class VTitle: Div {
    public override class var name: String { "div" }

    private let titleView = Div()
    private let actionsView = Div()
    private let closeButton = Button("×")
    private var onClose: () -> Void = {}

    public init<U>(
        _ title: U,
        @DOM actions: @escaping DOM.Block,
        onClose: @escaping () -> Void
    ) where U: UniValue, U.UniValue == String {
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
        titleView
        actionsView
        closeButton
    }

    private func configure() {
        self.class(Class(TCTripBetaClass.title))
        titleView.class(Class(TCTripBetaClass.titleText))
        actionsView.class(Class(TCTripBetaClass.titleActions))
        closeButton
            .class(Class(TCTripBetaClass.close))
            .attribute("aria-label", "Cerrar")
            .onClick {
                self.onClose()
            }
    }
}
