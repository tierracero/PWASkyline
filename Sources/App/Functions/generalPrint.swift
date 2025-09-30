//
//  generalPrint.swift
//
//
//  Created by Victor Cantu on 1/11/24.
//

import Foundation
import Web

func generalPrint(body: String) {
    _ = JSObject.global.generalPrint!(body)
}
