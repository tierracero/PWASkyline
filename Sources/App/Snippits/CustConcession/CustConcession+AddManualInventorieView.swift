//
//  CustConcession+AddManualInventorieView.swift
//
//
//  Created by Victor Cantu on 7/11/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class AddManualInventorieView: Div {
        
        override class var name: String { "div" }
        
        let account: CustAcct
        
        init(
            account: CustAcct
        ) {
            self.account = account
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var balanceString =  "0.00"
        
        @State var kart: [SalePointObject] = []
        
        @State var searchTerm = ""
        
        lazy var searchBox = InputText($searchTerm)
            .custom("background", "url('images/barcode.png') no-repeat scroll 7px 7px rgb(29, 32, 38)")
            .placeholder("Ingrese UPC/SKU/POC o Referencia")
            .backgroundSize(h: 18.px, v: 18.px)
            .onKeyUp(searchTermAct)
            .class(.textFiledLight)
            .paddingLeft(30.px)
            .marginLeft(7.px)
            .width(350.px)
            .height(32.px)
            .color(.white)
            .float(.left)
            .onFocus { tf in
                self.resultBox.innerHTML = ""
                tf.text = ""
            }
        
        lazy var resultBox = Div()
            .class(.transparantBlackBackGround, .roundDarkBlue)
            .maxHeight(70.percent)
            .position(.absolute)
            .overflow(.auto)
            .width(1000.px)
        
        lazy var itemGrid = Table{
            Tr {
                Td().width(50)
                Td("Marca").width(200)
                Td("Modelo / Nombre")
                //Td("Hubicación").width(200)
                Td("Units").width(100)
                Td("C. Uni").width(100)
                Td("S. Total").width(100)
            }
        }
        .width(100.percent)
        .color(.white)
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Agregar concesión del proveedor")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    self.searchBox
                    
                    Div().class(.clear)
                }
                
                Div().class(.clear).marginTop(3.px)
            
                self.resultBox

                //Price Grid
                Div{
                    self.itemGrid
                }
                .custom("height", "calc(100% - 115px)")
                .padding(all: 7.px)
                .class(.roundDarkBlue)
                .overflow(.auto)
                .onClick {
                    self.resultBox.innerHTML = ""
                }
                
                Div{
                    Div("Agregar Concesión")
                        .class(.uibtnLargeOrange)
                        .hidden(self.$kart.map{ $0.isEmpty })
                        .onClick {
                            self.addConcession()
                        }
                    Div("Agregar Concesión")
                        .class(.uibtnLarge)
                        .cursor(.default)
                        .opacity(0.5)
                        .hidden(self.$kart.map{ !$0.isEmpty })
                }
                .align(.right)
                
            }
            .custom("height","calc(100% - 50px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(90.percent)
            .left(5.percent)
            .top(25.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            searchBox.select()
        }
        
        func searchTermAct() {
            
            if searchBox.text.isEmpty {
                self.resultBox.innerHTML = ""
                return
            }
            
            let term = searchBox.text.purgeSpaces
            
            Dispatch.asyncAfter(0.37) {
                
                if term == self.searchBox.text.purgeSpaces {
                    
                    // TODO: properly parse currentCodeIds
                    searchPOC(
                        term: self.searchBox.text,
                        costType: .cost_a,
                        getCount: false
                    ) { term, resp in
                        
                        if self.searchBox.text == term {
                            
                            self.resultBox.innerHTML = ""
                            
                            if resp.count == 1 {
                                
                                guard let item = resp.first else {
                                    return
                                }
                                
                                addToDom(ConfirmProductView(item: item){ item, units in
                                    self.addItem(
                                        item: item,
                                        units: units
                                    )
                                })
                                
                                return
                                
                            }
                            
                            resp.forEach { item in
                                
                                let view = SearchChargeView(
                                    data: .init(
                                        t: .product,
                                        i: item.i,
                                        u: item.u,
                                        n: item.n,
                                        b: item.b,
                                        m: item.m,
                                        p: item.p,
                                        a: item.a
                                    ),
                                    costType: .cost_a
                                ) { item in
                                    
                                    self.searchBox.text = ""
                                    
                                    self.resultBox.innerHTML = ""
                                    
                                    addToDom(ConfirmProductView(
                                        item: .init(
                                            i: item.i,
                                            u: item.u,
                                            n: item.n,
                                            b: item.b,
                                            m: item.m,
                                            p: item.p,
                                            a: item.a,
                                            c: 0
                                        )
                                    ){ item, units in
                                        self.addItem(item: item, units: units)
                                    })
                                    
                                }
                                .custom("width", "calc(50% - 28px)")
                                .marginRight(3.px)
                                .float(.left)
                                
                                self.resultBox.appendChild(view)
                            }
                        }
                    }
                }
            }
        }
        
        func addItem( item: SearchPOCResponse, units: Int64) {
            
            let id = UUID()
            
            let row = KartItemView(
                id: id,
                cost: 0,
                quant: (units / 100),
                price: 0,
                data: .init(
                    t: .product,
                    i: item.i,
                    u: item.u,
                    n: item.n,
                    b: item.b,
                    m: item.m,
                    p: 0,
                    a: item.a
                )
            ) { id in
                
                var _kart: [SalePointObject] = []
                
                self.kart.forEach { item in
                    if item.id != id {
                        _kart.append(item)
                    }
                }
                
                self.kart = _kart
                
            } 
            editManualCharge: { _, _, _, _, _ in
                // MARK: No editd are suported / required
            }
            .color(.white)
            
            self.kart.append(.init(
                    id: id,
                    kartItemView: row,
                    data: .init(
                        type: .product,
                        id: item.i,
                        store: custCatchStore,
                        ids: [],
                        series: [],
                        cost: 0,
                        units: units,
                        unitPrice: 0,
                        subTotal: 0,
                        costType: .cost_a,
                        name: item.n,
                        brand: item.b,
                        model: item.m,
                        pseudoModel: "",
                        avatar: item.a,
                        fiscCode: "",
                        fiscUnit: "",
                        preRegister: false
                    )
                ))
            
            self.itemGrid.appendChild(row)
            
            self.searchBox.select()
            
        }
        
        func addConcession(){
            
            if kart.isEmpty {
                return
            }
            
            addToDom(ConfirmationView(
                type: .yesNo,
                title: "Agregar Concession Manuel",
                message: "Confirme la marcacia agregada",
                callback: { isConfirmed, comment in
                    
                    if !isConfirmed {
                        return
                    }
                    
                    let items: [SaleObjectItem] = self.kart.map{ .init(
                        id: $0.data.id,
                        store: custCatchStore,
                        ids: [],
                        quant: $0.data.units.fromCents,
                        price: 0,
                        subtotal: 0,
                        costType: .cost_a,
                        serie: nil,
                        description: "\($0.data.name) \($0.data.brand) \($0.data.model)".purgeSpaces
                    )}
                    
                    API.custAccountV1.addCustomerManualConcession(
                        storeId: custCatchStore,
                        accountId: self.account.id,
                        items: items
                    ) { resp in
                        
                        loadingView(show: false)

                        guard let resp else {
                            showError(.errorDeCommunicacion, "Error de comunicacion")
                            return
                        }

                        if resp.status != .ok {
                            showError(.errorGeneral, resp.msg)
                            return
                        }

                        guard let payload = resp.data else {
                            showError(.unexpectedResult, "No se obtuvo payload de data")
                            return
                        }

                        let control = payload.control

                        let cardex = payload.cardex

                        self.appendChild(ConcessionConfirmationView(
                            accountid: self.account.id,
                            accountFolio: self.account.folio,
                            accountName: "\(self.account.fiscalRfc) \(self.account.fiscalRazon)",
                            purchaseManager: control.id,
                            subTotal: self.balanceString,
                            document: control,
                            kart: self.kart,
                            cardex: cardex
                        ))
                        
                        self.kart = []
                        
                        self.itemGrid.innerHTML = ""
                        
                        self.itemGrid.appendChild(Tr {
                            Td().width(50)
                            Td("Marca").width(200)
                            Td("Modelo / Nombre")
                            //Td("Hubicación").width(200)
                            Td("Units").width(100)
                            Td("C. Uni").width(100)
                            Td("S. Total").width(100)
                        })
                    }
                })
            )
        }
    }
}
