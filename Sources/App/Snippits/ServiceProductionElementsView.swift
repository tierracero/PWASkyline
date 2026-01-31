//
//  ServiceProductionElementsView.swift
//
//
//  Created by Victor Cantu on 11/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceProductionElementsView: Div {
    
    override class var name: String { "div" }
    
    /// Current linked id's to SOC
    @State var currentItem: CustProductionElement?
    
    private var callback: ((
        _ item: CustProductionElement
    ) -> ())
    
    init(
        currentItem: CustProductionElement?,
        callback: @escaping ((
            _ item: CustProductionElement
        ) -> ())
    ) {
        self.currentItem = currentItem
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var favorits: [CustProductionElement] = []
    
    var general: [CustProductionElement] = []
    
    @State var actions: [CustProductionElement] = []
    
    @State var term = ""
    
    lazy var termField = InputText(self.$term)
        .placeholder("Buscar Accion")
        .class(.textFiledBlackDark)
        .marginRight(12.px)
        .width(300.px)
        .height(28.px)
        .float(.left)
        .disabled(true)
        .onFocus { tf in
            tf.select()
        }
        .onKeyDown({ tf, event in
            if ignoredKeys.contains(event.key) {
               return
            }
            self.findAction()
        })
            
        .onEnter {
            self.findAction()
        }
        .onPaste {
            self.findAction()
        }
    
    @DOM override var body: DOM.Content {
        Div{
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Elementos Base")
                    .color(.lightBlueText)
                    .marginRight(12.px)
                    .float(.left)
                
                self.termField
                
                Div("+ Crear Base")
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        
                        addToDom(ServiceProductionElementView(id: nil, callback: { element in

                            self.callback(element)
                            
                            self.remove()
                            
                        }))
                        
                        /*
                         
                         ServiceOperationalObjectView
                         
                        addToDom((type: self.type, id: nil, callback: { action in
                            
                            self.actions.append(action)
                            
                            self.callback(action)
                            
                            showSuccess(.operacionExitosa, "Accion Agregada")
                        }))
                         */
                    }
                    
                Div().class(.clear)
                
            }
            
            Div{
                
                ForEach(self.$actions){ object in
                    
                     ServiceProductionElementsRow(object: object) {
                        
                        var _actions: [CustProductionElement] = []
                        
                        self.actions.forEach { action in
                            
                            if action.id == object.id {
                                _actions.append(object)
                            }
                            else{
                                _actions.append(action)
                            }
                            
                        }
                        
                        self.actions = _actions
                        
                    }
                    .onClick {
                        self.callback(object)
                        self.remove()
                    }
                    
                }
                .hidden(self.$actions.map{ $0.isEmpty })
                
                Table().noResult(label: "Sin resultados, haga clic en \"Crear Elemento\" 🐼")
                    .hidden(self.$actions.map{ !$0.isEmpty })
            }
            .custom("height", "calc(100% - 35px)")
            .class(.roundDarkBlue)
            .overflow(.auto)
            
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
        
        loadingView(show: true)
        
        API.custAPIV1.getProductionElements { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let productionElement = resp.data?.productionElements else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            productionElement.forEach { item in
                if item.isFavorite {
                    self.favorits.append(item)
                }
                else {
                    self.general.append(item)
                }
            }
            
            if !self.favorits.isEmpty {
                self.actions = self.favorits
            }
            else {
                self.actions = self.general
            }
            
            self.actions = productionElement
            
        }
    }
    
    func findAction(){
        
        let _term = term.purgeSpaces
        
        if _term.count < 3 {
            if actions.count == favorits.count {
                return
            }
            actions = favorits
            return
        }
        
    }
    
}
