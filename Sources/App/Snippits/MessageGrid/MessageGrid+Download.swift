//
//  MessageGrid+Download.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Foundation
import Web

extension MessageGrid {

    class Download: Div {
    
        override class var name: String { "div" }

        /// Order ID
        let orderId: UUID
        
        let accountId: UUID
        
        let folio: String
        
        /// Order Name
        let name: String
        
        /// Order Mobile
        let mobile: String

        let notes: [CustOrderLoadFolioNotes]

        required init(
            orderId: UUID,
            accountId: UUID,
            folio: String,
            name: String,
            mobile: String,
            notes: [CustOrderLoadFolioNotes]
        ) {
            self.orderId = orderId
            self.accountId = accountId
            self.folio = folio
            self.name = name
            self.mobile = mobile
            self.notes = notes
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State var currentView: CurrentView = .selectAcction

        @State var selectableMesages: [CustOrderLoadFolioNotes] = []

        var selectedMessages: [UUID:Bool] = [:]

        @DOM override var body: DOM.Content {

            Div {

                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            stopVideo()
                            Dispatch.asyncAfter(0.5) {
                                self.remove()
                            }
                        }
                    
                    H2("Seleccione Accion")
                        .color(.lightBlueText)
                }

                Div{

                    Div("Reporte Completo")
                    .custom("width", "calc(100% - 12px)")
                    .class(.uibtnLarge)
                    .align(.left)
                    .onClick {

                    }


                    Div("Captura de pantalla")
                    .custom("width", "calc(100% - 12px)")
                    .class(.uibtnLarge)
                    .align(.left)
                    .onClick {
                        self.selectMessages()
                    }
                }
                
            }
            .custom("left", "calc(50% - 174px)")
            .custom("top", "calc(50% - 94px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(300.px)
            .hidden(self.$currentView.map{ $0 != .selectAcction })

            Div {

                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            stopVideo()
                            Dispatch.asyncAfter(0.5) {
                                self.remove()
                            }
                        }
                    
                    H2("Seleccione Messajes")
                        .color(.lightBlueText)
                        .height(35.px)
                }

                Div {
                    ForEach(self.$selectableMesages) { item in
                        self.drawMessage(item)
                    }
                }
                .custom("height", "calc(100% - 70px)")
                .borderRadius(all: 24.px)
                .position(.relative)
                .overflow(.auto)

                Div {
                    Div("Seleccionar Mensajes")
                    .class(.uibtnLargeOrange)
                }
                .align(.right)
            }
            .custom("left", "calc(50% - 274px)")
            .custom("top", "calc(50% - 274px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(300.px)
            .hidden(self.$currentView.map{ $0 != .selectMessages })

        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
        }
        
        func selectMessages() {

            // selectableMesages

            var selectableMesages: [CustOrderLoadFolioNotes] = []

            notes.reversed().forEach { note in
                if note.type == .webNote || note.type == .webNoteClie  || note.type == .webNoteRep {
                    selectableMesages.append(note)
                }
            }

            self.selectableMesages = selectableMesages 

            currentView = .selectMessages
            
        }

        func drawMessage(_ item: CustOrderLoadFolioNotes) -> Div {

            Div {
                InputCheckbox()
                .onChange { _, cb in
                    self.selectedMessages[item.id] = cb.checked
                }
            }
            .float(.left)
            .width(42.px)

            Div{

                if item.type == .webNoteClie {

                    Div(item.activity)
                    .maxWidth(70.percent)
                    .class(.uibtn)
                    .float(.left)
                    
                }
                else {

                    Div(item.activity)
                    .maxWidth(70.percent)
                    .class(.uibtn)
                    .float(.right)

                }

                Div().clear(.both)

            }
            .custom("width", "calc(100% - 42px)")
            .float(.left)

            Div().clear(.both)

        }

    }
}
extension MessageGrid.Download {

    enum CurrentView {
        case selectAcction

        case selectMessages
    }
    
}