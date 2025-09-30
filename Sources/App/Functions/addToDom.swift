//
//  addToDom.swift
//  
//
//  Created by Victor Cantu on 9/25/22.
//

import Foundation
import Web

func addToDom(_ view: DOMElement) {
    WebApp.shared.document.body.appendChild(view)
    // WebApp.shared.window.document.body.appendChild(view)
    // WebApp.shared.window.document.appendChild(view)
}
