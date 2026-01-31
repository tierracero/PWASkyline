//
//  EditChargePOCView.swift
//
//
//  Created by Victor Cantu on 7/10/22.
//

import Foundation
import TCFundamentals
import Web

/**
  General Ruling
 ``POC``
    ❌ units (always 1)
    ✅ cost
    ✅ price
    ✅ name
    ✅ fiscCode
    ✅ fiscUnit
 
 ``SOC``
    ✅ units
    ✅ cost
    ✅ price
    ✅ name
    ✅ fiscCode
    ✅ fiscUnit
    
 ``PAY``
    ❌ units (always 1)
    ❌ cost
    ✅ price
    ✅ name
    ✅ fiscCode
    ❌ fiscUnit
 
``Rent``
    ❌ units (always 1)
    ❌ cost
    ✅ price
    ✅ name
    ❌ fiscCode
    ❌ fiscUnit
 */
class EditChargePOCView: Div {
    
    override class var name: String { "div" }
    
    /// service, product, manual, rental
    var type: ChargeType
    
    var viewId: UUID
    
    var ids: [UUID]
    
    var orderId: UUID
    
    private var delete: ((
        _ ids: [UUID],
        _ name: String,
        _ price: Int64
    ) -> ())
    
    private var callback: ((
        _ ids: [UUID],
        _ units: Int64,
        _ cost: Int64,
        _ price: Int64,
        _ name: String,
        _ fiscCode: String,
        _ fiscUnit: String
    ) -> ())
    
