//
//  DateTimePicker.swift
//

import Foundation
import Web

/// A TripController beta-themed calendar and optional time picker.
///
/// All input values and the callback value use Unix epoch seconds in the
/// browser's current calendar and time zone.
public final class DateTimePicker: Div {

    public override class var name: String { "div" }

    private let setTime: Bool
    private let from: Int64?
    private let to: Int64?
    private let callback: (_ date: Int64) -> Void

    private var selectedYear = 0
    private var selectedMonth = 0
    private var selectedDay = 0
    private var selectedHour = 0
    private var selectedMinute = 0

    private var displayedYear = 0
    private var displayedMonth = 0

    private lazy var monthTitle = Strong("")
        .fontSize(27.px)
        .custom("color", "var(--tc-beta-orange-soft)")

    private lazy var timeTitle = Strong("")
        .fontSize(27.px)
        .custom("color", "var(--tc-beta-orange-soft)")

    private lazy var calendarGrid = Div()
        .width(100.percent)

    private lazy var hourList = Div()
        .height(290.px)
        .overflow(.auto)
        .width(50.percent)
        .float(.left)

    private lazy var minuteList = Div()
        .height(290.px)
        .overflow(.auto)
        .width(50.percent)
        .float(.left)

    public init(
        date: Int64? = nil,
        setTime: Bool = true,
        from: Int64? = nil,
        to: Int64? = nil,
        callback: @escaping (_ date: Int64) -> Void
    ) {
        self.setTime = setTime

        if let from, let to, from > to {
            self.from = to
            self.to = from
        } else {
            self.from = from
            self.to = to
        }

        self.callback = callback
        super.init()

        loadSelection(from: date ?? defaultTimestamp())
        constrainSelectionToBounds()
        displayedYear = selectedYear
        displayedMonth = selectedMonth
    }

    public required init() {
        fatalError("init() has not been implemented")
    }

    @DOM public override var body: DOM.Content {
        VPopUp(.custome(w: self.setTime ? 900 : 690, h: 640)) {
            VTitle(
                self.setTime ? "Seleccionar fecha y hora" : "Seleccionar fecha",
                icon: "icon_calendar.png"
            ) {
                USmallTitle("Hora local")
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(self.setTime ? .twoThirds : .full) {
                    VBox {
                        Div {
                            self.navigationButton("‹‹") {
                                self.changeDisplayedMonth(by: -12)
                            }
                            self.navigationButton("‹") {
                                self.changeDisplayedMonth(by: -1)
                            }
                            Div { self.monthTitle }
                                .display(.inlineBlock)
                                .minWidth(190.px)
                                .textAlign(.center)
                            self.navigationButton("›") {
                                self.changeDisplayedMonth(by: 1)
                            }
                            self.navigationButton("››") {
                                self.changeDisplayedMonth(by: 12)
                            }
                        }
                        .textAlign(.center)
                        .padding(v: 2.px, h: 0.px)

                        self.calendarGrid
                    }
                    .height(490.px)
                    .overflow(.auto)
                }

                if self.setTime {
                    VGrid(.oneThird) {
                        VBox(.raised) {
                            Div { self.timeTitle }
                                .height(48.px)
                                .lineHeight(48.px)
                                .textAlign(.center)
                                .custom("border-bottom", "1px solid var(--tc-beta-border)")

                            Div {
                                Div("Hora")
                                    .width(50.percent)
                                    .float(.left)
                                    .textAlign(.center)
                                    .custom("color", "var(--tc-beta-muted)")
                                Div("Min")
                                    .width(50.percent)
                                    .float(.left)
                                    .textAlign(.center)
                                    .custom("color", "var(--tc-beta-muted)")
                                Div().class(.clear)
                            }
                            .padding(v: 7.px, h: 0.px)

                            Div {
                                self.hourList
                                self.minuteList
                                Div().class(.clear)
                            }
                        }
                        .height(490.px)
                    }
                }

                VGrid(.half) {
                    ULargeButton("Ahora")
                        .onClick { self.selectNow() }
                }

                VGrid(.half) {
                    ULargeButton("Aceptar")
                        .float(.right)
                        .onClick { self.acceptSelection() }
                }
            }
        }
    }

    public override func buildUI() {
        super.buildUI()

        self.class(Class(TCTripBetaClass.dateTimePicker))

        render()
    }

