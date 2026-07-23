//
//  CatchControler.swift
//
//
//  Created by Victor Cantu on 10/25/24.
//

import Foundation
import TCFundamentals
import Web
//@State

private var _shared: CatchControler?

public final class CatchControler {

    public static var shared: CatchControler {
        guard let shared = _shared else {
            let shared = CatchControler()
            _shared = shared
            return shared
        }
        return shared
    }

    @State var taskAlerts: [CustTaskAuthorizationManagerQuick] = []

    private func taskAlertsStorageKey(userId: UUID, username: String) -> String {
        "taskAlerts_\(userId.uuidString)_\(username.lowercased())"
    }

    func loadTaskAlertsFromLocalDatabase(userId: UUID, username: String) {
        let storageKey = taskAlertsStorageKey(userId: userId, username: username)

        guard let json = WebApp.current.window.localStorage.string(forKey: storageKey) else {
            taskAlerts = []
            return
        }

        guard
            let data = json.data(using: .utf8),
            let cachedAlerts = try? JSONDecoder().decode(
                [CustTaskAuthorizationManagerQuick].self,
                from: data
            )
        else {
            WebApp.current.window.localStorage.removeItem(forKey: storageKey)
            taskAlerts = []
            return
        }

        taskAlerts = cachedAlerts
    }

    func syncTaskAlerts(_ alerts: [CustTaskAuthorizationManagerQuick]) {
        taskAlerts = alerts

        guard !custCatchUser.isEmpty else {
            return
        }

        guard
            let data = try? JSONEncoder().encode(alerts),
            let json = String(data: data, encoding: .utf8)
        else {
            return
        }

        WebApp.current.window.localStorage.set(
            json,
            forKey: taskAlertsStorageKey(userId: custCatchID, username: custCatchUser)
        )
    }

    func clearTaskAlerts() {
        if !custCatchUser.isEmpty {
            WebApp.current.window.localStorage.removeItem(
                forKey: taskAlertsStorageKey(userId: custCatchID, username: custCatchUser)
            )
        }

        taskAlerts = []
    }
    
    /// [ Country : [ State : [PostalCodesMexico] ]]
    public var cityRefrence: [Countries: [ String : [PostalCodesMexicoItem] ]] = [:]
    
    func setCityRefrence( country: Countries, state: String, cities: [PostalCodesMexicoItem]) {
        
        if let _ = cityRefrence[country] {
            
            cityRefrence[country]?[state] = cities
            
        }
        else {
            cityRefrence[country] = [state: cities]
        }
        
    }
    
    
    /// [ Country : [ State : City:   [PostalCodesMexico]  ]]
    public var settelmentRefrence: [Countries: [ String: [ String : [PostalCodesMexicoItem] ] ] ] = [:]
    
    func setSettelmentRefrence( country: Countries, state: String, city: String, settlements: [PostalCodesMexicoItem]) {
        
        if let _ = settelmentRefrence[country] {
            
            if let _ = settelmentRefrence[country]?[state] {
                
                settelmentRefrence[country]?[state]?[city] = settlements
                
            }
            else {
                
                settelmentRefrence[country]?[state] = [ city: settlements ]
                
            }
            
        }
        else {
            
            settelmentRefrence[country] = [ state: [ city: settlements ]]
            
        }
    }
}
