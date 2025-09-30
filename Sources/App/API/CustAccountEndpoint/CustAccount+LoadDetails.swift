//
//  CustAccount+LoadDetails.swift
//
//
//  Created by Victor Cantu on 7/25/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func loadDetails(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadDetailsResponse>?) -> () )) {
        
            //API.papaContadorV1.ChangeSATPasswordRequest
            
        sendPost(
            rout,
            version,
            "loadDetails",
            APIRequestID(
                id: id,
                store: nil
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadDetailsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadDetails \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
