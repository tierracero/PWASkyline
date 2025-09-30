//
//  CustPOC+AddStorage.swift
//  
//
//  Created by Victor Cantu on 2/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func addStorage(
        pocid: UUID,
        storeid: UUID,
        storeName: String,
        bodegaid: UUID,
        bodegaName: String,
        sectionid: UUID,
        sectionName: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreProductSection>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addStorage",
            AddStorageRequest(
                pocid: pocid,
                storeid: storeid,
                storeName: storeName,
                bodegaid: bodegaid,
                bodegaName: bodegaName,
                sectionid: sectionid,
                sectionName: sectionName
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustStoreProductSection>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