    private func navigationButton(
        _ title: String,
        action: @escaping () -> Void
    ) -> USmallButton {
        USmallButton(title)
            .fontSize(24.px)
            .lineHeight(34.px)
            .height(36.px)
            .minWidth(38.px)
            .margin(v: 0.px, h: 3.px)
            .onClick {
                action()
            }
    }

    private func render() {
        renderCalendar()

        if setTime {
            renderTimeSelector()
        }
    }

    private func renderCalendar() {
        calendarGrid.innerHTML = ""
        monthTitle.innerText = "\(monthNames[displayedMonth - 1]) \(displayedYear)"

        weekdayNames.forEach { weekday in
            calendarGrid.appendChild(
                Div(weekday)
                    .width(14.285.percent)
                    .height(42.px)
                    .lineHeight(42.px)
                    .float(.left)
                    .textAlign(.center)
                    .fontWeight(.bold)
                    .custom("color", "var(--tc-beta-muted)")
            )
        }

        guard let monthStart = calendar.date(from: DateComponents(
            year: displayedYear,
            month: displayedMonth,
            day: 1
        )) else {
            return
        }

        let weekday = calendar.component(.weekday, from: monthStart)
        let mondayBasedOffset = (weekday + 5) % 7

        guard let gridStart = calendar.date(
            byAdding: .day,
            value: -mondayBasedOffset,
            to: monthStart
        ) else {
            return
        }

        for offset in 0..<42 {
            guard let cellDate = calendar.date(
                byAdding: .day,
                value: offset,
                to: gridStart
            ) else {
                continue
            }

            let components = calendar.dateComponents(
                [.year, .month, .day],
                from: cellDate
            )

            guard
                let year = components.year,
                let month = components.month,
                let day = components.day
            else {
                continue
            }

            let isDisplayedMonth = year == displayedYear && month == displayedMonth
            let isSelected = year == selectedYear
                && month == selectedMonth
                && day == selectedDay
            let isToday = calendar.isDateInToday(cellDate)
            let isSelectable = dayIsSelectable(cellDate)

            let cell = Div {
                Strong(String(day))
                    .fontSize(20.px)
            }
            .custom("width", "calc(14.285% - 8px)")
            .height(46.px)
            .lineHeight(46.px)
            .float(.left)
            .margin(all: 4.px)
            .textAlign(.center)
            .borderRadius(all: 10.px)
            .custom(
                "border",
                isToday && !isSelected
                    ? "1px solid var(--tc-beta-blue)"
                    : "1px solid transparent"
            )
            .custom(
                "background",
                isSelected
                    ? "var(--tc-beta-orange)"
                    : "var(--tc-beta-surface-deep)"
            )
            .custom(
                "color",
                isSelected
                    ? "#101214"
                    : (isDisplayedMonth ? "var(--tc-beta-ink)" : "var(--tc-beta-muted)")
            )
            .opacity(isSelectable ? (isDisplayedMonth ? 1 : 0.55) : 0.2)
            .cursor(isSelectable ? .pointer : .default)

            if isSelectable {
                cell.onClick {
                    self.selectedYear = year
                    self.selectedMonth = month
                    self.selectedDay = day
                    self.displayedYear = year
                    self.displayedMonth = month
                    self.constrainSelectionToBounds()
                    self.render()
                }
            }

            calendarGrid.appendChild(cell)
        }

        calendarGrid.appendChild(Div().class(.clear))
    }

    private func renderTimeSelector() {
        hourList.innerHTML = ""
        minuteList.innerHTML = ""
        timeTitle.innerText = "\(padded(selectedHour)):\(padded(selectedMinute))"

        for offset in 0..<24 {
            let hour = (selectedHour + offset) % 24
            hourList.appendChild(
                timeItem(title: padded(hour), isSelected: hour == selectedHour) {
                    self.selectedHour = hour
                    self.constrainSelectionToBounds()
                    self.renderTimeSelector()
                }
            )
        }

        for offset in 0..<60 {
            let minute = (selectedMinute + offset) % 60
            minuteList.appendChild(
                timeItem(title: padded(minute), isSelected: minute == selectedMinute) {
                    self.selectedMinute = minute
                    self.constrainSelectionToBounds()
                    self.renderTimeSelector()
                }
            )
        }
    }

