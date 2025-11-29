//
//  CustPOC+ProductDepartmentTransfer.swift
//  
//
//  Created by Victor Cantu on 8/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func productDepartmentTransfer(
        originLevel: CustProductType,
        originId: UUID?,
        originName: String,
        targetLevel: CustProductType,
        depId: UUID,
        depName: String,
        catId: UUID?,
        catName: String,
        lineId: UUID?,
        lineName: String,
        pocids: [UUID],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "productDepartmentTransfer",
            ProductDepartmentTransferRequest(
                originLevel: originLevel,
                originId: originId,
                originName: originName,
                targetLevel: targetLevel,
                depId: depId,
                depName: depName,
                catId: catId,
                catName: catName,
                lineId: lineId,
                lineName: lineName,
                pocids: pocids
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
                print(error)
                callback(nil)
            }
        }
    }
}

