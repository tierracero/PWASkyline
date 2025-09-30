//
//  CustPOC+CreateProduct.swift
//
//
//  Created by Victor Cantu on 2/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func createProduct(
        productCreateType: CustProductType,
        productCreateUUID: UUID?,
        productCreateSeccionName: String,
        store: UUID?,
        upc: String,
        productType: String,
        productSubType: String,
        brand: String,
        model: String,
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
        curStoreBodega: UUID?,
        curStoreBodegaName: String,
        curStoreSeccion: UUID?,
        curStoreSeccionName: String,
        minInventory: Float,
        promo: Bool,
        highlight: Bool,
        providers: [UUID],
        appliedTo: [String],
        files: [GeneralFile],
        comision: Double?,
        points: Double?,
        premier: Double?,
        codes: [String],
        warentySelf: Float,
        warentyProvider: Float,
        reqSeries: Bool,
        curInventory: Float,
        maximize: Bool,
        level: Int,
        oneTimeUse: Bool,
        series: [String],
        conditions: ItemConditions,
        amazon: CustPOC.Amazon?,
        claroShop: CustPOC.ClaroShop?,
        ebay: CustPOC.EBay?,
        enremate: CustPOC.EnRemate?,
        mercadoLibre: CustPOC.MercadoLibre?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateProductResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createProduct",
            CreateProductRequest(
                productCreateType: productCreateType,
                productCreateUUID: productCreateUUID,
                productCreateSeccionName: productCreateSeccionName,
                store: store,
                upc: upc,
                productType: productType,
                productSubType: productSubType,
                brand: brand,
                model: model,
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
                curStoreBodega: curStoreBodega,
                curStoreBodegaName: curStoreBodegaName,
                curStoreSeccion: curStoreSeccion,
                curStoreSeccionName: curStoreSeccionName,
                minInventory: minInventory,
                promo: promo,
                highlight: highlight,
                providers: providers,
                appliedTo: appliedTo,
                files: files,
                comision: comision,
                points: points,
                premier: premier,
                codes: codes,
                warentySelf: warentySelf,
                warentyProvider: warentyProvider,
                reqSeries: reqSeries,
                curInventory: curInventory,
                maximize: maximize,
                level: level,
                oneTimeUse: oneTimeUse,
                series: series,
                conditions: conditions,
                amazon: amazon,
                claroShop: claroShop,
                ebay: ebay,
                enremate: enremate,
                mercadoLibre: mercadoLibre
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateProductResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}

