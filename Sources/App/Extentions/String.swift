//
//  String.swift
//  
//
//  Created by Victor Cantu on 2/19/22.
//

import Foundation
import TCFundamentals
import Web

extension String {
	
    public static func unexpectedMissingValue(_ missingValue: String) -> String {
		return "No se pudo obtener: \(missingValue.uppercased()), refresque e intente de nuevo o contacte a Soporte TC."
	}
	
    /*
    public static func requierdValid(_ ls: [LocalizedString]) -> String {
        
        let messages: [LocalizedString] = [
            .es("Ingrese valor valido para:"),
            .en("Required value for:")
        ]
        
        let message = String(messages)
        
        let what = String(ls)
        
		return "\(message)\(what)"
        
	}
	*/
	public static func unexpectedError(_ error: String) -> String {
		return ""
	}
	
	static var serverConextionError = "No se pudo comunicar con el servidor."
	
    static var unexpenctedMissingPayload = "No se localizo payload de data."
    
	static var addPayment = "Agregar Pago"
    
	static var confirm = "Confirm"
	
	static var next = "Siguiente"
	static var previous = "Anteriror"
	static var firstName = "Primer Nombre"
	static var secondName = "Segundo Nombre"
	static var mobile = "Celular"
	static var telephone = "Telefono"
	static var lastName = "Primer Apellido"
	static var secondLastName = "Segundo Apellido"
	static var streetNumber = "Calle y Numero"
	static var colony = "Colonia"
	static var city = "Cuidad"
	static var state = "Estado"
	static var country = "Pais"
	static var zipCode = "CP"
	
	
	//"No se pudo comunicar con el servidor"
	
	func explode(_ str: String) -> [String]  {
		let splitText : [String] = self.components(separatedBy: str)
		return splitText
	}
	
	func replace(from:String,to:String) -> String{
		return self.replacingOccurrences(of: from, with: to)
	}
	
	func pseudo() -> String{
		var str = self.lowercased()
		
		str = str.replace(from: "á", to: "a")
		str = str.replace(from: "é", to: "e")
		str = str.replace(from: "í", to: "i")
		str = str.replace(from: "ó", to: "o")
		str = str.replace(from: "ú", to: "u")
		str = str.replace(from: "ñ", to: "n")
		str = str.replace(from: "ü", to: "u")
		str = str.replace(from: "ç", to: "c")
		str = str.replace(from: "à", to: "a")
		str = str.replace(from: "â", to: "a")
		str = str.replace(from: "ã", to: "a")
		str = str.replace(from: "ä", to: "a")
		str = str.replace(from: "å", to: "a")
		str = str.replace(from: "æ", to: "ae")
		str = str.replace(from: "è", to: "e")
		str = str.replace(from: "ê", to: "e")
		str = str.replace(from: "ë", to: "e")
		str = str.replace(from: "ì", to: "i")
		str = str.replace(from: "î", to: "i")
		str = str.replace(from: "ï", to: "i")
		str = str.replace(from: "ð", to: "o")
		str = str.replace(from: "ò", to: "o")
		str = str.replace(from: "ô", to: "o")
		str = str.replace(from: "õ", to: "o")
		str = str.replace(from: "ö", to: "o")
		str = str.replace(from: "ø", to: "o")
		str = str.replace(from: "ù", to: "u")
		str = str.replace(from: "û", to: "u")
		str = str.replace(from: "ý", to: "y")
		str = str.replace(from: "þ", to: "p")
		str = str.replace(from: "ÿ", to: "y")
		
		return str
	}
	
	mutating func purgeSpaces() -> Self{
		self = self.trimmingCharacters(in: .whitespacesAndNewlines)
		return self.replace(from: "  ", to: " ")
	}
	
	//: ### Base64 encoding a string
	func base64Encoded() -> String? {
		if let data = self.data(using: .utf8) {
			return data.base64EncodedString()
		}
		return nil
	}
	//: ### Base64 decoding a string
	func base64Decoded() -> String? {
		if let data = Data(base64Encoded: self) {
			return String(data: data, encoding: .utf8)
		}
		return nil
	}
	
	///Capatilize fist letter of string:
	///"hola mundo" -> "Hola mundo
	func capitalizingFirstLetter() -> String {
		return prefix(1).uppercased() + self.lowercased().dropFirst()
	}
	///Capatilize fist letter each word:
	///"hola mundo" -> "Hola Mundo"
	func capitalizingFirstLetters(_ smart: Bool = false) -> String {
		var string = self
		var resp: String = ""
		
		string = string.purgeSpaces()
		let parts = self.explode(" ")
		parts.forEach { part in
			var _part = ""
			if smart {
				
				var hasUpper = false
				
				part.forEach { (char) in
					if(char.isUppercase){
						hasUpper = true
					}
				}
				
				if hasUpper {
					_part = part
				}
				else {
					_part = part.capitalizingFirstLetter()
				}
			}
			else{
				_part = part.capitalizingFirstLetter()
			}
			
			if resp.isEmpty {
				resp = _part
			}
			else{
				resp += " " + _part
			}
		}
		return resp
	}
	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
}

