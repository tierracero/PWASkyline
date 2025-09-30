//
//  RentalItemView.swift
//  
//
//  Created by Victor Cantu on 6/2/22.
//

import Foundation
import TCFundamentals
import Web

class RentalItemView: Tr {
    
    override class var name: String { "tr" }
    
    var img = Img()
        .src("/skyline/media/tc-logo-32x32.png")
        .height(16.px)
        .marginRight(7.px)
    
    var mainString = ""
    var subString = ""
    
    var id: UUID
    var lineCount: Int
    var deleteButton: Bool
    var data: RentalProduct
    var name: String
    var cost: Int64
    
    private var callback: ((_ id: UUID) -> ())
    
    init(
        id: UUID,
        lineCount: Int,
        deleteButton: Bool,
        data: RentalProduct,
        name: String,
        cost: Int64,
        callback: @escaping ((_ id: UUID) -> ())
    ) {
        self.id = id
        self.lineCount = lineCount
        self.deleteButton = deleteButton
        self.data = data
        self.name = name
        self.cost = cost
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Td{
            Img()
                .src("/skyline/media/cross.png")
                .onClick {
                    self.callback(self.id)
                    self.remove()
                }
        }
        .align(.center)
        
        Td(String(self.lineCount))
            .align(.center)
        
        Td{
            Strong(self.mainString)
            Span(self.subString)
        }
        .colSpan(2)
        
        Td(String(1))
            .align(.center)
        Td(self.cost.formatMoney)
            .align(.center)
        Td(self.cost.formatMoney)
            .align(.center)
        
    }
    
    override func buildUI() {
        self.color(.black)
        self.padding(all: 12.px)
        
        
        mainString = "\(self.name) \(self.data.ecoNumber)"
        
        self.data.rentalActions.forEach { action in
            subString += "\(action.name.uppercased())"
            action.objects.forEach { object in
                subString += " \(object.name) \(object.value)"
            }
        }
    }
    
}
