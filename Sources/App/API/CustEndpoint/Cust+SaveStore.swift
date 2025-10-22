//
//  Cust+SaveStore.swift
//  
//
//  Created by Victor Cantu on 7/3/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func saveStore(
        storeId: UUID,
        name: String,
        telephone: String,
        mobile: String,
        email: String,
        street: String,
        colony: String,
        city: String,
        state: String,
        country: String,
        zip: String,
        isPublic: Bool,
        isFiscalable: Bool,
        fiscalProfileId: UUID?,
        fiscalProfileName: String,
        lat: Double?,
        lon: Double?,
        button: CustStorePrintButtonType,
        document: CustStorePrintButtonOptions,
        image: CustStorePrintDocumentImage,
        lineBreak: Int,
        buttonPdv: CustStorePrintButtonType,
        documentPdv: CustStorePrintButtonOptions,
        imagePdv: CustStorePrintDocumentImage,
        lineBreakPdv: Int,
        priceModifierPdv: Double,
        priceModifierOrder: Double,
        operationType: StoreOperationType,
        operationStore: UUID?,
        sunday: ConfigStoreScheduleObject,
        monday: ConfigStoreScheduleObject,
        tuesday: ConfigStoreScheduleObject,
        wednesday: ConfigStoreScheduleObject,
        thursday: ConfigStoreScheduleObject,
        friday: ConfigStoreScheduleObject,
        saturday: ConfigStoreScheduleObject,
        lockedInventory: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveStore",
            SaveStoreRequest(
                storeId: storeId,
                name: name,
                telephone: telephone,
                mobile: mobile,
                email: email,
                street: street,
                colony: colony,
                city: city,
                state: state,
                country: country,
                zip: zip,
                isPublic: isPublic,
                isFiscalable: isFiscalable,
                fiscalProfileId: fiscalProfileId,
                fiscalProfileName: fiscalProfileName,
                lat: lat,
                lon: lon,
                button: button,
                document: document,
                image: image,
                lineBreak: lineBreak,
                buttonPdv: buttonPdv,
                documentPdv: documentPdv,
                imagePdv: imagePdv,
                lineBreakPdv: lineBreakPdv,
                priceModifierPdv: priceModifierPdv,
                priceModifierOrder: priceModifierOrder,
                operationType: operationType,
                operationStore: operationStore,
                sunday: sunday,
                monday: monday,
                tuesday: tuesday,
                wednesday: wednesday,
                thursday: thursday,
                friday: friday,
                saturday: saturday,
                lockedInventory: lockedInventory
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
