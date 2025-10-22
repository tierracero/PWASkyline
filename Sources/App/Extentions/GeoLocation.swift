//
//  File.swift
//  TCFireSignalWebSW
//
//  Created by Victor Cantu on 10/21/25.
//

import Foundation
import TCFundamentals
import Web
/*
extension GeoLocation: ConvertibleToJSValue {
    
    public var jsValue: JavaScriptKit.JSValue {
        
        var value: Dictionary<String, JavaScriptKit.JSValue> = [:]
        
        value["latitud"] = self.latitud.jsValue
        
        value["longitud"] = self.longitud.jsValue
        
        return value.jsValue
        
    }
    
}
*/
extension GeoLocation: ConvertibleToJSValue {
    
    public var jsValue: JavaScriptKit.JSValue {
        
        var result: [String: ConvertibleToJSValue] = [:]
        
        result["latitud"] = self.latitud.jsValue
        
        result["longitud"] = self.longitud.jsValue
        
        return result.jsValue
        
    }
    
}
