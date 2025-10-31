//
//  BudgetEditItemView.swift
//  
//
//  Created by Victor Cantu on 10/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class BudgetEditItemView: Div {
    
    override class var name: String { "div" }
    
    ///service, product, manual, rental
    let type: ChargeType
    
    let orderid: UUID
    
    let budgetid: UUID
    
    let objectid: UUID
    
    var name: String
    
    @State var price: String
    
    @State var units: String
    
    private var updateItem: ((
        _ units: Int64,
        _ price: Int64
    ) -> ())
    
    private var deleteItem: ((
    ) -> ())
    
    init(
        type: ChargeType,
        orderid: UUID,
        budgetid: UUID,
        objectid: UUID,
        name: String,
        price: String,
        units: String,
        updateItem: @escaping ((
            _ units: Int64,
            _ price: Int64
        ) -> ()),
        deleteItem: @escaping ((
        ) -> ())
    ) {
        self.type = type
        self.orderid = orderid
        self.budgetid = budgetid
        self.objectid = objectid
        self.name = name
        self.price = price
        self.units = units
        self.updateItem = updateItem
        self.deleteItem = deleteItem
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var unitsField = InputText(self.$units)
        .class(.textFiledBlackDarkLarge)
        .placeholder("0")
        .marginTop(-3.px)
        .fontSize(24.px)
        .height(32.px)
        .textAlign(.right)
        .onFocus { tf in tf.select() }
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
    
    lazy var priceField = InputText(self.$price)
        .class(.textFiledBlackDarkLarge)
        .textAlign(.right)
        .placeholder("0")
        .marginTop(-3.px)
        .fontSize(24.px)
        .height(32.px)
        .textAlign(.right)
        .onFocus { tf in tf.select() }
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
    
    var currentUnits: Int64 = 0
    
    var currentPrice: Int64 = 0
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                
                if self.type == .product {
                    
                    Img()
                        .src("/skyline/media/info.png")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .height(24.px)
                        .float(.right)
                        .onClick {
                            
                            let view = ManagePOC(
                                leveltype: CustProductType.all,
                                levelid: nil,
                                levelName: "",
                                pocid: self.objectid,
                                titleText: "",
                                quickView: false
                            ) {  _, _, _, _, _, _, _, _, _ in
                                
                            } deleted: {
                                
                            }
                            
                            addToDom(view)
                            
                        }
                }
                
                H2("Editar Cargo")
                    .color(.lightBlueText)
                
            }
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Label("Unidades")
                    .color(.gray)
                
                Div{
                    
                    self.unitsField
                }
                
            }
            .class(.section)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                
                Label("Nombre")
                    .color(.gray)
                
                Div{
                    
                    InputText(self.name)
                        .class(.textFiledBlackDarkLarge)
                        .textAlign(.right)
                        .placeholder("0")
                        .marginTop(-3.px)
                        .fontSize(24.px)
                        .disabled(true)
                        .height(32.px)
                }
            
            }
            .class(.section)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                
                Label("Precio")
                    .color(.gray)
                
                Div{
                    self.priceField
                }
                
            }
            .class(.section)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                
                Div{
                    Img()
                        .src("/skyline/media/cross.png")
                        .paddingRight(7.px)
                        .height(24.px)
                    
                    Span("Eliminar")
                }
                .class(.uibtnLarge)
                .marginTop(12.px)
                .float(.left)
                .onClick {
                    self.removeCharge()
                }
                
                
                Div{
                    Img()
                        .src("/skyline/media/diskette.png")
                        .paddingRight(7.px)
                        .height(24.px)
                    
                    Span("Guardar")
                    
                }
                .class(.uibtnLargeOrange)
                .float(.right)
                .onClick {
                    self.editCharge()
                }
                
                Div().class(.clear)
                
            }
            
            
        }
        .custom("left", "calc(50% - 200px)")
        .custom("top", "calc(50% - 150px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        
        .width(400.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if let cu = Float(units)?.toCents {
            currentUnits = cu
        }
        
        if let cu = Float(price)?.toCents {
            currentPrice = cu
        }
    }
    
    override func didAddToDOM(){
        super.didAddToDOM()
        
        self.unitsField.select()
        
    }
    
    func editCharge(){
        
        guard let updatedUnits = Float(units.replace(from: ",", to: ""))?.toCents else {
            showError(.formatoInvalido, "Ingrese unidades validas.")
            self.unitsField.select()
            return
        }
        
        guard let updatedCost = Float(price.replace(from: ",", to: ""))?.toCents else {
            showError(.formatoInvalido, "Ingrese costo validas.")
            self.unitsField.select()
            return
        }
        
        if currentUnits == updatedUnits && currentPrice == updatedCost {
            self.unitsField.select()
            return
        }
        
        loadingView(show: true)
        
        API.custOrderV1.editBudgetObject(
            orderid: orderid,
            budgetid: budgetid,
            objectid: objectid,
            units: updatedUnits,
            unitCost: updatedCost,
            name: name
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
            
            self.updateItem(updatedUnits, updatedCost)
            self.remove()
            
        }
        
    }
    
    func removeCharge(){
        
        addToDom(ConfirmView(
            type: .aproveDeny,
            title: "Remover Cargo",
            message: "¿Esta seguro que quiere remover?\n\(name.uppercased())",
            callback: { isConfirmed, comment in
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.removeBudgetObject(
                        orderid: self.orderid,
                        budgetid: self.budgetid,
                        objectid: self.objectid,
                        units: 0.toInt64,
                        unitCost: 0.toInt64,
                        name: self.name
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else {
                            showError(.errorGeneral, resp.msg)
                            return
                        }
                        
                        self.deleteItem()
                        
                        self.remove()
                        
                    }
                }
            }))
        
    }
    
}
