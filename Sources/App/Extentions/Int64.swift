//
//  Int64.swift
//  
//
//  Created by Victor Cantu on 2/19/22.
//

import Foundation

extension Int64 {
	///Convers cents to pesos.
	///10055 -> 100.55
	func fromCents() -> Float{
		return Float(self) / 1000000
	}
	/// Converts float to money format
	/// - Returns:  1000 -> $1,000
	func formatMoney() -> String{

		let parts = String(Float64(self) / 1000000).explode(".")
		
		var numbers: [String] = []
		
		parts[0].forEach { char in
			numbers.insert(char.description, at: 0)
		}
		
		var finalAtr = ""
		var cc = 0
		numbers.forEach { char in
			if cc == 3 {
				finalAtr = "," + finalAtr
				cc = 0
			}
			
			finalAtr =  char + finalAtr
			
			cc += 1
		}
		
		if parts.count > 1{
			let dec = parts[1].prefix(2)
			
			if dec.count == 1{
				finalAtr += ".\(dec)0"
			}
			else{
				finalAtr += ".\(dec)"
			}
			
		}
		else{
			finalAtr =  ".00"
		}
		
		return finalAtr
	}
}
