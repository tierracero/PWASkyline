//
//  HistorySettings+TripProcessing.swift
//
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals
import Web


/*
TODO:
    1) 
*/
extension ToolsView.HistorySettings {
    
    class TripProcessing: Div {
        
        override class var name: String { "div" }
        
        @State var currentView: CuttentView = .reportView

        var searchHistoricalPurchaseView: SearchHistoricalPurchaseView? =  nil
        
        @State var departmentSelectListener = ""

        lazy var settingViewContainer = Div()

        var settingViewIsLoaded = false 
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Ajustes y Auditoria del Sistema de Viajes")
                        .color(.lightBlueText)
                        .marginRight(12.px)
                        .float(.left)
                    
                    if custCatchHerk > 2 {
                        
                        H2("Ajustes")
                            .borderBottom(width: .thin, style: self.$currentView.map{($0 == .settingsView) ? .solid : .none }, color: .lightBlue)
                            .color(self.$currentView.map{ ($0 == .settingsView) ? .lightBlue : .gray })
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .float(.right)
                            .onClick {
                                self.loadSincView()
                            }
                    }
                    
                    H2("Reportes")
                        .borderBottom(width: .thin, style: self.$currentView.map{($0 == .reportView) ? .solid : .none }, color: .lightBlue)
                        .color(self.$currentView.map{ ($0 == .reportView) ? .lightBlue : .gray })
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .float(.right)
                        .onClick {
                            self.currentView = .reportView
                        }
                    
                    Div().class(.clear)

                }
                .class(Class(TCCrystalSurfaceClass.historyTripProcessingHeader))
                
                Div{
                    Reports()
                }
                .hidden(self.$currentView.map{ $0 != .reportView })
                .custom("height","calc(100% - 35px)")
                .borderRadius(12.px)
                .marginTop(7.px)
                .class(Class(TCCrystalSurfaceClass.historyTripProcessingBody))
                
                self.settingViewContainer
                .hidden(self.$currentView.map{ $0 != .settingsView })
                .custom("height","calc(100% - 35px)")
                .borderRadius(12.px)
                .marginTop(7.px)
                .class(Class(TCCrystalSurfaceClass.historyTripProcessingBody))
                
                
            }
            .custom("height", "calc(100% - 124px)")
            .custom("width", "calc(100% - 124px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(50.px)
            .top(60.px)
            .class(Class(TCCrystalSurfaceClass.historyTripProcessingPanel))
        }
        
        override func buildUI() {
            super.buildUI()
            
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

            TCCrystalSurfaceTheme.apply(to: self, variant: .historyTripProcessing)
            
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $currentView.removeAllListeners()
            $departmentSelectListener.removeAllListeners()
        }

        func loadSincView() {

            if settingViewIsLoaded  {
                currentView = .settingsView
                return
            }

            loadingView(show: true)

            API.custCommercialTrips.components { resp in

                loadingView(show: false)

                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                guard let payload = resp.data else {
                    showError(.unexpectedResult, .payloadDecodError)
                    return
                }

                let view = Settings(
                    operadors: payload.operadors,
                    insurances: payload.insurances,
                    permits: payload.permits,
                    vehicals: payload.vehicals,
                    trailers: payload.trailers,
                    merchendises: payload.merchendises,
                    locations: payload.locations
                )

                self.settingViewIsLoaded = true

                self.settingViewContainer.appendChild(view)

                self.currentView = .settingsView

            }
        }

    }
}
