//
//  VGrid.swift
//

import Foundation
import Web

public enum VGridSize {
    case full
    case oneForth
    case oneThird
    case half
    case twoThirds
    case threeForths
}

/// A transparent, layout-only 12-column grid.
///
/// `VGrid` never supplies a surface, border, radius, shadow, or card padding.
public final class VGrid: Div {
    public override class var name: String { "div" }

    public let size: VGridSize

    public init(
        _ size: VGridSize = .full,
        @DOM content: @escaping DOM.Block
    ) {
        self.size = size
        super.init()
        configure()
        parseDOMItem(content().domContentItem)
    }

    public required init() {
        self.size = .full
        super.init()
        configure()
    }

    private func configure() {
        self.class(Class(TCTripBetaClass.grid))
        self.class(Class(size.cssClass))
    }
}

private extension VGridSize {
    var cssClass: String {
        switch self {
        case .full:
            return TCTripBetaClass.gridFull
        case .oneForth:
            return TCTripBetaClass.gridOneForth
        case .oneThird:
            return TCTripBetaClass.gridOneThird
        case .half:
            return TCTripBetaClass.gridHalf
        case .twoThirds:
            return TCTripBetaClass.gridTwoThirds
        case .threeForths:
            return TCTripBetaClass.gridThreeForths
        }
    }
}
