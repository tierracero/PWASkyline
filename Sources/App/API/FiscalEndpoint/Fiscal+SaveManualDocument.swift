//
//  Fiscal+SaveManualDocument.swift
//
//
//  Created by Victor Cantu on 10/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func saveManualDocument(
        eventid: UUID,
        taxMode: TaxMode,
        comment: String,
        communicationMethod: String,
        type: FIAccountsServicesRelatedType,
        storeId: UUID,
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
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveManualDocument",
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
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: payload)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
