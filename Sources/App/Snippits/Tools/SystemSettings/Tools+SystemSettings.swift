//
//  Tools+SystemSettings.swift
//  
//
//  Created by Victor Cantu on 9/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView {
    
    class SystemSettings: Div {
        
        override class var name: String { "div" }
        
        @State var selectedSetting: ConfigurationView = .seviceOrder
        
        // seviceOrder
        lazy var seviceOrderDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .seviceOrder })
            .height(100.percent)
            .width(100.percent)
        
        // seviceTags
        lazy var seviceTagsDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .seviceTags })
            .height(100.percent)
            .width(100.percent)
        
        // storeProduct
        lazy var storeProductDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .storeProduct })
            .height(100.percent)
            .width(100.percent)
        
        // general
        lazy var generalDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .general })
            .height(100.percent)
            .width(100.percent)
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Ajustes de Sistema")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                Div {
                    
                    Div{
                        Div{
                            
                            H2("Configuraciones")
                                .color(.lightBlueText)
                                .width(95.percent)
                                .marginBottom(7.px)
                            
                            if custCatchHerk > 3 {
                                
                                /// ConfigStoreProcessing
                                /// ConfigContactTags
                                Div("Ordenes de Servicio")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .seviceOrder ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .seviceOrder
                                    }
                                
                                /// ConfigServiceTags
                                Div("Etiquetas de Servicio")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .seviceTags ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .seviceTags
                                    }
                                
                                Div("Tieda / Productos")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .storeProduct ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .storeProduct
                                    }
                                    
                                /// ConfigGeneral
                                Div("General")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .general ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .general
                                    }
                            }
                            
                        }
                        .padding(all: 7.px)
                    }
                    .height(100.percent)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        self.seviceOrderDiv
                        self.seviceTagsDiv
                        self.storeProductDiv
                        self.generalDiv
                    }
                    .height(100.percent)
                    .width(75.percent)
                    .overflow(.auto)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                .custom("height", "calc(100% - 28px)")
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(90.percent)
            .left(5.percent)
            .top(10.percent)
            
        }
        
        override func buildUI() {
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custAPIV1.getConfigs { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.seviceOrderDiv.appendChild(SeviceOrder(
                    configStoreProcessing: payload.configStoreProcessing,
                    configContactTags: payload.configContactTags
                ))
                
                self.seviceTagsDiv.appendChild(SeviceTags(
                    configServiceTags: payload.configServiceTags
                ))

                self.storeProductDiv.appendChild(StoreProducts(
                    configStoreProduct: payload.configStoreProduct
                ))
                
                self.generalDiv.appendChild(General(
                    pageProfile: payload.pageProfile,
                    socialProfile: payload.socialProfile
                ))


                

                // payload.configGeneral
                // payload.configServiceTags

            }
        }
    }
}

extension ToolsView.SystemSettings {
    
    /// seviceOrder, seviceTags, ConfigGeneral
    enum ConfigurationView {
        
        /// My personal Conficuration
        case myconfig
        
        /// ConfigStoreProcessing
        /// ConfigContactTags
        case seviceOrder
        
        /// ConfigServiceTags
        case seviceTags
        
        /// ConfigGeneral
        case general
        
        ///  ConfigStoreProduct
        case storeProduct
        
    }
    
}
