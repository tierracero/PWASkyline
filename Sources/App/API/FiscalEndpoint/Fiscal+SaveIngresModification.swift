//
//  Fiscal+SaveIngresModification.swift
//  
//
//  Created by Victor Cantu on 12/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func saveIngresModification(
        docid: UUID,
        itemno: Int,
        item: InventroyIngresItem,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveIngresModification",
            SaveIngresModificationRequest(
                docid: docid,
                itemno: itemno,
                item: item
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


