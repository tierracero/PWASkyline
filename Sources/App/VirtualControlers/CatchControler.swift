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

    private var favoriteVendorCacheUserID: UUID?

    private var loadedFavoriteVendorCacheUserID: UUID?

    private var favoriteVendorOverrides: [UUID: CustVendorsQuick] = [:]

    private(set) var favoriteVendors: [CustVendorsQuick] = []

    func cachedFavoriteVendors(for userID: UUID) -> [CustVendorsQuick]? {
        guard favoriteVendorCacheUserID == userID,
              loadedFavoriteVendorCacheUserID == userID else {
            return nil
        }

        return favoriteVendors
    }

    func cacheFavoriteVendors(_ vendors: [CustVendorsQuick], for userID: UUID) {
        guard custCatchID == userID else {
            return
        }

        var cachedVendors = vendors.filter { $0.favorite }

        for vendor in favoriteVendorOverrides.values {
            if let index = cachedVendors.firstIndex(where: { $0.id == vendor.id }) {
                if vendor.favorite {
                    cachedVendors[index] = vendor
                }
                else {
                    cachedVendors.remove(at: index)
                }
            }
            else if vendor.favorite {
                cachedVendors.append(vendor)
            }
        }

        favoriteVendors = cachedVendors
        favoriteVendorOverrides.removeAll()
        favoriteVendorCacheUserID = userID
        loadedFavoriteVendorCacheUserID = userID
    }

    func updateFavoriteVendor(_ vendor: CustVendorsQuick, for userID: UUID) {
        guard custCatchID == userID else {
            return
        }

        if favoriteVendorCacheUserID != userID {
            favoriteVendors = []
            favoriteVendorCacheUserID = userID
            loadedFavoriteVendorCacheUserID = nil
            favoriteVendorOverrides = [:]
        }

        if loadedFavoriteVendorCacheUserID != userID {
            favoriteVendorOverrides[vendor.id] = vendor
        }

        if vendor.favorite {
            if let index = favoriteVendors.firstIndex(where: { $0.id == vendor.id }) {
                favoriteVendors[index] = vendor
            }
            else {
                favoriteVendors.append(vendor)
            }
        }
        else {
            favoriteVendors.removeAll { $0.id == vendor.id }
        }
    }

    func clearFavoriteVendors() {
        favoriteVendors = []
        favoriteVendorCacheUserID = nil
        loadedFavoriteVendorCacheUserID = nil
        favoriteVendorOverrides = [:]
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
