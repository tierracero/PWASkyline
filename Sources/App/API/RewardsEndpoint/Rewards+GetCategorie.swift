//
//  Rewards+GetCategorie.swift
//  
//
//  Created by Victor Cantu on 2/17/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension RewardsComponents {
    
    /// - Parameters:
    ///   - categorie:airTime, packages, services, giftCards
    ///   - rewards: isRewardsAvailable
    public static func getCategorie(
        categorie: TaecelAPICore.Categorie,
        subCategorie: TaecelAPICore.SubCategorie?,
        rewards: Bool?,
        callback: @escaping ( (_ resp: APIResponseGeneric<[TaecelAPICore.CategoriesItem]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getCategorie",
            GetCategorieRequest(
                categorie: categorie,
                subCategorie: subCategorie,
                rewards: rewards
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[TaecelAPICore.CategoriesItem]>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadFIAccounts")
                print(error)
                callback(nil)
            }
        }
    }
}
