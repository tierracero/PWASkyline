//
//  ToolFiscal+ViewManualSavedDocuments.swift
//  
//
//  Created by Victor Cantu on 10/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolFiscal {
    
    class ViewManualSavedDocuments: Div {
        
        override class var name: String { "div" }
        
        private var callback: ((
            _ eventid: UUID,
            _ payload: API.fiscalV1.GetSavedManualDocumentResponse
        ) -> ())
        
        init(
            callback: @escaping (
                _ eventid: UUID,
                _: API.fiscalV1.GetSavedManualDocumentResponse
            ) -> Void
        ) {
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var items: [SavedManualDocumentObject] = []
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Documentos Manuales Guardados")
                        .color(.lightBlueText)
                }
                
                Div{
                    
                    ForEach(self.$items) { item in
                        Div{
                            Div{
                                Div("\(item.receptor.rfc) \(item.receptor.nombre)")
                                    .custom("width", "calc(100% - 40px)")
                                    .class(.oneLineText)
                                    .float(.left)
                                Div{
                                    Img()
                                        .src("/skyline/media/cross.png")
                                        .marginLeft(7.px)
                                        .cursor(.pointer)
                                        .height(18.px)
                                        .onClick { _, event in
                                            addToDom(ConfirmView(
                                                type: .yesNo,
                                                title: "¿Eliminar Pre Factura?",
                                                message: "Confirme la eliminacion del pre documento",
                                                callback: { isConfirmed, reason in
                                                    
                                                    loadingView(show: true)
                                                    
                                                    API.fiscalV1.deleteSavedManualDocument(
                                                        id: item.id
                                                    ) { resp in
                                                        
                                                        loadingView(show: false)
                                                        
                                                        guard let resp else {
                                                            showError(.comunicationError, .serverConextionError)
                                                            return
                                                        }
                                                        
                                                        guard resp.status == .ok else {
                                                            showError(.generalError, resp.msg)
                                                            return
                                                        }
                                                        
                                                        var _items: [SavedManualDocumentObject] = []
                                                        
                                                        self.items.forEach { _item in
                                                            
                                                            if item.id == _item.id {
                                                                return
                                                            }
                                                            
                                                            _items.append(_item)
                                                            
                                                        }
                                                        
                                                        self.items = _items
                                                    }
                                                    
                                                }))
                                            event.stopPropagation()
                                        }
                                }
                                .float(.right)
                            }
                            
                            .fontSize(22.px)
                            .color(.white)
                            
                            Div().clear(.both).height(7.px)
                            
                            Div{
                                Span("$\(item.total.formatMoney)")
                                    .padding(all: 0.px)
                                    .margin(all: 0.px)
                                    .float(.right)
                                
                                Span("Conceptos: \(item.itemCount)")
                            }
                            .class(.oneLineText)
                            .fontSize(14.px)
                            .color(.gray)
                            
                        }
                        .padding(all: 7.px)
                        .marginTop(7.px)
                        .width(93.percent)
                        .class(.uibtn)
                        .onClick { _, event in
                            
                            loadingView(show: true)
                            
                            API.fiscalV1.getSavedManualDocument(
                                id: item.id
                            ) { resp in
                                
                                loadingView(show: false)
                                
                                guard let resp else {
                                    showError(.comunicationError, .serverConextionError)
                                    return
                                }
                                
                                guard resp.status == .ok else {
                                    showError(.generalError, resp.msg)
                                    return
                                }
                                
                                guard let payload = resp.data else {
                                    showError(.generalError, resp.msg)
                                    return
                                }
                                
                                self.callback( item.id, payload)
                                
                                self.remove()
                                
                            }
                            
                            event.stopPropagation()
                        }
                    }
                }
                .custom("height","calc(100% - 35px)")
                .class(.roundDarkBlue)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left","calc(50% - 264px)")
            .custom("top","calc(50% - 164px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(500.px)
            .height(300.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            API.fiscalV1.getSavedManualDocuments { resp in
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let items = resp.data else {
                    showError(.generalError, "Un expected missing payload")
                    return
                }

                self.items = items
                
            }
            
        }
        
    }
}
