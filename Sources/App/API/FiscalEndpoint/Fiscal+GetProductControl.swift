//
//  Fiscal+GetProductControl.swift
//  
//
//  Created by Victor Cantu on 2/8/23.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func getProductControl(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetProductControlResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProductControl",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetProductControlResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
