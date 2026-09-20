//
//  Tools+SystemSettings+UserStoreConfiguration+NewStoreType.swift
//
//
//  Created by Victor Cantu on 6/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {

        class NewStoreType: Div {

        override class var name: String { "div" }

        private var callback: (
            _ type: CustStoreType
        ) ->  Void

        init(
            callback: @escaping (
                _ type: CustStoreType
            ) ->  Void
        ) {
            self.callback = callback
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {

            VPopUp(.fitContent(w: 450)) {

                VTitle("Tipo de tienda a crear", icon: "icon_store.png") {
                    USmallTitle("Nueva tienda")
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.full) {
                        Div {
                            Div {
                                Img()
                                    .src("/skyline/media/icon_store.png")
                                    .paddingTop(3.px)
                                    .class(.iconBlue)
                                    .height(24.px)
                            }
                            .marginRight(7.px)
                            .float(.left)

                            Span(CustStoreType.branch.description)
                        }
                        .class(Class(TCCrystalSurfaceClass.goodButton))
                        .custom("width", "calc(100% - 18px)")
                        .class(.uibtnLarge)
                        .onClick {
                            self.callback(.branch)
                            self.remove()
                        }

                        Div {
                            Div {
                                Img()
                                    .src("/skyline/media/icon_warehouse.png")
                                    .paddingTop(3.px)
                                    .class(.iconBlue)
                                    .height(24.px)
                            }
                            .marginRight(7.px)
                            .float(.left)

                            Span(CustStoreType.warehouse.description)
                        }
                        .class(Class(TCCrystalSurfaceClass.goodButton))
                        .custom("width", "calc(100% - 18px)")
                        .class(.uibtnLarge)
                        .onClick {
                            self.callback(.warehouse)
                            self.remove()
                        }
                    }
                }
            }
            
        }

        override func buildUI() {
            super.buildUI()

            TCCrystalSurfaceTheme.apply(to: self, variant: .customerCreation)
            TCCrystalSurfaceTheme.applyModalHost(to: self)

            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

        }

    }

}
