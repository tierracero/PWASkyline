//
//  FiscalConceptDestinationManualItemsEditView.swift
//  
//
//  Created by Victor Cantu on 12/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptDestinationManualItemsEditView: Div {
    
    override class var name: String { "div" }
        
    let totalUnitCount: Int64

    @State var missingUnitsCount: String
    
    let missingUnitsReason: InventoryPlaceType?
    
    private var callback: ((
        _ missingUnitsCount: Int64,
        _ missingUnitsReason: InventoryPlaceType
    ) -> ())
    
    init(
        totalUnitCount: Int64,
        missingUnitsCount: Int64?,
        missingUnitsReason: InventoryPlaceType?,
        callback: @escaping (
            _ missingUnitsCount: Int64,
            _ missingUnitsReason: InventoryPlaceType
        ) -> Void
    ) {
        self.totalUnitCount = totalUnitCount
        self.missingUnitsCount = missingUnitsCount?.toString ?? "0"
        self.missingUnitsReason = missingUnitsReason
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// InventoryPlaceType
    /// store, order, sold, merm, returnToVendor, missingFromVendor
    @State var missingUnitsReasonListener = ""
    
    lazy var missingUnitsCountField = InputText(self.$missingUnitsCount)
        .placeholder("Unidades Faltantes")
        .custom("width","calc(100% - 12px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    
    lazy var typeSelect = Select(self.$missingUnitsReasonListener)
        .body{
            Option("Seleccione Razon")
                .value("")
        }
        .custom("width","calc(100% - 12px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Registrar Faltante")
                    .color(.lightBlueText)
                
            }
            
            Div().class(.clear).height(7.px)
            
            Label("Inidades Faltantes")
                .color(.white)
            
            Div().class(.clear).height(3.px)
            
            self.missingUnitsCountField
            
            Div().class(.clear).height(7.px)
            
            Label("Selecione Motivo")
                .color(.white)
            
            self.typeSelect
            
            Div().class(.clear).height(7.px)
            
            Div("Registrar")
                .custom("width","calc(100% - 12px)")
                .class(.uibtnLargeOrange)
                .textAlign(.center)
                .onClick {
                    self.addMissingInventory()
                }
        }
        .custom("left", "calc(50% - 224px)")
        .custom("top", "calc(50% - 224px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(400.px)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        InventoryPlaceType.allCases.forEach { type in
            if type.posPurchaseAvailability {
                typeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
        }
        
        if let missingUnitsReason {
            missingUnitsReasonListener = missingUnitsReason.rawValue
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        missingUnitsCountField.select()
    }
    
    
    func addMissingInventory(){
        
        guard let units = Int64(missingUnitsCount) else {
            showError(.errorGeneral, "Ingrese unidades validas")
            missingUnitsCountField.select()
            return
        }
        
        if units > totalUnitCount {
            showError(.errorGeneral, "No puede mermar mas de \(totalUnitCount.toString) unidades.")
            missingUnitsCountField.select()
            return
        }
        
        guard let type = InventoryPlaceType(rawValue: missingUnitsReasonListener) else {
            showError(.errorGeneral, "Seleccione una razon de la merma")
            return
        }
        
        callback(units, type)
        
        self.remove()
        
    }
}

