//
//  OrderManagerItem.swift
//  
//
//  Created by Victor Cantu on 8/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class OrderManagerItem: Div {
    
    override class var name: String { "div" }
    
    var id: UUID
    
    var name: String
    
    var preSelectID: State<UUID?>
    
    private var callback: ((
        _ id: UUID,
        _ name: String
        
    ) -> ())
    
    init(
        id: UUID,
        name: String,
        preSelectID: State<UUID?>,
        callback: @escaping ((
            _ id: UUID,
            _ name: String
        ) -> ())
    ) {
        self.id = id
        self.name = name
        self.preSelectID = preSelectID
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
 
    @DOM override var body: DOM.Content {
        Strong(self.name)
            .fontSize(23.px)
            .color(self.preSelectID.map{ ($0 == self.id) ? .white : .gray })
    }
    
    override func buildUI() {
        border( width: .thin, style: .solid, color: self.preSelectID.map{ ($0 == self.id) ? .dodgerBlue  : .lightGray })
        backgroundColor(self.preSelectID.map{ ($0 == self.id) ? .dodgerBlue : .init(r: 244, g: 244, b: 244) })
        borderRadius(all: 12.px)
        padding(all: 7.px)
        margin(all: 3.px)
        cursor(.pointer)
        onClick {
            self.callback(self.id, self.name)
        }
    }
}
