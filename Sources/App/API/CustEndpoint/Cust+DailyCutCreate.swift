//
//  Cust+DailyCutCreate.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func dailyCutCreate(
        type: MoneyManagerType,
        userid: UUID,
        hasStoreBalance: Bool,
        storeid: UUID,
        torender: Int64,
        inBoxOld: Int64,
        inBoxNew: Int64,
        faltante: Int64,
        validations: [UUID],
        payments: [UUID],
        financials: [UUID],
        moneyManager: [UUID],
        callback: @escaping ( (_ resp: APIResponseGeneric<CustMoneyManager>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "dailyCutCreate",
            DailyCutCreateRequest(
                type: type,
                userid: userid,
                hasStoreBalance: hasStoreBalance,
                storeid: storeid,
                torender: torender,
                inBoxOld: inBoxOld,
                inBoxNew: inBoxNew,
                faltante: faltante,
                validations: validations,
                payments: payments,
                financials: financials,
                moneyManager: moneyManager
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<CustMoneyManager>.self, from: payload))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
