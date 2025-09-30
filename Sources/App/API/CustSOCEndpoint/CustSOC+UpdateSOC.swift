//
//  CustSOC+UpdateSOC.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func updateSOC(
        id: UUID,
        serviceType: SOCCodeType,
        serviceLevel: UsernameRoles,
        fiscCode: String,
        fiscCodeName: String,
        fiscUnit: String,
        fiscUnitName: String,
        autoExpireAt: Int?,
        name: String,
        smallDescription: String,
        description: String,
        productionCost: Float,
        cost: Float,
        pricea: Float,
        priceb: Float,
        pricec: Float,
        pricep: Float,
        operationalObject: [UUID],
        saleActions: [UUID],
        saleActionsTime: Int,
        saleActionsCost: Int64,
        saleActionsPoints: Int,
        serviceActions: [UUID],
        serviceActionsTime: Int,
        serviceActionsCost: Int64,
        serviceActionsPoints: Int,
        comisionBy: ComisionBy,
        comision: Int,
        inPromo: Bool,
        createOds: Bool,
        efect: [CustSOCCodeStratergy],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "updateSOC",
            UpdateSOCRequest(
                id:id,
                serviceType: serviceType,
                serviceLevel: serviceLevel,
                fiscCode: fiscCode,
                fiscCodeName: fiscCodeName,
                fiscUnit: fiscUnit,
                fiscUnitName: fiscUnitName,
                autoExpireAt: autoExpireAt,
                name: name,
                smallDescription: smallDescription,
                description: description,
                productionCost: productionCost,
                cost: cost,
                pricea: pricea,
                priceb: priceb,
                pricec: pricec,
                pricep: pricep,
                operationalObject: operationalObject,
                saleActions: saleActions,
                saleActionsTime: saleActionsTime,
                saleActionsCost: saleActionsCost,
                saleActionsPoints: saleActionsPoints,
                serviceActions: serviceActions,
                serviceActionsTime: serviceActionsTime,
                serviceActionsCost: serviceActionsCost,
                serviceActionsPoints: serviceActionsPoints,
                comisionBy: comisionBy,
                comision: comision,
                inPromo: inPromo,
                createOds: createOds,
                efect: efect
            )
        ) { payload in
            
            guard let data = payload else{
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
