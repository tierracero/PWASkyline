//
//  AddCartaPorteFromHistoryView.swift
//  
//
//  Created by Victor Cantu on 2/24/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddCartaPorteFromHistoryView: Div {
    
    override class var name: String { "div" }
    
    let cartaPortes: [FiscalCartaPorte]
    
    private var callback: ((
        _ cartaPorte: FiscalCartaPorte
    ) -> ())
    
    init(
        cartaPortes: [FiscalCartaPorte],
        callback: @escaping ((
            _ cartaPorte: FiscalCartaPorte
        ) -> ())
    ) {
        self.cartaPortes = cartaPortes
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var cartaPortesView = Div()
        .custom("height", "calc(100% - 35px)")
        .overflow(.auto)
    
    lazy var dateConfirmView = Div()
        .custom("height", "calc(100% - 78px)")
        .overflow(.auto)
    
    @State var confirmDateIsHidden = true
    
    /// Strore ID [ORIXXXXX] : uts [Int64]
    var dateDayRefence: [String:State<String>] = [:]
    
    var dateTimeRefence: [String:State<String>] = [:]
    
    var selectedCartaPorte: FiscalCartaPorte? = nil
    
    @DOM override var body: DOM.Content {
     
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Seleccionar Viaje")
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            
            self.cartaPortesView
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(70.percent)
        .width(80.percent)
        .left(10.percent)
        .top(15.percent)
        
        Div{
            
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView3)
                        .onClick {
                            self.confirmDateIsHidden = true
                        }
                    
                    H2("Confirme Fechas")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                }
                
                self.dateConfirmView
             
                Div{
                    Div("Agregar")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.addCartaPorte()
                        }
                }
                .align(.right)
                
                
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(60.percent)
            .width(50.percent)
            .left(25.percent)
            .top(20.percent)
            
        }
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        .hidden(self.$confirmDateIsHidden)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        cartaPortes.forEach { carta in
            
            let merchDiv = Div()
            
            carta.merchandise.forEach { merch in
                merchDiv.appendChild(Label("Descripción").color(.gray).fontSize(16.px))
                merchDiv.appendChild(Div(merch.description).fontSize(20.px))
                merchDiv.appendChild(Label("Origen").color(.gray).fontSize(16.px))
                merchDiv.appendChild(Div(merch.fromStoreName).fontSize(20.px))
                merchDiv.appendChild(Label("Destino").color(.gray).fontSize(16.px))
                merchDiv.appendChild(Div(merch.toStoreName).fontSize(20.px))
                merchDiv.appendChild(Div().class(.clear).margin(all: 3.px))
            }
            
            let locationDiv = Div()
            
            carta.locations.forEach { loc in
                
                locationDiv.appendChild(Label("Tipo / Nombre").color(.gray).fontSize(16.px))
                locationDiv.appendChild(Div("\(loc.placementType.description) / \(loc.storeName)").fontSize(20.px))
                locationDiv.appendChild(Label("Estado").color(.gray).fontSize(16.px))
                locationDiv.appendChild(Div("\(loc.state.description) \(loc.zipCode)").fontSize(20.px))
                locationDiv.appendChild(Div().class(.clear).margin(all: 3.px))
            }
            
            let view = Div {
                Div {
                    
                    Div{
                        merchDiv
                    }
                    .custom("width", "calc(50% - 4px)")
                    .marginRight(7.px)
                    .float(.left)
                    
                    Div{
                        locationDiv
                    }
                    .custom("width", "calc(50% - 4px)")
                    .float(.left)
                    
                    Div().class(.clear)
                    
                }
            }
                .class(.uibtnLarge)
                .width(97.percent)
                .onClick {
                    self.selectCartaPorte(cartaPorte: carta)
                }
            
            cartaPortesView.appendChild(view)
            
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        
    }
    
    func selectCartaPorte(cartaPorte: FiscalCartaPorte) {
        
        selectedCartaPorte = cartaPorte
        
        confirmDateIsHidden = false
        
        cartaPorte.locations.forEach { location in
            
            let date = getDate(nil)
            
            @State var day = date.dateStamp
            
            @State var time = date.time
             
            dateDayRefence[location.placementId] = $day
            
            dateTimeRefence[location.placementId] = $time
            
            var dateTag = "Fecha de salida"
            
            var hourTag = "Hora de salida"
            
            if location.placementType == .destino {
                dateTag = "Fecha de llegada"
                hourTag = "Hora de llegada"
            }
            
            dateConfirmView.appendChild(H2("Tienda \(location.storeName)").color(.white))
            
            dateConfirmView.appendChild(Div{
                Label(dateTag)
                    .fontSize(23.px)
                    .color(.gray)
                
                Div{
                    InputText($day)
                        .custom("width","calc(100% - 24px)")
                        .class(.textFiledBlackDark)
                        .placeholder("DD/MM/AAAA")
                        .height(31.px)
                        .onFocus({ tf in
                            tf.select()
                        })
                    
                }
            }.class(.section))
            
            dateConfirmView.appendChild(Div{
                Label(hourTag)
                    .fontSize(23.px)
                    .color(.gray)
                
                Div{
                    InputText($time)
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark)
                    .placeholder("HH:MM")
                    .height(31.px)
                    .onFocus({ tf in
                        tf.select()
                    })
                }
            }.class(.section))
            
            dateConfirmView.appendChild(Div().class(.clear).height(7.px))
            
        }
        
    }
    
    
    func addCartaPorte(){
        
        guard var selectedCartaPorte else {
            showError(.generalError, "No se seleccion carta porte")
            return
        }
        
        var locations: [FiscalLocationItem] = []
        
        var hasError = false
        
        selectedCartaPorte.locations.forEach { loc in
            
            var location = loc
            
            guard let date = dateDayRefence[loc.placementId]?.wrappedValue else {
                showError(.generalError, "No se localizo nueva fecha")
                hasError = true
                return
            }
            
            guard let time = dateTimeRefence[loc.placementId]?.wrappedValue else {
                showError(.generalError, "No se localizo nueva fecha")
                hasError = true
                return
            }
            
            guard let uts = parseDate(date: date, time: time) else{
                hasError = true
                return
            }
            
            location.uts = uts
            
            locations.append(location)
            
        }
        
        if hasError {
            return
        }
        
        selectedCartaPorte.locations = locations
        
        self.callback(selectedCartaPorte)
        
        self.remove()
        
    }
    
}

