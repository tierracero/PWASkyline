//
//  Cust+CreateStore.swift
//  
//
//  Created by Victor Cantu on 7/3/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func createStore(
        supervisorId: UUID,
        storePrefix: String,
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
        groopName: String,
        bodega: String,
        bodegaDescr: String,
        seccion: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateStoreResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createStore",
            CreateStoreRequest(
                supervisorId: supervisorId,
                storePrefix: storePrefix,
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
                lockedInventory: lockedInventory,
                groopName: groopName,
                bodega: bodega,
                bodegaDescr: bodegaDescr,
                seccion: seccion
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<CreateStoreResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
