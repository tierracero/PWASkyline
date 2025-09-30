//
//  SearchCustomerView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class SearchCustomerView: Div {
    
    override class var name: String { "div" }
    
    
    private var callback: ((_ term: String,_ account: [CustAcctSearch]) -> ())
    
    init(
        callback: @escaping ((_ term: String, _ account: [CustAcctSearch]) -> ())
    ) {
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""
    
    lazy var seachCustomerField = InputText(self.$term)
        .placeholder("Ingrese Telefono")
        .width(70.percent)
        .height(52.px)
        .fontSize(36.px)
        .class(.textFiledLight)
        .onKeyUp { input, event in
            if event.code == "Enter" || event.code ==  "NumpadEnter" {
                self.searchCustomer()
            }
        }
    
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.subView)
                .onClick{
                    self.remove()
                }
            
            H2("Buscar Cliente")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(3.px)
            
            Span("Ingese telefono, nombre empresa o nombre y apellido.")
            
            Div{
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                self.seachCustomerField
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                Div{
                    Img()
                        .src("/skyline/media/zoom.png")
                        .height(24.px)
                        .paddingRight(7.px)
                    
                    Span("Buscar Cliente")
                }
                .width(70.percent)
                .fontSize(36.px)
                .align(.center)
                .class(.smallButtonBox)
                .onClick(self.searchCustomer)
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
            }
            .align(.center)
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 134px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 12.px)
        .height(220.px)
        .width(500.px)
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        
        super.buildUI()
        
    }
    
    func searchCustomer(){
        
        term = term.purgeSpaces
        
        if term.isEmpty {
            return
        }
        
        if let _ = Int64(term) {
            if term.count < 5 {
                showError(.formatoInvalido, "Si busca por telefono, debera ingrear 5 digitos por lo menos")
                return
            }
        }
        else{
            if term.count < 4 {
                showError(.formatoInvalido, "Busqueda debe incluir por lo menos 4 caracteres")
                return
            }
        }
        loadingView(show: true)

        searchAccount(term: term) { term, resp in
            loadingView(show: false)

            self.callback(term, resp)

            self.remove()
        }
        
    }
    
}

