//
//  InputTel.swift
//  
//
//  Created by Victor Cantu on 8/25/22.
//

import Foundation
import Web

extension InputTel{
    @discardableResult
    public func leftImage(img: String) -> Self {
        self.backgroundImage(img)
            .backgroundRepeat(.noRepeat)
            .paddingLeft(42.px)
            .custom("background-position", "4px 8px")
            .backgroundSize(h: 32.px, v: 32.px)
        
        return self
    }
    
    @discardableResult
    public func onReturn(_ handler: @escaping () -> Void) -> Self {
        self.onKeyUp { input, event in
            if event.code == "Enter" || event.code == "NumpadEnter" {
                handler()
            }
        }
        return self
    }
    
    @discardableResult
    public func onReturn(_ handler: @escaping (_ input: Self) -> Void) -> Self {
        self.onKeyUp { input, event in
            if event.code == "Enter" || event.code == "NumpadEnter" {
                handler(self)
            }
        }
        return self
    }
}

