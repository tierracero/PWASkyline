//
//  ManagePOC+RevenuePreview.swift
//
//
//  Created by Victor Cantu on 9/20/24.
//

import Foundation
import TCFundamentals
import Web

extension ManagePOC {
 
    class RevenuePreview: Div {
        
        override class var name: String { "div" }
        
        let price: Int64
        
        let cost: Int64
        
        init(
            price: Int64,
            cost: Int64
        ){
            self.price = price
            self.cost = cost
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        /// 29.0
        let taxModifire: Float = ((((0.16 + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000
        
        
        
        var costSubTotal: Float = 0
        
        var costTaxes: Float = 0
        
        var costTotal: Float = 0
        
        
        
        var priceSubTotal: Float = 0
        
        var priceTaxes: Float = 0
        
        var priceTotal: Float = 0
        
        
        var taxDiffrance: Float = 0
        
        
        var revenue: Float = 0
        
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick {
                            Dispatch.asyncAfter(0.5) {
                                self.remove()
                            }
                        }
                    
                    H2("Detalles de Ganacia")
                        .color(.lightBlueText)
                        .marginRight(7.px)
                        .height(35.px)
                        .float(.left)
                    
                }
                
                Div().class(.clear).marginBottom(3.px)
                
                Div{
                    
                    Div{
                        Div("")
                            .height(18.px)
                            .color(.gray)
                        
                        H2("Costo")
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div("Sub Total")
                            .height(18.px)
                            .color(.gray)
                            .textAlign(.center)
                        H2{
                            Span(self.costSubTotal.formatMoney)
                        }
                        .color(.gray)
                        .textAlign(.right)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div("Impuestos")
                            .height(18.px)
                            .color(.gray)
                            .textAlign(.center)
                        H2{
                            Span(self.costTaxes.formatMoney)
                        }
                        .color(.gray)
                        .textAlign(.right)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div("Total")
                            .height(18.px)
                            .color(.lightGray)
                            .textAlign(.center)
                        H2{
                            Span(self.costTotal.formatMoney)
                        }
                        .textAlign(.right)
                        .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                    
                    
                }
                
                Div().class(.clear).height(12.px)
                
                Div{
                    
                    Div{
                        
                        H2("Precio")
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        
                        H2{
                            Span(self.priceSubTotal.formatMoney)
                        }
                        .color(.gray)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                    Div{
                        
                        H2{
                            Span(self.priceTaxes.formatMoney)
                        }
                        .color(.gray)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                    Div{
                        
                        H2{
                            Span(self.priceTotal.formatMoney)
                        }
                        .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                // MARK: Driffrence
                Div{
                    
                    Div{
                        
                        H2("Diferencia")
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        
                        H2{
                            Span((self.priceSubTotal - self.costSubTotal).formatMoney)
                        }
                        .color(.gray)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                    Div{
                        
                        H2{
                            Span((self.priceTaxes - self.costTaxes).formatMoney)
                        }
                        .color(.gray)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                    Div{
                        
                        H2{
                            Span((self.priceTotal - self.costTotal).formatMoney)
                        }
                        .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                // MARK: Taxes to pau
                Div{
                    
                    Div{
                        
                        H2("Impuestos a pagar")
                            .marginRight(7.px)
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(75.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                    Div{
                        H2{
                            Span("-\((self.priceTaxes - self.costTaxes).formatMoney)")
                        }
                        .color(.white)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                // MARK: Revenue
                Div{
                    
                    Div{
                        
                        H2("Ganacia")
                            .marginRight(7.px)
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(75.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                    Div{
                        H2{
                            Span(self.revenue.formatMoney)
                        }
                        .color(.yellowTC)
                    }
                    .class(.oneLineText)
                    .width(25.percent)
                    .textAlign(.right)
                    .float(.left)
                    
                }
                
                
                
            }
            .custom("left", "calc(50% - 324px)")
            .custom("top", "calc(50% - 274px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(600.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            costTotal = cost.fromCents
            
            costSubTotal = (((cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
             
            costTaxes = costTotal - costSubTotal
            
            
            priceTotal = price.fromCents
            
            priceSubTotal = (((price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
             
            priceTaxes = priceTotal - priceSubTotal
            
            
            
            taxDiffrance = priceTaxes - costTaxes
            
            // 4900 = (5900 - 1000)
            revenue = (price.fromCents - cost.fromCents) - taxDiffrance
            
//            self.priceaTaxText = revenue.formatMoney
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }

    }
    
}
