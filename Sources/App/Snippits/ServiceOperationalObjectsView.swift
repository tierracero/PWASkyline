//
//  ServiceOperationalObjectsView.swift
//
//
//  Created by Victor Cantu on 11/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceOperationalObjectsView: Div {
    
    override class var name: String { "div" }
    
    /// Current linked id's to SOC
    @State var currentIds: [UUID]
    
    private var callback: ((
        _ item: CustSOCActionOperationalObjectQuick
    ) -> ())
    
    init(
        currentIds: [UUID],
        callback: @escaping ((
            _ item: CustSOCActionOperationalObjectQuick
        ) -> ())
    ) {
        self.currentIds = currentIds
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var favorits: [CustSOCActionOperationalObjectQuick] = []
    
    var general: [CustSOCActionOperationalObjectQuick] = []
    
    @State var actions: [CustSOCActionOperationalObjectQuick] = []
    
    @State var term = ""
    
    lazy var termField = InputText(self.$term)
        .class(.textFiledBlackDark)
        .placeholder("Buscar Accion")
        .marginRight(12.px)
        .width(300.px)
        .height(28.px)
        .float(.left)
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
                
                H2("Elementos Operacionales")
                    .color(.lightBlueText)
                    .marginRight(12.px)
                    .float(.left)
                
                self.termField
                
                Div("+ Crear Elemento")
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        
                        addToDom(ServiceOperationalObjectView(
                            id: nil
                        ) { element in
                            self.callback(element)
                            self.remove()
                        } removed: {
                            
                        })
                        
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
                    
                    ServiceActionOperationalRow(showEditControler: true, object: object) {
                        /// Removed
                        var _actions: [CustSOCActionOperationalObjectQuick] = []
                        
                        self.actions.forEach { action in
                            if action.id == object.id {
                                return
                            }
                            _actions.append(action)
                        }
                        self.actions = _actions
                        
                    } edited: { newobject in
                        /// Edited
                        var _actions: [CustSOCActionOperationalObjectQuick] = []
                        
                        self.actions.forEach { action in
                            if action.id == object.id {
                                _actions.append(newobject)
                            }
                            else{
                                _actions.append(action)
                            }
                        }
                        
                        self.actions = _actions
                    }
                    .onClick {
                        
                        self.actions.forEach { item in
                            if item.id == object.id {
                                self.callback(item)
                            }
                        }
                        
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
        
        API.custAPIV1.getOperationalObjects { resp in
            
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
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            data.forEach { item in
                
                if self.currentIds.contains(item.id) {
                    return
                }
                
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
            
            self.actions = data
            
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
        
        Dispatch.asyncAfter(0.37) {
            
            if self.term.purgeSpaces == _term {
                
                self.termField.class(.isLoading)
                
                API.custAPIV1.searchOperationalObject(
                    term: _term,
                    currentIDs: self.currentIds
                ) { term, resp in
                    
                    self.termField.removeClass(.isLoading)
                    
                    if self.term.purgeSpaces == _term {
                        self.actions = resp
                    }
                    
                }
            }
        }
    }
    
}
