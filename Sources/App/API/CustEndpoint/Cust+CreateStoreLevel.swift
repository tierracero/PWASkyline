//
//  Cust+CreateStoreLevel.swift
//  
//
//  Created by Victor Cantu on 9/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func createStoreLevel(
        id: UUID?,
        ///dep, cat, line, main, all
        type: CustProductType,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        isPublic: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createStoreLevel",
            CreateStoreLevelRequest(
                id: id,
                type: type,
                name: name,
                smallDescription: smallDescription,
                description: description,
                icon: icon,
                coverLandscape: coverLandscape,
                coverPortrait: coverPortrait,
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
