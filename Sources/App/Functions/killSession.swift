//
//  killSession.swift
//  
//
//  Created by Victor Cantu on 5/29/22.
//

import Foundation
import Web

public func killSession(){
    
    var cc = 0
    
    while cc <  WebApp.current.window.localStorage.length {
        if let key = WebApp.current.window.localStorage.key(at: cc) {
            if key.starts(with: "conserve") {
                return
            }
            WebApp.current.window.localStorage.removeItem(forKey: key)
        }
        cc += 1
    }
    
    /*
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchUser")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchToken")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchMid")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchKey")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchID")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchStore")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchGroop")
    WebApp.current.window.localStorage.removeItem(forKey: "linkedProfile")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchHerk")
    WebApp.current.window.localStorage.removeItem(forKey: "activeSession")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchChatConnID")
    WebApp.current.window.localStorage.removeItem(forKey: "custCatchChatToken")
     */
}
