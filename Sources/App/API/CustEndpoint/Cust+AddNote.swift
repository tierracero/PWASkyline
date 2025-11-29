//
//  Cust+AddNote.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addNote(
        relType: CustGeneralNotesTargetTypes,
        rel: UUID,
        type: NoteTypes,
        activity: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustGeneralNotesQuick>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addNote",
            AddNoteRequest(
                relType: relType,
                rel: rel,
                type: type,
                activity: activity
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustGeneralNotesQuick>.self, from: data)
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
