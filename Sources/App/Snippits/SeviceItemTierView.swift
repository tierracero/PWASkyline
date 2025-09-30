//
//  SeviceItemTierView.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SeviceItemTierView: Div {
    
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
    
    @DOM override var body: DOM.Content {
        Img()
            .src("/skyline/media/512.png")
            .borderRadius(all: 12.px)
            .paddingRight(7.px)
            .objectFit(.cover)
            .height(35.px)
            .width(35.px)
            .float(.left)
        
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
                        
                        API.custSOCV1.getDepartment(depid: self.dep) { resp in
                            
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
                            
                            let view = CreateServiceLevelDepartement(
                                dep: payload
                            ) { id, name in
                                
                                self.tierName = name
                                
                                self.open( true, self.dep, self.tierName)
                            }
                            
                            addToDom(view)

                            
                        }
                        
                    case .cat:
                        /*
                        guard let cat = self.cat else {
                            return
                        }
                        */
                        showError(.errorGeneral, "La edicion de \(self.type.description) [seccion] aun no es soportado, contacte a soporte TC")
                        
                    case .line:
                        /*
                        guard let lineid = self.line else {
                            return
                        }
                        
                        guard let catid = self.cat else {
                            return
                        }
                        */
                        showError(.errorGeneral, "La edicion de \(self.type.description) [seccion] aun no es soportado, contacte a soporte TC")
                        
                    case .main, .all:
                        
                        showError(.errorGeneral, "La edicion de \(self.type.description) [seccion] aun no es soportado, contacte a soporte TC")
                        
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
                /*
                guard let catid = self.cat else{
                    return
                }
                 */
                showError(.errorGeneral, "La manipulacion de \(self.type.description) [seccion] aun no es soportado, contacte a soporte TC")
            case .line:
                /*
                guard let lineid = self.line else{
                    return
                }
                 */
                showError(.errorGeneral, "La manipulacion de \(self.type.description) [seccion] aun no es soportado, contacte a soporte TC")
            case .main,  .all:
                showError(.errorGeneral, "La manipulacion de \(self.type.description) [seccion] aun no es soportado, contacte a soporte TC")
            }
            
        }
        
    }
    
    
    
}


