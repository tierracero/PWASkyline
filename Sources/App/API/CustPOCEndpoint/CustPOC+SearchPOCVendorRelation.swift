//
//  CustPOC+SearchPOCVendorRelation.swift
//  
//
//  Created by Victor Cantu on 9/7/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func searchPOCVendorRelation(
        poc: UUID,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<SearchPOCVendorRelationResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "searchPOCVendorRelation",
            SearchPOCVendorRelationRequest(
                poc: poc,
                name: name
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<SearchPOCVendorRelationResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

