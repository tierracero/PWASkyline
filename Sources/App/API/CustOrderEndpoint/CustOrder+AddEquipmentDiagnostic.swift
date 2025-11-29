//
//  CustOrder+AddEquipmentDiagnostic.swift
//
//
//  Created by Victor Cantu on 6/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func addEquipmentDiagnostic (
        equipmentId: UUID,
        comment: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addEquipmentDiagnostic",
            AddEquipmentDiagnosticRequest(
                equipmentId: equipmentId,
                comment: comment
            )
        ) { data in
            guard let data else{
                
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

