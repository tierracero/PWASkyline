//
//  ServiceAccionView.swift
//  
//
//  Created by Victor Cantu on 4/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionView: Div {
    
    override class var name: String { "div" }
    
    /// saleItem, actionItem
    var type: SaleActionType
    
    @State var id: UUID?
    
    private var callback: ((
        _ action: CustSaleActionQuick
    ) -> ())
    
    init(
        type: SaleActionType,
        id: UUID?,
        callback: @escaping ((
            _ action: CustSaleActionQuick
        ) -> ())
    ) {
        self.type = type
        self.id = id
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var objects: [CustSaleActionObjectDecoder] = []
    
    
    @State var operationalObject: [CustSOCActionOperationalObjectQuick] = []

    
    @State var custDocumentSupport: [UUID] = []
    /// in secconds
    @State var productionTime = "0"
    
    /// SaleActionDificultltyLevel
    /// easy, medium, hard, expertise
    @State var productionLevel = SaleActionDificultltyLevel.easy.rawValue
    @State var productionLevelCalculation = ""
    @State var productionLevelListener = ""
    
    /// SaleActionEmployeeLevel
    /// case worker, technician, graduate, engineerClassD, engineerClassC, engineerClassB, engineerClassA, engineerClassAA, engineerClassAAA
    @State var workforceLevel = SaleActionEmployeeLevel.worker.rawValue
    @State var workforceLevelCalculation = ""
    @State var workforceLevelListener = ""
    
    @State var requestCompletition = false
    
    @State var isFavorite = false
    
    @State var name = ""
    
    lazy var nameField = InputText(self.$name)
        .class(.textFiledBlackDark)
        .placeholder("Nombre de la acción")
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
        .float(.left)
        .onBlur { tf, event in
            
            tf.removeClass(.isOk)
            tf.removeClass(.isNok)
            tf.class(.isLoading)
            
            API.custAPIV1.actionItemAvalability(
                type: self.type,
                id: self.id,
                name: self.name
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    return
                }
                
                guard let data = resp.data else {
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
        }
    
    lazy var productionTimeField = InputText(self.$productionTime)
        .class(.textFiledBlackDark)
        .placeholder("0")
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
        .float(.left)
    
    lazy var workforceLevelSelect = Select(self.$workforceLevelListener)
        .custom("width", "calc(100% - 100px)")
        .class(.textFiledBlackDark)
        .height(28.px)
        .onChange { _, select in
            self.workforceLevel = select.value
        }
    
    lazy var productionLevelSelect = Select(self.$productionLevelListener)
        .custom("width", "calc(100% - 100px)")
        .class(.textFiledBlackDark)
        .height(28.px)
        .onChange { _, select in
            self.productionLevel = select.value
        }

    var itemRefrence: [ UUID : ServiceAccionItemElementRow ] = [:]

    lazy var itemContainer = Div()

    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2( self.$id.map{ ($0 == nil) ? "Crear \(self.type.description)" : "Editar \(self.type.description)" } )
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Div{
                
                /* MARK: GENRAL INFIORMATION */
                Div {
                    Div{
                        
                        H2("Datos Generales")
                            .marginBottom(7.px)
                            .color(.white)
                        Div{
                            
                            Label("Nombre de la accion")
                                .color(.white)

                            Div().class(.clear).height(3.px)
                            
                            Div{
                                self.nameField
                            }
                        }

                        
                        Div().class(.clear).height(12.px)
                        
                        Div{
                            InputCheckbox().toggle(self.$requestCompletition)
                                .marginRight(7.px)
                            
                            Span("Confiracion requerida")
                                .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            InputCheckbox().toggle(self.$isFavorite)
                                .marginRight(7.px)
                            
                            Span("Es favorito")
                                .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        /// Tiempo de producción
                        Div{
                            Div{
                                
                                Label("Minutos de producción")
                                    .fontSize(18.px)
                                    .color(.white)

                            }
                            .width(80.percent)
                            .float(.left)
                            
                            Div{
                                self.productionTimeField
                            }
                            .width(20.percent)
                            .float(.left)
                        }
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        Label("Tipo de mano de obra")
                            .marginBottom(7.px)
                            .color(.white)
                        
                        Div {
                            Span(self.$workforceLevelCalculation)
                                .float(.right)
                                .color(.white)
                            
                            self.workforceLevelSelect
                        }
                        .marginBottom(12.px)
                        
                        Div().class(.clear)
                        
                        Label("Grado de dificultad")
                            .marginBottom(7.px)
                            .color(.white)
                        
                        Div {
                            Span(self.$productionLevelCalculation)
                                .float(.right)
                                .color(.white)
                            
                            self.productionLevelSelect
                        }
                        .marginBottom(12.px)
                        
                        Div().class(.clear)
                        
                    }
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                }
                .height(100.percent)
                .width(50.percent)
                .overflow(.auto)
                .float(.left)
                
                /* MARK: ACTION ELEMENTS */
                Div {
                    Div{
                        
                        Div{
                            
                            Div(" + Agregar Elementos ")
                                .class(.uibtn)
                                .float(.right)
                                .onClick {
                                    addToDom(ServiceAccionItemElementView(
                                        element: nil,
                                        callback: { element in
                                            self.objects.append(element)
                                            self.renderElement(element)
                                        }
                                    ))
                                }
                            H2("Elementos")
                                .marginBottom(7.px)
                                .color(.white)
                        }
                        
                        Div{
                            
                            self.itemContainer
                            .hidden(self.$objects.map{ $0.isEmpty })
                            .id("sortableElements")
                            
                            Table().noResult(label: "Haga click en \"+ Agregar Elementos\" ⚽️")
                                .hidden(self.$objects.map{ !$0.isEmpty })
                            
                        }
                        .custom( "height", "calc(100% - 45px)")
                        .class(.roundDarkBlue)
                        .overflow(.auto)
                        
                    }
                    .custom("height", "calc(100% - 12px)")
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                }
                .height(100.percent)
                .width(50.percent)
                .overflow(.auto)
                .float(.left)
                
                Div().class(.clear)
            }
            .custom("height", "calc(100% - 65px)")
            
            Div{
                
                Div(self.$id.map{ ($0 == nil) ? "Crear Accion" : "Guardar Cambios" })
                    .class(.uibtnLargeOrange)
                    .marginTop(0.px)
                    .onClick {
                        self.saveAction(false)
                    }
                
            }
            .align(.right)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(20% - 12px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(60.percent)
        .width(60.percent)
        .top(20.percent)
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        self.appendChild(Script()
                .type("text/javascript")
                .src("https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js")
                .onLoad {
                    _ = JSObject.global.sortable!("sortableElements")
                })

        SaleActionDificultltyLevel.allCases.forEach { item in
            productionLevelSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        SaleActionEmployeeLevel.allCases.forEach { item in
            
            let perweek = item.value.fromCents * 2880.toFloat
            
            workforceLevelSelect.appendChild(
                Option("\(item.description) \(item.value.formatMoney)/min | \(perweek.formatMoney)/sem")
                    .value(item.rawValue)
            )
        }
        
        $productionTime.listen {
            self.calculateProductionTime()
            self.calculatWorforceCost()
        }
        
        $productionLevel.listen {
            self.calculateProductionTime()
        }
        
        $workforceLevel.listen {
            self.calculatWorforceCost()
        }
        
        if let id {
            
            loadingView(show: true)
            
            API.custAPIV1.loadServiceActionItem(id: id) { resp in
            
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
                    showError(.errorGeneral, "Error al obtener payload de data.")
                    return
                }
                
                self.objects = payload.objects
                self.custDocumentSupport = payload.custDocumentSupport
                self.productionTime = payload.productionTime.toString
                self.productionLevel = payload.productionLevel.rawValue
                self.workforceLevel = payload.workforceLevel.rawValue
                self.requestCompletition = payload.requestCompletition
                self.isFavorite = payload.isFavorite
                self.name = payload.name
                
                let perweek = (payload.workforceLevel.value.fromCents * 2880.toFloat)
                
                self.workforceLevelListener = payload.workforceLevel.rawValue
                
                self.productionLevelListener = self.productionLevel
                
                self.nameField.class(.isOk)

                payload.objects.forEach { obj in
                    self.renderElement(obj)
                }
            }
        }
    }
    
    func renderElement(_ obj: CustSaleActionObjectDecoder) {

        let view = ServiceAccionItemElementRow(
            element: obj
        ) { id in

            var objects: [CustSaleActionObjectDecoder] = []

            self.objects.forEach { element in
                if id == element.id {
                    return
                }
                objects.append(element)
            }

            self.objects = objects

            if var view = self.itemRefrence [id] {
                view.remove()
            }

            self.itemRefrence.removeValue(forKey: id)
            
        } callback: { editedeElement in

            var objects: [CustSaleActionObjectDecoder] = []

            self.objects.forEach { element in
                if editedeElement.id == element.id {
                    objects.append(editedeElement)
                }
                else {
                    objects.append(element)
                }
            }

            self.objects = objects

            if var view = self.itemRefrence [obj.id] {

                view.element = editedeElement

                view.type = editedeElement.type

                view.typeListener = editedeElement.type.rawValue

                view.title = editedeElement.title

                view.help = editedeElement.help

                view.placeholder = editedeElement.placeholder

                view.isRequired = editedeElement.isRequired

            }
            
        }
        .onDrop {
            self.arrageElements()
        }

        self.itemRefrence[obj.id] = view

        self.itemContainer.appendChild(view)
            
    }

    func calculateProductionTime(){
        
        guard let time = Double(productionTime) else {
            print("faild to establish time \(productionTime)")
            return
        }
        
        guard let level = SaleActionDificultltyLevel(rawValue: productionLevel) else {
            print("faild to establish level \(productionLevel)")
            return
        }
        
        productionLevelCalculation = (Double(level.value.fromCents) * time).formatMoney
    }
    
    func calculatWorforceCost(){
        
        guard let time = Double(productionTime) else {
            print("faild to establish time \(productionTime)")
            return
        }
        
        guard let level = SaleActionEmployeeLevel(rawValue: workforceLevel) else {
            print("faild to establish level \(productionLevel)")
            return
        }
        
        workforceLevelCalculation = (Double(level.value.fromCents) * time).formatMoney

    }
    
    func arrageElements() {
        
        if let string = JSObject.global.renderElements!("sortableElements").string {
            
            if string.isEmpty {
                return
            }
            
            let parts = string.explode(",")
            
            var ids: [UUID] = []
            
            parts.forEach { part in
                if let id = UUID(uuidString: part) {
                    ids.append(id)
                }
            }
            
            var new: [CustSaleActionObjectDecoder] = []
            
            var refrence: [UUID:CustSaleActionObjectDecoder] = [:]
            
            self.objects.forEach { object in
                refrence[object.id] = object
            }
            
            ids.forEach { id in
                
                if let element = refrence[id] {
                    new.append(element)
                }
                
            }
            
            self.objects = new
            
        }
    }
    
    func saveAction(_ forse: Bool){
        
        print("001")
        
        name = name.purgeSpaces.capitalizingFirstLetters()
        
        if name.isEmpty {
            showError(.campoRequerido, "Ingrese nombre de la accion")
            return
        }
        
        guard let _productionLevel = SaleActionDificultltyLevel(rawValue: productionLevel) else {
            showError(.campoRequerido, "Seccione grado de dificultad")
            return
        }
        
        guard let _workforceLevel = SaleActionEmployeeLevel(rawValue: workforceLevel) else {
            showError(.campoRequerido, "Seccione tipo de mano de obra")
            return
        }
        
        guard let _productionTime = Float(self.productionTime)?.toInt64 else {
            showError(.campoRequerido, "Ingrese tiempo de produccion")
            return
        }
        
        if objects.isEmpty && !forse {
            showError( .campoRequerido, "Incluya Elementos en la Accion")
            addToDom(ServiceAccionItemElementView(
                element: nil,
                callback: { element in
                    self.objects.append(element)
                    self.renderElement(element)
                }
            ))
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.createSaleActionItem(
            type: type,
            id: id,
            name: name,
            productionLevel: _productionLevel,
            workforceLevel: _workforceLevel,
            productionTime: _productionTime,
            requestCompletition: requestCompletition, 
            operationalObject: self.operationalObject.map { $0.id },
            isFavorite: isFavorite,
            objects: objects
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
            
            guard let id = resp.id else {
                showError( .unexpectedResult, "No se obtuvo payload de data")
                return
            }
            
            self.callback(.init(
                id: id,
                name: self.name,
                requestCompletition: self.requestCompletition,
                isFavorite: self.isFavorite,
                productionTime: _productionTime,
                productionLevel: _productionLevel,
                workforceLevel: _workforceLevel
            ))
            
            self.remove()
            
        }
        
    }

}
