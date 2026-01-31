//
//  RentalOrderConfirmation.swift
//
//
//  Created by Victor Cantu on 3/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

class RentalOrderConfirmation: Div {
    
    override class var name: String { "div" }
    
    var dueAt: Double = 0
    var startAt: Double = 0
    var endAt: Double = 0
    
    @State var dueDateHour = "00:00"
    
    @State var dueDateDay = "00/00/0000"
    
    @State var startAtDay = "00/00/0000"
    @State var endAtDay = "00/00/0000"
    
    @State var firstName = ""
    @State var lastName = ""
    
    @State var mobile = ""
    @State var telephone = ""
    
    @State var street = ""
    @State var colony = ""
    @State var city = ""
    @State var state = ""
    @State var country = ""
    @State var zip = ""
    
    lazy var timeField = InputText($dueDateHour)
        .placeholder("00:00")
        .class(.textFiledLight)
    
    /// TODO: convert to sistem setings
    var rentalStarts: RentalStartsAt = .nextDay
    /// TODO: convert to sistem setings
    var pickUpHour: Int = 16
    /// TODO: convert to sistem setings
    var pickUpMin: Int = 0
    
    lazy var firstNameField = InputText(self.$firstName)
    lazy var mobileField = InputText(self.$mobile)
    lazy var lastNameField = InputText(self.$lastName)
    
    let uts: Double
    let custAcct: CustAcctSearch
    private var callback: ((
        _ dueAt: Double,
        _ startAt: Double,
        _ endAt: Double,
        _ firstName: String,
        _ lastName: String,
        _ mobile: String,
        _ telephone: String,
        _ street: String,
        _ colony: String,
        _ city: String,
        _ state: String,
        _ country: String,
        _ zip: String
    ) -> ())
    
    init(
        uts: Double,
        custAcct: CustAcctSearch,
        callback: @escaping ((
            _ dueAt: Double,
            _ startAt: Double,
            _ endAt: Double,
            _ firstName: String,
            _ lastName: String,
            _ mobile: String,
            _ telephone: String,
            _ street: String,
            _ colony: String,
            _ city: String,
            _ state: String,
            _ country: String,
            _ zip: String
        ) -> ())
    ) {
        self.uts = uts
        self.custAcct = custAcct
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.subView)
                .onClick{
                    self.remove()
                }
            
            H2("Confirme Información")
                .color(.lightBlueText)
           
            Div()
                .class(.clear)
                .marginBottom(3.px)
            
