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
                    VBox(.raised) {
                        Div {
                            Img()
                                .src("/skyline/media/money_bag.png")
                                .width(40.px)
                                .height(40.px)
                                .custom("object-fit", "contain")

                            Div {
                                USubTitle("Centro financiero")
                                UMinorTitle("Seleccione una operación para administrar dinero, cortes y transferencias.")
                                    .marginTop(4.px)
                                    .custom("line-height", "1.4")
                            }
                            .custom("min-width", "0")
                        }
                        .display(.grid)
                        .custom("grid-template-columns", "50px minmax(0, 1fr)")
                        .custom("align-items", "center")
                        .custom("gap", "12px")
                    }
                    .class(Class(TCMoneyManagerClass.hero))
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
        .class(Class(TCMoneyManagerClass.popup))
    }
    
    override func buildUI() {
        super.buildUI()

        TCMoneyManagerTheme.apply(to: self)
        
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
                .class(Class(TCMoneyManagerClass.actionIcon))

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
            .class(Class(TCMoneyManagerClass.actionCard))
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

enum TCMoneyManagerClass {
    static let root = "tc-money-manager-theme"
    static let popup = "tc-money-manager-popup"
    static let hero = "tc-money-manager-hero"
    static let actionCard = "tc-money-manager-action-card"
    static let actionIcon = "tc-money-manager-action-icon"
    static let list = "tc-money-manager-list"
    static let listRow = "tc-money-manager-list-row"
    static let listIdentity = "tc-money-manager-list-identity"
    static let listAmount = "tc-money-manager-list-amount"
    static let badge = "tc-money-manager-badge"
    static let emptyState = "tc-money-manager-empty"
    static let formCard = "tc-money-manager-form-card"
    static let formGrid = "tc-money-manager-form-grid"
    static let userSummary = "tc-money-manager-user-summary"
    static let hint = "tc-money-manager-hint"
    static let primaryButton = "tc-money-manager-primary-button"
}

enum TCMoneyManagerTheme {
    private static var isInstalled = false

    static func apply(to view: Div) {
        install()
        view.class(Class(TCMoneyManagerClass.root))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }

        isInstalled = true
        let root = ".\(TCMoneyManagerClass.root)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("--tc-money-glass", "rgba(5, 22, 37, 0.76)")
                .custom("--tc-money-glass-raised", "rgba(8, 34, 54, 0.84)")
                .custom("--tc-money-border", "rgba(75, 164, 220, 0.3)")
                .custom("--tc-money-blue", "#42b7f5")
                .custom("--tc-money-green", "#72d84a")
                .custom("--tc-money-muted", "#a9bed0")

            CSSRule(Pointer("\(root)[hidden], \(root) [hidden]"))
                .custom("display", "none !important")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.popup)"))
                .custom("background", "rgba(1, 7, 14, 0.5)")
                .custom("backdrop-filter", "blur(12px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(12px) saturate(120%)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.popup) .\(TCTripBetaClass.popUpPanel)"))
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 54, 0.9), rgba(4, 15, 28, 0.8)) !important")
                .custom("border", "1px solid var(--tc-money-border) !important")
                .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.62), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(24px) saturate(135%)")
                .custom("-webkit-backdrop-filter", "blur(24px) saturate(135%)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.popup) .\(TCTripBetaClass.title)"))
                .custom("background", "rgba(3, 17, 30, 0.72) !important")
                .custom("border-bottom", "1px solid rgba(76, 169, 225, 0.2)")
                .custom("backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.popup) .\(TCTripBetaClass.bodyGrid)"))
                .custom("background", "radial-gradient(circle at 12% 8%, rgba(31, 139, 205, 0.13), transparent 34%), radial-gradient(circle at 88% 92%, rgba(35, 186, 58, 0.06), transparent 28%)")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCTripBetaClass.box)"))
                .custom("background", "var(--tc-money-glass) !important")
                .custom("border-color", "rgba(92, 153, 194, 0.24) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.035), 0 12px 28px rgba(0, 0, 0, 0.22)")
                .custom("backdrop-filter", "blur(14px)")
                .custom("-webkit-backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.hero)"))
                .custom("border-left", "3px solid var(--tc-money-blue) !important")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.actionCard)"))
                .custom("transition", "transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.actionCard):hover"))
                .custom("border-color", "rgba(66, 183, 245, 0.58) !important")
                .custom("box-shadow", "0 16px 34px rgba(0, 0, 0, 0.34), 0 0 28px rgba(26, 143, 210, 0.09)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.actionIcon)"))
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.04), 0 8px 20px rgba(0, 0, 0, 0.24)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.list)"))
                .custom("display", "grid")
                .custom("gap", "9px")
                .custom("max-height", "min(520px, calc(100vh - 300px))")
                .custom("overflow-y", "auto")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.listRow)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "16px")
                .custom("padding", "13px 14px")
                .custom("border", "1px solid rgba(84, 151, 194, 0.26)")
                .custom("border-left", "3px solid var(--tc-money-blue)")
                .custom("border-radius", "12px")
                .custom("background", "linear-gradient(135deg, rgba(7, 31, 50, 0.82), rgba(7, 22, 37, 0.68))")
                .custom("cursor", "pointer")
                .custom("transition", "transform 150ms ease, border-color 150ms ease, background 150ms ease")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.listRow):hover"))
                .custom("transform", "translateY(-1px)")
                .custom("border-color", "rgba(79, 188, 247, 0.58)")
                .custom("background", "linear-gradient(135deg, rgba(10, 45, 70, 0.9), rgba(8, 28, 46, 0.76))")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.listAmount)"))
                .custom("color", "#dff4ff")
                .custom("font-size", "18px")
                .custom("font-weight", "700")
                .custom("text-align", "right")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.badge)"))
                .custom("display", "inline-flex")
                .custom("width", "fit-content")
                .custom("padding", "4px 8px")
                .custom("border", "1px solid rgba(66, 183, 245, 0.3)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(18, 78, 118, 0.45)")
                .custom("color", "#9cd9ff")
                .custom("font-size", "11px")
                .custom("font-weight", "700")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.formCard)"))
                .custom("border-left", "3px solid rgba(66, 183, 245, 0.72) !important")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.formGrid)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                .custom("gap", "12px")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.userSummary)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "48px minmax(0, 1fr) auto")
                .custom("align-items", "center")
                .custom("gap", "12px")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.hint)"))
                .custom("padding", "10px 12px")
                .custom("border", "1px solid rgba(255, 159, 10, 0.25)")
                .custom("border-radius", "10px")
                .custom("background", "rgba(112, 65, 8, 0.18)")
                .custom("color", "#f7c978")
                .custom("font-size", "13px")
                .custom("line-height", "1.4")

            CSSRule(Pointer("\(root) input, \(root) select, \(root) textarea"))
                .custom("min-height", "42px")
                .custom("background", "rgba(1, 13, 25, 0.76) !important")
                .custom("border-color", "rgba(93, 151, 190, 0.34) !important")
                .custom("color", "#f3f8fc !important")
                .custom("box-shadow", "inset 0 1px 2px rgba(0, 0, 0, 0.28)")

            CSSRule(Pointer("\(root) input:focus, \(root) select:focus, \(root) textarea:focus"))
                .custom("border-color", "var(--tc-money-blue) !important")
                .custom("outline", "2px solid rgba(66, 183, 245, 0.16) !important")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.primaryButton)"))
                .custom("background", "linear-gradient(135deg, #159bd7, #315ed8) !important")
                .custom("color", "#ffffff !important")
                .custom("box-shadow", "0 10px 24px rgba(20, 103, 196, 0.24)")

            CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.emptyState)"))
                .custom("min-height", "180px")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")

            MediaRule(.screen.maxWidth(760.px)) {
                CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.formGrid), \(root) .\(TCMoneyManagerClass.listRow), \(root) .\(TCMoneyManagerClass.userSummary)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.listAmount)"))
                    .custom("text-align", "left")
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) .\(TCMoneyManagerClass.actionCard), \(root) .\(TCMoneyManagerClass.listRow)"))
                    .custom("transition", "none")
            }
        }
    }
}
