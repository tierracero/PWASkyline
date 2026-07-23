//
//  VBodyGrid.swift
//

import Foundation
import Web

/// The 12-column content area used inside `VPopUp`.
public final class VBodyGrid: Div {
    public override class var name: String { "div" }

    public init(@DOM content: @escaping DOM.Block) {
        super.init()
        configure()
        parseDOMItem(content().domContentItem)
    }

    public required init() {
        super.init()
        configure()
    }

    private func configure() {
        self.class(Class(TCTripBetaClass.bodyGrid))
    }
}
