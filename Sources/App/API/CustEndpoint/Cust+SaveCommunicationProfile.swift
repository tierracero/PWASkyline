//
//  Cust+SaveCommunicationProfile.swift
//
//  Created by Victor Cantu on 6/21/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func saveCommunicationProfile(
        orderCommunicationProfile: [CustCommunicationEvents],
        saleCommunicationProfile: [CustCommunicationEvents],
        dateCommunicationProfile: [CustCommunicationEvents],
        rentCommunicationProfile: [CustCommunicationEvents],
        welcomeMessage: CustCustomeMessage,
        closingMessage: CustCustomeMessage,
        closingImage: String?,
        closingLink: String?,
        sendFinalizedOrderFollowUp: AutoCommunicationsFollowUp?,
        sendFinalizedOrderMarketingFollowUp: AutoCommunicationsFollowUp?,
        sendOrderBudgetCreditExperationAlert: Int?,
        orderTermsAndConditions: String?,
        saleTermsAndConditions: String?,
        dateTermsAndConditions: String?,
        rentalTermsAndConditions: String?,
        followUpWelcomeDocument: String?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveCommunicationProfile",
            SaveCommunicationProfileRequest(
                orderCommunicationProfile: orderCommunicationProfile,
                saleCommunicationProfile: saleCommunicationProfile,
                dateCommunicationProfile: dateCommunicationProfile,
                rentCommunicationProfile: rentCommunicationProfile,
                welcomeMessage: welcomeMessage,
                closingMessage: closingMessage,
                closingImage: closingImage,
                closingLink: closingLink,
                sendFinalizedOrderFollowUp: sendFinalizedOrderFollowUp,
                sendFinalizedOrderMarketingFollowUp: sendFinalizedOrderMarketingFollowUp,
                sendOrderBudgetCreditExperationAlert: sendOrderBudgetCreditExperationAlert,
                orderTermsAndConditions: orderTermsAndConditions,
                saleTermsAndConditions: saleTermsAndConditions,
                dateTermsAndConditions: dateTermsAndConditions,
                rentalTermsAndConditions: rentalTermsAndConditions,
                followUpWelcomeDocument: followUpWelcomeDocument
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
