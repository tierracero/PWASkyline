//
//  getParentId.swift
//  
//
//  Created by Victor Cantu on 1/5/23.
//

import Foundation
import Web

func getParentId(childid: String) -> String {
    var value: String = ""
    print("childid \(childid)")
    if let _value = JSObject.global.getParentId!(childid).string {
        value = _value
    }
    return value
}
