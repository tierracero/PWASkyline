//
//  StoreItemTierView.swift
//  
//
//  Created by Victor Cantu on 1/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class StoreItemTierView: Div {
    
    override class var name: String { "div" }
    
    ///dep, cat, line, main, all
    let type: CustProductType
    let dep: UUID
    let cat: UUID?
    let line: UUID?
    @State var tierName: String
    @State var icon: String
    @State var coverLandscape: String
    @State var coverPortrait: String
    
    private var open: ((
        _ isEdited: Bool,
        _ id: UUID,
        _ tierName: String
    ) -> ())
    
    
    init(
        type: CustProductType,
        dep: UUID,
        cat: UUID?,
        line: UUID?,
        tierName: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        open: @escaping ((
            _ isEdited: Bool,
            _ id: UUID,
            _ tierName: String
        ) -> ())
    ) {
        self.type = type
        self.dep = dep
        self.cat = cat
        self.line = line
        self.tierName = tierName
        self.icon = icon
        self.coverLandscape = coverLandscape
        self.coverPortrait = coverPortrait
        self.open = open
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var avatar = Img()
        .src("/skyline/media/512.png")
        .borderRadius(all: 12.px)
        .paddingRight(7.px)
        .objectFit(.cover)
        .height(35.px)
        .width(35.px)
        .float(.left)
    
    @DOM override var body: DOM.Content {
        
        self.avatar
        
        Div(self.$tierName)
            .custom("width", "calc(100% - 70px)")
            .class(.oneLineText)
            .float(.left)
        
        Div {
            Img()
                .src("/skyline/media/pencil.png")
                .paddingRight(7.px)
                .class(.toolItem)
                .marginTop(7.px)
                .height(18.px)
                .width(18.px)
                .onClick { _, event in
                    
                    switch self.type {
                    case .dep:
                        
                        loadingView(show: true)
                        
                        API.custAPIV1.getStoreDepartement(id: self.dep) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else{
                                showError(.errorDeCommunicacion, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else{
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            guard let payload = resp.data else {
                                showError(.unexpectedResult, "No se puede obtener payload")
                                return
                            }
                            
                            let view = CreateStoreLevelDepartement(
                                dep: payload
                            ) { id, name in
                                
                                self.tierName = name
                                
                                self.open( true, self.dep, self.tierName)
                            } deleted: {
                                self.remove()
                            } changeAvatar: { id, url in
                                self.avatar.load(url)
                            }
                            
                            addToDom(view)
                            
                        }
                        
                    case .cat:
                        
                        guard let cat = self.cat else {
                            return
                        }
                        
                        loadingView(show: true)
                        
                        API.custAPIV1.getStoreCategory(id: cat) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else{
                                showError(.errorDeCommunicacion, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else{
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            guard let payload = resp.data else {
                                showError(.unexpectedResult, "No se puede obtener payload")
                                return
                            }
                            
                            let view = CreateStoreLevelCategoria(
                                cat: payload,
                                depid: self.dep,
                                depname: ""
                            ) { id, name in
                                
                                self.tierName = name
                                
                                self.open( true, self.dep, self.tierName)
                            } deleted: {
                                self.remove()
                            } changeAvatar: { id, url in
                                self.avatar.load(url)
                            }
                            
                            addToDom(view)
                            
                        }
                        
                    case .line:
                        
                        guard let lineid = self.line else {
                            return
                        }
                        
                        guard let catid = self.cat else {
                            return
                        }
                        
                        loadingView(show: true)
                        
                        API.custAPIV1.getStoreLine(id: lineid) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else{
                                showError(.errorDeCommunicacion, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else{
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            guard let payload = resp.data else {
                                showError(.unexpectedResult, "No se puede obtener payload")
                                return
                            }
                            
                            let view = CreateStoreLevelLine(
                                line: payload,
                                catid: catid,
                                catname: ""
                            ) { id, name in
                                self.tierName = name
                                self.open( true, self.dep, self.tierName)
                            } deleted: {
                                self.remove()
                            } changeAvatar: { id, url in
                                self.avatar.load(url)
                            }
                            
                            addToDom(view)
                            
                        }
                    case .main,  .all:
                        break
                    }
                    event.stopPropagation()
                }
        }
        .float(.left)
        
        Div().class(.clear)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        self.class(.rowItem, .hiddeToolItem)
        
        onClick {
            
            switch self.type{
            case .dep:
                self.open( false, self.dep, self.tierName)
            case .cat:
                guard let catid = self.cat else{
                    return
                }
                self.open( false, catid, self.tierName)
            case .line:
                guard let lineid = self.line else{
                    return
                }
                self.open( false, lineid, self.tierName)
            case .main,  .all:
                break
            }
            
        }
        
        if !coverLandscape.isEmpty {
            self.avatar.load("https://\(custCatchUrl)/contenido/thump_\(coverLandscape)")
            
        }
        
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        
    }
    
    
}
