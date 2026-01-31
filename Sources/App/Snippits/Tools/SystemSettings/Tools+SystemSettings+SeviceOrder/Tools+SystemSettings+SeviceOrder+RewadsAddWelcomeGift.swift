//
//  Tools+SystemSettings+SeviceOrder+RewadsAddWelcomeGift.swift
//  
//
//  Created by Victor Cantu on 9/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.SeviceOrder {
    
    class RewadsAddWelcomeGift: Div {
        
        override class var name: String { "div" }
        
        let currentGifts: [RewardsProgramWelcomeItems]
        
        private var callback: ((
            _ item: RewardsProgramWelcomeItems
        ) -> ())
        
        init(
            currentGifts: [RewardsProgramWelcomeItems],
            callback: @escaping ( (
                _ item: RewardsProgramWelcomeItems
            ) -> ())
        ) {
            self.currentGifts = currentGifts
            self.callback = callback
            
            super.init()
        }
        
        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var newItems: [RewardsProgramWelcomeItems.Items] = []
        
        lazy var itemGrid = Div()
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("+ Regalo de Bienvenida")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                Div{
                    
                    Table().noResult(label: "⚠️ No hay recompensas que agregar")
                        .hidden(self.$newItems.map{ !$0.isEmpty })
                    
                    self.itemGrid
                        .hidden(self.$newItems.map{ $0.isEmpty })
                    
                }
                .class(.roundDarkBlue)
                .padding(all: 7.px)
                .height(200.px)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 250px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(500.px)
            .top(20.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            var currentGifts = currentGifts.map{ $0.item }
            
            RewardsProgramWelcomeItems.Items.allCases.forEach { item in
                
                switch item {
                case .freePoints:
                    if !currentGifts.contains(.freePoints) {
                        newItems.append(.freePoints)
                    }
                }
                
            }
            
            newItems.forEach { item in
                switch item {
                case .freePoints:
                    
                    @State var points: String = ""
                    
                    let pointsField = InputText($points)
                        .backgroundColor(r: 52, g: 54, b: 58)
                        .onFocus { tf in tf.select() }
                        .class(.textFiledBlackDark)
                        .placeholder("100")
                        .textAlign(.right)
                        .height(32.px)
                        .width(100.px)
                        .float(.right)
                        .onClick { _, event in
                            event.stopPropagation()
                        }
                    
                    itemGrid.appendChild(
                        Div{
                            
                            pointsField
                            
                            H3("Puntos ")
                                .color(.white)
                                .float(.left)
                            
                            Div()
                                .marginBottom(3.px)
                                .clear(.both)
                            
                            Div("Minimo recomendado 100 puntos (50 ~ 75 mxp)")
                                .fontSize(18.px)
                                .color(.gray)
                        }
                        .class(.uibtnLarge)
                        .width(95.percent)
                        .onClick {
                            
                            guard let points = Double(points)?.rounded().toInt else {
                                showError(.generalError, "Ingrese pubtos a agreagr")
                                pointsField.select()
                                return
                            }
                            
                            guard points > 0 else {
                                showError(.generalError, "Ingrese pubtos a agreagr")
                                pointsField.select()
                                return
                            }
                            
                            self.callback(.freePoints(points))
                            
                            self.remove()
                            
                        }
                    )
                }
            }
            
        }
        
    }
}

