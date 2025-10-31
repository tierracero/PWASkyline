//
//  StoreItemPOCView.swift
//  
//
//  Created by Victor Cantu on 1/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class StoreItemPOCView: Div {
    
    override class var name: String { "div" }
    
    let searchTerm: String
    
    let poc: SearchPOCResponse
    
    private var callback: ((
        _ update: @escaping (
            _ title: String,
            _ subTitle: String,
            _ price: Int64,
            _ avatar: String,
            _ reqSeries: Bool
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
                _ avatar: String,
                _ reqSeries: Bool
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
        .class(.oneLineText)
    
    lazy var detailView = Div()
        .class(.oneLineText)
    
    @State var price: Int64 = 0
    
    @DOM override var body: DOM.Content {
        avatar
            .src("/skyline/media/512.png")
            .borderRadius(all: 12.px)
            .marginRight(7.px)
            .objectFit(.cover)
            .height(50.px)
            .width(50.px)
            .float(.left)
        
        Div{
            
            self.nameView
            
            self.detailView
            
        }
            .custom("width", "calc(100% - 200px)")
            .class(.oneLineText)
            .marginRight(7.px)
            .float(.left)
        
        Div{
            Div(self.$price.map{ $0.formatMoney })
                .class(.oneLineText)
                .marginTop(12.px)
                .color(.white)
        }
        .class(.oneLineText)
        .width(130.px)
        .align(.right)
        .float(.left)
        
        Div().class(.clear)
        
    }
    
    override func buildUI() {
        super.buildUI()
        self.class(.rowItem, .hiddeToolItem)
        margin(all: 7.px)
        
        onClick {
            
            self.callback { title, subTitle, price, avatar, reqSeries in
                
                self.nameView.innerHTML = ""
                
                self.detailView.innerHTML = ""
                
                self.nameView.appendChild(
                    Span(title)
                        .fontSize(22.px)
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
                            .fontSize(24.px)
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
                                .fontSize(24.px)
                        )
                        
                        self.nameView.appendChild(
                            Span("\(str) ")
                                .fontSize(22.px)
                                .color(.gray)
                        )
                        
                    }
                    /// ends width
                    else if value.hasSuffix(part) {
                        
                        /// we have removed the ending of the string
                        let str = value.replace(from: part, to: "")
                        
                        self.nameView.appendChild(
                            Span(str)
                                .fontSize(22.px)
                                .color(.gray)
                        )
                        
                        self.nameView.appendChild(
                            Strong("\(part.uppercased()) ")
                                .fontSize(24.px)
                        )
                        
                    }
                    /// contains
                    else{
                        
                        let subparts = value.explode(part)
                        
                        if let subpart = subparts.first{
                            self.nameView.appendChild(
                                Span(subpart)
                                    .fontSize(22.px)
                                    .color(.gray)
                            )
                        }
                        
                        self.nameView.appendChild(
                            Strong(part.uppercased())
                                .fontSize(24.px)
                        )
                        
                        if let subpart = subparts.last{
                            self.nameView.appendChild(
                                Span("\(subpart) ")
                                    .fontSize(22.px)
                                    .color(.gray)
                            )
                        }
                    }
                }
            }
            
            if !hasBeenAdded {
                self.nameView.appendChild(
                    Span("\(_value) ")
                        .fontSize(22.px)
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
                            .fontSize(22.px)
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
                                .fontSize(22.px)
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
                                .fontSize(22.px)
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
                                .fontSize(22.px)
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
