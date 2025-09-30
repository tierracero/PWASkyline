//
//  POCAddStorageView.swift
//  
//
//  Created by Victor Cantu on 2/2/23.
//

import Foundation
import TCFundamentals
import Web

class POCAddStorageView: Div {
    
    override class var name: String { "div" }
    
    let pocid: UUID
    
    let storeid: UUID
    
    let storeName: String
    
    private var callback: ((
        _ storagePlace: CustStoreProductSection,
        _ items: [CustPOCInventoryIDSale]
    ) -> ())
    
    init(
        pocid: UUID,
        storeid: UUID,
        storeName: String,
        callback: @escaping ((
            _ storagePlace: CustStoreProductSection,
            _ items: [CustPOCInventoryIDSale]
        ) -> ())
    ) {
        self.pocid = pocid
        self.storeid = storeid
        self.storeName = storeName
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var newInventory = "0"
    
    lazy var currentNewInventoryField = InputText(self.newInventory)
        .custom("width", "calc(100% - 16px)")
        .placeholder("Inventario actual")
        .class(.textFiledBlackDark)
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
    
    var bods: [CustStoreBodegasSinc] = []
    
    lazy var storeBodegaSelect = Select()
        .class(.textFiledBlackDark)
        .height(28.px)
        .width(200.px)
    
    lazy var sectionSelectDiv = Div()
    
    var bodegaid: UUID? = nil
    
    var bodegaName = ""
    
    var sectionid: UUID? = nil
    
    var sectionName = ""
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Agergar Almacenaje | \(self.storeName)")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
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
            
            Div().class(.clear).marginBottom(7.px)
            
            
            /// TODO: agerbar esta capasidad
//            Div{
//
//                Label("Unidades")
//                    .color(.gray)
//
//                Div{
//                    self.currentNewInventoryField
//                }
//
//            }
//            .class(.section)
//
//            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Div("+ Agregar")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addStoragePlace()
                    }
            }
            .align(.right)
            
            Div().class(.clear).marginBottom(7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
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
        
        bodegaid = bodega.id
        
        bodegaName = bodega.name
        
        sectionSelectDiv.appendChild(SectionSelectField(
            storeid: storeid,
            storeName: stores[storeid]?.name ?? "",
            bodid: bodega.id,
            bodName: bodega.name,
            callback: { section in
                self.sectionid = section.id
                self.sectionName = section.name
            })
            .position(.relative))
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    func addStoragePlace(){
        
        guard let bodegaid else {
            showError(.campoRequerido, "Selecione bodega")
            return
        }
        
        guard let sectionid else {
            showError(.campoRequerido, "Seleccione Seccion")
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.addStorage(
            pocid: pocid,
            storeid: storeid,
            storeName: storeName,
            bodegaid: bodegaid,
            bodegaName: bodegaName,
            sectionid: sectionid,
            sectionName: sectionName
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
            
            guard let storagePlace = resp.data else {
                showError(.unexpectedResult, "No se localizo payload de data.")
                return
            }
            
            self.callback(storagePlace, [])
            
            self.remove()
            
            
        }
    }
    
}
