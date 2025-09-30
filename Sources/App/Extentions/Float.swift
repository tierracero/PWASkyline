//
//  Float.swift
//  
//
//  Created by Victor Cantu on 2/23/22.
//

import Foundation

extension Float{
	

	
	func formatMoney() -> String{
		print("xx2")
		return self.toCents().formatMoney()
	}
	/// self * 1000000
	func toCents() -> Int64{
		return Int64(Double(self * 1000000).rounded())
	}
	func toInt() -> Int{
		return Int(self)
	}
	func toInt64() -> Int64{
		return Int64(self)
	}
	func toString() -> String{
		return String(self)
	}
	
	func fiscalFixDecial() -> String {
		var resp = ""
		let str = String(self)
		
		var num = ""
		var deci = ""
		
		if !str.contains(".") {
			num = str
		}
		else{
			let parts = str.explode(".")
			num = parts[0]
			deci = parts[1]
		}
		
		var zeros = 6 - deci.count
		
		resp = num + "." + deci
		
		while zeros > 0 {
			resp += "0"
			zeros -= 1
		}
		
		return resp
		
	}
}
