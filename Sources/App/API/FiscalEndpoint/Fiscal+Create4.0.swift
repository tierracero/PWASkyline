//
//  Fiscal+Create4.0.swift
//  
//
//  Created by Victor Cantu on 11/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func create4(
        eventid: UUID,
        taxMode: TaxMode,
        comment: String,
        communicationMethod: String,
        type: FIAccountsServicesRelatedType,
        storeId: UUID?,
        accountid: UUID,
        orderid: UUID?,
        officialDate: Int64?,
        profile: UUID,
        razon: String,
        rfc: String,
    
        zip: String,
        regimen: FiscalRegimens,
    
        use: FiscalUse,
        metodo: FiscalPaymentMeths,
        forma: FiscalPaymentCodes,
        items: [FiscalConcept],
        provider: String,
        auth: String,
        lastFour: String,
        cartaPorte: FiscalCartaPorte?,
        globalInformation: InformacionGlobal?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "create4",
            Create4Request(
                eventid: eventid,
                taxMode: taxMode,
                comment: comment,
                communicationMethod: communicationMethod,
                type: type, 
                storeId: storeId,
                accountid: accountid,
                orderid: orderid,
                officialDate: officialDate,
                profile: profile,
                razon: razon,
                rfc: rfc,
                zip: zip,
                regimen: regimen,
                use: use,
                metodo: metodo,
                forma: forma,
                items: items,
                provider: provider,
                auth: auth,
                lastFour: lastFour,
                cartaPorte: cartaPorte,
                globalInformation: globalInformation
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
