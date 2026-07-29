//
//  TCCrystalSurfaceTheme.swift
//

import Foundation
import Web

enum TCCrystalSurfaceVariant {
    case addCharge
    case addPayment
    case analytics
    case customerData
    case customerCreation
    case customerLookup
    case customerSearch
    case highPriorityNote
    case historyTripProcessing
    case trip
    case taskRequest

    fileprivate var className: String {
        switch self {
        case .addCharge:
            return TCCrystalSurfaceClass.addCharge
        case .addPayment:
            return TCCrystalSurfaceClass.addPayment
        case .analytics:
            return TCCrystalSurfaceClass.analyticsPanel
        case .customerData:
            return TCCrystalSurfaceClass.customerData
        case .customerCreation:
            return TCCrystalSurfaceClass.customerCreation
        case .customerLookup:
            return TCCrystalSurfaceClass.customerLookup
        case .customerSearch:
            return TCCrystalSurfaceClass.customerSearch
        case .highPriorityNote:
            return TCCrystalSurfaceClass.highPriorityNote
        case .historyTripProcessing:
            return TCCrystalSurfaceClass.historyTripProcessing
        case .trip:
            return TCCrystalSurfaceClass.trip
        case .taskRequest:
            return TCCrystalSurfaceClass.taskPanel
        }
    }
}

enum TCCrystalSurfaceClass {
    static let root = "tc-crystal-surface"
    static let addCharge = "tc-crystal-add-charge"
    static let addPayment = "tc-crystal-add-payment"
    static let paymentPanel = "tc-crystal-payment-panel"
    static let paymentHeader = "tc-crystal-payment-header"
    static let paymentTitle = "tc-crystal-payment-title"
    static let paymentClose = "tc-crystal-payment-close"
    static let paymentMethodRow = "tc-crystal-payment-method-row"
    static let paymentDetailSection = "tc-crystal-payment-detail-section"
    static let paymentDetailTitle = "tc-crystal-payment-detail-title"
    static let paymentSummary = "tc-crystal-payment-summary"
    static let paymentSummaryRow = "tc-crystal-payment-summary-row"
    static let paymentSummaryLabel = "tc-crystal-payment-summary-label"
    static let paymentSummaryValue = "tc-crystal-payment-summary-value"
    static let paymentChangeRow = "tc-crystal-payment-change-row"
    static let paymentToggle = "tc-crystal-payment-toggle"
    static let paymentDateRow = "tc-crystal-payment-date-row"
    static let paymentActions = "tc-crystal-payment-actions"
    static let paymentPrimaryAction = "tc-crystal-payment-primary-action"
    static let paymentSecondaryAction = "tc-crystal-payment-secondary-action"
    static let paymentBankResults = "tc-crystal-payment-bank-results"
    static let analyticsPanel = "tc-crystal-analytics-panel"
    static let customerData = "tc-crystal-customer-data"
    static let customerDataPanel = "tc-crystal-customer-data-panel"
    static let customerCreation = "tc-crystal-customer-creation"
    static let customerLookup = "tc-crystal-customer-lookup"
    static let customerSearch = "tc-crystal-customer-search"
    static let customerLookupPanel = "tc-crystal-customer-lookup-panel"
    static let customerLookupBody = "tc-crystal-customer-lookup-body"
    static let customerLookupToolbar = "tc-crystal-customer-lookup-toolbar"
    static let customerLookupInput = "tc-crystal-customer-lookup-input"
    static let customerLookupSearch = "tc-crystal-customer-lookup-search"
    static let customerLookupCreate = "tc-crystal-customer-lookup-create"
    static let customerLookupResults = "tc-crystal-customer-lookup-results"
    static let customerLookupEmpty = "tc-crystal-customer-lookup-empty"
    static let customerLookupList = "tc-crystal-customer-lookup-list"
    static let customerLookupItem = "tc-crystal-customer-lookup-item"
    static let customerLookupBusiness = "tc-crystal-customer-lookup-business"
    static let customerLookupName = "tc-crystal-customer-lookup-name"
    static let customerLookupMeta = "tc-crystal-customer-lookup-meta"
    static let customerLookupBadge = "tc-crystal-customer-lookup-badge"
    static let customerLookupReward = "tc-crystal-customer-lookup-reward"
    static let highPriorityNote = "tc-crystal-high-priority-note"
    static let highPriorityPanel = "tc-crystal-high-priority-panel"
    static let highPriorityHeader = "tc-crystal-high-priority-header"
    static let highPriorityTitle = "tc-crystal-high-priority-title"
    static let highPriorityClose = "tc-crystal-high-priority-close"
    static let highPriorityMeta = "tc-crystal-high-priority-meta"
    static let highPriorityBody = "tc-crystal-high-priority-body"
    static let highPriorityActions = "tc-crystal-high-priority-actions"
    static let highPriorityLower = "tc-crystal-high-priority-lower"
    static let highPriorityConfirm = "tc-crystal-high-priority-confirm"
    static let historyTripProcessing = "tc-crystal-history-trip-processing"
    static let historyTripProcessingPanel = "tc-crystal-history-trip-processing-panel"
    static let historyTripProcessingHeader = "tc-crystal-history-trip-processing-header"
    static let historyTripProcessingBody = "tc-crystal-history-trip-processing-body"
    static let goodButton = "tc-good-button"
    static let trip = "tc-crystal-trip"
    static let tripPicker = "tc-crystal-trip-picker"
    static let tripPickerPanel = "tc-crystal-trip-picker-panel"
    static let tripPickerHeader = "tc-crystal-trip-picker-header"
    static let tripPickerTitle = "tc-crystal-trip-picker-title"
    static let tripPickerActions = "tc-crystal-trip-picker-actions"
    static let tripPickerCreate = "tc-crystal-trip-picker-create"
    static let tripPickerClose = "tc-crystal-trip-picker-close"
    static let tripPickerBody = "tc-crystal-trip-picker-body"
    static let tripPickerList = "tc-crystal-trip-picker-list"
    static let tripPickerItem = "tc-crystal-trip-picker-item"
    static let tripPickerItemTitle = "tc-crystal-trip-picker-item-title"
    static let tripPickerItemSubtitle = "tc-crystal-trip-picker-item-subtitle"
    static let tripPickerEmpty = "tc-crystal-trip-picker-empty"
    static let tripPickerEmptyIcon = "tc-crystal-trip-picker-empty-icon"
    static let tripPickerEmptyTitle = "tc-crystal-trip-picker-empty-title"
    static let taskPanel = "tc-crystal-task-panel"
}

