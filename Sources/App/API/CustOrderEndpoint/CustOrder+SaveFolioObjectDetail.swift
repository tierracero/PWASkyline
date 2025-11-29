//
//  CustOrder+SaveFolioObjectDetail.swift
//  
//
//  Created by Victor Cantu on 7/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func saveFolioObjectDetail (
        id: UUID,
        IDTag1: String,
        IDTag2: String,
        tag1: String,
        tag2: String,
        tag3: String,
        tag4: String,
        tag5: String,
        tag6: String,
        tagCheck1: Bool,
        tagCheck2: Bool,
        tagCheck3: Bool,
        tagCheck4: Bool,
        tagCheck5: Bool,
        tagCheck6: Bool,
        diagnostic: String?,
        resolution: String?,
        tagDescr: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveFolioObjectDetail",
            SaveFolioObjectDetailRequest(
                id: id,
                IDTag1: IDTag1,
                IDTag2: IDTag2,
                tag1: tag1,
                tag2: tag2,
                tag3: tag3,
                tag4: tag4,
                tag5: tag5,
                tag6: tag6,
                tagCheck1: tagCheck1,
                tagCheck2: tagCheck2,
                tagCheck3: tagCheck3,
                tagCheck4: tagCheck4,
                tagCheck5: tagCheck5,
                tagCheck6: tagCheck6,
                diagnostic: diagnostic,
                resolution: resolution,
                tagDescr: tagDescr
            )
        ) { resp in
            guard let data = resp else{
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

