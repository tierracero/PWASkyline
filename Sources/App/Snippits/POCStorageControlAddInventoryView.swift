//
//  POCStorageControlAddInventoryView.swift.swift
//  
//
//  Created by Victor Cantu on 2/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class POCStorageControlAddInventoryView: Div {
    
    override class var name: String { "div" }
    
    let pocId: UUID

    let pocName: String

    let reqSeries: Bool
    
    let storeId: UUID

    let storeName: String
    
    var bodegaId: UUID
    
    var sectionId: UUID
    
    @State var documentName: String

    @State var vendor: CustVendorsQuick

    var profile: FiscalEndpointV1.Profile

    private var callback: ((
        _ items: [CustPOCInventoryIDSale]
    ) -> ())
    
    init(
        pocId: UUID,
        pocName: String,
        reqSeries: Bool,
        storeId: UUID,
        storeName: String,
        bodegaId: UUID,
        sectionId: UUID,
        documentName: String,
        vendor: CustVendorsQuick,
        profile: FiscalEndpointV1.Profile,
        callback: @escaping ((
            _ items: [CustPOCInventoryIDSale]
        ) -> ())
    ) {
        self.pocId = pocId
        self.pocName = pocName
        self.reqSeries = reqSeries
        self.storeId = storeId
        self.storeName = storeName
        self.bodegaId = bodegaId
        self.sectionId = sectionId
        self.documentName = documentName
        self.vendor = vendor
        self.profile = profile
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    @State var bodegaName = ""

    @State var sectionName = ""

    @State var unitsString = "0"

    @State var documentSerie: String = ""

    @State var documentFolio: String = ""

    lazy var unitsField = InputText(self.$unitsString)
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
        .onEnter {
            self.addInventory()
        }

    lazy var documentSerieField = InputText(self.$documentSerie)
        .class(.textFiledBlackDark)
        .placeholder("0331-001")
        .textAlign(.right)
        .height(28.px)

    lazy var documentFolioField = InputText(self.$documentFolio)
        .class(.textFiledBlackDark)
        .placeholder("2025")
        .textAlign(.right)
        .height(28.px)

    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        Dispatch.asyncAfter(0.5) {
                            self.remove()
                        }
                    }
                
                H2("Agregar Inventario")
                    .color(.lightBlueText)
                    .marginRight(7.px)
                    .height(35.px)
                    .float(.left)
                
                H2(self.storeName)
                    .color(.darkOrange)
                    .height(35.px)
                    .color(.white)
                    .float(.left)
                
            }
          
            Div{
               Div{
                    Label("Bodega")
                        .color(.gray)

                    Div().class(.clear).height(3.px)

                    H2(self.$bodegaName)
                    .color(.white)

                }
                .width(50.percent)
                .float(.left)

                Div{
                    Label("Seccion")   
                        .color(.gray)

                    Div().class(.clear).height(3.px)

                    H2(self.$sectionName)
                    .color(.white)
                }
                .width(50.percent)
                .float(.left)
            }

            Div().class(.clear).height(7.px)
            
            Div{
               Div{
                    Label("Serie")
                        .color(.gray)

                    Div().class(.clear).height(3.px)

                    self.documentSerieField

                }
                .width(50.percent)
                .float(.left)

                Div{
                    Label("Folio")   
                        .color(.gray)

                    Div().class(.clear).height(3.px)

                    self.documentFolioField
                }
                .width(50.percent)
                .float(.left)
            }

            Div().class(.clear).height(7.px)
                        
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .marginTop(3.px)
                    .onClick({ _, event in
                        
                        addToDom( SearchVendorView(loadBy: nil) { account in
                            self.vendor = account
                        })
                        
                        event.stopPropagation()
                        
                    })
                
                Div{
                    Span(self.$vendor.map{ $0.folio })
                        .marginRight(7.px)
                    
                    Span(self.$vendor.map{ $0.businessName })
                        .marginRight(7.px)
                        .hidden(self.$vendor.map{ ($0.businessName ).isEmpty })
                    
                    Span(self.$vendor.map{ $0.razon })
                        .marginRight(7.px)
                }
                .custom("width", "calc(100% - 35px)")
                .class(.oneLineText)
                
            }
            .color(.yellowTC)
            .paddingBottom(7.px)
            .marginBottom(7.px)
            .width(97.percent)
            .paddingTop(7.px)
            .fontSize(18.px)
            .class(.uibtn)
            .onClick {
                
                addToDom( SearchVendorView(loadBy: .account(self.vendor)) { account in
                    self.vendor = account
                })

            }
            

            Div().class(.clear).height(7.px)




            Div {

                Div{
                    H2("Ingrese Unidades")
                    .color(.gray)    
                }
                .width(50.percent)
                .float(.left)

                Div{
                    self.unitsField                    
                }
                .width(50.percent)
                .float(.left)

                Div().class(.clear)

            }
            
            
            Div().class(.clear).height(7.px)
            
            Div{
                Div("+ Agregar")
                    .class(.uibtnLargeOrange)
                    .onClick{
                        self.addInventory()
                    }
            }
            .align(.right)
            
            Div().class(.clear).marginBottom(7.px)
            
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 274px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(500.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        bodegaName = bodegas[bodegaId]?.name ?? "NOT_FOUND"
        
        sectionName = seccions[sectionId]?.name ?? "NOT_FOUND"
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        unitsField.select()
    }

    
    func addInventory(){
        
        guard let units = Float(unitsString)?.toInt else {
            showError(.formatoInvalido, "Ingrese unidades validas")
            unitsField.select()
            return
        }
        /*
        
        guard let store = stores[storeid] else {
            showError(.unexpectedResult, "No se localizo teinda, refresque el sistema.")
            return
        }
        
        guard let currentbod else {
            showError(.campoRequerido, "Seleccione Bodega")
            return
        }
        
        
        guard let bodega = bodegas[currentbod] else {
            showError(.unexpectedResult, "No se localizo bodega, refresque el sistema.")
            return
        }
        
        guard let currentsec else {
            showError(.campoRequerido, "Seleccione Seccion")
            return
        }
        
        guard let seccion = seccions[currentsec] else {
            showError(.unexpectedResult, "No se localizo seccion, refresque el sistema.")
            return
        }
        */

        if reqSeries {
            let view = POCStorageControlAddInventorySeriesView(
                pocName: pocName,
                units: units
            ) { series in

                addToDom(ConfirmationView(
                    type: .acceptDeny,
                    title: "Confirme Accion",
                    message: "¿Quiere agregar \(units.toString) unidades?"
                ) { isConfirmed, comment in
                    
                    if isConfirmed {
                        
                        loadingView(show: true)

                        API.custPOCV1.addManualInventory(
                            storeId: self.storeId,
                            relationType: .store,
                            items: [.init(
                                pocId: self.pocId,
                                description: self.pocName,
                                units: .serilized(series),
                                price: nil
                            )],
                            documentName: self.documentName,
                            documentSerie: self.documentSerie,
                            documentFolio: self.documentFolio,
                            vendorId: self.vendor.id,
                            profileId: self.profile.id,
                            bodegaId: self.bodegaId,
                            sectionId: self.sectionId
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
                                showError(.errorGeneral, .unexpenctedMissingPayload)
                                return
                            }
                            
                            showSuccess(.operacionExitosa, "Se agrego inventario")
                            
                            let items: [CustPOCInventoryIDSale] = payload.items.map { .init(
                                id: $0.id,
                                custStore: self.storeId,
                                custStoreBodegas: self.bodegaId,
                                custStoreSecciones: self.sectionId,
                                series: $0.series
                            ) }
                            
                            self.callback(items)
                            
                            self.remove()
                            
                        }
                    }
                    
                })
        
            }

            addToDom(view)    

            return
        }
        
        addToDom(ConfirmationView(
            type: .acceptDeny,
            title: "Confirme Accion",
            message: "¿Quiere agregar \(units.toString) unidades?"
        ) { isConfirmed, comment in
            
            if isConfirmed {
                
                loadingView(show: true)

                API.custPOCV1.addManualInventory(
                    storeId: self.storeId,
                    relationType: .store,
                    items: [.init(
                        pocId: self.pocId,
                        description: self.pocName,
                        units: .units(units),
                        price: nil
                    )],
                    documentName: self.documentName,
                    documentSerie: self.documentSerie,
                    documentFolio: self.documentFolio,
                    vendorId: self.vendor.id,
                    profileId: self.profile.id,
                    bodegaId: self.bodegaId,
                    sectionId: self.sectionId
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
                        showError(.errorGeneral, .unexpenctedMissingPayload)
                        return
                    }
                    
                    showSuccess(.operacionExitosa, "Se agrego inventario")
                    
                    let items: [CustPOCInventoryIDSale] = payload.items.map { .init(
                        id: $0.id,
                        custStore: self.storeId,
                        custStoreBodegas: self.bodegaId,
                        custStoreSecciones: self.sectionId,
                        series: $0.series
                    ) }
                    
                    self.callback(items)
                    
                    self.remove()
                    
                }
            }
            
        })
        
    }
    
}
