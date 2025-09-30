//
//  SelectNewOrderTypeView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web
import TCFundamentals

class SelectNewOrderTypeView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((_ orderType: CustOrderProfiles?) -> ())
    
    init(
        callback: @escaping ((_ orderType: CustOrderProfiles?) -> ())
    ) {
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.view)
                .onClick{
                    //SkylineApp.current.$keyUp.removeAllListeners()
                    self.callback(nil)
                    self.remove()
                }
            
            H2("Selcione tipo de orden")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(3.px)
            
            Div("Orden de Renta")
            .fontSize(36.px)
            .align(.center)
            .class(.largeButtonBox)
            .hidden({ !configStoreProcessing.moduleProfile.contains(.rental) }())
            .onClick(self.startNewRental)
            
            Div()
                .class(.clear)
                .marginTop(12.px)
                .hidden({ !configStoreProcessing.moduleProfile.contains(.rental) }())
            
            Div("Orden de Servicio")
            .fontSize(36.px)
            .align(.center)
            .class(.largeButtonBox)
            .hidden({ !configStoreProcessing.moduleProfile.contains(.order) }())
            .onClick(self.startNewOrder)
            
            Div()
                .class(.clear)
                .marginTop(12.px)
                .hidden({ !configStoreProcessing.moduleProfile.contains(.order) }())
            
        }
        .padding(all: 12.px)
        .width(40.percent)
        .position(.absolute)
        .left(30.percent)
        .top(30.percent)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        /*
        moño corbata corbaton fajin camisa patanlon chaleco  chaznet frack smokin
         
         saco
            saco slim pantalosn smil  saco recto saco vaquero pantalons vaquero
         
         minimo una semana con aticipacion
         
         1) dos imprimen la agensa del dia
          
        
        
        SkylineApp.current.$keyUp.listen {
            if $0 == "r" {
                self.startNewRental()
            }
            else if $0 == "s"{
                self.startNewOrder()
            }
        }
         */
    }
    
    func startNewRental(){
        self.callback(.rental)
        self.remove()
        //SkylineApp.current.$keyUp.removeAllListeners()
    }
    
    func startNewOrder(){
        self.callback(.order)
        self.remove()
        //SkylineApp.current.$keyUp.removeAllListeners()
    }
    
}

