//
//  isValidPhone.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import JavaScriptKit
import Web

func isValidPhone(_ mobile: String) -> (isValid: Bool, reason: String) {
    
    if mobile.isEmpty {
        return (false, "Incuya telefono a validar")
    }
    
    guard let _ = Int64(mobile) else {
        return (false, "Incuya un telefono valido")
    }
    
    if mobile.count != 10 {
        return (false, "El telefono debe de ser a 10 digitos")
    }
    
    return (true, "")
}
