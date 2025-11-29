//
//  Cust+CreateSection.swift
//  
//
//  Created by Victor Cantu on 12/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func createSection(
        storeId: UUID,
        bodegaId: UUID,
        name: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreSeccionesSinc>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createSection",
            CreateSectionRequest(
                storeId: storeId,
                bodegaId: bodegaId,
                name: name,
                description: description
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustStoreSeccionesSinc>?.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

