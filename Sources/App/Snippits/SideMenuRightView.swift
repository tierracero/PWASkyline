//
//  SideMenuRightView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web

class SideMenuView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((_ caller: String) -> ())
    
    lazy var config = SideMenuItemView(
        icon: "/skyline/media/gear.png",
        title: "Ajustes y Herramientas",
        subTitle: "Controla los ajustes operativos",
        caller: "config"
    ) { caller in
        self.callback(caller)
    }
    
    init(
        callback: @escaping ((_ caller: String) -> ())
    ) {
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Div().height(60.px)
            
            Img()
                .closeButton(.sideMenu)
                .float(.right)
                .position(.sticky)
                .right(15.px)
                .top(15.px)
                .cursor(.pointer)
                .zIndex(99)
                .onClick {
                    self.callback("close")
                }
            
            H1("Herramientas")
                .color(.lightBlueText)
            
            if linkedProfile.contains(.POCs) || linkedProfile.contains(.budgetManager){
                
                // Cobranza
                SideMenuItemView(
                    icon: "/skyline/media/zoom.png",
                    title: "Buscar en Compras",
                    subTitle: "Buscar productos en compras pasadas",
                    caller: "historicalPriceSearch"
                ) { caller in
                    self.callback(caller)
                }
                
                
                // Tienda y productos
                SideMenuItemView(
                    icon: "/skyline/media/store.png",
                    title: "Productos",
                    subTitle: "Manejo de tienda y productos",
                    caller: "storeAndProducts"
                ) { caller in
                    self.callback(caller)
                }
            }
            
            if linkedProfile.contains(.configDieneroProvedores) {
                // Configuracion
                self.config
                
            }
            
            // Cerrar Session
            SideMenuItemView(
                icon: "/skyline/media/power.png",
                title: "Cerrar Sesion",
                subTitle: "No olvides cerra la session por seguridad",
                caller: "logout"
            ) { caller in
                self.callback(caller)
            }
            
            Div("Tierra Cero Skyline [" +
            "\(SkylineWeb().version.mode.rawValue) " +
            "\(SkylineWeb().version.major.toString)." +
            "\(SkylineWeb().version.minor.toString)." +
            "\(SkylineWeb().version.patch.toString)" +
            "]")
                .position(.absolute)
                .float(.right)
                .bottom(7.px)
                .right(7.px)
            
        }
        .width(33.percent)
        .height(100.percent)
        .position(.absolute)
        .right(0.px)
        .top(0.px)
        .backgroundColor(.white)
        .overflow(.auto)
        .onClick { _, event in
            event.stopPropagation()
        }
    }
    
    override func buildUI() {
        onClick {
            self.callback("")
        }
        width(100.percent)
        height(100.percent)
        backgroundColor(.transparentBlack)
        position(.fixed)
        top(0.px)
        left(0.px)
        zIndex(99999999)
        
        if custCatchHerk < 4 {
            self.config.remove()
        }
        
    }
}
