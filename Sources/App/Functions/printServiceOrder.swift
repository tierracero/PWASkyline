//
//  printServiceOrder.swift
//  
//
//  Created by Victor Cantu on 8/24/22.
//

import Foundation

func printServiceOrder(orderid: UUID) -> String{
    
    return baseSkylineAPIUrl(ie: "printServiceOrder") +
    "&orderid=\(orderid.uuidString)" +
    "&send=false"
    
}
