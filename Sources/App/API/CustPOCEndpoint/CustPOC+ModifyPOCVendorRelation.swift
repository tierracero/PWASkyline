//
//  CustPOC+ModifyPOCVendorRelation.swift
//  
//
//  Created by Victor Cantu on 9/8/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func modifyPOCVendorRelation(
        add: Bool,
        pocid: UUID?,
        itemid: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "modifyPOCVendorRelation",
            ModifyPOCVendorRelationRequst(
                add: add,
                pocid: pocid,
                itemid: itemid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
