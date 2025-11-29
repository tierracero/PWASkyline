//
//  Cust+SaveCropImage.swift
//
//
//  Created by Victor Cantu on 10/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func saveCropImage(
        eventid: UUID,
        replaceImage: Bool,
        to: ImagePickerTo,
        subId: CustWebFilesObjectType?,
        relId: UUID?,
        folio: String?,
        isAvatar: Bool,
        /// if image has been previosly registerd
        mediaid: UUID?,
        originalImage: String,
        /// The image original width
        originalWidth: Int,
        /// The image original height
        originalHeight: Int,
        /// The image relative width as appers in UI
        relativeWidth: Int,
        /// The image relative  height as appers in UI
        relativeHieght: Int,
        logoRelativeHeight: Int,
        logoRelativeWidth: Int,
        thumpWidth: Int,
        thumpHeight: Int,
        thumpX: Int,
        thumpY: Int,
        wapWidth: Int,
        wapHeight: Int,
        wapX: Int,
        wapY: Int,
        watermarks: [WaterMarkItem],
        connid: String,
        roomtoken: String?,
        usertoken: String?,
        mid: String?,
        replyTo: String?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveCropImage",
            SaveCropImageRequest(
                eventid: eventid,
                replaceImage: replaceImage,
                to: to, 
                subId: subId,
                relId: relId,
                folio: folio,
                isAvatar: isAvatar,
                mediaid: mediaid,
                originalImage: originalImage,
                originalWidth: originalWidth,
                originalHeight: originalHeight,
                relativeWidth: relativeWidth,
                relativeHieght: relativeHieght,
                logoRelativeHeight: logoRelativeHeight,
                logoRelativeWidth: logoRelativeWidth,
                thumpWidth: thumpWidth,
                thumpHeight: thumpHeight,
                thumpX: thumpX,
                thumpY: thumpY,
                wapWidth: wapWidth,
                wapHeight: wapHeight,
                wapX: wapX,
                wapY: wapY,
                watermarks: watermarks,
                connid: connid,
                roomtoken: roomtoken,
                usertoken: usertoken,
                mid: mid,
                replyTo: replyTo
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
