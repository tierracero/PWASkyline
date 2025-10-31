//
//  AddOrderManagerModel.swift
//  
//
//  Created by Victor Cantu on 8/16/22.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddOrderManagerModel: Div {
    
    override class var name: String { "div" }
    
    @State var term: String
    
    let typeId: UUID
    
    let brandId: UUID
    
    let brandName: String
    
    private var callback: ((
        _ model: CustOrderManagerModel
    ) -> ())
    
    init(
        term: String,
        typeId: UUID,
        brandId: UUID,
        brandName: String,
        callback: @escaping ((
            _ model: CustOrderManagerModel
        ) -> ())
    ) {
        self.term = term
        self.typeId = typeId
        self.brandId = brandId
        self.brandName = brandName
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var termInput = InputText(self.$term)
        .placeholder(configServiceTags.tag2Placeholder)
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
                        
                        Strong(configServiceTags.tag2Name.uppercased())
                            .color(.red)
                    }
                    .color(.lightBlueText)
                    .float(.left)
                    
                    H2(self.brandName)
                        .color(.gray)
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
                        
                        Strong(configServiceTags.tag2Name.uppercased())
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
        
        term = term.purgeSpaces.uppercased()
        
        if term.isEmpty { return }
        
        loadingView(show: true)
        
        API.custOrderV1.addOrderManagerModel(typeId: self.typeId, brandId: self.brandId, term: term) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let model = resp.data else {
                showError(.unexpectedResult, "No se obtuvo nuevo objeto, contacte a Soporte TC")
                return
            }
            
            self.callback(model)
            
            self.remove()
            
        }
    }
}

