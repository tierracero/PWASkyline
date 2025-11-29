//
//  CustOrder+GetWorkLoadDay.swift
//  
//
//  Created by Victor Cantu on 7/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    ///  Send OrderID to retive notes
    static func getWorkLoadDay (
        type: FolioTypes,
        day: Int,
        month: Int,
        year: Int,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWorkLoadDayResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getWorkLoadDay",
            GetWorkLoadDayRequest(
                type: type,
                day: day,
                month: month,
                year: year
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetWorkLoadDayResponse>.self, from: data)
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