    init(
        /// service, product, manual, rental
        type: ChargeType,
        viewId: UUID,
        ids: [UUID],
        orderId: UUID,
        callback: @escaping ((
            _ ids: [UUID],
            _ units: Int64,
            _ cost: Int64,
            _ price: Int64,
            _ name: String,
            _ fiscCode: String,
            _ fiscUnit: String
        ) -> ()),
        delete: @escaping ((
            _ ids: [UUID],
            _ name: String,
            _ price: Int64
        ) -> ())
    ) {
        self.type = type
        self.viewId = viewId
        self.ids = ids
        self.orderId = orderId
        self.callback = callback
        self.delete = delete
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// Number of units
    @State var units: String = ""
    /// Holder for original data in case dose not have permition to edit this filed, get it form hear more sevurely
    var __units: String = ""
    
    /// Internal cost, what we (the biz cust) pays
    @State var cost: String = ""
    /// Holder for original data in case dose not have permition to edit this filed, get it form hear more sevurely
    var __cost: String = ""
    
    /// Price sold, what final customer pays
    @State var price: String = ""
    /// Holder for original data in case dose not have permition to edit this filed, get it form hear more sevurely
    var __price: String = ""
    var __priceInt: Int64 = 0
    
    /// Name of the finalcial event
    @State var name: String = ""
    /// Holder for original data in case dose not have permition to edit this filed, get it form hear more sevurely
    var __name: String = ""
    
    /// Fiscal Product Code EG: PIANO
    @State var fiscCode: String = ""
    
    /// String that is used to help in the search of an oficcial Fiscal Product Code
    @State var fiscCodeDescription: String = ""
    
    /// Fiscal Unit Code EG: PIEZA
    @State var fiscUnit: String = ""
    
    /// String that is used to help in the search of an oficcial Fiscal Unit Code
    @State var fiscUnitDescription: String = ""
    
    /// if has been loaded
    @State var isLoaded: Bool = false
    
    lazy var unitsField: InputText = InputText(self.$units)
        .disabled({
            (custCatchHerk < configStoreProcessing.restrictDeleteCharges)
        }())
        .onFocus({ tf in
            tf.select()
        })
        .placeholder("1")
        .class(.textFiledBlackDark)
    
    lazy var unitsFieldNoEdit: InputText = InputText(self.units)
        .disabled({
            (custCatchHerk < configStoreProcessing.restrictDeleteCharges)
        }())
        .onFocus({ tf in
            tf.select()
        })
        .placeholder("1")
        .class(.textFiledBlackDark)
    
    lazy var costField: InputText = InputText(self.$cost)
        .disabled({
            (custCatchHerk < configStoreProcessing.restrictDeleteCharges)
        }())
        .onFocus({ tf in
            tf.select()
        })
        .placeholder("0.00")
        .class(.textFiledBlackDark)
    
    lazy var priceField: InputText = InputText(self.$price)
        .disabled({
            (custCatchHerk < configStoreProcessing.restrictDeleteCharges)
        }())
        .onFocus({ tf in
            tf.select()
        })
        .placeholder("0.00")
        .class(.textFiledBlackDark)
    
    lazy var nameField: InputText = InputText(self.$name)
        .disabled({
            (custCatchHerk < configStoreProcessing.restrictDeleteCharges)
        }())
        .width(93.percent)
        .onFocus({ tf in
            tf.select()
        })
        .placeholder("Nombre del \(self.type.description)")
        .class(.textFiledBlackDark)
               
    lazy var fiscCodeField = FiscCodeField(style: .dark, type: self.type) { data in
        self.fiscCode = data.c
    }
    
    lazy var fiscUnitField = FiscUnitField(style: .dark, type: self.type) { data in
        self.fiscUnit = data.c
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.uiView3)
                .onClick{
                    self.remove()
                }
            
            if self.type == .product {
                Div("Ver Detalles")
                .marginRight(7.px)
                .class(.uibtn)
                .float(.right)
                .onClick {

                    guard let id = self.ids.first else {
                        showError(.unexpectedResult, "No se localizo id del cargo a editar")
                        self.remove()
                        return
                    }
        
                    let view = InventoryItemDetailView(
                        itemid: id
                    ){ updatedCost in

                    }
                    
                    addToDom(view)

                }
            }

            /// Editar Manual
            /// Editar Servicio
            /// Editar Producto
            H2("Editar \(self.type.description)")
                .color(.lightBlueText)
            
            Div().class(.clear).marginTop(3.px)
            
            /// price
            Div{
                Label("Precio de Veta").color(.lightGray)
                Div{
                    self.priceField
                }
            }.class(.section)
            Div().class(.clear).marginTop(3.px)
            /// name
            Div{
                Label("Nombre").color(.lightGray)
                Div{
                    self.nameField
                }
            }.class(.section)
            
            Div().class(.clear).marginTop(3.px)
            
            /// fiscCode
            Div{
                Label("Codigo Producto Fiscal").color(.lightGray)
                self.fiscCodeField
            }.class(.section)
                .hidden({ self.type == .rental }())
            Div().class(.clear).marginTop(3.px)
            
            /// fiscUnit
            Div{
                Label("Codigo Unidad Fiscal").color(.lightGray)
                self.fiscUnitField
            }.class(.section)
                .hidden({(self.type == .rental)}())
            Div().class(.clear).marginTop(3.px)
            
            Div().class(.clear).marginTop(12.px)
            
            Div {
                
                /// Save Data Button
                Div{
                    Img()
                        .src("/skyline/media/diskette.png")
                        .class(.iconWhite)
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Guardar")
                }
                .id("ok")
                .class(.uibtn)
                .float(.right)
                .onClick {
                    
                    self.saveData()
                    
                    self.remove()
                }
                
                /// Delete Button
                Div{
                    Img()
                        .src("/skyline/media/cross.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Eliminar")
                }
                .backgroundColor(.transparent)
                .boxShadow(h: 0.px, v: 0.px, blur: 0.px, color: .transparent)
                .class(.uibtn)
                .onClick {
                    self.delete(self.ids, self.__name, self.__priceInt)
                    self.remove()
                }
                
            }
        
            Div()
                .class(.clear)
                .marginTop(12.px)
            
        }
        .padding(all: 7.px)
        .width(40.percent)
        .position(.absolute)
        .left(30.percent)
        .top(30.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
    }
    
    override func buildUI() {
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.fixed)
        self.class(.transparantBlackBackGround)
        .zIndex(999999998)
        
        super.buildUI()
        
        guard let id = ids.first else {
            showError(.unexpectedResult, "No se localizo id del cargo a editar")
            self.remove()
            return
        }
        
        loadingView(show: true)
        
        API.custOrderV1.loadChargeData(
            type: type,
            id: id
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError( .generalError, .unexpenctedMissingPayload)
                return
            }
            
            self.__units = data.units.formatMoney
            self.__cost = data.cost.formatMoney
            self.__price = data.price.formatMoney
            self.__name = data.name
            
            self.units = data.units.formatMoney
            self.cost = data.cost.formatMoney
            self.price = data.price.formatMoney
            self.__priceInt = data.price
            self.name = data.name
            self.fiscCode = data.fiscCode
            self.fiscUnit = data.fiscUnit
            
            self.isLoaded = true
            
            ///Prepare and load fiscCode
            /*
            self.fiscCodeField.loadBasicData {
                self.fiscCodeField.loadFiscalCodeData(data.fiscCode)
            }
            */
            self.fiscCodeField.loadFiscalCodeData(data.fiscCode)
            
