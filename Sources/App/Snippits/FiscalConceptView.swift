//
//  FiscalConceptView.swift
//  
//
//  Created by Victor Cantu on 9/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptView: Div {
    
    override class var name: String { "div" }
    
    var documentStatus: State<CustInventoryPurchaseManagerStatus?>
    
    let itemno: Int
    
    /// Number of items included
    var units: Int64 = 0
    
    /// Sums the tax per item
    var taxes: Int64 = 0
    
    let item: Conceptos.Concepto
    
    @State var docid: UUID?
    
    @State var pocid: UUID?
    
    @State var searching: Bool = false
    
    @State var isService: Bool = false
    
    var vendorid: UUID
    
    var vendorname: String
    
    var canAddTargets: State<Bool>
    
    private var callback: ((
    ) -> ())
    
    init(
        documentStatus: State<CustInventoryPurchaseManagerStatus?>,
        itemno: Int,
        docid: UUID?,
        item: Conceptos.Concepto,
        pocid: UUID?,
        vendorid: UUID,
        vendorname: String,
        canAddTargets: State<Bool>,
        callback: @escaping ((
        ) -> ())
    ) {
        self.documentStatus = documentStatus
        self.itemno = itemno
        self.docid = docid
        self.item = item
        self.pocid = pocid
        self.vendorid = vendorid
        self.vendorname = vendorname
        self.canAddTargets = canAddTargets
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var inventoryDestinations: [UUID:FiscalConceptDestinationItemsView] = [:]
    
    @State var upc: String = ""
    
    @State var brand: String = ""
    
    @State var model: String = ""
    
    @State var name: String = ""
    
    @State var cost: Int64 = 0
    
    @State var price: Int64 = 0
    
    lazy var noSelectedInventoryView = Div {
        
        Span("Ingrese")
        
        Span{
            Img()
                .src("/skyline/media/add.png")
                .height(18.px)
                .marginLeft(7.px)
            
            Span(" Entrada")
        }
        .hidden(self.canAddTargets.map{ !$0 }) 
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
        
    lazy var selectedInventoryView = Table{
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
    
    @DOM override var body: DOM.Content {
        
        Div(units.toString)
            .marginTop(7.px)
            .align(.center)
            .width(55.px)
            .float(.left)
        
        Div(item.noIdentificacion)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(150.px)
            .float(.left)
        
        Div(item.descripcion.purgeSpaces.purgeHtml)
            .custom("width", "calc(100% - 610px)")
            .class(.oneLineText)
            .marginTop(7.px)
            .float(.left)
        
        Div{
            
            Span((self.item.valorUnitario.toCents + self.taxes).formatMoney)
                .marginRight(7.px)
            
            Span(self.$cost.map{$0.formatMoney})
                .hidden(self.$cost.map{ $0 == 0 })
                .marginRight(3.px)
                .color(self.$cost.map{ ((self.item.valorUnitario.toCents + self.taxes) > $0) ? .red : .lightGreen })
                .color(.gray)
        }
        .class(.oneLineText)
        .marginTop(7.px)
        .width(200.px)
        .align(.center)
        .float(.left)
        
        Div{
            
            Img()
                .src( self.$pocid.map{ ($0 == nil) ? "/skyline/media/zoom.png" : "/skyline/media/checkmark.png"} )
                .hidden(self.$searching)
                .cursor(.pointer)
                .marginLeft(7.px)
                .height(18.px)
                .onClick {
                    if self.isService {
                        return
                    }
                    self.selectPOC()
                }
            
            Img()
                .src("/skyline/media/loader.gif")
                .hidden(self.$searching.map{ !$0 })
                .marginLeft(7.px)
                .height(18.px)
        }
        .hidden(self.$isService)
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
            .hidden(self.canAddTargets.map{ !$0 })
        }
        .hidden(self.$isService)
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
            }
            .hidden(self.$inventoryDestinations.map{ $0.isEmpty })
            .padding(all: 7.px)
            .margin(all: 7.px)
        }
        .hidden(self.$isService)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        borderRadius(all: 12.px)
        padding(all: 3.px)
        margin(all: 3.px)
        color(.white)
        
        if !self.itemno.isEven {
            self.backgroundColor(.grayBlackDark)
        }
        
        units = item.cantidad.toInt64
        
        if units > 0 {
            
            if let taxItems = item.impuestos {
                
                if let retens = taxItems.retenidos {
                    retens.retenido.forEach { reten in
                        if reten.importe > 0 {
                            
                            taxes += (reten.importe / Double(units)).toCents
                        }
                        
                    }
                }
                
                if let trass = taxItems.traslados {
                    trass.traslado.forEach { tras in
                        if tras.importe > 0 {
                            taxes += (tras.importe / Double(units)).toCents
                        }
                    }
                }
                
            }
        }
        
        if let descuento = item.descuento?.toCents {
            taxes -= descuento
        }
        
        if fiscCodeServiceCodes.contains(item.claveUnidad.uppercased()) || fiscCodeServiceCodes.contains(item.claveProdServ.uppercased()) {
            self.isService = true
        }
        
        if let pocid {
            
            API.custPOCV1.getPOC(
                id: pocid,
                full: false
            ) { resp in
                
                guard let payload = resp?.data else {
                    return
                }
                
                self.upc = payload.poc.upc
                
                self.brand = payload.poc.brand
                 
                self.model = payload.poc.model
                
                self.name = payload.poc.name
                
                self.cost = payload.poc.cost
                
                self.price = payload.poc.pricea
                
            }
            
        }
        
    }
    
    override func didAddToDOM() {
        print("i was added to dom :)")
    }
    
    func selectPOC(){
        
        if !canAddTargets.wrappedValue {
            return
        }
        
        if let pocid {
            
            let view = FiscalConceptProductView(
                pocid: pocid, 
                documentPrice: (self.item.valorUnitario.toCents + self.taxes)
            ) { pocid, upc, brand, model, name, cost, price, avatar in
                
                self.upc = upc
                self.brand = brand
                self.model = model
                self.name = name
                self.cost = cost
                self.price = price
                
                self.updateIngresModification()
                
            } isSwaped: {
                self.selectPOCAction()
            }

            addToDom(view)
            
        }
        else {
            selectPOCAction()
        }
        
    }
    
    func selectPOCAction(){
        
        addToDom(ToolReciveSendInventorySelectPOC(isManual: false, selectedPOC: { pocid, upc, brand, model, name, cost, price, avatar in
            
            self.pocid = pocid
            self.upc = upc
            self.brand = brand
            self.model = model
            self.name = name
            self.cost = cost
            self.price = price
            self.selectStoragePlace()
            
            self.updateIngresModification()
            
            API.fiscalV1.getProductControlItem(
                pseudo: "\(self.item.noIdentificacion) \(self.item.descripcion)".pseudo.purgeSpaces.purgeHtml,
                rfc: self.vendorname
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo obtener id del la articulo de compra")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, "No se pudo obtener id del la articulo de compra")
                    return
                }
                
                guard let itemid = resp.data?.id else {
                    showError(.unexpectedResult, "No se pudo obtener payload de la data del la articulo de compra")
                    return
                }
                
                API.fiscalV1.relatePOCtoProductControlItem(
                    productContolId: itemid,
                    vendorId: self.vendorid,
                    vendorRfc: self.vendorname,
                    pocid: pocid,
                    name: name,
                    brand: brand,
                    model: model,
                    upc: upc
                ) { resp in
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo replacior el POC a la Compra")
                        return
                    }
                    guard resp.status == .ok else {
                        showError(.errorGeneral, "No se pudo replacior el POC a la Compra")
                        return
                    }
                }
            }
            
        }, createPOC: { type, levelid, titleText in
            
            let view = ManagePOC(
                leveltype: type,
                levelid: levelid,
                levelName: titleText,
                pocid: nil,
                titleText: titleText,
                quickView: true
            ) { pocid, upc, brand, model, name, cost, price, avatar in
                
                self.pocid = pocid
                self.upc = upc
                self.brand = brand
                self.model = model
                self.name = name
                self.cost = cost
                self.price = price
                
                self.selectStoragePlace()
                
                self.updateIngresModification()
                
                API.fiscalV1.getProductControlItem(
                    pseudo: "\(self.item.noIdentificacion) \(self.item.descripcion)".pseudo.purgeSpaces.purgeHtml,
                    rfc: self.vendorname
                ) { resp in
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo obtener id del la articulo de compra")
                        return
                    }
                    guard resp.status == .ok else {
                        showError(.errorGeneral, "No se pudo obtener id del la articulo de compra")
                        return
                    }
                    
                    guard let itemid = resp.data?.id else {
                        showError(.unexpectedResult, "No se pudo obtener payload de la data del la articulo de compra")
                        return
                    }
                    
                    API.fiscalV1.relatePOCtoProductControlItem(
                        productContolId: itemid,
                        vendorId: self.vendorid,
                        vendorRfc: self.vendorname,
                        pocid: pocid,
                        name: name,
                        brand: brand,
                        model: model,
                        upc: upc
                    ) { resp in
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, "No se pudo replacior el POC a la Compra")
                            return
                        }
                        guard resp.status == .ok else {
                            showError(.errorGeneral, "No se pudo replacior el POC a la Compra")
                            return
                        }
                    }
                    
                }
                
            } deleted: {
                
            }
            
            view.cost = (self.item.valorUnitario.toCents + self.taxes).formatMoney
            
            view.model = self.item.noIdentificacion
            
            view.name = self.item.descripcion
            
            view.fiscCode = self.item.claveProdServ
            
            view.fiscCodeField.loadFiscalCodeData(self.item.claveProdServ)
            
            view.fiscUnit = self.item.claveUnidad
            
            view.fiscUnitField.loadFiscalCodeData(self.item.claveUnidad)
            
            view.addVendor(id: self.vendorid, name: self.vendorname)
            
            WebApp.current.document.body.appendChild( view )
            
        }))
    }
    
    func selectStoragePlace(){
        
        if !canAddTargets.wrappedValue {
            return
        }
        
        guard let pocid = pocid else {
            selectPOC()
            return
        }

        var numberOfUnits = self.units
        
        inventoryDestinations.forEach { id, item in
            numberOfUnits -= item.units
        }
        
        guard numberOfUnits > 0 else {
            return
        }
        
        addToDom(FiscalConceptDestinationView(pocid: pocid, units: numberOfUnits, callback: {selectedPlace, storeid, storeName, custAccountId, placeid, placeName, bodid, bodName, secid, secName, units, series in
            
            let view = FiscalConceptDestinationItemsView(
                addMoreButtonIsHidden: self.canAddTargets, 
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
                series: series
            ) { viewid in
                self.inventoryDestinations.removeValue(forKey: viewid)
                self.updateIngresModification()
            }
            
            self.inventoryDestinations[view.viewid] = view
            
            self.selectedInventoryView.appendChild(view)
            
            self.updateIngresModification()
            
        }))
        
    }
    
    func updateIngresModification() {
        //var item: InventroyIngresItem
        
        guard let docid else {
            return
        }
        
        var items: [InventroyIngresItemStorage] = []
        
        inventoryDestinations.forEach { _, item in
            items.append(.init(
                selectedPlace: item.selectedPlace,
                storeid: item.storeid,
                storeName: item.storeName,
                custAccountId: item.custAccountId,
                placeid: item.placeid,
                placeName: item.placeName,
                bodid: item.bodid,
                bodName: item.bodName,
                secid: item.secid,
                secName: item.secName,
                units: item.units,
                series: item.series
            ))
        }
        
        API.fiscalV1.saveIngresModification(
            docid: docid,
            itemno: itemno,
            item: .init(
                pseudo: item.descripcion.pseudo,
                pocid: pocid,
                items: items
            )
        ) { resp in
            
            guard let resp else {
                showError(.errorDeCommunicacion, "No se pudo guardar cambios temporales a \(self.item.descripcion), si el problema persiste contacte a Soporte TC")
                return
            }
            guard resp.status == .ok else {
                showError(.errorGeneral, "No se pudo guardar cambios temporales a \(self.item.descripcion), si el problema persiste contacte a Soporte TC")
                return
            }
        }
        
    }
    
    
}

