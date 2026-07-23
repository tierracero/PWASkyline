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
    
    init(
        callback: @escaping ((_ caller: String) -> ())
    ) {
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var config = SideMenuItemView(
        icon: "/skyline/media/gear.png",
        title: "Ajustes y Herramientas",
        subTitle: "Controla los ajustes operativos",
        caller: "config"
    ) { caller in
        self.callback(caller)
    }
    

    @DOM override var body: DOM.Content {
        Div {
            VTitle("Herramientas") {
                USmallTitle("Tierra Cero Skyline")
            } onClose: {
                self.callback("close")
            }

            Div {
                if linkedProfile.contains(.POCs) || linkedProfile.contains(.budgetManager) {
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

                SideMenuItemView(
                    icon: "/skyline/media/commercial_trip.png",
                    title: "Control de Viajes",
                    subTitle: "Registra y maneja el historial de viajes",
                    caller: "tradesa_trip_control"
                ) { caller in
                    self.callback(caller)
                }

                // Cerrar Session
                SideMenuItemView(
                    icon: "/skyline/media/power.png",
                    title: "Cerrar Sesión",
                    subTitle: "Cierra la sesión para proteger tu cuenta",
                    caller: "logout"
                ) { caller in
                    self.callback(caller)
                }
            }
            .custom("height", "calc(100% - 96px)")
            .custom("box-sizing", "border-box")
            .padding(all: 12.px)
            .overflow(.auto)

            Div("Tierra Cero Skyline [" +
            "\(SkylineWeb().version.mode.rawValue) " +
            "\(SkylineWeb().version.major.toString)." +
            "\(SkylineWeb().version.minor.toString)." +
            "\(SkylineWeb().version.patch.toString)" +
            "]")
                .height(48.px)
                .custom("box-sizing", "border-box")
                .custom("color", "var(--tc-beta-muted)")
                .fontSize(12.px)
                .padding(v: 15.px, h: 12.px)
                .textAlign(.right)
        }
        .class(Class(TCTripBetaClass.popUpPanel))
        .custom("width", "min(460px, 100vw)")
        .custom("max-width", "100vw")
        .custom("max-height", "100vh")
        .height(100.percent)
        .position(.absolute)
        .right(0.px)
        .top(0.px)
        .custom("border-radius", "18px 0 0 18px")
        .custom("border-right", "0")
        .onClick { _, event in
            event.stopPropagation()
        }
    }
    
    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)

        onClick {
            self.callback("")
        }
        width(100.percent)
        height(100.percent)
        custom("background", "rgba(1, 0, 19, 0.82)")
        custom("backdrop-filter", "blur(3px)")
        position(.fixed)
        top(0.px)
        left(0.px)
        zIndex(99999999)
        
        if custCatchHerk < 4 {
            self.config.remove()
        }
        
    }
}
