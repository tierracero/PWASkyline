//
//  Date.swift
//  
//
//  Created by Victor Cantu on 3/20/22.
//

import Foundation

extension Date {
	/*
	var weekday: Int {
		return Calendar.current.component(.weekday, from: self) - 1
	}
	var weekdayName: String {
		let names = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
		return names[Calendar.current.component(.weekday, from: self) - 1]
	}
	var weekdayNumber: Int {
		return Calendar.current.component(.weekday, from: self) - 1
	}
	var day: Int {
		return Calendar.current.component(.day, from: self)
	}
	
	var month: Int {
		return Calendar.current.component(.month, from: self)
	}
	var monthName: String {
		let names = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
		let month = Calendar.current.component(.month, from: self)
		return names[month - 1]
	}
	var year: Int {
		return Calendar.current.component(.year, from: self)
	}
	
	var hour: Int {
		return Calendar.current.component(.hour, from: self)
	}
	
	var minute: Int {
		return Calendar.current.component(.minute, from: self)
	}

    /// 7:23
    public var time: String {
        
        let date = Date(timeIntervalSince1970: self.timeIntervalSince1970 - 21600)
        var hour = Calendar.current.component(.hour, from: date).toString
        var min = Calendar.current.component(.minute, from: date).toString
        
        if min.count == 1 {
            min =  "0\(min)"
        }
        
        return "\(hour):\(min)"
    }
    
    
    /// View short formated date  Lun 23/Mar
    public var formatedShort: String {
        let date = Date(timeIntervalSince1970: self.timeIntervalSince1970 - 21600)
        let day = Calendar.current.component(.day, from: self)
        return "\(self.weekdayName.prefix(3)) \(day.toString)/\(self.monthName.prefix(3))"
    }
    
    /// View long formated date  Lun 23/Mar/22
    public var formatedLong: String {
        let date = Date(timeIntervalSince1970: self.timeIntervalSince1970 - 21600)
        let day = Calendar.current.component(.day, from: self)
        let year = Calendar.current.component(.year, from: self)
        return "\(self.weekdayName.prefix(3)) \(day.toString)/\(self.monthName.prefix(3)) \(year.toString.suffix(2))"
    }
     */
    
}
