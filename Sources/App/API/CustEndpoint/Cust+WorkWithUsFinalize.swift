//
//  Cust+WorkWithUsFinalize.swift
//  
//
//  Created by Victor Cantu on 6/6/23.
//

/*
import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    public static func workWithUsFinalize(
        profileid: UUID,
        subProfileid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<String>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "workWithUsFinalize",
            WorkWithUsFinalizeRequest(
                profileid: profileid,
                subProfileid: subProfileid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<String>.self, from: data)
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
*/
