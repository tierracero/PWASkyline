//
//  validateTimeFormat.swift
//
//
//  Created by Victor Cantu on 11/4/24.
//

import Foundation

func validateTimeFormat(
    time: String
) -> ValidatFormatError? {
    
    guard !time.isEmpty else {
        return .init("Campo Requerido", "Ingrese hora de envio/recepcion")
        
    }
    
    if !time.contains(":") {
        return .init("Formato de hora invalida", "La hora debe de tener el siguente formato:\nHH:MM")
    }
    
    let hourParts = time.explode(":")
    
    if hourParts.count != 2 {
        return .init("Formato de fecha invalida", "La hora debe de tener el siguente formato:\nHH:MM")
    }
    
    guard let hour = Int(hourParts[0]) else {
        return .init("Formato de fecha invalida", "Hora invalido, ingrese una hora valido entre 1 y el 24")
    }
    
    guard (hour >= 0 && hour < 25) else {
        return .init("Formato de fecha invalida", "Hora invalido, ingrese una hora valido entre 1 y el 24.")
    }
    
    guard let min = Int(hourParts[1]) else {
        return .init("Formato de fecha invalida", "Minuto invalido, ingrese un minito valido entre 0 y el 59")
    }
    
    guard (min >= 0 && min < 60) else {
        return .init( "Formato de fecha invalida", "Minuto invalido, ingrese un minito valido entre 0 y el 59.")
    }

    return nil
    
}
