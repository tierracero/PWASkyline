//
//  CustPOC+AddManualInventory.swift
//
//
//  Created by Victor Cantu on 7/12/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func addCustomerManualConcession(
            storeId: UUID,
            accountId: UUID,
            items: [CreateManualProductObject],
            documentName: String,
            documentSerie: String,
            documentFolio: String,
            vendorId: UUID,
            profileId: UUID,
            bodegaId: UUID?,
            sectionId: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddCustomerManualConcessionResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "addCustomerManualConcession",
            AddCustomerManualConcessionRequest(
                storeId: storeId,
                accountId: accountId,
                items: items,
                documentName: documentName,
                documentSerie: documentSerie,
                documentFolio: documentFolio,
                vendorId: vendorId,
                profileId: profileId,
                bodegaId: bodegaId,
                sectionId: sectionId
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddCustomerManualConcessionResponse>.self, from: data))
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
