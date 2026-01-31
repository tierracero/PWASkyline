//
//  getSocialAccountRefrence.swift
//  
//
//  Created by Victor Cantu on 4/21/23.
//

import Foundation
import TCFundamentals
import Web

public var getSocialAccountRefrenceListenerByUUID: [ UUID : State<CustSocialAccounts?> ] = [:]
public var getSocialAccountRefrenceListenerByToken: [ String : State<CustSocialAccounts?> ] = [:]

func getSocialAccountRefrence(id: HybridIdentifier, callback: @escaping ( (_ user: CustSocialAccounts?) -> () ) ){
    
    switch id {
    case .id(let uUID):
        if let user = socialAccountCathtByUUID[uUID] {
            callback(user)
            return
        }
        
        if let state = getSocialAccountRefrenceListenerByUUID[uUID] {
            state.listen {
                callback($0)
            }
            debugPrint("🤖 getSocialAccountRefrence Waiting Async [UUID]")
            return
        }
        
        @State var idListener: CustSocialAccounts? = nil
        
        getSocialAccountRefrenceListenerByUUID[uUID] = $idListener
        
    case .folio(let string):
        if let user = socialAccountCathtByToken[string] {
            callback(user)
            return
        }
        
        if let state = getSocialAccountRefrenceListenerByToken[string] {
            state.listen {
                callback($0)
            }
            debugPrint("🤖 getUserRefrence Waiting Async [String]")
            return
        }
        
        @State var folioListener: CustSocialAccounts? = nil
  
        getSocialAccountRefrenceListenerByToken[string] = $folioListener
        
    }
    
    API.custAPIV1.getSocialAccountRefrence(id: id) { accounts in

        guard let account = accounts.first else {
            showError(.generalError, "No se localizar informacion del usuario solicitado")
            return
        }
        
        socialAccountCathtByUUID[account.id] = account
        
        socialAccountCathtByToken[account.userid] = account
        
        switch id {
        case .id(let uUID):
            getSocialAccountRefrenceListenerByUUID[uUID]?.wrappedValue = account
            //getUserRefrenceListenerByUUID.removeValue(forKey: uUID)
        case .folio(let string):
            getSocialAccountRefrenceListenerByToken[string]?.wrappedValue = account
            //getUserRefrenceListenerByToken.removeValue(forKey: string)
        }
        
        callback(account)
        
    }
}

