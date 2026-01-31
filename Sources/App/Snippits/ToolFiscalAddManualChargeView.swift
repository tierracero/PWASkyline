//
//  ToolFiscalAddManualChargeView.swift
//  
//
//  Created by Victor Cantu on 10/27/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscalAddManualChargeView: Div {
    override class var name: String { "div" }
    
    @State var item: FiscalItem?
    
    let substractedTaxCalculation: Bool
    
    /// When it comes from ODS, ODV or PDV
    let lockPrices: Bool
    
    private var add: ((
        _ item: FiscalItem
    ) -> ())
    
    private var update: ((
        _ item: FiscalItem
    ) -> ())
    
    private var remove: ((
        _ id: UUID
    ) -> ())
    
    init(
        item: FiscalItem?,
        substractedTaxCalculation: Bool,
        lockPrices: Bool,
        add: @escaping ((
            _ item: FiscalItem
        ) -> ()),
        update: @escaping ((
            _ item: FiscalItem
        ) -> ()),
        remove: @escaping ((
            _ id: UUID
        ) -> ())
    ) {
        
        self.item = item
        self.substractedTaxCalculation = substractedTaxCalculation
        self.lockPrices = lockPrices
        self.add = add
        self.update = update
        self.remove = remove
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var fiscCode: String = ""
    var fiscCodeDescription: String = ""
    @State var fiscUnit: String = ""
    var fiscUnitDescription: String = ""
    @State var code: String = ""
    @State var name: String = ""
    
    /// Float * 1000000
    @State var unitsListener: String = "0"
    @State var units: Int64 = 0
    
    /// This  is used for locked price in ui
    @State var unitsTextListener = ""
    /// This  is used for locked price in ui
    @State var costTextListener = ""
    
    /// Float * 1000000
    @State var costListener: String = "0"
    @State var cost: Int64 = 0
    
    /// Float * 1000000
    @State var discountListener: String = "0"
    @State var discount: Int64 = 0
    
    @State var subTotal: String = "0"
    
    @State var taxTrasladados: String = "0"
    
    @State var taxRetenidos: String = "0"
    
    /// Float * 1000000
    @State var total: String = "0"
    
    @State var retenidos: [FiscalItemTaxItem] = []
    
    @State var trasladados: [FiscalItemTaxItem] = []
    
    lazy var fiscCodeField = FiscCodeField(style: .dark, type: .manual) { data in
        
        self.fiscCode = data.c
        self.fiscCodeDescription = data.v
        self.fiscUnitField.fiscUnitField.select()
        
        if let item = self.item {
            
            guard let id = item.id else {
                return
            }
            
            switch item.type {
            case .service:
                
                API.custSOCV1.updateFiscalCodes(
                    id: id,
                    type: .code,
                    code: data.c
                ) { _ in
                    
                }
                
            case .product:
                
                API.custPOCV1.updateFiscalCodes(
                    id: id,
                    type: .code,
                    code: data.c
                ) { _ in
                    
                }
                
            case .manual:
                API.custOrderV1.saveChargeFiscalData(
                    type: .code,
                    id: id,
                    code: data.c
                ) { _ in
                    
                }
            case .rental:
                break
            }
        }
        
    }
    
    lazy var fiscUnitField = FiscUnitField(style: .dark, type: .manual) { data in
        
        self.fiscUnit = data.c
        self.fiscUnitDescription = data.v
        self.codeField.select()
        
        if let item = self.item {
            
            guard let id = item.id else {
                return
            }
            
            switch item.type {
            case .service:
                
                API.custSOCV1.updateFiscalCodes(
                    id: id,
                    type: .unit,
                    code: data.c
                ) { _ in
                    
                }
                
            case .product:
                
                API.custPOCV1.updateFiscalCodes(
                    id: id,
                    type: .unit,
                    code: data.c
                ) { _ in
                    
                }
                
            case .manual:
                API.custOrderV1.saveChargeFiscalData(
                    type: .unit,
                    id: id,
                    code: data.c
                ) { _ in
                    
                }
            case .rental:
                break
            }
        }
        
    }
    
    lazy var taxGridRetenidos = Div()
    
    lazy var taxGridTrasladados = Div()
    
    lazy var codeField = InputText(self.$code)
        .custom("width","calc(100% - 30px)")
        .class(.textFiledBlackDark)
        .placeholder("SKU / UPC / Modelo")
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
        .onEnter {
            self.nameField.select()
        }
    
    lazy var nameField = InputText(self.$name)
        .custom("width","calc(100% - 30px)")
        .class(.textFiledBlackDark)
        .placeholder("Nombre o descripción")
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
        .onEnter {
            self.unitsField.select()
        }
    
    @State var nameTextListener = ""
    lazy var nameText = InputText(self.$nameTextListener)
        .custom("width","calc(100% - 30px)")
        .class(.textFiledBlackDark)
        .placeholder("Nombre o descripción")
        .height(31.px)
        .disabled(true)
    
    lazy var unitsField = InputText(self.$unitsListener)
        .custom("width","calc(100% - 40px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .placeholder("1")
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
        .onEnter {
            self.costField.select()
        }
    
    /// This  is used for locked price in ui
    lazy var unitsText = InputText(self.$unitsTextListener)
        .custom("width","calc(100% - 40px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .placeholder("1")
        .disabled(true)
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
    
    
    lazy var costField = InputText(self.$costListener)
        .custom("width","calc(100% - 40px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
    
    /// This  is used for locked price in ui
    lazy var costText = InputText(self.$costTextListener)
        .custom("width","calc(100% - 40px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .disabled(true)
        .height(31.px)
        
    
    lazy var discountField = InputText(self.$discountListener)
        .custom("width","calc(100% - 40px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
    
    @State var addNewTaxViewIsHidden: Bool = true
    
    @State var newRetentionTypeLister: String = TaxRetentionType.trasladado.rawValue
    
    @State var newTaxTypeListener: String = TaxType.iva.rawValue
    
    @State var newTaxFactorListener: String = TaxFactor.tasa.rawValue
    
    @State var newTaxTaza: String = ""
    
    lazy var newRetentionTypeSelect = Select(self.$newRetentionTypeLister)
        .custom("width","calc(100% - 10px)")
        .class(.textFiledBlackDark)
    
    lazy var newTaxTypeSelect = Select(self.$newTaxTypeListener)
        .custom("width","calc(100% - 10px)")
        .class(.textFiledBlackDark)
    
    lazy var newTaxFactorSelect = Select(self.$newTaxFactorListener)
        .custom("width","calc(100% - 10px)")
        .class(.textFiledBlackDark)
    
    lazy var newTaxTazaField = InputText(self.$newTaxTaza)
        .custom("width","calc(100% - 10px)")
        .class(.textFiledBlackDark)
        .placeholder("0.160000")
        .textAlign(.right)
        .height(31.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var addNewTaxView = Div {
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.addNewTaxViewIsHidden = true
                    }
                
                H2("Agregar Impuesto")
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            Div("Trasladado / Retenido")
                .marginBottom(3.px)
                .color(.white)
            
            self.newRetentionTypeSelect
                .marginBottom(7.px)
            
            Div("Tipo de Impuesto")
                .marginBottom(3.px)
                .color(.white)
            self.newTaxTypeSelect
                .marginBottom(7.px)
            
            Div("Factor")
                .marginBottom(3.px)
                .color(.white)
            self.newTaxFactorSelect
                .marginBottom(7.px)
            
            Div("Tasa de Impuesto")
                .marginBottom(3.px)
                .color(.white)
            self.newTaxTazaField
                .marginBottom(7.px)
                .onEnter {
                    self.addNewTax()
                }
            
            Div{
                Div("Agregar Impuesto")
                    .class(.uibtnLargeOrange)
                    .onClick({
                        self.addNewTax()
                    })
            }
            .align(.center)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 150px)")
        .custom("top", "calc(50% - 150px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)

        .width(300.px)
    }
    .hidden(self.$addNewTaxViewIsHidden)
    .class(.transparantBlackBackGround)
    .position(.absolute)
    .height(100.percent)
    .width(100.percent)
    .left(0.px)
    .top(0.px)
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.$item.map{ ($0 == nil) ? "Agregar Cargo" : "Editar Cargo" })
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            Div("Codigo Producto Fiscal")
                .marginBottom(3.px)
                .color(.white)
            self.fiscCodeField
                .marginBottom(7.px)
            
            Div("Codigo De Unidad Fiscal")
                .marginBottom(3.px)
                .color(.white)
            self.fiscUnitField
                .marginBottom(3.px)
            
            Div{
                
                Img()
                    .float(.right)
                    .cursor(.pointer)
                    .src("/skyline/media/add.png")
                    .height(18.px)
                    .paddingRight(0.px)
                    .onClick { img, event in
                        self.newRetentionTypeLister = TaxRetentionType.trasladado.rawValue
                        self.newTaxTypeListener = TaxType.iva.rawValue
                        self.newTaxFactorListener = TaxFactor.tasa.rawValue
                        self.newTaxTaza = ""
                        self.addNewTaxViewIsHidden = false
                    }
                
                Div("Impuestos")
                    .color(.white)
            }
            .marginBottom(3.px)
            
            Div{
                self.taxGridRetenidos
                self.taxGridTrasladados
            }
            .class(.roundDarkBlue)
            .marginBottom(3.px)
            .padding(all:3.px)
            .overflow(.auto)
            .height(70.px)
            
            Div("Codigo de Producto")
                .marginBottom(3.px)
                .color(.white)
            self.codeField
                .marginBottom(7.px)
            
            Div("Nombre o descripción del cargo")
                .marginBottom(3.px)
                .color(.white)
            
            if self.lockPrices {
                self.nameText
                    .marginBottom(7.px)
            }
            else{
                self.nameField
                    .marginBottom(7.px)
            }
            
            Div{
                Div("Unidades")
                    .marginBottom(3.px)
                    .color(.white)
                
                if self.lockPrices {
                    self.unitsText
                        .marginBottom(7.px)
                }
                else {
                    self.unitsField
                        .marginBottom(7.px)
                }
            }
            .width(33.percent)
            .float(.left)
            
            Div{
                
                Div("Costo")
                    .marginBottom(3.px)
                    .float(.left)
                    .color(.white)
                
                if self.lockPrices {
                    self.costText
                        .marginBottom(7.px)
                }
                else{
                    self.costField
                        .marginBottom(7.px)
                }
                
            }
            .width(33.percent)
            .float(.left)
            
            
            Div{
                
                Div("Descuento")
                    .marginBottom(3.px)
                    .float(.left)
                    .color(.white)
                
                if !self.lockPrices {
                    self.discountField
                        .marginBottom(7.px)
                }
                
            }
            .width(33.percent)
            .float(.left)
            
            Div().class(.clear)
            
            /// Sub Total
            Div{
                Div("Sub Total")
                .width(40.percent)
                .align(.right)
                .float(.left)
                
                Div{
                    Div(self.$subTotal)
                        .marginRight(24.px)
                        .textAlign(.right)
                }
                .width(60.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .marginTop(3.px)
            .color(.gray)
            
            /// Trasladados
            Div{
                Div("Trasladados")
                .width(40.percent)
                .align(.right)
                .float(.left)
                
                Div{
                    Div(self.$taxTrasladados)
                        .marginRight(24.px)
                        .textAlign(.right)
                }
                .width(60.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .marginTop(3.px)
            .color(.gray)
            
            /// Retenidos
            Div{
                Div("Retenidos")
                .width(40.percent)
                .align(.right)
                .float(.left)
                
                Div{
                    Div(self.$taxRetenidos)
                        .textAlign(.right)
                        .marginRight(24.px)
                }
                .width(60.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .marginTop(3.px)
            .color(.gray)
            
            Div().class(.clear)
            
            /// Total
            Div{
                Div("Total")
                .width(40.percent)
                .align(.right)
                .float(.left)
                
                Div{
                    Div(self.$total)
                        .marginRight(22.px)
                        .textAlign(.right)
                }
                .width(60.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .color(.white)
            .marginTop(7.px)
            .fontSize(24.px)
            
            Div().class(.clear).marginBottom(3.px)
            
            Div{
                Div("Remover")
                .class(.uibtnLargeOrange)
                .width(90.percent)
                .color(.fireBrick)
                .hidden(self.lockPrices)
                .onClick {
                    if let tid = self.item?.tid {
                        self.remove(tid)
                        self.remove()
                    }
                }
            }
            .hidden(self.$item.map{ ($0 == nil) })
            .width(50.percent)
            .align(.center)
            .float(.left)
            
            Div {
                Div(self.$item.map{ ($0 == nil) ? "Agregar Cargo" : "Guardar" })
                .class(.uibtnLargeOrange)
                .width(90.percent)
                .onClick{
                    
                    guard !self.fiscCode.isEmpty else {
                        showError(.requiredField, .requierdValid("Codigo Fiscal"))
                        return
                    }
                    
                    guard !self.fiscUnit.isEmpty else {
                        showError(.requiredField, .requierdValid("Unidad Fiscal"))
                        return
                    }
                    
                    guard !self.name.isEmpty else {
                        showError(.requiredField, .requierdValid("Nombre"))
                        return
                    }
                    
                    guard self.units > 0 else {
                        showError(.requiredField, .requierdValid("Unidades"))
                        return
                    }
                    
                    guard self.cost > 0 else {
                        showError(.requiredField, .requierdValid("Unidades"))
                        return
                    }
                    
                    
                    
                    let price = Double((self.units * self.cost) - self.discount) / 1000000.0
                    
                    print("⭐️  self.units  ⭐️  ")
                    print(self.units)
                    
                    print("⭐️  self.cost  ⭐️  ")
                    print(self.cost)
                    
                    print("⭐️  price  ⭐️  ")
                    print(price)
                    
                    
                    
                    
                    let newItem: FiscalItem = .init(
                        tid: self.item?.tid ?? .init(),
                        type: .manual,
                        id: nil,
                        fiscCode: self.fiscCode,
                        fiscCodeDescription: self.fiscCodeDescription,
                        fiscUnit: self.fiscUnit,
                        fiscUnitDescription: self.fiscUnitDescription,
                        series: "",
                        code: self.code,
                        name: self.name.capitalizingFirstLetters(true),
                        discount: self.discount,
                        units: self.units,
                        unitCost: self.cost,
                        total: price.toInt64,
                        taxes: .init(
                            retenidos: self.retenidos,
                            trasladados: self.trasladados
                        )
                    )
                    
                    if let _ = self.item {
                        self.update(newItem)
                    }
                    else{
                        self.add(newItem)
                    }
                    
                    self.remove()
                }
            }
            .width(self.$item.map{ ($0 == nil) ? 100.percent : 50.percent })
            .align(.center)
            .float(.right)
            
            Div().class(.clear).marginBottom(3.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 200px)")
        .custom("top", "calc(50% - 300px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(600.px)
        .width(400.px)
        
        self.addNewTaxView
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        fiscCodeField.fiscCodeField.height(31.px)
        
        fiscUnitField.fiscUnitField.height(31.px)
        
        $unitsListener.listen {
            guard let unitsDouble = Double($0.replace(from: ",", to: "")) else {
                return
            }
            self.units = Int64((unitsDouble *  10000).rounded()) * 100
        }
        
        $costListener.listen {
            guard let costDouble = Double($0.replace(from: ",", to: "")) else {
                return
            }
            self.cost = Int64((costDouble *  10000).rounded()) * 100
        }
        
        $discountListener.listen {
            print("dsl 001")
            guard let double = Double($0.replace(from: ",", to: "")) else {
                return
            }
            self.discount = Int64((double *  10000).rounded()) * 100
        }
        
        $retenidos.listen {
            self.taxGridRetenidos.innerHTML = ""
            
            $0.forEach { item in
                self.taxGridRetenidos.appendChild(
                    Div {
                        Div("RET: \(item.type.rawValue) \(item.type.code) \(item.taza)")
                            .class(.oneLineText)
                            .width(90.percent)
                            .float(.left)
                        Div().class(.clear)
                    }
                        .marginBottom(3.px)
                        .width(95.percent)
                        .class(.uibtn)
                )
            }
        }
        
        $trasladados.listen {
            self.taxGridTrasladados.innerHTML = ""
            
            $0.forEach { item in
                self.taxGridTrasladados.appendChild(
                    Div {
                        Div("TRAS: \(item.type.rawValue) \(item.type.code) \(item.taza)")
                            .class(.oneLineText)
                            .width(90.percent)
                            .float(.left)
                        Div().class(.clear)
                    }
                        .marginBottom(3.px)
                        .width(95.percent)
                        .class(.uibtn)
                )
            }
        }
        
        $units.listen {
            self._calcSubTotal()
        }
        
        $cost.listen {
            self._calcSubTotal()
        }
        
        $discount.listen {
            
            print($0)
            
            self._calcSubTotal()
        }
        
        TaxRetentionType.allCases.forEach { item in
            self.newRetentionTypeSelect.appendChild(Option(item.description).value(item.rawValue))
        }
        
        TaxType.allCases.forEach { item in
            self.newTaxTypeSelect.appendChild(Option("\(item.rawValue) \(item.code)").value(item.rawValue))
        }
        
        TaxFactor.allCases.forEach { item in
            self.newTaxFactorSelect.appendChild(Option(item.rawValue).value(item.rawValue))
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        if let item = item {
            
            if !item.fiscCode.isEmpty {
                self.fiscCodeField.fiscCodeField.text = "\(item.fiscCode) \(item.fiscCodeDescription)"
                self.fiscCodeField.fiscCodeField.class(.isOk)
                self.fiscCode = item.fiscCode
                self.fiscCodeDescription = item.fiscCodeDescription
            }
            
            if !item.fiscUnit.isEmpty {
                self.fiscUnitField.fiscUnitField.text = "\(item.fiscUnit) \(item.fiscUnitDescription)"
                self.fiscUnitField.fiscUnitField.class(.isOk)
                self.fiscUnit = item.fiscUnit
                self.fiscUnitDescription = item.fiscUnitDescription
            }
            
            self.code = item.code
            
            self.name = item.name
            self.nameTextListener = item.name
            
            self.unitsListener = item.units.fiscalFormatMoney
            self.unitsTextListener = item.units.fiscalFormatMoney
            
            self.costListener = item.unitCost.fiscalFormatMoney
            self.costTextListener = item.unitCost.fiscalFormatMoney
            
            self.discountListener = item.discount.fiscalFormatMoney
            
            self.retenidos = item.taxes.retenidos
            
            self.trasladados = item.taxes.trasladados
            
            units = item.units
            cost = item.unitCost
            
            //self.fiscCodeField.fiscCodeField.select()
            
            if !item.fiscCode.isEmpty {
                nameField.select()
            }
            
        }
        else{
            
            trasladados.append(.init(
                type: .iva,
                factor: .tasa,
                taza: "0.160000"
            ))
        }
        
        self._calcSubTotal()
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
    func addNewTax() {
        
        guard let _retentionType = TaxRetentionType(rawValue: self.newRetentionTypeLister) else {
            return
        }
        
        guard let _taxType = TaxType(rawValue: self.newTaxTypeListener) else {
            return
        }
        
        guard let _taxFactor = TaxFactor(rawValue: self.newTaxFactorListener) else {
            return
        }
        
        guard let _ = Double(self.newTaxTaza) else {
            return
        }
        
        switch _retentionType {
        case .trasladado:
            self.trasladados.append(.init(
                type: _taxType,
                factor: _taxFactor,
                taza: self.newTaxTaza
            ))
        case .retenido:
            self.retenidos.append(.init(
                type: _taxType,
                factor: _taxFactor,
                taza: self.newTaxTaza
            ))
        }
        
        self.addNewTaxViewIsHidden = true
        
        self._calcSubTotal()
        
    }
    
    func _calcSubTotal(){
        
        
        Console.clear()
        
        print(units)
        print(cost)
        print(discount)
        
        print("----------")
        
        let totals = calcSubTotal(
            substractedTaxCalculation: substractedTaxCalculation,
            units: units,
            cost: cost,
            discount: discount,
            retenidos: retenidos,
            trasladados: trasladados
        )
        
        print(totals)
        
        subTotal = (totals.subTotal.doubleValue / 1000000).formatMoney
        
        taxTrasladados = (totals.trasladado.doubleValue / 1000000).formatMoney
        
        taxRetenidos = (totals.retenido.doubleValue / 1000000).formatMoney
        
        total = ((totals.total - totals.retenido).doubleValue / 1000000).formatMoney
        
    }
    
}
