
//  Cust+LoadRentalStoreLevels.swift
//
//
//  Created by Victor Cantu on 3/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustComponents {
    
    static func loadRentalStoreLevels(id: UUID?, full: Bool?, callback: @escaping ( (_ resp: APIResponseGeneric<[CustStoreDepsRental]>?) -> () )) {
        
        if !rentalProducts.isEmpty {
            let resp: APIResponseGeneric<[CustStoreDepsRental]> = .init(data: rentalProducts)
            callback(resp)
            return
        }
        
        loadingView(show: true, message: "cargando")
        
        sendPost(
            rout,
            version,
            "loadRentalStoreLevels",
            EmptyPayload()
        ) { payload in
            
            loadingView(show: false, message: "")
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustStoreDepsRental]>.self, from: data)
                
                guard let deps = resp.data else {
                    callback(nil)
                    return
                }
                
                rentalProducts = deps
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
