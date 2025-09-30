//
//  ProductSuperSearchView.swift
//  
//
//  Created by Victor Cantu on 9/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ProductSuperSearchView: Div {
    
    override class var name: String { "div" }
    
    var searchTerm: State<String>
    
    private var callback: ((
    ) -> ())
    
    init(
        searchTerm: State<String>,
        callback: @escaping ((
        ) -> ())
    ) {
        self.searchTerm = searchTerm
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var searchProductField = InputText(self.searchTerm)
        .placeholder("Buscar Producto...")
        .class(.textFiledBlackDark)
        .width(350.px)
        .height(35.px)
        .onFocus({ tf in
            tf.select()
        })
        .onPaste {
            
            Dispatch.asyncAfter(0.3) {
                print(self.searchTerm.wrappedValue)
                self.search()
            }
            
        }
        .onKeyUp{ _, event in
            
            if ignoredKeys.contains(event.key) {
                return
            }
            
            self.search()
        }
        .onEnter {
            
            self.search()
        }
    
    lazy var productResultDiv = Div()
        .class(.roundDarkBlue, .transparantBlackBackGround)
        .custom("height", "calc(100% - 35px)")
        .overflow(.auto)
    
    @DOM override var body: DOM.Content {
        
        Div {
            Div{
                
                Img()
                    .closeButton(.uiView1)
                    .marginRight(12.px)
                    .marginTop(7.px)
                    .onClick{
                        self.fadeOut(time: 0.2, end: .hidden) {
                            self.callback()
                        }
                    }
                
                Img()
                    .src("/skyline/media/lowerWindow.png")
                    .marginRight(18.px)
                    .class(.iconWhite)
                    .cursor(.pointer)
                    .marginTop(7.px)
                    .float(.right)
                    .width(24.px)
                    .onClick {
                        self.fadeOut(time: 0.2, end: .hidden)
                    }
                
                H2("Buscar: ")
                    .marginRight(12.px)
                    .color(.white)
                    .float(.left)
                
                self.searchProductField
            }
            .marginBottom(7.px)
            
            self.productResultDiv
            
        }
        .position(.absolute)
        .padding(all: 7.px)
        .height(90.percent)
        .width(90.percent)
        .left(5.percent)
        .top(5.percent)
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        searchProductField.select()
        
        self.fadeIn(time: 0.3, begin: .display(.block)) {
            
        }
        
    }
    
    func search(){
         
        let term = searchTerm.wrappedValue.purgeSpaces
         
         if term.count < 4 {
             self.productResultDiv.innerHTML = ""
             return
         }
         
         Dispatch.asyncAfter(0.5) {
             
             if term != self.searchTerm.wrappedValue.purgeSpaces {
                 return
             }
             
             self.searchProductField.class(.isLoading)
             
             searchPOC(term: term, costType: .cost_a, getCount: true) { _term, resp in
                 
                 self.searchProductField.removeClass(.isLoading) 

                 if term != _term {
                     return
                 }
                 
                 self.productResultDiv.innerHTML = ""
                 
                 resp.forEach { item in
                     self.productResultDiv.appendChild(
                        
                        SearchItemPOCView(
                            searchTerm: _term,
                            poc: item,
                            callback: { update, deleted in
                                
                                let view = ManagePOC(
                                    leveltype: CustProductType.all,
                                    levelid: nil,
                                    levelName: "",
                                    pocid: item.i,
                                    titleText: "",
                                    quickView: false
                                ) {  pocid, upc, brand, model, name, cost, price, avatar in
                                    update( name, "\(upc) \(brand) \(model)", price, avatar)
                                } deleted: {
                                    deleted()
                                }
                                
                                addToDom(view)
                                
                            })
                     )
                 }
             }
         }
     }
}
