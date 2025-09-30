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
        .custom( "height", "calc(100% - 35px)")
        .borderRadius(7.px)
        .position(.relative)
        .overflow(.auto)
    
    @State var changeSettingViewIsHidden = true
    
    @State var frequencySelectListener = ""
    
    @State var levelSelectListener = ""
    
    lazy var frequencySelect = Select(self.$frequencySelectListener)
        .custom("width","calc(100% - 0px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var levelSelect = Select(self.$levelSelectListener)
        .custom("width","calc(100% - 0px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                Div("Posponer")
                    .marginRight(12.px)
                    .class(.uibtn)
                    .float(.right)
                    .onClick {
                        Dispatch.asyncAfter(1800) {
                            API.custAPIV1.notifications() { resp in
                                
                                guard let resp else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }
                                
                                guard let data = resp.data else {
                                    showError( .errorGeneral, .unexpenctedMissingPayload)
                                    return
                                }
                                
                                var levels: [CustTaskAuthorizationManagerAlertLevel]
                                
                                switch alertManagerConfiguration.level {
                                case .low:
                                    levels = [.low,.medium,.high]
                                case .medium:
                                    levels = [.medium,.high]
                                case .high:
                                    levels = [.high]
                                }
                                
                                var alerts: [CustTaskAuthorizationManagerQuick] = []
                                
                                data.forEach { alert in
                                    if levels.contains(alert.alertLevel) {
                                        alerts.append(alert)
                                    }
                                }
                                
                                if alerts.isEmpty {
                                    return
                                }
                                
                                let view = CustTaskAuthorizationView(
                                    alerts: alerts
                                )
                                
                                addToDom(view)
                                
                            }
                        }
                        self.remove()
                    }
                
                Img()
                    .src("/skyline/media/gear2.png")
                    .marginRight(12.px)
                    .cursor(.pointer)
                    .float(.right)
                    .height(28.px)
                    .onClick {
                        self.changeSettingViewIsHidden = false
                    }
                
                Img()
                    .src("/skyline/media/addBlueIcon.png")
                    .marginRight(12.px)
                    .cursor(.pointer)
                    .float(.right)
                    .height(28.px)
                    .onClick {
                        addToDom(RequestTastView(
                            type: nil,
                            relationId: nil,
                            relationFolio: nil,
                            relationName: nil,
                            callback: {
                                
                            }
                        ))
                    }
                
                H2{
                    Img()
                        .src("/skyline/media/notificationIcon.png")
                        .marginRight(7.px)
                        .height(24.px)
                    
                    Span("Tareas y Notificaciones")
                }
                .color(.lightBlueText)
                .height(35.px)
                
            }
            
            self.alertsView
                .hidden({ self.alerts.isEmpty }())
            
            Table().noResult(label: "No hay alertas 🔔")
                .hidden({ !self.alerts.isEmpty }())
            
        }
        .custom("left", "calc(50% - 364px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
        
        Div{
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.changeSettingViewIsHidden = true
                        }
                    
                    H2("Configurar Alertas")
                        .color(.lightBlueText)
                        .height(35.px)
                    
                }
                
                Div().class(.clear).marginBottom(7.px)
                
                Span("Frecuencia de Notificaciones")
                    .color(.white)
                
                Div().class(.clear).marginBottom(7.px)
                
                self.frequencySelect
                
                Div().class(.clear).marginBottom(7.px)
                
                Span("Nivel de Notificaciones")
                    .color(.white)
                
                Div().class(.clear).marginBottom(7.px)
                
                self.levelSelect
                
                Div().class(.clear).marginBottom(7.px)
                
                Div{
                    Div("Guardar")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            
                            guard let frequency = CustTaskAuthorizationManagerAlertFrequency(rawValue: self.frequencySelectListener) else {
                                showError(.errorGeneral, "")
                                return
                            }
                            
                            guard let level = CustTaskAuthorizationManagerAlertLevel(rawValue: self.levelSelectListener) else {
                                showError(.errorGeneral, "")
                                return
                            }
                            
                            loadingView(show: true)
                            
                            API.custAPIV1.notificationsSaveSettings(
                                frequency: frequency,
                                level: level
                            ) { resp in
                            
                                loadingView(show: false)
                                
                                guard let resp else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }
                                
                                guard resp.status == .ok else {
                                    showError(.errorGeneral, resp.msg)
                                    return
                                }
                                
                                alertManagerConfiguration.frequency = frequency
                                
                                alertManagerConfiguration.level = level
                                
                            }
                        }
                }
                .align(.right)
                
            }
            .custom("left", "calc(50% - 212px)")
            .custom("top", "calc(50% - 122px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(400.px)
        }
        .hidden(self.$changeSettingViewIsHidden)
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
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
                showError(.errorDeCommunicacion, "No se pudo actulaizar, sistema de altertas (ultima vista), contacte a Soporte TC")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, "No se pudo actulaizar, sistema de altertas (ultima vista), contacte a Soporte TC")
                return
            }
        }
        
    }
    
    func addTask(_ task: CustTaskAuthorizationManagerQuick){
        
        alertsView.appendChild(CustTaskAuthorizationRow(task: task){
            
            if task.alertType == .budget || task.alertType == .order {
                self.remove()
            }
            
        })
        
    }
}
