//
//  CustPOC+AddInventoryItemNote.swift
//  
//
//  Created by Victor Cantu on 7/22/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func addInventoryItemNote(
        itemid: UUID,
        note: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addInventoryItemNote",
            AddInventoryItemNoteRequest(
                itemid: itemid,
                note: note
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
