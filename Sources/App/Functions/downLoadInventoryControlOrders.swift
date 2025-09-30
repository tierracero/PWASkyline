//
//  downLoadInventoryControlOrders.swift
//  
//
//  Created by Victor Cantu on 4/29/23.
//

import Foundation
import JavaScriptKit

func downLoadInventoryControlOrders(id: UUID, detailed: Bool){
    
    let url = baseSkylineAPIUrl(ie: "downLoadInventoryControlOrders") +
    "&docid=\(id.uuidString)" +
    "&storeid=\(custCatchStore.uuidString)" +
    "&detailed=\(detailed.description)"

    _ = JSObject.global.goToURL!(url)
    
}
