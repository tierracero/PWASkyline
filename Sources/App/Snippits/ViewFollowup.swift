//
//  ViewFollowup.swift
//
//
//  Created by Victor Cantu on 6/24/26.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ViewFollowup: Div {
    
    override class var name: String { "div" }
    
    public let account: CustAcct
    
    public let followup: CustFollowUp
    
    public let items: [CustFollowUpItem]
    
    private var onUpdate: ((
        _ closeType: CustFollowupComponents.CloseType
    ) -> Void)

    private var onClosing: (() -> Void)

    @State var nextDateAt: Int64? = nil
    
    @State var currentUser: UUID? = nil
    
    @State public var interest: CustFollowUpIntrest
    
    init(
        account: CustAcct,
        followup: CustFollowUp,
        items: [CustFollowUpItem],
        onUpdate: @escaping ((
            _ closeType: CustFollowupComponents.CloseType
        ) -> Void),
        onClosing: @escaping (() -> Void)
    ) {
        self.account = account
        self.followup = followup
        self.items = items
        self.nextDateAt = followup.nextDateAt
        self.currentUser = followup.currentUser
        self.interest = followup.interest
        self.interestListener = followup.interest.rawValue
        self.onUpdate = onUpdate
        self.onClosing = onClosing
        super.init()

    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var comment: String = ""
    
    @State var interestListener = ""
    
    @State var nextDateLabel = "Sin fecha seleccionada"
    
    @State var currentUserLabel = "No seleccionado"
    
    var accountLabel = ""
    
    var createdAtLabel = ""
    
    var currentComment = ""
    
    lazy var interestSelect = Select(self.$interestListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var commentField = TextArea(self.$comment)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Ingrese nuevo comentario")
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
                
                H2("Seguimiento \(self.followup.folio)")
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).height(7.px)
            
            Div {

                H3("Cuenta").color(.gray)

                Div().class(.clear).height(3.px)
                
                Div(self.accountLabel)
                    .class(.oneLineText)
                    .width(50.percent)
                    .fontSize(22.px)
                    .float(.left)
                    .color(.white)


                Div(self.account.mobile)
                    .class(.oneLineText)
                    .width(50.percent)
                    .fontSize(22.px)
                    .float(.left)
                    .color(.white)
                
            }
            
            Div().class(.clear).height(7.px)
            
            Div {
                Div {
                    H3("Creado")
                        .color(.gray)
                    Div().class(.clear).height(3.px)
                    Div(self.createdAtLabel)
                        .color(.white)
                        .class(.oneLineText)
                }
                .width(50.percent)
                .float(.left)
                
                Div {
                    H3("Interes")
                        .color(.gray)
                    Div().class(.clear).height(3.px)
                    self.interestSelect
                }
                .width(50.percent)
                .float(.left)
            }
            
            Div().class(.clear).height(7.px)
            
            H3("Usuario activo")
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
                        Div {
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
            
            Div {
                
                H1(self.$nextDateLabel)
                    .color(.white)
                    .float(.left)
                
                Div {
                    Img()
                        .src("/skyline/media/calendar.png")
                        .cursor(.pointer)
                        .height(24.px)
                }
                .float(.right)
                .onClick {
                    self.selectDate()
                }
                
                Div {
                    Img()
                        .src("/skyline/media/cross.png")
                        .cursor(.pointer)
                        .height(24.px)
                }
                .hidden(self.$nextDateAt.map{ $0 == nil })
                .marginRight(7.px)
                .float(.right)
                .onClick {
                    self.nextDateAt = nil
                    self.nextDateLabel = "Sin fecha seleccionada"
                }
            }
            
            Div().class(.clear).height(7.px)
                        
            Div {

                Div{

                    H2("Historial")
                        .color(.gray)
                    Div().class(.clear).height(3.px)
                    
                    ForEach(Array(self.items.indices)) { index in
                        let item = self.items[index]
                        
                        Div {
                            Div {
                                Span(item.linkType.rawValue)
                                    .fontWeight(.bolder)
                                    .paddingRight(7.px)
                                
                                Span(getDate(item.createdAt).formatedLong)
                                    .color(.gray)
                            }
                            .class(.oneLineText)
                            
                            Div(item.comment.replace(from: "\n", to: " "))
                                .class(.oneLineText)
                                .color(.white)
                        }
                        .padding(all: 7.px)
                        .marginBottom(5.px)
                        .backgroundColor(.init(r: 0, g: 0, b: 0, a: 0.18))
                        .borderRadius(all: 7.px)
                    }
                    
                    Div("Sin historial")
                        .color(.gray)
                        .hidden(self.items.isEmpty == false)  

                }
                .width(50.percent)
                .float(.left)

                Div{
                    
                    H3("Comentario actual").color(.gray)

                    Div().class(.clear).height(3.px)

                    Div{
                        H2(self.currentComment)
                        .fontSize(32.px)
                        .color(.white)
                    }
                    .padding(all: 7.px)

                    Div().class(.clear).height(7.px)
                        
                    H3("Nuevo comentario").color(.gray)

                    Div().class(.clear).height(3.px)

                    self.commentField
                    
                    Div().class(.clear).height(7.px)

                }
                .width(50.percent)
                .float(.left)

            }            

            Div {

                Div{

                    Div("Cerrar Seguimiento")
                        .class(.uibtnLarge)
                        .textAlign(.center)
                        .width(90.percent)
                        .onClick {
                            self.closeFollowupView()
                        }

                }
                .width(50.percent)
                .float(.left)

                Div{
                    Div("Actualizar Seguimiento")
                        .class(.uibtnLarge)
                        .textAlign(.center)
                        .width(90.percent)
                        .onClick {
                            self.updateFollowup()
                        }
                }
                .width(50.percent)
                .float(.left)

            }

            Div().class(.clear).height(7.px)
        }
        .custom("left", "calc(50% - 275px)")
        .custom("top", "calc(50% - 380px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(550.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        accountLabel = account.businessName.isEmpty ? "\(account.firstName) \(account.lastName)" : account.businessName
        createdAtLabel = getDate(followup.createdAt).formatedLong
        currentComment = followup.comment

        if let nextDateAt {
            let date = getDate(nextDateAt)
            nextDateLabel = "\(date.formatedLong) \(date.time)"
        }
        
        updateCurrentUserLabel(followup.currentUser)
        
        interestSelect.appendChild(
            Option("Seleccione interes")
                .value("")
        )
        
        CustFollowUpIntrest.allCases.forEach { item in
            interestSelect.appendChild(
                Option(item.documentableName)
                    .value(item.rawValue)
            )
        }
        
        interestListener = followup.interest.rawValue

        $interestListener.listen {
            guard let interest = CustFollowUpIntrest(rawValue: $0) else {
                return
            }
            self.interest = interest
        }
    }
    
    func selectUser(_ compleat: Bool = false) {
        addToDom(
            SelectCustUsernameView(
                type: (custCatchHerk > 3) ? .all : .store(custCatchStore),
                ignore: [],
                callback: { user in
                    self.currentUser = user.id
                    self.currentUserLabel = user.username
                    if compleat {
                        self.updateFollowup()
                    }
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
        
        getUserRefrence(id: .id(userId)) { user in
            guard let user else {
                self.currentUserLabel = userId.uuidString
                return
            }
            self.currentUserLabel = user.username
        }
    }
    
    func updateFollowup() {
        
        guard let currentUser else {
            showError(.invalidField, "Seleccione usuario")
            selectUser(true)
            return
        }
        
        guard let interest = CustFollowUpIntrest(rawValue: interestListener) else {
            showError(.invalidField, "Seleccione nivel de interes")
            return
        }
        
        if comment.isEmpty {
            showError(.invalidField, "Ingrese nuevo comentario")
            return
        }
        
        loadingView.show()
        
        API.custFollowup.update(
            followupId: followup.id,
            nextDateAt: nextDateAt,
            currentUser: currentUser,
            type: followup.type,
            comment: comment,
            interest: interest
        ) { resp in
            
            loadingView.hide()
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            if interest == CustFollowUpIntrest.closing {
                self.onClosing()
            }
            
            self.remove()
        }
    }
    
    func closeFollowupView() {
        addToDom(
            CloseFollowupView(
                followup: followup
            ) { closeType in
                self.onUpdate(closeType)
                self.remove()
            }
        )
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $nextDateAt.removeAllListeners()
        $currentUser.removeAllListeners()
        $interest.removeAllListeners()
        $comment.removeAllListeners()
        $interestListener.removeAllListeners()
        $nextDateLabel.removeAllListeners()
        $currentUserLabel.removeAllListeners()
    }
}

class CloseFollowupView: Div {
    
    override class var name: String { "div" }
    
    let followup: CustFollowUp
    
    private var callback: ((
        _ closeType: CustFollowupComponents.CloseType
    ) -> Void)
    
    @State var closeType: CustFollowupComponents.CloseType? = nil
    
    @State var closeTypeListener = ""
    
    lazy var closeTypeSelect = Select(self.$closeTypeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    init(
        followup: CustFollowUp,
        callback: @escaping ((
            _ closeType: CustFollowupComponents.CloseType
        ) -> Void)
    ) {
        self.followup = followup
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div {
            
            Div {
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        self.remove()
                    }
                
                H2("Cerrar Seguimiento")
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).height(7.px)
            
            H3("Resultado")
                .color(.gray)
            Div().class(.clear).height(3.px)
            self.closeTypeSelect
            
            Div().class(.clear).height(7.px)
            
            Div("Cerrar Seguimiento")
                .class(.uibtnLargeOrange)
                .textAlign(.center)
                .width(95.percent)
                .onClick {
                    self.closeFollowup()
                }
        }
        .custom("left", "calc(50% - 225px)")
        .custom("top", "calc(50% - 160px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(450.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        closeTypeSelect.appendChild(
            Option("Seleccione resultado")
                .value("")
        )
        
        CustFollowupComponents.CloseType.allCases.forEach { item in
            closeTypeSelect.appendChild(
                Option(closeTypeLabel(item))
                    .value(item.rawValue)
            )
        }
        
        $closeTypeListener.listen {
            self.closeType = CustFollowupComponents.CloseType(rawValue: $0)
        }
    }
    
    func closeFollowup() {
        
        guard let closeType = CustFollowupComponents.CloseType(rawValue: closeTypeListener) else {
            showError(.invalidField, "Seleccione resultado")
            return
        }
        
        loadingView.show()
        
        API.custFollowup.close(
            followupId: followup.id,
            closeType: closeType
        ) { resp in
            
            loadingView.hide()
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            self.callback(closeType)
            self.remove()
        }
    }
    
    func closeTypeLabel(_ closeType: CustFollowupComponents.CloseType) -> String {
        switch closeType {
        case .toOrder:
            return "Convertir a orden"
        case .toPOS:
            return "Convertir a punto de venta"
        case .noIntrest:
            return "Sin interes"
        }
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $closeType.removeAllListeners()
        $closeTypeListener.removeAllListeners()
    }
}
