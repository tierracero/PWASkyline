//
//  loadBasicStatus.swift
//  
//
//  Created by Victor Cantu on 5/29/22.
//

import Foundation
import TCFundamentals
import JavaScriptKit
import Web

public func loadBasicStatus(
    callback: @escaping ( (
        _ status: GeneralStatus?
    ) -> () )
){
    
    let activeSession = WebApp.current.window.localStorage.string(forKey: "activeSession") ?? ""
        
    let today = "\(JSDate().fullYear)\(JSDate().month)\(JSDate().day)"
    
    if activeSession != today {
        print("⭕️ I have NO a session (or valid session)")
        killSession()
        callback(nil)
    }
    else{
        
        // Get Strings from settings
        guard let _custCatchUser = WebApp.current.window.localStorage.string(forKey: "custCatchUser") else {
            killSession()
            callback(nil)
            return
        }
        
        guard let __custCatchHerk = WebApp.current.window.localStorage.string(forKey: "custCatchHerk") else {
            killSession()
            callback(nil)
            return
        }
        guard let _custCatchToken = WebApp.current.window.localStorage.string(forKey: "custCatchToken") else {
            killSession()
            callback(nil)
            return
        }
        guard let _custCatchMid = WebApp.current.window.localStorage.string(forKey: "custCatchMid") else {
            killSession()
            callback(nil)
            return
        }
        guard let _custCatchKey = WebApp.current.window.localStorage.string(forKey: "custCatchKey") else {
            killSession()
            callback(nil)
            return
        }
        guard let __custCatchID = WebApp.current.window.localStorage.string(forKey: "custCatchID") else {
            killSession()
            callback(nil)
            return
        }
        guard let __custCatchStore = WebApp.current.window.localStorage.string(forKey: "custCatchStore") else {
            killSession()
            callback(nil)
            return
        }
        guard let __custCatchGroop = WebApp.current.window.localStorage.string(forKey: "custCatchGroop") else {
            killSession()
            callback(nil)
            return
        }
        
        guard let _custCatchMyChatToken = WebApp.current.window.localStorage.string(forKey: "custCatchMyChatToken") else {
            killSession()
            callback(nil)
            return
        }
        
        guard let str = WebApp.current.window.localStorage.string(forKey: "linkedProfile") else {
            killSession()
            callback(nil)
            return
        }
        
        guard let _panelMode = PanelMode(rawValue: (WebApp.current.window.localStorage.string(forKey: "panelMode") ?? "") ) else {
            killSession()
            
            print("❌ panel mode ❌")
            
            callback(nil)
            return
        }
        
        // convert String to proper data types
        guard let _custCatchHerk = Int(__custCatchHerk) else {
            killSession()
            callback(nil)
            return
        }
        guard let _custCatchID = UUID(uuidString: __custCatchID) else {
            killSession()
            callback(nil)
            return
        }
        guard let _custCatchStore = UUID(uuidString: __custCatchStore) else {
            killSession()
            callback(nil)
            return
        }
        guard let _custCatchGroop = UUID(uuidString: __custCatchGroop) else {
            killSession()
            callback(nil)
            return
        }

        pDir = WebApp.current.window.localStorage.string(forKey: "custCatchPDir") ?? "" 

        custCatchAccountType = TCAccountType(rawValue: (WebApp.current.window.localStorage.string(forKey: "custCatchAccountType") ?? "") ) ?? .buisness

        custCatchUser = _custCatchUser
        custCatchHerk = _custCatchHerk
        custCatchToken = _custCatchToken
        custCatchMid = _custCatchMid
        custCatchKey = _custCatchKey
        custCatchID = _custCatchID
        custCatchMyChatToken = _custCatchMyChatToken
        custCatchStore = _custCatchStore
        custCatchGroop = _custCatchGroop
        panelMode = _panelMode

        CatchControler.shared.loadTaskAlertsFromLocalDatabase(
            userId: _custCatchID,
            username: _custCatchUser
        )

        ErrorReportingControler.shared.sessionDidBecomeAvailable()
        
        print("⭐️  panelMode \(panelMode)")

        if custCatchAccountType == .entrepreneur {
            custCatchUrl = "skyline.tierracero.com"
            skylineUrlPatch = "/\(pDir)"
        } else {
            if let _url = custCatchUser.explode("@").last {
                custCatchUrl = _url
            }
        }

        print("⭐️  custCatchUrl \(custCatchUrl)")
        print("⭐️  skylineUrlPatch \(skylineUrlPatch)")

        
        if let data = str.data(using: .utf8) {
            do {
                linkedProfile = try JSONDecoder().decode([PanelConfigurationObjects].self, from: data)
            }
            catch{
                print(error)
                killSession()
                callback(nil)
            }
        }
        
        API.custAPIV1.accountStatus { resp in
            
            guard let resp else {
                print("🔴   API.custAPIV1.sincCustSettings 001")
                callback(nil)
                return
            }
            
            if resp.status != .ok {
                print("🔴   API.custAPIV1.sincCustSettings 002")
                callback(nil)
                return
            }
            
            guard let status = resp.data?.status else {
                print("🔴   API.custAPIV1.sincCustSettings 003")
                callback(nil)
                return
            }

            callback(status)

        }        
    }
}
