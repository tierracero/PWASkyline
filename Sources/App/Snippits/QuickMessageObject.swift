//
//  QuickMessageObject.swift
//  
//
//  Created by Victor Cantu on 12/19/22.
//

import Foundation
import TCFundamentals
import Web

class QuickMessageObject: Div {
    
    override class var name: String { "div" }
    
    let isEven: Bool
    
    let note: CustGeneralNotesQuick
    
    init(
        isEven: Bool,
        note: CustGeneralNotesQuick
    ) {
        self.isEven = isEven
        self.note = note
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var username = "..."
    
    @DOM override var body: DOM.Content {
        /// Data
        Div{
            
            Div("\(getDate(self.note.createdAt).formatedLong) \(getDate(self.note.createdAt).time) \(self.note.type.description)")
                .color(.gray)
                .float(.left)
            
            Div(self.$username)
                .color(.gray)
                .float(.right)
            
            Div().class(.clear)
            
        }
        .marginBottom(3.px)
        
        if self.note.type == .altaPrioridad {
            Div(self.note.activity)
                .color(r: 255, g: 84, b: 84)
                .fontSize(24.px)
            
            Div().height(3.px).clear(.both)
            
            Div{
                Div("Bajar Prioridad")
                    .class(.uibtn)
                    .onClick {
                        self.lowerNotePriority()
                    }
            }
            .align(.right)
            
        }
        else {
            
            Div(self.note.activity)
                .color(.lightGray)
        }
    
    }
    
    override func buildUI() {
        super.buildUI()
        
        borderRadius(12.px)
        margin(all: 3.px)
        padding(all: 7.px)
        overflow(.hidden)
        
        if isEven {
            self.backgroundColor(.grayBlackDark)
        }
        
        if let userid = self.note.createdBy {
            
            getUserRefrence(id: .id(userid)) { user in
                guard let user else {
                    return
                }
                
                if let prefix = user.username.explode("@").first {
                    self.username = "@\(prefix)"
                }
                else{
                    self.username = "\(user.firstName) \(user.lastName)"
                }
            }
            
        }
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        
    }
    
    func lowerNotePriority(){
        
        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Bajar Prioridad",
            message: "¿Esta seguro que desea bajar la prioridad de la nota?",
            callback: { isConfirmed, comment in
                
                API.custAPIV1.lowerNotePriority(
                    noteId: .general(self.note.id)
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
                    
                    showSuccess(.operacionExitosa, "Se cambio la prioridad")
                    
                }
                
            }
        ))
        
    }
    
}
