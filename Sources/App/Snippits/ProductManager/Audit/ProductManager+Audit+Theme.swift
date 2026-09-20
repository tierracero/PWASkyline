//
//  ProductManager+Audit+Theme.swift
//

import Foundation
import Web

extension ProductManagerView.AuditView {
    enum CrystalTheme {
        private static var isInstalled = false

        static func apply(to view: BaseElement) {
            TCCrystalSurfaceTheme.apply(to: view, variant: .productAudit)
            install()
        }

        private static func install() {
            guard !isInstalled else { return }
            isInstalled = true

            let root = ".\(TCCrystalSurfaceClass.root).\(TCCrystalSurfaceClass.productAudit)"

            WebApp.current.addStylesheet {
                CSSRule(Pointer(root))
                    .custom("box-sizing", "border-box")
                    .custom("color", "var(--tc-crystal-ink)")

                CSSRule(Pointer("\(root).\(TCCrystalSurfaceClass.auditWorkspace)"))
                    .custom("background", "rgba(1, 8, 17, 0.18) !important")
                    .custom("backdrop-filter", "blur(10px) saturate(122%)")
                    .custom("-webkit-backdrop-filter", "blur(10px) saturate(122%)")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditPopup)"))
                    .custom("background", "transparent !important")
                    .custom("backdrop-filter", "none !important")
                    .custom("-webkit-backdrop-filter", "none !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditPopup) > .\(TCTripBetaClass.popUpPanel)"))
                    .custom("background", "linear-gradient(145deg, rgba(9, 35, 57, 0.83), rgba(3, 16, 30, 0.72)) !important")
                    .custom("border", "1px solid var(--tc-crystal-border) !important")
                    .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.56), inset 0 1px 0 rgba(255, 255, 255, 0.055)")
                    .custom("backdrop-filter", "blur(24px) saturate(132%)")
                    .custom("-webkit-backdrop-filter", "blur(24px) saturate(132%)")
                    .custom("overflow", "hidden")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditHeader)"))
                    .custom("display", "grid")
                    .custom("grid-template-columns", "minmax(0, 1fr) auto auto")
                    .custom("align-items", "center")
                    .custom("gap", "10px")
                    .custom("min-height", "52px")
                    .custom("padding", "7px 10px 7px 16px")
                    .custom("box-sizing", "border-box")
                    .custom("background", "#252c3b !important")
                    .custom("border", "1px solid rgba(102, 184, 236, 0.24) !important")
                    .custom("border-left", "4px solid #49b9f5 !important")
                    .custom("border-radius", "12px !important")
                    .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.06), 0 8px 20px rgba(0, 0, 0, 0.2)")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditHeader) > *"))
                    .custom("float", "none !important")
                    .custom("margin-top", "0 !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditHeader) .\(TCTripBetaClass.titleText)"))
                    .custom("color", "#49b9f5 !important")
                    .custom("font-size", "23px !important")
                    .custom("font-weight", "800")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditBody)"))
                    .custom("grid-template-rows", "auto minmax(0, 1fr)")
                    .custom("align-content", "stretch")
                    .custom("overflow", "hidden")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditNavigation)"))
                    .custom("align-content", "stretch")
                    .custom("min-height", "0")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditTabs)"))
                    .custom("display", "flex")
                    .custom("align-items", "center")
                    .custom("gap", "7px")
                    .custom("flex-wrap", "wrap")
                    .custom("flex", "1 1 auto")
                    .custom("padding", "8px 10px")
                    .custom("background", "#252c3b")
                    .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                    .custom("border-radius", "11px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditTab)"))
                    .custom("margin", "0 !important")
                    .custom("padding", "7px 10px")
                    .custom("border", "1px solid rgba(102, 184, 236, 0.12)")
                    .custom("border-radius", "9px")
                    .custom("background", "rgba(3, 18, 32, 0.34)")
                    .custom("font-size", "16px !important")
                    .custom("font-weight", "700")
                    .custom("transition", "background 160ms ease, border-color 160ms ease, transform 160ms ease")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditTab):hover"))
                    .custom("background", "rgba(18, 66, 99, 0.58)")
                    .custom("border-color", "rgba(73, 185, 245, 0.48)")
                    .custom("transform", "translateY(-1px)")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditAction)"))
                    .custom("margin-left", "auto !important")
                    .custom("border", "2px solid #245a7c !important")
                    .custom("border-radius", "11px !important")
                    .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.95), rgba(5, 27, 48, 0.95)) !important")
                    .custom("color", "#edf7ff !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditPanel)"))
                    .custom("height", "100% !important")
                    .custom("margin", "0 !important")
                    .custom("min-width", "0")
                    .custom("min-height", "0")
                    .custom("box-sizing", "border-box")
                    .custom("background", "rgba(2, 15, 28, 0.22) !important")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.16)")
                    .custom("border-radius", "14px !important")
                    .custom("overflow", "hidden")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditPanelHost)"))
                    .custom("height", "100%")
                    .custom("min-height", "0")
                    .custom("align-content", "stretch")
                    .custom("overflow", "hidden")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditPanelHost) > .\(TCCrystalSurfaceClass.auditPanel)[hidden]"))
                    .custom("display", "none !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditToolbar)"))
                    .custom("display", "flex")
                    .custom("align-items", "flex-end")
                    .custom("gap", "9px 12px")
                    .custom("flex-wrap", "wrap")
                    .custom("height", "auto !important")
                    .custom("min-height", "82px")
                    .custom("padding", "10px 12px")
                    .custom("box-sizing", "border-box")
                    .custom("background", "rgba(5, 24, 42, 0.62) !important")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.2)")
                    .custom("border-radius", "12px !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditToolbar) > div"))
                    .custom("float", "none !important")
                    .custom("margin", "0 !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditToolbar) label"))
                    .custom("display", "block")
                    .custom("margin-bottom", "4px")
                    .custom("color", "#a8bed0 !important")
                    .custom("font-size", "11px !important")
                    .custom("font-weight", "700")
                    .custom("letter-spacing", "0.45px")
                    .custom("text-transform", "uppercase")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditToolbar) input, \(root) .\(TCCrystalSurfaceClass.auditToolbar) select"))
                    .custom("max-width", "100%")
                    .custom("border", "2px solid #245a7c !important")
                    .custom("border-radius", "9px !important")
                    .custom("background", "rgba(2, 16, 29, 0.88) !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportActions)"))
                    .custom("align-items", "center")
                    .custom("gap", "7px")
                    .custom("position", "absolute")
                    .custom("top", "30px")
                    .custom("right", "24px")
                    .custom("z-index", "5")
                    .custom("margin", "0 !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportAction)"))
                    .custom("display", "inline-flex")
                    .custom("align-items", "center")
                    .custom("justify-content", "center")
                    .custom("gap", "7px")
                    .custom("min-height", "40px")
                    .custom("padding", "7px 11px")
                    .custom("box-sizing", "border-box")
                    .custom("border", "1px solid #245a7c")
                    .custom("border-radius", "9px")
                    .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.96), rgba(5, 27, 48, 0.96))")
                    .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.06), 0 6px 14px rgba(0, 0, 0, 0.24)")
                    .custom("color", "#edf7ff")
                    .custom("font-size", "14px")
                    .custom("font-weight", "800")
                    .custom("cursor", "pointer")
                    .custom("user-select", "none")
                    .custom("transition", "transform 150ms ease, border-color 150ms ease, box-shadow 150ms ease")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportAction):hover"))
                    .custom("transform", "translateY(-1px)")
                    .custom("border-color", "#49b9f5")
                    .custom("box-shadow", "0 0 18px rgba(73, 185, 245, 0.22), 0 8px 16px rgba(0, 0, 0, 0.28)")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportAction)[data-report-action='play']"))
                    .custom("border-color", "rgba(255, 159, 10, 0.78)")
                    .custom("box-shadow", "0 0 16px rgba(255, 159, 10, 0.14), inset 0 1px 0 rgba(255, 255, 255, 0.06)")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportAction) img"))
                    .custom("width", "20px")
                    .custom("height", "20px")
                    .custom("object-fit", "contain")

                CSSRule(Pointer("\(root) .tc-audit-report-action-symbol"))
                    .custom("display", "inline-grid")
                    .custom("place-items", "center")
                    .custom("width", "22px")
                    .custom("height", "22px")
                    .custom("border-radius", "999px")
                    .custom("background", "#ff9f0a")
                    .custom("color", "#07111d")
                    .custom("font-size", "11px")
                    .custom("padding-left", "1px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditResults)"))
                    .custom("position", "relative")
                    .custom("min-height", "0")
                    .custom("overflow", "auto !important")
                    .custom("box-sizing", "border-box")
                    .custom("padding", "12px")
                    .custom("background", "radial-gradient(circle at 6% 2%, rgba(43, 153, 221, 0.12), transparent 28%), rgba(2, 14, 25, 0.36) !important")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.14)")
                    .custom("border-radius", "12px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportHeader)"))
                    .custom("padding", "14px 250px 14px 16px !important")
                    .custom("margin-bottom", "12px !important")
                    .custom("background", "#252c3b !important")
                    .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                    .custom("border-left", "4px solid #49b9f5")
                    .custom("border-radius", "11px !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditSection)"))
                    .custom("margin", "12px 0")
                    .custom("padding", "12px")
                    .custom("background", "rgba(5, 24, 42, 0.52)")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.16)")
                    .custom("border-radius", "12px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditMetricGrid)"))
                    .custom("display", "grid !important")
                    .custom("grid-template-columns", "repeat(auto-fit, minmax(150px, 1fr))")
                    .custom("gap", "9px !important")
                    .custom("margin-bottom", "12px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditMetric)"))
                    .custom("box-sizing", "border-box")
                    .custom("min-width", "0")
                    .custom("padding", "11px 12px !important")
                    .custom("background", "linear-gradient(145deg, rgba(8, 35, 57, 0.82), rgba(3, 18, 32, 0.72)) !important")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.2)")
                    .custom("border-top", "2px solid rgba(73, 185, 245, 0.48)")
                    .custom("border-radius", "11px !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChart)"))
                    .custom("margin", "12px 0")
                    .custom("padding", "13px 14px")
                    .custom("background", "rgba(4, 21, 37, 0.66)")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.18)")
                    .custom("border-radius", "12px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartRow)"))
                    .custom("display", "grid")
                    .custom("grid-template-columns", "minmax(120px, 220px) minmax(120px, 1fr) minmax(72px, auto)")
                    .custom("gap", "10px")
                    .custom("align-items", "center")
                    .custom("margin", "8px 0")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartLabel)"))
                    .custom("overflow", "hidden")
                    .custom("text-overflow", "ellipsis")
                    .custom("white-space", "nowrap")
                    .custom("color", "#d8e9f6")
                    .custom("font-size", "12px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartTrack)"))
                    .custom("height", "10px")
                    .custom("overflow", "hidden")
                    .custom("background", "rgba(1, 10, 18, 0.72)")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.16)")
                    .custom("border-radius", "999px")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartBar)"))
                    .custom("height", "100%")
                    .custom("min-width", "3px")
                    .custom("background", "linear-gradient(90deg, #245a7c, #49b9f5)")
                    .custom("border-radius", "999px")
                    .custom("box-shadow", "0 0 16px rgba(73, 185, 245, 0.18)")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartValue)"))
                    .custom("color", "#edf7ff")
                    .custom("font-size", "12px")
                    .custom("font-weight", "800")
                    .custom("text-align", "right")

                CSSRule(Pointer("\(root) table"))
                    .custom("border-collapse", "separate")
                    .custom("border-spacing", "0")
                    .custom("background", "rgba(2, 15, 28, 0.42)")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.14)")
                    .custom("border-radius", "10px")

                CSSRule(Pointer("\(root) table thead, \(root) table tfoot"))
                    .custom("background", "#252c3b !important")
                    .custom("color", "#edf7ff !important")

                CSSRule(Pointer(
                    "\(root) .\(TCCrystalSurfaceClass.auditResults) table thead"
                ))
                    .custom("position", "sticky")
                    .custom("top", "0")
                    .custom("z-index", "4")
                    .custom("background", "#252c3b !important")
                    .custom("box-shadow", "0 2px 0 rgba(255, 159, 10, 0.72), 0 8px 16px rgba(0, 0, 0, 0.28)")

                CSSRule(Pointer(
                    "\(root) .\(TCCrystalSurfaceClass.auditResults) table thead th, " +
                    "\(root) .\(TCCrystalSurfaceClass.auditResults) table thead td"
                ))
                    .custom("position", "sticky")
                    .custom("top", "0")
                    .custom("z-index", "4")
                    .custom("background", "#252c3b !important")
                    .custom("background-clip", "padding-box")
                    .custom("box-shadow", "inset 0 -2px 0 rgba(255, 159, 10, 0.72)")

                CSSRule(Pointer(
                    "\(root) .\(TCCrystalSurfaceClass.auditResults) table tfoot"
                ))
                    .custom("position", "sticky")
                    .custom("bottom", "0")
                    .custom("z-index", "4")
                    .custom("background", "#252c3b !important")
                    .custom("color", "#f2c94c !important")
                    .custom("font-weight", "800")
                    .custom("box-shadow", "0 -2px 0 rgba(255, 159, 10, 0.72), 0 -8px 16px rgba(0, 0, 0, 0.28)")

                CSSRule(Pointer(
                    "\(root) .\(TCCrystalSurfaceClass.auditResults) table tfoot th, " +
                    "\(root) .\(TCCrystalSurfaceClass.auditResults) table tfoot td"
                ))
                    .custom("position", "sticky")
                    .custom("bottom", "0")
                    .custom("z-index", "4")
                    .custom("background", "#252c3b !important")
                    .custom("background-clip", "padding-box")
                    .custom("box-shadow", "inset 0 2px 0 rgba(255, 159, 10, 0.72)")

                CSSRule(Pointer("\(root) table td"))
                    .custom("padding", "8px 9px")
                    .custom("border-bottom", "1px solid rgba(96, 164, 207, 0.11)")
                    .custom("vertical-align", "middle")

                CSSRule(Pointer("\(root) table tbody tr:nth-child(even)"))
                    .custom("background", "rgba(16, 47, 70, 0.16) !important")

                CSSRule(Pointer("\(root) table tbody tr:hover"))
                    .custom("background", "rgba(35, 98, 134, 0.26) !important")

                CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditModalPanel)"))
                    .custom("box-sizing", "border-box")
                    .custom("background", "linear-gradient(145deg, rgba(9, 35, 57, 0.94), rgba(3, 16, 30, 0.9)) !important")
                    .custom("border", "1px solid var(--tc-crystal-border) !important")
                    .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.62), inset 0 1px 0 rgba(255, 255, 255, 0.055)")
                    .custom("backdrop-filter", "blur(24px) saturate(132%)")
                    .custom("-webkit-backdrop-filter", "blur(24px) saturate(132%)")

                CSSRule(Pointer("\(root).\(TCCrystalSurfaceClass.auditProductRow)"))
                    .custom("box-sizing", "border-box")
                    .custom("background", "rgba(6, 27, 46, 0.74) !important")
                    .custom("border", "1px solid rgba(96, 164, 207, 0.18) !important")
                    .custom("border-radius", "10px !important")
                    .custom("color", "#edf7ff !important")

                MediaRule(.screen.maxWidth(900.px)) {
                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditPopup) > .\(TCTripBetaClass.popUpPanel)"))
                        .custom("width", "calc(100vw - 20px) !important")
                        .custom("height", "calc(100vh - 20px) !important")

                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartRow)"))
                        .custom("grid-template-columns", "minmax(92px, 130px) minmax(90px, 1fr) minmax(58px, auto)")
                }

                MediaRule(.screen.maxWidth(620.px)) {
                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditHeaderTitle)"))
                        .custom("font-size", "19px !important")

                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditMetricGrid)"))
                        .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")

                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartRow)"))
                        .custom("grid-template-columns", "1fr")

                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditChartValue)"))
                        .custom("text-align", "left")

                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportActions)"))
                        .custom("position", "relative")
                        .custom("top", "auto")
                        .custom("right", "auto")
                        .custom("justify-content", "flex-end")
                        .custom("margin", "0 0 10px auto !important")

                    CSSRule(Pointer("\(root) .\(TCCrystalSurfaceClass.auditReportHeader)"))
                        .custom("padding", "14px 16px !important")
                }
            }
        }
    }

    static func reportHeader(
        title: String,
        subtitle: String,
        context: String
    ) -> Div {
        Div {
            H1(title)
                .color(.yellowTC)
                .marginTop(0.px)
                .marginBottom(3.px)
            Div(subtitle)
                .color(.gray)
                .fontSize(13.px)
            Div(context)
                .color(.white)
                .fontSize(13.px)
                .marginTop(5.px)
        }
        .class(Class(TCCrystalSurfaceClass.auditReportHeader))
    }

    static func reportMetric(title: String, value: String, detail: String) -> Div {
        Div {
            Div(title)
                .color(.gray)
                .fontSize(11.px)
            Div(value)
                .color(.lightBlueText)
                .fontSize(23.px)
                .fontWeight(.bold)
            Div(detail)
                .color(.white)
                .fontSize(11.px)
        }
        .class(Class(TCCrystalSurfaceClass.auditMetric))
    }

    static func productDescriptionCell(_ description: String) -> Td {
        Td(description)
    }

    static func productManagerHeaderCell() -> Td {
        Td("")
            .width(38.px)
    }

    static func productManagerCell(pocId: UUID?) -> Td {
        Td {
            if let pocId {
                Img()
                    .src("/skyline/media/maximizeWindow.png")
                    .class(.iconWhite)
                    .title("Abrir administrador de producto")
                    .width(18.px)
                    .height(18.px)
                    .cursor(.pointer)
                    .onClick { _, event in
                        event.stopPropagation()
                        self.openProductManager(pocId: pocId)
                    }
            }
        }
        .align(.center)
        .width(38.px)
    }

    private static func openProductManager(pocId: UUID) {
        addToDom(
            ManagePOC(
                leveltype: .all,
                levelid: nil,
                levelName: "",
                pocid: pocId,
                titleText: "",
                quickView: false
            ) { _, _, _, _, _, _, _, _, _ in
            } deleted: {
            }
        )
    }

    static func reportBarChart(
        title: String,
        items: [(label: String, value: Double, displayValue: String)]
    ) -> Div {
        let maximum = max(items.map { max($0.value, 0) }.max() ?? 0, 1)

        var container = Div {
            H3(title)
                .color(.lightBlueText)
                .marginTop(0.px)
                .marginBottom(8.px)
        }
        .class(Class(TCCrystalSurfaceClass.auditChart))

        items.forEach { item in

            let percentage = max(0, min(100, (item.value / maximum) * 100))

            let innerItem = Div {
                Div(item.label)
                    .class(Class(TCCrystalSurfaceClass.auditChartLabel))
                Div {
                    Div()
                        .class(Class(TCCrystalSurfaceClass.auditChartBar))
                        .custom("width", "\(percentage)%")
                }
                .class(Class(TCCrystalSurfaceClass.auditChartTrack))
                Div(item.displayValue)
                    .class(Class(TCCrystalSurfaceClass.auditChartValue))
            }
            .class(Class(TCCrystalSurfaceClass.auditChartRow))

            container.appendChild(innerItem)

        }


        return container
    }
}
