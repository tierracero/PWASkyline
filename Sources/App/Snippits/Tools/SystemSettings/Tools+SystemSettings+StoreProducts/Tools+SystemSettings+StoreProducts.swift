//
//  Tools+SystemSettings+StoreProducts.swift
//
//
//  Created by Victor Cantu on 2/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings {
    
    
    class StoreProducts: Div {
        
        override class var name: String { "div" }
        
        let configStoreProduct: ConfigStoreProduct
        
        init(
            configStoreProduct: ConfigStoreProduct
        ) {
            self.configStoreProduct = configStoreProduct
            
            super.init()
            
        }
        
        /// Currencies
        /// EUR, USD, MXN
        @State var defaultCurrencie: String = ""//Currencies.MXN.rawValue
        
        /// Producduct aditional tag
        @State var tagOne: String = ""
        
        /// Producduct aditional tag
        @State var tagTwo: String = ""
        
        /// Producduct aditional tag
        @State var tagThree: String = ""
        
        /// Int
        /// Warenty In Days
        @State var defaultWarentySelf: String = ""
        
        /// Int
        /// Warenty In months
        @State var defaultWarentyProvider: String = ""
        
        /// InventorieZeroSale
        /// createSaleOrder, doNotSale
        @State var inventorieZeroSale: String = ""//InventorieZeroSale.createSaleOrder.rawValue
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        /// Currencies
        /// EUR, USD, MXN
        lazy var defaultCurrencieSelect = Select(self.$defaultCurrencie)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        /// Producduct aditional tag
        lazy var tagOneField = InputText(self.$tagOne)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Etiqueta Adicional")
            
        /// Producduct aditional tag
        lazy var tagTwoField = InputText(self.$tagTwo)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Etiqueta Adicional")
        
        /// Producduct aditional tag
        lazy var tagThreeField = InputText(self.$tagThree)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Etiqueta Adicional")
        
        /// Int
        /// Warenty In Days
        lazy var defaultWarentySelfField = InputText(self.$defaultWarentySelf)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("0~90")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        /// Int
        /// Warenty In months
        lazy var defaultWarentyProviderField = InputText(self.$defaultWarentyProvider)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("0~36")
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
        
        /// InventorieZeroSale
        /// createSaleOrder, doNotSale
        lazy var inventorieZeroSaleSelect = Select(self.$inventorieZeroSale)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        @DOM override var body: DOM.Content {
            Div{
                
                H3("Etiquetas de Producto").color(.lightBlueText)
                Div().clear(.both)
                Span("Permite agregar campos de texto personalizado a los productos").color(.white)
                Div().clear(.both)
                
                /// TAG1
                Div{
                    Div{
                        Label("Etiquetas Adicionales Uno")
                            .color(.lightGray)
                        Div().clear(.both)
                        Label("Dejar vacio para inactivo")
                            .fontSize(14.px)
                            .color(.gray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.tagOneField
                    }
                    .class(.oneHalf)
                    
                    Div().clear(.both)
                }
                Div().clear(.both).height(7.px)
                
                /// TAG2
                Div{
                    Div{
                        Label("Etiquetas Adicionales Dos")
                            .color(.lightGray)
                        Div().clear(.both)
                        Label("Dejar vacio para inactivo")
                            .fontSize(14.px)
                            .color(.gray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.tagTwoField
                    }
                    .class(.oneHalf)
                    Div().clear(.both)
                }
                Div().clear(.both).height(7.px)
                
                /// TAG3
                Div{
                    Div{
                        Label("Etiquetas Adicionales Tres")
                            .color(.lightGray)
                        Div().clear(.both)
                        Label("Dejar vacio para inactivo")
                            .fontSize(14.px)
                            .color(.gray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.tagThreeField
                    }
                    .class(.oneHalf)
                    Div().clear(.both)
                }
                
                Div().clear(.both).height(7.px)
                
            }
            .custom("width", "calc(50% - 7px)")
            .height(100.percent)
            .paddingRight( 3.px)
            .paddingLeft( 3.px)
            .float(.left)
            
            Div{
                
                H3("Garantia").color(.lightBlueText)
                Div().clear(.both)
                
                /// Warenty Self, Days.
                Div{
                    Div{
                        Label("Garantia Interna (días)")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.defaultWarentySelfField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Warentie Provider, Months,
                Div{
                    Div{
                        Label("Garantia Extenrna (meses)")
                            .color(.lightGray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.defaultWarentyProviderField
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                H3("Otras Configuraciones").color(.lightBlueText)
                Div().clear(.both)
                
                /// Inventorie Zero
                Div{
                    Div{
                        Label("Inventario Zero")
                            .color(.lightGray)
                        Div().clear(.both)
                        Label("Accion si no hay inventario")
                            .fontSize(14.px)
                            .color(.gray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.inventorieZeroSaleSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
                /// Cirrencie
                Div{
                    Div{
                        Label("Moneda Por Defecto")
                            .color(.lightGray)
                        Div().clear(.both)
                        Label("productos registrados en que moneda")
                            .fontSize(14.px)
                            .color(.gray)
                    }
                    .class(.oneHalf)
                    
                    Div{
                        self.defaultCurrencieSelect
                    }
                    .class(.oneHalf)
                }
                Div().clear(.both).height(7.px)
                
            }
            .custom("width", "calc(50% - 7px)")
            .height(100.percent)
            .paddingRight( 3.px)
            .paddingLeft( 3.px)
            .float(.left)
            
            Div("Guardar Cambios")
                .border(width: .thin, style: .solid, color: .darkGray)
                .custom("box-shadow", "1px 1px 28px #000000")
                .class(.uibtnLargeOrange)
                .position(.absolute)
                .bottom(12.px)
                .right(12.px)
                .onClick {
                    self.saveData()
                }
        }
        
        override func buildUI() {
            super.buildUI()
            
            height(100.percent)
        
            Currencies.allCases.forEach { item in
                defaultCurrencieSelect.appendChild(Option(item.description).value(item.rawValue))
            }
            
            InventorieZeroSale.allCases.forEach { item in
                inventorieZeroSaleSelect.appendChild(Option(item.description).value(item.rawValue))
            }
            
            /// Currencies
            defaultCurrencie = configStoreProduct.defaultCurrencie.rawValue
            
            tagOne = configStoreProduct.tagOne
            
            tagTwo = configStoreProduct.tagTwo
            
            tagThree = configStoreProduct.tagThree
            
            defaultWarentySelf = configStoreProduct.defaultWarentySelf.toString
            
            defaultWarentyProvider = configStoreProduct.defaultWarentyProvider.toString
            
            /// InventorieZeroSale
            inventorieZeroSale = configStoreProduct.inventorieZeroSale.rawValue
            
        }
        
        func saveData(){
            
            /// Currencies
            guard let defaultCurrencie = Currencies(rawValue: defaultCurrencie) else {
                showError(.generalError, "Seleccione tipo de moneda")
                return
            }
            
            guard let defaultWarentySelf = Int(defaultWarentySelf) else {
                showError(.generalError, "Seleccione garantia extenra valida")
                return
            }
            
            guard let defaultWarentyProvider = Int(defaultWarentyProvider) else {
                showError(.generalError, "Seleccione garantia extenra valida")
                return
            }
            
            /// InventorieZeroSale
            guard let inventorieZeroSale = InventorieZeroSale(rawValue: inventorieZeroSale) else {
                showError(.generalError, "Seleccione accion de zero inventario")
                return
            }
            
            loadingView(show: true)
            
            API.custAPIV1.saveConfigStoreProduct(
                defaultCurrencie: defaultCurrencie,
                tagOne: tagOne,
                tagTwo: tagTwo,
                tagThree: tagThree,
                defaultWarentySelf: defaultWarentySelf,
                defaultWarentyProvider: defaultWarentyProvider,
                inventorieZeroSale: inventorieZeroSale
            ) { resp in
        
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                // TODO: update sistem configStoreProduct
                
            }
        }
    }
}
