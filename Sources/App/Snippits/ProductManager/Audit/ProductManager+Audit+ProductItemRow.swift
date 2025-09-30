//
//  ProductManager+Audit+ProductItemRow.swift
//
//
//  Created by Victor Cantu on 1/14/24.
//


import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class ProductItemRow: Div {
        
        override class var name: String { "div" }
        
        let poc: SearchPOCResponse
        
        private var callback: ((
        ) -> ())
        
        init(
            poc: SearchPOCResponse,
            callback: @escaping ((
            ) -> ())
        ) {
            self.poc = poc
            self.callback = callback
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var avatar = Img()
        
        var price: Int64 = 0
        
        @DOM override var body: DOM.Content {
            avatar
                .src("/skyline/media/512.png")
                .borderRadius(all: 12.px)
                .marginRight(7.px)
                .objectFit(.cover)
                .height(50.px)
                .width(50.px)
                .float(.left)
            
            Div{
                Div{
                    
                    Div(self.poc.n)
                        .custom("width", "calc(100% - 110px)")
                        .class(.oneLineText)
                        .fontSize(20.px)
                        .float(.left)
                    
                    Div{
                        Div(self.poc.p.formatMoney)
                            .class(.oneLineText)
                            .fontSize(20.px)
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(110.px)
                    .align(.right)
                    .float(.right)
                    
                    Div().clear(.both)
                }
                
                Div().clear(.both)
                
                Div("\(self.poc.u) \(self.poc.b) \(self.poc.m)")
                    .class(.oneLineText)
                    .fontSize(16.px)
                
            }
                .custom("width", "calc(100% - 105px)")
                .class(.oneLineText)
                .marginRight(7.px)
                .float(.left)
            
            Div{
                
                 Table{
                     Tr{
                         Td{
                             Img()
                                 .src("/skyline/media/cross.png")
                                 .marginLeft(7.px)
                                 .cursor(.pointer)
                                 .height(18.px)
                                 .onClick {
                                     self.callback()
                                 }
                         }
                         .verticalAlign(.middle)
                         .align(.center)
                     }
                 }
                 .height(100.percent)
                 .width(100.percent)
                 
            }
            .float(.left)
            .width(35.px)
            
            Div().class(.clear)
            
        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.rowItem)
            margin(all: 3.px)
            float(.left)
            
            if !poc.a.isEmpty {
                if let pDir = customerServiceProfile?.account.pDir {
                    avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.a)")
                }
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
        }
        
    }
}
