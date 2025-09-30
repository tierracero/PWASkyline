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
        
        @State var selectedStore: UUID? = nil
        
        lazy var storeContainer = Div()
            .custom("height", "calc(100% - 42px)")
        
        /// [ CustStore.id : CustStore ]
        var storeRefrence: [ UUID : StoreView ] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{
                
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
                
                Div{
                    
                    Div{

                        Div{

                            ForEach(self.$storeList) { store in
                                Div(store.name)
                                .color(self.$selectedStore.map{ ($0 == store.id) ? .yellowTC : .lightGray })
                                .borderBottom(width: .thin, style: .solid, color: self.$selectedStore.map{$0 == store.id ? .yellowTC : .transparent})
                                .class(.uibtnLarge)
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                                .onClick {
                                    self.selectedStore = store.id
                                }
                            }

                        }
                        .float(.left)
                    
                        Div{
                            
                            Img()
                                .src("/skyline/media/add.png")
                                .padding(all: 3.px)
                                .paddingRight(7.px)
                                .cursor(.pointer)
                                .height(18.px)
                            
                            Span("Ageragr Tienda")
                            .float(.right
                            )
                            
                        }
                        .class(.uibtnLarge)
                        .marginRight(7.px)
                        .fontSize(18.px)
                        .height(22.px)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                    
                    Div().clear(.both).height(7.px)
                    
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
            
            storeList = stores.map { $1 }
            
            stores.forEach { id, store in
                
                let view = StoreView(store: store)
                    .hidden(self.$selectedStore.map{ id != self.selectedStore })
                
                storeContainer.appendChild(view)
                
                storeRefrence[id] = view
                
            }
            
            selectedStore = stores.first?.key
            
        }
    }
}
