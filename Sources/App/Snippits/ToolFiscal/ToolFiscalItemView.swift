//
//  ToolFiscalItemView.swift
//  
//
//  Created by Victor Cantu on 10/27/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscalItemView: Div {
    
    override class var name: String { "div" }
    
    var substractedTaxCalculation: State<Bool>
    
    var item: FiscalItem
    
    private var edit: ((
    ) -> ())
    
    init(
        substractedTaxCalculation: State<Bool>,
        item: FiscalItem,
        edit: @escaping ((
        ) -> ())
    ) {
        self.substractedTaxCalculation = substractedTaxCalculation
        self.item = item
        self.edit = edit
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    
    @State var base: String = "0"
    
    @State var discount: String = "0"
    
    /// Float * 1000000
    @State var subTotal: String = "0"
    
    @State var taxTrasladados: String = "0"
    
    @State var taxRetenidos: String = "0"
    
    @State var total: String = "0"
    
    var totals: CalcSubTotalResponse? = nil
    
    /// if the price is beaing loaded  from a ODS, ODV or PDV
    var costAreBlockedLoaded = false
    
    @State var fiscCodesAreMissing = false
    
    lazy var taxView = Div{
        
        Span("\(self.item.fiscCode) \(self.item.fiscCodeDescription.prefix(24)) \(self.item.fiscUnit) \(self.item.fiscUnitDescription.prefix(24)) ||")
            .marginRight(7.px)
        
        Span(self.$base.map{ "Base: \($0)"})
            .marginRight(7.px)
        
        
        Span(self.$discount.map{ "Descuento: \($0)"})
            .hidden(self.$discount.map{ $0 == "0" })
            .marginRight(7.px)
        
        
        Span(self.$subTotal.map{ "SubTotal: \($0)"})
            .marginRight(7.px)
        
        Span(self.$taxTrasladados.map{ $0.isEmpty ? "" : "Trasladados: \($0)" })
            .marginRight(7.px)
        
        Span(self.$taxRetenidos.map{ $0.isEmpty ? "" : "Retenidos: \($0)" })
            .marginRight(7.px)
        
    }
        .fontSize(12.px)
        .color(.gray)
    
    @DOM override var body: DOM.Content {
        Div{
            Img()
                .src("/skyline/media/pencil.png")
                .height(18.px)
                .cursor(.pointer)
                .onClick {
                    self.edit()
                }
        }
        .width(5.percent)
        .float(.left)
        
        Div(item.units.fiscalFormatMoney)
            .class(.oneLineText)
            .width(7.percent)
            .color(.white)
            .float(.left)
        
        Div{
            Img()
                .src("/skyline/media/alert.png")
                .marginRight(3.px)
                .height(18.px)
            Span("Codigos")
                .color(.orangeRed)
        }
        .class(.oneLineText)
        .width(13.percent)
        .float(.left)
        .hidden(self.$fiscCodesAreMissing.map{ !$0 })
        
        Div(item.name)
            .width(self.$fiscCodesAreMissing.map{ $0 ? 45.percent : 58.percent })
            .class(.oneLineText)
            .color(.white)
            .float(.left)
        
        Div($subTotal)
            .class(.oneLineText)
            .width(15.percent)
            .align(.right)
            .color(.white)
            .float(.left)
        
        Div($total)
            .class(.oneLineText)
            .width(15.percent)
            .align(.right)
            .color(.white)
            .float(.left)
        
        Div().class(.clear).marginBottom(3.px)
        
        self.taxView
        
        Div().class(.clear).marginBottom(3.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        marginBottom(3.px)
        
        substractedTaxCalculation.listen {
            self.calcTotals()
        }
        
        self.calcTotals()
        
        if item.fiscCode.isEmpty || item.fiscUnit.isEmpty {
            fiscCodesAreMissing = true
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
    func calcTotals(){
        
        let tax = calcSubTotal(
            substractedTaxCalculation: self.substractedTaxCalculation.wrappedValue,
            units: item.units,
            cost: item.unitCost,
            discount: item.discount,
            retenidos: item.taxes.retenidos,
            trasladados: item.taxes.trasladados
        )
        
        base = (tax.base.doubleValue / 1000000).formatMoney
        
        discount = (item.discount.doubleValue / 1000000).formatMoney
        
        totals = tax
        
        subTotal = (tax.subTotal.doubleValue / 1000000).formatMoney
        
        taxTrasladados = (tax.trasladado.doubleValue / 1000000).formatMoney
        
        taxRetenidos = (tax.retenido.doubleValue / 1000000).formatMoney
        
        //total = (tax.total.doubleValue / 1000000).formatMoney
        total = ((tax.total - tax.retenido).doubleValue / 1000000).formatMoney
        
    }
    
}


