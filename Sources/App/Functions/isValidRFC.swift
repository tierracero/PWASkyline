//
//  isValidRFC.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import JavaScriptKit
import Web

func isValidRFC(_ rfc: String) -> Bool {
    
    var isValid = false
    
    if let test = JSObject.global.isValidRFC!(rfc).boolean {
        isValid = test
    }
    
    return isValid
}
