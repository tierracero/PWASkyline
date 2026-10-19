//
//  Cust+NotificationsSaveSettings.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func notificationsSaveSettings(
        frequency: CustTaskAuthorizationManagerAlertFrequency,
        level: CustTaskAuthorizationManagerAlertLevel,
        moneyPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        cashControlPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        ordersPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        approvalsPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        fiscalDocumentsPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        inventoryAndAssetsPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        accountSecurityPushNotificationAlertFrequency: CustPushNotificationAlertFrequency,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "notificationsSaveSettings",
            NotificationsSaveSettingsRequest(
                frequency: frequency,
                level: level,
                moneyPushNotificationAlertFrequency: moneyPushNotificationAlertFrequency,
                cashControlPushNotificationAlertFrequency: cashControlPushNotificationAlertFrequency,
                ordersPushNotificationAlertFrequency: ordersPushNotificationAlertFrequency,
                approvalsPushNotificationAlertFrequency: approvalsPushNotificationAlertFrequency,
                fiscalDocumentsPushNotificationAlertFrequency: fiscalDocumentsPushNotificationAlertFrequency,
                inventoryAndAssetsPushNotificationAlertFrequency: inventoryAndAssetsPushNotificationAlertFrequency,
                accountSecurityPushNotificationAlertFrequency: accountSecurityPushNotificationAlertFrequency
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponse.self, from: data)
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

