//
//  POCStorageControlView.swift
//  
//
//  Created by Victor Cantu on 2/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class POCStorageControlView: Div {
    
    override class var name: String { "div" }
    
    let pocid: UUID

    let pocName: String

    var reqSeries: Bool
    
    let storeId: UUID
    
    let store: CustStore
    
    let storagePlace: CustStoreProductSection
    
    var countListener: State<Int>
    
    var items: [CustPOCInventoryIDSale]
    
    private var updateBodega: ((
        _ bod: CustStoreBodegasSinc
    ) -> ())
    
    private var updateSeccion: ((
        _ sec: CustStoreSeccionesSinc
    ) -> ())
    
    private var updateInventoryCount: ((
        _ units: Int
    ) -> ())
    
    init(
        pocid: UUID,
        pocName: String,
        reqSeries: Bool,
        storeId: UUID,
        store: CustStore,
        storagePlace: CustStoreProductSection,
        countListener: State<Int>,
        items: [CustPOCInventoryIDSale],
        updateBodega: @escaping ((
            _ bod: CustStoreBodegasSinc
        ) -> ()),
        updateSeccion: @escaping ((
            _ sec: CustStoreSeccionesSinc
        ) -> ()),
        updateInventoryCount: @escaping ((
            _ units: Int
        ) -> ())
    ) {
        self.pocid = pocid
        self.pocName = pocName
        self.reqSeries = reqSeries
        self.storeId = storeId
        self.store = store
        self.storagePlace = storagePlace
        self.countListener = countListener
        self.items = items
        self.updateBodega = updateBodega
        self.updateSeccion = updateSeccion
        self.updateInventoryCount = updateInventoryCount
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var bodegaid: UUID? = nil
    
    var seccionid: UUID? = nil
    
    var bods: [CustStoreBodegasSinc] = []
    
    lazy var storeBodegaSelect = Select()
        .class(.textFiledBlackDark)
        .height(28.px)
        .width(200.px)
    
    lazy var sectionSelectDiv = Div()
    
    lazy var itemsGrid = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(200.px)
    
    var itemViews: [POCStorageControlItemView] = []
    
    @DOM override var body: DOM.Content {
        Div{
            Div{
                Label("Bodega")
                    .color(.gray)
                Div{
                    self.storeBodegaSelect
                        .disabled(true)
                }
            }
            .class(.section)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Label("Seccion")
                    .paddingTop(11.px)
                    .width(30.percent)
                    .marginLeft(5.px)
                    .marginTop(2.px)
                    .float(.left)
                    .color(.gray)
                
                self.sectionSelectDiv
                .marginLeft(35.percent)
                .paddingTop(5.px)
            }
            .position(.relative)
            .zIndex(1)
            
            Div().class(.clear).marginBottom(7.px)
            
            self.itemsGrid
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                /// add
                Div{
                    
                    Img()
                        .src("/skyline/media/add.png")
                        .marginLeft(7.px)
                        .height(18.px)
                    
                    Span("Agregar")
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.left)
                .onClick{ div in

                    let view: StartManualInventory = StartManualInventory { name, vendor, profile in

                        let view: POCStorageControlAddInventoryView = POCStorageControlAddInventoryView(
                            pocId: self.pocid,
                            pocName: self.pocName,
                            reqSeries: self.reqSeries,
                            storeId: self.storeId,
                            storeName: self.store.name,
                            bodegaId: self.storagePlace.bodid,
                            sectionId: self.storagePlace.secid,
                            documentName: name,
                            vendor: vendor,
                            profile: profile
                        ) { items in
                             
                             self.updateInventoryCount(items.count)
                             
                             self.items.append(contentsOf: items)
                                     
                            self.countListener.wrappedValue = items.count
                            
                            items.forEach { item in
                                
                                let view = POCStorageControlItemView(item: item)
                                
                                self.itemViews.append(view)
                                
                                self.itemsGrid.appendChild(view)
                                
                            }
                            
                        }

                        let date = Date()

                        view.documentSerie = date.year.toString

                        view.documentFolio = "\(date.month.toString)\(date.day.toString)-\(callKey(5))"

                        addToDom(view)

                    }
                    
                    let date = Date()

                    view.newDocumentName = "Ingreso manual \(self.store.name) \(self.pocName) \(date.formatedShort)"

                    addToDom(view)
                    
                }
                
                Div{
                    
                    Img()
                        .src("/skyline/media/delete.png")
                        .marginLeft(7.px)
                        .height(18.px)
                    
                    Span("Mermar")
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.left)
                .onClick({ div in
                    self.mermItems()
                })
            }
            
            Div().class(.clear).marginBottom(7.px)
            
        }
    }
    
    override func buildUI() {
        super.buildUI()
        
        bodegas.forEach { id, bod in
            if bod.custStore == storeId {
                
                bods.append(bod)
                
                storeBodegaSelect.appendChild(
                    Option(bod.name)
                        .value(bod.id.uuidString)
                )
            }
        }
        
        guard let bodega = bods.first else {
            showError(.generalError, "No se localizo bodega de la tienda. Refresque o asegurese que su configuracion sea la correcta.")
            return
        }
        
        updateBodega(bodega)
        
        let view = SectionSelectField(
            storeid: storeId,
            storeName: stores[storeId]?.name ?? "",
            bodid: bodega.id,
            bodName: bodega.name,
            callback: { section in
                self.updateSeccion(section)
                self.seccionid = section.id
            }
        )
            .position(.relative)
        
        sectionSelectDiv.appendChild(view)
        
        countListener.wrappedValue = items.count
        
        items.forEach { item in
            
            let view = POCStorageControlItemView(item: item)
            
            itemViews.append(view)
            
            itemsGrid.appendChild(view)
            
        }
        
        if let sect = seccions[storagePlace.secid] {
            view.sectionSelectText = sect.name
            view.sectionSelectId = sect.id
        }
        
        bodegaid = storagePlace.bodid
        
        seccionid = storagePlace.secid
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func mermItems(){
        
        
        var ids: [UUID] = []
        
        self.itemViews.forEach { view in
            
            if view.checkbox.checked {
                ids.append(view.item.id)
            }
        }
        
        if ids.isEmpty {
            showError(.generalError, "Seleccione inventario a mermar.")
            return
        }
        
        addToDom(ConfirmationView(
            type: .acceptDeny,
            title: "Confirme Accion",
            message: "¿Desea ELIMINAR \(ids.count.toString) articulos del inventario?",
            comments: .required,
            callback: { isConfirmed, comment in
                
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.mermProductsInventory(
                        storeId: self.storeId,
                        items: ids,
                        reason: comment
                    ) { resp in
                    
                        guard let resp else {
                            loadingView(show: false)
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            loadingView(show: false)
                            showError(.comunicationError, resp.msg)
                            return
                        }
                        
                        guard let payload = resp.data else {
                            loadingView(show: false)
                            showError(.unexpectedResult, "Obtuvo payload de data.")
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Orden de Merma \(payload.folio)")
                        
                        downLoadInventoryControlOrders(id: payload.id, detailed: true)
                        
                        API.custPOCV1.getTransferInventory(identifier: .id(payload.id) ) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp = resp else {
                                showError(.comunicationError, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else{
                                showError(.generalError, resp.msg)
                                return
                            }
                            
                            guard let data = resp.data else {
                                showError(.unexpectedResult, "No se pudo obtener documento")
                                return
                            }
                            
                            addToDom(InventoryControlView(
                                control: data.control,
                                items: data.items,
                                pocs: data.pocs,
                                places: data.places,
                                notes: data.notes,
                                fromStore: data.fromStore,
                                toStore: data.toStore,
                                hasRecived: {
                                    
                                },
                                hasIngressed: {
                                    if data.fromStore.id == custCatchStore {
                                        self.remove()
                                    }
                                })
                            )
                        }
                        
                    }
                }
            })
        )
    }
    
    
}
