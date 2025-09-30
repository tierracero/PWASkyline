//
//  CustOrder+AddNote.swift
//  
//
//  Created by Victor Cantu on 4/19/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	///  Send OrderID to retive notes
	static func addNote (
		order: UUID,
		type: NoteTypes,
		activity: String,
        lastCommunicationMethod: MessagingCommunicationMethods?,
		callback: @escaping ( (_ resp: APIResponseGeneric<CustOrderLoadFolioNotes>?) -> () )
	) {
		sendPost(
			rout,
			version,
			"addNote",
            AddNoteRequest(
                order: order,
                type: type,
                activity: activity,
                lastCommunicationMethod: lastCommunicationMethod
            )
		) { resp in
			guard let data = resp else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<CustOrderLoadFolioNotes>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
		
	}
}
