//
//  validateTimeFormat.swift
//
//
//  Created by Victor Cantu on 11/4/24.
//

import Foundation

func validateTimeFormat(
    time: String,
    error: @escaping (
        _ title: String,
        _ message: String
    ) -> ()
){
    
    guard !time.isEmpty else {
        error("Campo Requerido", "Ingrese hora de envio/recepcion")
        return
    }
    
    if !time.contains(":") {
        error("Formato de hora invalida", "La hora debe de tener el siguente formato:\nHH:MM")
        return
    }
    
    let hourParts = time.explode(":")
    
    if hourParts.count != 2 {
        error("Formato de fecha invalida", "La hora debe de tener el siguente formato:\nHH:MM")
        return
    }
    
    guard let hour = Int(hourParts[0]) else {
        error("Formato de fecha invalida", "Hora invalido, ingrese una hora valido entre 1 y el 24")
        return
    }
    
    guard (hour >= 0 && hour < 25) else {
        error("Formato de fecha invalida", "Hora invalido, ingrese una hora valido entre 1 y el 24.")
        return
    }
    
    guard let min = Int(hourParts[1]) else {
        error("Formato de fecha invalida", "Minuto invalido, ingrese un minito valido entre 0 y el 59")
        return
    }
    
    guard (min >= 0 && min < 60) else {
        error( "Formato de fecha invalida", "Minuto invalido, ingrese un minito valido entre 0 y el 59.")
        return
    }
    
}
