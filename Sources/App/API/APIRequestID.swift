//
//  APIRequestID.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation

struct APIRequestID: Codable {
	let id: UUID
	let store: UUID?
    
    init(
        id: UUID,
        store: UUID?
    ){
        self.id = id
        self.store = store
    }
    
}
struct APIRequestIDOptional: Codable {
	let id: UUID?
	let store: UUID?
}
