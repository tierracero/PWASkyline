// Cust+GetVendors.swift


import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getVendors(
        callback: @escaping ((_ resp: APIResponseGeneric<GetVendorsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getVendors",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetVendorsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}

