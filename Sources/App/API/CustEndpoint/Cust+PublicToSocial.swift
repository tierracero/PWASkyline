//
//  CustPOC+PublicToSocial.swift
//  
//
//  Created by Victor Cantu on 1/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func publicToSocial(
        originalImage: String,
        /// The image original width
        originalWidth: Int,
        /// The image original height
        originalHeight: Int,
        /// The image relative width as appers in UI
        relativeWidth: Int,
        /// The image relative  height as appers in UI
        relativeHieght: Int,
        watermarks: [WaterMarkItem],
        pages: [CustSocialPageQuick],
        caption: String?,
        link: String?,
        uts: Int64?,
        callback: @escaping ( (_ resp: APIResponseGeneric<PublicToSocialResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "publicToSocial",
            PublicToSocialRequest(
                originalImage: originalImage,
                originalWidth: originalWidth,
                originalHeight: originalHeight,
                relativeWidth: relativeWidth,
                relativeHieght: relativeHieght,
                watermarks: watermarks,
                pages: pages,
                caption: caption,
                link: link,
                uts: uts
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<PublicToSocialResponse>.self, from: data)
                callback(resp)
                
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
