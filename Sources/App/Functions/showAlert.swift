//
//  showAlert.swift
//  
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import JavaScriptKit
import Web

public func showAlert(_ title: AlertMessagesTitles,_ msg: String,_ time: TimeLength = .medium){
	
	let grid = ShowAlert(title: title.description, message: msg)
	
    WebApp.current.messageGrid.appendChild(grid)
	
	grid.opacity(1)
		.fadeIn( begin: .display(.block))
//        .display(.block)
//        .filter(.opacity(100))
	
	Dispatch.asyncAfter(time.rawValue) {
        grid.fadeOut(end:.hidden){
            grid.remove()
        }
	}

}
