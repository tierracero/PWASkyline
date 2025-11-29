//
//  CustPDV+CreateBudgetReport.swift
//  
//
//  Created by Victor Cantu on 2/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVComponents {
    
    static func createBudgetReport(
        fiscalProfile: UUID?,
        budgetid: UUID?,
        custAcct: UUID,
        comment: String,
        store: UUID,
        saleType: FolioTypes,
        saleObjects: [SaleProductPDVObject], 
        callback: @escaping ((
            _ resp: APIResponse?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "createBudgetReport",
            CreateBudgetReportRequest(
                fiscalProfile: fiscalProfile,
                budgetid: budgetid,
                custAcct: custAcct,
                comment: comment,
                store: store,
                saleType: saleType,
                saleObjects: saleObjects
            )
        ) { resp in
            
                guard let data = resp else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            
            }
    }
     
}

