//
//  SuccessMessagesTitles.swift
//  
//
//  Created by Victor Cantu on 2/17/22.
//

import Foundation

public enum SuccessMessagesTitles: String {
	
	case operacionExitosa
	
    public var description: String {
		switch self {
		case .operacionExitosa:
			return "Operacion Exitosa"
		}
	}
	
}
