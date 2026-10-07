//
// TripControler+AddMerchandise.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerAddMerchandise: Div {

    override class var name: String { "div" }

    let account: CustAcctSearch
    let origin: CustCommercialTripsComponents.TripLocation
    var merchendises: [FiscalMercanciaBase]
    let callback: (FiscalMercanciaBase) -> Void
    let create: () -> Void

    init(
        account: CustAcctSearch,
        origin: CustCommercialTripsComponents.TripLocation,
        merchendises: [FiscalMercanciaBase],
        callback: @escaping (FiscalMercanciaBase) -> Void,
        create: @escaping () -> Void
    ) {
        self.account = account
        self.origin = origin
        self.merchendises = merchendises
        self.callback = callback
        self.create = create
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    lazy var itemsContainer = Div()
        .class(Class(TCCrystalSurfaceClass.tripPickerList))
 
    private func createButton() -> Button {
        Button("+ Agregar")
            .attribute("type", "button")
            .class(
                Class(TCCrystalSurfaceClass.goodButton),
                Class(TCCrystalSurfaceClass.tripPickerCreate)
            )
            .onClick {
                self.create()
                self.remove()
            }
    }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_merchandise.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2("Seleccione Mercancia")
                        .class(
                            Class(TCTripBetaClass.titleText),
                            Class(TCCrystalSurfaceClass.tripPickerTitle)
                        )
                }
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-width", "0")

                Div {

                    self.createButton()

                    Img()
                        .closeButton(.uiView2)
                        .class(Class(TCCrystalSurfaceClass.tripPickerClose))
                        .onClick {
                            self.remove()
                        }
                }
                .class(
                    Class(TCTripBetaClass.titleActions),
                    Class(TCCrystalSurfaceClass.tripPickerActions)
                )
            }
            .class(
                Class(TCTripBetaClass.title),
                Class(TCCrystalSurfaceClass.tripPickerHeader)
            )

            Div {
                self.itemsContainer
            }
            .class(Class(TCCrystalSurfaceClass.tripPickerBody))
        }
        .class(
            Class(TCTripBetaClass.popUpPanel),
            Class(TCTripBetaClass.popUpPanelFitContent),
            Class(TCCrystalSurfaceClass.tripPickerPanel)
        )
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        self.class(Class(TCCrystalSurfaceClass.tripPicker))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")

        if merchendises.isEmpty {
            itemsContainer.appendChild(
                Div {
                    Div("👾")
                        .class(Class(TCCrystalSurfaceClass.tripPickerEmptyIcon))

                    H2("No hay opciones disponibles")
                        .class(Class(TCCrystalSurfaceClass.tripPickerEmptyTitle))

                    self.createButton()
                }
                .class(Class(TCCrystalSurfaceClass.tripPickerEmpty))
            )
            return
        }

        merchendises.forEach { item in
            itemsContainer.appendChild(
                Div {
                    Div("\(item.fiscCode) \(item.description)")
                        .class(
                            .oneLineText,
                            Class(TCCrystalSurfaceClass.tripPickerItemTitle)
                        )

                    Div("Unidad \(item.fiscUnitName) | Peso \(item.kilograms.fromCents.toString) kg")
                        .class(
                            .oneLineText,
                            Class(TCCrystalSurfaceClass.tripPickerItemSubtitle)
                        )
                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxInteractive),
                    Class(TCCrystalSurfaceClass.tripPickerItem)
                )
                .onClick {
                    self.callback(item)
                    self.remove()
                }
            )
        }
    }



}
