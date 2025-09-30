//
//  downloadManualInventoryControlOrders.swift
//  
//
//  Created by Victor Cantu on 11/23/22.
//

import Foundation
import JavaScriptKit

func downloadManualInventoryControlOrders(id: UUID, detailed: Bool){
    
    let _token = (custCatchToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _user = (custCatchUser.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _key = (custCatchKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let url = baseSkylineAPIUrl(ie: "downLoadManualInventoryControlOrders") +
    "&docid=\(id.uuidString)" +
    "&storeid=\(custCatchStore.uuidString)" +
    "&detailed=\(detailed.description)"
    
    _ = JSObject.global.goToURL!(url)
    
}
