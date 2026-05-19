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

        let notesRefrence: [UUID:CustOrderLoadFolioNotes]

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

            self.notesRefrence = Dictionary.init(uniqueKeysWithValues: notes.map { ($0.id, $0) } )

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
                            self.remove()
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
                            self.remove()
                        }
                    
                    H2("Seleccione Messajes")
                        .color(.lightBlueText)
                        .height(35.px)
                }

                Div {
                    Div{

                        ForEach(self.$selectableMesages) { item in
                            self.drawMessage(item)
                        }

                    }
                    .margin(all: 7.px)

                }
                .custom("height", "calc(100% - 83px)")
                .borderRadius(all: 24.px)
                .class(.roundDarkBlue)
                .position(.relative)
                .overflow(.auto)

                Div {
                    Div("Seleccionar Mensajes")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.printMessages()
                    }
                }
                .align(.right)
            }
            .custom("left", "calc(50% - 474px)")
            .custom("top", "calc(50% - 374px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(900.px)
            .height(700.px)
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
                if (note.type == .webNoteClie  || note.type == .webNoteRep) && note.subType == .msg {
                    selectableMesages.append(note)
                }
            }

            self.selectableMesages = selectableMesages 

            currentView = .selectMessages
            
        }

        func drawMessage(_ item: CustOrderLoadFolioNotes) -> Div {
            Div{

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

                Div().clear(.both).height(7.px)
            }
        }

        func printMessages() {

            var notesToPrint: [UUID] = []

            selectedMessages.forEach { id, bool in
                if bool {
                    notesToPrint.append(id)
                }
            }

            if selectedMessages.isEmpty {
                return
            }

            loadingView(show: true)
            
            API.custOrderV1.downloadMessages(
                orderId: self.orderId,
                notes: notesToPrint
            ) { resp in

                loadingView(show: false)

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, "No se obtuvo datos de la cuenta.")
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpectedMissingPayload)
                    return
                }

                let url = baseAPIUrl("https://api.tierracero.co/cust/v1/customePrintDownloader") +
                "&file=" + payload.fileName
                
                print(url)

                _ = JSObject.global.goToURL!(url)

            }

        }

    }
}

extension MessageGrid.Download {

    enum CurrentView {
        case selectAcction

        case selectMessages
    }
    
}
