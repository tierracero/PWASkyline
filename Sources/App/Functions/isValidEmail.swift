//
//  isValidEmail.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import JavaScriptKit
import Web

func isValidEmail(_ email: String) -> Bool {
    
    var isValid = false
    
    if email.contains("@"){
        return false
    }
    
    if let test = JSObject.global.isValidEmail!(email).boolean {
        isValid = test
    }
    
    return isValid
        
}
