//
//  Tools+SystemSettings+SeviceOrder+RewadsAddTierReward.swift
//  
//
//  Created by Victor Cantu on 9/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.SeviceOrder {
    class RewadsAddTierReward: Div {
        
        override class var name: String { "div" }
        
        let currentRewardsItems: [RewardsProgramItems]
        
        private var callback: ((
            _ item: RewardsProgramItems
        ) -> ())
        
        init(
            currentRewardsItems: [RewardsProgramItems],
            callback: @escaping ( (
                _ item: RewardsProgramItems
            ) -> ())
        ) {
            self.currentRewardsItems = currentRewardsItems
            self.callback = callback
            
            super.init()
        }
        
        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var newItems: [RewardsProgramItems] = []
        
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
                    
                    H2("+ Regalo de Recompensa")
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
                .overflow(.auto)
                .height(250.px)
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
            
            RewardsProgramItems.allCases.forEach { item in
                if !currentRewardsItems.contains(item) {
                    newItems.append(item)
                }
            }
            
            newItems.forEach { item in
                
                itemGrid.appendChild(
                    Div{
                        
                        H3(item.description)
                            .color(.white)
                            .float(.left)
                        
                        Div()
                            .marginBottom(3.px)
                            .clear(.both)
                        
                        Div(item.helpText)
                            .fontSize(18.px)
                            .color(.gray)
                    }
                        .class(.uibtnLarge)
                        .width(95.percent)
                        .onClick {
                            self.callback(item)
                            self.remove()
                        }
                )
            }
            
        }
        
    }
}
