//
//  ServiceOperationalObjectView.swift
//
//
//  Created by Victor Cantu on 11/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceOperationalObjectView: Div {
    
    override class var name: String { "div" }
    
    @State var id: UUID?
    
    private var callback: ((
        _ element: CustSOCActionOperationalObjectQuick
    ) -> ())
    
    private var removed: ((
    ) -> ())

    init(
        id: UUID?,
        callback: @escaping ((
            _ element: CustSOCActionOperationalObjectQuick
        ) -> ()),
        removed: @escaping ((
        ) -> ())
    ) {
        self.id = id
        self.callback = callback
        self.removed = removed
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var directCost = "0.00"
    
    @State var indirectCost = "0.00"

    @State var custProductionElement: CustProductionElement? = nil
    
    @State var productionUnits = "0"
    
    @State var productionCost = "0"
    
    /// in secconds
    @State var productionTime = "0"
    
    @State var workforceLevelListener: String = SaleActionEmployeeLevel.worker.rawValue
    
    @State var isFavorite = false
    
    @State var code = ""
    
    @State var name = ""
    
    @State var descr = ""
    
    lazy var nameField = InputText(self.$name)
        .class(.textFiledBlackDark)
        .placeholder("Nombre de la acción")
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
        .float(.left)
        .onBlur { tf, event in
            /*
            tf.removeClass(.isOk)
            tf.removeClass(.isNok)
            tf.class(.isLoading)
            
            API.custAPIV1.actionItemAvalability(
                type: self.type,
                id: self.id,
                name: self.name
            ) { resp in
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    return
                }
                
                tf.class(.isLoading)
                
                if tf.text == data.name {
                    
                    if data.isFree {
                        tf.removeClass(.isOk)
                    }
                    else {
                        tf.removeClass(.isNok)
                    }
                    
                }
                
            }
             */
        }
    
    lazy var productionUnitsField = InputText(self.$productionUnits)
        .class(.textFiledBlackDark)
        .placeholder("0")
        .marginRight(12.px)
        .textAlign(.right)
        .width(95.percent)
        .height(28.px)
        .float(.left)
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
    
    lazy var productionCostField = InputText(self.$productionCost)
        .disabled(self.$custProductionElement.map{ $0 != nil })
        .class(.textFiledBlackDark)
        .placeholder("0")
        .marginRight(12.px)
        .textAlign(.right)
        .width(95.percent)
        .height(28.px)
        .float(.left)
        .onKeyDown({ tf, event in
            if self.custProductionElement != nil {
                event.preventDefault()
            }
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
    
    lazy var productionTimeField = InputText(self.$productionTime)
        .class(.textFiledBlackDark)
        .placeholder("0")
        .marginRight(12.px)
        .textAlign(.right)
        .width(95.percent)
        .height(28.px)
        .float(.left)
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
    
    lazy var workforceLevelSelect = Select(self.$workforceLevelListener)
        .custom("width", "calc(100% - 12px)")
        .class(.textFiledBlackDark)
        .height(36.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2("Crear Operativo")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Div{
                
                Div {
                    Div{
                        
                        Div{
                            
                            Label("Nombre")
                                .color(.white)
                            
                            Div{
                                self.nameField
                            }
                        }
                        .class(.section)
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        
                        Div{
                            Span("Favorito")
                                .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            InputCheckbox().toggle(self.$isFavorite)
                                .marginRight(7.px)
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        Div{
                            Div{
                                
                                Span("Elemento Base")
                                    .color(.white)
                                
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                
                                Div(self.$custProductionElement.map{ $0?.name ?? "Seleccione" })
                                    .color( self.$custProductionElement.map{ ($0 == nil) ? .gray : .white } )
                                    .class(.textFiledBlackDark, .oneLineText)
                                    .marginRight(12.px)
                                    .width(95.percent)
                                    .cursor(.pointer)
                                    .paddingTop(3.px)
                                    .height(28.px)
                                    .onClick {
                                        addToDom(ServiceProductionElementsView(
                                            currentItem: self.custProductionElement,
                                            callback: { element in
                                                self.custProductionElement = element
                                            }
                                        ))
                                    }
                                
                            }
                            .width(50.percent)
                            .float(.left)
                            
                        }
                         
                        Div().class(.clear).marginBottom(12.px)
                        
                        /// Costo de produccion
                        Div{
                            Div{
                                Label("Costo de producción")
                                    .color(.white)
                            }
                            .width(70.percent)
                            .float(.left)
                            
                            Div{
                                self.productionCostField
                            }
                            .width(30.percent)
                            .float(.left)
                        }
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        /// Unidades
                        Div{
                            Div{
                                
                                Label("Unidades de producción")
                                    .color(.white)
                                
                            }
                            .width(70.percent)
                            .float(.left)
                            
                            Div{
                                self.productionUnitsField
                            }
                            .width(30.percent)
                            .align(.right)
                            .float(.left)
                        }
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        H2(self.$directCost)
                            .textAlign(.right)
                            .color(.gray)
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        /// Tiempo de producción
                        Div{
                            Div{
                                
                                Label("Minutos de producción")
                                    .color(.white)
                                
                            }
                            .width(70.percent)
                            .float(.left)
                            
                            Div{
                                self.productionTimeField
                            }
                            .width(30.percent)
                            .align(.right)
                            .float(.left)
                        }
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        /// Tipo de mano de obra
                        Div{
                            Label("Tipo de mano de obra")
                                .color(.white)
                        
                            Div().class(.clear).marginBottom(3.px)
                            
                            self.workforceLevelSelect
                        }
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        H2(self.$indirectCost)
                            .textAlign(.right)
                            .color(.gray)
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                    }
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .fontSize(18.px)
                }
                .height(100.percent)
                .overflow(.auto)
                
            }
            .custom("height", "calc(100% - 65px)")
            
            Div{
                Div(self.$id.map{ ($0 == nil) ? "Crear Operativo" : "Guardar Cambios" })
                    .class(.uibtnLargeOrange)
                    .marginTop(0.px)
                    .onClick {
                        self.saveAction(false)
                    }
            }
            .align(.right)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 174px)")
        .custom("top", "calc(50% - 279px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(510.px)
        .width(350.px)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        SaleActionEmployeeLevel.allCases.forEach { item in
            
            let perweek = item.value.fromCents * 2880.toFloat
            
            workforceLevelSelect.appendChild(
                Option("\(item.description) \(item.value.formatMoney)/min | \(perweek.formatMoney)/sem")
                    .value(item.rawValue)
            )
        }
        
        $custProductionElement.listen {
            if let element = $0 {
                self.productionCost = element.cost.formatMoney
                self.productionUnitsField.select()
            }
            
        }
        
        $productionUnits.listen {
            self.calculateDirectCost()
        }
        
        $productionCost.listen {
            self.calculateDirectCost()
        }
        
        $productionTime.listen {
            self.calculateIndirectCost()
        }
        
        $workforceLevelListener.listen {
            self.calculateIndirectCost()
        }
        
        if let id {
            
            loadingView(show: true)
            
            API.custAPIV1.getOperationalObject(id: .id(id)) { resp in
            
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    self.remove()
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    self.remove()
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, "Error al obtener payload de data.")
                    self.remove()
                    return
                }

                self.custProductionElement = payload.custProductionElement
                
                self.productionUnits = payload.productionUnits.formatMoney
                
                self.productionCost = payload.productionCost.formatMoney
                
                self.productionTime = payload.productionTime.formatMoney
                
                self.workforceLevelListener = payload.productionLevel.rawValue
                
                self.isFavorite = payload.isFavorite
                
                self.code = payload.code
                
                self.name = payload.name
                
                self.descr = payload.description
                
            }
            
        }
        
    }
    
    func calculateDirectCost(){
        
        let units = Double(self.productionUnits.purgeSpaces.replace(from: ",", to: ""))  ?? 0
        
        let cost = Double(self.productionCost.purgeSpaces.replace(from: ",", to: "")) ?? 0
        
        directCost = (units * cost).formatMoney
        
    }
    
    func calculateIndirectCost(){
        
        indirectCost = "0.00"
        
        let time = Double(self.productionTime.purgeSpaces.replace(from: ",", to: "")) ?? 0
        
        guard let level = SaleActionEmployeeLevel(rawValue: workforceLevelListener) else {
            return
        }
        
        indirectCost = (Double(level.value.fromCents) * time).formatMoney
    }
    
    func saveAction(_ force: Bool){
        
        name = name.purgeSpaces
        
        if name.isEmpty {
            showError(.invalidField, "Inlcuya nombre")
            nameField.select()
            return
        }
        
        guard let productionUnits = Double(productionUnits)?.toCents else {
            showError(.invalidField, "Ingrese unidades valido")
            productionUnitsField.select()
            return
        }
        
        guard let productionCost = Double(productionCost)?.toCents else {
            showError(.invalidField, "Ingrese costo valido")
            productionCostField.select()
            return
        }
        
        guard let productionTime = Double(productionTime)?.toCents else {
            showError(.invalidField, "Ingrese Tiempo de produccion")
            productionTimeField.select()
            return
        }
        
        guard let workforceLevel = SaleActionEmployeeLevel(rawValue: workforceLevelListener) else {
            showError(.invalidField, "Seleccione mano de obra")
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.saveOperationalObject(
            id: id,
            productionElement: custProductionElement?.id,
            productionUnits: productionUnits,
            productionCost: productionCost,
            productionTime: productionTime,
            productionLevel: workforceLevel,
            isFavorite: isFavorite,
            code: code,
            name: name,
            description: descr
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
            
            guard let element = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.callback(element)
            
            self.remove()
        }
        
    }
}
