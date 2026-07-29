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

    private var searchId = UUID()
    private var searchRenderId = UUID()
    private var searchResultViewsById: [UUID: SearchItemPOCView] = [:]
    private var isActive = true
    
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
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        isActive = true
        searchProductField.select()
        
        self.fadeIn(time: 0.3, begin: .display(.block)) {
            
        }
        
    }

    override func didRemoveFromDOM() {
        searchId = UUID()
        searchRenderId = UUID()
        searchResultViewsById.removeAll()
        isActive = false
        super.didRemoveFromDOM()
    }
    
    func search(){
        let currentSearchId = UUID()
        searchId = currentSearchId
        let term = searchTerm.wrappedValue.purgeSpaces
         
         if term.count < 4 {
             searchRenderId = UUID()
             searchResultViewsById.removeAll()
             self.productResultDiv.innerHTML = ""
             return
         }
         
         Dispatch.asyncAfter(0.5) {
             guard self.isActive,
                   currentSearchId == self.searchId,
                   term == self.searchTerm.wrappedValue.purgeSpaces else {
                 return
             }
             
             self.searchProductField.class(.isLoading)
             
             searchPOC(term: term, costType: .cost_a, getCount: true) { _term, resp in
                 guard self.isActive,
                       currentSearchId == self.searchId,
                       term == _term,
                       term == self.searchTerm.wrappedValue.purgeSpaces else {
                     return
                 }

                 self.searchProductField.removeClass(.isLoading)

                 self.searchRenderId = currentSearchId
                 self.searchResultViewsById.removeAll(keepingCapacity: true)
                 self.productResultDiv.innerHTML = ""

                 self.asyncAddSearchResult(
                     results: resp,
                     term: term,
                     searchId: currentSearchId
                 )
             }
         }
     }

    private func asyncAddSearchResult(
        results: [SearchPOCResponse],
        term: String,
        searchId: UUID,
        index: Int = 0
    ) {
        guard isActive,
              searchId == self.searchId,
              searchId == searchRenderId,
              results.indices.contains(index) else {
            return
        }

        let result = results[index]
        let view = makeSearchResultView(result, searchTerm: term)

        guard isActive,
              searchId == self.searchId,
              searchId == searchRenderId else {
            view.remove()
            return
        }

        searchResultViewsById[result.id] = view
        productResultDiv.appendChild(view)

        Dispatch.asyncAfter(0.01) {
            guard self.isActive,
                  searchId == self.searchId,
                  searchId == self.searchRenderId else {
                return
            }

            self.asyncAddSearchResult(
                results: results,
                term: term,
                searchId: searchId,
                index: index + 1
            )
        }
    }

    private func makeSearchResultView(
        _ item: SearchPOCResponse,
        searchTerm: String
    ) -> SearchItemPOCView {
        SearchItemPOCView(
            searchTerm: searchTerm,
            poc: item
        ) { update, deleted in
            let view = ManagePOC(
                leveltype: .all,
                levelid: nil,
                levelName: "",
                pocid: item.id,
                titleText: "",
                quickView: false
            ) { _, upc, brand, model, name, _, price, avatar, reqSeries in
                update(name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
            } deleted: {
                self.searchResultViewsById.removeValue(forKey: item.id)
                deleted()
            }

            addToDom(view)
        }
    }
}
