//
//  CustPOC+AddSaleNote.swift
//  
//
//  Created by Victor Cantu on 7/22/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func addSaleNote(
        saleid: UUID,
        note: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addSaleNote",
            AddSaleNoteRequest(
                saleid: saleid,
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
