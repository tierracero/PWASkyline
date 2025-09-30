//
//  ApiResponse.swift
//  
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

struct ApiResponse: Codable {
    
	let status: APIResponseTypes
	let msg: String
	let id: UUID?
	let folio: String?
	let errcode: String
	
	init(
		status: APIResponseTypes = .nok,
		msg: String = "",
		id: UUID? = nil,
		folio: String? = nil,
		errcode: String = "none"
	) {
		self.status = status
		self.msg = msg
		self.id = id
		self.folio = folio
		self.errcode = errcode
	}
}

struct ApiResponseGeneric<T> : Codable where T: Codable {
	var status: APIResponseTypes
	var msg: String = ""
	var data: T
	var errcode: String
	init(
		status: APIResponseTypes = .nok,
		msg: String = "",
		data: T,
		errcode: String = "none"
	) {
		self.status = status
		self.msg  = msg
		self.data = data
		self.errcode = errcode
	}
}

