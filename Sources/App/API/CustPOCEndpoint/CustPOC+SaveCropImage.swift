//
//  CustPOC+SaveCropImage.swift
//  
//
//  Created by Victor Cantu on 9/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func saveCropImage(
        type: SaveCropImageType,
        relid: UUID?,
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
        callback: @escaping ( (_ resp: APIResponseGeneric<String>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveCropImage",
            SaveCropImageRequest(
                type: type,
                relid: relid,
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
                watermarks: watermarks
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<String>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
