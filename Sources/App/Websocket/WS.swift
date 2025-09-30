//
//  WebsocketEventManager.swift
//  
//
//  Created by Victor Cantu on 8/7/22.
//

import Foundation

public struct WS {
    
    public enum Events: String, Codable {
        case welcome
        case pong
        case custFetchUsersResponse
        case requestUserToChatResponse
        case iAmWritingNotification
        case reciveMessage
        case updateMessageStatus
        case NewChatRoomNotification
        case NotifyLoginNotification
        case NotifyLogoutNotification
        case alertStatusUpdate
        case asyncCustMessageSent
        
        /// Upload Image Async
        case asyncFileUpload
        
        /// Update Image Async
        case asyncFileUpdate
        
        /// Remove BackGround
        case asyncRemoveBackground
        
        case asyncCropImage
        case waMsgStatusUpdate
        case NotifyAddFacebookProfile
        case NotifyAddYoutubeProfile
        case NotifyAddMercadoLibreProfile
        case metaNewMessengerPayload
        case addSocialReaction
        case removeSocialReaction
        case confirmSentMessage
        
        case wsLocationUpdate
        
        /// Upload Picture
        case requestMobileCamaraComplete
        case requestMobileCamaraFail
        case requestMobileCamaraInitiate
        case requestMobileCamaraProgress
        
        
     
        /// Use camera to scan QR / Barcode
        case requestMobileScannerComplete
        
        /// Use camera to scan image text
        case requestMobileOCRComplete
        
        case custTaskAuthRequest
        
        case custTaskDenied
        
        case custTaskAuthoroized
     
        case sendToMobile
        
        case whatsAppLoadingScreen
        
        case whatsAppQR
        
        case whatsAppAuthenticated
            
        case whatsAppAuthFailure
            
        case whatsAppReady
            
        case whatsAppDisconnected
        
        case waMsgReactionUpdate
        
        case customerOrderStatusUpdate

    }
    
    public func recive(_ payload: String) -> (Events?, String?){
        
        struct _KeyDecoder: Codable {
            var event: String
        }
        
        if let data = payload.data(using: .utf8) {
            do {
                let key = try JSONDecoder().decode(_KeyDecoder.self, from: data).event
                
                return (Events(rawValue: key), nil)
                
            } catch {
                
                return (nil, String(describing: error))
            }
        }
        else{
            return (nil, "Failed data from payload ")
        }
    }
}
