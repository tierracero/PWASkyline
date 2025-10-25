//
//  ServiceAccionItemElementRow.swift
//  
//
//  Created by Victor Cantu on 4/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionItemElementRow: Div {
    
    override class var name: String { "div" }
    
    var element: CustSaleActionObjectDecoder
    
    private var removeItem: ((
        _ id: UUID
    ) -> ())
    
    private var callback: ((
        _ element: CustSaleActionObjectDecoder
    ) -> ())
    
    init(
        element: CustSaleActionObjectDecoder,
        removeItem: @escaping ((
            _ id: UUID
        ) -> ()),
        callback: @escaping ((
            _ element: CustSaleActionObjectDecoder
        ) -> ())
    ) {

        self.id = element.id
        self.type = element.type
        self.typeListener = element.type.rawValue
        self.title = element.title
        self.help = element.help
        self.placeholder = element.placeholder
        self.isRequired = element.isRequired
        self.customerMessage = element.customerMessage
        self.element = element
        self.removeItem = removeItem
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    let id: UUID
    
    /// textField, textArea, checkBox, selection, radio, instruction
    @State var type: SaleActionInputType 
    
    @State var typeListener: String
    
    @State var title: String
    
    @State var help: String
    
    @State var placeholder: String
    
    @State var isRequired: Bool
    
    @State var customerMessage: String
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .src("/skyline/media/pencil.png")
                .marginTop(12.px)
                .height(28.px)
                .onClick {
                    
                    addToDom(ServiceAccionItemElementView(
                        element: self.element,
                        callback: { element in
                            
                            self.element = element
                            
                            self.type = element.type
                            
                            self.typeListener = element.type.rawValue
                            
                            self.title = element.title
                            
                            self.help = element.help
                            
                            self.placeholder = element.placeholder
                            
                            self.isRequired = element.isRequired

                        }
                    ))
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
                
                Span(self.$title)
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
            
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
}
