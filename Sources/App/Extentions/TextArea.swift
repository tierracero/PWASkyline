//
//  TextArea.swift
//  
//
//  Created by Victor Cantu on 9/3/23.
//

import Foundation
import Web

extension TextArea {
    @discardableResult
    public func onEnter(_ handler: @escaping (_ input: Self) -> Void) -> Self {
        self.onKeyUp { input, event in
            if event.code == "Enter" || event.code == "NumpadEnter" {
                handler(self)
            }
        }
        return self
    }
}
