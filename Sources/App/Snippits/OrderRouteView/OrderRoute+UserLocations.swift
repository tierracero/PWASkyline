//
//  OrderRoute+UserLocations.swift
//
//
//  Created by Victor Cantu on 12/21/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderRouteView {
    
    class UserLocations: Div {
        
        override class var name: String { "div" }
        
        var userLocations: [API.custRouteV1.UserLocationsObject]
        
        init(
            userLocations: [API.custRouteV1.UserLocationsObject]
        ) {
            self.userLocations = userLocations
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var mapInitiated: Bool = false
        
        lazy var mapContainer = Div()
            .hidden(self.$mapInitiated.map{ !$0 })
            .id(.init("userMap"))
            .height(100.percent)
            .width(100.percent)
        
        @DOM override var body: DOM.Content {
            Div{
                
                // MARK: Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            //let _ = JSObject.global.removeAppleMapRought!()
                            self.remove()
                        }
                    
                    H2("Ubicaciones de Usuarios")
                        .color(.lightBlueText)
                        .marginRight(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).marginTop(7.px)
                
                // MARK: Body
                Div{
                    
                    self.mapContainer
                    
                    Table().noResult(label: "🗺️ No hay hubicacione activas para este día.")
                        .hidden(self.$mapInitiated)
                    
                }
                .custom("height", "calc(100% - 55px)")
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .padding(all: 12.px)
            .position(.absolute)
            .height(90.percent)
            .width(90.percent)
            .left(5.percent)
            .top(5.percent)
        }
        
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            super.buildUI()
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
         
            initiateMap()
            
        }
        
        func initiateMap(){
            
            if !mapInitiated {
                
                loadingView(show: true)
                
                API.v1.jwt { token in
                    
                    guard let token else {
                        loadingView(show: false)
                        showError(.comunicationError, "No se pudo cargar token")
                        return
                    }
                    
                    self.mapContainer.innerHTML = ""
                        
                    let _ = JSObject.global.initiatAppleMaps!("userMap", token, JSOneshotClosure { _ in
                        
                        loadingView(show: false)
                        
                        self.mapInitiated = true
                        
                        
                        Dispatch.asyncAfter(0.3) {
                            
                            self.processMap()
                            
                        }
                        
                        return .undefined
                    })
                }
            }
            else {
                self.processMap()
            }
        }
        
        func processMap(){
            
            do {
                
                var data = try JSONEncoder().encode(userLocations)
                
                guard let json = String(data: data, encoding: .utf8) else {
                    showError(.unexpectedResult, "No se pudo iniciar mapa, error al convertir data a hilo.")
                    return
                }
                
                let _ = JSObject.global.loadAppleMapUsers!("userMap", json, JSClosure { args in
                    
                    return .undefined
                })
                
            }
            catch{
                
                print("🔴 FAIL TO PROCESS MAP")
                print(error)
                
            }
            
        }
        
    }
    
}
