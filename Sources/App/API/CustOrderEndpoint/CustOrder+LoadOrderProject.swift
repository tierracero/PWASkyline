//
//  CustOrder+LoadOrderProject.swift
//
//
//  Created by Victor Cantu on 10/2/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func loadOrderProject (
        projetcId: UUID,
        orderId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadOrderProjectResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadOrderProject",
            LoadOrderProjectRequest(
                projetcId: projetcId,
                orderId: orderId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<LoadOrderProjectResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
