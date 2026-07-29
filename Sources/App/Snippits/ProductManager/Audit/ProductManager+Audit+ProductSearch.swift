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

        private var searchId = UUID()
        private var searchRenderId = UUID()
        private var searchResultViewsById: [UUID: SearchItemPOCView] = [:]
        private var currentIds: Set<UUID> = []
        private var isActive = true
        
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
            
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            parsablePOCs.listen {
                guard self.isActive else {
                    return
                }

                let ids = Set($0.map(\.id))
                ids.subtracting(self.currentIds).forEach { id in
                    self.searchResultViewsById.removeValue(forKey: id)?.remove()
                }
                self.currentIds = ids
            }
            
            self.currentIds = Set(parsablePOCs.wrappedValue.map(\.id))
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            isActive = true
            searchProductField.select()
            
            self.fadeIn(time: 0.3, begin: .display(.block)) {
                
            }
            
        }
        
        func search(_ pause: Double = 0.5){
            let currentSearchId = UUID()
            searchId = currentSearchId
            let term = searchTerm.purgeSpaces
             
             if term.count < 4 {
                 searchRenderId = UUID()
                 searchResultViewsById.removeAll()
                 self.productResultDiv.innerHTML = ""
                 return
             }
             
             Dispatch.asyncAfter(pause) {
                 guard self.isActive,
                       currentSearchId == self.searchId,
                       term == self.searchTerm.purgeSpaces else {
                     return
                 }
                 
                 self.searchProductField.class(.isLoading)
                 
                 searchPOC(term: term, costType: .cost_a, getCount: false) { _term, resp in
                     guard self.isActive,
                           currentSearchId == self.searchId,
                           term == _term,
                           term == self.searchTerm.purgeSpaces else {
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

            if !currentIds.contains(result.id) {
                let view = makeSearchResultView(result, term: term)

                guard isActive,
                      searchId == self.searchId,
                      searchId == searchRenderId else {
                    view.remove()
                    return
                }

                searchResultViewsById[result.id] = view
                productResultDiv.appendChild(view)
            }

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
            term: String
        ) -> SearchItemPOCView {
            SearchItemPOCView(
                searchTerm: term,
                poc: item
            ) { _, _ in
                guard !self.currentIds.contains(item.id) else {
                    return
                }

                self.parsablePOCs.wrappedValue.append(item)
                self.searchResultViewsById.removeValue(forKey: item.id)?.remove()
            }
        }

        func removeItem(id: UUID) {
            
            parsablePOCs.wrappedValue.removeAll { $0.id == id }
            
        }
        

        override func didRemoveFromDOM() {
            searchId = UUID()
            searchRenderId = UUID()
            searchResultViewsById.removeAll()
            isActive = false
            super.didRemoveFromDOM()
            $searchTerm.removeAllListeners()
        }
    }
}
