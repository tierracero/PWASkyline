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
    
    @State var title: String = ""
    
    @State var help: String = ""
    
    @State var placeholder: String = ""
    
    @State var isRequired: Bool = false
    
    @State var customerMessage: String = ""
    
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

    /*
                            loadingView(show: true)
                            
                            API.custAPIV1.createSaleActionItem(
                                type: type,
                                id: id,
                                name: name,
                                productionLevel: _productionLevel,
                                workforceLevel: _workforceLevel,
                                productionTime: _productionTime,
                                requestCompletition: requestCompletition, 
                                operationalObject: self.operationalObject.map { $0.id },
                                isFavorite: isFavorite,
                                objects: objects
                            ) { resp in
                            }
*/

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
        
        self.id(Id(stringLiteral: element.id.uuidString ))
        
        type = element.type
        
        typeListener = type.rawValue
        
        title = element.title
        
        help = element.help
        
        placeholder = element.placeholder
        
        isRequired = element.isRequired
        
        customerMessage = element.customerMessage
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
}
