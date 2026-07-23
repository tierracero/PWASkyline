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
       .width(100.percent)
       .class(.textFiledBlackDark)
       .height(92.px)
    
    lazy var negativeButton = ULargeButton(self.type.negative)
    .width(100.percent)
    .custom("border", "1px solid rgba(255, 104, 96, 0.55)")
    .custom("color", "#ff8a82")
    .id("no")
    .onClick {
        self.processRresponse(isConfimed: false)
    }
    
    @DOM public override var body: DOM.Content {
        VPopUp(.fitContent(w: 620)) {
            VTitle(self.title) {
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

                        if self.comments != .notRequired {
                            UField(
                                "Ingrese comentario",
                                required: self.comments != .optional
                            ) {
                                self.reasonField
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
                        self.processRresponse(isConfimed: true)
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
                    showError(.requiredField, "Comentario Requerido")
                    return
                }
            case .requiredExemptFromHerk(let herk):
                if custCatchHerk < herk {
                    if self.reason.isEmpty {
                        showError(.requiredField, "Comentario Requerido")
                        return
                    }
                }
            case .requiredBothExemptFromHerk(let herk):
                if custCatchHerk < herk {
                    if self.reason.isEmpty {
                        showError(.requiredField, "Comentario Requerido")
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
                    showError(.requiredField, "Comentario Requerido")
                    return
                }
            case .requiredExemptFromHerk(_):
                break
            case .requiredBothExemptFromHerk(let herk):
                if custCatchHerk < herk {
                    if self.reason.isEmpty {
                        showError(.requiredField, "Comentario Requerido")
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
    

    public override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $reason.removeAllListeners()
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
