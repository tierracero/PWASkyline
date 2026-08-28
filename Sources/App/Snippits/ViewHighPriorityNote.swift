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
    
    /// order, account, general
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

        VPopUp (.fitContent(w: 450)) {
            Div {
                H2 {
                    Img()
                        .src("/skyline/media/icons_alert.png")
                        .height(24.px)

                    Span("Nota de Alta Prioridad")
                }
                .class(Class(TCCrystalSurfaceClass.highPriorityTitle))

                Img()
                    .closeButton(.subView)
                    .class(Class(TCCrystalSurfaceClass.highPriorityClose))
                    .onClick {
                        self.remove()
                    }
            }
            .class(Class(TCCrystalSurfaceClass.highPriorityHeader))

            VBox(.raised) {
                Div {
                    Span("\(getDate(self.note.createdAt).formatedLong) \(getDate(self.note.createdAt).time)")
                    Span(self.$username)
                }
                .class(Class(TCCrystalSurfaceClass.highPriorityMeta))

                H1(self.note.activity)
                    .class(Class(TCCrystalSurfaceClass.highPriorityBody))

                Div {

                    Div("Bajar Prioridad")
                        .display(self.$isHighPriority.map { !$0 ? .none : .block })
                        .hidden(self.$isHighPriority.map { !$0 })
                        .float(.left)
                        .class(
                            Class(TCCrystalSurfaceClass.highPriorityLower)
                        )
                        .onClick {
                            self.lowerNotePriority()
                        }
                }
                .width(50.percent)
                .float(.left)

                Div {

                    Div("Ok")
                    .float(.right)
                    .display(.block)
                        .class(
                            Class(TCCrystalSurfaceClass.highPriorityConfirm)
                        )
                        .onClick {
                            self.remove()
                        }                    
                }
                .width(50.percent)
                .float(.left)

                Div().clear(.both)

            }
            .custom("height", "auto !important")


        }
        .id(.init("VPopUp"))
        //.class(Class(TCCrystalSurfaceClass.highPriorityPanel))
    }
    
    override func buildUI() {
        super.buildUI()

        TCCrystalSurfaceTheme.apply(to: self, variant: .highPriorityNote)
        
        position(.fixed)
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
                
                var noteId:  API.custAPIV1.LowerNotePriority {
                    if self.type == .account || self.type == .general {
                        return .general(self.note.id)
                    }
                    else {
                        return .order(self.note.id)
                    }
                }
                
                API.custAPIV1.lowerNotePriority(
                    noteId:  noteId
                ) { resp in
                    loadingView.hide()
                    
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

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $username.removeAllListeners()
        $isHighPriority.removeAllListeners()
    }
}

/// order, account, general
extension ViewHighPriorityNote {
    
    /// order, account, general
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
