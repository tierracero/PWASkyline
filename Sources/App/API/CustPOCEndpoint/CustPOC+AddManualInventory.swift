//
//  CustPOC+AddManualInventory.swift
//
//
//  Created by Victor Cantu on 7/12/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    public static func addManualInventory(
            storeId: UUID,
            relationType: AddManualInventoryType,
            items: [CreateManualProductObject],
            documentName: String,
            documentSerie: String,
            documentFolio: String,
            vendorId: UUID,
            profileId: UUID,
            bodegaId: UUID?,
            sectionId: UUID?,
            alocatedTo: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddManualInventoryResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "addManualInventory",
            AddManualInventoryRequest(
                storeId: storeId,
                relationType: relationType,
                items: items,
                documentName: documentName,
                documentSerie: documentSerie,
                documentFolio: documentFolio,
                vendorId: vendorId,
                profileId: profileId,
                bodegaId: bodegaId,
                sectionId: sectionId,
                alocatedTo: alocatedTo
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddManualInventoryResponse>.self, from: data))
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
