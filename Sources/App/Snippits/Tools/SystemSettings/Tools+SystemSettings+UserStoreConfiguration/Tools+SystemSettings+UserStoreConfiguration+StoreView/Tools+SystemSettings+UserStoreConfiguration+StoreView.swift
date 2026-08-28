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

        @State var userCount: Int = 0

        private var isLoadingConfiguration = false
        
        /// UserCard
        
        lazy var usersContainers = Div()
            .class(Class(TCStoreUserConfigurationClass.userList))
        
        @DOM override var body: DOM.Content {
            Div {
                Table().noResult(label: "🛍️ Cargando tienda \(self.store.name)")
            }
                .class(Class(TCStoreUserConfigurationClass.storeLoading))
                .hidden(self.$isLoaded)
                .display(self.$isLoaded.map { $0 ? .none : .flex })

            Div {
                Div {
                    Div {
                        H2("Usuarios activos")
                    }
                        .class(Class(TCStoreUserConfigurationClass.cardHeader))
                    self.usersContainers
                    Div("Gestionar usuarios")
                        .class(Class(TCCrystalSurfaceClass.goodButton))
                        .onClick {
                            // Individual user cards remain the interaction surface.
                        }
                }
                    .class(Class(TCStoreUserConfigurationClass.card))

                Div {
                    Div {
                        H2("Activos y herramientas")
                    }
                        .class(Class(TCStoreUserConfigurationClass.cardHeader))

                    Div {
                        self.toolRow(
                            title: "Inventario",
                            detail: "Productos y existencias",
                            count: self.$inventorie.map { $0.count.toString },
                            icon: "/skyline/media/panel_service.png"
                        )
                        self.toolRow(
                            title: "Bodegas",
                            detail: "Bodegas y ubicaciones",
                            count: self.$bodegas.map { $0.count.toString },
                            icon: "/skyline/media/panel_service.png"
                        )
                        self.toolRow(
                            title: "Secciones",
                            detail: "Secciones y categorías",
                            count: self.$sections.map { $0.count.toString },
                            icon: "/skyline/media/panel_service.png"
                        )
                        self.toolRow(
                            title: "Horarios",
                            detail: "Configuración de operación",
                            count: "—",
                            icon: "/skyline/media/icon_history.png"
                        )
                    }
                        .class(Class(TCStoreUserConfigurationClass.toolsList))

                    Div("Agregar")
                        .class(Class(TCCrystalSurfaceClass.goodButton))
                        .onClick {
                            // Tool creation remains scoped to the existing advanced configuration flow.
                        }
                }
                    .class(Class(TCStoreUserConfigurationClass.card))
            }
                .class(Class(TCStoreUserConfigurationClass.cards))
                .hidden(self.$isLoaded.map { !$0 })
                .display(self.$isLoaded.map { !$0 ? .none : .grid })
        }

        private func metric(
            label: String,
            value: State<Int>,
            icon: String
        ) -> Div {
            Div {
                Div {
                    Img().src(icon)
                }
                    .class(Class(TCStoreUserConfigurationClass.metricIcon))

                Div {
                    Span(label)
                        .class(Class(TCStoreUserConfigurationClass.metricLabel))
                    Span(value.map { $0.toString })
                        .class(Class(TCStoreUserConfigurationClass.metricValue))
                }
                    .class(Class(TCStoreUserConfigurationClass.metricCopy))
            }
                .class(Class(TCStoreUserConfigurationClass.metric))
        }

        private func metric(
            label: String,
            value: State<String>,
            icon: String
        ) -> Div {
            Div {
                Div {
                    Img().src(icon)
                }
                    .class(Class(TCStoreUserConfigurationClass.metricIcon))

                Div {
                    Span(label)
                        .class(Class(TCStoreUserConfigurationClass.metricLabel))
                    Span(value)
                        .class(Class(TCStoreUserConfigurationClass.metricValue))
                }
                    .class(Class(TCStoreUserConfigurationClass.metricCopy))
            }
                .class(Class(TCStoreUserConfigurationClass.metric))
        }

        private func toolRow(
            title: String,
            detail: String,
            count: State<String>,
            icon: String
        ) -> Div {
            Div {
                Div {
                    Img().src(icon)
                }
                    .class(Class(TCStoreUserConfigurationClass.toolIcon))

                Div {
                    Strong(title)
                        .class(Class(TCStoreUserConfigurationClass.toolName))
                    Span(detail)
                        .class(Class(TCStoreUserConfigurationClass.toolDetail))
                }
                    .class(Class(TCStoreUserConfigurationClass.toolCopy))

                Span(count)
                    .class(Class(TCStoreUserConfigurationClass.toolCount))
            }
                .class(Class(TCStoreUserConfigurationClass.toolRow))
        }

        private func toolRow(
            title: String,
            detail: String,
            count: String,
            icon: String
        ) -> Div {
            Div {
                Div {
                    Img().src(icon)
                }
                    .class(Class(TCStoreUserConfigurationClass.toolIcon))

                Div {
                    Strong(title)
                        .class(Class(TCStoreUserConfigurationClass.toolName))
                    Span(detail)
                        .class(Class(TCStoreUserConfigurationClass.toolDetail))
                }
                    .class(Class(TCStoreUserConfigurationClass.toolCopy))

                Span(count)
                    .class(Class(TCStoreUserConfigurationClass.toolCount))
            }
                .class(Class(TCStoreUserConfigurationClass.toolRow))
        }
        
        override func buildUI() {
            super.buildUI()
            TCStoreUserConfigurationTheme.applyStoreWorkspace(to: self)
            height(100.percent)
            loadIfNeeded()
        }

        func loadIfNeeded() {
            guard !isLoaded, !isLoadingConfiguration else {
                return
            }

            isLoadingConfiguration = true

            loadingView.show()
            
            API.custAPIV1.getStoreConfiguration(
                storeId: store.id
            ) { resp in

                loadingView.hide()
                self.isLoadingConfiguration = false
                
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
                
                self.store = payload.store
                
                self.bodegas = payload.bodegas
                
                self.sections = payload.sections
                
                self.inventorie = payload.inventorie
                self.userCount = payload.users.count
                
                let userSnippitRefrence = Dictionary(uniqueKeysWithValues: payload.usersPreformancenSippets.map{ ( $0.userId, $0) })
                
                payload.users.forEach { user in
                    
                    let view = UserCard(
                        user: user,
                        snippit: userSnippitRefrence[user.id]
                    ){ userCard in
                            
                        loadingView.show()
                        
                        API.custAPIV1.getUser(id: .id(user.id), full: true) { resp in
                            
                            loadingView.hide()
                            
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
                            
                            addToDom(view, presentation: .glass)
                            
                        }
                    }
                    
                    self.usersContainers.appendChild(view)
                    
                }

                self.isLoaded = true
            }
        }

        func reloadUsers() {
            guard !isLoadingConfiguration else { return }
            usersContainers.innerHTML = ""
            isLoaded = false
            loadIfNeeded()
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $store.removeAllListeners()
            $isLoaded.removeAllListeners()
            $bodegas.removeAllListeners()
            $sections.removeAllListeners()
            $inventorie.removeAllListeners()
            $userCount.removeAllListeners()
        }
    }
}
