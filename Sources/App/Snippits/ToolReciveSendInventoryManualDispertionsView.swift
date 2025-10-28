//
//  ToolReciveSendInventoryManualDispertionsView.swift
//
//
//  Created by Victor Cantu on 12/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolReciveSendInventoryManualDispertionsView: Div {
    
    override class var name: String { "div" }
    
    private var load: ((
        _ document: API.custPOCV1.GetManualDispertionResponse
    ) -> ())
    
    private var new: ((
    ) -> ())
    
    init(
        load: @escaping (
            _ document: API.custPOCV1.GetManualDispertionResponse
        ) -> Void,
        new: @escaping (
        ) -> Void
    ) {
        self.load = load
        self.new = new
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var docs: [API.custPOCV1.GetManualDispertionsObject] = []
    
    @State var createNewDocumentIsHidden = true
    
    @State var newDocumentName = ""
    
    @State var vendor: CustVendorsQuick? = nil
    
    @State var profile: FiscalEndpointV1.Profile? = nil
    
    @State var selectFiscalProfileIsHidden = true
    
    @State var profiles: [FiscalEndpointV1.Profile] = fiscalProfiles
    
    lazy var newDocumentNameField = InputText(self.$newDocumentName)
        .placeholder("Nombre de la orden de compra")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .overflow(.auto)
        .height(31.px)
    
    lazy var choseFiscalProfilesView = Div()
        .custom("height", "calc(100% - 45px)")
        .marginTop(7.px)
        .overflow(.auto)
        .float(.right)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /* Header*/
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                Img()
                    .src("/skyline/media/addBlueIcon.png")
                    .marginRight(18.px)
                    .height(24.px)
                    .float(.right)
                    .onClick {

                        print("🚧 🚧 🚧 🚧 🚧 🚧 ")
                        print("use StartManualInventory view insted")

                        self.createNewDocumentIsHidden = false
                        self.newDocumentNameField.select()
                    }
                
                Img()
                    .src( "/skyline/media/history_color.png" )
                    .marginRight(18.px)
                    .height(24.px)
                    .float(.right)
                    .onClick {
                        let view = ToolViewHistoricalInventoryManualDispertionsView()
                        addToDom(view)
                    }
                
                H2("Ingresar inventario")
                .color(.lightBlueText)
                
            }
            
            Div().class(.clear).height(7.px)
            
            Div{

                ForEach(self.$docs) { item in
                    
                    Div{
                        Div{
                            Div{
                                
                                Span(item.folio)
                                
                                Img()
                                    .src("/skyline/media/download2.png")
                                    .marginRight(12.px)
                                    .marginTop(2.px)
                                    .height(24.px)
                                    .float(.right)
                                    .onClick { _, event in
                                        
                                        loadingView(show: true)
                                        
                                        downloadManualInventoryControlOrders(id: item.id, detailed: true)
                                        
                                        Dispatch.asyncAfter(3.0) {
                                            loadingView(show: false)
                                        }
                                        event.stopPropagation()
                                    }
                                
                            }
                            .custom("width", "calc(100% - 150px)")
                            .class(.oneLineText)
                            .float(.left)
                            
                            Div(getDate(item.createdAt).formatedLong)
                                .width(150.px)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        .marginBottom(7.px)
                        .fontSize(20.px)
                        .color(.gray)
                        
                        Div{
                            
                            Div(item.name)
                                .custom("width", "calc(100% - 140px)")
                                .class(.oneLineText)
                        }
                        .marginBottom(7.px)
                        .fontSize(22.px)
                        
                        Div{
                            Div("\(item.vendor.businessName) \(item.vendor.razon)")
                                .custom("width", "calc(100% - 140px)")
                                .class(.oneLineText)
                                .float(.left)
                            
                            Div(item.status.description)
                                .width(140.px)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        .fontSize(16.px)
                        
                        Div().height(7.px).clear(.both)
                        
                    }
                    .width(96.percent)
                    .marginTop(12.px)
                    .class(.uibtn)
                    .onClick {
                        self.loadDocument(id: item.id)
                    }
                    
                }
            
            }
            .custom("height", "calc(100% - 42px)")
            .class(.roundDarkBlue)
            .padding(all: 3.px)
            .overflow(.auto)
        
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 324px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(500.px)
        
        Div{
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.newDocumentName = ""
                            self.vendor = nil
                            self.createNewDocumentIsHidden = true
                        }
                    
                    H2("Crear Ingreso")
                        .color(.lightBlueText)
                    
                }
                
                Div().class(.clear).height(7.px)
                
                Label("Nombre del nueva compra")
                    .color(.gray)
                
                Div().class(.clear).height(3.px)
                
                self.newDocumentNameField
                
                Div().class(.clear).height(7.px)
                
                Label("Proveedor")
                    .color(.gray)
                
                Div().class(.clear).height(3.px)
                
                Div("Buscar Proveedor")
                    .hidden(self.$vendor.map{ $0 != nil })
                    .color(.yellowTC)
                    .textAlign(.center)
                    .marginBottom(7.px)
                    .width(97.percent)
                    .paddingBottom(7.px)
                    .paddingTop(7.px)
                    .fontSize(18.px)
                    .class(.uibtn)
                    .onClick {
                        
                        addToDom( SearchVendorView(loadBy: nil) { account in
                            self.vendor = account
                        })
                    }
                
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .marginTop(3.px)
                        .onClick({ _, event in
                            
                            self.vendor = nil
                            
                            addToDom( SearchVendorView(loadBy: nil) { account in
                                self.vendor = account
                            })
                            
                            event.stopPropagation()
                            
                        })
                    
                    Div{
                        Span(self.$vendor.map{ $0?.folio ?? "--" })
                            .marginRight(7.px)
                        
                        Span(self.$vendor.map{ $0?.businessName ?? "--" })
                            .marginRight(7.px)
                            .hidden(self.$vendor.map{ ($0?.businessName ?? "").isEmpty })
                        
                        Span(self.$vendor.map{ $0?.razon ?? "--" })
                            .marginRight(7.px)
                    }
                    .custom("width", "calc(100% - 35px)")
                    .class(.oneLineText)
                    
                }
                .hidden(self.$vendor.map{ $0 == nil })
                .color(.yellowTC)
                .paddingBottom(7.px)
                .marginBottom(7.px)
                .width(97.percent)
                .paddingTop(7.px)
                .fontSize(18.px)
                .class(.uibtn)
                .onClick {
                    
                    guard let vendor = self.vendor else {
                        return
                    }
                    
                    addToDom( SearchVendorView(loadBy: .account(vendor)) { account in
                        self.vendor = account
                    })
                }
                
                Div().class(.clear).height(7.px)
                    .hidden(self.$profiles.map{ $0.count < 2 })
                
                Div {
                    Div{
                        
                        Div{
                            Div{
                                
                                Img()
                                    .src("/skyline/media/random.png")
                                    .height(18.px)
                                    .paddingRight(0.px)
                            }
                            .marginRight(3.px)
                            .float(.left)
                            
                            Label("Cambiar Perfil")
                                .fontSize(12.px)
                        }
                        .hidden(self.$profiles.map{ $0.count < 2 })
                        .marginTop(-7.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            self.changeFiscalProfile()
                        }
                        
                        H4("Perfil de Facturación")
                    }
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    InputText(self.$profile.map{ $0?.razon ?? "" })
                        .class(.textFiledBlackDark)
                        .placeholder("Razon Social")
                        .marginBottom(3.px)
                        .width(95.percent)
                        .fontSize(20.px)
                        .height(24.px)
                    
                    InputText(self.$profile.map{ $0?.rfc ?? "" })
                        .class(.textFiledBlackDark)
                        .placeholder("RFC")
                        .marginBottom(3.px)
                        .width(95.percent)
                        .fontSize(20.px)
                        .height(24.px)
                }
                .hidden(self.$profiles.map{ $0.count < 2 })
                
                Div().class(.clear).height(7.px)
                
                Div("iniciar Compra")
                    .paddingBottom(7.px)
                    .marginBottom(7.px)
                    .width(97.percent)
                    .paddingTop(7.px)
                    .textAlign(.center)
                    .color(.yellowTC)
                    .fontSize(18.px)
                    .class(.uibtn)
                    .onClick {
                        self.createDocument()
                    }
                
            }
            .custom("left", "calc(50% - 224px)")
            .custom("top", "calc(50% - 224px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(400.px)
        }
        .hidden(self.$createNewDocumentIsHidden)
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
        Div{
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick{
                            self.selectFiscalProfileIsHidden = true
                        }
                    
                    H2("Seleccionar Perfil")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                /// Fiscal Profie Div
                self.choseFiscalProfilesView
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 200px)")
            .custom("top", "calc(50% - 130px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(270.px)
            .width(400.px)
        }
        .hidden(self.$selectFiscalProfileIsHidden)
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        color(.white)
        left(0.px)
        top(0.px)
        
        profile = fiscalProfiles.first
        
        loadingView(show: true)
        
        API.custPOCV1.getManualDispertions(type: .current) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.docs = data
            
        }
        
    }
    
    func createDocument(){
        
        newDocumentName = newDocumentName.purgeSpaces.capitalizingFirstLetters()
        
        if newDocumentName.isEmpty {
            showError(.campoRequerido, "Ingrese nombre para identificar documento")
            newDocumentNameField.select()
            return
        }
        
        guard let vendor else {
            showError(.campoRequerido, "Seleccione provedor de la compra")
            
            addToDom( SearchVendorView(loadBy: nil) { account in
                self.vendor = account
                self.createDocument()
            })
            
            return
        }
        
        guard let profile else {
            showError(.campoRequerido, "Seleccione/Active Perfil Fiscal, contatcte a Soporte TC")
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.createManualDispertion(
            name: newDocumentName,
            store: custCatchStore,
            fiscalProfile: profile.id,
            vendor: vendor.id
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
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.load(payload)
            
            self.remove()
            
        }
    }
    
    func loadDocument(id: UUID) {
        
        loadingView(show: true)
        
        API.custPOCV1.getManualDispertion(
            docId: .id(id)
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
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.load(payload)
            
            self.remove()
            
        }
        
    }
    
    func changeFiscalProfile(){
        
        if profiles.count > 2 {
            
            choseFiscalProfilesView.innerHTML = ""
            
            profiles.forEach { prof in
                
                if prof.id == profile?.id {
                    return
                }
                
                choseFiscalProfilesView.appendChild(
                    Div(prof.razon)
                        .width(97.percent)
                        .class(.uibtnLarge)
                        .onClick {
                            self.selectFiscalProfileIsHidden = true
                            self.profile = prof
                        }
                )
            }
            
            selectFiscalProfileIsHidden = false
            
        }
        else{
            
            var _prof: FiscalEndpointV1.Profile? = nil
            profiles.forEach { prof in
                if prof.id != profile?.id {
                    _prof = prof
                }
            }
            
            profile = _prof
        }
    }
    
}
