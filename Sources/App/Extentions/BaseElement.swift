//
//  BaseElement.swift
//  
//
//  Created by Victor Cantu on 3/20/22.
//

import Foundation
import Web

extension BaseElement {
	@discardableResult
	public func remove() -> Self {
		domElement.remove.function?.callAsFunction(optionalThis: jsValue.object)
		return self
	}
}
