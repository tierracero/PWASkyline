//
//  CustTaskAuthorizationView.swift
//  
//
//  Created by Victor Cantu on 4/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CustTaskAuthorizationView: Div {
    
    override class var name: String { "div" }
    
    var alerts: [CustTaskAuthorizationManagerQuick]
    
    init(
        alerts: [CustTaskAuthorizationManagerQuick]
    ) {
        self.alerts = alerts
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var alertsView = Div()
        .class(Class(TCCustTaskAuthorizationClass.alertList))
        .position(.relative)
        .width(100.percent)
    
    @State var changeSettingViewIsHidden = true
    
    @State var frequencySelectListener = ""
    
    @State var levelSelectListener = ""
    
    lazy var frequencySelect = USelectField(self.$frequencySelectListener)
        .width(100.percent)
        .custom("min-height", "42px")
    
    lazy var levelSelect = USelectField(self.$levelSelectListener)
        .width(100.percent)
        .custom("min-height", "42px")
    
    @DOM override var body: DOM.Content {
        VPopUp(.custome(w: 900, h: 760)) {
            VTitle("Tareas y notificaciones") {
                USmallTitle("\(self.alerts.count) pendientes")
                    .class(Class(TCCustTaskAuthorizationClass.countBadge))

                USmallButton("＋ Nueva tarea")
                    .attribute("aria-label", "Crear una nueva tarea")
                    .onClick {
                        addToDom(RequestTastView(
                            type: nil,
                            relationId: nil,
                            relationFolio: nil,
                            relationName: nil,
                            callback: {}
                        ))
                    }

                USmallButton("⚙ Configurar")
                    .attribute("aria-label", "Configurar alertas")
                    .onClick {
                        self.changeSettingViewIsHidden = false
                    }

                USmallButton("Posponer")
                    .attribute("aria-label", "Posponer tareas y notificaciones")
                    .onClick {
                        self.postponeAlerts()
                    }
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.full) {
                    VBox(.standard) {
                        Div {
                            Div {
                                Img()
                                    .src("/skyline/media/notificationIcon.png")
                                    .width(30.px)
                                    .height(30.px)
                                    .custom("object-fit", "contain")
                            }
                            .class(Class(TCCustTaskAuthorizationClass.heroIcon))

                            Div {
                                USubTitle("Centro de autorizaciones")
                                UMinorTitle("Revise solicitudes, tareas y avisos que requieren su atención.")
                                    .marginTop(4.px)
                                    .custom("line-height", "1.4")
                            }
                            .custom("min-width", "0")
                        }
                        .display(.grid)
                        .custom("grid-template-columns", "52px minmax(0, 1fr)")
                        .custom("align-items", "center")
                        .custom("gap", "12px")
                    }
                    .class(Class(TCCustTaskAuthorizationClass.hero))
                }

                VGrid(.full) {
                    self.alertsView
                        .hidden(self.alerts.isEmpty)

                    VBox(.standard) {
                        Table().noResult(label: "No hay alertas 🔔")
                    }
                    .class(Class(TCCustTaskAuthorizationClass.emptyState))
                    .hidden(!self.alerts.isEmpty)
                }
            }
        }
        .class(Class(TCCustTaskAuthorizationClass.popup))
        .custom("filter","blur(0px) !important")


        VPopUp(.fitContent(w: 560)) {
            VTitle("Configurar alertas") {
                USmallTitle("Preferencias")
            } onClose: {
                self.changeSettingViewIsHidden = true
            }

            VBodyGrid {
                VGrid(.full) {
                    VBox(.raised) {
                        UMinorTitle("Defina cuándo desea recibir avisos y qué nivel requiere su atención.")
                            .custom("line-height", "1.45")
                            .marginBottom(16.px)

                        UField("Frecuencia de notificaciones", required: false) {
                            self.frequencySelect
                        }
                        .marginBottom(14.px)

                        UField("Nivel de notificaciones", required: false) {
                            self.levelSelect
                        }
                    }
                }

                VGrid(.half) {
                    ULargeButton("Cancelar")
                        .width(100.percent)
                        .onClick {
                            self.changeSettingViewIsHidden = true
                        }
                }

                VGrid(.half) {
                    ULargeButton("Guardar")
                        .width(100.percent)
                        .custom("background", "linear-gradient(135deg, #159bd7, #315ed8)")
                        .custom("color", "#ffffff")
                        .onClick {
                            self.saveAlertSettings()
                        }
                }
            }
        }
        .class(Class(TCCustTaskAuthorizationClass.settingsPopup))
        .hidden(self.$changeSettingViewIsHidden)
        
    }
    
    override func buildUI() {
        super.buildUI()

        TCCustTaskAuthorizationTheme.apply(to: self)
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        CustTaskAuthorizationManagerAlertFrequency.allCases.forEach { item in
            
            if custCatchHerk < 4 {
                if item == .deactive {
                    return
                }
            }
            
            self.frequencySelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        CustTaskAuthorizationManagerAlertLevel.allCases.forEach { item in
            
            if custCatchHerk < 4 {
                if item == .medium || item == .high {
                    return
                }
            }
            
            self.levelSelect.appendChild(
                Option(item.optionDescription)
                    .value(item.rawValue)
            )
        }
        
        frequencySelectListener = alertManagerConfiguration.frequency.rawValue
        
        levelSelectListener = alertManagerConfiguration.level.rawValue
        
        var auths: [CustTaskAuthorizationManagerQuick] = []
        
        var product: [CustTaskAuthorizationManagerQuick] = []
        
        var purchase: [CustTaskAuthorizationManagerQuick] = []
        
        var fiscal: [CustTaskAuthorizationManagerQuick] = []
        
        var orderCharge: [CustTaskAuthorizationManagerQuick] = []
        
        var orderPayment: [CustTaskAuthorizationManagerQuick] = []
        
        var sale: [CustTaskAuthorizationManagerQuick] = []
        
        var budget: [CustTaskAuthorizationManagerQuick] = []
        
        var personalLone: [CustTaskAuthorizationManagerQuick] = []
        
        var moneyTransfer: [CustTaskAuthorizationManagerQuick] = []
        
        var tasks: [CustTaskAuthorizationManagerQuick] = []
        
        alerts.forEach { alert in
            switch alert.alertType{
            case .product:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    product.append(alert)
                }
            case .purchase:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    purchase.append(alert)
                }
            case .fiscal:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    fiscal.append(alert)
                }
            case .order:
                tasks.append(alert)
            case .orderCharge:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    orderCharge.append(alert)
                }
            case .orderPayment:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    orderPayment.append(alert)
                }
            case .sale:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    sale.append(alert)
                }
            case .budget:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    budget.append(alert)
                }
            case .personalLone:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    personalLone.append(alert)
                }
            case .moneyTransfer:
                if alert.actionType == .auth {
                    auths.append(alert)
                }
                else {
                    moneyTransfer.append(alert)
                }
            case .changePrice:
                auths.append(alert)
            case .task:
                tasks.append(alert)
            }
        }
        
        if !auths.isEmpty {
            
            alertsView.appendChild(
                H1("Autorizaciones Pendientes")
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            auths.forEach { task in
                addTask(task)
            }
            
        }
        
        if !product.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.product.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            product.forEach { task in
                addTask(task)
            }
            
        }
        
        if !purchase.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.purchase.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            purchase.forEach { task in
                addTask(task)
            }
            
        }
    
        if !fiscal.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.fiscal.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            fiscal.forEach { task in
                addTask(task)
            }
            
        }
    
        if !orderCharge.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.orderCharge.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            orderCharge.forEach { task in
                addTask(task)
            }
            
        }
    
        if !orderPayment.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.orderPayment.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            orderPayment.forEach { task in
                addTask(task)
            }
            
        }
    
        if !sale.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.sale.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            sale.forEach { task in
                addTask(task)
            }
            
        }
    
        if !budget.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.budget.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            budget.forEach { task in
                addTask(task)
            }
            
        }
    
        if !personalLone.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.personalLone.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            personalLone.forEach { task in
                addTask(task)
            }
            
        }
    
        if !moneyTransfer.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.moneyTransfer.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            moneyTransfer.forEach { task in
                addTask(task)
            }
        }
        
        if !tasks.isEmpty {
            
            alertsView.appendChild(
                H1(CustTaskAuthorizationManagerAlertType.task.sectionName)
                    .marginTop(12.px)
                    .color(.yellowTC)
            )
            
            tasks.forEach { task in
                addTask(task)
            }
        }
        
        
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        alertManagerConfiguration.executedAt = getNow()
        
        API.custAPIV1.notificationsViewed { resp in
            
            guard let resp else {
                showError(.comunicationError, "No se pudo actulaizar, sistema de altertas (ultima vista), contacte a Soporte TC")
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, "No se pudo actulaizar, sistema de altertas (ultima vista), contacte a Soporte TC")
                return
            }
        }
        
    }

    private func postponeAlerts() {
        Dispatch.asyncAfter(1800) {
            API.custAPIV1.notifications() { resp in
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard let data = resp.data else {
                    showError(.generalError, .unexpenctedMissingPayload)
                    return
                }

                let levels: [CustTaskAuthorizationManagerAlertLevel]

                switch alertManagerConfiguration.level {
                case .low:
                    levels = [.low, .medium, .high]
                case .medium:
                    levels = [.medium, .high]
                case .high:
                    levels = [.high]
                }

                let alerts = data.filter { levels.contains($0.alertLevel) }

                guard !alerts.isEmpty else {
                    return
                }

                addToDom(CustTaskAuthorizationView(alerts: alerts))
            }
        }

        remove()
    }

    private func saveAlertSettings() {
        guard let frequency = CustTaskAuthorizationManagerAlertFrequency(
            rawValue: frequencySelectListener
        ) else {
            showError(.generalError, "")
            return
        }

        guard let level = CustTaskAuthorizationManagerAlertLevel(
            rawValue: levelSelectListener
        ) else {
            showError(.generalError, "")
            return
        }

        loadingView(show: true)

        API.custAPIV1.notificationsSaveSettings(
            frequency: frequency,
            level: level
        ) { resp in
            loadingView(show: false)

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            alertManagerConfiguration.frequency = frequency
            alertManagerConfiguration.level = level
        }
    }
    
    func addTask(_ task: CustTaskAuthorizationManagerQuick){
        
        alertsView.appendChild(CustTaskAuthorizationRow(task: task){

            API.custAPIV1.notifications { _ in }
            
            if task.alertType == .budget || task.alertType == .order {
                self.remove()
            }
            
        })
        
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $changeSettingViewIsHidden.removeAllListeners()
        $frequencySelectListener.removeAllListeners()
        $levelSelectListener.removeAllListeners()
    }
}

