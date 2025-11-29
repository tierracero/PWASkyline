//
//  CustOrder+Discovery.swift
//  
//
//  Created by Victor Cantu on 2/27/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
	
	struct CustOrderDiscoveryAPIv1: Codable {
		var term: String
	}
	
	struct CustOrderDiscoveryAPIv1Response: Payloadable {
		var results: [CustOrderDiscoveryResult]
		var term: String
	}
	
	struct CustOrderDiscoveryResult: Payloadable {
        
		let id: UUID
        
		let folio: String
        
		let businessName: String
        
		/// cost_a, cost_b cost_c
		let costType: CustAcctCostTypes
        
		///personal, empresaFisica, empresaMoral, organizacion
		let type: CustAcctTypes
        
		let firstName: String
        
		let lastName: String
        
		let mobile: String
        
		let email: String
		
		let street: String
        
		let colony: String
        
		let city: String
        
		let state: String
        
		let zip: String
        
		let country: String
		
		let fiscalRfc: String
        
		let fiscalRazon: String
        
	}
    
	static func discovery(term: String, callback: @escaping ( (_ resp: APIResponseGeneric<CustOrderDiscoveryAPIv1Response>?) -> () )) {
		
		sendPost(
			rout,
			version,
			"discovery",
			CustOrderDiscoveryAPIv1(
                term: term
            )
		) { resp in
			guard let data = resp else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<CustOrderDiscoveryAPIv1Response>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
	
}
