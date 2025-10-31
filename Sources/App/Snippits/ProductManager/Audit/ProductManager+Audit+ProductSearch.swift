//
//  ProductManager+Audit+ProductSearch.swift
//
//
//  Created by Victor Cantu on 1/14/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView.AuditView {

    class ProductSearch: Div {
        
        override class var name: String { "div" }
        
        var parsablePOCs: State<[SearchPOCResponse]>
        
        private var callback: ((
        ) -> ())
        
        init(
            parsablePOCs: State<[SearchPOCResponse]>,
            callback: @escaping ((
            ) -> ())
        ) {
            self.parsablePOCs = parsablePOCs
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var searchTerm = ""
        
        lazy var searchProductField = InputText(self.$searchTerm)
            .placeholder("Buscar Producto...")
            .class(.textFiledBlackDark)
            .width(350.px)
            .height(35.px)
            .onFocus({ tf in
                tf.select()
            })
            .onPaste {
                Dispatch.asyncAfter(0.1) {
                    self.search(0)
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
        
        @State var currentIds: [UUID] = []
        
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
                
                Div{
                    ForEach(self.parsablePOCs){ item in
                        ProductItemRow(poc: item) {
                            self.removeItem(id: item.id)
                        }
                    }
                }
                .custom("height", "calc(100% - 35px)")
                .custom("width", "calc(33% - 4px)")
                .class(.roundGrayBlackDark)
                .marginRight(7.px)
                .float(.left)
                
                /// Results View
                self.productResultDiv
                    .custom("width", "calc(66% - 3px)")
                    .float(.left)
                
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
            
            parsablePOCs.listen {
                self.currentIds = $0.map{ $0.id }
            }
            
            self.currentIds = parsablePOCs.wrappedValue.map{ $0.id }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            searchProductField.select()
            
            self.fadeIn(time: 0.3, begin: .display(.block)) {
                
            }
            
        }
        
        func search(_ pause: Double = 0.5){
             
            let term = searchTerm.purgeSpaces
             
             if term.count < 4 {
                 self.productResultDiv.innerHTML = ""
                 return
             }
             
             Dispatch.asyncAfter(pause) {
                 
                 if term != self.searchTerm.purgeSpaces {
                     return
                 }
                 
                 self.searchProductField.class(.isLoading)
                 
                 searchPOC(term: term, costType: .cost_a, getCount: false) { _term, resp in
                     
                     self.searchProductField.removeClass(.isLoading)

                     if term != _term {
                         return
                     }
                     
                     self.productResultDiv.innerHTML = ""
                     
                     resp.forEach { item in
                         
                         if self.currentIds.contains(item.id) {
                             return
                         }
                         
                         self.productResultDiv.appendChild(
                            
                            SearchItemPOCView(
                                searchTerm: _term,
                                poc: item
                            ) { _, _ in
                                
                                if self.currentIds.contains(item.id) {
                                    return
                                }
                                
                                self.parsablePOCs.wrappedValue.append(item)
                            }.hidden(self.$currentIds.map{ $0.contains(item.id) })
                            
                         )
                     }
                 }
             }
         }
        
        func removeItem(id: UUID) {
            
            var items: [SearchPOCResponse] = []
            
            parsablePOCs.wrappedValue.forEach { item in
                if item.id == id {
                    return
                }
                items.append(item)
            }
            
            parsablePOCs.wrappedValue = items
            
        }
        
    }
}
