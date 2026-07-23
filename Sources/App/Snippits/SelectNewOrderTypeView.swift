//
//  SelectNewOrderTypeView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web
import TCFundamentals

class SelectNewOrderTypeView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((_ orderType: CustOrderProfiles?) -> ())
    
    init(
        callback: @escaping ((_ orderType: CustOrderProfiles?) -> ())
    ) {
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 760)) {
            VTitle("Seleccione tipo de orden") {
                USmallTitle("Nueva operación")
            } onClose: {
                self.callback(nil)
                self.remove()
            }

            VBodyGrid {
                if configStoreProcessing.moduleProfile.contains(.rental) {
                    self.orderTypeOption(
                        icon: "/skyline/DocumentFamilyIcons/rental.svg",
                        title: "Orden de renta",
                        subtitle: "Reserva y entrega de productos en renta",
                        orderType: .rental
                    )
                }

                if configStoreProcessing.moduleProfile.contains(.order) {
                    self.orderTypeOption(
                        icon: "/skyline/DocumentFamilyIcons/order.svg",
                        title: "Orden de servicio",
                        subtitle: "Diagnóstico, trabajo y seguimiento operativo",
                        orderType: .order
                    )
                }
            }
        }
    }

    private func orderTypeOption(
        icon: String,
        title: String,
        subtitle: String,
        orderType: CustOrderProfiles
    ) -> VGrid {
        let showsMultipleTypes = configStoreProcessing.moduleProfile.contains(.rental) &&
            configStoreProcessing.moduleProfile.contains(.order)

        return VGrid(showsMultipleTypes ? .half : .full) {
            VBox(.interactive) {
                Img()
                    .src(icon)
                    .width(68.px)
                    .height(68.px)
                    .custom("object-fit", "contain")

                Div {
                    USubTitle(title)
                    UMinorTitle(subtitle)
                        .marginTop(6.px)
                        .custom("line-height", "1.4")
                }
                .custom("min-width", "0")
            }
            .height(100.percent)
            .display(.grid)
            .custom("grid-template-columns", "68px minmax(0, 1fr)")
            .custom("align-items", "center")
            .custom("gap", "16px")
            .attribute("aria-label", title)
            .onClick {
                self.selectOrderType(orderType)
            }
            .onKeyUp { _, event in
                guard event.code == "Enter" || event.code == "Space" else { return }
                event.preventDefault()
                self.selectOrderType(orderType)
            }
        }
        .custom("min-height", "155px")
    }
    
    override func buildUI() {
        super.buildUI()
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        /*
        moño corbata corbaton fajin camisa patanlon chaleco  chaznet frack smokin
         
         saco
            saco slim pantalosn smil  saco recto saco vaquero pantalons vaquero
         
         minimo una semana con aticipacion
         
         1) dos imprimen la agensa del dia
          
        
        
        SkylineApp.current.$keyUp.listen {
            if $0 == "r" {
                self.startNewRental()
            }
            else if $0 == "s"{
                self.startNewOrder()
            }
        }
         */
    }
    
    func startNewRental(){
        self.callback(.rental)
        self.remove()
        //SkylineApp.current.$keyUp.removeAllListeners()
    }
    
    func startNewOrder(){
        self.callback(.order)
        self.remove()
        //SkylineApp.current.$keyUp.removeAllListeners()
    }

    private func selectOrderType(_ orderType: CustOrderProfiles) {
        self.callback(orderType)
        self.remove()
    }
    
}
