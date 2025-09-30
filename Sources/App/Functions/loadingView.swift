//
//  loadingView.swift
//  
//
//  Created by Victor Cantu on 3/20/22.
//

import Foundation
import Web
public func loadingView (show: Bool, message: String = "") {
	
	if show {
        WebApp.current.loadingView.fadeIn( begin: .display(.block))
//        WebApp.current.loadingView
//            .display(.block)
//            .filter(.opacity(100))
		return
	}
	
    WebApp.current.loadingView.fadeOut( end: .hidden)
//    WebApp.current.loadingView
//        .display(.none)
//        .filter(.opacity(0))
}

public func faseOutLoadingView () {
	WebApp.current.loadingView.fadeOut( end: .hidden)
}