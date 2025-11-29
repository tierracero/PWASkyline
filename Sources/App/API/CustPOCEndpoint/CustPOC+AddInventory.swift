//
//  CustPOC+AddInventory.swift
//  
//
//  Created by Victor Cantu on 2/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
/*
extension CustPOCComponents {
    
    static func addInventory(
        pocid: UUID,
        units: Int64,
        storeid: UUID,
        storeName: String,
        bodid: UUID,
        bodName: String,
        secid: UUID,
        secName: String,
        series: [String],
        callback: @escaping ( (_ resp: APIResponseGeneric<[UUID]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addInventory",
            AddInventoryRequest(
                pocid: pocid,
                units: units,
                storeid: storeid,
                storeName: storeName,
                bodid: bodid,
                bodName: bodName,
                secid: secid,
                secName: secName,
                series: series
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[UUID]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

*/