//
//  FiscalConceptDestinationManualItemsView.swift
//
//
//  Created by Victor Cantu on 12/16/23.
//

import Foundation

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptDestinationManualItemsView: Tr {
    
    override class var name: String { "tr" }
    
    var documentStatus: State<CustInventoryPurchaseManagerStatus?>
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
    @State var missingUnitsCount: Int64?
    var missingUnitsReason: InventoryPlaceType?
    
    private var callback: ((
        _ viewid: UUID?
    ) -> ())
    
    init(
        documentStatus: State<CustInventoryPurchaseManagerStatus?>,
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
        missingUnitsCount: Int64?,
        missingUnitsReason: InventoryPlaceType?,
        callback: @escaping ((
            _ viewid: UUID?
        ) -> ())
    ) {
        self.documentStatus = documentStatus
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
        self.missingUnitsCount = missingUnitsCount
        self.missingUnitsReason = missingUnitsReason
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
                .hidden(self.documentStatus.map{ $0 != .preparing })
                .cursor(.pointer)
                .width(18.px)
                .onClick {
                    
                    guard let status = self.documentStatus.wrappedValue else {
                        return
                    }
                    
                    if status != .preparing {
                        return
                    }
                    
                    self.callback(self.viewid)
                    self.remove()
                }
            
            Img()
                .src( "/skyline/media/pencil.png" )
                .hidden(self.documentStatus.map{ $0 == .preparing || $0 == .canceled || $0 == .processed })
                .cursor(.pointer)
                .marginLeft(7.px)
                .height(18.px)
                .onClick {
                    
                    guard let status = self.documentStatus.wrappedValue else {
                        return
                    }
                    
                    if status == .preparing || status == .canceled || status == .processed {
                        return
                    }
                    
                    let view = FiscalConceptDestinationManualItemsEditView(
                        totalUnitCount: self.units,
                        missingUnitsCount: self.missingUnitsCount,
                        missingUnitsReason: self.missingUnitsReason
                    ) { missingUnitsCount, missingUnitsReason in
                        self.missingUnitsCount = missingUnitsCount
                        self.missingUnitsReason = missingUnitsReason
                        self.callback(nil)
                    }
                    
                    addToDom(view)
                    
                }
        }
        Td{
            Span(self.units.toString)
            Span("/")
                .hidden(self.$missingUnitsCount.map{ $0 == nil })
                .marginRight(3.px)
                .marginLeft(3.px)
            Span(self.$missingUnitsCount.map{ $0?.toString ?? "" })
                .hidden(self.$missingUnitsCount.map{ $0 == nil })
                .color(.red)
        }
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
