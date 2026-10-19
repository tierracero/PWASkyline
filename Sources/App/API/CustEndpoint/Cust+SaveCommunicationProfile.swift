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
        notifyOnNewOrder: [String],
        notifyOnCloseOrder: [String],
        notifyOnPickedUpEquipment: [String],
        notifyOnNewFiscalDocument: [String],
        notifyOnPaymentReversed: [String],
        notifyOnPaymentDeleted: [String],
        notifyOnRefundIssued: [String],
        notifyOnOverdueBalance: [String],
        notifyOnCashClosing: [String],
        notifyOnCashDiscrepancy: [String],
        notifyOnOrderCanceled: [String],
        notifyOnOrderOverdue: [String],
        notifyOnBudgetAccepted: [String],
        notifyOnBudgetRejected: [String],
        notifyOnDiscountApproval: [String],
        notifyOnPriceOverrideApproval: [String],
        notifyOnPaymentRemovalApproval: [String],
        notifyOnExpenseApproval: [String],
        notifyOnFiscalGenerationFailed: [String],
        notifyOnFiscalDocumentCanceled: [String],
        notifyOnCreditNoteIssued: [String],
        notifyOnCriticalStock: [String],
        notifyOnInventoryLoss: [String],
        notifyOnTransferAwaitingReceipt: [String],
        notifyOnOverdueAssetReturn: [String],
        notifyOnPrivilegedUserAdded: [String],
        notifyOnPermissionsChanged: [String],
        notifyOnUnfamiliarDeviceSignIn: [String],
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
                followUpWelcomeDocument: followUpWelcomeDocument,
                notifyOnNewOrder: notifyOnNewOrder,
                notifyOnCloseOrder: notifyOnCloseOrder,
                notifyOnPickedUpEquipment: notifyOnPickedUpEquipment,
                notifyOnNewFiscalDocument: notifyOnNewFiscalDocument,
                notifyOnPaymentReversed: notifyOnPaymentReversed,
                notifyOnPaymentDeleted: notifyOnPaymentDeleted,
                notifyOnRefundIssued: notifyOnRefundIssued,
                notifyOnOverdueBalance: notifyOnOverdueBalance,
                notifyOnCashClosing: notifyOnCashClosing,
                notifyOnCashDiscrepancy: notifyOnCashDiscrepancy,
                notifyOnOrderCanceled: notifyOnOrderCanceled,
                notifyOnOrderOverdue: notifyOnOrderOverdue,
                notifyOnBudgetAccepted: notifyOnBudgetAccepted,
                notifyOnBudgetRejected: notifyOnBudgetRejected,
                notifyOnDiscountApproval: notifyOnDiscountApproval,
                notifyOnPriceOverrideApproval: notifyOnPriceOverrideApproval,
                notifyOnPaymentRemovalApproval: notifyOnPaymentRemovalApproval,
                notifyOnExpenseApproval: notifyOnExpenseApproval,
                notifyOnFiscalGenerationFailed: notifyOnFiscalGenerationFailed,
                notifyOnFiscalDocumentCanceled: notifyOnFiscalDocumentCanceled,
                notifyOnCreditNoteIssued: notifyOnCreditNoteIssued,
                notifyOnCriticalStock: notifyOnCriticalStock,
                notifyOnInventoryLoss: notifyOnInventoryLoss,
                notifyOnTransferAwaitingReceipt: notifyOnTransferAwaitingReceipt,
                notifyOnOverdueAssetReturn: notifyOnOverdueAssetReturn,
                notifyOnPrivilegedUserAdded: notifyOnPrivilegedUserAdded,
                notifyOnPermissionsChanged: notifyOnPermissionsChanged,
                notifyOnUnfamiliarDeviceSignIn: notifyOnUnfamiliarDeviceSignIn
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
