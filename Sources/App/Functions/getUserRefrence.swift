//
//  getUserRefrence.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

public var getUserRefrenceListenerByUUID: [ UUID : State<CustUsername?> ] = [:]
public var getUserRefrenceListenerByToken: [ String : State<CustUsername?> ] = [:]

func getUserRefrence(id: HybridIdentifier, callback: @escaping ( (_ user: CustUsername?) -> () ) ){
    
    switch id {
    case .id(let uUID):
        
        if let user = userCathByUUID[uUID] {
            callback(user)
            return
        }
        
        if let state = getUserRefrenceListenerByUUID[uUID] {
            state.listen {
                callback($0)
            }
            debugPrint("🤖 getUserRefrence Waiting Async [UUID]")
            return
        }
        
        @State var userIdListener: CustUsername? = nil
        
        getUserRefrenceListenerByUUID[uUID] = $userIdListener
        
    case .folio(let string):
        
        if let user = userCathByToken[string] {
            callback(user)
            return
        }
        
        if let state = getUserRefrenceListenerByToken[string] {
            state.listen {
                callback($0)
            }
            debugPrint("🤖 getUserRefrence Waiting Async [String]")
            return
        }
        
        @State var userFolioListener: CustUsername? = nil
  
        getUserRefrenceListenerByToken[string] = $userFolioListener
        
    }
    
    loadingView(show: true)
    
    API.custAPIV1.getUserRefrence(id: id) { resp in
    
        loadingView(show: false)
        
        guard let resp else {
            showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
            return
        }

        guard resp.status == .ok else {
            showError(.generalError, resp.msg)
            return
        }
        
        guard let data = resp.data else {
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }
        
        guard let uname = data.users.first else {
            showError(.generalError, "No se localizar informacion del usuario solicitado")
            return
        }
        
        switch id {
        case .id(let uUID):
            getUserRefrenceListenerByUUID[uUID]?.wrappedValue = uname
            //getUserRefrenceListenerByUUID.removeValue(forKey: uUID)
        case .folio(let string):
            getUserRefrenceListenerByToken[string]?.wrappedValue = uname
            //getUserRefrenceListenerByToken.removeValue(forKey: string)
        }
        
        userCathByUUID[uname.id] = uname
        
        userCathByToken[uname.usertoken] = uname
        
        callback(uname)
        
    }
}
