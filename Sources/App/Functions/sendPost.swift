//
//  sendPost.swift
//  
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

public func sendPost<T: Codable> (
    _ route: ServerRouts,
    _ version: ServerVersion?,
    _ service: String,
    _ auth: String,
    _ codable: T,
    callback: @escaping ( (_ payload: Foundation.Data?) -> () )
) {
    
    var server = "https://intratc.co/api"
    
    if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
        switch developmentMode {
            case .local:
                server = "http://localhost:8800/api"    
            case .develpment:
                server = "http://dev.tierracero.co/api"
            case .produccion:
                break
        }
    }

    

    
    var url = "\(server)/\(route.rawValue)"
    
    if let version {
        url += version.rawValue
    }
    
    if !service.isEmpty {
        url += "/\(service)"
    }
    
    var payload = ""
    
    debugPrint("🟡 \(url)")
    
    do{
        let jsonData = try JSONEncoder().encode(codable)
        if let jsonString = String(data: jsonData, encoding: .utf8){
            payload = jsonString
        }
    }
    catch{
        callback(nil)
        return
    }
    
    debugPrint(payload)
    
    let xhr = XMLHttpRequest()
    
    xhr.open(method: "POST", url: url)
    
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")
        .setRequestHeader("Authorization", auth)
    
    print("PAYLOAD: \(WebApp.shared.window.location.hostname)")
    
    xhr.send(payload)
    
    xhr.onError {
        print("🌎  ERROR \(url)")
        callback(nil)
    }
    xhr.onLoad {
//        print("onLoad")
//        print("🟢 \(url)")
        callback(xhr.responseText?.data(using: .utf8))
    }
}

public func sendPost<T: Codable> (
	_ route: ServerRouts,
	_ version: ServerVersion?,
	_ service: String,
	_ codable: T,
	callback: @escaping ( (_ payload: Foundation.Data?) -> () )
) {
    
    var server = "https://intratc.co/api"
    
    switch developmentMode {
        case .local:
            server = "https://localhost:8800/api"    
        case .develpment:
            server = "https://dev.tierracero.co/api"
        case .produccion:
            break
    }

    var url = "\(server)/\(route.rawValue)"
    
	if let version {
		url += version.rawValue
	}
	
	if !service.isEmpty {
		url += "/\(service)"
	}
	
	var payload = ""
    
    if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
        print("🟡 \(url)")
    }
    
	do{
		let jsonData = try JSONEncoder().encode(codable)
		if let jsonString = String(data: jsonData, encoding: .utf8){
			payload = jsonString
		}
	}
	catch{
		callback(nil)
		return
	}
	
    if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
        print("🟡 payload")
        print(payload)
    }
    
	let xhr = XMLHttpRequest()
	
	xhr.open(method: "POST", url: url)
	
	xhr.setRequestHeader("Accept", "application/json")
		.setRequestHeader("Content-Type", "application/json")
    
    if let jsonData = try? JSONEncoder().encode(APIHeader(
        AppID: thisAppID,
        AppToken: thisAppToken,
        user: custCatchUser,
        mid: custCatchMid,
        key: custCatchKey,
        token: custCatchToken,
        tcon: .web, 
        applicationType: .customer
    )){
        if let str = String(data: jsonData, encoding: .utf8){
            let utf8str = str.data(using: .utf8)
            if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
                    print("Authorization")
                    print(base64Encoded)
                }
                xhr.setRequestHeader("Authorization", base64Encoded)
            }
        }
    }
    
    print("PAYLOAD: \(WebApp.shared.window.location.hostname)")
    
	xhr.send(payload)
	
	xhr.onError {
        debugPrint("🌎  ERROR \(url)")
		callback(nil)
	}
	xhr.onLoad {
        
        print("HOSTNAME: \(WebApp.shared.window.location.hostname)")
        
        if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
            if let json = xhr.responseText {
                print("🟡 🟡 🟡 🟡 🟡 🟡 🟡 🟡 🟡 🟡 🟡 🟡 🟡 ")
                print(json)
            }
        }
        
		callback(xhr.responseText?.data(using: .utf8))
        
	}
}

public func sendPost<T: Codable> (
    _ url: String,
    _ codable: T,
    callback: @escaping ( (_ payload: Foundation.Data?) -> () )
) {
    
    var payload = ""
    
    do{
        let jsonData = try JSONEncoder().encode(codable)
        if let jsonString = String(data: jsonData, encoding: .utf8){
            payload = jsonString
        }
    }
    catch{
        callback(nil)
        return
    }
    
    debugPrint("🟡 \(url)")
    
    debugPrint(payload)
    
    let xhr = XMLHttpRequest()
    
    xhr.open(method: "POST", url: url)
    
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")
    
    if let jsonData = try? JSONEncoder().encode(APIHeader(
        AppID: thisAppID,
        AppToken: thisAppToken,
        user: custCatchUser,
        mid: custCatchMid,
        key: custCatchKey,
        token: custCatchToken,
        tcon: .web, 
        applicationType: .customer
    )){
        if let str = String(data: jsonData, encoding: .utf8){
            let utf8str = str.data(using: .utf8)
            if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                xhr.setRequestHeader("Authorization", base64Encoded)
            }
        }
    }
    
    print("PAYLOAD: \(WebApp.shared.window.location.hostname)")
    
    xhr.send(payload)
    
    xhr.onError {
        print("🌎  ERROR \(url)")
        callback(nil)
    }
    xhr.onLoad {
//        print("onLoad")
//        print("🟢 \(url)")
        callback(xhr.responseText?.data(using: .utf8))
    }
}
