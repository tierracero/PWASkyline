//
//  CustAPI+SincCustSettings.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

// Keep this wire-compatible with CustComponents.SincCustSettingsResponse.
// A reference avoids WASM copy helpers exceeding the browser's parameter limit.
final class SincCustSettingsSnapshot: Payloadable {
    let account: TCAccountsItem
    let custWebFilesLogos: CustWebFilesLogos
    let configStoreProduct: ConfigStoreProduct?
    let configContactTags: ConfigContactTags?
    let configServiceTags: ConfigServiceTags?
    let configStoreProcessing: ConfigStoreProcessing?
    let configGeneral: ConfigGeneral?
    let customerServiceProfile: CustomerServiceProfile
    let custOperationWorkProfile: CustOperationWorkProfile
    let configStore: ConfigStore?
    let alertManagerConfiguration: AlertManagerConfiguration
    let mercadoLibreProfile: MercadoLibreProfile?
    let orcScripts: [OCRCustomeScript]
    let printScripts: [CustomerCustomeScript]
    let internalCommunications: [InternalCommunicationMessagesMin]
}

extension CustComponents {
	
	static func sincCustSettings( callback: @escaping ( (_ resp: APIResponseGeneric<SincCustSettingsSnapshot>?) -> () )) {
		sendPost(
			rout,
			version,
			"sincCustSettings",
			EmptyPayload()
		) { data in
			guard let data  else{
				callback(nil)
				return
			}
			do{
				let resp = try decodeAPIResponse(APIResponseGeneric<SincCustSettingsSnapshot>.self, from: data)
				callback(resp)
			}
			catch{

				print("🔴. errror")

				print(error)
				callback(nil)
			}
		}
	}
	
}
