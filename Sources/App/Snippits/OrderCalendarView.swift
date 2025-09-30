//
//  OrderCalendarView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class OrderCalendarView: Div {
    
    override class var name: String { "div" }
    
    @State var currentMonthName = "Mes Actual"
    
    @State var realMonth = getDate(nil).month
    @State var realYear = getDate(nil).year
    @State var realDay = getDate(nil).day
    
    @State var selectedDay = 0
    @State var selectedMonth = 0
    @State var selectedYear = 0
    
    @State var day = 0
    var month = 0
    @State var year = 0
    @State var yearName = ""
    
    @State var highPriority = false
    
    lazy var calendarTable = Table ()
        .width(100.percent)
        .height(100.percent)
    
    @State var selectedDateStamp: String
    
    var __workMap: [
        Int: [
            Int: [
                Int: [CustOrderLoadFolios]
            ]
        ]
    ] = [:]
    
    private var callback: ((_ selectedDateStamp: String,_ uts: Double,_ highPriority: Bool) -> ())
    
    init(
        selectedDateStamp: String,
        __workMap: [Int: [Int: [Int: [CustOrderLoadFolios]]]],
        callback: @escaping ((_ selectedDateStamp: String,_ uts: Double,_ highPriority: Bool) -> ())
    ) {
        self.selectedDateStamp = selectedDateStamp
        self.__workMap = __workMap
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .src("/skyline/media/arrow_left2.png")
                .width(35.px)
                .left(35.px)
                .float(.left)
                .cursor(.pointer)
                .onClick {
                    self.changeCalandarMonth(add: false)
                }
            
            Strong(self.$currentMonthName)
                .fontSize(34.px)
                .marginRight(24.px)
                .cursor(.pointer)
                .color(.white)
            
            Strong(self.$yearName)
                .fontSize(34.px)
                .cursor(.pointer)
                .color(.white)
            Img()
                .src("/skyline/media/arrow_right2.png")
                .width(35.px)
                .left(35.px)
                .float(.right)
                .cursor(.pointer)
                .onClick {
                    self.changeCalandarMonth(add: true)
                }
            
        }
        .align(.center)
        
        Div().class(.clear)
        
        Div{
            self.calendarTable
        }
        .margin(all: 7.px)
        .marginBottom(3.px)
        .custom("height", "calc(100% - 50px)")
        
    }
    
    override func buildUI() {
        
        height(100.percent)
        
        self.$year.listen {
            self.yearName = String($0)
        }
        
        self.day = Date().day
        self.month = Date().month
        self.year = Date().year
        
        if !selectedDateStamp.isEmpty {
            
            let parts = selectedDateStamp.explode("/")
            
            guard parts.count == 3 else {
                return
            }
            guard let _day = Int(parts[2]) else {
                return
            }
            guard let _month = Int(parts[1]) else {
                return
            }
            guard let _year = Int(parts[0]) else {
                return
            }
            
            self.day = _day
            self.month = _month
            self.year = _year
            
        }
        
        drawCalendar()
    }
    
    func changeCalandarMonth(add: Bool) {
        
        var comps = DateComponents()
        comps.day = 1
        comps.month = self.month
        comps.year = self.year
        
        // Valdidate we cant go lower than present month
        if !add {
            
            var thisMonthCalendarComponants = DateComponents()
            thisMonthCalendarComponants.day = 1
            thisMonthCalendarComponants.month = Date().month
            thisMonthCalendarComponants.year = Date().year
            
            /// this is the ral life calander date  i cant go befor this date
            guard let thisMonthCalendar = Calendar.current.date(from: thisMonthCalendarComponants) else {
                return
            }
            
            if comps.month == 0 {
                comps.month = 11
                comps.year = (comps.year! - 1)
            }
            else{
                comps.month = (comps.month! - 1)
            }
            
            guard let summondCalendar = Calendar.current.date(from: comps) else {
                return
            }
            
            if summondCalendar < thisMonthCalendar {
                print("🔴 Can NOT go back")
                return
            }
            
            print("🟢 Can  go back")
            
        }
        else{
            
            if comps.month == 11 {
                comps.month = 0
                comps.year = (comps.year! + 1)
            }
            else{
                comps.month = (comps.month! + 1)
            }
        }
        
        self.month = comps.month!
        self.year = comps.year!
        
        drawCalendar()
        
    }
    
    func drawCalendar() {
        
        var hasFirstWeek = false
        
        calendarTable.innerHTML = ""
        calendarTable.appendChild(
            Tr {
                Td("Domingo").width(14.29.percent)
                Td("Lunes").width(14.29.percent)
                Td("Martes").width(14.29.percent)
                Td("Miercoles").width(14.29.percent)
                Td("Jueves").width(14.29.percent)
                Td("Viernes").width(14.29.percent)
                Td("Sabado").width(14.29.percent)
            }
                .color(.white)
                .height(18.px)
        )
        
        var comps = DateComponents()
        comps.day = 1
        comps.month = self.month
        comps.year = self.year
        
        guard let date = Calendar.current.date(from: comps) else {
            return
        }
        
        currentMonthName = date.monthName
        
        let dateComponents = DateComponents(year: self.year, month: self.month)
        let calendar = Calendar.current
        let _date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: _date)!
        let numberOfDay = range.count
        
        var tr = Tr()
        
        var _cc = 0
        
        print("order \(custOperationWorkProfile.order)")
        print("rent \(custOperationWorkProfile.rent)")
        print("sale \(custOperationWorkProfile.sale)")
        print("admin \(custOperationWorkProfile.admin)")
        
        var rowCount = 1
        
        for cday in 1...numberOfDay {
            
            if !hasFirstWeek {
                
                while _cc < date.weekday {
                    tr.appendChild(
                        Td("")
                            .backgroundColor(.transparent)
                    )
                    _cc += 1
                }
                
                hasFirstWeek = true
                
            }
            
            let _weekName = getDateName(day: cday)
            
            var orderColor: Color = .init(r: 191, g: 255, b: 0, a: 0.3)
            var rentColor: Color = .init(r: 191, g: 255, b: 0, a: 0.3)
            
            if let workload = workMap[self.year]?[self.month]?[cday] {
                
                if workload.order > 50 && workload.order < 81 {
                    orderColor = .init(r: 255, g: 191, b: 0, a: 0.3)
                }
                else if workload.order > 80 && workload.order < 99 {
                    orderColor = .init(r: 255, g: 125, b: 0, a: 0.3)
                }
                else if workload.order > 98 {
                    orderColor = .init(r: 255, g: 0, b: 0, a: 0.3)
                }
                
                if workload.rent > 50 && workload.rent < 81 {
                    rentColor = .init(r: 255, g: 191, b: 0, a: 0.3)
                }
                else if workload.rent > 80 && workload.rent < 99 {
                    rentColor = .init(r: 255, g: 125, b: 0, a: 0.3)
                }
                else if workload.rent > 98 {
                    rentColor = .init(r: 255, g: 0, b: 0, a: 0.3)
                }
            }
            
            var orderPayloadView = Div()
                .float(.left)
                .position(.absolute)
            var rentalPayloadView = Div()
                .float(.left)
                .position(.absolute)
            
            if let __workLoad = __workMap[self.year]?[self.month]?[cday] {
                
                var orderCount = 0
                var rentalCount = 0
                
                __workLoad.forEach { order in
                    if order.type == .folio {
                        orderCount += 1
                    }
                    else if order.type == .rental {
                        rentalCount += 1
                    }
                }
                
                if orderCount >  0 {
                    orderPayloadView = Div {
                        Div(orderCount.toString)
                            .color(.black)
                            .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.7))
                            .margin(all: 3.px)
                            .borderRadius(all: 7.px)
                            .width(30.px)
                            .align(.center)
                            .float(.right)
                            .fontSize(8.px)
                        
                        Span("ORD")
                            .float(.right)
                            .color(.white)
                            .margin(all: 3.px)
                            .fontSize(8.px)
                        
                        Div().class(.clear)
                        
                    }
                    .margin(all: 3.px)
                    .padding(all: 3.px)
                    .borderRadius(all: 7.px)
                    .backgroundColor(orderColor)
                    .float(.left)
                    .position(.absolute)
                    .custom("width", "calc(100% - 12px)")
                    
                }
                
                if rentalCount > 0 {
                    rentalPayloadView = Div {
                        Div(rentalCount.toString)
                            .color(.black)
                            .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.7))
                            .margin(all: 3.px)
                            .borderRadius(all: 7.px)
                            .width(30.px)
                            .align(.center)
                            .float(.right)
                        
                        Span("RNT")
                            .float(.right)
                            .color(.white)
                            .margin(all: 3.px)
                        
                        Div().class(.clear)
                        
                    }
                    .margin(all: 3.px)
                    .padding(all: 3.px)
                    .borderRadius(all: 7.px)
                    .backgroundColor(rentColor)
                    .float(.left)
                    .position(.absolute)
                    .custom("width", "calc(100% - 12px)")
                    
                }
                
            }
            
            var opacity: Double = 1.0
            
            var cursor: CursorType = .pointer
            
            if (self.year == self.realYear) && (self.month == self.realMonth) {
                if cday < self.realDay {
                    /// Td must be transperant since the day cannot be selected
                    opacity = 0.3
                    /// Td not inderactive
                    cursor = .default
                }
            }
            
            tr.appendChild(
                Td{
                    
                    Div()
                        .class(.clear)
                        .height(12.px)
                    
                    orderPayloadView
                    
                    rentalPayloadView
                    
                    Strong(String(cday))
                        .position(.absolute)
                        .top(3.px)
                        .left(3.px)
                        .width(24.px)
                        .padding(all: 3.px)
                        .borderRadius(all: 7.px)
                        .textAlign(.center)
                        .color(.white) 
                        .backgroundColor(.rgba(0, 0, 0, 0.7))
            
                    
                }
                    .align(.left)
                    .verticalAlign(.top)
                    .cursor(cursor)
                    .backgroundColor(.transparentBlack)
//                    .backgroundColor(self.$selectedDateStamp.map {
//                        if "\(self.year)/\(self.month)/\(cday)" != $0 {
//                            return .white
//                        }
//                        else{
//                            return .lightBlueText
//                        }
//                    })
                    .color(self.$selectedDateStamp.map{
                        if "\(self.year)/\(self.month)/\(cday)" != $0 {
                            return .lightBlueText
                        }
                        else{
                            return .white
                        }
                    })
                    .onClick {
                        
                    }
                    .position(.relative)
                    .opacity(opacity)
            )
            
            if _weekName == "Sabado" {
                calendarTable.appendChild(tr)
                
                if numberOfDay > cday {
                    tr = Tr()
                    rowCount += 1
                }
            }
            
            if cday == numberOfDay {
                
                var _tdc = 0
                
                WeekDays.allCases.forEach { _day in
                    switch _day{
                    case .domingo:
                        if _weekName == _day.description {
                            _tdc = 6
                        }
                    case .lunes:
                        if _weekName == _day.description {
                            _tdc = 5
                        }
                    case .martes:
                        if _weekName == _day.description {
                            _tdc = 4
                        }
                    case .miercoles:
                        if _weekName == _day.description {
                            _tdc = 3
                        }
                    case .jueves:
                        if _weekName == _day.description {
                            _tdc = 2
                        }
                    case .viernes:
                        if _weekName == _day.description {
                            _tdc = 1
                        }
                    case .sabado:
                        break
                    }
                }
                
                while _tdc > 0 {
                    tr.appendChild(
                        Td()
                            .backgroundColor(.transparent)
                    )
                    _tdc -= 1
                }
                
                calendarTable.appendChild(tr)
            }
            
        }
        
        print("⭐️ rowCount \(rowCount.toString)")
        print("⭐️ rowCount \(rowCount.toString)")
        print("⭐️ rowCount \(rowCount.toString)")
        
    }
    
    func getDateName(day: Int) -> String {
        
        var comps = DateComponents()
        comps.day = day
        comps.month = self.month
        comps.year = self.year
        
        guard let date = Calendar.current.date(from: comps) else {
            return "N/A"
        }
        
        return date.weekdayName
    }
    
}

