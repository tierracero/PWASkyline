//
//  CustAccount+LoadConcessions.swift
//
//
//  Created by Victor Cantu on 1/10/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func loadConcessions(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadConcessionResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "loadConcessions",
            LoadConcessionsRequest(
                id: id
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<LoadConcessionResponse>.self, from: data))
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}

