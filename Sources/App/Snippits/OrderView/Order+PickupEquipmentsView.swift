//
//  Order+PickupEquipmentsView.swift
//  
//
//  Created by Victor Cantu on 11/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension OrderView {
    
    class PickupEquipmentsView: Div {
        
        override class var name: String { "div" }
        
        let equipmentPickedStatusRefrence: [UUID:State<Bool>]
        
        let equipments: [CustOrderLoadFolioEquipments]
        
        let accountid: UUID
        
        let orderid: UUID
        
        let orderFolio: String
        
        private var callback: ((
            _ equipment: CustOrderLoadFolioEquipments,
            _ callback: ((
                _ success: Bool
            ) -> ())
        ) -> ())
        
        init(
            equipmentPickedStatusRefrence: [UUID:State<Bool>],
            equipments: [CustOrderLoadFolioEquipments],
            accountid: UUID,
            orderid: UUID,
            orderFolio: String,
            callback: @escaping ( (
                _ equipment: CustOrderLoadFolioEquipments,
                _ callback: ((
                    _ success: Bool
                ) -> ())
            ) -> ())
        ) {
            self.equipmentPickedStatusRefrence = equipmentPickedStatusRefrence
            self.equipments = equipments
            self.accountid = accountid
            self.orderid = orderid
            self.orderFolio = orderFolio
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var equipmentContainer = Div()
            .maxHeight(250.px)
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                Div{
                    
                    /// Header
                    Div {
                        
                        Img()
                            .closeButton(.subView)
                            .onClick {
                                self.remove()
                            }
                        
                        H2("Entregar Equipos")
                            .color(.lightBlueText)
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    self.equipmentContainer
                }
                .padding(all: 12.px)
                
            }
            .custom("left", "calc(50% - 225px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .top(25.percent)
            .width(450.px)
            .color(.white)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            equipments.forEach { equipment in
             
                if let _ = equipment.deliveredBy {
                    /// Has been deliverd
                    return
                }
                
                guard let state = equipmentPickedStatusRefrence[equipment.id] else {
                    return
                }
                
                equipmentContainer.appendChild(Div{
                    Div{
                        Div("\(equipment.tag1) \(equipment.tag2) \(equipment.tag3)").padding(all: 7.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        Div("Entregar")
                            .color(.yellowTC)
                            .class(.uibtn)
                            .hidden(state)
                            .onClick {
                                self.callback(equipment) { success in
                                    
                                }
                            }
                    }
                    .width(50.percent)
                    .align(.right)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }.marginBottom(7.px))
                
            }
            
        }
        
    }
}
