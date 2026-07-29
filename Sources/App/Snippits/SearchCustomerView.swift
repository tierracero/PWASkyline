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
        .placeholder("Ingrese teléfono")
        .width(100.percent)
        .height(48.px)
        .fontSize(18.px)
        .class(.textFiledLight)
        .onKeyUp { input, event in
            if event.code == "Enter" || event.code ==  "NumpadEnter" {
                self.searchCustomer()
            }
        }
    
    
    @DOM override var body: DOM.Content {
        
        VPopUp(.fitContent(w: 560)) {

            VTitle("Buscar Cliente") {
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.full) {
                    VBox(.raised) {
                        UMinorTitle("Ingrese teléfono, nombre de empresa, o nombre y apellido.")
                            .custom("line-height", "1.5")

                        UField("Teléfono, empresa o nombre", required: false) {
                            self.seachCustomerField
                        }
                        .marginTop(14.px)

                        ULargeButton("Buscar Cliente")
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(100.percent)
                            .marginTop(16.px)
                            .onClick(self.searchCustomer)
                    }
                }
            }
        }
    }
    
    override func buildUI() {
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        
        super.buildUI()

        TCCrystalSurfaceTheme.apply(to: self, variant: .customerSearch)
        
    }
    
    func searchCustomer(){
        
        term = term.purgeSpaces
        
        if term.isEmpty {
            return
        }
        
        if let _ = Int64(term) {
            if term.count < 5 {
                showError(.invalidFormat, "Si busca por telefono, debera ingrear 5 digitos por lo menos")
                return
            }
        }
        else{
            if term.count < 4 {
                showError(.invalidFormat, "Busqueda debe incluir por lo menos 4 caracteres")
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
    

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $term.removeAllListeners()
    }
}
