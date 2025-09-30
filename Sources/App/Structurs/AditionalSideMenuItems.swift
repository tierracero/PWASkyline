//
//  AditionalSideMenuItems.swift
//  
//
//  Created by Victor Cantu on 6/4/22.
//

import Foundation


public struct AditionalSideMenuItems: Codable {
    
    public let name: String
    public let smallDescription: String
    public let avatar: String
    public let link: String
    public let herk: Int
    
    public init(
        name: String,
        smallDescription: String,
        avatar: String,
        link: String,
        herk: Int
    ) {
        self.name = name
        self.smallDescription = smallDescription
        self.avatar = avatar
        self.link = link
        self.herk = herk
    }
    
}
