//
// SelectStore.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SelectStore: Div {

    override class var name: String { "div" }

    let callback: (CustStore) -> Void

    init(
        callback: @escaping (CustStore) -> Void
    ) {
        self.callback = callback

        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    lazy var itemsContainer = Div()
        .class(Class(TCCrystalSurfaceClass.tripPickerList))

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_store.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2("Seleccione Tienda")
                        .class(
                            Class(TCTripBetaClass.titleText),
                            Class(TCCrystalSurfaceClass.tripPickerTitle)
                        )
                }
                .custom("align-items", "center")
                .custom("min-width", "0")
                .custom("gap", "8px")
                .display(.flex)

            }
            .class(
                Class(TCTripBetaClass.title),
                Class(TCCrystalSurfaceClass.tripPickerHeader)
            )
            .zIndex(1)

            // Pending: wire tabsContainer once the tab state is defined.
            // tabsContainer(selectedValue: State<String>, items: [String], callback: (String) -> Void)

            Div {
                self.itemsContainer
            }
            .class(Class(TCCrystalSurfaceClass.tripPickerBody))
        }
        .class(
            Class(TCCrystalSurfaceClass.tripPickerPanel),
            Class(TCTripBetaClass.popUpPanelFitContent),
            Class(TCTripBetaClass.popUpPanel)
        )
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        self.class(Class(TCCrystalSurfaceClass.tripPicker))
        self.class(Class(TCCrystalSurfaceClass.tripLocationPicker))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")

        stores.forEach { _, store in

            itemsContainer.appendChild(
                Div {
                    Div {
                        Div(store.name)
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.tripPickerItemTitle)
                            )

                    }
                    .custom("min-width", "0")
                }
                .class(
                    Class(TCCrystalSurfaceClass.tripPickerItem),
                    Class(TCTripBetaClass.boxInteractive),
                    Class(TCTripBetaClass.box)
                )
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "10px")
                .onClick {

                    self.callback(store)

                    self.remove()

                }
            )

        }

    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }

}
