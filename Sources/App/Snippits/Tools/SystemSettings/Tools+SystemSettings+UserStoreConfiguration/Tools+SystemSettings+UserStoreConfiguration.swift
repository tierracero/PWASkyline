//
//  Tools+UserStoreConfiguration.swift
//
//
//  Created by Victor Cantu on 6/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings {
    
    class UserStoreConfiguration: Div {
        
        override class var name: String { "div" }
        
        @State var storeList: [CustStore] = []
        
        @State var selectedStore: CustStore? = nil
        
        @State var selectMenuViewIsHidden:Bool = true

        lazy var storeSelector = Div()
        .float(.left)

        lazy var storeContainer = Div()
            .custom("height", "calc(100% - 35px)")
        
        /// [ CustStore.id : CustStore ]
        var storeRefrence: [ UUID : StoreView ] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /* MARK: MAIN TOOLS*/
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    
                    Div("Solicitudes de Trabajo")
                    .class(.uibtnLargeOrange)
                    .marginRight(12.px)
                    .marginTop(-3.px)
                    .fontSize(18.px)
                    .float(.right)
                    .onClick {
                        
                        let view = WorkRequest { user in
                            
                        }
                        
                        addToDom(view)

                    }

                    /* MARK: Reports */

                    Div{

                        Img()
                            .src("/skyline/media/spreadsheet.png")
                            .marginRight(12.px)
                            .height(18.px)
                            
                        Span("Reportes")

                    }
                    .class(.uibtnLarge)
                    .marginRight(12.px)
                    .marginTop(-3.px)
                    .fontSize(18.px)
                    .float(.right)
                    .onClick {
                        
                    }

                    /* MARK: Configuration*/
                    Div{

                        Img()
                            .src("/skyline/media/history_setting_icon_white.png")
                            .marginRight(12.px)
                            .height(18.px)
                            
                        Span("Configuracion")

                    }
                    .class(.uibtnLarge)
                    .marginRight(12.px)
                    .marginTop(-3.px)
                    .fontSize(18.px)
                    .float(.right)
                    .onClick {
                        
                        let view = ProfileControles(selectedSetting: nil) { 
                            
                        }
                        
                        addToDom(view)
                        
                    }
                    
                    H2("Tiendas Y Usuarios")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                /* MARK:  STORE TOOL*/
                Div{
                    
                    Div{

                        Div{
                            
                            Div().height(7.px)

                            /* Store Name */
                            H2(self.$selectedStore.map{$0?.name ?? "Seleccione Tienda" })
                            .hidden( self.$storeList.map{ $0.count > 1 } )
                            .paddingRight(7.px)
                            .color(.goldenRod)
                            .float(.left)

                            /* Store Selector */
                            Div{
                                
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/panel_service.png")
                                        .marginRight(12.px)
                                        .marginLeft(12.px)
                                        .height(28.px)
                                        .float(.left)
                                
                                    H2(self.$selectedStore.map{$0?.name ?? "Seleccione Tienda" })
                                    .color(.goldenRod)
                                    .float(.left)
                                    
                                    Div{
                                        Img()
                                            .src(self.$selectMenuViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                            .class(.iconWhite)
                                            .paddingTop(7.px)
                                            .opacity(0.5)
                                            .width(18.px)
                                    }
                                    .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                                    .paddingRight(3.px)
                                    .paddingLeft(7.px)
                                    .marginLeft(7.px)
                                    .float(.right)
                                    
                                    Div().clear(.both)
                                    
                                }
                                .class(.uibtn)
                                .onClick {
                                    self.selectMenuViewIsHidden = !self.selectMenuViewIsHidden
                                }
                                
                                Div{
                                    
                                    ForEach(self.$storeList) { store in
                                        Div(store.name)
                                        .custom("width", "cal(100% - 1px)")
                                        .class(.uibtn, .oneLineText)
                                        .fontSize(23.px)
                                        .onClick { _, event in
                                            self.selectedStore = store
                                            self.selectMenuViewIsHidden = true
                                            event.stopPropagation()
                                        }

                                        Div().height(3.px)

                                    }
                                    
                                    Div().height(7.px)
                                }
                                .hidden(self.$selectMenuViewIsHidden)
                                .backgroundColor(.transparentBlack)
                                .borderRadius(12.px)
                                .position(.absolute)
                                .padding(all: 3.px)
                                .margin(all: 3.px)
                                .width(300.px)
                                .zIndex(1)
                                .onClick { _, event in
                                    event.stopPropagation()
                                }
                                
                            }
                            .hidden( self.$storeList.map{ $0.count == 1} )
                            .paddingRight(7.px)

                        }
                        .float(.left)

                        Div{
                            
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(7.px)
                                .cursor(.pointer)
                                .height(18.px)
                            
                            Span("Agregar Tienda")
                            .float(.right)
                            
                        }
                        .hidden(self.$selectedStore.map{  $0 == nil })
                        .class(.uibtnLarge)
                        .marginRight(7.px)
                        .fontSize(18.px)
                        .height(22.px)
                        .float(.right)
                        .onClick {

                            let stores: [CustStoreRef] = self.storeList.map{ .init(
                                id: $0.id,
                                name: $0.name,
                                lat: $0.lat,
                                lon: $0.lon
                            )}

                            let fiscals: [FIAccountsQuick] = fiscalProfiles.map{ .init(
                                id: $0.id,
                                rfc: $0.rfc,
                                razon: $0.razon
                            )}

                          let view = StoreDetailView(
                                store: nil,
                                inventory: [],
                                stores: stores,
                                config: .init(),
                                fiscal: fiscals, 
                                bodegas: []
                            ) { event in
                            
                                switch event {
                                case .create(let store):
                                    self.storeList.append(store)
                                    
                                    let view = StoreView(store: store)
                                        .hidden(self.$selectedStore.map{ store.id != self.selectedStore?.id })
                                    
                                    self.storeContainer.appendChild(view)
                                    
                                    self.storeRefrence[store.id] = view

                                case .update(let payload):

                                    var newStorestoreList: [CustStore] = []

                                    if payload.storeId == self.selectedStore?.id {
                                        self.selectedStore?.name = payload.name
                                    }

                                    self.storeList.forEach{ store in

                                        var store = store

                                        if store.id == payload.storeId {
                                            store.name = payload.name
                                        }

                                        if self.selectedStore?.id == store.id {
                                            self.selectedStore = store
                                        }

                                        newStorestoreList.append(store)
                                    }
                                    
                                    self.storeList = newStorestoreList
                                    
                                }

                            }
                            
                            addToDom(view)
                        }
  
                        Div{
                            
                            Img()
                                .src("/skyline/media/icon_white_general_statusl@128.png")
                                .padding(all: 3.px)
                                .paddingRight(7.px)
                                .cursor(.pointer)
                                .height(18.px)
                            
                            Span("Configuracion Avanzada")
                            .float(.right)
                            
                        }
                        .hidden(self.$selectedStore.map{  $0 == nil })
                        .class(.uibtnLarge)
                        .marginRight(7.px)
                        .fontSize(18.px)
                        .height(22.px)
                        .float(.right)
                        .onClick {
                            self.loadStore()
                        }

                        Div().clear(.both)
                        
                    }
                    
                    self.storeContainer
                    
                }
                .custom("height", "calc(100% - 35px)")
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(80.percent)
            .left(10.percent)
            .top(10.percent)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            stores.forEach { id, store in
                if store.mainStore {
                    storeList.append(store)
                }
            }

             stores.forEach { id, store in
                if !store.mainStore {
                    storeList.append(store)
                }
            }

            stores.forEach { id, store in
                
                let view = StoreView(store: store)
                    .hidden(self.$selectedStore.map{ id != self.selectedStore?.id })
                
                storeContainer.appendChild(view)
                
                storeRefrence[id] = view
                
            }
            
            selectedStore = storeList.first
            
        }

        func loadStore() {

            loadingView(show: true)
            
            guard let selectedStore else {
                showError(.generalError, "Seleccione tienda para configurar")
                return
            }

            getUsers(storeid: selectedStore.id, onlyActive: true) { users in
                
                API.custAPIV1.loadStore(storeId: selectedStore.id) { resp in
                
                    loadingView(show: false)

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }

                    let view = StoreDetailView(
                        store: payload.store,
                        inventory: payload.inventory,
                        stores: payload.stores,
                        config: payload.config,
                        fiscal: payload.fiscal, 
                        bodegas: payload.bodegas
                    ){ event in
                    
                        switch event {
                        case .create(let store):
                            self.storeList.append(store)
                            
                            let view = StoreView(store: store)
                                .hidden(self.$selectedStore.map{ store.id != self.selectedStore?.id })
                            
                            self.storeContainer.appendChild(view)
                            
                            self.storeRefrence[store.id] = view

                        case .update(let payload):

                            var newStorestoreList: [CustStore] = []

                            if payload.storeId == self.selectedStore?.id {
                                self.selectedStore?.name = payload.name
                            }

                            self.storeList.forEach{ store in

                                var store = store

                                if store.id == payload.storeId {
                                    store.name = payload.name
                                }

                                if self.selectedStore?.id == store.id {
                                    self.selectedStore = store
                                }

                                newStorestoreList.append(store)
                            }
                            
                            self.storeList = newStorestoreList
                            
                        }

                    }
                    
                    addToDom(view)

                }
            }
        }
    }
}
