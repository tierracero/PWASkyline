//
//  ToolsView.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolsView: Div {
    
    override class var name: String { "div" }
    
    
    /*
     
     init(
         currentChatIds: [UUID],
         callback: @escaping ((_ id: CustChatRoomProfile) -> ())
     ) {
         self.currentChatIds = currentChatIds
         self.callback = callback
         super.init()
     }
     
     required init() {
         fatalError("init() has not been implemented")
     }
     
    */
    
    @DOM override var body: DOM.Content {
        VPopUp(.custome(w: 980, h: 620)) {
            VTitle("Ajustes y Herramientas") {
                USmallTitle("Configuración del sistema")
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                self.menuItem(
                    icon: "/skyline/media/service_icon.png",
                    title: "Servicios",
                    subtitle: "Administra servicios y configuraciones operativas"
                ) {
                    addToDom(ServiceManager())
                    self.remove()
                }

                self.menuItem(
                    icon: "/skyline/media/gear.png",
                    title: "Ajustes",
                    subtitle: "Configura las reglas generales del sistema"
                ) {
                    addToDom(SystemSettings())
                    self.remove()
                }

                self.menuItem(
                    icon: "/skyline/media/user_configuration_icon.png",
                    title: "Tiendas y Usuarios",
                    subtitle: "Gestiona tiendas, perfiles y accesos"
                ) {
                    addToDom(SystemSettings.UserStoreConfiguration())
                    self.remove()
                }

                self.menuItem(
                    icon: "/skyline/media/website_icon.png",
                    title: "Página Web",
                    subtitle: "Edita el contenido y la apariencia del sitio"
                ) {
                    guard let tcaccount else {
                        showError(.generalError, "No se localizaron datos de la cuenta")
                        return
                    }

                    addToDom(WebPage(account: tcaccount))
                    self.remove()
                }
            }
        }
    }

    private func menuItem(
        icon: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> VGrid {
        VGrid(.half) {
            VBox(.interactive) {
                Img()
                    .src(icon)
                    .width(78.px)
                    .height(78.px)
                    .custom("object-fit", "contain")

                Div {
                    USubTitle(title)
                    UMinorTitle(subtitle)
                        .marginTop(7.px)
                        .custom("line-height", "1.45")
                }
                .custom("min-width", "0")
            }
            .height(100.percent)
            .display(.grid)
            .custom("grid-template-columns", "78px minmax(0, 1fr)")
            .custom("align-items", "center")
            .custom("gap", "18px")
            .attribute("aria-label", title)
            .onClick {
                action()
            }
            .onKeyUp { _, event in
                guard event.code == "Enter" || event.code == "Space" else { return }
                event.preventDefault()
                action()
            }
        }
        .custom("min-height", "190px")
    }
    
    override func buildUI() {
        super.buildUI()

        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
    }
    
    
    override public func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
