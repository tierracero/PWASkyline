//
//  CustomEvent.swift
//
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import Web

public class CustomEvent: Event {

    /// Returns how much work has been loaded
    public let detail: String

    required init (_ event: JSValue) {
        detail = event.detail.string ?? ""
        super.init(event)
    }
}
