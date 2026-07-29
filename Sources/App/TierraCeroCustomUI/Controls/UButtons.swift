//
//  UButtons.swift
//

import Foundation
import Web

public final class USmallButton: Button {

    public override class var name: String { "button" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiButton))
        self.class(Class(TCTripBetaClass.uiSmallButton))
    }
}

public final class ULargeButton: Button {

    public override class var name: String { "button" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiButton))
        self.class(Class(TCTripBetaClass.uiLargeButton))
    }
}
