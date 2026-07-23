//
//  MoneyManagerView.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class MoneyManagerView: Div {
    
    override class var name: String { "div" }
    
    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 980)) {
            VTitle("Dinero y cortes") {
                if custCatchHerk > 1 {
                    USmallButton("Auditar")
                        .attribute("aria-label", "Auditar movimientos de dinero")
                        .onClick {
                            addToDom(AuditView())
                        }
                }

                USmallButton("Historial")
                    .attribute("aria-label", "Consultar historial de movimientos")
                    .onClick {
                        addToDom(HistoryView())
                    }
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.full) {
                    UMinorTitle("Seleccione una operación financiera")
                        .custom("line-height", "1.4")
                }

                self.actionCard(
                    icon: "/skyline/media/coin.png",
                    eyebrow: custCatchHerk > 1 ? "Administración" : "Gastos",
                    title: custCatchHerk > 1 ? "Otorgar dinero / gastos" : "Reportar gastos",
                    detail: custCatchHerk > 1
                        ? "Registre préstamos, gastos y movimientos financieros."
                        : "Capture y documente un gasto realizado.",
                    accent: "#ff9f0a"
                ) {
                    addToDom(FinancialServicesView())
                }

                self.actionCard(
                    icon: "/skyline/media/security.png",
                    eyebrow: "Corte propio",
                    title: "Corte de caja / banco",
                    detail: "Prepare el corte correspondiente a su usuario actual.",
                    accent: "#1887c7"
                ) {
                    addToDom(NewDailyCutView(
                        type: .bankDeposit,
                        user: API.custAPIV1.UserList(
                            id: custCatchID,
                            user: custCatchUser,
                            name: custCatchUser
                        )
                    ))
                }

                self.actionCard(
                    icon: "/skyline/media/spreadsheet.png",
                    eyebrow: "Transferencias",
                    title: "Recibir corte",
                    detail: "Seleccione un usuario y reciba su transferencia general.",
                    accent: "#72d84a"
                ) {
                    addToDom(
                        NewDailyCutView.NewDailyCutSelectUserView { user in
                            addToDom(
                                NewDailyCutView(
                                    type: .generalTransfer,
                                    user: user
                                )
                            )
                        }
                    )
                }
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
        
    }

    private func actionCard(
        icon: String,
        eyebrow: String,
        title: String,
        detail: String,
        accent: String,
        action: @escaping () -> Void
    ) -> VGrid {
        VGrid(.oneThird) {
            VBox(.interactive) {
                Div {
                    Img()
                        .src(icon)
                        .width(42.px)
                        .height(42.px)
                        .custom("object-fit", "contain")
                }
                .display(.flex)
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .width(56.px)
                .height(56.px)
                .custom("background", "rgba(8, 20, 31, 0.68)")
                .custom("border", "1px solid rgba(122, 148, 168, 0.22)")
                .borderRadius(all: 12.px)

                Div {
                    USmallTitle(eyebrow)
                        .custom("text-transform", "uppercase")
                        .custom("letter-spacing", "0.06em")

                    USubTitle(title)
                        .marginTop(5.px)

                    UMinorTitle(detail)
                        .marginTop(7.px)
                        .custom("line-height", "1.35")
                }
                .custom("min-width", "0")

                Div("›")
                    .fontSize(30.px)
                    .custom("line-height", "1")
                    .color(.lightBlueText)
            }
            .display(.grid)
            .custom("grid-template-columns", "56px minmax(0, 1fr) auto")
            .custom("align-items", "center")
            .custom("gap", "13px")
            .custom("min-height", "152px")
            .custom("border-left", "3px solid \(accent)")
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
    }
}
