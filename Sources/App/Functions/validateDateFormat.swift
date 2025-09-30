//
//  validateDateFormat.swift
//
//
//  Created by Victor Cantu on 11/4/24.
//

import Foundation

func validateDateFormat(
    date: String,
    error: @escaping (
        _ title: String,
        _ message: String
    ) -> ()
){
    
    guard !date.isEmpty else {
        error("Campo Rwquerido", "Ingrese fecha de envio/recepcion")
        return
    }
    
    if !date.contains("/") {
        error("Formato de fecha invalida", "La fecha debe de tener el siguente formato:\nDD/MM/AAAA")
        return
    }
    
    let dateParts = date.explode("/")
    
    if dateParts.count != 3 {
        error("Formato de fecha invalida", "La fecha debe de tener el siguente formato:\nDD/MM/AAAA")
        return
    }
    
    guard let day = Int(dateParts[0]) else {
        error("Formato de fecha invalida", "Dia invalido, ingrese un dia valido entre 1 y el 31")
        return
    }
    
    guard (day > 0 && day < 32) else {
        error("Formato de fecha invalida", "Dia invalido, ingrese un dia valido entre 1 y el 31.")
        return
    }
    
    guard let month = Int(dateParts[1]) else {
        error("Formato de fecha invalida", "Mes invalido, ingrese un mes valido entre 1 y el 12.")
        return
    }
    
    guard (month > 0 && month < 13) else {
        error("Formato de fecha invalida", "Mes invalido, ingrese un mes valido entre 1 y el 12.")
        return
    }
    
    guard let year = Int(dateParts[2]) else {
        error("Formato de fecha invalida", "Ingrese un año valido.")
        return
    }
    
}
