//
//  POCStorageControlAddInventorySeriesView.swift.swift
//  
//
//  Created by Victor Cantu on 2/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class POCStorageControlAddInventorySeriesView: Div {
    
    override class var name: String { "div" }

    let pocName: String

    let units: Int

    let seriesRequiermentType: SeriesRequiermentType

    private var callback: ((
        _ series: [String]
    ) -> ())
    
    init(
        pocName: String,
        units: Int,
        requier: SeriesRequiermentType,
        callback: @escaping ((
            _ series: [String]
        ) -> ())
    ) {
        self.pocName = pocName
        self.units = units
        self.seriesRequiermentType = requier
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    var inputRefrence: [ UUID : InventorySeriesItem ] = [:]
    
    lazy var seriesView = Div()
    .height(500.px)
    .overflow(.auto)

    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        Dispatch.asyncAfter(0.5) {
                            self.remove()
                        }
                    }
                
                H2("Agregar series al inventario")
                    .color(.lightBlueText)
                    .marginRight(7.px)
                    .height(35.px)
                    .float(.left)
                
            }
            
            Div().class(.clear).height(7.px)

            self.seriesView

            Div{
                Div("+ Agregar")
                    .class(.uibtnLargeOrange)
                    .onClick{
                        self.addInventory()
                    }
            }
            .align(.right)
            
            Div().class(.clear).height(7.px)
            
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 274px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(500.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        var curentNextViewId: UUID? = nil
        
        var firstInput: InventorySeriesItem? = nil


        for i in 1...units {
            
            let thisViewId: UUID = curentNextViewId ?? .init()

            let nextViewId: UUID  = .init()

            curentNextViewId =  nextViewId

            let view = InventorySeriesItem(
                cc: i,
                thisViewId: thisViewId,
                nextViewId: nextViewId
            ) { nextViewId in
                if let view = self.inputRefrence[nextViewId] {
                    view.input.select()
                }
                else {
                    self.addInventory()
                }
            }

            inputRefrence[view.thisViewId] = view

            seriesView.appendChild(view)

            if firstInput == nil {
                firstInput = view
            }

        }

        firstInput?.input.select()
        
    }

    
    func addInventory(){

        var series: [String] = []

        var cc = 1

        var invalidField: InputText? = nil

        for refrence in  inputRefrence { 

            let view = refrence.value

            let serie = view.input.text.purgeSpaces.uppercased()

            if serie.isEmpty && seriesRequiermentType == .required {
                invalidField = view.input
                break
            }

            series.append(serie)

            cc += 1

        }

        if let invalidField {
            invalidField.select()
            showError(.requiredField, "Incluya serie #\(cc.toString)")
            return 
        }

        self.callback(series)

        self.remove()

    }
    
}

extension POCStorageControlAddInventorySeriesView {

    class InventorySeriesItem: Div {
    
        override class var name: String { "div" }

        let cc: Int

        let thisViewId: UUID

        let nextViewId: UUID

        private var callback: ((
            _ nextViewId: UUID
        ) -> ())
        
        init(
            cc: Int,
            thisViewId: UUID,
            nextViewId: UUID,
            callback: @escaping ((
                _ nextViewId: UUID
            ) -> ())
        ) {
            self.cc = cc
            self.thisViewId = thisViewId
            self.nextViewId = nextViewId
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        lazy var input = InputText()
            .class(.textFiledBlackDark)
            .placeholder("Ingrese serie #\(self.cc.toString)")
            .custom("width", "calc(100% - 14px)")
            .textAlign(.right)
            .height(28.px)
            .onFocus { inputText in
                inputText.select()
            }
            .onEnter { inputField in

                if inputField.text.isEmpty {
                    return
                }

                self.callback(self.nextViewId)

            }

        @DOM override var body: DOM.Content {

            Label("Ingrese serie #\(cc.toString)")
                .color(.white)

            Div().class(.clear).height(3.px)

            input

            Div().class(.clear).height(7.px)
        }

        override func buildUI() {
            super.buildUI()
        }

    }
}
