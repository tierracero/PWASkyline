import TCFundamentals
import Web

extension CustStoreRef: ConvertibleToJSValue {
    
    public var jsValue: JavaScriptKit.JSValue {
        
        var result: [String: ConvertibleToJSValue] = [:]
        
        result["id"] = self.id.uuidString.jsValue
        
        result["name"] = self.name.jsValue

        if let lat = self.lat {
            result["lat"] = lat.jsValue
        }

        if let lon = self.lon {
            result["lon"] = lon.jsValue
        }
    
        return result.jsValue
        
    }
    
}