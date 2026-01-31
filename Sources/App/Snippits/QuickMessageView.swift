//
//  QuickMessageView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

class QuickMessageView: Div {
    
    override class var name: String { "div" }
    
    let style: StyleType
    let order: CustOrderLoadFolios
    var notes: [CustOrderLoadFolioNotes]
    private var callback: ((_ note: CustOrderLoadFolioNotes) -> ())
    
    init(
        style: StyleType,
        order: CustOrderLoadFolios,
        notes: [CustOrderLoadFolioNotes],
        callback: @escaping ((_ note: CustOrderLoadFolioNotes) -> ())
    ) {
        self.style = style
        self.order = order
        self.notes = notes
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var loader = Div {
        Div{
            Div()
            Div()
            Div()
            Div()
        }
        .class(.ldsRing)
        .position(.absolute)
        .custom("top","calc(50% - 40px)")
        .custom("left","calc(50% - 40px)")
    }
    .position(.absolute)
    .top(0.px)
    .left(0.px)
    .width(100.percent)
    .height(100.percent)
    .backgroundColor(.transparentBlack)
    .borderRadius(all: 24.px)
    .hidden(self.$loaderIsHidden)
    
    @State var loaderIsHidden = false
     
    lazy var grid = Div()
    
    @State var _lcm: MessagingCommunicationMethods? = nil
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .closeButton(.uiView1)
                .onClick{
                    self.remove()
                }
            
            H1("Enviar Comentario")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
            
            self.grid
                .custom("height", "calc(100% - 45px)")
            
            self.loader
            
    }
        .padding(all: 12.px)
        .width(40.percent)
        .height(50.percent)
        .position(.absolute)
        .left(30.percent)
        .top(25.percent)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
    
    }
    
    override func buildUI() {
        super.buildUI()
        
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        top(0.px)
        left(0.px)
        onClick { clic, event in
            event.stopPropagation()
        }
        
        if !self.notes.isEmpty {
            
            let mg = MessageGrid(
                style: self.style,
                orderid: self.order.id,
                accountid: self.order.custAcct,
                folio: self.order.folio,
                name: self.order.name,
                mobile: self.order.mobile,
                notes: self.notes,
                lastCommunicationMethod: self.$_lcm,
                callback: { note in
                    self.callback(note)
                })
            
            self.grid.appendChild(mg    )
            
            mg.messageInput.select()
            
            self.loaderIsHidden =  true
        }
        else{
            
            API.custOrderV1.getNotes(accountId: self.order.id) { resp in
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let notes = resp.data?.notes else {
                    showError(.generalError, .unexpenctedMissingPayload)
                    return
                }
                
                self.notes = notes
                
                let mg = MessageGrid(
                    style: self.style,
                    orderid: self.order.id,
                    accountid: self.order.custAcct,
                    folio: self.order.folio,
                    name: self.order.name,
                    mobile: self.order.mobile,
                    notes: self.notes,
                    lastCommunicationMethod: self.$_lcm
                ) { note in
                    self.callback(note)
                }
            
                self.grid.appendChild(mg)
                
                mg.messageInput.select()
                
                self.loaderIsHidden = true
                
            }
            
        }
    }
}
