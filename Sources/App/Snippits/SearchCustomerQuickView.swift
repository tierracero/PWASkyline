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
        .placeholder("Mobile, RFC, correo, razon...")
        .class(
            .textFiledBlackDark,
            Class(TCCrystalSurfaceClass.customerLookupInput)
        )
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
        .class(
            .roundDarkBlue,
            Class(TCCrystalSurfaceClass.customerLookupEmpty)
        )
        .overflow(.hidden)
    
    lazy var resultDiv = Div()
        .class(
            .roundDarkBlue,
            Class(TCCrystalSurfaceClass.customerLookupList)
        )
        .overflow(.auto)
    
    @DOM override var body: DOM.Content {
        VPopUp(.custome(w: 820, h: 610)) {
            VTitle("Buscar Cuenta de Cliente", icon: "icon_user.png") {
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                Div {
                    Div {
                        self.seachCustomerField

                        Div {
                            Img()
                                .src("/skyline/media/zoom.png")
                                .height(18.px)

                            Label("Buscar")
                        }
                        .class(
                            .uibtn,
                            Class(TCCrystalSurfaceClass.customerLookupSearch)
                        )
                        .onClick {
                            self.searchCustomer()
                        }

                        Div {
                            Img()
                                .src("/skyline/media/add.png")
                                .height(18.px)

                            Label("Crear")
                        }
                        .hidden(self.$canCreateAccount.map { !$0 })
                        .class(
                            .uibtn,
                            Class(TCCrystalSurfaceClass.customerLookupCreate)
                        )
                        .onClick {
                            self.create(self.term)
                            self.remove()
                        }
                    }
                    .class(Class(TCCrystalSurfaceClass.customerLookupToolbar))

                    Div {
                        self.noResultDiv
                            .hidden(self.$results.map { !$0.isEmpty })
                            .display(self.$results.map { !$0.isEmpty ? .none : .block })

                        self.resultDiv
                            .hidden(self.$results.map { $0.isEmpty })
                            .display(self.$results.map { $0.isEmpty ? .none : .block })
                    }
                    .class(Class(TCCrystalSurfaceClass.customerLookupResults))
                }
                .class(Class(TCCrystalSurfaceClass.customerLookupBody))
            }
        }
    }
    
    override func buildUI() {
        
        super.buildUI()

        TCCrystalSurfaceTheme.apply(to: self, variant: .customerLookup)
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.fixed)
        
        $results.listen {
            
            self.resultDiv.innerHTML = ""
            
            $0.forEach { prof in
                
                let bizname = "\(prof.fiscalRfc) \(prof.fiscalRazon) \(prof.businessName)".purgeSpaces
                
                self.resultDiv.appendChild(
                    Div {
                        
                        if prof.isConcessionaire {
                            
                            Div {
                                Span("Concessionario")
                                
                                Img()
                                    .src("skyline/media/icon-fiscal.png")
                                    .width(18.px)
                                
                            }
                            .class(Class(TCCrystalSurfaceClass.customerLookupBadge))
                        }

                        if !bizname.isEmpty {
                            
                            Div(bizname)
                                .class(
                                    .oneLineText,
                                    Class(TCCrystalSurfaceClass.customerLookupBusiness)
                                )
                        }
                        
                        if prof.CardID.isEmpty {
                            Div("\(prof.firstName) \(prof.lastName)")
                                .class(
                                    .oneLineText,
                                    Class(TCCrystalSurfaceClass.customerLookupName)
                                )
                        }
                        else {
                            Div {
                                
                                Div("\(prof.firstName) \(prof.lastName)")
                                    .class(
                                        .oneLineText,
                                        Class(TCCrystalSurfaceClass.customerLookupName)
                                    )
                                
                                Div {
                                    Img()
                                        .src("skyline/media/star_yellow.png")
                                        .width(18.px)
                                }
                                .class(Class(TCCrystalSurfaceClass.customerLookupReward))
                                
                            }
                            .class(Class(TCCrystalSurfaceClass.customerLookupMeta))
                        }
                        
                    }
                    .class(
                        .uibtnLarge,
                        Class(TCCrystalSurfaceClass.customerLookupItem)
                    )
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

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $term.removeAllListeners()
        $results.removeAllListeners()
        $canCreateAccount.removeAllListeners()
    }
}