            ///Prepare and load fiscUnit
            /*
            self.fiscUnitField.loadBasicData {
                self.fiscUnitField.loadFiscalCodeData(data.fiscUnit)
            }
            */
            self.fiscUnitField.loadFiscalCodeData(data.fiscUnit)
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        switch self.type {
        case .product:
            break
        case .service, .manual:
            break
        case .rental:
            self.priceField.select()
        }
    }
    
    func saveData(){
        
        var units: Int64 = 0
        var cost: Int64 = 0
        var price: Int64 = 0
        var name: String = ""
        var fiscCode: String = ""
        var fiscUnit: String = ""
        
        switch self.type {
        case .service, .manual:
            
            /*
             ``SOC``
                ✅ units
                ✅ cost
                ✅ price
                ✅ name
                ✅ fiscCode
                ✅ fiscUnit
             */
            
            guard let unitFloat = Float(self.units) else {
                showError(.invalidField, "Ingrese una unidad valida")
                self.unitsField.select()
                return
            }
            
            let _cost = self.cost
                .replace(from: ",", to: "")
                .replace(from: "$", to: "")
                .purgeHtml
            
            guard let costFloat = Float(_cost) else {
                showError(.invalidField, "Ingrese un costo valida")
                self.costField.select()
                return
            }
            
            let _price = self.price
                .replace(from: ",", to: "")
                .replace(from: "$", to: "")
                .purgeHtml
            
            guard let priceFloat = Float(_price) else {
                showError(.invalidField, "Ingrese un precio valida")
                self.priceField.select()
                return
            }
            
            guard !self.name.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.nameField.select()
                return
            }
            
            guard !self.fiscCode.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.fiscCodeField.fiscCodeField.select()
                return
            }
            
            guard !self.fiscUnit.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.fiscUnitField.fiscUnitField.select()
                return
            }
            
            units = unitFloat.toCents
            cost = costFloat.toCents
            price = priceFloat.toCents
            name = self.name.purgeSpaces
            fiscCode = self.fiscCode
            fiscUnit = self.fiscUnit
            
        case .product:
            
            /*
             ``POC``
                ❌ units (always 1)
                ✅ cost
                ✅ price
                ✅ name
                ✅ fiscCode
                ✅ fiscUnit
             */
            
            
            
            let _cost = self.cost
                .replace(from: ",", to: "")
                .replace(from: "$", to: "")
                .purgeHtml
            
            guard let costFloat = Float(_cost) else {
                showError(.invalidField, "Ingrese un costo valida")
                self.costField.select()
                return
            }
            
            let _price = self.price
                .replace(from: ",", to: "")
                .replace(from: "$", to: "")
                .purgeHtml
            
            guard let priceFloat = Float(_price) else {
                showError(.invalidField, "Ingrese un precio valida")
                self.priceField.select()
                return
            }
            
            guard !self.name.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.nameField.select()
                return
            }
            
            guard !self.fiscCode.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.fiscCodeField.fiscCodeField.select()
                return
            }
            
            guard !self.fiscUnit.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.fiscUnitField.fiscUnitField.select()
                return
            }
            
            units = 100
            cost = costFloat.toCents
            price = priceFloat.toCents
            name = self.name.purgeSpaces
            fiscCode = self.fiscCode
            fiscUnit = self.fiscUnit
            
        case .rental:
            /*
            ``Rent``
                ❌ units (always 1)
                ❌ cost
                ✅ price
                ✅ name
                ❌ fiscCode
                ❌ fiscUnit
             */
            
            
            let _cost = self.cost
                .replace(from: ",", to: "")
                .replace(from: "$", to: "")
                .purgeHtml
            
            guard let costFloat = Float(_cost) else {
                showError(.invalidField, "Ingrese un costo valida")
                self.costField.select()
                return
            }
            
            let _price = self.price
                .replace(from: ",", to: "")
                .replace(from: "$", to: "")
                .purgeHtml
            
            guard let priceFloat = Float(_price) else {
                showError(.invalidField, "Ingrese un precio valida")
                self.priceField.select()
                return
            }
            
            
            guard !self.name.isEmpty else {
                showError(.invalidField, "Ingrese un nombre valido")
                self.nameField.select()
                return
            }
            
            units = 100
            cost = costFloat.toCents
            price = priceFloat.toCents
            name = self.name.purgeSpaces
            fiscCode = self.fiscCode
            fiscUnit = self.fiscUnit
            
        }
        
        loadingView(show: true)
        
        API.custOrderV1.saveChargeData(
            type: self.type,
            orderId: self.orderId,
            ids: self.ids,
            units: units,
            cost: cost,
            price: price,
            name: name,
            fiscCode: fiscCode,
            fiscUnit: fiscUnit
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
                        
            self.callback(
                self.ids,
                units,
                cost,
                price,
                name,
                fiscCode,
                fiscUnit
            )
            
            self.remove()

        }
    }
    
}
