//
//  parseDate.swift
//  
//
//  Created by Victor Cantu on 3/1/23.
//

import Foundation

public func parseDate(date: String, time: String) -> Int64? {
    
    guard !date.isEmpty else {
        showError(.requiredField, "Ingrese fecha de envio/recepcion")
        return nil
    }
    
    if !date.contains("/") {
        
        print("001 date \(date)")
        
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    let dateParts = date.explode("/")
    
    if dateParts.count != 3 {
        print("002 date \(date)")
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard let day = Int(dateParts[0]) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Dia invalido, ingrese un dia valido entre 1 y el 31", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard (day > 0 && day < 32) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Dia invalido, ingrese un dia valido entre 1 y el 31.", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard let month = Int(dateParts[1]) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Mes invalido, ingrese un mes valido entre 1 y el 12.", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard (month > 0 && month < 13) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Mes invalido, ingrese un mes valido entre 1 y el 12.", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard let year = Int(dateParts[2]) else {
        return nil
    }
    
    guard year >= Date().year else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Año invalido, ingrese un año igual o mayor que al presente.", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard !time.isEmpty else {
        showError(.requiredField, "Ingrese hora de envio/recepcion")
        return nil
    }
    
    
    if !time.contains(":") {
        addToDom(ConfirmView(type: .ok, title: "Formato de hora invalida", message: "La hora debe de tener el siguente formato:\nHH:MM", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    let hourParts = time.explode(":")
    
    if hourParts.count != 2 {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "La hora debe de tener el siguente formato:\nHH:MM", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard let hour = Int(hourParts[0]) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Hora invalido, ingrese una hora valido entre 1 y el 24", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard (hour >= 0 && hour < 25) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Hora invalido, ingrese una hora valido entre 1 y el 24.", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard let min = Int(hourParts[1]) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Minuto invalido, ingrese un minito valido entre 0 y el 59", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    guard (min >= 0 && min < 60) else {
        addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Minuto invalido, ingrese un minito valido entre 0 y el 59.", callback: { isConfirmed, comment in
            
        }))
        return nil
    }
    
    var comps = DateComponents() // <1>
    comps.day = day
    comps.month = month
    comps.year = year
    comps.hour = hour
    comps.minute = min
    
    guard let uts = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
        showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
        return nil
    }
    
    return uts
    
}
