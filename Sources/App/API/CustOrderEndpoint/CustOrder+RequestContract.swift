//
//  CustOrder+RequestContract.swift
//  
//
//  Created by Victor Cantu on 7/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func requestContract (
        orderId: UUID,
        configuration: CustContractRelationConfiguration,
        payload: CustContractPayload,
        callback: @escaping ( (_ resp: APIResponseGeneric<RequestContractResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "requestContract",
            RequestContractRequest(
                orderId: orderId,
                configuration: configuration,
                payload: payload
        )
        ) { data in

            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback( try decodeAPIResponse(APIResponseGeneric<RequestContractResponse>.self, from: data) )
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
        
    }
    
}
