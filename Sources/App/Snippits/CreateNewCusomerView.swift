//
//  CreateNewCusomerView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

class CreateNewCusomerView: Div {
    
    override class var name: String { "div" }
    
    var searchTerm: String
    
    /// general, business
    let custType: CreateNewCusomerType
    
    private var callback: ((
        ///personal, empresaFisica, empresaMoral, organizacion
        _ acctType: CustAcctTypes,
        /// general, business
        _ custType: CreateNewCusomerType,
        _ searchTerm: String
    ) -> ())
    
    init(
        searchTerm: String,
        /// general, business
        custType: CreateNewCusomerType,
        callback: @escaping ((
            ///personal, empresaFisica, empresaMoral, organizacion
            _ acctType: CustAcctTypes,
            /// general, business
            _ custType: CreateNewCusomerType,
            _ searchTerm: String
        ) -> ())
    ) {
        self.searchTerm = searchTerm
        self.custType = custType
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.view)
                .onClick{
                    self.remove()
                }
            
            H1("Seleccione tipo de Cliente")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(12.px)
            
            Div{
            
                if self.custType == .general {
                    
                    // Personal
                    
                    Div{
                        Img()
                            .src("/skyline/media/icon-personal.png")
                            .height(48.px)
                            .marginLeft(10.percent)
                            .marginRight(25.px)
                        
                        B("P")
                            .color(.highlighBlue)
                        Span("ersonal")
                    }
                    .align(.left)
                    .fontSize(48.px)
                    .width(80.percent)
                    .class(.smallButtonBox)
                    .marginBottom(7.px)
                    .onClick {
                        self.createCustForm(acctType: .personal)
                    }
                    
                    
                    Div()
                        .class(.clear)
                        .marginTop(12.px)
                    
                }
                
                // Biz - Fisical
                Div{
                    Img()
                        .src("/skyline/media/icon-biz.png")
                        .height(48.px)
                        .marginLeft(10.percent)
                        .marginRight(25.px)
                    
                    Span("Empresa ")
                    
                    B("F")
                        .color(.highlighBlue)
                    Span("isica")
                }
                .align(.left)
                .fontSize(48.px)
                .width(80.percent)
                .class(.smallButtonBox)
                .marginBottom(7.px)
                .onClick {
                    self.createCustForm(acctType: .empresaFisica)
                }
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                // biz - Moral
                
                Div{
                    Img()
                        .src("/skyline/media/icon-biz.png")
                        .height(48.px)
                        .marginLeft(10.percent)
                        .marginRight(25.px)
                    
                    Span("Empresa ")
                    B("M")
                        .color(.highlighBlue)
                    Span("oral")
                }
                .align(.left)
                .fontSize(48.px)
                .width(80.percent)
                .class(.smallButtonBox)
                .marginBottom(7.px)
                .onClick {
                    self.createCustForm(acctType: .empresaMoral)
                }
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                // Non Profit
                
                Div{
                    Img()
                        .src("/skyline/media/icon-nonprofit.png")
                        .height(48.px)
                        .marginLeft(10.percent)
                        .marginRight(25.px)
                    
                    B("O")
                        .color(.highlighBlue)
                    Span("rganizacion")
                }
                .align(.left)
                .fontSize(48.px)
                .width(80.percent)
                .class(.smallButtonBox)
                .marginBottom(7.px)
                .onClick {
                    self.createCustForm(acctType: .organizacion)
                }
            }
            .align(.center)

            Div()
                .class(.clear)
                .marginTop(12.px)
            
        }
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .padding(all: 12.px)
        .width(50.percent)
        .position(.absolute)
        .left(25.percent)
        .top(24.percent)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        super.buildUI()
    }
    
    func createCustForm( acctType: CustAcctTypes){
        
        //SkylineApp.current.$keyUp.removeAllListeners()
        
        self.callback(
            acctType,
            self.custType,
            self.searchTerm
        )
        
        self.remove()
        
    }
    
}

