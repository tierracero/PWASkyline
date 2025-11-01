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
    
    @State var sectionName: String

    var relationType: API.custAPIV1.CreateBodegaRelationType

    // bodegaName: String,
    //     bodegaDescription: String,
    //     : String,
    //     relationType: ,

    private var callback: ((
        _ bodega: CustStoreBodegasSinc,
        _ seccion: CustStoreSeccionesQuickRef
    ) -> ())
    
    init(
        storeid: UUID,
        storeName: String,
        bodegaId: UUID?,
        bodegaName: String,
        bodegaDescription: String,
        sectionName: String,
        relationType: API.custAPIV1.CreateBodegaRelationType,
        callback: @escaping ((
            _ bodega: CustStoreBodegasSinc,
            _ seccion: CustStoreSeccionesQuickRef
        ) -> ())
    ) {
        self.storeid = storeid
        self.storeName = storeName
        self.bodegaId = bodegaId
        self.bodegaName = bodegaName
        self.bodegaDescription = bodegaDescription
        self.sectionName = sectionName
        self.relationType = relationType
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var newBodegaField = InputText(self.$bodegaName)
        .class(.textFiledBlackDark)
        .placeholder("Nombre de la nueva bodega")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp {
            self.checkSectionAvailability()
        }
    
    lazy var newBodegaDescriptionField = InputText(self.$bodegaDescription)
        .class(.textFiledBlackDark)
        .placeholder("Descripcion, que va a incluir.")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onEnter { tf in
            self.saveBodega()
        }
    
    lazy var newSeccionField = InputText(self.$sectionName)
        .class(.textFiledBlackDark)
        .placeholder("Nombre la primera seccion")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp {
            self.checkSectionAvailability()
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
                 
                H2("Crear Bodega")
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
                
                Label("Nueva Bodega")
                    .fontSize(18.px)
                    .color(.gray)
                
                Div{
                    self.newBodegaField
                }
            }
            .class(.section)
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                Label("Descripcion")
                    .fontSize(18.px)
                    .color(.gray)
                
                Div{
                    self.newBodegaDescriptionField
                }
            }
            .class(.section)
            
            
            Div().class(.clear).height(7.px)

            Div{
                
                Label("Seccion")
                    .fontSize(18.px)
                    .color(.gray)
                
                Div{
                    self.newSeccionField
                }
            }
            .class(.section)
            .hidden(self.$bodegaId.map { $0 != nil})
            
            Div().class(.clear).height(7.px)
            .hidden(self.$bodegaId.map { $0 != nil})
            
            Div{
                Div(self.$bodegaId.map{ ($0 == nil) ? "Crear Bodega" : "Guardar Datos"} )
                .class(.uibtnLargeOrange)
                .onClick {
                    self.saveBodega()
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
        
        let term: String = self.bodegaName.purgeSpaces.pseudo.capitalizingFirstLetters()

        if term.count < 2 {
            return
        }

        newBodegaField.removeClass(.isOk)
        newBodegaField.removeClass(.isNok)
        newBodegaField.class(.isLoading)

        API.custAPIV1.bodegaNameAvalability(
            storeId: storeid,
            bodegaId: bodegaId,
            name: term
        ) { resp in

            self.newBodegaField.removeClass(.isLoading)

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
                    self.newBodegaField.class(.isOk)
                }
                else{
                    self.newBodegaField.class(.isNok)
                }

            }
        }
    }
    
    func saveBodega(){
        
        let name = self.bodegaName.purgeSpaces.pseudo.capitalizingFirstLetters()
        
        if name.count < 3 {
            newBodegaField.select()
            return
        }
        
        let description = self.bodegaDescription.purgeSpaces
        
        loadingView(show: true)
        
        if let bodegaId {
           
            API.custAPIV1.saveBodegaDetails(
                id: bodegaId,
                name: name
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
                
            }
            

        }
        else {

            let sectionName = sectionName.purgeSpaces

            if sectionName.isEmpty {
                showError(.campoRequerido, "Ingrese nombre de la seccion")
                newSeccionField.select()
                return
            }

            API.custAPIV1.createBodega(
                bodegaName: name,
                bodegaDescription: description,
                sectionName: sectionName,
                relationType: relationType
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
                
                guard let payload = resp.data else {
                    showError( .errorGeneral, .unexpenctedMissingPayload)
                    return
                }
                
                print("⭐️  bodega  ⭐️")

                bodegas[payload.bodega.id] = .init(
                    id: payload.bodega.id,
                    modifiedAt: payload.bodega.modifiedAt,
                    custStore: payload.bodega.custStore,
                    name: payload.bodega.name
                 )
                
                self.callback(
                    .init(
                        id: payload.bodega.id,
                        modifiedAt: payload.bodega.modifiedAt,
                        custStore: payload.bodega.custStore,
                        name: payload.bodega.name
                    ),
                    .init(
                        id: payload.section.id,
                        name: payload.section.name,
                        custStoreBodegas: payload.section.custStoreBodegas
                    )
                )
                
                self.remove()
            }

        
        }
    
    }

}