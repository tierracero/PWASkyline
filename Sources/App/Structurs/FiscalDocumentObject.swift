//
//  FiscalDocumentObject.swift
//  
//
//  Created by Victor Cantu on 2/28/23.
//

import Foundation
import TCFundamentals


///CFDI 3.3 Fiscal Document
@available(*, deprecated, message: "In server migrate this to TCFoundation and delete this file")
struct FiscalDocumentObject: Codable {
    ///MXN,USD, etc...
    var moneda: FIDocumentCurrency
    ///1 if their MXP
    var tipoDeCambio: Int64
    ///EG: gastosEnGeneral, porDefinir ...
    let use: FiscalUse
    ///pagoEnUnaSolaExhibicion PUE
    ///pagoEnParcialidadesODiferido PPD
    let metodo: FiscalPaymentMeths
    ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
    let forma: FiscalPaymentCodes
    var comment: String
    var lugarExpedicion: String
    var emisor: Emisor
    var receptor: Receptor
    var items: [TaxItem]
    var subTotal: Int64
    var total: Int64
    var sello: String
    var selloCFDI: String
    var selloSAT: String
    var cadenaOriginal: String
    var qr: String
    var xml: String
    ///Only for facturas with "Pagos en una solo exibicion"
    var payment: UUID?
}
extension FiscalDocumentObject {
    struct Emisor: Codable {
        var rfc: String
        var razon: String
        var regimen: FiscalRegimens
        init(
            rfc: String,
            razon: String,
            regimen: FiscalRegimens
        ) {
            self.rfc = rfc
            self.razon = razon
            self.regimen = regimen
        }
    }
    struct Receptor: Codable {
        var rfc: String
        var razon: String
        init(
            rfc: String,
            razon: String
        ) {
            self.rfc = rfc
            self.razon = razon
        }
    }
    
    struct TaxItem: Codable {
        
        private enum CodingKeys: String, CodingKey {
            case fiscCode
            case fiscUnit
            case code
            case name
            case quant
            case cost
            case importe
            case taxString
        }
        
        var fiscCode: String
        var fiscUnit: String
        var code: String
        var name: String
        var quant: Int64
        var cost: Int64
        /// quant * cost
        var importe: Int64
        /// FiscalTaxType: retenido, trasladado
        ///[FiscalTaxItemType:[TaxItemObj]]
        var taxString: [String:[TaxItemObj]]
        
        init(
            fiscCode: String,
            fiscUnit: String,
            code: String,
            name: String,
            quant: Int64,
            cost: Int64,
            importe: Int64,
            ///[FiscalTaxItemType:[TaxItemObj]]
            taxString: [String:[TaxItemObj]]
        ) {
            self.fiscCode = fiscCode
            self.fiscUnit = fiscUnit
            self.code = code
            self.name = name
            self.quant = quant
            self.importe = importe
            self.cost = cost
            self.taxString = taxString
        }
        
        /*
         case fiscCode: String
         case fiscUnit: String
         case code: String
         case name: String
         case quant: Int64
         case cost: Int64
         case importe: Int64
         case taxString: [String:[TaxItemObj]]
      
         */
        
        
        public init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            fiscCode = try container.decode(String.self, forKey: .fiscCode)
            
            fiscUnit = try container.decode(String.self, forKey: .fiscUnit)
            
            code = try container.decode(String.self, forKey: .code)
            
            name = try container.decode(String.self, forKey: .name)
            
            quant = try container.decode(Int64.self, forKey: .quant)
            
            cost = try container.decode(Int64.self, forKey: .cost)
            
            do {
                importe = try container.decode(Int64.self, forKey: .importe)
            }
            catch {
                importe = 0
            }
            taxString = try container.decode([String:[TaxItemObj]].self, forKey: .taxString)
            
        }
    }
    
    struct TaxItemObj: Codable {
        /// Tasa
        var factor: TaxFactor
        /// isr iva ieps
        var impuesto: TaxType
        /// 0.160000
        var cuota: String
        /// total of (cuant * cost) - tax
        var base: Int64
        /// Total tax result of (cuant * cost)
        var importe: Int64
        /// (cuant * cost)
        var total: Int64
    }
}


