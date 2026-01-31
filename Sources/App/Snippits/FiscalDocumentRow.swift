//
//  FiscalDocumentRow.swift
//  
//
//  Created by Victor Cantu on 2/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalDocumentRow: Div {
    
    override class var name: String { "div" }
    
    let folio: String
    
    let doc: FIAccountsServices
    
    init(
        folio: String,
        doc: FIAccountsServices
    ) {
        self.folio = folio
        self.doc = doc
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var moseIsOver: Bool = false
    
    lazy var iconDiv = Div {
        
        A{
            Img()
                .src("/skyline/media/pdf_icon.png")
                .marginTop(18.px)
                .height(55.px)
        }
        .href(self.pdfLink)
        .margin(all: 7.px)
        .onClick { _, event in
            event.stopPropagation()
        }
        
        A {
            Img()
                .src("/skyline/media/xml_icon.png")
                .marginTop(18.px)
                .height(55.px)
        }
        .href(self.xmlLink)
        .margin(all: 7.px)
        .onClick { _, event in
            event.stopPropagation()
        }
        
    }
        .float(.right)
        .width(117.px)
    
    lazy var dataView = Div()
        .width(100.percent)
        .marginTop(3.px)
    
    var pdfLink = ""
    
    var xmlLink = ""
   
    lazy var mainGrid = Div {
        
        Div{
            
            Div(self.doc.receptorRfc)
                .class(.oneLineText)
                .marginRight(3.px)
                .color(.gray)
                .width(200.px)
                .float(.left)
            
            Div(self.doc.receptorName)
                .custom("width", "calc(100% - 204px)")
                .class(.oneLineText)
                .color(.white)
                .float(.left)
            
            Div().class(.clear)
            
        }
        
        self.dataView
    }
        .custom("width", "calc(100% - 18px)")
        .marginBottom(7.px)
        .fontSize(23.px)
        .height(80.px)
        .class(.uibtn)
        .float(.left)
               
    @DOM override var body: DOM.Content {
        
        self.mainGrid
        
        self.iconDiv
        
        Div().class(.clear)
                
    }
    
    override func buildUI() {
        super.buildUI()
        
        marginBottom(3.px)
        overflow(.hidden)
        height(90.px)
        onClick {
            self.openDocument()
        }
        
        onMouseOver {
            self.moseIsOver = true
            self.mainGrid
                .custom("width", "calc(100% - 137px)")
        }
        
        onMouseOut {
            self.moseIsOver = false
            self.mainGrid
                .custom("width", "calc(100% - 18px)")
        }
        
        let _folio = (folio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _pdf = (doc.pdf.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _xml = (doc.xml.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        pdfLink = pdfLinkString(folio: _folio, pdf: _pdf)
        
        xmlLink = xmlLinkString(folio: _folio, xml: _xml)
        
        switch doc.tipoDeComprobante {
        case .ingreso:
            
            switch doc.paidStatus {
            case .unrequest, .paid, .global:
                dataView.appendChild(Div{
                    
                    Div("Ingreso")
                        .width(15.percent)
                        .fontSize(14.px)
                        .align(.center)
                        .color(.green)
                        .float(.left)
                    
                    
                    Div("Folio / Serie")
                        .class(.oneLineText)
                        .width(30.percent)
                        .fontSize(14.px)
                        .color(.gray)
                        .float(.left)
                    
                    Div("Creado")
                        .width(30.percent)
                        .fontSize(14.px)
                        .color(.gray)
                        .float(.left)
                    
                    Div("Total")
                        .width(25.percent)
                        .fontSize(14.px)
                        .align(.right)
                        .color(.gray)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                    Div{
                        Img()
                            .src("/skyline/media/money_bag.png")
                            .width(30.px)
                    }
                        .width(15.percent)
                        .fontSize(24.px)
                        .align(.center)
                        .color(.white)
                        .float(.left)
                    
                    Div{
                        Span(self.doc.folio)
                            .padding(all: 0.px)
                            .margin(all: 0.px)
                        Span(" ")
                            .padding(all: 0.px)
                            .margin(all: 0.px)
                        Span(self.doc.serie)
                            .padding(all: 0.px)
                            .margin(all: 0.px)
                            .color(.gray)
                    }
                        .class(.oneLineText)
                        .width(30.percent)
                        .fontSize(24.px)
                        .color(.white)
                        .float(.left)
                    
                    Div(getDate(self.doc.officialDate).formatedLong)
                        .class(.oneLineText)
                        .width(30.percent)
                        .fontSize(24.px)
                        .color(.white)
                        .float(.left)
                    
                    Div("$" + self.doc.total.formatMoney)
                        .class(.oneLineText)
                        .width(25.percent)
                        .fontSize(24.px)
                        .align(.right)
                        .color(.white)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                    
                }.width(100.percent))
                
            case .pendToPay:
                
                var paidColor: Color = .white
                
                var paidDate = ""
                
                if let dueAt = doc.dueAt {
                    
                    paidDate = getDate(dueAt).formatedLong
                    
                    let dueIn = dueAt - getNow()
                    
                    if dueIn > Int64().sevenDays {
                        paidColor = .white
                    }
                    else if dueIn > Int64().threeDays && dueIn < Int64().sevenDays {
                        paidColor = .green
                    }
                    else if dueIn > Int64().oneDay && dueIn < Int64().threeDays {
                        paidColor = .yellowDarkText
                    }
                    else if dueIn > 0.toInt64 && dueIn < Int64().oneDay {
                        paidColor = .darkOrange
                    }
                    else if dueIn < 0.toInt64 {
                        paidColor = .slateRed
                    }
                    
                    
                }
                
                dataView.appendChild(Div{
                    
                    Div("Folio / Serie")
                        .class(.oneLineText)
                        .width(20.percent)
                        .fontSize(14.px)
                        .color(.gray)
                        .float(.left)
                    
                    Div("Creado")
                        .width(30.percent)
                        .fontSize(14.px)
                        .color(.gray)
                        .float(.left)
                    
                    Div("Pagar")
                        .width(30.percent)
                        .fontSize(14.px)
                        .color(.gray)
                        .float(.left)
                    
                    Div("Bal: \(self.doc.total.formatMoney)")
                        .width(20.percent)
                        .fontSize(14.px)
                        .align(.right)
                        .color(.gray)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                    Div{
                        Span(self.doc.folio)
                            .padding(all: 0.px)
                            .margin(all: 0.px)
                        Span(" ")
                            .padding(all: 0.px)
                            .margin(all: 0.px)
                        Span(self.doc.serie)
                            .padding(all: 0.px)
                            .margin(all: 0.px)
                            .color(.gray)
                    }
                        .class(.oneLineText)
                        .width(20.percent)
                        .fontSize(24.px)
                        .color(.white)
                        .float(.left)
                
                    
                    Div(getDate(self.doc.officialDate).formatedLong)
                        .class(.oneLineText)
                        .width(30.percent)
                        .fontSize(24.px)
                        .color(.white)
                        .float(.left)
                    
                    Div(paidDate)
                        .class(.oneLineText)
                        .width(30.percent)
                        .color(paidColor)
                        .fontSize(24.px)
                        .float(.left)
                    
                    Div("$" + (self.doc.total - self.doc.paidBalance).formatMoney)
                        .class(.oneLineText)
                        .width(20.percent)
                        .fontSize(24.px)
                        .align(.right)
                        .color(.white)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }.width(100.percent))
                
            case .sentToAcct:
                break
            case .sentToDebt:
                break
            }
            
        case .egreso:
            break
        case .nomina:
            break
        case .pago:
            dataView.appendChild(Div{
                
                Div("Pago")
                    .width(15.percent)
                    .fontSize(14.px)
                    .align(.center)
                    .color(.yellowDarkText)
                    .float(.left)
                
                Div("Folio / Serie")
                    .class(.oneLineText)
                    .width(30.percent)
                    .fontSize(14.px)
                    .color(.gray)
                    .float(.left)
                
                Div("Creado")
                    .width(30.percent)
                    .fontSize(14.px)
                    .color(.gray)
                    .float(.left)
                
                Div("Total")
                    .width(25.percent)
                    .fontSize(14.px)
                    .align(.right)
                    .color(.gray)
                    .float(.left)
                
                Div().class(.clear)
                
                Div{
                    Img()
                        .src("/skyline/media/coin.png")
                        .width(30.px)
                }
                    .width(15.percent)
                    .fontSize(24.px)
                    .align(.center)
                    .color(.white)
                    .float(.left)
                
                Div{
                    Span(self.doc.folio)
                        .padding(all: 0.px)
                        .margin(all: 0.px)
                    Span(" ")
                        .padding(all: 0.px)
                        .margin(all: 0.px)
                    Span(self.doc.serie)
                        .padding(all: 0.px)
                        .margin(all: 0.px)
                        .color(.gray)
                }
                    .class(.oneLineText)
                    .width(30.percent)
                    .fontSize(24.px)
                    .color(.white)
                    .float(.left)
                
                Div(getDate(self.doc.officialDate).formatedLong)
                    .class(.oneLineText)
                    .width(30.percent)
                    .fontSize(24.px)
                    .color(.white)
                    .float(.left)
                
                Div("$" + self.doc.total.formatMoney)
                    .class(.oneLineText)
                    .width(25.percent)
                    .fontSize(24.px)
                    .align(.right)
                    .color(.white)
                    .float(.left)
                
                Div().class(.clear)
                
                
            }.width(100.percent))
        case .traslado:
            break
        }
        
        
        if doc.status == .canceled || doc.status == .canceledFraud || doc.status == .cancelationRequest {
            self.opacity(0.5)
        }

        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    func openDocument(){
    
        switch doc.tipoDeComprobante {
        case .ingreso:
            break
        case .egreso:
            showError(.generalError, "Documento no soportado")
            return
        case .nomina:
            showError(.generalError, "Documento no soportado")
            return
        case .pago:
            break
        case .traslado:
            showError(.generalError, "Documento no soportado")
            return
        }
        
        loadingView(show: true)

        API.fiscalV1.loadDocument(docid: self.doc.id) { resp in

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
    
//    override func didRemoveFromDOM() {
//        super.didRemoveFromDOM()
//
//    }
    
    
}
