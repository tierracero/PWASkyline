//
//  UTitles.swift
//

import Foundation
import Web

public final class UTitle: Div {
    public override class var name: String { "div" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiTitle))
    }
}

public final class USubTitle: Div {
    public override class var name: String { "div" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiSubTitle))
    }
}

public final class UMinorTitle: Div {
    public override class var name: String { "div" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiMinorTitle))
    }
}

public final class USmallTitle: Div {
    public override class var name: String { "div" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiSmallTitle))
    }
}
