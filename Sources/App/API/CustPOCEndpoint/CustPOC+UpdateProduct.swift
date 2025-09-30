//
//  CustPOC+UpdateProduct.swift
//  
//
//  Created by Victor Cantu on 2/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func updateProduct(
        pocid: UUID,
        upc: String,
        productType: String,
        productSubType: String,
        brand: String,
        model: String,
        pseudoModel: String,
        name: String,
        tagOne: String,
        tagTwo: String,
        tagThree: String,
        smallDescription: String,
        description: String,
        fiscCode: String,
        fiscUnit: String,
        cost: Int64,
        pricea: Int64,
        priceb: Int64,
        pricec: Int64,
        pricep: Int64,
        pricecr: Int64,
        inCredit: Bool,
        downPay: Float,
        monthToPay: Int,
        breakType: BreakType,
        breakOne: Float,
        breakOneText: String,
        breakTwo: Float,
        breakTwoText: String,
        breakThree: Float,
        breakThreeText: String,
        promo: Bool,
        highlight: Bool,
        providers: [UUID],
        appliedTo: [String],
        comision: Double?,
        points: Double?,
        premier: Double?,
        codes:[String],
        warentySelf: Int,
        warentyProvider: Int,
        reqSeries: Bool,
        maximize: Bool,
        minInventory: Float,
        level: Int,
        inventorySecction: [ProdInventorySecction],
        imagesMetaData: [ImagesMetaData],
        conditions: ItemConditions,
        amazon: CustPOC.Amazon?,
        claroShop: CustPOC.ClaroShop?,
        ebay: CustPOC.EBay?,
        enremate: CustPOC.EnRemate?,
        mercadoLibre: CustPOC.MercadoLibre?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "updateProduct",
            UpdateProductRequest(
                pocid: pocid,
                upc: upc,
                productType: productType,
                productSubType: productSubType,
                brand: brand,
                model: model,
                pseudoModel: pseudoModel,
                name: name,
                tagOne: tagOne,
                tagTwo: tagTwo,
                tagThree: tagThree,
                smallDescription: smallDescription,
                description: description,
                fiscCode: fiscCode,
                fiscUnit: fiscUnit,
                cost: cost,
                pricea: pricea,
                priceb: priceb,
                pricec: pricec,
                pricep: pricep,
                pricecr: pricecr,
                inCredit: inCredit,
                downPay: downPay,
                monthToPay: monthToPay,
                breakType: breakType,
                breakOne: breakOne,
                breakOneText: breakOneText,
                breakTwo: breakTwo,
                breakTwoText: breakTwoText,
                breakThree: breakThree,
                breakThreeText: breakThreeText,
                promo: promo,
                highlight: highlight,
                providers: providers,
                appliedTo: appliedTo,
                comision: comision,
                points: points,
                premier: premier,
                codes: codes,
                warentySelf: warentySelf,
                warentyProvider: warentyProvider,
                reqSeries: reqSeries,
                maximize: maximize,
                minInventory: minInventory,
                level: level,
                inventorySecction: inventorySecction,
                imagesMetaData: imagesMetaData,
                conditions: conditions,
                amazon: amazon,
                claroShop: claroShop,
                ebay: ebay,
                enremate: enremate,
                mercadoLibre: mercadoLibre
            )
        ) { data in
            
            guard let data else {
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

