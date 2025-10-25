//
//  CreateSectionView.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateBodegaView: Div {
    
    override class var name: String { "div" }
    
    let storeid: UUID
    
    let storeName: String
    
    @State var bodegaId: UUID?

    @State var bodegaName: String
    
    @State var bodegaDescription: String
    
    private var callback: ((
        _ section: CustStoreBodegasSinc
    ) -> ())
    
    init(
        storeid: UUID,
        storeName: String,
        bodegaId: UUID?,
        bodegaName: String,
        bodegaDescription: String,
        callback: @escaping ((
            _ section: CustStoreBodegasSinc
        ) -> ())
    ) {
        self.storeid = storeid
        self.storeName = storeName
        self.bodegaId = bodegaId
        self.bodegaName = bodegaName
        self.bodegaDescription = bodegaDescription
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var newSectionName = InputText(self.$bodegaName)
        .class(.textFiledBlackDark)
        .placeholder("Ingrese Nueva Seccion")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp {
            self.checkSectionAvailability()
        }
    
    lazy var newSectionDescription = InputText(self.$bodegaDescription)
        .class(.textFiledBlackDark)
        .placeholder("Descripcion, que va a incluir.")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onEnter { tf in
            self.createSection()
        }
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2("Crear Seccion")
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
            
            H2( self.storeName )
                .color(.white)
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                Label("Nueva Seccion")
                    .fontSize(18.px)
                    .color(.gray)
                
                Div{
                    self.newSectionName
                }
            }
            .class(.section)
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                Label("Descripcion")
                    .fontSize(18.px)
                    .color(.gray)
                
                Div{
                    self.newSectionDescription
                }
            }
            .class(.section)
            
            Div().class(.clear).height(7.px)
            
            Div{
                Div("Crear Seccion")
                .class(.uibtnLargeOrange)
                .onClick {
                    self.createSection()
                }
            }
            .align(.right)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func checkSectionAvailability(){
        
        let term: String = self.sectionName.purgeSpaces.pseudo.capitalizingFirstLetters()

        if term.count < 2 {
            return
        }

        newSectionName.removeClass(.isOk)
        newSectionName.removeClass(.isNok)
        newSectionName.class(.isLoading)
        
        API.custAPIV1.seccionNameAvalability(
            name: term,
            bodegaID: bodid,
            seccionID: nil
        ) { resp in

            self.newSectionName.removeClass(.isLoading)

            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }

            guard let payload = resp.data else {
                showError(.unexpectedResult, "no de obtuvo payload de respuesta, contacta a Soporte TC")
                return
            }

            if payload.term == term {

                if payload.free {
                    self.newSectionName.class(.isOk)
                }
                else{
                    self.newSectionName.class(.isNok)
                }

            }
        }
    }
    
    func createSection(){
        
        let name = self.sectionName.purgeSpaces.pseudo.capitalizingFirstLetters()
        
        if name.count < 3 {
            newSectionName.select()
            return
        }
        
        let description = self.sectionDescription.purgeSpaces
        
        loadingView(show: true)
        
        API.custAPIV1.createBodegaSection(
            name: name,
            description: description,
            store: storeid,
            bodega: bodid
        ) { resp in
            
            loadingView(show: false)

            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let section = resp.data else {
                showError( .errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            print("⭐️  seccion  ⭐️")
            
            print(section)
            
            self.callback(section)
            
            self.remove()
            
        }
        
    }
}
