//
//  CustUserFinacialServicesPrintEngine.swift
//  
//
//  Created by Victor Cantu on 8/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CustUserFinacialServicesPrintEngine: Div {
    
    override class var name: String { "div" }
    
    var item: CustUserFinacialServices
    
    var createdBy: String
    
    var targetUser: String
    
    var vendor: CustVendorsQuick?
    
    init(
        item: CustUserFinacialServices,
        createdBy: String,
        targetUser: String,
        vendor: CustVendorsQuick?
    ) {
        self.item = item
        self.createdBy = createdBy
        self.targetUser = targetUser
        self.vendor = vendor
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var vendorName = ""
    
    @DOM override var body: DOM.Content {
        Div{
            Div(self.item.type.description)
                .margin(all: 7.px)
            Div(self.item.folio)
        }
        .margin(all: 12.px)
        .align(.center)
        
        Table {
            
            
            Tr{
                Td("Creado")
                Td("Creador")
                Td("Portador")
                Td("Tipo Documento")
                Td("Confirmación")
            }
            Tr{
                Td(getDate(self.item.createdAt).formatedLong)
                Td(self.createdBy)
                Td(self.targetUser)
                Td(self.item.type.description)
                Td(self.item.confirmationType?.description ?? "")
            }
            
            Tr{
                Td("Comentarios")
                Td("")
                Td("Cantidad")
                Td("Retorno")
                Td("Balance")
            }
            
            Tr{
                Td(self.item.comments)
                    .colSpan(2)
                Td(self.item.amount.formatMoney)
                Td(self.item.returned.formatMoney)
                Td(self.item.balance.formatMoney)
            }
            
            Tr{
                Td("Proveedor")
                Td("Comprobante")
                Td("UUID")
                Td("Serie/Folio")
                Td("Comprobante")
            }
            
            Tr{
                Td(self.vendorName)
                Td(self.item.reciptType?.description ?? "")
                Td(self.item.reciptId?.uuidString ?? "")
                Td(self.item.reciptFolio ?? "")
                Td("N/A")
                    .align(.center)
            }
            
            
        }
        
        Div().height(50.px)
        
        Table {
            Tr{
                Td("")
                Td("______________________________")
                    .align(.center)
                Td("")
                Td("______________________________")
                    .align(.center)
                Td("")
            }
            
            Tr{
                Td("")
                Td(self.createdBy)
                    .align(.center)
                Td("")
                Td(self.targetUser)
                    .align(.center)
                Td("")
            }
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        if let vendor {
            vendorName = "\(vendor.rfc) \(vendor.razon)"
        }
        
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}

