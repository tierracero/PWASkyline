//
//  WeekDays.swift
//  
//
//  Created by Victor Cantu on 3/13/22.
//

import Foundation

enum WeekDays: String, Codable, CaseIterable {
	
	case domingo
	case lunes
	case martes
	case miercoles
	case jueves
	case viernes
	case sabado
	
	var description: String {
		switch self{
		case .domingo:
			return "Domingo"
		case .lunes:
			return "Lunes"
		case .martes:
			return "Martes"
		case .miercoles:
			return "Miercoles"
		case .jueves:
			return "Jueves"
		case .viernes:
			return "Viernes"
		case .sabado:
			return "Sabado"
		}
	}
	
}
