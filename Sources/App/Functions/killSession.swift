//
//  killSession.swift
//  
//
//  Created by Victor Cantu on 5/29/22.
//

import Foundation
import Web

public func killSession(){
    
    WebApp.current.window.localStorage.clear()

    /*
    var cc = 0

    let length = WebApp.current.window.localStorage.length

    let conserveItemList: [String] = ["lastLoginUser", "EmailControlerViewMode"]

    while cc <  length {

            

        if let key = WebApp.current.window.localStorage.key(at: cc) {
            if !conserveItemList.contains(key) {
                WebApp.current.window.localStorage.removeItem(forKey: key)   
            }
        }
        
        cc += 1
    }
    */
    
}
