//
//  ToolReciveSendInventorySelectPOC.swift
//  
//
//  Created by Victor Cantu on 9/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolReciveSendInventorySelectPOC: Div {
    
    override class var name: String { "div" }
    
    var isManual: Bool
    
    private var selectedPOC: ((
        _ pocid: UUID,
        _ upc: String,
        _ brand: String,
        _ model: String,
        _ name: String,
        _ cost: Int64,
        _ price: Int64,
        _ avatar: String
    ) -> ())
    
    private var createPOC: ((
        _ type: CustProductType,
        _ levelid: UUID?,
        _ titleText: String
    ) -> ())
    
    init(
        isManual: Bool,
        selectedPOC: @escaping ((
            _ pocid: UUID,
            _ upc: String,
            _ brand: String,
            _ model: String,
            _ name: String,
            _ cost: Int64,
            _ price: Int64,
            _ avatar: String
        ) -> ()),
        createPOC: @escaping ((
            _ type: CustProductType,
            _  levelid: UUID?,
            _ titleText: String
        ) -> ())
        
    ) {
        self.isManual = isManual
        self.selectedPOC = selectedPOC
        self.createPOC = createPOC
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var searchTerm: String = ""
    
    @State var selectedDepartmentId: UUID? = nil
    
    @State var selectedDepartment = ""
    
    @State var selectedCategoryId: UUID? = nil
    
    @State var selectedCategory = ""
    
    @State var selectedLineId: UUID? = nil
    
    @State var selectedLine = ""
    
    var items: [Div] = []
    
    var lastSerchedTerm = ""
    
    lazy var seachProductField = InputText(self.$searchTerm)
        .placeholder("Buscar Producto...")
        .class(.textFiledBlackDark)
        .width(97.percent)
        .height(35.px)
        .onKeyUp{
            self.search()
        }
        .onEnter {
            self.search()
        }
    
    lazy var productResultDiv = Div()
        .overflow(.auto)
        .class(.roundBlue)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                  
                H2( "Buscar Productos" )
                    .color( .lightBlueText )
                    .float(.left)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
            
            Span("Busca el producto a relacionar con el articulo.")
                .color(.gray)
            
            Div().class(.clear).marginTop(3.px)
            
            /// Search Product
            Div{
                self.seachProductField
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
                self.productResultDiv
                    .custom("height", "calc(100% - 125px)")
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
                Span("Si no encuentra, puede registrar uno nuevo.")
                    .color(.white)
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
                Div{
                    
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .height(24.px)
                        }
                        .paddingRight(7.px)
                        .paddingTop(4.px)
                        .float(.left)
                        
                        Span("Crear Nuevo Producto")
                            .color(.gray)
                        
                        Div().clear(.both)

                    }
                    .class(.uibtnLarge)
                    .onClick{

                    }
                }
                .align(.center)
                
            }
            .custom("height", "calc(100% - 50px)")

            Div()
                .class(.clear)
                .marginTop(7.px)
            
        }
        .height( 85.percent )
        .top( 7.5.percent )
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
    }
    
    override func didAddToDOM() {
        seachProductField.select()
    }
    
    func search(){
        
        let term = searchTerm.purgeSpaces
        
        if term.count < 4 {
            return
        }
        
        Dispatch.asyncAfter(0.5) {
            
            if term != self.searchTerm.purgeSpaces || self.lastSerchedTerm == term {
                return
            }
            
            self.lastSerchedTerm = term
            
            self.items.forEach { div in
                div.remove()
            }
            
            self.items.removeAll()
            
            self.seachProductField.class(.isLoading)
            
            searchPOC(term: term, costType: .cost_a, getCount: false) { _term, resp in
                
                self.seachProductField.removeClass(.isLoading)

                if term != _term {
                    return
                }
                
                resp.forEach { item in
                    let view = StoreItemPOCView(
                        searchTerm: _term,
                        poc: item
                    ) { update, deleted in
                        
                        API.custPOCV1.getPOCCost(id: item.i) { resp in
                            
                            guard let cost = resp?.data else {
                                showError(.errorDeCommunicacion, .serverConextionError)
                                return
                            }
                            
                            self.confirmSelectedProduct(
                                pocid: item.i,
                                upc: item.u,
                                brand: item.b,
                                model: item.m,
                                name: item.n,
                                cost: cost,
                                price: item.p,
                                avatar: item.a
                            )
                        }
                        
                    }
                    
                    self.items.append(view)
                    
                    self.productResultDiv.appendChild(view)
                    
                }
            }
        }
    }
    
    func confirmSelectedProduct(
        pocid: UUID,
        upc: String,
        brand: String,
        model: String,
        name: String,
        cost: Int64,
        price: Int64,
        avatar: String
    ) {
        if isManual {
            self.selectedPOC(pocid, upc, brand, model, name, cost, price, avatar)
            self.remove()
        }
        else{
            
            WebApp.current.document.body.appendChild(ConfirmView(
                type: .yesNo,
                title: "Relacionar Producto",
                message: "\(brand) \(model) \(name)",
                callback: { isConfirmed, comment in
                    if isConfirmed {
                        self.selectedPOC(pocid, upc, brand, model, name, cost, price, avatar)
                        self.remove()
                    }
                    else{
                        self.seachProductField.select()
                    }
                }))
        } 
    }
    
}

