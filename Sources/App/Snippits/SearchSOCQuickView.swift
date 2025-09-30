//
//  SearchSOCQuickView.swift
//
//
//  Created by Victor Cantu on 11/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/// Searches and registes vendors
class SearchSOCQuickView: Div {
    
    override class var name: String { "div" }
    
    let excludIds: [UUID]
    
    private var callback: ((
        _ account: CustSOCQuick
    ) -> ())
    
    init(
        excludIds: [UUID],
        callback: @escaping ((
            _ account: CustSOCQuick
        ) -> ())
    ) {
        self.excludIds = excludIds
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""
    
    lazy var seachVendorField = InputText(self.$term)
        .custom("width","calc(100% - 210px)")
        .placeholder("Buscar Servicio...")
        .class(.textFiledBlackDark)
        .marginRight(7.px)
        .height(29.px)
        .float(.left)
        .onKeyUp { tf, event in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.search()
            }
        }
    
    lazy var noResultDiv = Div{
        Table{
            Tr{
                Td(self.$term.map{ $0.isEmpty ? "Ingrese busqueda..." : "No hay resultados \"\($0)\"" })
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.white)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
        .custom("height","calc(100% - 70px)")
        .class(.roundDarkBlue)
        .overflow(.hidden)
    
    lazy var resultDiv = Div()
        .custom("height","calc(100% - 70px)")
        .class(.roundDarkBlue)
        .overflow(.auto)
    
    @State var results: [SearchChargeResponse] = []
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Buscar Servicio")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            /// Tool
            Div {
                
                self.seachVendorField
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/zoom.png")
                            .paddingRight(0.px)
                            .height(18.px)
                    }
                    .marginRight(7.px)
                    .float(.left)
                    
                    Label("Buscar")
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    self.search()
                }
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            self.noResultDiv
                .hidden(self.$results.map{ !$0.isEmpty })
            
            self.resultDiv
                .hidden(self.$results.map{ $0.isEmpty })
             
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(50.percent)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        super.buildUI()
        
        $results.listen {
            
            self.resultDiv.innerHTML = ""
            
            $0.forEach { soc in
                
                self.resultDiv.appendChild(
                    Div{
                        Div("\(soc.n)")
                            .class(.oneLineText)
                            .fontSize(23.px)
                    }
                        .width(96.percent)
                        .class(.uibtnLarge)
                        .onClick {
                            self.callback(.init(
                                id: soc.i,
                                name: soc.n,
                                pseudoName: soc.n,
                                pricea: soc.p,
                                priceb: soc.p,
                                pricec: soc.p,
                                avatar: soc.a,
                                status: .active
                            ))
                            self.remove()
                        })
                
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        seachVendorField.select()
    }
    
    func search(){
        
        term = term.purgeSpaces
        
        if term.isEmpty {
            return
        }
        
        if let _ = Int64(term) {
            if term.count < 5 {
                return
            }
        }
        else{
            if term.count < 4 {
                return
            }
        }
        
        self.seachVendorField
            .class(.isLoading)
        
        searchSOCs(
            term: term,
            costType: .cost_a,
            socType: nil
        ){ _term, resp in
        
            self.seachVendorField
                .removeClass(.isLoading)
            
            if self.term != _term {
                return
            }
            
            var _results: [SearchChargeResponse] = []
            
            resp.forEach { soc in
                if self.excludIds.contains(soc.i) {
                    return
                }
                _results.append(soc)
            }
            
            self.results = _results
            
        }
        
    }
    
}

