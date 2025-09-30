//
//  FiscalConceptDestinationItemsView.swift
//  
//
//  Created by Victor Cantu on 9/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptDestinationItemsView: Tr {
    
    override class var name: String { "tr" }
    
    var addMoreButtonIsHidden: State<Bool>
    /// store, order, sold, merm, returnToVendor
    let selectedPlace: InventoryPlaceType
    let storeid: UUID?
    let storeName: String
    let custAccountId: UUID?
    ///  can be order id, sale id
    let placeid: UUID?
    let placeName: String
    let bodid: UUID?
    let bodName: String
    let secid: UUID?
    let secName: String
    let units: Int64
    let series: [String]
    
    private var callback: ((
        _ viewid: UUID
    ) -> ())
    
    init(
        addMoreButtonIsHidden: State<Bool>,
        /// store, order, sold, merm, returnToVendor
        selectedPlace: InventoryPlaceType,
        storeid: UUID?,
        storeName: String,
        custAccountId: UUID?,
        placeid: UUID?,
        placeName: String,
        bodid: UUID?,
        bodName: String,
        secid: UUID?,
        secName: String,
        units: Int64,
        series: [String],
        callback: @escaping ((
            _ viewid: UUID
        ) -> ())
    ) {
        self.addMoreButtonIsHidden = addMoreButtonIsHidden
        self.selectedPlace = selectedPlace
        self.storeid = storeid
        self.storeName = storeName
        self.custAccountId = custAccountId
        self.placeid = placeid
        self.placeName = placeName
        self.bodid = bodid
        self.bodName = bodName
        self.secid = secid
        self.secName = secName
        self.units = units
        self.series = series
        
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var viewid: UUID = .init()
    
    @DOM override var body: DOM.Content {
        Td{
            Img()
                .src("/skyline/media/cross.png")
                .cursor(.pointer)
                .width(18.px)
                .onClick {
                    self.callback(self.viewid)
                    self.remove()
                }
        }
        Td(self.units.toString)
            .align(.center)
        Td(self.selectedPlace.description)
            .align(.center)
        Td("\(self.storeName) \(self.placeName)".purgeSpaces)
        Td(self.bodName)// Bodega
        Td(self.secName)// Seccion
        Td(self.series.joined(separator: ", "))
    }
    
    override func buildUI() {
        super.buildUI()
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
