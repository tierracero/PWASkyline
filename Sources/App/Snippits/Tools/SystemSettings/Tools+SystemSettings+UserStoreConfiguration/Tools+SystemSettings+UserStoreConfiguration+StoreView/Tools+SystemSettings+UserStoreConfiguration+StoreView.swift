//
//  Tools+UserStoreConfiguration+StoreView.swift
//
//
//  Created by Victor Cantu on 6/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class StoreView: Div {
        
        override class var name: String { "div" }
        
        @State var store: CustStore

        init(
            store: CustStore
        ) {
            self.store = store
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var isLoaded = false
        
        @State var bodegas: [CustStoreBodegasQuick] = []
        
        @State var sections: [CustStoreSeccionesQuick] = []
        
        @State var inventorie: [CustGeneralInventoryQuick] = []
        
        /// UserCard
        
        lazy var usersContainers = Div()
        
        @DOM override var body: DOM.Content {
            
            Div{
                Table().noResult(label: "🛍️ Cargando tienda \(self.store.name)")
            }
            .custom("height", "calc(100% - 8px)")
            .hidden(self.$isLoaded)
            
            Div{
                
                Div{
                    self.usersContainers
                }
                .custom("height", "calc(100% - 12px)")
                .custom("width", "calc(66% - 16px)")
                .class(.roundDarkBlue)
                .marginRight(12.px)
                .marginTop(7.px)
                .overflow(.auto)
                .float(.left)
                
                Div{
                    // Activos y Herramientas
                    Div {
                        Div{

                            H2("Activos y Herramientas")
                                .color(.lightGray)
                                .float(.left)
                                
                              Div{
                                
                                Img()
                                    .src("/skyline/media/add.png")
                                    .padding(all: 3.px)
                                    .paddingRight(7.px)
                                    .cursor(.pointer)
                                    .height(18.px)
                                
                                Span("Agregar")
                                .float(.right)
                                
                            }
                            .class(.uibtnLarge)
                            .marginRight(7.px)
                            .fontSize(18.px)
                            .height(22.px)
                            .float(.right)
                            .onClick {
                                // ADD tool
                            }
                            
                            Div().clear(.both)

                        }
                        
                        
                        Div().class(.clear)
                        
                        Div{
                            
                        }
                        .custom("height", "calc(100% - 42px)")
                        .class(.roundGrayBlackDark)
                        .padding(all: 3.px)
                        .marginTop(3.px)

                    }
                    .custom("height", "calc(50% - 7px)")
                    .marginBottom(7.px)
                    
                    /// Estadisticas
                    Div {
                        
                        H2("Estadisticas")
                            .color(.lightGray)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                        Div{
                            
                        }
                        .custom("height", "calc(100% - 37px)")
                        .class(.roundGrayBlackDark)
                        .padding(all: 3.px)
                        .marginTop(3.px)
                    }
                    .custom("height", "calc(50% - 7px)")
                    
                }
                .custom("height", "calc(100% - 12px)")
                //.custom("width", "calc(34% - 0px)")
                .width(34.percent)
                .marginTop(7.px)
                .overflow(.auto)
                .float(.left)
                 
            }
            .custom("height", "calc(100% - 12px)")
            .hidden(self.$isLoaded.map{ !$0 })
            .marginTop(3.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            height(100.percent)
            
            API.custAPIV1.getStoreConfiguration(
                storeId: store.id
            ) { resp in
                
                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
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
                
                self.isLoaded = true
                
                self.store = payload.store
                
                self.bodegas = payload.bodegas
                
                self.sections = payload.sections
                
                self.inventorie = payload.inventorie
                
                let userSnippitRefrence = Dictionary(uniqueKeysWithValues: payload.usersPreformancenSippets.map{ ( $0.userId, $0) })
                
                payload.users.forEach { user in
                    
                    let view = UserCard(
                        user: user,
                        snippit: userSnippitRefrence[user.id]
                    ){ userCard in
                            
                        loadingView(show: true)
                        
                        API.custAPIV1.getUser(id: .id(user.id), full: true) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else {
                                showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
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
                            
                            let view = UserView(
                                store: self.store, 
                                userCard: userCard,
                                data: payload
                            )
                            
                            addToDom(view)
                            
                        }
                    }
                    
                    self.usersContainers.appendChild(view)
                    
                }
            }
        }
    }
}
