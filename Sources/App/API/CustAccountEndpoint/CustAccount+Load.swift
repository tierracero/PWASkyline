//
//  CustAccount+Load.swift
//
//
//  Created by Victor Cantu on 7/25/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func load(
        id: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "load",
            LoadRequest(
                id: id
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
