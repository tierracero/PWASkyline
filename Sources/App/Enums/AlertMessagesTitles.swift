//
//  AlertMessagesTitles.swift
//  
//
//  Created by Victor Cantu on 2/17/22.
//

import Foundation

public enum AlertMessagesTitles: String {
	case alerta
	
	public var description: String {
		switch self {
		case .alerta:
			return "Alerta"
		}
	}
	
}
