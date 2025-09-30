//
//  FiscResultView.swift
//
//
//  Created by Victor Cantu on 7/12/22.
//

import Foundation
import TCFundamentals
import Web

class FiscResultView: Div {
    
    override class var name: String { "div" }
    
    var type: FiscResultViewType
    
    var term: String
    
    var data: APISearchResultsGeneral
    
    private var callback: ((_ data: APISearchResultsGeneral) -> ())
    
    init(
        type: FiscResultViewType,
        term: String,
        data: APISearchResultsGeneral,
        callback: @escaping ((_ data: APISearchResultsGeneral) -> ())
    ) {
        
        self.type = type
        self.term = term
        self.data = data
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var textSpan = Span()
    
    @DOM override var body: DOM.Content {
        
        self.textSpan
            .color(.black)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        width(400.px)
        padding(all: 7.px)
        cursor(.pointer)
        onClick {
            self.callback(self.data)
        }
        
        backgroundColor(Color.rgba( 255, 253, 253, 97))
        border(width: .thin, style: .solid, color: .gray)
        id(Id(stringLiteral: "\(self.type.rawValue)_\(self.data.c)"))
        
        term = term.purgeSpaces
        
        if term.isEmpty {
            
            self.textSpan.appendChild(
                Span("\(self.data.c) \(self.data.v)")
                    .fontSize(18.px)
            )
        }
        else{
            
            let termParts = term.explode(" ")
            
            let valueParts = self.data.v.explode(" ")
            
            //partHasBeenAdded = false
            
            valueParts.forEach { _value in
                
                let value = _value.pseudo.lowercased()
                
                var hasBeenAdded = false
                
                termParts.forEach { _part in
                    
                    if hasBeenAdded { return }
                    
                    let part = _part.pseudo.lowercased()
                    
                    if value == part {
                        
                        hasBeenAdded = true
                        
                        self.textSpan.appendChild(
                            Strong("\(_value.uppercased()) ")
                                .fontSize(19.px)
                        )
                        
                    }
                    else if value.contains(part) {
                        
                        hasBeenAdded = true
                        
                        /// begins width
                        if value.hasPrefix(part) {
                            
                            /// we have removed the begining of the string
                            let str = value.replace(from: part, to: "")
                            
                            self.textSpan.appendChild(
                                Strong(part.uppercased())
                                    .fontSize(19.px)
                            )
                            
                            self.textSpan.appendChild(
                                Span("\(str) ")
                                    .fontSize(18.px)
                            )
                            
                        }
                        /// ends width
                        else if value.hasSuffix(part) {
                            
                            /// we have removed the ending of the string
                            let str = value.replace(from: part, to: "")
                            
                            self.textSpan.appendChild(
                                Span(str)
                                    .fontSize(18.px)
                            )
                            
                            self.textSpan.appendChild(
                                Strong("\(part.uppercased()) ")
                                    .fontSize(19.px)
                            )
                            
                        }
                        /// contains
                        else{
                            
                            let subparts = value.explode(part)
                            
                            if let subpart = subparts.first{
                                self.textSpan.appendChild(
                                    Span(subpart)
                                        .fontSize(18.px)
                                )
                            }
                            
                            self.textSpan.appendChild(
                                Strong(part.uppercased())
                                    .fontSize(19.px)
                            )
                            
                            if let subpart = subparts.last{
                                self.textSpan.appendChild(
                                    Span("\(subpart) ")
                                        .fontSize(18.px)
                                )
                            }
                        }
                    }
                }
                
                if !hasBeenAdded {
                    self.textSpan.appendChild(
                        Span("\(_value) ")
                            .fontSize(18.px)
                    )
                }
                
            }
        }
    }
}

extension FiscResultView {
    enum FiscResultViewType: String {
        case fiscCode
        case fiscUnit
    }
}
