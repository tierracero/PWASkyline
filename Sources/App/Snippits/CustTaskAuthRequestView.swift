//
//  CustTaskAuthRequestView.swift
//  
//
//  Created by Victor Cantu on 5/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CustTaskAuthRequestView: Div {
    
    override class var name: String { "div" }
    
    let task: CustTaskAuthorizationManagerQuick
    
    init(
        task: CustTaskAuthorizationManagerQuick
    ) {
        self.task = task
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        
                        if self.task.alertType == .changePrice {
                            
                            loadingView(show: true)
                            
                            API.custAPIV1.CTAMResolve(
                                alertid: self.task.id,
                                action: .denied,
                                responseMessage: ""
                            ) { resp in
                                
                                loadingView(show: false)
                            
                                guard resp != nil else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }
                                
                                self.remove()
                                
                                
                            }
                            
                        }
                        else {
                            self.remove()
                        }
                        
                    }
                 
                H2("Autorizacion Requerida")
                    .color(.lightBlueText)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                
            }
            .paddingBottom(3.px)
            
            H3(self.task.alertType.sectionName)
                .color(.lightBlueText)
            
            Div().class(.clear).height(7.px)
            
            CustTaskAuthorizationRow(
                task: self.task
            ){
                self.remove()
            }
            
            Div().class(.clear).height(7.px)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
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
        top(0.px)
        left(0.px)
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
