//
//  POCStorageControlAddInventoryView.swift.swift
//  
//
//  Created by Victor Cantu on 2/5/23.
//

import Foundation
import TCFundamentals
import Web

class POCStorageControlAddInventoryView: Div {
    
    override class var name: String { "div" }
    
    let pocid: UUID
    
    let storeid: UUID
    
    let storeName: String
    
    var currentbod: UUID?
    
    var currentsec: UUID?
    
    private var callback: ((
        _ items: [CustPOCInventoryIDSale]
    ) -> ())
    
    
    init(
        pocid: UUID,
        storeid: UUID,
        storeName: String,
        currentbod: UUID?,
        currentsec: UUID?,
        callback: @escaping ((
            _ items: [CustPOCInventoryIDSale]
        ) -> ())
    ) {
        self.pocid = pocid
        self.storeid = storeid
        self.storeName = storeName
        self.currentbod = currentbod
        self.currentsec = currentsec
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var unitsString = "0"
    
    var bods: [CustStoreBodegasSinc] = []
    
    lazy var unitsField = InputText(self.$unitsString)
        .class(.textFiledBlackDark)
        .placeholder("0.00")
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
    
    
    lazy var storeBodegaSelect = Select()
        .class(.textFiledBlackDark)
        .height(28.px)
        .width(200.px)
    
    lazy var sectionSelectDiv = Div()
    
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
                    .float(.left)
                
            }
            
            
            Div().class(.clear).marginBottom(7.px)
            
            
            Div{
                Label("Ingrese Unidades")
                    .color(.gray)
                
                Div{
                    self.unitsField
                }
            }
            .class(.section)
            
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Label("Bodega")
                    .color(.gray)
                
                Div{
                    self.storeBodegaSelect
                        .disabled(true)
                }
            }
            .class(.section)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Label("Seccion")
                    .paddingTop(11.px)
                    .width(30.percent)
                    .marginLeft(5.px)
                    .marginTop(2.px)
                    .float(.left)
                    .color(.gray)
                
                self.sectionSelectDiv
                .marginLeft(35.percent)
                .paddingTop(5.px)
            }
            .position(.relative)
            .zIndex(1)
            
            Div().class(.clear).marginBottom(7.px)
            
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
        
        bodegas.forEach { id, bod in
            if bod.custStore == storeid {
                
                bods.append(bod)
                
                storeBodegaSelect.appendChild(
                    Option(bod.name)
                        .value(bod.id.uuidString)
                )
            }
        }
        
        guard let bodega = bods.first else {
            showError(.errorGeneral, "No se localizo bodega de la tienda. Refresque o asegurese que su configuracion sea la correcta.")
            return
        }
        
        currentbod = bodega.id
        
        let view = SectionSelectField(
            storeid: storeid,
            storeName: stores[storeid]?.name ?? "",
            bodid: bodega.id,
            bodName: bodega.name,
            callback: { section in
                self.currentsec = section.id
            })
            .position(.relative)
        
        sectionSelectDiv.appendChild(view)
        
        if let sectid = currentsec {
            if let place = seccions[sectid] {
                
                view.sectionSelectText = place.name
                view.sectionSelectId = place.id
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        unitsField.select()
    }

    
    func addInventory(){
        
        guard let units = Float(unitsString)?.toCents else {
            showError(.formatoInvalido, "Ingrese unidades validas")
            unitsField.select()
            return
        }
        
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
        
        addToDom(ConfirmView(
            type: .acceptDeny,
            title: "Confirme Accion",
            message: "¿Quiere agregar \(unitsString) unidadesd?"
        ) { isConfirmed, comment in
            
            if isConfirmed {
                
                loadingView(show: true)

                /*
                API.custAccountV1.addCustomerManualConcession(
                    storeId: UUID,
                    accountId: UUID,
                    items: [CreateManualProductObject],
                    documentName: String,
                    documentSerie: String,
                    documentFolio: String,
                    vendorId: UUID,
                    profileId: UUID,
                    bodegaId: UUID?,
                    sectionId: UUID?
                ) { resp in

                }
                */

                API.custPOCV1.addInventory(
                    pocid: self.pocid,
                    units: units,
                    storeid: store.id,
                    storeName: store.name,
                    bodid: bodega.id,
                    bodName: bodega.name,
                    secid: seccion.id,
                    secName: seccion.name,
                    series: []
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp = resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }

                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    
                    guard let data = resp.data else {
                        showError(.errorGeneral, .unexpenctedMissingPayload)
                        return
                    }
                    
                    showSuccess(.operacionExitosa, "Se agrego inventario")
                    
                    let items: [CustPOCInventoryIDSale] = data.map { .init(
                        id: $0,
                        custStore: self.storeid,
                        custStoreBodegas: bodega.id,
                        custStoreSecciones: seccion.id,
                        series: ""
                    ) }
                    
                    self.callback(items)
                    
                    self.remove()
                    
                }
            }
        })
        
    }
    
}
