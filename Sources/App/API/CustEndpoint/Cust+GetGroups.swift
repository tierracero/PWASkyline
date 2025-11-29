//
//  Cust+GetGroups.swift
//
//
//  Created by Victor Cantu on 6/28/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getGroups(
        storeId: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustPageContentQuick]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getGroups",
            GetGroupsRequest(
                storeId: storeId
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<[CustPageContentQuick]>.self, from: data))
            }
            catch {
                
                callback(nil)
            }
            
        }
    }
}



