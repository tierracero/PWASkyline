//
//  OrderView+OrderView+AddOrderProjectItemObject.swift
//
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension OrderView {
    
    class AddOrderProjectItemObject: Div {
        
        override class var name: String { "div" }
        
        var element: API.custOrderV1.AddOrderProjectItemObject
        
        private var removeItem: ((
            _ id: UUID
        ) -> ())
        
        private var callback: ((
            _ element: API.custOrderV1.AddOrderProjectItemObject
        ) -> ())
        
        init(
            element: API.custOrderV1.AddOrderProjectItemObject,
            removeItem: @escaping ((
                _ id: UUID
            ) -> ()),
            callback: @escaping ((
                _ element: API.custOrderV1.AddOrderProjectItemObject
            ) -> ())
        ) {
            self.element = element
            self.removeItem = removeItem
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        /// textField, textArea, checkBox, selection, radio, instruction
        @State var type = SaleActionInputType.textField
        
        @State var typeListener = SaleActionInputType.textField.rawValue
        
        @State var actionName: String = ""
        
        @State var help: String = ""
        
        @State var placeholder: String = ""
        
        @State var isRequired: Bool = false
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                Img()
                    .src("/skyline/media/pencil.png")
                    .marginTop(12.px)
                    .height(28.px)
                    .opacity(0.5)
                    .onClick {
                        
                    }
            }
            .align(.center)
            .width(35.px)
            .float(.left)
            .onClick { _, event in
                event.preventDefault()
            }
            
            Div{
                
                Div{
                    
                    Span(self.$type.map{ $0.description })
                        .float(.right)
                        .color(.lightGray)
                    
                    Span(self.$actionName)
                        .marginRight(7.px)
                    
                    Strong("(R)")
                        .color(.orangeRed)
                        .hidden( self.$isRequired.map{ !$0 } )
                }
                    .class(.oneLineText)
                    .marginBottom(7.px)
                    .fontSize(16.px)
                    .color(.white)
                
                Div{
                    
                    Span(self.$help)
                        .marginRight(7.px)
                    
                    Span("|")
                        .hidden(self.$placeholder.map{ $0.isEmpty })
                        .marginRight(7.px)
                    
                    Span(self.$placeholder)
                        .marginRight(7.px)
                    
                }
                .custom("word-wrap", "break-word")
                .whiteSpace(.preWrap)
                .wordBreak(.breakWord)
                .fontSize(14.px)
                .color(.lightGray)
                
            }
            .custom("width", "calc(100% - 83px)")
            .padding(all: 3.px)
            .margin(all: 3.px)
            .float(.left)
            
            Div{
                
                Img()
                    .src("/skyline/media/cross.png")
                    .opacity(0.5)
                    .marginTop(12.px)
                    .height(28.px)
                    .onClick { _, event in
                        self.removeItem(self.element.id)
                        event.stopPropagation()
                    }
                
            }
            .align(.center)
            .width(35.px)
            .float(.left)
            .onClick { _, event in
                event.preventDefault()
            }
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.uibtnLarge)
                .width(95.percent)
            
            self.id(Id(stringLiteral: element.id.uuidString ))
            
            type = element.type
            
            typeListener = type.rawValue
            
            actionName = element.actionName
            
            help = element.helpText
            
            placeholder = element.placeholder
            
            isRequired = element.isRequired
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }
    }
}
