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
    
    lazy var negativeButton = ULargeButton(self.type.negative)
    .width(100.percent)
    .custom("border", "1px solid rgba(255, 104, 96, 0.55)")
    .custom("color", "#ff8a82")
    .id("no")
    .onClick {
        self.remove()
    }
    
    @DOM public override var body: DOM.Content {
        VPopUp(.fitContent(w: 620)) {
            VTitle(self.title, icon: "icon_alert.png") {
                USmallTitle("Confirmación")
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.full) {
                    VBox(.raised) {
                        UMinorTitle(self.message)
                            .fontSize(20.px)
                            .custom("line-height", "1.5")
                            .whiteSpace(.initial)

                        if self.requiersComment {
                            UField("Ingrese comentario") {
                                TextArea(self.$comment)
                                    .width(100.percent)
                                    .placeholder("Ingrese comentario")
                                    .height(100.px)
                            }
                            .marginTop(16.px)
                        }
                    }
                }

                if self.type != .ok {
                    VGrid(.half) {
                        self.negativeButton
                    }
                }

                VGrid(self.type == .ok ? .full : .half) {
                    ULargeButton(self.type.positive)
                    .width(100.percent)
                    .id("ok")
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
            }
        }
    }
    
    public override func buildUI() {
        
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if type == .ok {
            negativeButton.hidden(true)
        }
        
    }

    public override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $comment.removeAllListeners()
    }
}
