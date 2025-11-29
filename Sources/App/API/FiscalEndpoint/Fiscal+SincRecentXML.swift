//
//  Fiscal+SincRecentXML.swift
//  
//
//  Created by Victor Cantu on 2/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func sincRecentXML(
        callback: @escaping ( (_ resp: APIResponseGeneric<SincRecentXMLResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "sincRecentXML",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<SincRecentXMLResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
