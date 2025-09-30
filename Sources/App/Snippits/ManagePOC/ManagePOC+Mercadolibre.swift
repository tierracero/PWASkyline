//
//  ManagePOC+Mercadolibre.swift
//
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    
    class Mercadolibre: Div {
        
        var productType: State<String>
        
        var productSubType: State<String>
        
        var brand: State<String>
        
        var model: State<String>
        
        var name: State<String>
        
        public var productId: String
        
        /// Third party department identifier
        @State var categoryId: String
        
        /// Third party department identifier
        @State var inventoryId: String
        
        @State var siteId: String
        
        /// Auto Puse products in zero inventory case
        @State var autoPause: Bool
        
        /// active, paused
        var saleStatus: OnSaleStatus
        
        /// saleStatus helper
        @State var isActive: Bool
        
        var price: PriceType
        
        @State var allowInPromoPrice: Bool
        
        init(
            productType: State<String>,
            productSubType: State<String>,
            brand: State<String>,
            model: State<String>,
            name: State<String>,
            mercadoLibre: CustPOC.MercadoLibre
        ) {
            
            self.productType = productType
            
            self.productSubType = productSubType
            
            self.brand = brand
            
            self.model = model
            
            self.name = name
            
            self.productId = mercadoLibre.productId ?? ""
            
            self.categoryId = mercadoLibre.categoryId ?? ""
            
            self.inventoryId = mercadoLibre.inventoryId ?? ""
            
            self.siteId = mercadoLibre.siteId
            
            self.autoPause = mercadoLibre.autoPause
            
            self.saleStatus = mercadoLibre.saleStatus
            
            self.price = mercadoLibre.price
            
            self.allowInPromoPrice = mercadoLibre.allowInPromoPrice
            
            self.isActive = (mercadoLibre.saleStatus == .active)
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var priceTypeListener = ""
        
        lazy var productIdField = InputText(self.productId)
            .custom("width", "calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .placeholder("Id de tienda")
            .disabled(true)
            .height(28.px)
        
        lazy var categoryIdField = Div(self.$categoryId.map{ $0.isEmpty ? "Id de Categoria" : $0 })
            .color(self.$categoryId.map{ $0.isEmpty ? .gray : .lightGray })
            .class(.textFiledBlackDark, .oneLineText)
            .padding(all: 3.px)
            .marginBottom(5.px)
            .textAlign(.left)
            .cursor(.pointer)
            .fontSize(20.px)
            .onClick {
                self.selectProductCategorie()
            }
        
        lazy var priceTypeSelect = Select(self.$priceTypeListener)
            .body(content: {
                Option("Seleccione Tipo de Precio")
                    .value("")
            })
            .custom("width", "calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(28.px)
        
        @DOM override var body: DOM.Content {
            Div{
                Label("Identificador")
                    .color(.lightGray)
                Div().clear(.both).height(3.px)
                
                self.productIdField
            }
            .width(50.percent)
            .float(.left)
            Div{
                Label("Categoria")
                    .color(.lightGray)
                Div().clear(.both).height(3.px)
                
                self.categoryIdField
            }
            .width(50.percent)
            .float(.left)
            
            Div().clear(.both).height(7.px)
            
            Div{
                Label("Auto Pausa")
                    .color(.lightGray)
                Div().clear(.both).height(3.px)
                
                InputCheckbox().toggle(self.$autoPause)
            }
            .width(50.percent)
            .float(.left)
            Div{
                Label("Activo")
                    .color(.lightGray)
                Div().clear(.both).height(3.px)
                
                InputCheckbox().toggle(self.$isActive)
            }
            .width(50.percent)
            .float(.left)
            
            Div().clear(.both).height(7.px)
            
            Div{
                Label("Tipo de Precio")
                    .color(.lightGray)
                Div().clear(.both).height(3.px)
                
                self.priceTypeSelect
            }
            .width(50.percent)
            .float(.left)
            Div{
                Label("Permitor Prcio Promocional")
                    .color(.lightGray)
                Div().clear(.both).height(3.px)
                
                InputCheckbox().toggle(self.$allowInPromoPrice)
            }
            .width(50.percent)
            .float(.left)
            
            Div().clear(.both).height(7.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            $isActive.listen { self.saleStatus = ($0 ? .active : .paused) }
            
            PriceType.allCases.forEach { type in
                priceTypeSelect.appendChild(Option(type.description)
                    .value(type.rawValue))
            }
            
            priceTypeListener = price.rawValue
            
        }
        
        func selectProductCategorie(){
            
            if productType.wrappedValue.isEmpty {
                showError(.campoRequerido, "Ingrese tipo de producto")
                return
            }
            
            if name.wrappedValue.isEmpty && brand.wrappedValue.isEmpty && model.wrappedValue.isEmpty {
                showError(.campoRequerido, "Ingrese tipo de marca o modelo o nombre")
                return
            }
            
            loadingView(show: true)
            
            API.custPOCV1.categorizer(
                store: .mercadoLibre,
                productType: self.productType.wrappedValue,
                productSubType: self.productSubType.wrappedValue,
                brand: self.brand.wrappedValue,
                model: self.model.wrappedValue,
                name: self.name.wrappedValue
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .payloadDecodError)
                    return
                }
                
                if payload.categories.count == 1 {
                    self.categoryId = payload.categories.first?.subCategorieId ?? ""
                    showSuccess(.operacionExitosa, "Categoria \(self.categoryId)")
                    return
                }
                
                addToDom(SelectThirPartyStoreCategorie(items: payload.categories) { item in
                    self.categoryId = item.subCategorieId
                })
                
            }
        }
    }
}
