//
//  SalePoint+HistoryRow.swift
//  
//
//  Created by Victor Cantu on 5/16/23.
//

import TCFundamentals
import Foundation
import Web

extension SalePointView {
    class HistoryRow: Div {
        
        override class var name: String { "div" }
        
        let sale: CustSaleQuick
        
        let custAcct: CustAcctQuick?
        
        /*
        private var callback: ((
            _ action: CustSaleActionQuick
        ) -> ())
        */
        
        init(
            sale: CustSaleQuick,
            custAcct: CustAcctQuick?
            /*
            callback: @escaping ((
                _ action: CustSaleActionQuick
            ) -> ())
             */
        ) {
            self.sale = sale
            self.custAcct = custAcct
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
        
            Div(self.sale.folio)
                .textAlign(.center)
                .width(10.percent)
                .float(.left)
            
            Div("\(getDate(self.sale.createdAt).formatedShort) \(getDate(self.sale.createdAt).time)")
                .textAlign(.center)
                .width(15.percent)
                .float(.left)
            
            Div{
                if let account = self.custAcct {
                    Span("\(account.folio) \(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces)
                }
                else {
                    Span("Public General")
                        .color(Color(r: 81, g: 85, b: 94))
                }
            }
            .textAlign(.center)
            .width(25.percent)
            .minHeight(20.px)
            .float(.left)
            
            Div( (self.sale.purchesOrder == nil) ? "No" : "Si" )
                .textAlign(.center)
                .width(5.percent)
                .float(.left)
            
            Div( self.sale.pickupOrder.isEmpty ?  "No" : self.sale.pickupOrder.count.toString )
                .textAlign(.center)
                .width(5.percent)
                .float(.left)
            
            Div(self.sale.total.formatMoney)
                .textAlign(.center)
                .width(15.percent)
                .float(.left)
            
            
            if self.sale.status == .canceled {
                Div("CANCELADO")
                    .class(.oneLineText)
                    .textAlign(.center)
                    .width(10.percent)
                    .color(.yellowTC)
                    .float(.left)
            }
            else {
                
                Div(self.sale.balance.formatMoney)
                    .textAlign(.center)
                    .width(10.percent)
                    .float(.left)
                
            }
            Div{
                
                // unrequest, pendToPay, paid, sentToAcct, sentToDebt
                if self.sale.fiscalDocumentStatus == .unrequest {
                    
                    
                }
                else if self.sale.fiscalDocumentStatus == .pendToPay {
                    Span()
                }
                else if self.sale.fiscalDocumentStatus == .paid {
                    Img()
                        .src("/skyline/media/checkmark.png")
                        .marginLeft(7.px)
                        .height(18.px)
                }
                else if self.sale.fiscalDocumentStatus == .global {
                    Img()
                        .src("/skyline/media/world.png")
                        .marginLeft(7.px)
                        .height(18.px)
                }
                else if self.sale.fiscalDocumentStatus == .sentToAcct {
                    Span()
                }
                else if self.sale.fiscalDocumentStatus == .sentToDebt {
                    Span()
                }
                
            }
            .textAlign(.center)
            .width(5.percent)
            .float(.left)
            
            
            Div().class(.clear)
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            marginBottom(7.px)
            cursor(.pointer)
            color(.white)
            onClick {
                addToDom(DetailView(saleId: .id(self.sale.id)))
            }
        }
    }
}
