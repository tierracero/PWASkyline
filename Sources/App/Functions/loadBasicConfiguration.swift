//
//  loadBasicConfiguration.swift
//  
//
//  Created by Victor Cantu on 5/29/22.
//

import Foundation
import TCFundamentals
import JavaScriptKit
import Web

public func loadBasicConfiguration( callback: @escaping ( (
    _ status: GeneralStatus?) -> () )
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
        
        print("⭐️  panelMode \(panelMode)")
        
        if let _url = custCatchUser.explode("@").last {
            custCatchUrl = _url
        }
        
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
        
        loadingView(show: true)
        
        API.custAPIV1.sincCustSettings { resp in
            
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
            
            guard let settings = resp.data else {
                print("🔴   API.custAPIV1.sincCustSettings 003")
                callback(nil)
                return
            }
            
            tcaccount = settings.account
            
            custWebFilesLogos = settings.custWebFilesLogos
            
            configStoreProduct = settings.configStoreProduct
            
            configContactTags = settings.configContactTags
            
            configServiceTags = settings.configServiceTags

            configStoreProcessing = settings.configStoreProcessing
            
            if WebApp.current.window.localStorage.string(forKey: "viewType") == nil {
                /// ``list, calendar``
                WebApp.current.window.localStorage.set(
                    JSString(configStoreProcessing.gridView.rawValue),
                    forKey: "viewType"
                )
            }
            
            configGeneral = settings.configGeneral
            
            customerServiceProfile = settings.customerServiceProfile
            
            custOperationWorkProfile = settings.custOperationWorkProfile
            
            configStore = settings.configStore
            
            alertManagerConfiguration = settings.alertManagerConfiguration
            
            MercadoLibreControler.shared.profile = settings.mercadoLibreProfile
            
            WebApp.shared.skyline.orcScripts = settings.orcScripts
            
            if settings.account.status != .active {
                callback(settings.account.status)
                return
            }
            
            API.fiscalV1.getProfile(type: .general, relation: nil) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    return
                }
                
                guard resp.status == .ok else{
                    return
                }
                
                guard let data = resp.data else {
                    return
                }


                fiscalProfile = data

                fiscalProfiles = data.profiles
                
                API.custAPIV1.getUserRefrence(id: nil) { resp in
                    
                    guard let resp else {
                        return
                    }
                    
                    if resp.status != .ok {
                        return
                    }
                    
                    guard let data = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }
                    
                    data.users.forEach { user in
                        userCathByUUID[user.id] = user
                    }
                }
                
                API.custAPIV1.sincStore { resp in
                    
                    guard let resp else {
                        return
                    }
                    
                    if resp.status != .ok {
                        return
                    }
                    
                    guard let data = resp.data else {
                        return
                    }

                    OrderCatchControler.shared.stores = data.stores.map{.init(
                        id: $0.id,
                        name: $0.name,
                        mainStore: $0.mainStore,
                        telephone: $0.telephone,
                        mobile: $0.mobile,
                        email: $0.email,
                        street: $0.street,
                        colony: $0.colony,
                        city: $0.city,
                        state: $0.state,
                        schedulea: $0.schedulea,
                        scheduleb: $0.scheduleb,
                        schedulec: $0.schedulec,
                        lat: $0.lat,
                        lon: $0.lon
                    )}
                    
                    data.stores.forEach { store in
                        stores[store.id] = store
                        
                        if store.id == custCatchStore {
                            
                            OrderCatchControler.shared.selectedStore = .init(
                                id: store.id,
                                name: store.name,
                                mainStore: store.mainStore,
                                telephone: store.telephone,
                                mobile: store.mobile,
                                email: store.email,
                                street: store.street,
                                colony: store.colony,
                                city: store.city,
                                state: store.state,
                                schedulea: store.schedulea,
                                scheduleb: store.scheduleb,
                                schedulec: store.schedulec,
                                lat: store.lat,
                                lon: store.lon
                            )
                        }
                    }
                    
                    data.bodegas.forEach { _bodegas in
                        bodegas[_bodegas.id] = _bodegas
                    }
                    
                    data.seccion.forEach { _seccion in
                        seccions[_seccion.id] = _seccion
                    }
                    
                }
                
                API.custAPIV1.getBankAccounts { resp in
                    
                    guard let resp = resp else {
                        return
                    }
                    
                    if resp.status != .ok {
                        return
                    }

                    guard let data = resp.data else {
                        return
                    }
    
                    mybanks = data.banks
                }
                
                API.custOrderV1.getOrderManagerItems{ resp in
                    
                    guard let resp  else {
                        return
                    }
                    
                    guard resp.status == .ok else {
                        return
                    }
                    

                    guard let data = resp.data else {
                        return
                    }
    

                    orderManagerType = data.orderManagerType
                    
                    orderManagerBrand = data.orderManagerBrand
                    
                    orderManagerModel = data.orderManagerModel
                    
                }
                
                getWorkLoadPayload()
                
            }
            
            callback(settings.account.status)
            
        }
        
        
    }
}

