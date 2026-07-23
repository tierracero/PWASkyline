//
//  VBox.swift
//

import Foundation
import Web

public enum VBoxStyle {
    case standard
    case raised
    case interactive
}

/// A visible Tierra Cero surface/card.
public final class VBox: Div {
    public override class var name: String { "div" }

    public let style: VBoxStyle

    public init(
        _ style: VBoxStyle = .standard,
        @DOM content: @escaping DOM.Block
    ) {
        self.style = style
        super.init()
        configure()
        parseDOMItem(content().domContentItem)
    }

    public required init() {
        self.style = .standard
        super.init()
        configure()
    }

    private func configure() {
        self.class(Class(TCTripBetaClass.box))
        self.class(Class(style.cssClass))

        if style == .interactive {
            tabIndex(0)
            attribute("role", "button")
        }
    }
}

private extension VBoxStyle {
    var cssClass: String {
        switch self {
        case .standard:
            return TCTripBetaClass.boxStandard
        case .raised:
            return TCTripBetaClass.boxRaised
        case .interactive:
            return TCTripBetaClass.boxInteractive
        }
    }
}
