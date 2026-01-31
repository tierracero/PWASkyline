//
//  AddNoteView.swift
//
//
//  Created by Victor Cantu on 10/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class AddNoteView: Div {
    
    override class var name: String { "div" }
    
    ///service, product, inventory, webContent, pageContent, album, purches, user, gps, account, subAccount, none, store, storeBodega, storeSeccion
    let relationType : CustGeneralNotesTargetTypes
    
    let relationId: UUID
    
    private var callback: ((
        _ note: CustGeneralNotesQuick
    ) -> ())
    
    init(
        relationType : CustGeneralNotesTargetTypes,
        relationId: UUID,
        callback: @escaping (
            _ note: CustGeneralNotesQuick
        ) -> Void
    ) {
        self.relationType = relationType
        self.relationId = relationId
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var message = ""
    
    @State var date = ""
    
    @State var noteTypeListener = ""
    
    lazy var messageField = TextArea(self.$message)
       .placeholder("Ingrese razon por el cambio.")
       .custom("width","calc(100% - 24px)")
       .class(.textFiledBlackDark)
       .height(120.px)
    
    lazy var newNoteFilter = Select(self.$noteTypeListener)
        .class(.textFiledBlackDark)
        .borderStyle(.none)
        .fontSize(18.px)
        .height(23.px)
    
    
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
                    
                    H2("Agregar Nota \(self.relationType.description.uppercased())")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().height(7.px)
                
                H2{
                    Label("Nueva nota")
                    
                    self.newNoteFilter
                        .float(.right)
                }
                
                Div().height(7.px)
                
                self.messageField
                
                Div().height(7.px)
                
                Div("Agregar Nota")
                    .custom("width", "calc(100% - 12px)")
                    .textAlign(.center)
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addNote()
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
        
        NoteTypes.allCases.forEach { type in
            
            if type == .webNote {
                return
            }
            
            if type.writeAvailable {
                newNoteFilter.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
        }
        
        noteTypeListener = NoteTypes.general.rawValue
        
    }
    
    func addNote(){
        
        guard let noteType = NoteTypes(rawValue: noteTypeListener) else {
            return
        }
        
        if message.isEmpty {
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.addNote(
            relType: relationType,
            rel: relationId,
            type: noteType,
            activity: message
        ) { resp in
            
            loadingView(show: false)
            
            guard let  resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let note = resp.data else {
                return
            }
            
            self.callback(note)
            
            self.remove()
            
        }
        
    }
    
}
