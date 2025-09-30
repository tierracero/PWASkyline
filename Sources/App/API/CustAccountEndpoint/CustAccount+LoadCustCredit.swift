//
//  CustAccount+LoadCustCredit.swift
//  
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func loadCustCredit(
        custAcct: UUID,
        creditid: UUID,
        callback: @escaping (
            (_ resp: APIResponseGeneric<CustCredit>?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "loadCustCredit",
            LoadCustCreditRequest(
                custAcct: custAcct,
                creditid: creditid
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustCredit>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadDetails \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
