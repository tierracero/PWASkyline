//
//  AppleMapItem.swift
//
//
//  Created by Victor Cantu on 11/7/24.
//

import Foundation


/*
 
 public typealias CustOrder = CustFolio

 extension CustOrder: Hashable, Equatable {
     
 }

 #if canImport(UIKitPlus)
 extension CustOrder: Identable {
     public static var idKey: KeyPath<Self, UUID> { \.id }
 }
 #endif


 */

public struct AppleMap: Codable, Hashable, Equatable {
    
    public struct Coordinate: Codable {
        public let latitude: Double
        public let longitude: Double
    }
    
    public let id: UUID
    
    /**
     "coordinate": {
         "latitude": 23.711401801229428,
         "longitude": -99.186655493232
       },
     */
    public let coordinate: Coordinate
    
    /// Arroyo Carrizal, Luis Echeverria, 87060 Victoria, Tamps., México
    public let formattedAddress: String?
    
    /// cc
    public let name: String
    
    /// Tamaulipas
    public let locality: String
    
    /// 87060
    public let postCode: String
    
//    init(coordinate: Coordinate, formattedAddress: String, name: String, locality: String, postCode: String) {
//        self.coordinate = coordinate
//        self.formattedAddress = formattedAddress
//        self.name = name
//        self.locality = locality
//        self.postCode = postCode
//    }
    
    
    enum CodingKeys: CodingKey {
        case id
        case coordinate
        case formattedAddress
        case name
        case locality
        case postCode
    }
  
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = .init()
        self.coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        self.formattedAddress = try container.decode(String.self, forKey: .formattedAddress)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.locality = try container.decodeIfPresent(String.self, forKey: .locality) ?? ""
        self.postCode = try container.decodeIfPresent(String.self, forKey: .postCode) ?? ""
        
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash (into hasher: inout Hasher) {
        hasher.combine(id)
    }
  
}
