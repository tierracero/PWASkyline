//
//  AddCartaPorteView.swift
//  
//
//  Created by Victor Cantu on 1/10/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddCartaPorteView: Div {
    
    override class var name: String { "div" }
    
    @State var cartaPorte: CustFiscalCartaPorteItem?
    
    var loadHistory: Bool
    
    private var callback: ((
        _ cartaPorte: CustFiscalCartaPorteItem?
    ) -> ())
    
    init(
        cartaPorte: CustFiscalCartaPorteItem?,
        loadHistory: Bool,
        callback: @escaping ((
            _ cartaPorte: CustFiscalCartaPorteItem?
        ) -> ())
    ) {
        self.cartaPorte = cartaPorte
        self.loadHistory = loadHistory
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Agregar Carta Porte")
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }

            
            TripControlerView(
                mode: .cartaPorte,
                cartaPorte: self.cartaPorte,
                loadHistory: self.loadHistory,
                callback: self.callback
            )

        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(80.percent)
        .width(95.percent)
        .left(2.5.percent)
        .top(10.percent)
        
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
        
    }
    
        
}
