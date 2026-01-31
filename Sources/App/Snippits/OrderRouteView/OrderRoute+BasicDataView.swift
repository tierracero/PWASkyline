//
//  OrderRouteView+BasicDataView.swift
//
//
//  Created by Victor Cantu on 11/3/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderRouteView{

    class BasicDataView: Div {
        
        override class var name: String { "div" }
        
        @State var name: String
        
        @State var day: String
        
        @State var month: String
        
        @State var year: String
        
        @State var initialTime: String
        
        @State var endingTime: String
        
        @State var supervisor: String
        
        @State var assignUsers: [UUID]
        
        private var callback: ((
            _ name: String?,
            _ day: String?,
            _ month: String?,
            _ year: String?,
            _ initialTime: String?,
            _ endingTime: String?,
            _ supervisor: UUID?,
            _ assignUsers: [UUID]
        ) -> ())
        
        init(
            name: String?,
            day: String?,
            month: String?,
            year: String?,
            initialTime: String?,
            endingTime: String?,
            supervisor: UUID?,
            assignUsers: [UUID],
            callback: @escaping ((
                _ name: String?,
                _ day: String?,
                _ month: String?,
                _ year: String?,
                _ initialTime: String?,
                _ endingTime: String?,
                _ supervisor: UUID?,
                _ assignUsers: [UUID]
            ) -> ())
        ) {
            self.name = name ?? ""
            self.day = day ?? Date().day.toString
            self.month = month ?? Date().month.toString
            self.year = year ?? Date().year.toString
            self.initialTime = initialTime ?? ""
            self.endingTime = endingTime ?? ""
            self.supervisor = supervisor?.uuidString ?? ""
            self.assignUsers = assignUsers
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var nameField = InputText(self.$name)
            .custom("width","calc(100% - 24px)")
            .placeholder("Nombre de la ruta")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onEnter {
                if self.name.isEmpty {
                    return
                }
                self.dayField.select()
            }
        
        lazy var dayField = InputText(self.$day)
            .custom("width","calc(100% - 24px)")
            .placeholder("31")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeysOnlyNumbers.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
            .onEnter {
                if self.day.isEmpty {
                    return
                }
                self.monthField.select()
            }
        
        lazy var monthField = InputText(self.$month)
            .custom("width","calc(100% - 24px)")
            .placeholder("1")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeysOnlyNumbers.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
            .onEnter {
                if self.month.isEmpty {
                    return
                }
                self.yearField.select()
            }
        
        lazy var yearField = InputText(self.$year)
            .custom("width","calc(100% - 24px)")
            .placeholder("2024")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeysOnlyNumbers.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
            .onEnter {
                if self.year.isEmpty {
                    return
                }
                self.initialTimeField.select()
            }
        
        lazy var initialTimeField = InputText(self.$initialTime)
            .custom("width","calc(100% - 24px)")
            .placeholder("8:00")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeysOnlyTime.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
            .onEnter {
                if self.initialTime.isEmpty {
                    return
                }
                self.endingTimeField.select()
            }
        
        lazy var endingTimeField = InputText(self.$endingTime)
            .custom("width","calc(100% - 24px)")
            .placeholder("13:00")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeysOnlyTime.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
            .onEnter {
                if self.endingTime.isEmpty {
                    return
                }
                self.addData()
            }
        
        lazy var supervisorSelect = Select(self.$supervisor)
            .custom("width", "calc(100% - 18px)")
            .class(.textFiledLightLarge)
            .height(37.px)
            .body {
                Option("Seleccione Supervisor")
                    .value("")
            }
        
        lazy var userGrid = Div()
        
        
        @DOM override var body: DOM.Content {
            Div{
                // MARK: Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Ingersar Datos Basicos")
                        .color(.lightBlueText)
                }
                
                Div().class(.clear).marginTop(7.px)
                
                // MARK: Body
                Div{
                    
                    // MARK: Basic Data
                    Div{
                        
                        Div{
                            Label("Nombre del evento")
                                .color(.gray)
                            
                            self.nameField
                        }
                        
                        Div().class(.clear).marginTop(3.px)
                        
                        Div{
                            Label("Fecha del evento")
                                .color(.gray)
                            
                            Div{
                                
                                Div{
                                    self.dayField
                                }
                                .width(33.percent)
                                .float(.left)
                                
                                Div{
                                    self.monthField
                                }
                                .width(33.percent)
                                .float(.left)
                                
                                Div{
                                    self.yearField
                                }
                                .width(33.percent)
                                .float(.left)
                                
                                Div().class(.clear)
                                
                            }
                            
                        }
                        
                        Div().class(.clear).marginTop(3.px)
                        
                        Div{
                            
                            Div{
                                Label("Hora de inicio")
                                    .color(.gray)
                                
                                self.initialTimeField
                                
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                Div{
                                    Label("finalización")
                                        .color(.gray)
                                }
                                .class(.oneLineText)
                                
                                
                                self.endingTimeField
                                
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().class(.clear)
                        }
                        
                        Div().class(.clear).marginTop(3.px)
                        
                        Label("Seleccione Supervisor")
                            .color(.gray)
                        
                        Div().class(.clear).marginTop(3.px)
                        
                        self.supervisorSelect
                        
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    // MARK: Users Data
                    Div{
                        
                        Label("Seleccione Equipo")
                            .color(.gray)
                
                        Div().class(.clear).marginTop(3.px)
                        
                        self.userGrid
                        
                    }
                    .width(50.percent)
                    .overflow(.auto)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                
                Div().class(.clear).marginTop(3.px)
                
                Div{
                    Div("Ageragar datos")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            print("001")
                            self.addData()
                        }
                        
                }
                .align(.right)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 274px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .top(24.percent)
            .width(500.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            getUsers(storeid: custCatchStore, onlyActive: true) { users in
                
                users.forEach { row in
                    
                    var user = row.username
                    
                    if let firstPart = row.username.explode("@").first {
                        user = "@\(firstPart)"
                    }
                    
                    self.supervisorSelect.appendChild(Option(user).value(row.id.uuidString))
                    
                    self.userGrid.appendChild(
                        Div(user)
                            .backgroundColor(self.$assignUsers.map{ $0.contains(row.id) ? .black : .grayBlackDark })
                            .color(self.$assignUsers.map{ $0.contains(row.id) ? .titleBlue : .white })
                            .onClick {
                                
                                
                                if self.assignUsers.contains(row.id) {
                                    
                                    var assignUsers: [UUID] = []
                                   
                                    self.assignUsers.forEach { id in
                                        if row.id != id {
                                            assignUsers.append(id)
                                        }
                                    }
                                    
                                    self.assignUsers = assignUsers
                                    
                                }
                                else {
                                    
                                    self.assignUsers.append(row.id)
                                    
                                }
                            }
                            .class(.uibtnLarge)
                            .width(93.percent)
                    )
                    
                }
                
            }
            
            super.buildUI()
        }
        
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            nameField.select()
            
        }
        
        func addData() {
            
            if name.isEmpty {
                print("🔴  No name")
                showError(.requiredField, .requierdValid("Nombre"))
                nameField.select()
                return
            }
            
            validateDateFormat(date: "\(day)/\(month)/\(year)") { title, message in
                print("🔴  invalid date ")
                addToDom(ConfirmationView(type: .ok, title: title, message: message, callback: { isConfirmed, comment in
                    self.dayField.select()
                }))
                return
            }
            
            validateTimeFormat(time: initialTime) { title, message in
                print("🔴  invalid time 1 ")
                addToDom(ConfirmationView(type: .ok, title: title, message: message, callback: { isConfirmed, comment in
                    self.initialTimeField.select()
                }))
                return
            }
            
            validateTimeFormat(time: endingTime) { title, message in
                print("🔴  invalid time 2 ")
                addToDom(ConfirmationView(type: .ok, title: title, message: message, callback: { isConfirmed, comment in
                    self.endingTimeField.select()
                }))
                return
            }
            
            
            guard let supervisor = UUID(uuidString: supervisor) else {
                showError(.generalError, "Seleccione Supervisor")
                return
            }
            
            callback(
                name,
                day,
                month,
                year,
                initialTime.isEmpty ? nil : initialTime,
                endingTime.isEmpty ? nil : endingTime,
                supervisor,
                assignUsers
            )
            
            self.remove()
            
        }
        
    }
    
}