            Div {
                
                H2("Datos del contacto")
                
                Div{
                    
                    /// First Name
                    Label("Primer Nombre")
                        .color(.red)
                    
                    self.firstNameField
                        .class(.textFiledLight)
                        .placeholder(.firstName)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(1)
                    
                    Div().class(.clear)
                    
                    /// mobile
                    Label("Movil")
                        .color(.red)
                    
                    self.mobileField
                        .class(.textFiledLight)
                        .placeholder("Telefono Movil")
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(3)
                    
                    Div().class(.clear)
                    
                }
                .class(.oneHalf)
                
                Div{
                    
                    /// lastName
                    Label("Apellido")
                        .color(.red)
                    
                    self.lastNameField
                        .class(.textFiledLight)
                        .placeholder("Apellido")
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(2)
                    
                    Div().class(.clear)
                    
                    /// telephone
                    Label("Telephone")
                        .color(.red)
                    
                    InputText(self.$telephone)
                        .placeholder("Telefono")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(4)
                    
                    Div().class(.clear)
                }
                .class(.oneHalf)
               
                H2("Direccion")
                
                Div{
                    
                    /// street
                    Label("Calle y numero")
                    
                    InputText(self.$street)
                        .placeholder("Calle y numero")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(5)
                    
                    /// city
                    Label("Cuidad")
                    
                    InputText(self.$city)
                        .placeholder("Cuidad")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(7)
                    
                    Div().class(.clear)
                    
                    /// country
                    Label("Pais")
                    
                    InputText(self.$country)
                        .placeholder("Pais")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(9)
                    
                }.class(.oneHalf)
                
                Div{
                    
                    /// colonia
                    Label("Colonia")
                    
                    InputText(self.$colony)
                        .placeholder("Colonia")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(6)
                    
                    /// estado
                    Label("Estado")
                        .color(.red)
                    
                    InputText(self.$state)
                        .placeholder("Estado")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(8)
                    
                    Div().class(.clear)
                    
                    /// zip
                    Label("Codigo Postal")
                    
                    InputText(self.$zip)
                        .placeholder("Codigo Postal")
                        .class(.textFiledLight)
                        .fontSize(24.px)
                        .width(95.percent)
                        .tabIndex(10)
                    
                }.class(.oneHalf)
                /**/
            }
            .class(.oneHalf)
            /*
            Div{
                
                Div{
                    
                    Span("Hora de recoleccion")
                        .float(.right)
                    
                    H2("Recolección")
                }
                
                Div().class(.clear)
                
                Div{
                    
                    self.timeField
                        .float(.right)
                        .width(125.px)
                        .fontSize(36.px)
                        .onEnter {
                            self.confirmHour()
                        }
                    
                    Span(self.$dueDateDay)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .fontSize(36.px)
                
                Div()
                    .class(.clear)
                    .marginBottom(24.px)
                
                H2("Inicio de Renta")
                
                Div().class(.clear)
                
                Div{
                    
                    Span(self.$startAtDay)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .fontSize(36.px)
                
                Div()
                    .class(.clear)
                    .marginBottom(24.px)
                
                H2("Entrega antes de cierre")
                    .color(.red)
                
                Div().class(.clear)
                
                Div{
                    Span(self.$endAtDay)
                        .float(.left)
                    Div().class(.clear)
                }
                .fontSize(36.px)
                
                Div()
                    .class(.clear)
                    .marginBottom(24.px)
                
                Div(){
                    Strong("Siguiente")
                        .fontSize(28.px)
                }
                .align(.center)
                .class(.largeButtonBox)
                .onClick {
                    self.confirmHour()
                }
                
                Div()
                    .class(.clear)
                    .marginBottom(24.px)
            }
            .class(.oneHalf)
            
            */
        }
        .padding(all: 12.px)
        .position(.absolute)
        .width(60.percent)
        .left(20.percent)
        .top(20.percent)
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

        recalculateDueHour()
        
        self.firstName = self.custAcct.firstName
        self.lastName = self.custAcct.lastName
        
        self.mobile = self.custAcct.mobile
        
        self.street = self.custAcct.street
        self.colony = self.custAcct.colony
        self.city = self.custAcct.city
        self.state = self.custAcct.state
        self.country = "Mexico"
        self.zip = self.custAcct.zip
        
    }
    
    func recalculateDueHour(){
        
        var comp = DateComponents()
        
        let date = Date(timeIntervalSince1970: TimeInterval(self.uts))
        
        switch self.rentalStarts{
        case .rightNow:
            comp.day = Date().day
            comp.month = Date().month
            comp.year = Date().year
            comp.hour = Date().hour
            comp.minute = Date().minute
        case .sameDay:
            comp.day = date.day
            comp.month = date.month
            comp.year = date.year
            comp.hour = self.pickUpHour
            comp.minute = self.pickUpMin
        case .nextDay:
            
            var _year = date.year
            var _month = date.month
            var _day = date.day
            
            if _day == 1 {
                
                if _month == 1 {
                    _month = 12
                    _year -= 1
                }
                else {
                    _month -= 1
                }
                
                let _comp = DateComponents(year: _year, month: _month)
                let _cal = Calendar.current
                let _date = _cal.date(from: _comp)!
                
                let _range = _cal.range(of: .day, in: .month, for: _date)!
                let _daysInMonth = _range.count
                
                _day = _daysInMonth
                
                comp.day = _day
                comp.month = _month
                comp.year = _year
                
            }
            else{
                
                comp.day = date.day - 1
                comp.month = date.month
                comp.year = date.year
                
            }
            
            comp.hour = self.pickUpHour
            comp.minute = self.pickUpMin
        }
        
        guard let _dueAt = Calendar.current.date(from: comp) else {
            return
        }
        
        let _startAt = date
        
        comp.year = date.year
        comp.month = date.month
        comp.day = date.day
        comp.hour = 23
        comp.minute = 59
        
        guard var _endAtUTS = Calendar.current.date(from: comp)?.timeIntervalSince1970 else {
            return
        }
        
        _endAtUTS += (60 * 60 * 24)
        
        let _endAt = Date(timeIntervalSince1970: TimeInterval(_endAtUTS))
        
        self.dueAt = _dueAt.timeIntervalSince1970
        self.startAt = _startAt.timeIntervalSince1970
        self.endAt = _endAt.timeIntervalSince1970
        
        var min = String(_dueAt.minute)
        
        if min.count == 1 {
            min = "0\(min)"
        }
        
        self.dueDateDay = "\(_dueAt.weekdayName) \(_dueAt.day)/\(_dueAt.month)/\(String(_dueAt.year).suffix(2))"
        self.dueDateHour = "\(_dueAt.hour):\(min)"
        
        self.startAtDay = "\(_startAt.weekdayName) \(_startAt.day)/\(_startAt.month)/\(String(_startAt.year).suffix(2))"
        self.endAtDay = "\(_endAt.weekdayName) \(_endAt.day)/\(_endAt.month)/\(String(_endAt.year).suffix(2))"
        
    }
    
    func confirmHour(){
        
        let time = self.dueDateHour
        
        if !time.contains(":") {
            showError(.invalidField, .requierdValid("hora"))
            self.timeField.select()
            return
        }
        
        let part = time.explode(":")
        
        if part.count != 2 {
            showError(.invalidField, .requierdValid("hora"))
            self.timeField.select()
            return
        }
        
        guard let hour = Int(part[0]) else {
            showError(.invalidField, .requierdValid("hora"))
            self.timeField.select()
            return
        }
        
        guard hour >= 0 && hour < 24 else {
            showError(.invalidField, .requierdValid("hora"))
            self.timeField.select()
            return
        }
        
        guard let min = Int(part[1]) else {
            showError(.invalidField, .requierdValid("hora"))
            self.timeField.select()
            return
        }
        
        guard min >= 0 && min < 60 else {
            showError(.invalidField, .requierdValid("hora"))
            self.timeField.select()
            return
        }
        
        self.pickUpHour = hour
        
        self.pickUpMin = min
        
        
        recalculateDueHour()
        
        self.callback(
            self.dueAt,
            self.startAt,
            self.endAt,
            self.firstName,
            self.lastName,
            self.mobile,
            self.telephone,
            self.street,
            self.colony,
            self.city,
            self.state,
            self.country,
            self.zip
        )
    }
    
}
