// Cust+GetVendors.swift


import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getVendors(
        type: GetVendorsType = .all,
        callback: @escaping ((_ resp: APIResponseGeneric<GetVendorsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getVendors",
            GetVendorsRequest(type: type)
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetVendorsResponse>.self, from: data)
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

