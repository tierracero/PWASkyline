//
//  dragElement.swift
//  
//
//  Created by Victor Cantu on 8/9/22.
//

import Foundation
import JavaScriptKit
import Web

func dragElement(_ elementID: String) {
    _ = JSObject.global.dragElement!(elementID)
}
