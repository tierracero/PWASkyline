//
//  Theme+SaveTemplete.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func saveTemplete(
        id: UUID,
        version templetVersion: Float,
        themeDirectory: String,
        themeName: String,
        themeDescription: String,
        thumpWidth: Float,
        thumpHeight: Float,
        index: WebConfigIndex,
        meetUs: WebConfigMeetUs,
        service: WebConfigService,
        product: WebConfigProduct,
        calendar: WebConfigCalendar,
        album: WebConfigAlbum,
        blog: WebConfigBlog,
        download: WebConfigDownload,
        order: WebConfigOrder,
        contact: WebConfigContact,
        general: WebConfigGeneral,
        myaccount: WebConfigMyAccount,
        webStore: WebConfigWebStore,
        images: [String],
        files: [String],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveTemplete",
            SaveTempleteDataRequest(
                id: id,
                version: templetVersion,
                themeDirectory: themeDirectory,
                themeName: themeName,
                themeDescription: themeDescription,
                thumpWidth: thumpWidth,
                thumpHeight: thumpHeight,
                index: index,
                meetUs: meetUs,
                service: service,
                product: product,
                calendar: calendar,
                album: album,
                blog: blog,
                download: download,
                order: order,
                contact: contact,
                general: general,
                myaccount: myaccount,
                webStore: webStore,
                images: images,
                files: files
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
