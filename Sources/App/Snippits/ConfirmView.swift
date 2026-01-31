//
//  ConfirmView.swift
//
//
//  Created by Victor Cantu on 3/17/22.
//

import Foundation
import TCFundamentals
import Web

@available(*, deprecated, message: "Use ConfirmationView")
public class ConfirmView: Div {
    
    public override class var name: String { "div" }
    
    let type: ConfirmViewButton
    
    let title: String
    
    let message: String
    
    let requiersComment: Bool
    
    private var callback: ((
        _ isConfirmed: Bool,
        _ comment: String
    ) -> ())?
    
    public init(
        type: ConfirmViewButton,
        title: String,
        message: String,
        requiersComment: Bool = false,
        callback: ((
            _ isConfirmed: Bool,
            _ comment: String
        ) -> ())? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.requiersComment = requiersComment
        self.callback = callback
        
        super.init()
    }
    
    public init(
        type: ConfirmViewButton,
        title: String,
        message: String,
        requiersComment: Bool = false,
        callback: @escaping ((
            _ isConfirmed: Bool,
            _ comment: String
        ) -> ())
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.requiersComment = requiersComment
        self.callback = callback
        
        super.init()
    }
    
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var comment = ""
    
    lazy var negativeButton = Div {
        Div {
            Strong(self.type.negative)
        }
        .padding(all: 7.px)
    }
    .id("no")
    .cursor(.pointer)
    .class(.redButton)
    .float(.left)
    .marginRight(10.px)
    .custom("width", "calc(50% - 5px)")
    .onClick {
        self.remove()
    }
    
    @DOM public override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.uiView4)
                .onClick{
                    //$keyUp.removeAllListeners()  CKME
                    self.remove()
                }
            
            H2(self.title)
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(7.px)
            
            P(self.message)
                .fontSize(32.px)
                .color(.black)
            
            Div()
                .class(.clear)
                .marginTop(7.px)
            
            if self.requiersComment {
                
                Div{
                    
                    Label("Ingrese Comentario")
                
                    Div().class(.clear).marginTop(7.px)
                    
                    TextArea(self.$comment)
                        .custom("width", "calc(100% - 14px)")
                        .placeholder("Ingrese comentario")
                        .padding(all: 7.px)
                        .fontSize(24.px)
                        .height(100.px)
                    
                }
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
            }
            
            
            Div{
                
                self.negativeButton
                
                Div{
                    Div{
                        Strong(self.type.positive)
                    }
                    .padding(all: 7.px)
                }
                .id("ok")
                .cursor(.pointer)
                .class(.greenButton)
                .float(.left)
                .custom("width", "calc(50% - 5px)")
                .onClick {
                    
                    if self.requiersComment && self.comment.isEmpty {
                        showError(.requiredField, "Comentario Requerido")
                        return
                    }
                    
                    if let callback = self.callback {
                        callback(true, self.comment)
                    }
                    
                    self.remove()
                }
            }
            
            Div()
                .class(.clear)
                .marginTop(12.px)
            
            
        }
        .custom("left", "calc(50% - 264px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 7.px)
        .width(500.px)
        .top(30.percent)
    }
    
    public override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if type == .ok {
            negativeButton.hidden(true)
        }
        
    }
}
