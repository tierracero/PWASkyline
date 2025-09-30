//
//  SelectCalendarDate.swift
//
//
//  Created by Victor Cantu on 3/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/*
 TODO: load if its sigle porduct, for explame if you rents a party saloon, youonly have  one  saloon.  load the days the saloon is ocupied

 */

class SelectCalendarDate: Div {
    
    override class var name: String { "div" }
    
    /// folio, date, sale, pdv, eSale, rental
    var type: FolioTypes?
    
    @State var selectedDateStamp: String
    
    /// I have no used  for this right now and  i dont know what where my intention.
    /// I will consider moding or deleting
    var currentSelectedDates: [UUID]
    
    private var callback: ((
        _ selectedDateStamp: String,
        _ uts: Double,
        _ highPriority: Bool
    ) -> ())

    init(
        /// folio, date, sale, pdv, eSale, rental
        type: FolioTypes?,
        selectedDateStamp: String,
        currentSelectedDates: [UUID],
        callback: @escaping ((
            _ selectedDateStamp: String,
            _ uts: Double,
            _ highPriority: Bool
        ) -> ())
    ) {
        self.type = type
        self.selectedDateStamp = selectedDateStamp
        self.currentSelectedDates = currentSelectedDates
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
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
    @State var hour = "16:00"
    
    @State var highPriority = false
    
    lazy var calendarTable = Table ()
        .width(100.percent)
        .height(100.percent)
    
    lazy var hourInput = InputText(self.$hour)
        .fontSize(26.px)
        .class(.textFiledLightLarge)
        .width(77.px)
        .onFocus { tf in
            tf.select()
        }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .closeButton(.uiView2)
                .onClick{
                    self.remove()
                }
            
            Div{
            
                Img()
                    .src("images/arrow_left2.png")
                    .width(50.px)
                    .left(50.px)
                    .float(.left)
                    .cursor(.pointer)
                    .onClick {
                        self.changeCalandarMonth(add: false)
                    }
                
                Strong(self.$currentMonthName)
                    .fontSize(38.px)
                    .marginRight(24.px)
                    .cursor(.pointer)
                
                Strong(self.$yearName)
                    .fontSize(38.px)
                    .cursor(.pointer)
                
                Img()
                    .src("images/arrow_right2.png")
                    .width(50.px)
                    .left(50.px)
                    .float(.right)
                    .cursor(.pointer)
                    .onClick {
                        self.changeCalandarMonth(add: true)
                    }
                
            }
            .paddingLeft(36.px)
            .paddingRight(36.px)
            .paddingBottom(7.px)
            .align(.center)
            
            Div().class(.clear)
            
            Div{
                self.calendarTable
            }
            .class(.roundBlue)
            .margin(all: 7.px)
            .marginBottom(3.px)
            .custom("height", "calc(100% - 100px)")
            
            Div {
                
                Span("Hora:")
                    .fontSize(26.px)
                    .paddingRight(7.px)
                
                self.hourInput
                
                Div{
                    InputCheckbox().toggle(self.$highPriority)
                        .marginRight(7.px)
                    
                    Strong("Alta Prioridad")
                        .marginRight(12.px)
                        .color(.red)
                        .fontSize(26.px)
                        .onClick {
                            self.highPriority = !self.highPriority
                        }
                }
                .hidden({ (self.type != .rental) ? true : false }())
                .float(.right)
                
                Div().class(.clear)
            }
            .padding(all: 7.px)
            
            Div().class(.clear)
            
        }
        .padding(all: 12.px)
        .position(.absolute)
        .width(50.percent)
        .left(25.percent)
        .top(20.percent)
        .height(55.percent)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
        
    }
    
    override func buildUI() {
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        super.buildUI()
        zIndex(999999998)
        
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
        
        Dispatch.asyncAfter(0.5) {
            self.hourInput.select()
        }
        
    }
    
    func changeCalandarMonth(add: Bool){
        
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
    
    func drawCalendar(){
        
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
                .height(35.px)
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
        
        print("⭐️ numberOfDay \(numberOfDay)")
        
        var tr = Tr()
        
        var _cc = 0
        
        for cday in 1...numberOfDay {
            
            if !hasFirstWeek {
                
                while _cc < date.weekday {
                    tr.appendChild(
                        Td("")
                            .backgroundColor(.hex(0xf0f0f0))
                    )
                    _cc += 1
                }
                
                hasFirstWeek = true
                
            }
            
            let _weekName = getDateName(day: cday)
            
            var payloadColor: Color = .transparent
            
            if let workload = workMap[self.year]?[self.month]?[cday] {
                
                //print("⭐️  paylod for \(self.year.toString)/\(self.month.toString)/\(cday)  ⭐️")
                
                if let type {
                    
                    switch type {
                        
                    case .folio:
                        
                        // print("workload.order \(workload.order)")
                        
                        if workload.order > 50 && workload.order < 81 {
                            /// Amber
                            payloadColor = .init(r: 255, g: 191, b: 0, a: 0.3)
                        }
                        else if workload.order > 80 && workload.order < 99 {
                            /// Orange
                            payloadColor = .init(r: 255, g: 125, b: 0, a: 0.3)
                        }
                        else if workload.order > 98 {
                            /// Red
                            payloadColor = .init(r: 255, g: 0, b: 0, a: 0.3)
                        }
                    case .date:
                        break
                    case .sale:
                        break
                    case .rental:
                        
                        print("workload.rent \(workload.rent)")
                        
                        if workload.rent > 50 && workload.rent < 81 {
                            /// Amber
                            payloadColor = .init(r: 255, g: 191, b: 0, a: 0.3)
                        }
                        else if workload.rent > 80 && workload.rent < 99 {
                            /// Orange
                            payloadColor = .init(r: 255, g: 125, b: 0, a: 0.3)
                        }
                        else if workload.rent > 98{
                            /// Red
                            payloadColor = .init(r: 255, g: 0, b: 0, a: 0.3)
                        }
                        
                    case .mercadoLibre:
                        break
                    case .claroShop:
                        break
                    case .amazon:
                        break
                    case .ebay:
                        break
                    }
                }
                
            }
            
            var opacity: Double = 1.0
            
            var cursor: CursorType = .pointer
            
            if (self.year == self.realYear) && (self.month == self.realMonth) {
                if cday < self.realDay {
                    /// Worlpayload does not apply sice day has passed
                    payloadColor = .transparent
                    /// Td must be transperant since the day cannot be selected
                    opacity = 0.3
                    /// Td not inderactive
                    cursor = .default
                }
            }
            
            tr.appendChild(
                Td{
                    
                    Div{

                    }
                    .margin(all: 7.px)
                    .custom("width", "calc(100% - 14px)")
                    .custom("height", "calc(100% - 14px)")
                    .backgroundColor(payloadColor)
                    .borderRadius(all: 7.px)
                    
//
                    Strong(String(cday))
                        .position(.absolute)
                        .top(12.px)
                        .left(12.px)
                        .width(24.px)
                        .padding(all: 3.px)
                        .borderRadius(all: 7.px)
                        .backgroundColor(.white)
                        .textAlign(.center)
                        .backgroundColor(.rgba( 255, 255, 255, 0.7))
                    
                }
                    .align(.left)
                    .verticalAlign(.top)
                    .cursor(cursor)
                    .backgroundColor(self.$selectedDateStamp.map {
                        if "\(self.year)/\(self.month)/\(cday)" != $0 {
                            return .white
                        }
                        else{
                            return .lightBlueText
                        }
                    })
                    .color(self.$selectedDateStamp.map{
                        if "\(self.year)/\(self.month)/\(cday)" != $0 {
                            return .lightBlueText
                        }
                        else{
                            return .white
                        }
                    })
                    .onClick {
                        
                        if (self.year == self.realYear) && (self.month == self.realMonth) {
                            if cday < self.realDay {
                                return
                            }
                        }
                        
                        guard self.hour.contains(":") else {
                            showError(.campoRequerido, "Formato de hora erroneo HH:MM ")
                            self.hourInput.select()
                            return
                        }
                        
                        let hourParts = self.hour.explode(":")
                        
                        guard hourParts.count == 2 else{
                            showError(.campoRequerido, "Formato de hora erroneo HH:MM ")
                            self.hourInput.select()
                            return
                        }
                        
                        guard let _hour = Int(hourParts[0]) else {
                            showError(.campoRequerido, "Formato de hora erroneo HH:MM entre 0 - 23")
                            self.hourInput.select()
                            return
                        }
                        
                        guard _hour >= 0 && _hour <= 23 else {
                            showError(.campoRequerido, "Formato de hora erroneo HH:MM entre 0 - 23")
                            self.hourInput.select()
                            return
                        }
                        
                        guard let _min = Int(hourParts[1]) else {
                            showError(.campoRequerido, "Formato de minuto erroneo HH:MM entre 0 - 23")
                            self.hourInput.select()
                            return
                        }
                        
                        guard _min >= 0 && _min <= 59 else {
                            showError(.campoRequerido, "Formato de hora erroneo HH:MM entre 0 - 59")
                            self.hourInput.select()
                            return
                        }
                        
                        self.day = cday
                        
                        let _dateComponents = DateComponents(
                            year: self.year,
                            month: self.month,
                            day: cday,
                            hour: _hour,
                            minute: _min
                        )
                        
                        let _calendar = Calendar.current
                        let _td = _calendar.date(from: _dateComponents)!
                        
                        self.callback(
                            "\(self.year)/\(self.month)/\(cday)",
                            _td.timeIntervalSince1970.value + (60 * 60 * 6),
                            self.highPriority
                        )
                        self.remove()
                        
                    }
                    .position(.relative)
                    .opacity(opacity)
            )
            
            if _weekName == "Sabado" {
                calendarTable.appendChild(tr)
                tr = Tr()
            }
            
            if cday == numberOfDay{
                
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
                            .backgroundColor(.hex(0xf0f0f0))
                    )
                    _tdc -= 1
                }
                
                calendarTable.appendChild(tr)
            }
            
        }
        
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
    
    func drawWeek(){
        
    }
    
}
