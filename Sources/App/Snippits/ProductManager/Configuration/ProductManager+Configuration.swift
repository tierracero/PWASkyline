//
//  ProductManager+Configuration.swift
//
//
//  Created by Victor Cantu on 3/5/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView {
    
    class Configuration: Div {
        
        override class var name: String { "div" }
        
        lazy var mainContainer = Div()
            .custom("height","calc(100% - 35px)")
            .borderRadius(12.px)
            .marginTop(7.px)
            .overflow(.auto)
        
        @State var requestProductDiscontinueViewIsHidden = true
        
        @State var daysLimit: String = "90"
        
        lazy var daysLimitField = InputText(self.$daysLimit)
            .custom("width", "calc(100% - 8px)")
            .class(.textFiledBlackDark)
            .placeholder("Dias sin venta")
            .fontSize(22.px)
            .height(34.px)
        
        var productItemViews: [ UUID : Div ] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick {
                            self.remove()
                        }
                    
                    Div("Descontinuar Poductos")
                        .class(.uibtnLargeOrange)
                        .marginRight(14.px)
                        .marginTop(-3.px)
                        .float(.right)
                        .onClick {
                            self.requestProductDiscontinueViewIsHidden = false
                            self.daysLimitField.select()
                        }
                    
                    H1("Configuración")
                        .color(.lightBlueText)
                        .marginRight(12.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }

                self.mainContainer
                
            }
            .custom("height", "calc(100% - 124px)")
            .custom("width", "calc(100% - 124px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(50.px)
            .top(60.px)
            
            Div {
                Div {
                    
                    /// Header
                    Div{
                        
                        Img()
                            .closeButton(.uiView3)
                            .onClick {
                                self.requestProductDiscontinueViewIsHidden = true
                            }
                        
                        H2("Ingrese dias sin ventas")
                            .color(.lightBlueText)
                            .marginRight(12.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().class(.clear).height(7.px)
                    
                    H3("Ingese los dias en los que no haya ventas del producto.")
                        .color(.gray)
                    
                    Div().class(.clear).height(7.px)
                    
                    self.daysLimitField

                    Div().class(.clear).height(7.px)
                    
                    Div{
                        Div("Buscar Productos")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                self.getToDiscontinue()
                            }
                    }
                    .align(.right)
                    
                }
                .backgroundColor(.backGroundGraySlate)
                .custom("left", "calc(50% - 224px)")
                .custom("top", "calc(50% - 114px)")
                .borderRadius(all: 24.px)
                .position(.absolute)
                .padding(all: 12.px)
                .width(400.px)
            }
            .hidden(self.$requestProductDiscontinueViewIsHidden)
            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .left(0.px)
            .top(0.px)
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
        
        func getToDiscontinue() {
            
            guard let daysLimit = Int(self.daysLimit) else {
                showError(.invalidField, "Ingrese dias sin venta.")
                daysLimitField.select()
                return
            }
            
            loadingView(show: true)
            
            API.custPOCV1.getToDiscontinue(
                limit: daysLimit
            ) { [self] resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.generalError, .unexpenctedMissingPayload)
                    return
                }
                
                self.requestProductDiscontinueViewIsHidden = true
                
                self.mainContainer.innerHTML = ""
                
                data.forEach { item in
                    
                    let view = pocItemView(item: item)
                    
                    self.productItemViews[item.poc.id] = view
                    
                    self.mainContainer.appendChild(view)
                    
                }
                
            }
        }
        
        func pocItemView(item: CustPOCComponents.GetToDiscontinueItem) -> Div {
            
            @State var name = "\(item.poc.name) \(item.poc.model) \(item.poc.brand)".purgeSpaces
            
            if let lastSaleAt = item.lastSaleAt {
                print(lastSaleAt)
            }
            
            lazy var avatar = Img()
                .src("/skyline/media/512.png")
                .borderRadius(all: 12.px)
                .marginRight(7.px)
                .objectFit(.cover)
                .height(120.px)
                .width(120.px)
            
            if !item.poc.avatar.isEmpty,let pDir = customerServiceProfile?.account.pDir {
                avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(item.poc.avatar)")
            }
            
            return Div {
                
                Div{
                    avatar
                }
                .width(120.px)
                .float(.left)
                
                Div{
                    
                    Div{
                        
                        // Name View
                        Div($name)
                            .class(.oneLineText)
                        
                        if !item.poc.upc.isEmpty {
                            Div(item.poc.upc)
                                .class(.oneLineText)
                                .marginTop(7.px)
                        }
                        
                        Div().class(.clear)
                        
                    }
                        .custom("width", "calc(100% - 200px)")
                        .class(.oneLineText)
                        .marginRight(7.px)
                        .float(.left)
                    
                    Div{
                        Div(item.poc.pricea.formatMoney)
                            .class(.oneLineText)
                            .marginTop(12.px)
                            .color(.white)
                    }
                    .class(.oneLineText)
                    .width(130.px)
                    .align(.right)
                    .float(.left)
                    
                    Div().class(.clear).height(3.px)
                    
                    Div{
                        
                        if custCatchHerk > 1 {
                            Div{
                                
                                Img()
                                    .src("/skyline/media/cross.png")
                                    .height(18.px)
                                    .marginRight(7.px)
                                
                                Span("Eliminar")
                                    .color(.darkOrange)
                                    .fontSize(18.px)
                                
                            }
                            .backgroundColor(.backGroundRow)
                            .class(.uibtn)
                            .float(.right)
                            .onClick({ _, event in
                                event.stopPropagation()
                                self.deletePoc(pocId: item.poc.id, name: name)
                            })
                        }
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/icon_pending@128.png")
                                .height(18.px)
                                .marginRight(7.px)
                            
                            Span("Pausar")
                                .color(.darkOrange)
                                .fontSize(18.px)
                            
                        }
                        .backgroundColor(.backGroundRow)
                        .class(.uibtn)
                        .float(.right)
                        .onClick({ _, event in
                            event.stopPropagation()
                            self.pausePoc(pocId: item.poc.id, name: name)
                        })
                        
                        if let lastSaleAt = item.lastSaleAt {
                            Div(
                                "ULTIMA VENTA: \(((getNow() - lastSaleAt) / 86400).toString) dia(s)\n" +
                                "\(getDate(lastSaleAt).formatedLong)"
                            )
                                .color(.darkGoldenRod)
                                .class(.oneLineText)
                                .fontSize(18.px)
                                .marginTop(7.px)
                        }
                        else {
                            Div("SIN VENTAS")
                                .class(.oneLineText)
                                .color(.darkGoldenRod)
                                .marginTop(7.px)
                        }
                    }
                }
                .custom("width", "calc(100% - 127px)")
                .paddingLeft(7.px)
                .float(.left)
                
                
            }
            .custom("width", "calc(50% - 28px)")
            .class(.rowItem, .hiddeToolItem)
            .margin(all: 7.px)
            .float(.left)
            .onClick {
                
                let view = ManagePOC(
                    leveltype: .all,
                    levelid: nil,
                    levelName: "",
                    pocid: item.poc.id,
                    titleText: "Editar \(name)",
                    quickView: false
                ) { pocid, upc, brand, model, newName, cost, price, avatar, reqSeries in
                    name = newName
                } deleted: {
                    
                    self.productItemViews[item.poc.id]?.remove()
                    
                    self.productItemViews.removeValue(forKey: item.poc.id)
                    
                }
                
                addToDom(view)
                
            }
        }
        
        
        func deletePoc(pocId: UUID, name: String) {
             
             guard let pDir = customerServiceProfile?.account.pDir else {
                 return
             }
             
             addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme eliminación", 
                message: "¿Realmente desea eliminar el producto \(name.uppercased())?"
             ){ isConfirm, reason in
                  
                 loadingView(show: true)
                 
                 API.custPOCV1.deletePOC(
                     id: pocId,
                     pDir: pDir
                 ) { resp in
                 
                     loadingView(show: false)
                     
                     guard let resp else {
                         showError(.comunicationError, .serverConextionError)
                         return
                     }
                     
                     guard resp.status == .ok else{
                         showError(.generalError, resp.msg)
                         return
                     }
                     
                     showSuccess(.operacionExitosa, "Producto Eliminado")
                     
                     self.productItemViews[pocId]?.remove()
                     
                     self.productItemViews.removeValue(forKey: pocId)
                     
                 }
                 
             })
             
         }
         
        func pausePoc(pocId: UUID, name: String){
            
            addToDom(ConfirmView(type: .yesNo, title: "Confirme Pausa", message: "¿Realmente desea pausar el producto \(name.uppercased())?"){ isConfirm, reason in
                 
                loadingView(show: true)
                
                API.custPOCV1.pausePOC(
                    pocId: pocId
                ) { resp in
                
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else{
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    self.productItemViews[pocId]?.remove()
                    
                    self.productItemViews.removeValue(forKey: pocId)
                    
                }
                
            })
            
        }
        
        
    }
}
