//
//  RentalStartsAt.swift
//  
//
//  Created by Victor Cantu on 3/16/22.
//

import Foundation

enum RentalStartsAt: String, Codable {
	case rightNow
	case sameDay
	case nextDay
	
	var description: String {
		switch self {
		case .rightNow:
			return "En el momento"
		case .sameDay:
			return "Mismo Dia"
		case .nextDay:
			return "Siguiente Dia"
		}
	}
}
