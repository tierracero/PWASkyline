//
//  QuickOrderSearch.swift
//
//
//  Created by Victor Cantu on 10/24/23.
//

import Foundation
// import SkylinePublicAPI
import TCFundamentals
import TCFireSignal
import Web

class QuickOrderSearch: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ order: CustOrderLoadFolios
    ) -> ())
    
    init(
        callback: @escaping (_: CustOrderLoadFolios) -> Void
    ) {
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var searchFolioString: String = ""
    
    lazy var searchFolioField = InputText(self.$searchFolioString)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Ingrese Folio")
        .width(90.percent)
        .fontSize(23.px)
        .height(27.px)
        .onEnter { tf in
            self.searchFolio()
        }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2("Buscar Orden")
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear).height(12.px)
            
            Div{
                Label("Ingrese Folio")
                    .color(.lightGray)
                    .fontSize(23.px)
                
                Div{
                    self.searchFolioField
                        
                }
            }
            .class(.section)
            
            Div().class(.clear).height(12.px)
            
            Div{
                Div("Buscar Folio")
                    .onClick {
                        self.searchFolio()
                    }
                .class(.uibtnLargeOrange)
            }
            .align(.right)
            
        }
        .top(25.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        self.searchFolioField.select()
    }
    
    func searchFolio() {
        
        var term = searchFolioString
            .purgeSpaces
            .pseudo
        
        if searchFolioString.isEmpty {
            showAlert( .alerta, "Ingrese Folio")
            return
        }
        
        if !term.contains("-") {
            term = "-\(term)"
        }
        
        loadingView(show: true)
        
        API.custOrderV1.searchFolio(
            term: term,
            accountid: nil,
            tag1: nil,
            tag2: nil,
            tag3: nil,
            tag4: nil,
            description: nil,
            startAt: nil,
            endAt: nil
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let order = resp.data?.orders.first else {
                showError( .generalError, "No se localizo folio, revice de nuevo.")
                return
            }
            
            self.callback(order)
            
            self.remove()
            
        }
    }
}
