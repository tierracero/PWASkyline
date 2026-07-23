//
//  CustOrder+AddEquipmentResolution.swift
//  
//
//  Created by Victor Cantu on 6/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func addEquipmentResolution (
        equipmentId: UUID,
        comment: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addEquipmentResolution",
            AddEquipmentResolutionRequest(
                equipmentId: equipmentId,
                comment: comment
            )
        ) { data in
            guard let data else{
                
                callback(nil)
                return
            }
            do{
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

