//
//  AddOrderManagerType.swift
//  
//
//  Created by Victor Cantu on 8/15/22.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddOrderManagerType: Div {
    
    override class var name: String { "div" }
    
    var brandId: UUID
    
    @State var term: String
    
    private var callback: ((
        _ type: CustOrderManagerType
    ) -> ())
    
    init(
        brandId: UUID,
        term: String,
        callback: @escaping ((
            _ type: CustOrderManagerType
        ) -> ())
    ) {
        self.brandId = brandId
        self.term = term
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var termInput = InputText(self.$term)
        .placeholder(configServiceTags.tag3Placeholder)
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
                
                H2{
                    Span("Agregar ")
                        .marginRight(7.px)
                    Strong(configServiceTags.tag3Name.uppercased())
                        .color(.red)
                }
                    .color(.lightBlueText)
                
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
                        
                        Strong(configServiceTags.tag3Name.uppercased())
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
        
        print("send to server: 💎")
        print(term)
        print(brandId.uuidString)
        
        API.custOrderV1.addOrderManagerType(
            brandId: brandId,
            term: term
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let type = resp.data else {
                showError(.unexpectedResult, "No se obtuvo nuevo objeto, contacte a Soporte TC")
                return
            }
            
            self.callback(type)
            
            self.remove()
            
        }
    }
}
