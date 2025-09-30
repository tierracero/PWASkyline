//
//  ProductTransferViewRow.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ProductTransferViewRow: Div {
    
    override class var name: String { "div" }
    
    let item: CustFiscalInventoryControl
    
    private var removed: ((
        _ id: UUID
    ) -> ())
    
    init(
        item: CustFiscalInventoryControl,
        removed: @escaping ((
            _ id: UUID
        ) -> ())
    ) {
        self.item = item
        self.removed = removed
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var storeTargeting: String = ""
    
    @State var storeTargetingName: String = ""
    
    
    @State var statusName: String = ""
    
    @State var statusState: String = ""
    
    
    @DOM override var body: DOM.Content {
        Div{
            Div("Date")
                .float(.left)
                .width(110.px)
            
            Div("Folio")
                .float(.left)
                .width(110.px)
            
            Div(self.$storeTargeting)
                .class(.oneLineText)
                .width(200.px)
                .float(.left)
                        
            Div("Unidades")
                .align(.center)
                .float(.right)
                .width(70.px)
            
            Div(self.$statusName)
                .align(.center)
                .float(.right)
                .width(100.px)

            Div().class(.clear)
        }
        .marginBottom(3.px)
        .fontSize(14.px)
        .color(.gray)
        
        Div{
            Div(getDate(self.item.createdAt).formatedShort)
                .float(.left)
                .width(110.px)
            
            Div(self.item.folio)
                .float(.left)
                .width(110.px)
            
            Div(self.$storeTargetingName)
                .class(.oneLineText)
                .width(200.px)
                .float(.left)
            
            Div(self.item.items.count.toString)
                .textAlign(.center)
                .float(.right)
                .width(100.px)
            
            Div(self.$statusState)
                .float(.right)
                .width(70.px)

            Div().class(.clear)
            
        }
        .marginBottom(7.px)
        .fontSize(18.px)
        .color(.white)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.uibtnLarge)
            .width(97.percent)
        
        onClick {
            
            loadingView(show: true)
            
            API.custPOCV1.getTransferInventory(identifier: .id(self.item.id) ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.errorGeneral, resp.msg)
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
                        if data.fromStore.id == custCatchStore {
                            self.statusState = "Por Ingresar"
                        }
                    },
                    hasIngressed: {
                        if data.fromStore.id == custCatchStore {
                            self.remove()
                        }
                    })
                )
            }
            
        }
        
        /// Im the sender
        if item.fromStore == custCatchStore {
            storeTargeting = "Tienda Destino"
            
            if let storeid = item.toStore {
                storeTargetingName = stores[storeid]?.name ?? "Tienda Externa"
            }
            
        }
        /// Im the reciver
        else {
            storeTargeting = "Tienda Origen"
            storeTargetingName = stores[item.fromStore]?.name ?? "Tienda Externa"
            
            statusName = "Estado"

            if !item.isRecived {
                statusState = "Por Recibir"
            }
            else {
                statusState = "Por Ingresar"
            }
            
            
            
            
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
}
