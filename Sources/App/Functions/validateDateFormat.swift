//
//  validateDateFormat.swift
//
//
//  Created by Victor Cantu on 11/4/24.
//

import Foundation

struct ValidatFormatError  {
    var title: String
    var message: String

    init(
        _ title: String,
        _ message: String
    ){
        self.title = title
        self.message = message
    }
}

func validateDateFormat(
    date: String
) -> ValidatFormatError? {
    
    guard !date.isEmpty else {
        return .init("Campo Rwquerido", "Ingrese fecha de envio/recepcion")
        
    }
    
    if !date.contains("/") {
        return .init("Formato de fecha invalida", "La fecha debe de tener el siguente formato:\nDD/MM/AAAA")
    }
    
    let dateParts = date.explode("/")
    
    if dateParts.count != 3 {
        return .init("Formato de fecha invalida", "La fecha debe de tener el siguente formato:\nDD/MM/AAAA")
    }
    
    guard let day = Int(dateParts[0]) else {
        return .init("Formato de fecha invalida", "Dia invalido, ingrese un dia valido entre 1 y el 31")
    }
    
    guard (day > 0 && day < 32) else {
        return .init("Formato de fecha invalida", "Dia invalido, ingrese un dia valido entre 1 y el 31.")
    }
    
    guard let month = Int(dateParts[1]) else {
        return .init("Formato de fecha invalida", "Mes invalido, ingrese un mes valido entre 1 y el 12.")
    }
    
    guard (month > 0 && month < 13) else {
        return .init("Formato de fecha invalida", "Mes invalido, ingrese un mes valido entre 1 y el 12.")
    }
    
    guard let year = Int(dateParts[2]) else {
        return .init("Formato de fecha invalida", "Ingrese un año valido.")
    }
    
    return nil
    
}
