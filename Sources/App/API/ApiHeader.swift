//
//  ApiHeader.swift
//  
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation

struct ApiHeader: Codable {
	let AppID: String
	let user: String
	let mid: String
	let key: String
	let token: String
	let tcon: String
	init(
		AppID: String = "1000",
		user: String = "",//custCatchUser,
		mid: String = "",//custCatchMid,
		key: String = "",//custCatchKey,
		token: String = "",//custCatchToken,
		tcon: String = "web"
	) {
		self.AppID = AppID
		self.user = user
		self.mid = mid
		self.key =  key
		self.token = token
		self.tcon = tcon
	}
}
