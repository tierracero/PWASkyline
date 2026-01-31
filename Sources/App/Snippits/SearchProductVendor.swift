//
//  SearchProductVendor.swift
//  
//
//  Created by Victor Cantu on 9/7/22.
//

import Foundation
import TCFundamentals
import Web

public class SearchProductVendor: Div {
    
    public override class var name: String { "div" }
    
    var pocid: UUID
    
    @State var name: String
    
    private var addVendor: ((
        _ vendor: API.custPOCV1.POCVendor
    ) -> ())
    
    
    public init(
        pocid: UUID,
        name: String,
        addVendor: @escaping ((
            _ vendor: API.custPOCV1.POCVendor
        ) -> ())
    ) {
        self.pocid = pocid
        self.name = name
        self.addVendor = addVendor
        
        super.init()
    }
    
    public required init() {
        fatalError("init() has not been implemented")
    }

    lazy var providerGridHeader =  Tr{
        Td("Folio").width(100.px)
        Td("Proveedor").width(150.px)
        Td("SKU/UPC/POC").width(120.px)
        Td("Descripcion")
        Td("Costo").width(100.px)
        Td("Agregar").width(35.px)
    }
    
    lazy var providerGrid = Table {
        self.providerGridHeader
    }
        .width(100.percent)
    
    lazy var searchField = InputText(self.$name)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 100px)")
    
    @DOM public override var body: DOM.Content {
        Div{
            Img()
                .closeButton(.uiView3)
                .onClick{
                    self.remove()
                }
            
            H2("Agergar de Factura")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(7.px)
            
            Div{
                self.searchField
            }
            
            Div{
                self.providerGrid
            }
            .padding(all: 3.px)
            .margin(all: 3.px)
            .class(.roundBlue)
            .overflow(.auto)
            .height(500.px)
            
        }
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(10.percent)
    }
    
    public override func buildUI() {
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        
        super.buildUI()
        
        self.search()
    }

    func search(){
        
        if self.name.count < 4{
            
        }
        
        loadingView(show: true)
        
        API.custPOCV1.searchPOCVendorRelation(
            poc: self.pocid,
            name: self.name
        ) { resp in
        
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.generalError, .unexpenctedMissingPayload)
                return
            }
            
            /// RFC /  CustVendorsQuick
            var vendorRefrence: [String:CustVendorsQuick] = [:]
            
            payload.vendors.forEach { vendor in
                vendorRefrence[vendor.rfc] = vendor
            }
            
            self.providerGrid.innerHTML = ""
            
            self.providerGrid.appendChild(self.providerGridHeader)
            
            payload.current.forEach { item in
                
                self.providerGrid.appendChild(SearchProductVendorItem(
                    term: self.name,
                    vendor: vendorRefrence[item.rfc],
                    item: item,
                    isActive: true,
                    pocid: self.pocid,
                    addVendor: { isActive in
                        
                        if isActive {
                            self.addVendor(.init(
                                pocid: self.pocid,
                                vendorid: vendorRefrence[item.rfc]!.id,
                                vendorName: vendorRefrence[item.rfc]!.razon
                            ))
                        }
                        else{
                            showAlert(.alerta, "Para tambien remover provedro del producto debe hacer se desde los detalles del producto")
                        }
                        
                    }))
                
            }
            
            payload.suggestions.forEach { item in
                self.providerGrid.appendChild(SearchProductVendorItem(
                    term: self.name,
                    vendor: vendorRefrence[item.rfc],
                    item: item,
                    isActive: false,
                    pocid: self.pocid,
                    addVendor: { isActive in
                        
                        if isActive {
                            self.addVendor(.init(
                                pocid: self.pocid,
                                vendorid: vendorRefrence[item.rfc]!.id,
                                vendorName: vendorRefrence[item.rfc]!.razon
                            ))
                        }
                        else{
                            showAlert(.alerta, "Para tambien remover provedro del producto debe hacer se desde los detalles del producto")
                        }
                        
                    }))
            }
         
        }
    }
    
}
