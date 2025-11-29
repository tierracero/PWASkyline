//
//  Theme+SaveWebIndex.swift
//  
//
//  Created by Victor Cantu on 1/20/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func saveWebIndex(
        configLanguage: LanguageCode,
        metaTitle: String,
        metaDescription: String,
        title: String,
        description: String,
        mainText: String,
        subText: String,
        carouselOneText: String,
        carouselOneSecondaryText: String,
        carouselOneBtnIsActive: Bool,
        carouselOneBtnText: String,
        carouselOneBtnLink: String,
        carouselTwoText: String,
        carouselTwoSecondaryText: String,
        carouselTwoBtnIsActive: Bool,
        carouselTwoBtnText: String,
        carouselTwoBtnLink: String,
        carouselThreeText: String,
        carouselThreeSecondaryText: String,
        carouselThreeBtnIsActive: Bool,
        carouselThreeBtnText: String,
        carouselThreeBtnLink: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveWebIndex",
            SaveWebIndexRequest(
                configLanguage: configLanguage,
                metaTitle: metaTitle,
                metaDescription: metaDescription,
                title: title,
                description: description,
                mainText: mainText,
                subText: subText,
                carouselOneText: carouselOneText,
                carouselOneSecondaryText: carouselOneSecondaryText,
                carouselOneBtnIsActive: carouselOneBtnIsActive,
                carouselOneBtnText: carouselOneBtnText,
                carouselOneBtnLink: carouselOneBtnLink,
                carouselTwoText: carouselTwoText,
                carouselTwoSecondaryText: carouselTwoSecondaryText,
                carouselTwoBtnIsActive: carouselTwoBtnIsActive,
                carouselTwoBtnText: carouselTwoBtnText,
                carouselTwoBtnLink: carouselTwoBtnLink,
                carouselThreeText: carouselThreeText,
                carouselThreeSecondaryText: carouselThreeSecondaryText,
                carouselThreeBtnIsActive: carouselThreeBtnIsActive,
                carouselThreeBtnText: carouselThreeBtnText,
                carouselThreeBtnLink: carouselThreeBtnLink
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
