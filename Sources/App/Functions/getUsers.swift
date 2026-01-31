//
//  getUsers.swift
//  
//
//  Created by Victor Cantu on 4/26/23.
//

import Foundation
import TCFundamentals
import Web

/*
 
 public var userCathByUUID: [UUID:CustSocialAccounts] = [:]

 public var userCathByToken: [String:CustSocialAccounts] = [:]
 */

func getUsers(storeid: UUID?, onlyActive: Bool, callback: @escaping ( (_ users: [CustUsername]) -> () ) ){
    
    var users: [CustUsername] = []
    
    if hasGlobalyLoadedUsers {
       
        print("hasGlobalyLoadedUsers")
        
        print(userCathByUUID)
        
        if let storeid {
            
            print("by store")
            
            userCathByUUID.forEach { _, user in
                
                if onlyActive {
                    if user.status != .active {
                       return
                    }
                }
                
                print("----------")
                print(user.store)
                print("vs")
                print(storeid)
                print(user.status)
                
                if user.store == storeid {
                    users.append(user)
                }
                
            }
            
            callback(users)
        }
        else {
            
            userCathByUUID.forEach { _, user in
                
                if onlyActive {
                    if user.status != .active {
                       return
                    }
                }
                
                users.append(user)
                
            }
            
            callback(users)
        }
        
        return
    }
    
    loadingView(show: true)
    
    API.custAPIV1.getUserRefrence(id: nil) { resp in
    
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

        hasGlobalyLoadedUsers = true
        
        data.users.forEach { user in
            
            userCathByUUID[user.id] = user
            
            userCathByToken[user.usertoken] = user
            
        }
        
        if let storeid {
            
            print("⭐️  by store")
            
            userCathByUUID.forEach { _, user in
                
                if user.store == storeid {
                    
                    if onlyActive {
                        if user.status != .active {
                           return
                        }
                    }
                    
                    
                    print("----------")
                    print(user.store)
                    print("vs")
                    print(storeid)
                    print(user.status)
                    
                    
                    users.append(user)
                }
                
            }
            
            callback(users)
        }
        else {
            
            userCathByUUID.forEach { _, user in
                
                if onlyActive {
                    print("⭐️  by all")
                    if user.status != .active {
                       return
                    }
                }
                
                users.append(user)
                
            }
            
            callback(users)
        }
    }
}
