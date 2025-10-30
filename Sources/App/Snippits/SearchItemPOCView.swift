//
//  SearchItemPOCView.swift
//  
//
//  Created by Victor Cantu on 9/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SearchItemPOCView: Div {
    
    override class var name: String { "div" }
    
    let searchTerm: String
    
    let poc: SearchPOCResponse
    
    private var callback: ((
        _ update: @escaping (
            _ title: String,
            _ subTitle: String,
            _ price: Int64,
            _ avatar: String
        ) -> (),
        _ deleted: @escaping (
        ) -> ()
    ) -> ())
    
    init(
        searchTerm: String,
        poc: SearchPOCResponse,
        callback: @escaping ((
            _ update: @escaping (
                _ title: String,
                _ subTitle: String,
                _ price: Int64,
                _ avatar: String
            ) -> (),
            _ deleted: @escaping (
            ) -> ()
        ) -> ())
    ) {
        self.searchTerm = searchTerm
        self.poc = poc
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var avatar = Img()
    
    lazy var nameView = Div()
        .custom("width", "calc(100% - 130px)")
        .class(.twoLineText)
        .float(.left)
    
    lazy var detailView = Div()
        .class(.twoLineText)
    
    @State var price: Int64 = 0
    
    @DOM override var body: DOM.Content {
        avatar
            .src("/skyline/media/512.png")
            .borderRadius(all: 12.px)
            .marginRight(7.px)
            .objectFit(.cover)
            .height(100.px)
            .width(100.px)
            .float(.left)
        
        Div{
            Div{
                
                self.nameView
                
                Div{
                    Div(self.$price.map{ $0.formatMoney })
                        .class(.oneLineText)
                        .color(.white)

                        if let count = self.poc.units {
                            Div("#\(count.toString)")
                            .class(.oneLineText)
                            .fontSize(18.px)
                            .color(.darkOrange)
                            .marginTop(3.px)
                        }
                }
                .class(.oneLineText)
                .width(130.px)
                .align(.right)
                .float(.right)
                
                Div().clear(.both)
            }
            
            self.detailView
            
        }
            .custom("width", "calc(100% - 115px)")
            .marginRight(7.px)
            .float(.left)
        
        Div().class(.clear)
        
    }
    
    override func buildUI() {
        super.buildUI()
        custom("width", "calc(50% - 20px)")
        self.class(.rowItem)
        margin(all: 3.px)
        float(.left)
        onClick {
            
            self.callback { title, subTitle, price, avatar in
                
                self.nameView.innerHTML = ""
                
                self.detailView.innerHTML = ""
                
                self.nameView.appendChild(
                    Span(title)
                        .fontSize(20.px)
                    )
                   
                self.detailView.appendChild(
                    Span(subTitle)
                        .fontSize(20.px)
                        .color(.gray)
                    )
                
                self.price = price
                
                if let pDir = customerServiceProfile?.account.pDir {
                    self.avatar
                        .load("https://intratc.co/cdn/\(pDir)/thump_\(avatar)")
                }
                
            }  _: {
                self.remove()
            }
            
        }
        
        self.price = poc.price
        
        if !poc.avatar.isEmpty {
            if let pDir = customerServiceProfile?.account.pDir {
                avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.avatar)")
            }
        }
        
        let termParts = searchTerm.explode(" ")
        
        var valueParts = self.poc.name.explode(" ")
        
        valueParts.forEach { _value in
            
            let value = _value.pseudo.lowercased()
            
            var hasBeenAdded = false
            
            termParts.forEach { _part in
                
                if hasBeenAdded { return }
                
                let part = _part.pseudo.lowercased()
                
                if value == part {
                    
                    hasBeenAdded = true
                    
                    self.nameView.appendChild(
                        Strong("\(_value.uppercased()) ")
                            .fontSize(22.px)
                    )
                    
                }
                else if value.contains(part) {
                    
                    hasBeenAdded = true
                    
                    /// begins width
                    if value.hasPrefix(part) {
                        
                        /// we have removed the begining of the string
                        let str = value.replace(from: part, to: "")
                        
                        self.nameView.appendChild(
                            Strong(part.uppercased())
                                .fontSize(22.px)
                        )
                        
                        self.nameView.appendChild(
                            Span("\(str) ")
                                .fontSize(20.px)
                                .color(.gray)
                        )
                        
                    }
                    /// ends width
                    else if value.hasSuffix(part) {
                        
                        /// we have removed the ending of the string
                        let str = value.replace(from: part, to: "")
                        
                        self.nameView.appendChild(
                            Span(str)
                                .fontSize(20.px)
                                .color(.gray)
                        )
                        
                        self.nameView.appendChild(
                            Strong("\(part.uppercased()) ")
                                .fontSize(22.px)
                        )
                        
                    }
                    /// contains
                    else{
                        
                        let subparts = value.explode(part)
                        
                        if let subpart = subparts.first{
                            self.nameView.appendChild(
                                Span(subpart)
                                    .fontSize(20.px)
                                    .color(.gray)
                            )
                        }
                        
                        self.nameView.appendChild(
                            Strong(part.uppercased())
                                .fontSize(22.px)
                        )
                        
                        if let subpart = subparts.last{
                            self.nameView.appendChild(
                                Span("\(subpart) ")
                                    .fontSize(20.px)
                                    .color(.gray)
                            )
                        }
                    }
                }
            }
            
            if !hasBeenAdded {
                self.nameView.appendChild(
                    Span("\(_value) ")
                        .fontSize(20.px)
                        .color(.gray)
                )
            }
            
        }
     
        valueParts = "\(self.poc.upc) \(self.poc.brand) \(self.poc.model)".purgeSpaces.explode(" ")
        
        valueParts.forEach { _value in
            
            let value = _value.pseudo.lowercased()
            
            var hasBeenAdded = false
            
            termParts.forEach { _part in
                
                if hasBeenAdded { return }
                
                let part = _part.pseudo.lowercased()
                
                if value == part {
                    
                    hasBeenAdded = true
                    
                    self.detailView.appendChild(
                        Strong("\(_value.uppercased()) ")
                            .fontSize(20.px)
                    )
                    
                }
                else if value.contains(part) {
                    
                    hasBeenAdded = true
                    
                    /// begins width
                    if value.hasPrefix(part) {
                        
                        /// we have removed the begining of the string
                        let str = value.replace(from: part, to: "")
                        
                        self.detailView.appendChild(
                            Strong(part.uppercased())
                                .fontSize(20.px)
                        )
                        
                        self.detailView.appendChild(
                            Span("\(str) ")
                                .fontSize(20.px)
                                .color(.gray)
                        )
                        
                    }
                    /// ends width
                    else if value.hasSuffix(part) {
                        
                        /// we have removed the ending of the string
                        let str = value.replace(from: part, to: "")
                        
                        self.detailView.appendChild(
                            Span(str)
                                .fontSize(20.px)
                                .color(.gray)
                        )
                        
                        self.detailView.appendChild(
                            Strong("\(part.uppercased()) ")
                                .fontSize(20.px)
                        )
                        
                    }
                    /// contains
                    else{
                        
                        let subparts = value.explode(part)
                        
                        if let subpart = subparts.first{
                            self.detailView.appendChild(
                                Span(subpart)
                                    .fontSize(20.px)
                                    .color(.gray)
                            )
                        }
                        
                        self.detailView.appendChild(
                            Strong(part.uppercased())
                                .fontSize(20.px)
                        )
                        
                        if let subpart = subparts.last{
                            self.detailView.appendChild(
                                Span("\(subpart) ")
                                    .fontSize(20.px)
                                    .color(.gray)
                            )
                        }
                    }
                }
            }
            
            if !hasBeenAdded {
                self.detailView.appendChild(
                    Span("\(_value) ")
                        .fontSize(20.px)
                        .color(.gray)
                )
            }
            
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
     
    }
    
}

