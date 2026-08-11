//
//  CreateNewCusomerView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

class CreateNewCusomerView: Div {
    
    override class var name: String { "div" }
    
    var searchTerm: String
    
    /// general, business
    let custType: CreateNewCusomerType
    
    private var callback: ((
        ///personal, empresaFisica, empresaMoral, organizacion
        _ acctType: CustAcctTypes,
        /// general, business
        _ custType: CreateNewCusomerType,
        _ searchTerm: String
    ) -> ())
    
    init(
        searchTerm: String,
        /// general, business
        custType: CreateNewCusomerType,
        callback: @escaping ((
            ///personal, empresaFisica, empresaMoral, organizacionq
            _ acctType: CustAcctTypes,
            /// general, business
            _ custType: CreateNewCusomerType,
            _ searchTerm: String
        ) -> ())
    ) {
        self.searchTerm = searchTerm
        self.custType = custType
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 820)) {
            VTitle("Seleccione tipo de cliente", icon: "icon_add_user.png") {
                USmallTitle("Nueva cuenta")
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                if self.custType == .general {
                    self.customerTypeOption(
                        icon: "/skyline/media/icon-personal.png",
                        title: "Cuenta personal",
                        subtitle: "Persona para compras y servicios",
                        accountType: .personal
                    )
                }

                self.customerTypeOption(
                    icon: "/skyline/media/icon-biz.png",
                    title: "Empresa física",
                    subtitle: "Actividad empresarial a nombre propio",
                    accountType: .empresaFisica
                )

                self.customerTypeOption(
                    icon: "/skyline/media/icon-biz.png",
                    title: "Empresa moral",
                    subtitle: "Sociedad o entidad mercantil",
                    accountType: .empresaMoral
                )

                self.customerTypeOption(
                    icon: "/skyline/media/icon-nonprofit.png",
                    title: "Organización",
                    subtitle: "Asociación o entidad sin fines de lucro",
                    accountType: .organizacion
                )
            }
        }
    }

    private func customerTypeOption(
        icon: String,
        title: String,
        subtitle: String,
        accountType: CustAcctTypes
    ) -> VGrid {
        VGrid(.half) {
            VBox(.interactive) {
                Img()
                    .src(icon)
                    .width(64.px)
                    .height(64.px)
                    .custom("object-fit", "contain")

                Div {
                    USubTitle(title)
                    UMinorTitle(subtitle)
                        .marginTop(5.px)
                        .custom("line-height", "1.4")
                }
                .custom("min-width", "0")
            }
            .display(.grid)
            .custom("grid-template-columns", "64px minmax(0, 1fr)")
            .custom("align-items", "center")
            .custom("gap", "15px")
            .attribute("aria-label", title)
            .onClick {
                self.createCustForm(acctType: accountType)
            }
            .onKeyUp { _, event in
                guard event.code == "Enter" || event.code == "Space" else { return }
                event.preventDefault()
                self.createCustForm(acctType: accountType)
            }
        }
    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)

        TCCrystalSurfaceTheme.apply(to: self, variant: .customerCreation)
    }
    
    func createCustForm( acctType: CustAcctTypes){
        
        //SkylineApp.current.$keyUp.removeAllListeners()
        
        self.callback(
            acctType,
            self.custType,
            self.searchTerm
        )
        
        self.remove()
        
    }
    
}
