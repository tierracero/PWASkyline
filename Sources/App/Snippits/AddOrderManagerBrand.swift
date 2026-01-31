//
//  AddOrderManagerBrand.swift
//  
//
//  Created by Victor Cantu on 8/16/22.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddOrderManagerBrand: Div {
    
    override class var name: String { "div" }
    
    @State var term: String
    
    private var callback: ((
        _ brand: CustOrderManagerBrand
    ) -> ())
    
    init(
        term: String,
        callback: @escaping ((
            _ brand: CustOrderManagerBrand
        ) -> ())
    ) {
        self.term = term
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var termInput = InputText(self.$term)
        .placeholder(configServiceTags.tag1Placeholder)
        .width(70.percent)
        .height(52.px)
        .fontSize(36.px)
        .class(.textFiledLight)
    
    @DOM override var body: DOM.Content {
        Div{
            Div{
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                Div{
                    H2{
                        Span("Agregar")
                            .marginRight(7.px)
                        
                        Strong(configServiceTags.tag1Name.uppercased())
                            .color(.red)
                    }
                    .color(.lightBlueText)
                    .float(.left)
                }
                
                
                Div().class(.clear)
                
                H2("• Evita registros duplicados").color(.gray)
                
                H2("• Revisa tu ortografía").color(.gray)
                
                H2("• Sigue una estartegía adecuada").color(.gray)
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                Div{
                    self.termInput
                    
                    Div().class(.clear).marginTop(12.px)
                    
                    Div{
                        Img()
                            .src("/skyline/media/diskette.png")
                            .height(24.px)
                            .paddingRight(7.px)
                        
                        Span("Agregar")
                            .marginRight(7.px)
                        
                        Strong(configServiceTags.tag1Name.uppercased())
                            .color(.red)
                    }
                    .width(70.percent)
                    .fontSize(36.px)
                    .align(.center)
                    .class(.smallButtonBox)
                    .onClick(self.addTerm)
                }
                .align(.center)
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
            }
            .margin(all: 7.px)
        }
        .top(30.percent)
        .left(30.percent)
        .width(40.percent)
        .position(.absolute)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
    }

    override func buildUI() {
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
    }
    
    func addTerm(){
        
        term = term.purgeSpaces.capitalizingFirstLetters(true)
        
        if term.isEmpty { return }
        
        loadingView(show: true)
        
        API.custOrderV1.addOrderManagerBrand(term: term) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            let brand = data.brand
            
            orderManagerType.append(contentsOf: data.types)
            
            self.callback(brand)
            
            self.remove()
            
        }
    }
}

