//
//  FiscalCurrentCancelationsView.swift
//  
//
//  Created by Victor Cantu on 6/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalCurrentCancelationsView: Div {
    
    override class var name: String { "div" }
    
    lazy var docDiv = Div()
    
    @DOM override var body: DOM.Content {
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2("Historial de cancelaciones")
                    .color(.lightBlueText)
                    .height(35.px)
                
            }
            
            self.docDiv
            .custom("height", "calc(100% - 35px)")
            .overflow(.auto)
            
        }
        .custom("left", "calc(50% - 364px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
    }
    
    override func buildUI() {
        super.buildUI()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        loadingView(show: true)
        
        API.fiscalV1.getCurrentCancelations { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError( .errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            /*
             id: UUID,
             createdAt: Int64,
             modifiedAt: Int64,
             requestedBy: UUID,
             docid: UUID,
             uuid: UUID,
             motive: FiscalCancelDocumentMotive,
             reason: String,
             folio: String,
             lastEight: String,
             status: FiscalDocumentCancelationStatus
             */
            
            data.forEach { item in
                
                @State var uname = ""
                
                getUserRefrence(id: .id(item.requestedBy)) { user in
                    uname = (user?.username ?? "")
                }
                
                let view = Div{
                    Div{
                        Span($uname)
                        Span(getDate(item.createdAt).formatedLong)
                            .float(.right)
                    }
                    .marginBottom(7.px)
                    .fontSize(14)
                    
                    Div{
                        
                        Span(item.reason)
                            .marginRight(7.px)
                    }
                    .marginBottom(7.px)
                    
                    Div{
                        
                        Div("Ver Documento")
                        .class(.uibtnLargeOrange)
                        .float(.left)
                        .onClick {
                            
                            loadingView(show: true)

                            API.fiscalV1.loadDocument(docid: item.docid) { resp in

                                loadingView(show: false)

                                guard let resp else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }

                                guard resp.status == .ok else {
                                    showError(.errorGeneral, resp.msg)
                                    return
                                }

                                guard let payload = resp.data else {
                                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                                    return
                                }

                                let view = ToolFiscalViewDocument(
                                    type: payload.type,
                                    doc: payload.doc,
                                    reldocs: payload.reldocs,
                                    account: payload.account
                                ) {
                                    /// Document canceled
                                    self.remove()
                                }
                                
                                addToDom(view)

                            }
                        
                            
                        }
                        
                        Span(item.status.description)
                            .float(.right)
                        
                        Div().class(.clear)
                        
                    }
                }
                .marginBottom(3.px)
                .overflow(.hidden)
                .class(.uibtn)
                
                self.docDiv.appendChild(view)
                
            }
        }
    }
}
