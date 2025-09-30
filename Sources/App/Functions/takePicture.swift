//
//  takePicture.swift
//  
//
//  Created by Victor Cantu on 1/20/23.
//

import Foundation
import Web

public func takePicture() -> String {
    var value: String = ""
    if let _value = JSObject.global.takePicture!().string {
        value = _value
    }
    return value
}
