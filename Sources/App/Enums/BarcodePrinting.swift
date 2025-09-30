//
//  BarcodePrinting.swift
//  
//
//  Created by Victor Cantu on 11/23/22.
//

import Foundation

public struct BarcodePrinting: Codable {
    
    public let id: UUID
    
    public let upc: String
    
    public let brand: String
    
    public let model: String
    
    public let name: String
    
    public let price: Int64
    
    public init(
        id: UUID,
        upc: String,
        brand: String,
        model: String,
        name: String,
        price: Int64
    ){
        self.id = id
        self.upc = upc
        self.brand = brand
        self.model = model
        self.name = name
        self.price = price
    }
    
}
