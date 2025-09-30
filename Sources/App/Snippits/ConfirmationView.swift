//
//  ConfirmationView.swift
//
//
//  Created by Victor Cantu on 10/27/23.
//

import Foundation
import TCFundamentals
import Web

public class ConfirmationView: Div {
    
    public override class var name: String { "div" }
    
    public let type: ConfirmViewButton
    
    public let title: String
    
    public let message: String
    
    public let comments: CommentsRequireType
    
    private var callback: ((
        _ isConfirmed: Bool,
        _ comment: String
    ) -> ())?
    
    public init(
        type: ConfirmViewButton,
        title: String,
        message: String,
        comments: CommentsRequireType = .notRequired,
        callback: @escaping((
            _ isConfirmed: Bool,
            _ comment: String
        ) -> ())
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.comments = comments
        self.callback = callback
        
        super.init()
    }
    
    public init(
        type: ConfirmViewButton,
        title: String,
        message: String,
        comments: CommentsRequireType = .notRequired
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.comments = comments
        self.callback = nil
        
        super.init()
    }
    
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var reason = ""
    
    lazy var reasonField = TextArea(self.$reason)
       .placeholder("Ingrese razon por el cambio.")
       .custom("width","calc(100% - 24px)")
       .class(.textFiledBlackDark)
       .height(70.px)
       .height(31.px)
    
    lazy var negativeButton = Div {
        Div {
            Strong(self.type.negative)
        }
        .padding(all: 7.px)
    }
    .custom("width", "calc(50% - 5px)")
    .marginRight(10.px)
    .class(.redButton)
    .cursor(.pointer)
    .float(.left)
    .id("no")
    .onClick {
        self.processRresponse(isConfimed: false)
    }
    
    @DOM public override var body: DOM.Content {
        
        Div{
            Div{
                
                
                Img()
                    .closeButton(.uiView4)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.title)
                    .color(.lightBlueText)
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
                P(self.message)
                    .fontSize(32.px)
                    .color(.white)
                
                Div()
                    .class(.clear)
                    .marginTop(7.px)
                
                if self.comments != .notRequired {
                    
                    Div{
                        
                        Label("Ingrese Comentario")
                    
                        Div().class(.clear).marginTop(7.px)
                        
                        self.reasonField
                        
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
                    .custom("width", "calc(50% - 5px)")
                    .class(.greenButton)
                    .cursor(.pointer)
                    .float(.left)
                    .id("ok")
                    .onClick {
                        self.processRresponse(isConfimed: true)
                    }
                }
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
            }
            .margin(all: 7.px)
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
        
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
    
    func processRresponse(isConfimed: Bool) {
        
        /// Porcess positive answer
        if isConfimed {
            
            switch comments{
            case .notRequired:
                break
            case .optional:
                break
            case .required,.requiredBoth:
                if self.reason.isEmpty {
                    showError(.campoRequerido, "Comentario Requerido")
                    return
                }
            case .requiredExemptFromHerk(let herk):
                if custCatchHerk < herk {
                    if self.reason.isEmpty {
                        showError(.campoRequerido, "Comentario Requerido")
                        return
                    }
                }
            case .requiredBothExemptFromHerk(let herk):
                if custCatchHerk < herk {
                    if self.reason.isEmpty {
                        showError(.campoRequerido, "Comentario Requerido")
                        return
                    }
                }
            }
            
            if let callback = self.callback {
                callback(isConfimed, self.reason)
            }
        }
        /// Porcess negative answer
        else {
            
            switch comments{
            case .notRequired:
                break
            case .optional:
                break
            case .required:
                break
            case .requiredBoth:
                if self.reason.isEmpty {
                    showError(.campoRequerido, "Comentario Requerido")
                    return
                }
            case .requiredExemptFromHerk(_):
                break
            case .requiredBothExemptFromHerk(let herk):
                if custCatchHerk < herk {
                    if self.reason.isEmpty {
                        showError(.campoRequerido, "Comentario Requerido")
                        return
                    }
                }
            }
            
            if let callback = self.callback {
                callback(isConfimed, self.reason)
            }
        }
        
        self.remove()
    }
    
}

extension ConfirmationView {
    
    public enum CommentsRequireType: Equatable {
        
        case notRequired
        
        case optional
        
        /// Requeires comment if positive answer
        case required
        
        /// Requeires comment if positive or negative answer
        case requiredBoth
        
        /// Requeires comment if positive answer
        case requiredExemptFromHerk(Int)
        
        /// Requeires comment if positive or negative answer
        case requiredBothExemptFromHerk(Int)
    }
    
}
