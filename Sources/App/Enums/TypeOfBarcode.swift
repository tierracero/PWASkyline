//
//  TypeOfBarcode.swift
//  
//
//  Created by Victor Cantu on 11/23/22.
//

import Foundation


public enum TypeOfBarcode: String, CaseIterable {
    
    /// Only Barcode
    case onlyBarcode
    
    /// Basic text with price an barcode
    case smallRectangled
    
    ///  Bigger font
    case rectangled
    
    /// Full data semi-squerd
    case semiSquered
    
    /// Full data
    case longRectangled
    
    var description: String {
        switch self {
        case .onlyBarcode:
            return "Rectangular - Solo CdB"
        case .smallRectangled:
            return "Rectangular - CdB y datos min."
        case .rectangled:
            return "Semi Rectangular - CdB y datos"
        case .semiSquered:
            return "Semi Cuadrado - CdB, Logo y datos"
        case .longRectangled:
            return "Rectangular - CdB, Logo y datos"
        }
    }
    
}
