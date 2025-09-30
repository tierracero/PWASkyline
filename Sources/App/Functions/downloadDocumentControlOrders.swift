//
//  downloadDocumentControlOrders.swift
//  
//
//  Created by Victor Cantu on 10/2/22.
//

import Foundation
import JavaScriptKit

func downloadDocumentControlOrders(id: UUID){
    
    let url = baseSkylineAPIUrl(ie: "downloadDocumentControlOrders") +
    "&docid=\(id.uuidString)" +
    "&storeid=\(custCatchStore.uuidString)"
    
    _ = JSObject.global.goToURL!(url)
    
}
