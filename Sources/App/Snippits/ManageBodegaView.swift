//
//  ManageBodegaView.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ManageBodegaView: Div {
    
    override class var name: String { "div" }
    
    var relationType: API.custAPIV1.CreateBodegaRelationType
    
    let relationName: String

    private var onCreate: ((
        _ bodega: CustStoreBodegasSinc,
        _ seccion: CustStoreSeccionesQuickRef?
    ) -> ())?

    private var onUpdate: ((
        _ name: String,
        _ description: String
    ) -> ())?
    
    init(
        relationType: API.custAPIV1.CreateBodegaRelationType,
        relationName: String,
        loadBy: LoadManageBodegaView,
        onCreate: @escaping(
            _ bodega: CustStoreBodegasSinc,
            _ seccion: CustStoreSeccionesQuickRef?
        ) -> ()
    ) {

        self.relationType = relationType
        self.relationName = relationName

        switch loadBy {
        case .createForConcession:
            self.sectionable = false
        case .createForStore:
            self.sectionable = true
        case .bodega(let payload):
            self.bodegaId = payload.bodega.id
            self.bodegaName = payload.bodega.name
            self.bodegaDescription = payload.bodega.description
            self.sectionable = payload.bodega.sectionable
        }

        self.onCreate = onCreate

        self.onUpdate =  nil
        
        super.init()
    }

    init(
        relationType: API.custAPIV1.CreateBodegaRelationType,
        relationName: String,
        loadBy: LoadManageBodegaView,
        onUpdate: @escaping ((
             _ name: String,
            _ description: String
        ) -> ())
    ) {

        self.relationType = relationType
        self.relationName = relationName

        switch loadBy {
        case .createForConcession:
            self.sectionable = false
        case .createForStore:
            self.sectionable = true
        case .bodega(let payload):
            self.bodegaId = payload.bodega.id
            self.bodegaName = payload.bodega.name
            self.bodegaDescription = payload.bodega.description
            self.sectionable = payload.bodega.sectionable
        }

        self.onCreate =  nil

        self.onUpdate = onUpdate

        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var bodegaId: UUID? = nil

    @State var bodegaName: String = ""
    
    @State var bodegaDescription: String = ""
    
    @State var sectionName: String = ""
    
    var sectionable: Bool = true

    lazy var newBodegaField = InputText(self.$bodegaName)
        .class(.textFiledBlackDark)
        .placeholder("Nombre de la nueva bodega")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onKeyUp {
            self.checkBodegaAvailability()
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
                 
                H2(self.$bodegaId.map{ ($0 == nil) ? "Crear Bodega" : "EditarBodega" })
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
            
            H2( self.relationName )
                .color(.white)
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                Label("Nombre")
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

            if self.sectionable {

                Div{
                    
                    Label("Seccion")
                        .fontSize(18.px)
                        .color(.gray)
                    
                    Div{
                        self.newSeccionField
                    }
                }
                .class(.section)
                
                Div().class(.clear).height(7.px)

            }

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
    
    func checkBodegaAvailability(){
        
        let term: String = self.bodegaName.purgeSpaces.pseudo.capitalizingFirstLetters()

        if term.count < 2 {
            return
        }

        newBodegaField.removeClass(.isOk)

        newBodegaField.removeClass(.isNok)

        newBodegaField.class(.isLoading)
        
        API.custAPIV1.bodegaNameAvalability(
            storeId: relationType.id,
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
                else {
                    self.newBodegaField.class(.isNok)
                }

            }

        }
        
    }

    func checkSectionAvailability(){

        newSeccionField.removeClass(.isOk)

        newSeccionField.removeClass(.isNok)

        newSeccionField.class(.isLoading)
        
        let name: String = self.sectionName.purgeSpaces.pseudo.capitalizingFirstLetters()

        if name.count < 2 {
            return
        }
        
        guard let bodegaId else {
            self.newSeccionField.class(.isOk)
            return 
        }

        API.custAPIV1.seccionNameAvalability(
            name: name,
            bodegaID: bodegaId,
            seccionID: nil
        ) { resp in

            self.newSeccionField.removeClass(.isLoading)

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

            if payload.term == name {

                if payload.free {
                    self.newSeccionField.class(.isOk)
                }
                else {
                    self.newSeccionField.class(.isNok)
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
                
                // self.callback(
                //     .init(
                //         id: payload.bodega.id,
                //         modifiedAt: payload.bodega.modifiedAt,
                //         custStore: payload.bodega.custStore,
                //         name: payload.bodega.name
                //     ),
                //     .init(
                //         id: payload.section.id,
                //         name: payload.section.name,
                //         custStoreBodegas: payload.section.custStoreBodegas
                //     )
                // )
                
                self.remove()
            }

        
        }
    
    }
}

extension ManageBodegaView {

    struct ViewPayload {

        let bodega: CustStoreBodegas

        let secciones: [CustStoreSeccionesQuick]
        
        init(
            bodega: CustStoreBodegas,
            secciones: [CustStoreSeccionesQuick]
        ) {
            self.bodega = bodega
            self.secciones = secciones
        }

    }

    enum LoadManageBodegaView {

        case createForConcession

        case createForStore

        case bodega(ViewPayload)
        
    }

    struct CallbackActionUpdate {

        let name: String
    
        let description: String
            
        init(
            name: String,
            description: String
        ) {
            self.name = name
            self.description = description
        }
    
    }

    struct CallbackActionCreate {

        let bodega: CustStoreBodegasSinc

        let section: CustStoreSeccionesQuickRef?

        init(
            bodega: CustStoreBodegasSinc,
            section: CustStoreSeccionesQuickRef?
        ) {
            self.bodega = bodega
            self.section = section
        }
    }
    
     enum CallbackAction {

        case update (CallbackActionUpdate)

        case create (CallbackActionCreate)
        
     }

}