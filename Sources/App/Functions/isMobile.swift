//
//  isMobile.swift
//  
//
//  Created by Victor Cantu on 3/21/22.
//

import Foundation
import TCFundamentals
import Web

/// Cheke is its a mobile bronwser
/// - Returns `Optinal`: iOS, Android, Other
func isMobile() -> PushNotificationTokensPlatform? {
	
	let agent = WebApp.current.window.navigator.userAgent.lowercased()
	var type: PushNotificationTokensPlatform? = nil
	
	///  iOS, Android, Safari, Chrome, Fierfox, Windows, Other
	["android","webos","iphone","ipad","ipod","blackberry","iemobile","opera","mini"].forEach { platform in
		if agent.contains(platform) {
			
			if platform == "android" {
				type = .Android
			}
			else if platform == "iphone" || platform == "ipad" || platform == "ipod" {
				type = .iOS
			}
			else{
				type = .Other
			}
			
			
		}
	}
	
	return type
	
}
