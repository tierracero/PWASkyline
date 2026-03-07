//
//  CreateNewFollowup.swift
//
//
//  Created by Victor Cantu on 3/6/26.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateNewFollowup: Div {
    
    override class var name: String { "div" }

    var custAcct: CustAcctSearch
    
    init(
        custAcct: CustAcctSearch
    ) {
        self.custAcct = custAcct
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var nextDateAt: Int64? = nil
    
    @State var currentUser: UUID? = nil
    
    /// date, purchase
    @State var type: CustFollowUpType?  = nil
    
    /// low, medium, high, verryHigh, closing
    @State var interest: CustFollowUpIntrest?  = nil
    
    @State var comment: String = ""
    
    @State var typeListener = ""
    
    @State var interestListener = ""
    
    @State var nextDateLabel = "Sin fecha seleccionada"
    
    @State var currentUserLabel = "No seleccionado"
    
    lazy var typeSelect = Select(self.$typeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var interestSelect = Select(self.$interestListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var commentField = TextArea(self.$comment)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Ingrese comentario de seguimiento")
        .width(95.percent)
        .height(110.px)
    
    @DOM override var body: DOM.Content {
        Div {
            
            Div {
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        self.remove()
                    }
                
                H2("Crear Seguimiento")
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).height(7.px)
            
            Div {
                Div{
                    H3("Tipo de seguimiento")
                        .color(.gray)
                    Div().class(.clear).height(3.px)
                    self.typeSelect
                }
                .width(50.percent)
                .float(.left)
                Div{
                    H3("Nivel de interes")
                        .color(.gray)
                    Div().class(.clear).height(3.px)
                    self.interestSelect
                }
                .width(50.percent)
                .float(.left)
            }
            
            Div().class(.clear).height(7.px)
            
            H3("Usuario")
                .color(.gray)
            Div().class(.clear).height(3.px)
            
            Div {

                Div {

                    Div {
                        H2(self.$currentUserLabel)
                        .color(.white)
                    }
                    .custom("width", "calc(100% - 50px)")
                    .float(.left)

                    Div {
                        Div{
                            Img()
                                .src("/skyline/media/zoom.png")
                                .width(18.px)
                                
                        }
                        .marginTop(0.px)
                        .class(.uibtnLarge)
                        .align(.center)
                        .onClick {
                            self.selectUser()
                        }
                        
                    }
                    .width(50.px)
                    .float(.left)

                }
                .hidden(self.$currentUser.map{ $0 == nil })

                Div("Seleccionar Usuario")
                    .hidden(self.$currentUser.map{ $0 != nil })
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(95.percent)
                    .onClick {
                        self.selectUser()
                    }
            }
            
            Div().class(.clear).height(7.px)
            
            H3("Fecha siguiente contacto")
                .color(.gray)
            Div().class(.clear).height(3.px)
            
            H2(self.$nextDateLabel)
                .color(.white)
            
            Div().class(.clear).height(3.px)
            
            Div {
                Div {

                    Div("Seleccionar Fecha")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(95.percent)
                        .float(.left)
                        .onClick {
                            self.selectDate()
                    }
                }
                .width(50.percent)
                .float(.left)

                Div {

                    Div("Remover Fecha")
                        .class(.uibtnLarge)
                        .textAlign(.center)
                        .width(95.percent)
                        .float(.left)
                        .onClick {
                            self.nextDateAt = nil
                            self.nextDateLabel = "Sin fecha seleccionada"
                        }

                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear)
            }
            
            Div().class(.clear).height(7.px)
            
            H3("Comentario")
                .color(.gray)
            Div().class(.clear).height(3.px)
            self.commentField
            
            Div().class(.clear).height(7.px)
            
            Div("Crear Seguimiento")
                .class(.uibtnLargeOrange)
                .textAlign(.center)
                .width(95.percent)
                .onClick {
                    self.createFollowup()
                }
            
        }
        .custom("left", "calc(50% - 250px)")
        .custom("top", "calc(50% - 320px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
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
        
        typeSelect.appendChild(
            Option("Seleccione tipo")
                .value("")
        )
        
        interestSelect.appendChild(
            Option("Seleccione interes")
                .value("")
        )
        
        CustFollowUpType.allCases.forEach { item in
            typeSelect.appendChild(
                Option(item.documentableName)
                .value(item.rawValue)
            )
        }
        
        CustFollowUpIntrest.allCases.forEach { item in
            interestSelect.appendChild(
                Option(item.documentableName)
                    .value(item.rawValue)
            )
        }

        typeListener = CustFollowUpType.purchase.rawValue

        $typeListener.listen {
            self.type = CustFollowUpType(rawValue: $0)
        }
        
        $interestListener.listen {
            self.interest = CustFollowUpIntrest(rawValue: $0)
        }
    }
    
    func selectUser() {
        addToDom(
            SelectCustUsernameView(
                type: (custCatchHerk > 3) ? .all : .store(custCatchStore),
                ignore: [],
                callback: { user in
                    self.currentUser = user.id
                    self.currentUserLabel = user.username
                }
            )
        )
    }
    
    func selectDate() {
        
        var selectedDateStamp = ""
        
        if let nextDateAt {
            selectedDateStamp = getDate(nextDateAt).calendarDateStamp
        }
        
        addToDom(
            SelectCalendarDate(
                type: nil,
                selectedDateStamp: selectedDateStamp,
                currentSelectedDates: []
            ) { _, uts, _ in
                
                let uts = Int64(uts)
                let date = getDate(uts)
                
                self.nextDateAt = uts
                self.nextDateLabel = "\(date.formatedLong) \(date.time)"
            }
        )
    }
    
    func updateCurrentUserLabel(_ userId: UUID) {
        
        if let user = userCathByUUID[userId] {
            self.currentUserLabel = user.username
            return
        }
        
        self.currentUserLabel = userId.uuidString
    }
    
    func createFollowup() {
        
        guard let currentUser else {
            showError(.invalidField, "Seleccione usuario")
            return
        }
        
        guard let type = CustFollowUpType(rawValue: typeListener) else {
            showError(.invalidField, "Seleccione tipo de seguimiento")
            return
        }
        
        guard let interest = CustFollowUpIntrest(rawValue: interestListener) else {
            showError(.invalidField, "Seleccione nivel de interes")
            return
        }
        
        if comment.isEmpty {
            showError(.invalidField, "Ingrese comentario")
            return
        }
        
        
    }
}
