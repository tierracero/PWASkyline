//
//  SearchCustomerFiscalView.swift
//  
//
//  Created by Victor Cantu on 10/26/22.
//

import Foundation
import TCFundamentals
// import SkylinePublicAPI
import Web
import TCFireSignal

class SearchCustomerFiscalView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ account: CustAcctFiscal
    ) -> ())
    private var create: ((
        _ term: String
    ) -> ())
    
    init(
        term: String? = nil,
        callback: @escaping ((
            _ account: CustAcctFiscal
        ) -> ()),
        create: @escaping ((
            _ term: String
        ) -> ())
    ) {
        self.callback = callback
        self.create = create
        
        if let term {
            self.term = term
        }
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""
    
    @State var results: [CustAcctFiscal] = []
    
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
    
    lazy var noResultDiv = Div {
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
            VTitle("Buscar Cuenta Fiscal") {
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
                        .class(
                            .uibtn,
                            Class(TCCrystalSurfaceClass.customerLookupCreate)
                        )
                        .onClick {
                    
                            if let _ = Int(self.term) {
                                if self.term.count < 5 {
                                    showError(.invalidFormat, "Si busca por telefono, debera ingrear 5 digitos por lo menos")
                                    return
                                }
                            }
                            else{
                                if self.term.count < 4 {
                                    showError(.invalidFormat, "Busqueda debe incluir por lo menos 4 caracteres")
                                    return
                                }
                            }
                            
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
                
                self.resultDiv.appendChild(
                    Div {
                        Div("\(prof.fiscalRfc) \(prof.fiscalRazon) \(prof.businessName)".purgeSpaces)
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.customerLookupBusiness)
                            )
                        
                        Div("\(prof.firstName) \(prof.lastName)")
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.customerLookupName)
                            )
                    }
                        .class(
                            .uibtnLarge,
                            Class(TCCrystalSurfaceClass.customerLookupItem)
                        )
                        .onClick {
                            self.callback(prof)
                            self.remove()
                        })
                
            }
        }
        
        if !term.isEmpty {
            
            self.seachCustomerField.class(.isLoading)
            
            searchAccountFiscal(term: term) { _term, resp in
                
                self.seachCustomerField.removeClass(.isLoading)
                
                if resp.isEmpty {
                    self.create(self.term)
                    self.remove()
                }
                else if resp.count == 1 {
                    self.callback(resp.first!)
                    self.remove()
                }
                else {
                    self.results = resp
                }
                
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        if term.isEmpty {
            seachCustomerField.select()
        }
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
        
        Console.clear()

        print("🟡  searchAccountFiscal")

        searchAccountFiscal(term: term) { _term, resp in

            print("🟢  searchAccountFiscal")
            
            self.seachCustomerField
                .removeClass(.isLoading)
            
            if self.term != _term {
                print("⚠️  searchAccountFiscal")
                return
            }
            
            print("🟢  searchAccountFiscal resp \(resp.count)")

            self.results = resp
            
        }
        
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $term.removeAllListeners()
        $results.removeAllListeners()
    }
}
