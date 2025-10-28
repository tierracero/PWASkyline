//
//  Cust+SaveSecctionDetails.swift
//  
//
//  Created by Victor Cantu on 7/5/22.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func saveSecctionDetails(
        id: UUID,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<SaveSecctionDetailsResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveSecctionDetails",
            SaveSecctionDetailsRequest(
                id: id,
                name: name
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<SaveSecctionDetailsResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
