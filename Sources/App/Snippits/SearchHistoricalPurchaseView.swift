//
//  SearchHistoricalPurchaseView.swift
//  
//
//  Created by Victor Cantu on 10/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SearchHistoricalPurchaseView: Div {
    
    override class var name: String { "div" }
    
    private var close: ((
    ) -> ())
    
    private var minimize: ((
    ) -> ())

    init(
        close: @escaping ((
        ) -> ()),
        minimize: @escaping ((
        ) -> ())
    ) {
        self.close = close
        self.minimize = minimize
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var term = ""
    
    lazy var termField = InputText(self.$term)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Buscar en historial de compras...")
        .marginLeft(12.px)
        .fontSize(24.px)
        .height(28.px)
        .width(500.px)
        .onFocus { tf in
            tf.select()
        }
        .onEnter {
            self.searchTerm()
        }
    
    lazy var resultGridHeader = Tr{
        Td("Provedor")
            .width(120.px)
        Td("Fecha")
            .width(100.px)
        Td("Code")
            .width(120.px)
        Td("Description")
        Td("Costo")
            .width(100.px)
    }
        .color(.white)
    
    lazy var resultGrid = Table {
        self.resultGridHeader
    }
    .width(100.percent)
    
    lazy var minimizeButton = Img()
        .src("/skyline/media/lowerWindow.png")
        .marginRight(18.px)
        .class(.iconWhite)
        .cursor(.pointer)
        .float(.right)
        .width(24.px)
        .onClick {
            self.minimize()
        }
    
    @DOM override var body: DOM.Content {
        Div{
        
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.close()
                    }
                
                self.minimizeButton
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/reload.png")
                            .height(18.px)
                            .marginRight(7.px)
                            .marginTop(3.px)
                    }
                    .float(.left)
                    
                    
                    Span("Sincronizar XMLs")
                        .fontSize(18.px)
                }
                .class(.uibtn)
                .marginRight(20.px)
                .marginTop(-4.px)
                .float(.right)
                .onClick({
                    self.sincRecentXML()
                })
                
                
                H2("Buscar productos")
                    .color(.lightBlueText)
                    .float(.left)
                
                self.termField
                    .float(.left)
                    .onKeyUp {
                        self.searchTerm()
                    }
            }
            
            Div().class(.clear).height(3.px)
            
            Div{
                self.resultGrid
            }
            .custom("height", "calc(100% - 45px)")
            .class(.roundDarkBlue)
            .padding(all: 3.px)
            .margin(all: 3.px)
            .overflow(.auto)
            .color(.white)
        }
        .custom("height", "calc(100% - 124px)")
        .custom("width", "calc(100% - 224px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .left(100.px)
        .top(50.px)
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
    
    override func didAddToDOM(){
        super.didAddToDOM()
        termField.select()
    }
    
    func searchTerm(){
        let _term = term.purgeSpaces.pseudo
        
        if _term.count < 3 {
            return
        }
        
        Dispatch.asyncAfter(0.35) {
            
            if _term != self.term.purgeSpaces.pseudo {
                return
            }
                
            self.termField.class(.isLoading)
            
            searchHistoricalPurchase(term: _term) { _term, resp in
            
                self.termField.removeClass(.isLoading)
                
                if _term != self.term.purgeSpaces.pseudo {
                    return
                }
                
                self.resultGrid.innerHTML = ""
                
                self.resultGrid.appendChild(self.resultGridHeader)
                
                var cc = 1
                
                resp.forEach { item in
                    
                    let date = getDate(item.l)
                    
                    let tr = Tr{
                        Td(item.r)
                        Td("\(date.day.toString)/\(date.monthName.prefix(3))/\(date.year.toString)")
                        Td(item.cd)
                        Td(item.d)
                        Td(item.c.formatMoney)
                    }
                        .class(.uibtnLarge)
                        .fontSize(14.px)
                        .onClick {
                            
                            loadingView(show: true)
                            
                            API.fiscalV1.getProductControl(
                                id: item.i
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
                                    showError(.unexpectedResult, "No se obtuvo payload de data")
                                    return
                                }
                                 
                                addToDom(SearchHistoricalPurchaseDetailedView(
                                    control: payload.control,
                                    vendor: payload.vendor,
                                    poc: payload.poc
                                ))
                            }
                        }
                    
                    if cc.isEven {
                        tr.backgroundColor(.grayBlack)
                    }
                    
                    self.resultGrid.appendChild(tr)
                    
                    cc += 1
                }
                
                
                
            }
        }
    }
    
    func sincRecentXML(){
        
        loadingView(show: true)
        
        API.fiscalV1.sincRecentXML { resp in
            
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
                showError(.unexpectedResult, "No se obtuvo payload de data")
                return
            }
            
            if !payload.hasProfile {
                addToDom(ConfirmView(
                    type: .ok,
                    title: "No se localizo perfiles",
                    message: "",
                    callback: { isConfirmed, comment in
                        
                    }))
                
                return
            }
            
            var str = ""
            
            if !payload.profilesWithOutRequest.isEmpty {
                str += "Perfiles sin procesar\n"
                payload.profilesWithOutRequest.forEach { profile  in
                    str += "\(profile)\n"
                }
            }
            
            if !payload.profilesWithRequest.isEmpty {
                str += "Perfiles procesados\n"
                payload.profilesWithRequest.forEach { profile  in
                    str += "\(profile)\n"
                }
            }
            
            addToDom(ConfirmView(
                type: .ok,
                title: "Resultados de la peticion",
                message: str,
                callback: { isConfirmed, comment in
                    
                }))
            
        }
    }
}
