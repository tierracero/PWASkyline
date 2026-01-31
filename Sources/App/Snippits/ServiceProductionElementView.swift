//
//  ServiceProductionElementView.swift
//
//
//  Created by Victor Cantu on 11/13/23.
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceProductionElementView: Div {
    
    override class var name: String { "div" }
    
    @State var id: UUID?
    
    private var callback: ((
        _ element: CustProductionElement
    ) -> ())
    
    init(
        id: UUID?,
        callback: @escaping ((
            _ element: CustProductionElement
        ) -> ())
    ) {
        self.id = id
        
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var code = ""
    
    @State var name = ""
    
    @State var descr = ""
    
    @State var cost = "0"
    
    @State var isFavorite = false
    
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
    
    lazy var descrField = InputText(self.$descr)
        .class(.textFiledBlackDark)
        .placeholder("Descriptión")
        .marginRight(12.px)
        .textAlign(.right)
        .width(95.percent)
        .height(28.px)
        .float(.left)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var costField = InputText(self.$cost)
        .class(.textFiledBlackDark)
        .placeholder("0")
        .marginRight(12.px)
        .textAlign(.right)
        .width(95.percent)
        .height(28.px)
        .float(.left)
        .onFocus { tf in
            tf.select()
        }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2("Crear Elemento")
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
                            
                            Label("Descripcion")
                                .color(.white)
                            
                            Div{
                                self.descrField
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
                            Span("Costo")
                                .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.costField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).marginBottom(12.px)
                        
                        
                    }
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .fontSize(18.px)
                }
                .height(100.percent)
                .overflow(.auto)
                
            }
            
            Div{
                Div(self.$id.map{ ($0 == nil) ? "Crear Elemento" : "Guardar Cambios" })
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
        .custom("top", "calc(50% - 179px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(350.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if let id {
            
            loadingView(show: true)
            
            API.custAPIV1.getProductionElement(id: .id(id)) { resp in
            
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, "Error al obtener payload de data.")
                    return
                }
                
                /*
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
                */
            }
            
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
     
        nameField.select()
        
    }
    
    func saveAction(_ force: Bool){
        
        name = name.purgeSpaces
        
        if name.isEmpty {
            showError(.invalidField, "Inlcuya nombre")
            nameField.select()
            return
        }
        
        guard let cost = Double(cost)?.toCents else {
            showError(.invalidField, "Ingrese  costo valido")
            costField.select()
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.saveProductionElement(
            id: id,
            code: code,
            name: name,
            description: descr,
            cost: cost,
            isFavorite: isFavorite
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
