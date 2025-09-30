//
//  RentalProductOptionType.swift
//  
//
//  Created by Victor Cantu on 3/15/22.
//

import Foundation

enum RentalProductOptionType: String, Codable {
	case selection
	case addSum
	case textField
	case textArea
	case checkBox
	case instruction
	
	var description: String {
		switch self {
		case .selection:
			return "Selección"
		case .addSum:
			return "AgregarQuitar"
		case .textField:
			return "Campo de Texto"
		case .textArea:
			return "Area de Texto"
		case .checkBox:
			return "Check Box"
		case .instruction:
			return "Instrucción"
		}
	}
	
}
