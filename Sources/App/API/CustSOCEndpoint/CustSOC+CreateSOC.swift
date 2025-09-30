//
//  CustSOC+CreateSOC.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func createSOC(
        /// dep, cat, line, main, all
        type: CustProductType,
        typeid: UUID?,
        typeName: String,
        codeLevel: SOCCodeLevel,
        /// charge, adjustment, recuring, membership
        codeType: SOCCodeType,
        /// general, supervisor, manager, gmanager, owner
        serviceLevel: UsernameRoles,
        fiscCode: String,
        fiscCodeName: String,
        fiscUnit: String,
        fiscUnitName: String,
        autoExpireAt: Int?,
        name: String,
        code: String,
        smallDescription: String,
        description: String,
        productionCost: Int64,
        cost: Int64,
        pricea: Int64,
        priceb: Int64,
        pricec: Int64,
        pricep: Int64,
        operationalObject: [UUID],
        saleActions: [UUID],
        saleActionsTime: Int,
        saleActionsCost: Int64,
        saleActionsPoints: Int,
        serviceActions: [UUID],
        serviceActionsTime: Int,
        serviceActionsCost: Int64,
        serviceActionsPoints: Int,
        ///amount, percent
        comisionBy: ComisionBy,
        comision: Int,
        inPromo: Bool,
        createOds: Bool,
        efect: [CustSOCCodeStratergy],
        callback: @escaping ( (_ resp: APIResponseGeneric<CustSOCQuick>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createSOC",
            CreateSOCRequest(
                type: type,
                typeid: typeid,
                typeName: typeName,
                codeLevel: codeLevel,
                codeType: codeType,
                serviceLevel: serviceLevel,
                fiscCode: fiscCode,
                fiscCodeName: fiscCodeName,
                fiscUnit: fiscUnit,
                fiscUnitName: fiscUnitName,
                autoExpireAt: autoExpireAt,
                name: name,
                code: code,
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
                ///amount, percent
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustSOCQuick>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
