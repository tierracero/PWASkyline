//
//  FiscalConceptManualView.swift
//  
//
//  Created by Victor Cantu on 11/19/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptManualView: Div {
    
    override class var name: String { "div" }
    
    let isEven: Bool
    
    ///preparing, prepared, purchsed, inreview, processed, canceled, internalDispute, externalDispute
    var documentStatus: State<CustInventoryPurchaseManagerStatus?>
    
    var pocid: UUID
    
    @State var upc: String
    
    @State var brand: String
    
    @State var model: String
    
    @State var name: String
    
    @State var cost: Int64
    
    @State var price: Int64
    
    private var removeRow: ((
        _ viewid: UUID
    ) -> ())
    
    private var itemsChanged: ((
    ) -> ())
    
    init(
        isEven: Bool,
        documentStatus: State<CustInventoryPurchaseManagerStatus?>,
        pocid: UUID,
        upc: String,
        brand: String,
        model: String,
        name: String,
        cost: Int64,
        price: Int64,
        removeRow: @escaping ((
            _ viewid: UUID
        ) -> ()),
        itemsChanged: @escaping ((
        ) -> ())
    ) {
        self.isEven = isEven
        self.documentStatus = documentStatus
        self.pocid = pocid
        self.upc = upc
        self.brand = brand
        self.model = model
        self.name = name
        self.cost = cost
        self.price = price
        self.removeRow = removeRow
        self.itemsChanged = itemsChanged
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    //// viewid: view
    @State var inventoryDestinations: [UUID:FiscalConceptDestinationManualItemsView] = [:]
    
    /// Number of items included
    @State var units: Int64 = 0
    
    @State var addMoreButtonIsHidden = false
    
    let viewid: UUID = .init()
    
    lazy var noSelectedInventoryView = Div {
        
        Span("Ingrese")
        
        Span{
            Img()
                .src("/skyline/media/add.png")
                .height(18.px)
                .marginLeft(7.px)
            
            Span("Entrada")
        }
        .class(.uibtn)
        .onClick {
            self.selectStoragePlace()
        }
        
        Span("para agregar inventario")
        
    }
        .hidden(self.$inventoryDestinations.map{ !$0.isEmpty })
        .padding(all: 7.px)
        .margin(all: 7.px)
        .fontSize(18.px)
        .align(.center)
        .color(.gray)
        
    lazy var selectedInventoryView = Table {
        Tr{
            Td("")
                .width(35.px)
            Td("Unis.")
                .align(.center)
                .width(100.px)
            Td("Tipo.")
                .align(.center)
                .width(100.px)
            Td("Description")
            Td("")// Bodega
                .width(150.px)
            Td("")// Seccion
                .width(150.px)
            Td("Series")
                .width(200.px)
        }
    }
        .width(100.percent)
    
    var autoLoad = true
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .src( "/skyline/media/cross.png" )
                .hidden(self.documentStatus.map{ $0 != .preparing })
                .cursor(.pointer)
                .marginLeft(7.px)
                .height(18.px)
                .onClick {
                    self.removeRow(self.viewid)
                }
            
        }
        .class(.oneLineText)
        .marginTop(7.px)
        .align(.center)
        .width(50.px)
        .float(.left)
        
        Div(self.$units.map{ $0.toString })
            .marginTop(7.px)
            .align(.center)
            .width(55.px)
            .float(.left)
        
        Div(self.$upc)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(150.px)
            .float(.left)
        
        Div{
            
            Span(self.$brand)
                .hidden(self.$brand.map{ $0.isEmpty })
                .marginRight(7.px)
            
            Span(self.$model)
                .hidden(self.$model.map{ $0.isEmpty })
                .marginRight(7.px)
            
            Span(self.$name)
                .hidden(self.$name.map{ $0.isEmpty })
            
        }
            .custom("width", "calc(100% - 640px)")
            .class(.oneLineText)
            .marginTop(7.px)
            .float(.left)
        
        Div(self.$cost.map{ $0.formatMoney })
            .class(.oneLineText)
            .marginTop(7.px)
            .width(90.px)
            .float(.left)
            .align(.right)
        
        Div(self.$price.map{ $0.formatMoney })
            .class(.oneLineText)
            .marginTop(7.px)
            .width(90.px)
            .float(.left)
            .align(.right)
        
        Div{
            
            
            Img()
                .src("/skyline/media/pencil.png")
                .hidden(self.documentStatus.map{ 
                    if let status = $0 {
                        switch status {
                        case .preparing:
                            return false
                        case .prepared:
                            return false
                        case .purchased:
                            return true
                        case .inreview:
                            return true
                        case .processed:
                            return true
                        case .canceled:
                            return true
                        case .internalDispute:
                            return true
                        case .externalDispute:
                            return true
                        }
                    }
                    else {
                        return true
                    }
                })
                .cursor(.pointer)
                .marginLeft(7.px)
                .height(18.px)
                .onClick {
                    let view = ManagePOC(
                        leveltype: .all,
                        levelid: nil,
                        levelName: "",
                        pocid: self.pocid,
                        titleText: "",
                        quickView: true
                    ) { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                        
                        self.upc = upc
                        self.brand = brand
                        self.model = model
                        self.name = name
                        self.cost = cost
                        self.price = price
                        
                        self.itemsChanged()
                        
                    } deleted: {
                        
                    }
                    addToDom(view)
                }
            
        }
        .class(.oneLineText)
        .marginTop(7.px)
        .align(.center)
        .width(50.px)
        .float(.left)
        
        Div{
            Div{
                Img()
                    .src("/skyline/media/add.png")
                    .height(18.px)
                    .marginLeft(7.px)
                
                Span("Entrada")
            }
            .class(.uibtn)
        }
        .hidden(self.$addMoreButtonIsHidden)
        .width(150.px)
        .float(.left)
        .onClick {
            self.selectStoragePlace()
        }
        
        Div().class(.clear)
        
        Div{
            
            self.noSelectedInventoryView
            
            Div{
                self.selectedInventoryView
                    .marginLeft(7.px)
                    .marginRight(7.px)
            }
            .hidden(self.$inventoryDestinations.map{ $0.isEmpty })
            .padding(all: 7.px)
            .margin(all: 7.px)
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        borderRadius(all: 12.px)
        padding(all: 3.px)
        margin(all: 3.px)
        color(.white)
        
        if !self.isEven {
            self.backgroundColor(.grayBlackDark)
        }
        
        documentStatus.listen {

            if $0 == .preparing {
                self.addMoreButtonIsHidden = false
            } else {
                self.addMoreButtonIsHidden = true
            }
        }
        
        $inventoryDestinations.listen {
            
            self.units = 0
            
            $0.forEach { id, view in
                self.units += view.units
            }
            
            self.itemsChanged()
            
        }
        
    }
    
    override func didAddToDOM() {
        if autoLoad {
            self.selectStoragePlace()
        }
    }
        
    func selectStoragePlace(){
        
        addToDom(FiscalConceptDestinationView(
            pocid: self.pocid,
            units: 0,
            callback: { selectedPlace, storeid, storeName, custAccountId, placeid, placeName, bodid, bodName, secid, secName, units, series in
            self.addStoragePlace(selectedPlace, storeid, storeName, custAccountId, placeid, placeName, bodid, bodName, secid, secName, units, series, nil, nil)
        }))
        
    }
    
    func addStoragePlace (
        _ selectedPlace: InventoryPlaceType,
        _ storeid: UUID?,
        _ storeName: String,
        _ custAccountId: UUID?,
        _ placeid: UUID?,
        _ placeName: String,
        _ bodid: UUID?,
        _ bodName: String,
        _ secid: UUID?,
        _ secName: String,
        _ units: Int64,
        _ series: [String],
        _ missingUnitsCount: Int64?,
        _ missingUnitsReason: InventoryPlaceType?
    ){
        
        let view = FiscalConceptDestinationManualItemsView(
            documentStatus: self.documentStatus,
            selectedPlace: selectedPlace,
            storeid: storeid,
            storeName: storeName,
            custAccountId: custAccountId,
            placeid: placeid,
            placeName: placeName,
            bodid: bodid,
            bodName: bodName,
            secid: secid,
            secName: secName,
            units: units,
            series: series,
            missingUnitsCount: missingUnitsCount,
            missingUnitsReason: missingUnitsReason
        ) { viewid in
            
            if let viewid {
                self.inventoryDestinations.removeValue(forKey: viewid)
            }
            else {
                self.itemsChanged()
            }
            
        }
        
        self.inventoryDestinations[view.viewid] = view
        
        self.selectedInventoryView.appendChild(view)
        
    }
    
}
