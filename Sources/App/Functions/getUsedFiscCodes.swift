//
//  getUsedFiscCodes.swift
//
//
//  Created by Victor Cantu on 7/11/22.
//

import Foundation
import TCFundamentals

func getUsedFiscCodes(type: ChargeType, callback: @escaping (_ success: Bool) -> ()){
    
    switch type {
    case .service:
        if serviceUsedFiscCodesIsLoaded {
            callback(true)
        }
    case .product:
        if productUsedFiscCodesIsLoaded {
            callback(true)
        }
    case .manual:
        if manualUsedFiscCodesIsLoaded {
            callback(true)
        }
    case .rental:
        if rentalUsedFiscCodesIsLoaded {
            callback(true)
        }
    }
    
    loadingView(show: true)
    
    API.custAPIV1.getUsedFiscCode(type: type) { codes in
        
        API.custAPIV1.getUsedFiscUnit(type: type) { units in
            
            loadingView(show: false)
            
            guard let codes = codes else {
                showError(.comunicationError, "Error al obtener codigos de productos fiscales")
                return
            }
            
            guard let units = units else {
                showError(.comunicationError, "Error al obtener codigos de unidades fiscales")
                return
            }
            
            
            do{
                
                print("⭐️ productos fiscales ")
                
                let data = try JSONEncoder().encode(codes)
                print(String(data: data, encoding: .utf8)!)
                
            }
            catch{ }
            
            
            
            do{
                
                print("⭐️ unidades fiscales ")
                
                let data = try JSONEncoder().encode(units)
                print(String(data: data, encoding: .utf8)!)
                
            }
            catch{ }
            
            
            
            codes.forEach { code in
                fiscCodeRefrence[code.c] = code.v
            }
            
            units.forEach { code in
                fiscUnitRefrence[code.c] = code.v
            }
            
            switch type {
            case .service:
                serviceUsedFiscCodesIsLoaded = true
                serviceUsedFiscCode = codes
                serviceUsedFiscUnit = units
                callback(true)
            case .product:
                productUsedFiscCodesIsLoaded = true
                productUsedFiscCode = codes
                productUsedFiscUnit = units
                callback(true)
            case .manual:
                manualUsedFiscCodesIsLoaded = true
                manualUsedFiscCode = codes
                manualUsedFiscUnit = units
                callback(true)
            case .rental:
                rentalUsedFiscCodesIsLoaded = true
                rentalUsedFiscCode = codes
                rentalUsedFiscUnit = units
                callback(true)
            }
            
        }
    }
}
