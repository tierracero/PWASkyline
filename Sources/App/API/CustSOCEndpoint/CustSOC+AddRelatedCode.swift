//
//  CustSOC+AddRelatedCode.swift
//
//
//  Created by Victor Cantu on 10/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func addRelatedCode(
        force: Bool,
        type: AddRelatedCodeType,
        currentId: UUID,
        targetId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddRelatedCodeResponseType>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addRelatedCode",
            AddRelatedCodeRequest(
                force: force,
                type: type,
                currentId: currentId,
                targetId: targetId
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AddRelatedCodeResponseType>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
