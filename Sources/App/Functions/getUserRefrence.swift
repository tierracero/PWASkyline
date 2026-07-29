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
            return
        }
        
        @State var userFolioListener: CustUsername? = nil
  
        getUserRefrenceListenerByToken[string] = $userFolioListener
        
    }
    
    loadingView(show: true)
    
    API.custAPIV1.getUserRefrence(id: id) { resp in
    
        loadingView(show: false)
        
        guard let resp else {
            finishUserReferenceRequest(id: id, user: nil)
            showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
            return
        }

        guard resp.status == .ok else {
            finishUserReferenceRequest(id: id, user: nil)
            showError(.generalError, resp.msg)
            return
        }
        
        guard let data = resp.data else {
            finishUserReferenceRequest(id: id, user: nil)
            showError(.unexpectedResult, .unexpenctedMissingPayload)
            return
        }
        
        guard let uname = data.users.first else {
            finishUserReferenceRequest(id: id, user: nil)
            showError(.generalError, "No se localizar informacion del usuario solicitado")
            return
        }

        finishUserReferenceRequest(id: id, user: uname)
        
        userCathByUUID[uname.id] = uname
        
        userCathByToken[uname.usertoken] = uname
        
        callback(uname)
        
    }
}

private func finishUserReferenceRequest(
    id: HybridIdentifier,
    user: CustUsername?
) {
    switch id {
    case .id(let userId):
        getUserRefrenceListenerByUUID[userId]?.wrappedValue = user
        getUserRefrenceListenerByUUID.removeValue(forKey: userId)
    case .folio(let token):
        getUserRefrenceListenerByToken[token]?.wrappedValue = user
        getUserRefrenceListenerByToken.removeValue(forKey: token)
    }
}
