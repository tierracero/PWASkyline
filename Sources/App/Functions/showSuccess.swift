//
//  showSuccess.swift
//  
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import JavaScriptKit
import Web

public func showSuccess(_ title: SuccessMessagesTitles,_ msg: String,_ time: TimeLength = .medium){
	
	let grid = ShowSuccess(title: title.description, message: msg)
	
    WebApp.current.messageGrid.appendChild(grid)
	
	grid.opacity(1)
		.fadeIn( begin: .display(.block))
//        .display(.block)
//        .filter(.opacity(100))
	
	Dispatch.asyncAfter(time.rawValue) {
		grid.fadeOut(end:.hidden){
			grid.remove()
		}
//        grid.remove()
	}
	
}

