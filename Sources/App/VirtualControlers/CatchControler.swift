//
//  CatchControler.swift
//
//
//  Created by Victor Cantu on 10/25/24.
//

import Foundation
import TCFundamentals
//@State

private var _shared: CatchControler?

public final class CatchControler {

    public static var shared: CatchControler {
        guard let shared = _shared else {
            let shared = CatchControler()
            _shared = shared
            return shared
        }
        return shared
    }
    
    /// [ Country : [ State : [PostalCodesMexico] ]]
    public var cityRefrence: [Countries: [ String : [PostalCodesMexicoItem] ]] = [:]
    
    func setCityRefrence( country: Countries, state: String, cities: [PostalCodesMexicoItem]) {
        
        if let _ = cityRefrence[country] {
            
            cityRefrence[country]?[state] = cities
            
        }
        else {
            cityRefrence[country] = [state: cities]
        }
        
    }
    
    
    /// [ Country : [ State : City:   [PostalCodesMexico]  ]]
    public var settelmentRefrence: [Countries: [ String: [ String : [PostalCodesMexicoItem] ] ] ] = [:]
    
    func setSettelmentRefrence( country: Countries, state: String, city: String, settlements: [PostalCodesMexicoItem]) {
        
        if let _ = settelmentRefrence[country] {
            
            if let _ = settelmentRefrence[country]?[state] {
                
                settelmentRefrence[country]?[state]?[city] = settlements
                
            }
            else {
                
                settelmentRefrence[country]?[state] = [ city: settlements ]
                
            }
            
        }
        else {
            
            settelmentRefrence[country] = [ state: [ city: settlements ]]
            
        }
    }
}
