//
//  CustConcession+ConfirmConcessionView.swift
//
//
//  Created by Victor Cantu on 7/11/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class ConfirmConcessionView: Div {
        
        override class var name: String { "div" }
        
        let item: SearchPOCResponse
        
        private var callback: ((
            _ item: SearchPOCResponse,
            _ units: Int64
        ) -> ())
        
        init(
            item: SearchPOCResponse,
            callback: @escaping ((
                _ item: SearchPOCResponse,
                _ units: Int64
            ) -> ())
        ) {
            self.item = item
            self.callback = callback
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var avatarImg = Img()
            .src("/skyline/media/512.png")
            .custom("height", "calc(100% - 6px)")
            .custom("width", "calc(100% - 6px)")
            .objectFit(.cover)
        
        @State var unitsToAdd: String = "0"
        
        lazy var unitsToAddField = InputText(self.$unitsToAdd)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .placeholder("0")
            .height(28.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
            .onEnter {
                self.addItems()
            }
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Confirmar producto")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                
                Div().class(.clear).marginTop(3.px)
                
                Div{
                    self.avatarImg
                        
                }
                .padding(all: 3.px)
                .width(164.px)
                .float(.left)
                
                Div{
                    
                    Div("Name")
                        .marginBottom(3.px)
                        .color(.gray)
                    
                    Div(self.item.n.isEmpty ? "SIN NOMBRE" : self.item.n)
                        .color(self.item.n.isEmpty ? .gray : .white)
                        .class(.oneLineText)
                        .marginBottom(7.px)
                    
                    Div("Marca")
                        .marginBottom(3.px)
                        .color(.gray)
                    
                    Div(self.item.b.isEmpty ? "SIN MARCA" : self.item.b)
                        .color(self.item.b.isEmpty ? .gray : .white)
                        .class(.oneLineText)
                        .marginBottom(7.px)
                    
                    Div("Modelo")
                        .marginBottom(3.px)
                        .color(.gray)
                    
                    Div(self.item.m.isEmpty ? "SIN MODELO" : self.item.m)
                        .color(self.item.m.isEmpty ? .gray : .white)
                        .class(.oneLineText)
                        .marginBottom(7.px)
                    
                }
                .custom("width", "calc(100% - 170px)")
                .color(.white)
                .float(.left)
                
                Div().clear(.both).height(3.px)
                
                Div{
                    Div("Unidades")
                        .width(70.percent)
                        .color(.yellowTC)
                        .fontSize(24.px)
                        .float(.left)
                    
                    Div{
                        self.unitsToAddField
                    }
                    .width(30.percent)
                    .float(.left)
                }
                
                
                Div().clear(.both).height(3.px)
                
                Div{
                    Div("Agergar")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.addItems()
                        }
                }
                .align(.right)
                
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left","calc(50% - 239px)")
            .custom("top","calc(50% - 139px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(450.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            if let pDir = customerServiceProfile?.account.pDir, !item.a.isEmpty {
                avatarImg.load("https://intratc.co/cdn/\(pDir)/thump_\(item.a)")
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            unitsToAddField.select()
        }
        
        func addItems(){
            
            guard let units = Int64(unitsToAdd), units > 0 else {
                showError( .errorGeneral, "Ingrese unidades validas")
                return
            }
            
            self.callback(item, (units * 100))
            
            self.remove()
            
        }
        
    }
}
