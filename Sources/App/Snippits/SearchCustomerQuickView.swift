//
//  SearchCustomerQuickView.swift
//  
//
//  Created by Victor Cantu on 2/3/23.
//

import Foundation
import TCFundamentals
// import SkylinePublicAPI
import Web
import TCFireSignal

class SearchCustomerQuickView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ account: CustAcctSearch
    ) -> ())
    
    private var create: ((
        _ term: String
    ) -> ())
    
    init(
        callback: @escaping ((
            _ account: CustAcctSearch
        ) -> ()),
        create: @escaping ((
            _ term: String
        ) -> ())
    ) {
        self.callback = callback
        self.create = create
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""
    
    @State var results: [CustAcctSearch] = []
    
    @State var canCreateAccount = true
    
    lazy var seachCustomerField = InputText(self.$term)
        .custom("width","calc(100% - 210px)")
        .placeholder("Mobile, RFC, correo, razon...")
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
                self.searchCustomer()
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
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Buscar Cuenta de Cliente")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            /// Tool
            Div{
                self.seachCustomerField
                
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
                    self.searchCustomer()
                }
                
                Div{
                    
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .paddingRight(0.px)
                            .height(18.px)
                    }
                    .marginRight(7.px)
                    .float(.left)
                    
                    Label("Crear")
                }
                .hidden(self.$canCreateAccount.map{ !$0 })
                .marginRight(7.px)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    
                    self.create(self.term)
                    
                    self.remove()
                    
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
        
        super.buildUI()
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        
        $results.listen {
            
            self.resultDiv.innerHTML = ""
            
            $0.forEach { prof in
                
                let bizname = "\(prof.fiscalRfc) \(prof.fiscalRazon) \(prof.businessName)".purgeSpaces
                
                self.resultDiv.appendChild(
                    Div{
                        
                        if prof.isConcessionaire {
                            
                            Div{
                                Span("Concessionario")
                                    .color(.gray)
                                
                                Img()
                                    .src("skyline/media/icon-fiscal.png")
                                    .width(18.px)
                                
                            }
                            
                            Div().clear(.both)
                        }
                    
                        if !bizname.isEmpty {
                            
                            Div(bizname)
                                .class(.oneLineText)
                                .fontSize(18.px)
                            
                            Div().clear(.both).paddingTop(7.px)
                        }
                        
                        if prof.CardID.isEmpty {
                            Div("\(prof.firstName) \(prof.lastName)")
                                .class(.oneLineText)
                                .fontSize(23.px)
                        }
                        else {
                            Div{
                                
                                Div("\(prof.firstName) \(prof.lastName)")
                                    .custom("width", "calc(100% - 50px)")
                                    .class(.oneLineText)
                                    .fontSize(23.px)
                                    .float(.left)
                                
                                Div{
                                    Table{
                                        Tr{
                                            Td{
                                                Img()
                                                    .src("skyline/media/star_yellow.png")
                                                    .width(18.px)
                                            }
                                            .verticalAlign(.middle)
                                            .align(.center)
                                        }
                                    }
                                    .height(100.percent)
                                }
                                .width(50.px)
                                .float(.left)
                                
                                Div().clear(.both)
                                
                            }
                        }
                        
                    }
                    .width(96.percent)
                    .class(.uibtnLarge)
                    .onClick {
                        self.callback(prof)
                        self.remove()
                    }
                )
            }
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        seachCustomerField.select()
    }
    
    func searchCustomer(){
        
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
        
        self.seachCustomerField
            .class(.isLoading)
        
        searchAccount(term: term) { _term, resp in
            
            self.seachCustomerField
                .removeClass(.isLoading)
            
            if self.term != _term {
                return
            }
            
            self.results = resp
            
        }
        
    }
}

