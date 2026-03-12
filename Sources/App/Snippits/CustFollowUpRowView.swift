//
//  CustFollowUpRowView.swift
//
//
//  Created by Victor Cantu on 3/10/26.
//

import Foundation
import TCFundamentals
import Web

class CustFollowUpRowView: Div {
    
    override class var name: String { "div" }
    
    let data: CustFollowUp
    
    private var callback: () -> Void
    
    @State var createdByLabel = "..."
    
    @State var currentUserLabel = "..."
    
    var typeLabel = ""
    
    var statusLabel = ""
    
    var createdAtLabel = "..."
    
    var elapsedLabel = "..."
    
    var closedAtLabel = ""
    
    lazy var dateView = Div()
    
    init(
        _ data: CustFollowUp,
        callback: @escaping () -> Void
    ) {
        self.data = data
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div {
                H2(self.typeLabel)
                
                Div(self.statusLabel)
                    .class(.oneLineText)
                    .paddingTop(3.px)
                
                if !self.closedAtLabel.isEmpty {
                    Div(self.closedAtLabel)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)
                }
            }
            .color(.white)
            .align(.center)
            .float(.left)
            .width(90.px)
            
            Div {
                Div {
                    Span(self.createdAtLabel)
                        .paddingRight(7.px)
                    
                    Strong(self.elapsedLabel)
                        .color(.black)
                    
                    Strong(self.data.interest.documentableName)
                        .float(.right)
                }
                .color(.gray)
                
                Div(self.data.comment.replace(from: "\n", to: " "))
                    .class(.oneLineText)
                    .marginBottom(3.px)
                    .fontWeight(.bolder)
                    .fontSize(24.px)
                    .marginTop(3.px)
                
                Div {
                    Span(self.$createdByLabel)
                        .color(.grayBlack)
                        .marginRight(7.px)
                    
                    Span(self.$currentUserLabel)
                        .color(.gray)
                }
                .class(.oneLineText)
                .marginBottom(3.px)
                .fontSize(16.px)
                
                if let lostReason = self.data.lostReason {
                    Div(lostReason.rawValue)
                        .class(.oneLineText)
                        .fontSize(16.px)
                        .color(.gray)
                }
            }
            .custom("width", "calc(100% - 145px)")
            .float(.left)
            .class(.smallButtonBox)
            .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.77))
            
            Div {
                Div(self.data.type.documentableName)
                    .class(.twoLineText)
                    .fontSize(20.px)
                    .color(.black)
                
                self.dateView
                    .fontSize(18.px)
                    .class(.oneLineText)
            }
            .align(.right)
            .float(.right)
            .width(125.px)
            
            Div().class(.clear)
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.smallButtonBox)
        
        switch self.data.status {
        case .open:
            backgroundColor(.folioRowDefaultColor)
        case .successful:
            backgroundColor(.green)
        case .closed:
            backgroundColor(.gray)
        }
        
        onClick {
            self.callback()
        }
        
        typeLabel = self.data.type.documentableName
        statusLabel = self.data.status.rawValue.uppercased()
        
        let createdDate = getDate(self.data.createdAt)
        createdAtLabel = createdDate.formatedLong
        elapsedLabel = orderTimeMesure(uts: self.data.createdAt, type: .createdAt).timeString
        
        if let closedAt = self.data.closedAt {
            let date = getDate(closedAt)
            closedAtLabel = date.formatedLong
        }
        
        if let nextDateAt = self.data.nextDateAt {
            let calc = orderTimeMesure(uts: nextDateAt, type: .date)
            
            let view = Div(calc.timeString)
                .fontSize(24.px)
            
            switch calc.color {
            case .blue:
                break
            case .green:
                view.color(.green)
            case .orange:
                view.color(.orange)
            case .red:
                view.color(.red)
            }
            
            self.dateView = view
        }
        else {
            self.dateView = Div("Sin fecha")
                .fontSize(18.px)
                .color(.gray)
        }
        
        getUserRefrence(id: .id(self.data.createdBy)) { user in
            guard let user else {
                return
            }
            
            self.createdByLabel = user.username.explode("@").first ?? user.firstName
        }
        
        getUserRefrence(id: .id(self.data.currentUser)) { user in
            guard let user else {
                return
            }
            
            self.currentUserLabel = user.username.explode("@").first ?? user.firstName
        }
    }
}
