//
//  ManagePOC+SelectProductSubType.swift
//
//
//  Created by Victor Cantu on 10/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    class SelectProductSubType: Div {
        
        override class var name: String { "div" }
        
        /// Wether it will show all the tooks for creation or not
        let productType: String
        
        let productSubType: String
        
        /// When you do changes to  soc create a call back to parent view
        private var callback: ((
            _ productSubType: String
        ) -> ())
        
        init(
            productType: String,
            productSubType: String,
            callback: @escaping ( (
                _ productSubType: String
            ) -> ())
            
        ) {
            self.productType = productType
            self.productSubType = productSubType
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var selectedBrand: String = ""
        
        @State var items: [String] = []
        
        lazy var selectedBrandField = InputText(self.$selectedBrand)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .placeholder("Ingrese Marca")
            .height(28.px)
            .onFocus { tf in
                tf.select()
            }
            .onKeyUp { tf, event in
                self.loadBrands()
            }
        
        lazy var brandGrid = Div()
            .custom("height", "calc(100% - 70px)")
            .class(.roundDarkBlue)
            .overflow(.auto)
        
        lazy var noBrandGrid = Div {
            Table{
                Tr{
                    Td{
                        Div{
                            Span("No hay SUB TIPOS para \(self.productType)")
                            Br()
                            Br()
                            Span("Ingrese marca para crear la...")
                        }
                        .hidden(self.$selectedBrand.map{ !$0.isEmpty })
                        .color(.white)
                        
                        Div( self.$selectedBrand.map{ "Crear Sub Tipo: \( $0.capitalizingFirstLetters(true) )" } )
                            .hidden(self.$selectedBrand.map{ $0.isEmpty })
                            .custom("width", "calc(100% - 21px)")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                self.createBrand()
                            }
                    }
                    .align(.center)
                    .verticalAlign(.middle)
                }
            }
            .width(100.percent)
            .height(100.percent)
        }
            .custom("height", "calc(100% - 70px)")
            .class(.roundDarkBlue)
        
        @DOM override var body: DOM.Content {
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView4)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Selecciona Sub Tipo de Producto")
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                
                self.selectedBrandField
                    .marginBottom(7.px)
                
                self.brandGrid
                    .hidden(self.$items.map { $0.isEmpty })
                
                self.noBrandGrid
                    .hidden(self.$items.map { !$0.isEmpty })
                
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(50.percent)
            .width(40.percent)
            .left(30.percent)
            .top(25.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            top(0.px)
            left(0.px)
            
            loadingView(show: true)
            
            API.custPOCV1.getProductSubTypes(productType: productType) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                productSubTypeRefrence[self.productType] = data
                
                self.items = data
                
                self.loadBrands()
            }
        }
        
        func loadBrands() {
            
            brandGrid.innerHTML = ""
            
            if selectedBrand.isEmpty {
                items.forEach { item in
                    brandGrid.appendChild(
                        Div(item)
                            .custom("width", "calc(100% - 21px)")
                            .class(.uibtnLarge)
                            .onClick {
                                self.callback(item)
                                self.remove()
                            }
                    )
                }
            }
            else {
                
                var included: [String] = []
                
                items.forEach { item in
                    
                    if item.lowercased().hasPrefix(selectedBrand.lowercased()) {
                        
                        included.append(item)
                        
                        brandGrid.appendChild(
                            Div(item)
                                .custom("width", "calc(100% - 21px)")
                                .class(.uibtnLarge)
                                .onClick {
                                    self.callback(item)
                                    self.remove()
                                }
                        )
                    }
                }
                
                items.forEach { item in
                    
                    if included.contains(item) { return }
                    
                    if item.lowercased().contains(selectedBrand.lowercased()) {
                        
                        included.append(item)
                        
                        brandGrid.appendChild(
                            Div(item)
                                .custom("width", "calc(100% - 21px)")
                                .class(.uibtnLarge)
                                .onClick {
                                    self.callback(item)
                                    self.remove()
                                }
                        )
                    }
                }
                
                if included.isEmpty {
                    
                    brandGrid.appendChild(
                        Table{
                            Tr{
                                Td{
                                    
                                    Div( self.$selectedBrand.map{ "Crear Sub Tipo: \( $0.capitalizingFirstLetters(true) )" } )
                                        .custom("max-width", "calc(100% - 21px)")
                                        .class(.uibtnLargeOrange)
                                        .onClick {
                                            self.createBrand()
                                        }
                                }
                                .align(.center)
                                .verticalAlign(.middle)
                            }
                        }
                        .width(100.percent)
                        .height(100.percent)
                    )
                    
                }
                
            }
        }
        
        func createBrand() {
            
            selectedBrand = selectedBrand.purgeSpaces.purgeHtml.capitalizingFirstLetters(true)
            
            if selectedBrand.isEmpty {
                return
            }
            
            self.appendChild(ConfirmView(
                type: .yesNo,
                title: "Crear Sub Tipo de Producto",
                message: "Confirm creacion de:\n\"\(selectedBrand)\"") { isConfirmed, comment in
                    if isConfirmed {
                        
                        loadingView(show: true)
                        
                        API.custPOCV1.createProductSubType(
                            productType: self.productType,
                            productSubType: self.selectedBrand
                        ) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else {
                                showError(.errorDeCommunicacion, .serverConextionError)
                                return
                            }

                            guard resp.status == .ok else{
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            self.callback(self.selectedBrand)
                            
                            if let refrence = productSubTypeRefrence[self.productType] {
                                if refrence.contains(self.selectedBrand) {
                                    return
                                }
                                productSubTypeRefrence[self.productType]?.append(self.selectedBrand)
                            }
                            else {
                                productSubTypeRefrence[self.productType] = [self.selectedBrand]
                            }
                            
                            self.remove()
                        }
                    }
                }
            )
        }
    }
}
