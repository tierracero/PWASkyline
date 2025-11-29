//
//  CustPOC+CloseRentalOrder.swift
//  
//
//  Created by Victor Cantu on 3/15/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
	/*
	struct CustOrderCreate: Codable {
		let type: FolioTypes
		let store: UUID
		let custAcct: UUID
		let custSubAcct: UUID?
		let workedBy: UUID?
		
		let dueDate: Int64?
		let rentStartAt: Int64?
		let rentEndAt: Int64?

		let descr: String
		let subDescr: String
		
		let lat: String?
		let lon: String?
		
		let highPriority: Bool
		
		let contact: CustOrderContact
		let address: CustOrderServiceAddress
		let rentals: [RentalObject]
		
		let charges: [CustOrderCreateCharges]
		let payment: [PaymentObject]
		let equipments: [CustOrderCreateEquipments]
	}
	
	static func create(
		type: FolioTypes,
		store: UUID,
		custAcct: UUID,
		custSubAcct: UUID?,
		workedBy: UUID?,
		
		dueDate: Int64?,
		rentStartAt: Int64?,
		rentEndAt: Int64?,
		
		descr: String,
		subDescr: String,
		
		lat: String?,
		lon: String?,
		
		highPriority: Bool,
		
		contact: CustOrderContact,
		address: CustOrderServiceAddress,
		rentals: [RentalObject],
		
		charges: [CustOrderCreateCharges],
		payment: [PaymentObject],
		equipments: [CustOrderCreateEquipments],
		callback: @escaping ( (_ resp: ApiResponse?) -> () )) {
		
		sendPost(
			rout,
			version,
			"create",
			CustOrderCreate(
				type: type,
				store: store,
				custAcct: custAcct,
				custSubAcct: custSubAcct,
				workedBy: workedBy,
				dueDate: dueDate,
				rentStartAt: rentStartAt,
				rentEndAt: rentEndAt,
				descr: descr,
				subDescr: subDescr,
				lat: lat,
				lon: lon,
				highPriority: highPriority,
				contact: contact,
				address: address,
				rentals: rentals,
				charges: charges,
				payment: payment,
				equipments: equipments
			)
		) { payload in
			guard let data = payload else{
				callback(nil)
				return
			}
			
			do{
				let resp = try JSONDecoder().decode(ApiResponse.self, from: data)
				callback(resp)
			}
			catch{
				
				print(error)
				
				callback(nil)
			}
		}
	}
	*/
}



