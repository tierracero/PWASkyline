//
//  Cust+SaveStoreLevel.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func saveStoreLevel(
        id: UUID,
        type: CustProductType,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        isPublic: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveStoreLevel",
            SaveStoreLevelRequest(
                id: id,
                type: type,
                name: name,
                smallDescription: smallDescription,
                description: description,
                icon: icon,
                isPublic: isPublic
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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