private enum TCCustTaskAuthorizationClass {
    static let root = "tc-task-authorization-theme"
    static let popup = "tc-task-authorization-popup"
    static let settingsPopup = "tc-task-authorization-settings-popup"
    static let hero = "tc-task-authorization-hero"
    static let heroIcon = "tc-task-authorization-hero-icon"
    static let countBadge = "tc-task-authorization-count"
    static let alertList = "tc-task-authorization-list"
    static let emptyState = "tc-task-authorization-empty"
}

private enum TCCustTaskAuthorizationTheme {
    private static var isInstalled = false

    static func apply(to view: Div) {
        install()
        view.class(Class(TCCustTaskAuthorizationClass.root))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }

        isInstalled = true
        let root = ".\(TCCustTaskAuthorizationClass.root)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("--tc-task-glass", "rgba(5, 24, 40, 0.76)")
                .custom("--tc-task-glass-raised", "rgba(8, 34, 55, 0.82)")
                .custom("--tc-task-border", "rgba(76, 169, 225, 0.32)")
                .custom("--tc-task-blue", "#42b7f5")
                .custom("--tc-task-muted", "#a9bed0")

            // `addToDom` already provides the full-screen translucent backdrop.
            // Keep this popup layer clear so the dashboard is not dimmed twice.
            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.popup)"))
                .custom("background", "transparent !important")
                .custom("backdrop-filter", "none !important")
                .custom("-webkit-backdrop-filter", "none !important")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.popUpPanel)"))
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 54, 0.84), rgba(4, 16, 29, 0.72)) !important")
                .custom("border", "1px solid var(--tc-task-border) !important")
                .custom("box-shadow", "0 28px 80px rgba(0, 0, 0, 0.58), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(24px) saturate(135%)")
                .custom("-webkit-backdrop-filter", "blur(24px) saturate(135%)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.title)"))
                .custom("background", "rgba(3, 17, 30, 0.68) !important")
                .custom("border-bottom", "1px solid rgba(76, 169, 225, 0.2)")
                .custom("backdrop-filter", "blur(14px)")
                .custom("-webkit-backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.bodyGrid)"))
                .custom("background", "radial-gradient(circle at 12% 8%, rgba(30, 132, 196, 0.12), transparent 34%), transparent")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCTripBetaClass.box)"))
                .custom("background", "var(--tc-task-glass) !important")
                .custom("border-color", "rgba(92, 153, 194, 0.24) !important")
                .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.035), 0 12px 28px rgba(0, 0, 0, 0.2)")
                .custom("backdrop-filter", "blur(14px)")
                .custom("-webkit-backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.hero)"))
                .custom("border-left", "3px solid var(--tc-task-blue) !important")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.heroIcon)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "52px")
                .custom("height", "52px")
                .custom("border", "1px solid rgba(66, 183, 245, 0.34)")
                .custom("border-radius", "14px")
                .custom("background", "rgba(10, 55, 87, 0.58)")
                .custom("box-shadow", "0 0 24px rgba(26, 143, 210, 0.14)")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.countBadge)"))
                .custom("padding", "6px 10px")
                .custom("border", "1px solid rgba(66, 183, 245, 0.3)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(18, 78, 118, 0.45)")
                .custom("color", "#9cd9ff !important")
                .custom("white-space", "nowrap")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.alertList)"))
                .custom("display", "grid")
                .custom("gap", "10px")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.alertList) > h1"))
                .custom("margin", "14px 2px 0 !important")
                .custom("font-size", "18px !important")
                .custom("font-weight", "700")
                .custom("letter-spacing", "0.01em")
                .custom("color", "var(--tc-task-blue) !important")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.alertList) > .uibtnLarge"))
                .custom("display", "flow-root")
                .custom("width", "100% !important")
                .custom("margin", "0 !important")
                .custom("padding", "14px !important")
                .custom("box-sizing", "border-box")
                .custom("background", "linear-gradient(135deg, rgba(7, 31, 50, 0.78), rgba(7, 22, 37, 0.62)) !important")
                .custom("border", "1px solid rgba(84, 151, 194, 0.28) !important")
                .custom("border-left", "3px solid var(--tc-task-blue) !important")
                .custom("border-radius", "14px !important")
                .custom("box-shadow", "0 10px 26px rgba(0, 0, 0, 0.2) !important")
                .custom("backdrop-filter", "blur(12px)")
                .custom("-webkit-backdrop-filter", "blur(12px)")
                .custom("transition", "border-color 160ms ease, background 160ms ease, transform 160ms ease")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.alertList) > .uibtnLarge:hover"))
                .custom("background", "linear-gradient(135deg, rgba(10, 45, 70, 0.88), rgba(8, 28, 46, 0.72)) !important")
                .custom("border-color", "rgba(79, 188, 247, 0.58) !important")
                .custom("transform", "translateY(-1px)")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.alertList) .uibtnLargeOrange"))
                .custom("border", "1px solid rgba(66, 183, 245, 0.26) !important")
                .custom("background", "rgba(8, 43, 68, 0.76) !important")
                .custom("color", "#d8efff !important")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.emptyState)"))
                .custom("min-height", "190px")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.settingsPopup)"))
                .zIndex(999999999)

            CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.settingsPopup)[hidden]"))
                .custom("display", "none !important")

            MediaRule(.screen.maxWidth(760.px)) {
                CSSRule(Pointer("\(root) .\(TCTripBetaClass.titleText)"))
                    .custom("font-size", "18px")

                CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.hero)"))
                    .custom("padding", "12px !important")
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) .\(TCCustTaskAuthorizationClass.alertList) > .uibtnLarge"))
                    .custom("transition", "none")
            }
        }
    }
}
