//
//  POCInventoryControlView.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class POCInventoryControlView: Div {
    
    override class var name: String { "div" }
    
    let storeid: UUID
    
    let storeName: String
    
    let secdata: CustStoreProductSection?
    
    private var callback: ((
        _ section: CustStoreSeccionesSinc
    ) -> ())
    
    init(
        storeid: UUID,
        storeName: String,
        secdata: CustStoreProductSection?,
        callback: @escaping ((
            _ section: CustStoreSeccionesSinc
        ) -> ())
    ) {
        self.storeid = storeid
        self.storeName = storeName
        self.secdata = secdata
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var controlViewIsHidden = true
    
    @State var bodegaid: String = ""
    
    var bodegaName: String = ""
    
    var seccionid: UUID? = nil
    
    var seccionName: String = ""
    
    lazy var controleView =  Div()
    
    @DOM override var body: DOM.Content {
        Div{
            
            Table {
                Tr{
                    Td{
                        Span("Activar Bodega / Seccion")
                        Br()
                        Div("Seleccionar almacen")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                self.loadView()
                            }
                        
                    }
                    .align(.center)
                    .verticalAlign(.middle)
                }
            }
            .width(100.percent)
            .height(200.px)
            
        }
        .hidden(self.$controlViewIsHidden.map{ !$0 })
        
        self.controleView
            .hidden(self.$controlViewIsHidden)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        backgroundColor(.grayBlack)
        padding(all: 3.px)
        margin(all: 3.px)
        height(400.px)
        
        if secdata != nil {
            controlViewIsHidden = false
            loadView()
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    func loadView() {
        
        var bods: [CustStoreBodegasSinc] = []
        
        bodegas.forEach { id, bod in
            if bod.custStore == storeid {
                bods.append(bod)
            }
        }
        
        guard let selectedBodega = bods.first else {
            showError(.unexpectedResult, "No se localozaron bodegas, refresque e untente nuevo y asegurese que tenga su configuracion correcta. Contacte a Soporte TC")
            return
        }
        
        let bodegaSelect = Select(self.$bodegaid)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .height(28.px)
        
        bods.forEach { bod in
            bodegaSelect.appendChild(
                Option(bod.name)
                    .value(bod.id.uuidString)
            )
        }
        
        bodegaid = selectedBodega.id.uuidString
        
        let sectionSelectField = SectionSelectField(
            storeid: storeid,
            storeName: storeName,
            bodid: selectedBodega.id,
            bodName: selectedBodega.name
        ) { section in
            self.seccionid = section.id
            self.seccionName = section.name
        }
        
        let view = Div{
            Div{
                Label("Bodega")
                Div{
                    bodegaSelect
                }
            }
            .class(.section)
            
            Div().class(.clear)
            
            Div{
                Label("Seccion")
                    .paddingTop(11.px)
                    .width(30.percent)
                    .marginLeft(5.px)
                    .marginTop(2.px)
                    .float(.left)
                    .color(.gray)
                
                Div{
                    sectionSelectField
                }
                .marginLeft(35.percent)
                .paddingTop(5.px)
            }
            
            Div().class(.clear)
            
        }
        .height(100.percent)
        
    }
    
}
