//
//  Cust+SaveConfigStoreProduct.swift
//
//
//  Created by Victor Cantu on 2/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func saveConfigStoreProduct(
        defaultCurrencie: Currencies,
        tagOne: String,
        tagTwo: String,
        tagThree: String,
        defaultWarentySelf: Int,
        defaultWarentyProvider: Int,
        inventorieZeroSale: InventorieZeroSale,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveConfigStoreProduct",
            SaveConfigStoreProductRequest(
                defaultCurrencie: defaultCurrencie,
                tagOne: tagOne,
                tagTwo: tagTwo,
                tagThree: tagThree,
                defaultWarentySelf: defaultWarentySelf,
                defaultWarentyProvider: defaultWarentyProvider,
                inventorieZeroSale: inventorieZeroSale
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
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
