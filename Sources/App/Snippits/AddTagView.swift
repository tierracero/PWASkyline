//
//  AddTagView.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

/// Searches and registes vendors
class AddTagView: Div {
    
    override class var name: String { "div" }
    
    var currentTags: [String]
    
    private var callback: ((
        _ tag: String
    ) -> ())
    
    init(
        currentTags: [String],
        callback: @escaping ((
            _ tag: String
        ) -> ())
    ) {
        self.currentTags = currentTags
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""

    lazy var termField = InputText(self.$term)
        .placeholder("Etiqueta o Aplicaciones...")
        .class(.textFiledBlackDark)
        .marginRight(7.px)
        .width(96.percent)
        .height(34.px)
        .float(.left)
        .onKeyUp { tf, event in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
        }
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Agergar Etiqueta")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            Div {
                
                self.termField
                
                Div().class(.clear).marginBottom(7.px)
                
                Div("+ Agregar")
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(96.percent)
                    .onClick {
                        self.addTag()
                    }
            }
            .marginBottom(7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
    }
    
    override func buildUI() {
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        
        super.buildUI()
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        termField.select()
    }
    
    func addTag(){
        
        var tag = self.term.purgeSpaces.pseudo.uppercased()
        
        if currentTags.contains(tag) {
            showError(.generalError, "\(tag) ya esta en la lista de etiquetas / aplicaciones.")
            termField.select()
            return
        }
     
        currentTags.append(tag)
        
        callback(tag)
        
        termField.select()
        
    }
}
