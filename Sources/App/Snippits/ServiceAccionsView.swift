//
//  ServiceAccionsView.swift
//  
//
//  Created by Victor Cantu on 4/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionsView: Div {
    
    override class var name: String { "div" }
    
    /// saleItem, actionItem
    var type: SaleActionType
    
    /// Current linked id's to SOC
    @State var currentIds: [UUID]
    
    private var callback: ((
        _ item: CustSaleActionQuick
    ) -> ())
    
    init(
        type: SaleActionType,
        currentIds: [UUID],
        callback: @escaping ((
            _ item: CustSaleActionQuick
        ) -> ())
    ) {
        self.type = type
        self.currentIds = currentIds
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var favorits: [CustSaleActionQuick] = []
    
    @State var actions: [CustSaleActionQuick] = []
    
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
                
                H2(self.type.description)
                    .color(.lightBlueText)
                    .marginRight(12.px)
                    .float(.left)
                
                self.termField
                
                Div("+ Crear Accion")
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        addToDom(ServiceAccionView(type: self.type, id: nil, callback: { action in
                            
                            self.actions.append(action)
                            
                            showSuccess(.operacionExitosa, "Accion Agregada")
                        }))
                    }
                    
                Div().class(.clear)
                
            }
            
            Div{
                ForEach(self.$actions){ action in
                    
                    ServiceAccionItemRow(type: self.type, action: action) { newAction in
                        
                        var _actions: [CustSaleActionQuick] = []
                        
                        self.actions.forEach { action in
                            
                            if action.id == newAction.id {
                                _actions.append(newAction)
                            }
                            else{
                                _actions.append(action)
                            }
                            
                        }
                        
                        self.actions = _actions
                        
                    }
                    .onClick {
                        self.callback(action)
                        self.remove()
                    }
                    
                }
                .hidden(self.$actions.map{ $0.isEmpty })
                
                Table().noResult(label: "Sin resultados, haga clic en \"Crear Accion\" 🐼")
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
        
        API.custAPIV1.loadServiceActionFavorites(type: self.type, currentIDs: self.currentIds) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let actions = resp.data else {
                showError(.generalError, .unexpenctedMissingPayload)
                return
            }
            
            self.favorits = actions
            
            self.actions = actions
            
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
                
                API.custAPIV1.searchActionItem(
                    term: _term,
                    currentIDs: self.currentIds,
                    type: self.type
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