    private func timeItem(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> Div {
        Div(title)
            .height(38.px)
            .lineHeight(38.px)
            .textAlign(.center)
            .fontSize(21.px)
            .borderRadius(all: 8.px)
            .margin(v: 2.px, h: 5.px)
            .custom("background", isSelected ? "var(--tc-beta-orange)" : "transparent")
            .custom("color", isSelected ? "#101214" : "var(--tc-beta-muted)")
            .cursor(.pointer)
            .onClick {
                action()
            }
    }

    private func changeDisplayedMonth(by value: Int) {
        guard
            let currentMonth = calendar.date(from: DateComponents(
                year: displayedYear,
                month: displayedMonth,
                day: 1
            )),
            let destination = calendar.date(byAdding: .month, value: value, to: currentMonth),
            monthHasSelectableDate(destination)
        else {
            return
        }

        let components = calendar.dateComponents([.year, .month], from: destination)
        guard let year = components.year, let month = components.month else {
            return
        }

        displayedYear = year
        displayedMonth = month
        renderCalendar()
    }

    private func monthHasSelectableDate(_ date: Date) -> Bool {
        guard let monthRange = calendar.range(of: .day, in: .month, for: date) else {
            return false
        }

        let monthComponents = calendar.dateComponents([.year, .month], from: date)

        return monthRange.contains { day in
            var components = monthComponents
            components.day = day

            guard let date = calendar.date(from: components) else {
                return false
            }

            return dayIsSelectable(date)
        }
    }

    private func dayIsSelectable(_ date: Date) -> Bool {
        let dayStart = calendar.startOfDay(for: date)
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
            return false
        }

        if setTime {
            let dayEnd = Int64(nextDay.timeIntervalSince1970) - 1

            if let from, dayEnd < from {
                return false
            }

            if let to, Int64(dayStart.timeIntervalSince1970) > to {
                return false
            }
        } else {
            if let from, dayStart < calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(from))) {
                return false
            }

            if let to, dayStart > calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(to))) {
                return false
            }
        }

        return true
    }

    private func selectNow() {
        loadSelection(from: Int64(Date().timeIntervalSince1970))
        constrainSelectionToBounds()
        displayedYear = selectedYear
        displayedMonth = selectedMonth
        render()
    }

    private func acceptSelection() {
        callback(selectedTimestamp())
        remove()
    }

    private func selectedTimestamp() -> Int64 {
        let rawValue = timestampForSelection()

        guard setTime else {
            return rawValue
        }

        return clamp(rawValue)
    }

    private func timestampForSelection() -> Int64 {
        let components = DateComponents(
            year: selectedYear,
            month: selectedMonth,
            day: selectedDay,
            hour: setTime ? selectedHour : 0,
            minute: setTime ? selectedMinute : 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            return defaultTimestamp()
        }

        return Int64(date.timeIntervalSince1970)
    }

    private func constrainSelectionToBounds() {
        let timestamp = timestampForSelection()

        if setTime {
            loadSelection(from: clamp(timestamp))
            return
        }

        let selectedDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        if let from {
            let lowerDate = Date(timeIntervalSince1970: TimeInterval(from))
            if calendar.startOfDay(for: selectedDate) < calendar.startOfDay(for: lowerDate) {
                loadSelection(from: Int64(calendar.startOfDay(for: lowerDate).timeIntervalSince1970))
                return
            }
        }

        if let to {
            let upperDate = Date(timeIntervalSince1970: TimeInterval(to))
            if calendar.startOfDay(for: selectedDate) > calendar.startOfDay(for: upperDate) {
                loadSelection(from: Int64(calendar.startOfDay(for: upperDate).timeIntervalSince1970))
            }
        }
    }

    private func loadSelection(from timestamp: Int64) {
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: Date(timeIntervalSince1970: TimeInterval(timestamp))
        )

        selectedYear = components.year ?? Date().year
        selectedMonth = components.month ?? Date().month
        selectedDay = components.day ?? Date().day
        selectedHour = setTime ? (components.hour ?? 16) : 0
        selectedMinute = setTime ? (components.minute ?? 0) : 0
    }

    private func defaultTimestamp() -> Int64 {
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = setTime ? 16 : 0
        components.minute = 0
        components.second = 0

        return Int64((calendar.date(from: components) ?? now).timeIntervalSince1970)
    }

    private func clamp(_ timestamp: Int64) -> Int64 {
        var value = timestamp

        if let from {
            value = max(value, from)
        }

        if let to {
            value = min(value, to)
        }

        return value
    }

    private func padded(_ value: Int) -> String {
        value < 10 ? "0\(value)" : String(value)
    }

    private var calendar: Calendar {
        Calendar.current
    }

    private var monthNames: [String] {
        [
            "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
            "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
        ]
    }

    private var weekdayNames: [String] {
        ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"]
    }
}
