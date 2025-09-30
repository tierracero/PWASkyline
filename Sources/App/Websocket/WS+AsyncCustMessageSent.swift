//
//  WS+AsyncCustMessageSent.swift
//  
//
//  Created by Victor Cantu on 8/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func asyncCustMessageSent(_ payload: String) -> API.wsV1.AsyncCustOrderLoadFolioNotes? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AsyncCustOrderLoadFolioNotesNotification.self, from: data).payload
            } catch {
                
                print(error)
                
                return nil
            }
        }
        else{
            return nil
        }
    }
}
