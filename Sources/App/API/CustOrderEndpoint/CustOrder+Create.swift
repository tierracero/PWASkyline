//
//  CustPOC+CustOrderCreate.swift
//
//
//  Created by Victor Cantu on 3/15/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func create(
        type: FolioTypes,
        store: UUID,
        custAcct: UUID,
        custSubAcct: UUID?,
        workedBy: UUID?,
        
        dueDate: Int64?,
        rentStartAt: Int64?,
        rentEndAt: Int64?,
        
        description: String,
        smallDescription: String,
        
        lat: String?,
        lon: String?,
        
        contact: CustOrderContact,
        address: CustOrderServiceAddress,
        rentals: [RentalObject],
        
        charges: [ChargeObject],
        payment: [PaymentObject],
        equipments: [EquipmentObject],
        files: [String],
        callback: @escaping ( (_ resp: APIResponse?) -> () )) {
        sendPost(
            rout,
            version,
            "create",
            CreateRequest(
                type: type,
                store: store,
                custAcct: custAcct,
                custSubAcct: custSubAcct,
                workedBy: workedBy,
                dueDate: dueDate,
                rentStartAt: rentStartAt,
                rentEndAt: rentEndAt,
                description: description,
                smallDescription: smallDescription,
                lat: lat,
                lon: lon,
                contact: contact,
                address: address,
                rentals: rentals,
                charges: charges,
                payment: payment,
                equipments: equipments,
                files: files
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
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}