enum TCCrystalSurfaceTheme {
    private static var isInstalled = false

    static func apply(to view: BaseElement, variant: TCCrystalSurfaceVariant) {
        install()
        view.class(Class(TCCrystalSurfaceClass.root))
        view.class(Class(variant.className))
    }

    static func applyModalHost(to view: BaseElement) {
        view.removeClass(.transparantBlackBackGround)
        view.backgroundColor(.init(r: 1, g: 8, b: 17, a: 0.18))
        view.custom("backdrop-filter", "blur(8px) saturate(120%)")
        view.custom("-webkit-backdrop-filter", "blur(8px) saturate(120%)")
    }

    private static func install() {
        guard !isInstalled else {
            return
        }

        isInstalled = true

        let root = ".\(TCCrystalSurfaceClass.root)"
        let analyticsPanel = "\(root) .\(TCCrystalSurfaceClass.analyticsPanel)"
        let customerData = "\(root) .\(TCCrystalSurfaceClass.customerData)"
        let customerDataPanel = "\(customerData) .\(TCCrystalSurfaceClass.customerDataPanel)"
        let customerSearchRoot = "\(root).\(TCCrystalSurfaceClass.customerSearch)"
        let customerLookupRoot = "\(root).\(TCCrystalSurfaceClass.customerLookup)"
        let goodButton = "\(customerSearchRoot) .\(TCCrystalSurfaceClass.goodButton)"
        let highPriorityRoot = "\(root).\(TCCrystalSurfaceClass.highPriorityNote)"
        let historyTripProcessingRoot = "\(root).\(TCCrystalSurfaceClass.historyTripProcessing)"
        let tripRoot = "\(root).\(TCCrystalSurfaceClass.trip)"
        let tripPicker = "\(tripRoot).\(TCCrystalSurfaceClass.tripPicker)"
        let taskPanel = "\(root) .\(TCCrystalSurfaceClass.taskPanel)"
        let crystalModalHost = ".transparantBlackBackGround:has(> .\(TCCrystalSurfaceClass.root))"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("--tc-crystal-surface", "rgba(6, 24, 42, 0.76)")
                .custom("--tc-crystal-raised", "rgba(10, 39, 63, 0.84)")
                .custom("--tc-crystal-border", "rgba(102, 184, 236, 0.28)")
                .custom("--tc-crystal-blue", "#49b9f5")
                .custom("--tc-crystal-ink", "#edf7ff")
                .custom("--tc-crystal-muted", "#a8bed0")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.popUp)"))
                .custom("background", "rgba(1, 8, 17, 0.18) !important")
                .custom("backdrop-filter", "blur(12px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(12px) saturate(120%)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.popUpPanel)"))
                .custom("background", "linear-gradient(145deg, rgba(12, 45, 72, 0.6), rgba(4, 17, 31, 0.3)) !important")
                .custom("border", "1px solid var(--tc-crystal-border) !important")
                .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.62), inset 0 1px 0 rgba(255, 255, 255, 0.06)")
                .custom("backdrop-filter", "blur(24px) saturate(135%)")
                .custom("-webkit-backdrop-filter", "blur(24px) saturate(135%)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.title)"))
                .custom("background", "rgba(3, 18, 32, 0.7) !important")
                .custom("border-bottom", "1px solid rgba(92, 177, 229, 0.2)")
                .custom("backdrop-filter", "blur(14px)")
                .custom("-webkit-backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.bodyGrid)"))
                .custom("background", "radial-gradient(circle at 10% 6%, rgba(43, 153, 221, 0.15), transparent 34%), radial-gradient(circle at 90% 95%, rgba(73, 185, 245, 0.07), transparent 28%)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.box)"))
                .custom("background", "var(--tc-crystal-surface) !important")
                .custom("border-color", "rgba(96, 164, 207, 0.24) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.04), 0 12px 28px rgba(0, 0, 0, 0.22)")
                .custom("backdrop-filter", "blur(14px)")
                .custom("-webkit-backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) input, \(root) select, \(root) textarea"))
                .custom("background", "rgba(2, 16, 29, 0.76) !important")
                .custom("border-color", "rgba(106, 178, 221, 0.3) !important")
                .custom("color", "var(--tc-crystal-ink) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.025)")

            CSSRule(Pointer("\(root) input:focus, \(root) select:focus, \(root) textarea:focus"))
                .custom("border-color", "rgba(73, 185, 245, 0.72) !important")
                .custom("box-shadow", "0 0 0 3px rgba(73, 185, 245, 0.13) !important")

            CSSRule(Pointer("\(root) .uibtn, \(root) .uibtnLarge, \(root) .uibtnLargeOrange"))
                .custom("border", "1px solid rgba(94, 173, 220, 0.3) !important")
                .custom("background", "linear-gradient(135deg, rgba(11, 53, 83, 0.78), rgba(5, 27, 46, 0.72)) !important")
                .custom("color", "var(--tc-crystal-ink) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.045), 0 10px 24px rgba(0, 0, 0, 0.2)")
                .custom("transition", "transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease")

            CSSRule(Pointer("\(root) .uibtn:hover, \(root) .uibtnLarge:hover, \(root) .uibtnLargeOrange:hover"))
                .custom("border-color", "rgba(87, 194, 247, 0.64) !important")
                .custom("box-shadow", "0 14px 30px rgba(0, 0, 0, 0.3), 0 0 24px rgba(29, 155, 222, 0.1)")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer(goodButton))
                .custom("min-height", "42px")
                .custom("padding", "9px 18px")
                .custom("border", "2px solid #245a7c !important")
                .custom("border-radius", "13px !important")
                .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.95), rgba(5, 27, 48, 0.95)) !important")
                .custom("color", "#edf7ff !important")
                .custom("font-size", "16px")
                .custom("font-weight", "700")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.08), 0 10px 24px rgba(0, 0, 0, 0.24)")
                .custom("transition", "transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease")

            CSSRule(Pointer("\(goodButton):hover"))
                .custom("border-color", "#49b9f5 !important")
                .custom("box-shadow", "0 12px 30px rgba(0, 0, 0, 0.32), 0 0 18px rgba(73, 185, 245, 0.16)")
                .custom("transform", "translateY(-1px)")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(customerLookupRoot) .\(TCTripBetaClass.popUpPanel)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("gap", "12px")
                .custom("padding", "12px")
                .custom("background", "rgba(7, 26, 44, 0.62) !important")
                .custom("border", "1px solid rgba(102, 184, 236, 0.28) !important")
                .custom("border-radius", "20px !important")
                .custom("box-shadow", "0 28px 80px rgba(0, 0, 0, 0.54), inset 0 1px 0 rgba(255, 255, 255, 0.055)")
                .custom("backdrop-filter", "blur(22px) saturate(132%)")
                .custom("-webkit-backdrop-filter", "blur(22px) saturate(132%)")
                .overflow(.hidden)

            CSSRule(Pointer("\(customerLookupRoot) .\(TCTripBetaClass.title)"))
                .custom("min-height", "58px")
                .custom("padding", "8px 10px 8px 18px")
                .custom("background", "#252c3b !important")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "4px solid #49b9f5")
                .custom("border-radius", "12px")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.045), 0 8px 20px rgba(0, 0, 0, 0.18)")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCTripBetaClass.titleText)"))
                .custom("color", "#58c7ff !important")
                .custom("font-size", "21px")
                .custom("letter-spacing", "0.01em")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCTripBetaClass.bodyGrid)"))
                .custom("height", "auto !important")
                .custom("min-height", "0")
                .custom("padding", "0 !important")
                .custom("background", "transparent !important")
                .overflow(.hidden)

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupBody)"))
                .custom("grid-column", "1 / -1")
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("gap", "12px")
                .custom("width", "100%")
                .custom("height", "100%")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupToolbar)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "minmax(0, 1fr) auto auto")
                .custom("gap", "10px")
                .custom("align-items", "center")
                .custom("padding", "12px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(9, 31, 50, 0.68)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "3px solid #49b9f5")
                .custom("border-radius", "12px")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.035)")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupInput)"))
                .custom("width", "100% !important")
                .custom("height", "44px !important")
                .custom("margin", "0 !important")
                .custom("padding", "9px 12px !important")
                .custom("box-sizing", "border-box")
                .custom("float", "none !important")
                .custom("border", "1px solid #245a7c !important")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(3, 21, 38, 0.9) !important")
                .custom("color", "#edf7ff !important")
                .custom("font-size", "16px !important")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupSearch), \(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupCreate)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "8px")
                .custom("min-width", "112px")
                .custom("height", "44px")
                .custom("margin", "0 !important")
                .custom("padding", "0 16px")
                .custom("box-sizing", "border-box")
                .custom("float", "none !important")
                .custom("border-radius", "9px !important")
                .custom("font-size", "15px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupSearch)"))
                .custom("border", "1px solid rgba(73, 185, 245, 0.7) !important")
                .custom("background", "linear-gradient(145deg, rgba(17, 111, 159, 0.96), rgba(7, 57, 91, 0.96)) !important")
                .custom("color", "#f4fbff !important")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupCreate)"))
                .custom("border", "1px solid rgba(102, 184, 236, 0.3) !important")
                .custom("background", "#252c3b !important")
                .custom("color", "#dcecf8 !important")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupSearch) img, \(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupCreate) img"))
                .custom("width", "18px !important")
                .custom("height", "18px !important")
                .custom("margin", "0 !important")
                .custom("object-fit", "contain")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupResults)"))
                .custom("position", "relative")
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(6, 22, 37, 0.58)")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2)")
                .custom("border-radius", "13px")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.03)")
                .overflow(.hidden)

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupEmpty), \(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupList)"))
                .custom("width", "100% !important")
                .custom("height", "100% !important")
                .custom("margin", "0 !important")
                .custom("box-sizing", "border-box")
                .custom("border", "0 !important")
                .custom("border-radius", "0 !important")
                .custom("background", "transparent !important")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupEmpty)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("padding", "28px")
                .custom("color", "#a8bed0 !important")
                .custom("font-size", "16px")
                .custom("text-align", "center")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupList)"))
                .custom("display", "grid")
                .custom("align-content", "start")
                .custom("gap", "9px")
                .custom("padding", "10px")
                .overflow(.auto)

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupItem)"))
                .custom("display", "grid")
                .custom("gap", "5px")
                .custom("width", "100% !important")
                .custom("margin", "0 !important")
                .custom("padding", "13px 15px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(91, 153, 190, 0.28) !important")
                .custom("border-left", "4px solid #49b9f5 !important")
                .custom("border-radius", "10px !important")
                .custom("background", "#171e29 !important")
                .custom("box-shadow", "0 8px 20px rgba(0, 0, 0, 0.2)")
                .custom("transition", "transform 150ms ease, border-color 150ms ease, background 150ms ease")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupItem):hover"))
                .custom("transform", "translateY(-1px)")
                .custom("border-color", "rgba(73, 185, 245, 0.62) !important")
                .custom("background", "#1b2532 !important")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupBusiness)"))
                .custom("color", "#8fb4ca !important")
                .custom("font-size", "13px !important")
                .custom("font-weight", "600")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupName)"))
                .custom("color", "#f0f7fc !important")
                .custom("font-size", "18px !important")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupMeta)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "10px")
                .custom("min-width", "0")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupBadge)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("gap", "6px")
                .custom("width", "fit-content")
                .custom("padding", "4px 8px")
                .custom("border", "1px solid rgba(245, 160, 64, 0.32)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(83, 48, 18, 0.32)")
                .custom("color", "#f5a040 !important")
                .custom("font-size", "12px")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupReward)"))
                .custom("display", "inline-flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "32px")
                .custom("height", "32px")
                .custom("border", "1px solid rgba(245, 193, 64, 0.34)")
                .custom("border-radius", "50%")
                .custom("background", "rgba(83, 61, 18, 0.32)")

            CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupReward) img"))
                .custom("width", "17px !important")
                .custom("height", "17px !important")

            MediaRule(.screen.maxWidth(720.px)) {
                CSSRule(Pointer("\(customerLookupRoot) .\(TCTripBetaClass.popUpPanel)"))
                    .custom("gap", "10px")
                    .custom("padding", "10px")
                    .custom("border-radius", "15px !important")

                CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupToolbar)"))
                    .custom("grid-template-columns", "1fr 1fr")

                CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupInput)"))
                    .custom("grid-column", "1 / -1")

                CSSRule(Pointer("\(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupSearch), \(customerLookupRoot) .\(TCCrystalSurfaceClass.customerLookupCreate)"))
                    .custom("width", "100%")
                    .custom("min-width", "0")
            }
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer(customerDataPanel))
                .custom("background", "linear-gradient(145deg, rgba(12, 45, 72, 0.94), rgba(4, 17, 31, 0.9)) !important")
                .custom("border", "1px solid var(--tc-crystal-border)")
                .custom("box-shadow", "0 24px 70px rgba(0, 0, 0, 0.5), inset 0 1px 0 rgba(255, 255, 255, 0.06)")
                .custom("color", "var(--tc-crystal-ink) !important")
                .custom("backdrop-filter", "blur(18px) saturate(130%)")
                .custom("-webkit-backdrop-filter", "blur(18px) saturate(130%)")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer(highPriorityRoot))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("padding", "24px")
                .custom("background", "rgba(1, 8, 17, 0.16)")
                .custom("backdrop-filter", "blur(10px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(10px) saturate(120%)")
                .custom("z-index", "999999992")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityPanel)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("width", "min(680px, 100%)")
                .custom("max-height", "min(560px, calc(100vh - 48px))")
                .custom("box-sizing", "border-box")
                .custom("overflow", "hidden")
                .custom("background", "linear-gradient(145deg, rgba(12, 45, 72, 0.94), rgba(4, 17, 31, 0.9)) !important")
                .custom("border", "1px solid var(--tc-crystal-border) !important")
                .custom("border-radius", "16px !important")
                .custom("box-shadow", "0 28px 80px rgba(0, 0, 0, 0.58), inset 0 1px 0 rgba(255, 255, 255, 0.06)")
                .custom("color", "var(--tc-crystal-ink) !important")
                .custom("backdrop-filter", "blur(20px) saturate(135%)")
                .custom("-webkit-backdrop-filter", "blur(20px) saturate(135%)")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityHeader)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("min-height", "58px")
                .custom("padding", "0 16px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(3, 18, 32, 0.72)")
                .custom("border-bottom", "1px solid rgba(92, 177, 229, 0.2)")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityTitle)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "9px")
                .custom("flex", "1 1 auto")
                .custom("min-width", "0")
                .custom("margin", "0 !important")
                .custom("color", "var(--tc-crystal-ink) !important")
                .custom("font-size", "21px !important")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityTitle) img"))
                .custom("width", "24px")
                .custom("height", "24px")
                .custom("flex", "0 0 auto")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityClose)"))
                .custom("float", "none !important")
                .custom("width", "34px !important")
                .custom("height", "34px !important")
                .custom("margin", "0 !important")
                .custom("padding", "8px")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(255, 123, 79, 0.3) !important")
                .custom("border-radius", "9px !important")
                .custom("background", "rgba(75, 29, 25, 0.38) !important")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityMeta)"))
                .custom("display", "flex")
                .custom("justify-content", "space-between")
                .custom("gap", "12px")
                .custom("padding", "13px 16px 0")
                .custom("box-sizing", "border-box")
                .custom("color", "var(--tc-crystal-muted) !important")
                .custom("font-size", "13px !important")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityBody)"))
                .custom("margin", "0 !important")
                .custom("padding", "18px 16px 24px")
                .custom("color", "var(--tc-crystal-ink) !important")
                .custom("font-size", "24px !important")
                .custom("font-weight", "600")
                .custom("line-height", "1.3")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityActions)"))
                .custom("display", "flex")
                .custom("justify-content", "flex-end")
                .custom("align-items", "center")
                .custom("gap", "10px")
                .custom("padding", "14px 16px 16px")
                .custom("border-top", "1px solid rgba(92, 177, 229, 0.2)")
                .custom("background", "rgba(3, 18, 32, 0.46)")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityLower)"))
                //.custom("min-height", "42px")
                .custom("padding", "9px 16px")
                .custom("border-radius", "10px !important")
                .custom("background", "linear-gradient(135deg, rgba(93, 67, 21, 0.9), rgba(65, 38, 11, 0.86)) !important")
                .custom("color", "#ffe9ad !important")

            CSSRule(Pointer("\(highPriorityRoot) .\(TCCrystalSurfaceClass.highPriorityConfirm)"))
                //.custom("min-height", "42px")
                .custom("padding", "9px 20px")
                .custom("border-radius", "10px !important")
                .custom("background", "linear-gradient(135deg, rgba(17, 106, 151, 0.96), rgba(7, 54, 88, 0.96)) !important")
                .custom("color", "#f4fbff !important")

            CSSRule(Pointer(historyTripProcessingRoot))
                .custom("color", "var(--tc-crystal-ink) !important")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingPanel)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("gap", "12px")
                .custom("box-sizing", "border-box")
                .custom("padding", "14px")
                .custom("background", "rgba(7, 26, 44, 0.58) !important")
                .custom("border", "1px solid var(--tc-crystal-border) !important")
                .custom("border-radius", "20px !important")
                .custom("box-shadow", "0 24px 70px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(18px) saturate(125%)")
                .custom("-webkit-backdrop-filter", "blur(18px) saturate(125%)")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingHeader)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .custom("min-height", "56px")
                .custom("padding", "10px 14px")
                .custom("box-sizing", "border-box")
                .custom("background", "rgba(4, 25, 43, 0.96) !important")
                .custom("border", "1px solid rgba(102, 184, 236, 0.24) !important")
                .custom("border-radius", "12px !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.06), 0 8px 20px rgba(0, 0, 0, 0.2)")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingHeader) > *"))
                .custom("float", "none !important")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingHeader) > .clear"))
                .custom("display", "none !important")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingHeader) h2"))
                .custom("margin", "0 !important")
                .custom("font-size", "18px !important")
                .custom("line-height", "1.2")
                .custom("color", "#edf7ff !important")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingHeader) h2:first-of-type"))
                .custom("margin-right", "auto !important")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingHeader) > img"))
                .custom("order", "10")
                .custom("margin-left", "12px")

            CSSRule(Pointer("\(historyTripProcessingRoot) .\(TCCrystalSurfaceClass.historyTripProcessingBody)"))
                .custom("min-height", "0")
                .custom("box-sizing", "border-box")
                .custom("margin-top", "0 !important")
                .custom("padding", "12px")
                .custom("background", "rgba(8, 30, 48, 0.5) !important")
                .custom("border", "1px solid rgba(102, 184, 236, 0.2) !important")
                .custom("border-radius", "13px !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.035)")
                .custom("overflow", "hidden")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(tripRoot) .\(TCTripBetaClass.box), \(tripRoot) .\(TCTripBetaClass.boxRaised), \(tripRoot) .\(TCTripBetaClass.boxStandard)"))
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 57, 0.88), rgba(3, 17, 32, 0.86)) !important")
                .custom("border", "1px solid rgba(73, 149, 195, 0.28) !important")
                .custom("border-radius", "14px !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.045), 0 12px 30px rgba(0, 0, 0, 0.24)")

            CSSRule(Pointer("\(tripRoot) .\(TCTripBetaClass.uiFieldLabel)"))
                .custom("color", "#edf7ff !important")
                .custom("font-size", "13px !important")
                .custom("font-weight", "700")
                .custom("line-height", "1.2")

            CSSRule(Pointer("\(tripRoot) .\(TCTripBetaClass.uiControl), \(tripRoot) input, \(tripRoot) select, \(tripRoot) textarea"))
                .custom("height", "30px !important")
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid #245a7c !important")
                .custom("border-radius", "7px !important")
                .custom("background", "rgba(3, 21, 38, 0.9) !important")
                .custom("color", "#edf7ff !important")
                .custom("padding", "5px 8px !important")
                .custom("font-size", "13px !important")

            CSSRule(Pointer("\(tripRoot) input:focus, \(tripRoot) select:focus, \(tripRoot) textarea:focus"))
                .custom("border-color", "#49b9f5 !important")
                .custom("outline", "2px solid rgba(73, 185, 245, 0.16)")

            CSSRule(Pointer("\(tripRoot) .textFiledBlackDark, \(tripRoot) .uibtn, \(tripRoot) .uibtnLarge, \(tripRoot) .uibtnLargeOrange, \(tripRoot) .\(TCTripBetaClass.uiButton)"))
                .custom("border", "1px solid #245a7c !important")
                .custom("border-radius", "9px !important")
                .custom("background", "linear-gradient(145deg, rgba(14, 57, 87, 0.92), rgba(5, 27, 48, 0.92)) !important")
                .custom("color", "#edf7ff !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.05), 0 6px 16px rgba(0, 0, 0, 0.2)")

            CSSRule(Pointer("\(tripRoot) .textFiledBlackDark"))
                .custom("height", "30px !important")
                .custom("box-sizing", "border-box")
                .custom("padding", "5px 8px !important")
                .custom("font-size", "13px !important")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer(tripPicker))
                .position(.fixed)
                .left(0.px)
                .top(0.px)
                .width(100.percent)
                .height(100.percent)
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("box-sizing", "border-box")
                .custom("padding", "24px")
                .custom("background", "rgba(1, 8, 17, 0.46)")
                .custom("backdrop-filter", "blur(10px) saturate(118%)")
                .custom("-webkit-backdrop-filter", "blur(10px) saturate(118%)")
                .zIndex(999999998)

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerPanel)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("width", "min(760px, 100%) !important")
                .custom("max-width", "760px !important")
                .custom("max-height", "calc(100vh - 48px)")
                .custom("background", "radial-gradient(circle at 12% 0%, rgba(73, 185, 245, 0.16), transparent 34%), linear-gradient(145deg, rgba(8, 35, 59, 0.96), rgba(2, 14, 28, 0.94)) !important")
                .custom("border", "1px solid rgba(101, 181, 229, 0.34) !important")
                .custom("border-radius", "20px !important")
                .custom("box-shadow", "0 34px 100px rgba(0, 0, 0, 0.66), 0 0 48px rgba(36, 139, 203, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.07)")
                .custom("backdrop-filter", "blur(28px) saturate(138%)")
                .custom("-webkit-backdrop-filter", "blur(28px) saturate(138%)")
                .overflow(.hidden)

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerHeader)"))
                .custom("grid-template-columns", "minmax(0, 1fr) auto")
                .custom("min-height", "62px")
                .custom("padding", "10px 12px 10px 20px")
                .custom("background", "linear-gradient(90deg, rgba(3, 20, 37, 0.9), rgba(7, 31, 51, 0.72)) !important")
                .custom("border-bottom", "1px solid rgba(105, 175, 218, 0.17)")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerTitle)"))
                .custom("margin", "0 !important")
                .custom("color", "#edf7ff !important")
                .custom("font-size", "22px !important")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerCreate)"))
                .custom("min-height", "36px")
                .custom("padding", "8px 14px")
                .custom("border", "1px solid rgba(74, 190, 240, 0.45) !important")
                .custom("border-radius", "10px !important")
                .custom("background", "linear-gradient(135deg, rgba(17, 106, 151, 0.96), rgba(7, 54, 88, 0.96)) !important")
                .custom("color", "#f4fbff !important")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerClose)"))
                .custom("float", "none !important")
                .custom("width", "36px !important")
                .custom("height", "36px !important")
                .custom("box-sizing", "border-box")
                .custom("margin", "0 !important")
                .custom("padding", "9px")
                .custom("border", "1px solid rgba(255, 123, 79, 0.22)")
                .custom("border-radius", "10px")
                .custom("background", "rgba(75, 29, 25, 0.32)")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerBody)"))
                .custom("min-height", "190px")
                .custom("max-height", "min(58vh, 480px)")
                .custom("padding", "12px")
                .custom("box-sizing", "border-box")
                .overflow(.hidden)

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerList)"))
                .custom("display", "grid")
                .custom("align-content", "start")
                .custom("gap", "9px")
                .custom("width", "100%")
                .custom("height", "100%")
                .custom("box-sizing", "border-box")
                .overflow(.auto)

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerItem)"))
                .custom("display", "grid")
                .custom("gap", "5px")
                .custom("width", "100% !important")
                .custom("padding", "13px 15px !important")
                .custom("background", "linear-gradient(145deg, rgba(9, 39, 64, 0.9), rgba(3, 21, 39, 0.86)) !important")
                .custom("border", "1px solid rgba(85, 165, 213, 0.24) !important")
                .custom("border-left", "3px solid rgba(73, 185, 245, 0.78) !important")
                .custom("border-radius", "12px !important")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerItem):hover"))
                .custom("background", "linear-gradient(145deg, rgba(13, 53, 84, 0.96), rgba(4, 27, 48, 0.92)) !important")
                .custom("border-color", "rgba(93, 194, 241, 0.52) !important")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerItemTitle)"))
                .custom("color", "#f1f8ff !important")
                .custom("font-size", "17px !important")
                .custom("font-weight", "700")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerItemSubtitle)"))
                .custom("color", "#9fb8cb !important")
                .custom("font-size", "13px !important")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerEmpty)"))
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("gap", "13px")
                .custom("min-height", "220px")
                .custom("padding", "28px")
                .custom("border", "1px dashed rgba(101, 181, 229, 0.24)")
                .custom("border-radius", "14px")
                .custom("background", "rgba(3, 20, 37, 0.42)")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerEmptyIcon)"))
                .custom("font-size", "38px")

            CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerEmptyTitle)"))
                .custom("margin", "0")
                .custom("color", "#a8bed0 !important")
                .custom("font-size", "17px")

            MediaRule(.screen.maxWidth(620.px)) {
                CSSRule(Pointer(tripPicker))
                    .custom("padding", "12px")

                CSSRule(Pointer("\(tripPicker) .\(TCCrystalSurfaceClass.tripPickerTitle)"))
                    .custom("font-size", "18px !important")
            }
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer(analyticsPanel))
                .custom("background", "linear-gradient(145deg, rgba(9, 35, 57, 0.86), rgba(3, 16, 30, 0.76)) !important")
                .custom("border", "1px solid var(--tc-crystal-border)")
                .custom("box-shadow", "0 28px 70px rgba(0, 0, 0, 0.48), inset 0 1px 0 rgba(255, 255, 255, 0.045)")
                .custom("backdrop-filter", "blur(22px) saturate(130%)")
                .custom("-webkit-backdrop-filter", "blur(22px) saturate(130%)")

            CSSRule(Pointer("\(analyticsPanel) .oneHalf"))
                .custom("background", "rgba(5, 24, 42, 0.56)")
                .custom("border", "1px solid rgba(96, 164, 207, 0.2)")
                .custom("border-radius", "16px")
                .custom("box-sizing", "border-box")
                .custom("padding", "18px")
                .custom("backdrop-filter", "blur(12px)")
                .custom("-webkit-backdrop-filter", "blur(12px)")

            CSSRule(Pointer("\(analyticsPanel) .roundBlue"))
                .custom("background", "rgba(2, 17, 31, 0.58) !important")
                .custom("border", "1px solid rgba(96, 164, 207, 0.22) !important")
                .custom("border-radius", "13px !important")

            CSSRule(Pointer("\(root) .transparantBlackBackGround"))
                .custom("background", "rgba(1, 8, 17, 0.54) !important")
                .custom("backdrop-filter", "blur(12px) saturate(120%)")
                .custom("-webkit-backdrop-filter", "blur(12px) saturate(120%)")

            CSSRule(Pointer(crystalModalHost))
                .custom("background", "rgba(1, 8, 17, 0.18) !important")
                .custom("backdrop-filter", "blur(8px) saturate(120%) !important")
                .custom("-webkit-backdrop-filter", "blur(8px) saturate(120%) !important")

            CSSRule(Pointer("\(root) .transparantBlackBackGround > div"))
                .custom("background", "linear-gradient(145deg, rgba(12, 45, 72, 0.92), rgba(4, 17, 31, 0.84)) !important")
                .custom("border", "1px solid var(--tc-crystal-border)")
                .custom("box-shadow", "0 28px 70px rgba(0, 0, 0, 0.55), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(22px) saturate(130%)")
                .custom("-webkit-backdrop-filter", "blur(22px) saturate(130%)")

            CSSRule(Pointer(taskPanel))
                .custom("background", "linear-gradient(145deg, rgba(11, 43, 68, 0.9), rgba(3, 16, 30, 0.82)) !important")
                .custom("border", "1px solid var(--tc-crystal-border)")
                .custom("box-shadow", "0 28px 70px rgba(0, 0, 0, 0.55), inset 0 1px 0 rgba(255, 255, 255, 0.055)")
                .custom("backdrop-filter", "blur(22px) saturate(130%)")
                .custom("-webkit-backdrop-filter", "blur(22px) saturate(130%)")
                .custom("box-sizing", "border-box")
                .custom("max-height", "calc(100vh - 36px)")
                .custom("overflow", "auto")

            CSSRule(Pointer("\(taskPanel) h2"))
                .custom("color", "var(--tc-crystal-ink) !important")

            CSSRule(Pointer("\(taskPanel) h3"))
                .custom("color", "var(--tc-crystal-muted) !important")
        }
    }
}
