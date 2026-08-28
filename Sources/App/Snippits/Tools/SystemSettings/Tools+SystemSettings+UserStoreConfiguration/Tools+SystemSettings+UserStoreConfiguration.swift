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

        @State var storeSearchText: String = ""

        lazy var storeSelector = Div()
        .float(.left)

        lazy var storeContainer = Div()
            .class(Class(TCStoreUserConfigurationClass.storeContainer))
        
        
        lazy var generalConfigurationBtn = Div{

            Img()
                .src("/skyline/media/icon_request.png")
                .marginRight(7.px)
                .class(.iconBlue)
                .height(18.px)
                
            Span("Solicitudes de Trabajo")

        }
        .class(Class(TCStoreUserConfigurationClass.action))
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

        lazy var reportsBtn = Div{

            Img()
                .src("/skyline/media/icon_report.png")
                .marginRight(7.px)
                .class(.iconBlue)
                .height(18.px)
                
            Span("Reportes")

        }
        .class(Class(TCStoreUserConfigurationClass.action))
        .marginRight(12.px)
        .marginTop(-3.px)
        .fontSize(18.px)
        .float(.right)
        .onClick {
            
        }
        .opacity(0.3)

        /* MARK: Configuration*/
        lazy var jobRequest = Div{

            Img()
                .src("/skyline/media/icon_settings.png")
                .marginRight(7.px)
                .class(.iconBlue)
                .height(18.px)
                
            Span("Configuracion")

        }
        .class(Class(TCStoreUserConfigurationClass.action))
        .marginRight(12.px)
        .marginTop(-3.px)
        .fontSize(18.px)
        .float(.right)
        .onClick {
            /*
            let view = ProfileControles(selectedSetting: nil) { 
                
            }
            
            addToDom(view)
            */
        }
        .opacity(0.3)
        


        /// [ CustStore.id : CustStore ]
        var storeRefrence: [ UUID : StoreView ] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{

                
                /* MARK: MAIN TOOLS*/
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .class(Class(TCStoreUserConfigurationClass.close))
                        .onClick {
                            self.remove()
                        }

                    self.generalConfigurationBtn

                    self.reportsBtn

                    self.jobRequest

                    H2("Tiendas y Usuarios")
                        .class(Class(TCStoreUserConfigurationClass.title))
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                    .class(Class(TCStoreUserConfigurationClass.header))
                
                
                Div {
                    Div {
                        Div {

                            Div {

                                Div{

                                    Img()
                                        .src("/skyline/media/icon_add_store.png")
                                        .marginRight(7.px)
                                        .class(.iconBlue)
                                        .height(18.px)
                                        
                                    Span("Agregar")

                                }
                                .class(Class(TCStoreUserConfigurationClass.action))
                                .marginTop(-3.px)
                                .fontSize(18.px)
                                .float(.right)
                                .onClick {
                                    self.addStore()
                                }

                                H4("Tiendas")
                                    .class(Class(TCStoreUserConfigurationClass.panelTitle))

                            }

                            Div().clear(.both).height(7.px)

                            Div {
                                ForEach(self.$storeList) { store in
                                    Div {
                                        
                                        Div()
                                            .class(Class(TCStoreUserConfigurationClass.storeIndicator))
                                            .hidden(self.$selectedStore.map { $0?.id != store.id })

                                        Div {
                                            Img()
                                                .src("/skyline/media/icon_store.png")
                                                .class(.iconBlue)
                                        }
                                            .class(Class(TCStoreUserConfigurationClass.storeIcon))

                                        Div {

                                            Img()
                                                .src("/skyline/media/edit_icon.png")
                                                .class(.iconBlue)
                                                .float(.right)
                                                .height(23.px)
                                                .onClick { _, event in
                                                    self.loadStore(store.id)
                                                    event.stopPropagation()
                                                }

                                            Span(store.name)
                                                .class(Class(TCStoreUserConfigurationClass.storeName))

                                        }
                                            // .class(Class(TCStoreUserConfigurationClass.storeCopy))

                                            
                                }
                                    .class(self.$selectedStore.map {
                                        $0?.id == store.id
                                            ? Class("\(TCStoreUserConfigurationClass.storeRow) \(TCStoreUserConfigurationClass.storeSelected)")
                                            : Class(TCStoreUserConfigurationClass.storeRow)
                                    })
                                        .hidden(self.$storeSearchText.map {
                                            !$0.isEmpty && !store.name.lowercased().contains($0.lowercased())
                                        })
                                        .onClick { _, event in
                                            self.selectedStore = store
                                            self.selectMenuViewIsHidden = true
                                            
                                            event.stopPropagation()
                                        }
                                }
                            }
                                .class(Class(TCStoreUserConfigurationClass.storeList))
                        }
                            .class(Class(TCStoreUserConfigurationClass.storesPanel))

                        Div {
                            H3("Resumen")
                            Span(self.$selectedStore.map { $0?.name ?? "Seleccione tienda" })
                                .class(Class(TCStoreUserConfigurationClass.summaryName))

                            Div {
                                Div {
                                    Span("Estado")
                                    Strong("ACTIVA")
                                }
                                    .class(Class(TCStoreUserConfigurationClass.summaryRow))

                                Div {
                                    Span("Tiendas")
                                    Strong(self.$storeList.map { $0.count.toString })
                                }
                                    .class(Class(TCStoreUserConfigurationClass.summaryRow))

                                Div {
                                    Span("Tipo")
                                    Strong(self.$selectedStore.map { $0?.mainStore == true ? "Principal" : "Operativa" })
                                }
                                    .class(Class(TCStoreUserConfigurationClass.summaryRow))
                            }
                                .class(Class(TCStoreUserConfigurationClass.summaryRows))
                        }
                            .class(Class(TCStoreUserConfigurationClass.summaryPanel))
                    }
                        .class(Class(TCStoreUserConfigurationClass.sidebar))
                    
                    Div {
                        Div {

                            H2(self.$selectedStore.map { $0?.name ?? "Seleccione Tienda" })
                                .class(Class(TCStoreUserConfigurationClass.toolbarTitle))

                            Div{

                                Img()
                                    .src("/skyline/media/icon_add_user.png")
                                    .marginRight(7.px)
                                    .class(.iconBlue)
                                    .height(18.px)
                                    
                                Span("Agregar Usuario")
                                .fontSize(18.px)

                            }
                            .class(Class(TCStoreUserConfigurationClass.action))
                            .hidden(self.$selectedStore.map { $0 == nil })
                            .height(45.px)
                            .onClick {
                                self.addUser()
                            }
                        }
                            .class(Class(TCStoreUserConfigurationClass.toolbar))

                        self.storeContainer
                    }
                        .class(Class(TCStoreUserConfigurationClass.content))

                }
                    .class(Class(TCStoreUserConfigurationClass.workspace))

            }
                .class(Class(TCStoreUserConfigurationClass.shell))
        }
        
        override func buildUI() {
            super.buildUI()

            TCStoreUserConfigurationTheme.apply(to: self)
            
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
                    .hidden(self.$selectedStore.map { $0?.id != id })
                    .display(self.$selectedStore.map { ($0?.id != id) ? .none : .block })
                
                storeContainer.appendChild(view)
                
                storeRefrence[id] = view
                
            }
            
            if let firstStore = storeList.first {
                selectedStore = firstStore
            }
            
        }

        func loadStore(_ storeId: UUID) {

            loadingView.show()
            
            getUsers(storeid: storeId, onlyActive: true) { users in
                
                API.custAPIV1.loadStore(storeId: storeId) { resp in
                
                    loadingView.hide()

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

        func addStore() {

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

        func addUser() {

            guard let selectedStore else {
                showError(.generalError, "Seleccione una tienda para agregar el usuario")
                return
            }

            guard custCatchHerk > UsernameRoles.general.value else {
                showError(.generalError, "Su nivel operativo no permite crear usuarios")
                return
            }

            loadingView.show()

            API.custUsernameV1.preRequestUsername(store: selectedStore.id) { resp in
                loadingView.hide()

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

                let view = CreateUserView(
                    store: selectedStore,
                    availability: payload
                ) {
                    self.storeRefrence[selectedStore.id]?.reloadUsers()
                }

                addToDom(view, presentation: .glass)

            }
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $storeList.removeAllListeners()
            $selectedStore.removeAllListeners()
            $selectMenuViewIsHidden.removeAllListeners()
            $storeSearchText.removeAllListeners()
        }
    }
}
