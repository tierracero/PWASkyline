//
// TripControler+AddElement.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripControlerAddElement<Item>: Div {

    override class var name: String { "div" }

    let icon: String
    let title: String
    let items: [Item]
    let titleForItem: (Item) -> String
    let subtitleForItem: (Item) -> String
    let avatarForItem: ((Item) -> String?)?
    let callback: (Item) -> Void
    let create: () -> Void

    init(
        icon: String,
        title: String,
        items: [Item],
        titleForItem: @escaping (Item) -> String,
        subtitleForItem: @escaping (Item) -> String,
        callback: @escaping (Item) -> Void,
        create: @escaping () -> Void,
        avatarForItem: ((Item) -> String?)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.items = items
        self.titleForItem = titleForItem
        self.subtitleForItem = subtitleForItem
        self.avatarForItem = avatarForItem
        self.callback = callback
        self.create = create
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
                        .src("/skyline/media/\(self.icon)")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.title)
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
                    Div("+ Agregar")
                        .class(
                            Class(TCTripBetaClass.uiButton),
                            Class(TCTripBetaClass.uiSmallButton),
                            Class(TCCrystalSurfaceClass.tripPickerCreate)
                        )
                        .onClick {
                            self.create()
                            self.remove()
                        }

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

        if items.isEmpty {
            itemsContainer.appendChild(
                Div {
                    Div("👾")
                        .class(Class(TCCrystalSurfaceClass.tripPickerEmptyIcon))

                    H2("No hay opciones disponibles")
                        .class(Class(TCCrystalSurfaceClass.tripPickerEmptyTitle))

                    Div("+ Agregar")
                        .class(
                            Class(TCTripBetaClass.uiButton),
                            Class(TCTripBetaClass.uiSmallButton),
                            Class(TCCrystalSurfaceClass.tripPickerCreate)
                        )
                        .onClick {
                            self.create()
                            self.remove()
                        }
                }
                .class(Class(TCCrystalSurfaceClass.tripPickerEmpty))
            )
            return
        }

        items.forEach { item in
            itemsContainer.appendChild(
                Div {
                    if let avatarForItem = self.avatarForItem {
                        tripAvatarImage(avatarForItem(item))
                            .width(44.px)
                            .height(44.px)
                            .borderRadius(all: 8.px)
                    }

                    Div {
                        Div(self.titleForItem(item))
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.tripPickerItemTitle)
                            )

                        Div(self.subtitleForItem(item))
                            .class(
                                .oneLineText,
                                Class(TCCrystalSurfaceClass.tripPickerItemSubtitle)
                            )
                    }
                    .custom("min-width", "0")
                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxInteractive),
                    Class(TCCrystalSurfaceClass.tripPickerItem)
                )
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "10px")
                .onClick {
                    self.callback(item)
                    self.remove()
                }
            )
        }
    }

}
