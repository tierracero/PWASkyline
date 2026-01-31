//
//  ViewHighPriorityNote.swift
//
//
//  Created by Victor Cantu on 10/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ViewHighPriorityNote: Div {
    
    override class var name: String { "div" }
    
    let type: NoteLevelType
    let note: HighPriorityNote
    let folio: String?
    let name: String?
    
    init(
        type: NoteLevelType,
        note: HighPriorityNote,
        folio: String?,
        name: String?
    ) {
        self.type = type
        self.note = note
        self.folio = folio
        self.name = name
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var username = ""
    
    @State var isHighPriority = true
    
    @DOM override var body: DOM.Content {
        //Select Code
        Div{
            
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2{
                        
                        Img()
                            .src("/skyline/media/icons_alert.png")
                            .marginRight(7.px)
                            .height(24.px)
                        
                        Span("Nota de Alta Prioridad")
                    }
                        .color(.red)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().height(7.px)
                
                Div{
                    Span("\(getDate(self.note.createdAt).formatedLong) \(getDate(self.note.createdAt).time)")
                        .marginRight(7.px)
                        .color(.gray)
                    
                    Span(self.$username)
                        .color(.gray)
                }
                
                Div().height(7.px)
                H1(self.note.activity)
                Div().height(7.px)
                
                Div{
                    Div("Ok")
                        .class(.uibtnLargeOrange)
                        .float(.right)
                        .onClick{
                            self.remove()
                        }
                    
                    Div("Bajar Prioridad")
                        .hidden(self.$isHighPriority.map{ !$0 })
                        .class(.uibtnLarge)
                        .onClick {
                            self.lowerNotePriority()
                        }

                }
                
            }
            .padding(all: 12.px)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if let userId = note.createdBy {
            getUserRefrence(id: .id(userId)) { user in
                guard let user else {
                    return
                }
                
                self.username = user.username
                
            }
        }
    }
    
    func lowerNotePriority(){
        
        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Bajar Prioridad",
            message: "¿Esta seguro que desea bajar la prioridad de la nota?",
            callback: { isConfirmed, comment in
                
                API.custAPIV1.lowerNotePriority(
                    noteId: .order(self.note.id)
                ) { resp in
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    self.isHighPriority = false
                    self.remove()
                    showSuccess(.operacionExitosa, "Se cambio la prioridad")
                    
                }
                
            }
        ))
        
    }
}

extension ViewHighPriorityNote {
    
    enum NoteLevelType {
        case order
        case account
        case general
        
        var description: String{
            switch self {
            case .order:
                return "Orden"
            case .account:
                return "Account"
            case .general:
                return "General"
            }
        }
    }
    
}
