//
//  Img.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web

extension Img {
    
    public var rowDefaultImage128: Img {
        Img().src("/skyline/media/icon_general_statusl@128.png")
    }
    public var rowDefaultImage256: Img {
        Img().src("/skyline/media/icon_general_statusl@256.png")
    }
    public var rowDefaultImage512: Img {
        Img().src("/skyline/media/icon_general_statusl@512.png")
    }
    
    public func closeButton(_ id: CrossButtonIdName) -> Img{
        self.src("/skyline/media/cross.png")
        self.float(.right)
        //self.marginTop(5.px)
        self.marginRight(7.px)
        self.cursor(.pointer)
        self.width(24.px)
        self.id(Id(stringLiteral: id.rawValue))
        
        return self
        
    }
    
    public var backButton: Img {
        Img()
            .src("/skyline/media/backDarkOrange.png")
            .marginRight(7.px)
            .cursor(.pointer)
            .width(24.px)
    }
    
    public var backOrangeButton: Img{
        Img()
            .src("/skyline/media/backDarkOrange.png")
            .marginRight(7.px)
            .cursor(.pointer)
            .width(24.px)
    }
    
    public func helpButton() -> Img{
        self.src("/skyline/media/help.png")
        self.float(.right)
        //self.marginTop(5.px)
        self.marginRight(7.px)
        self.cursor(.pointer)
        self.width(24.px)
        
        return self
        
    }
    
}

