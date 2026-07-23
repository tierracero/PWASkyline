//
//  VPopUp.swift
//

import Foundation
import Web

public enum VPopUpSize {
    case compact
    case semiFull
    case full
    case fitContent(w: Int)
    case custome(w: Int, h: Int)
}

/// Scoped popup overlay and panel used by the TripController beta UI.
public final class VPopUp: Div {
    public override class var name: String { "div" }

    public let size: VPopUpSize
    private let panel = Div()

    public init(
        _ size: VPopUpSize = .semiFull,
        @DOM content: @escaping DOM.Block
    ) {
        self.size = size
        super.init()
        panel.parseDOMItem(content().domContentItem)
        configure()
    }

    public required init() {
        self.size = .semiFull
        super.init()
        configure()
    }

    @DOM public override var body: DOM.Content {
        panel
    }

    public override func buildUI() {
        super.buildUI()
        TCTripBetaTheme.apply(to: self)
    }

    private func configure() {
        self.class(Class(TCTripBetaClass.popUp))
        panel.class(Class(TCTripBetaClass.popUpPanel))

        switch size {
        case .compact:
            panel
                .maxWidth(560.px)
                .custom("height", "min(620px, calc(100vh - 28px))")
        case .semiFull:
            panel
                .custom("width", "min(1180px, calc(100vw - 28px))")
                .custom("height", "min(820px, calc(100vh - 28px))")
        case .full:
            panel
                .custom("width", "calc(100vw - 28px)")
                .custom("height", "calc(100vh - 28px)")
        case .fitContent(let width):
            panel
                .class(Class(TCTripBetaClass.popUpPanelFitContent))
                .custom("width", "min(\(width)px, calc(100vw - 28px))")
        case .custome(let width, let height):
            panel
                .custom("width", "min(\(width)px, calc(100vw - 28px))")
                .custom("height", "min(\(height)px, calc(100vh - 28px))")
        }
    }
}
