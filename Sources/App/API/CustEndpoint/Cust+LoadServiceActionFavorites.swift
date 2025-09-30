//
//  Cust+LoadServiceActionFavorites.swift
//  
//
//  Created by Victor Cantu on 4/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func loadServiceActionFavorites(
        type: SaleActionType,
        currentIDs: [UUID],
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadServiceActionFavoritesResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadServiceActionFavorites",
            LoadServiceActionFavoritesRequest(
                type: type,
                currentIDs: currentIDs
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadServiceActionFavoritesResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

