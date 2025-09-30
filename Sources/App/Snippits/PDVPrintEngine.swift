//
//  PDVPrintEngine.swift
//  
//
//  Created by Victor Cantu on 3/20/23.
//


import Foundation
import TCFundamentals
import Web

class PDVPrintEngine: Div {
    
    let custAcct: CustAcct?
    let custSale: CustSale
    let custPOCInventory: [CustPOCInventorySoldObject]
    let custPurchesOrder: [CustSaleAdditinalManager]
    let custPickUpOrder: [CustSaleAdditinalManager]
    let pocs: [String:CustPOCQuick]
    let inventory: [String:CustPOCInventorySoldObject]
    let charges: [CustAcctChargesQuick]
    // TODO: also make available for other forms of print other than miniprinter
    let cardex: [CustPOCCardex]
    
    init(
        custAcct: CustAcct?,
        custSale: CustSale,
        custPOCInventory: [CustPOCInventorySoldObject],
        custPurchesOrder: [CustSaleAdditinalManager],
        custPickUpOrder: [CustSaleAdditinalManager],
        pocs: [String:CustPOCQuick],
        inventory: [String:CustPOCInventorySoldObject],
        charges: [CustAcctChargesQuick],
        cardex: [CustPOCCardex]
    ) {
        self.custAcct = custAcct
        self.custSale = custSale
        self.custPOCInventory = custPOCInventory
        self.custPurchesOrder = custPurchesOrder
        self.custPickUpOrder = custPickUpOrder
        self.pocs = pocs
        self.inventory = inventory
        self.charges = charges
        self.cardex = cardex
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    
    override class var name: String { "div" }
    
    /// [ CustPOC.id : CustPOCCardex ]
    var cardexRefrence: [UUID:CustPOCCardex] = [:]
    
    lazy var orderImg = Img()
    
    lazy var chargesData = Table{
        Tr{
            Td("Description")
            Td("Unis").width(50.px)
            Td("CUni").width(70.px)
            Td("STotal").width(70.px)
        }
    }.width(100.percent)
    
    var logo = "/skyline/media/logoTierraCeroLongBlack.svg"
    
    var createdAt = ""
    
    var fontSizeTile = 22.px
    
    var fontSizeSubTitle = 18.px
    
    var fontSizeBody = 16.px
    
    lazy var storeData = Div{
        
        Strong("Orden de Venta \(self.custSale.folio)")
            .fontSize(18.px)
        
        Div(getDate(self.custSale.createdAt).formatedLong)
        
        Br()
    }
    
    lazy var purchaseOrdersDiv = Div()
    
    lazy var transferOrdersDiv = Div()
    
    lazy var qrInternal = Div()
        .marginBottom(7.px)
        .marginTop(12.px)
        .id(Id(stringLiteral: "qrInternal"))
    
    @DOM override var body: DOM.Content {
        
        switch configStore.printPdv.document {
        case .letter:
            H1("Documento no soportado")
        case .halfLetter:
            H1("Documento no soportado")
        case .miniprinter:
            Div{
                
                Div{
                    Img()
                        .src(self.logo)
                        .maxWidth(200.px)
                        .maxHeight(70.px)

                    self.storeData
                    
                }
                .align(.center)
                
                Br()
                
                if let custAcct = self.custAcct {
                    
                    Div{
                        
                        Div{
                            Span("# Cuenta")
                                .fontSize(self.fontSizeSubTitle)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Span(custAcct.folio)
                                .fontSize(self.fontSizeSubTitle)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).height(7.px)
                        
                        Div("Cliente")
                            .fontSize(self.fontSizeBody)
                        
                        Div("\(custAcct.businessName) \(custAcct.fiscalRfc) \(custAcct.fiscalRazon) \(custAcct.firstName) \(custAcct.lastName)".purgeSpaces)
                            .fontSize(self.fontSizeSubTitle)
                        
                        Div().clear(.both).height(7.px)
                        
                    }
                }
                
                self.chargesData
                
                Div{
                    Svg()
                        .id(Id(stringLiteral: "barcode"))
                }
                .align(.center)
                Div{
                    self.qrInternal
                }
                .margin(all: 7.px)
                .align(.center)
                
                Br()
                
                self.purchaseOrdersDiv
                
                Br()
                
                self.transferOrdersDiv
                
            }.width(400.px)
        case .pdf:
            H1("Documento no soportado")
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        if let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
            if !_logo.isEmpty {
                logo = "/contenido/\(_logo)"
            }
        }
        
        cardexRefrence = Dictionary(uniqueKeysWithValues: cardex.map{ item in ( item.pocId, item ) })
        
        stores.forEach { storeid, store in
            
            if custSale.custStore ==  storeid {
                
                self.storeData.appendChild(
                    Small {
                        
                        Span("SUC:").marginRight(3.px)
                        Strong(store.name).marginRight(3.px)
                        Span(store.telephone).marginRight(3.px)
                        Br()
                        Span(store.street).marginRight(3.px)
                        Span(store.colony).marginRight(3.px)
                        Span(store.city).marginRight(3.px)
                        Br()
                        Span(store.schedulea).marginRight(3.px)
                        Span(store.scheduleb).marginRight(3.px)
                        Span(store.schedulec).marginRight(3.px)
                        Br()
                    }
                        .fontSize(16.px)
                )
            }
            
        }
        
        var itemsWithInventory: [ UUID : [CustPOCInventorySoldObject] ] = [:]
        
        var itemsWithNoInventory: [ UUID : [CustPOCInventorySoldObject] ] = [:]
        
        var granTotal: Int64 = 0
        
        custPOCInventory.forEach { item in
            
            if let _ = item.custStoreSecciones {
                
                if let _ = itemsWithInventory[item.POC] {
                    itemsWithInventory[item.POC]?.append(item)
                }
                else{
                    itemsWithInventory[item.POC] = [item]
                }
                
            }
            else{
                
                if let _ = itemsWithNoInventory[item.POC] {
                    itemsWithNoInventory[item.POC]?.append(item)
                }
                else{
                    itemsWithNoInventory[item.POC] = [item]
                }
                
            }
        }
        
        itemsWithInventory.forEach { id, items in
            
            guard let poc = pocs[id.uuidString.uppercased()] else {
                return
            }
            
            var units = items.count
            
            var total:Int64 = 0
            
            items.forEach { item in
                total += (item.soldPrice ?? 0)
            }
            
            granTotal += total
            
            var ticketCode = "\(poc.brand) \(poc.model)"
            
            if !poc.upc.isEmpty {
                ticketCode = poc.upc
            }
            
            chargesData.appendChild(
                Tr{
                    Td("\(ticketCode) \(poc.name)".purgeSpaces)
                    Td(units.toString)
                    Td((total / items.count.toInt64).formatMoney)
                    Td(total.formatMoney)
                }
            )
            
            if let cardexInfo = cardexRefrence[id] {
                chargesData.appendChild(
                    Tr{
                        Td("Cardex".purgeSpaces)
                        Td(cardexInfo.initialUnits.toString)
                        Td(cardexInfo.processedUnits.toString)
                        Td(cardexInfo.finalUnits.toString)
                    }.color(.gray)
                )
            }
            
        }
        
        itemsWithNoInventory.forEach { id, items in
        
            guard let poc = pocs[id.uuidString.uppercased()] else {
                return
            }
            
            var units = items.count
            
            var soldPrice: Int64 = 0
            
            var total:Int64 = 0
            
            items.forEach { item in
                total += (item.soldPrice ?? 0)
                soldPrice = (item.soldPrice ?? 0)
            }
            
            granTotal += total
            
            chargesData.appendChild(
                Tr{
                    Td("\(poc.brand) \(poc.model) \(poc.name) ** EN PEDIDO **".purgeSpaces)
                    Td(units.toString)
                    Td(soldPrice.formatMoney)
                    Td(total.formatMoney)
                }
            )
            
        }
        
        charges.forEach { obj in
            
           let stotal = ((obj.price * (obj.cuant / 100)) )
            
           granTotal += stotal
           
           chargesData.appendChild(
               Tr {
                   Td(obj.name)
                   Td(obj.cuant.fromCents.toString)
                   Td(obj.price.formatMoney)
                   Td(stotal.formatMoney)
               }
           )
        }
        
        chargesData.appendChild(Tr{
            Td()
            Td()
            Td("Total")
            Td(granTotal.formatMoney)
        })
        
        custPurchesOrder.forEach { order in
            
            let view = Div{
                Div().height(48.px)
                
                
                Img()
                    .src(self.logo)
                    .maxWidth(200.px)
                    .maxHeight(70.px)
                Br()
                
                Strong("Orden de Compra \(order.folio)")
                    .fontSize(18.px)
                
                Br()
                
            }
                .align(.center)
            
            stores.forEach { storeid, store in
                
                if order.custStore ==  storeid {
                    
                    view.appendChild(
                        Small {
                            
                            Span("SUC:").marginRight(3.px)
                            Strong(store.name).marginRight(3.px)
                            Span(store.telephone).marginRight(3.px)
                            Br()
                            Span(store.street).marginRight(3.px)
                            Span(store.colony).marginRight(3.px)
                            Span(store.city).marginRight(3.px)
                            Br()
                            Strong("Horarios").marginRight(3.px)
                            Br()
                            Span(store.schedulea).marginRight(3.px)
                            Br()
                            Span(store.scheduleb).marginRight(3.px)
                            Br()
                            Span(store.schedulec).marginRight(3.px)
                            Br()
                        }
                            .fontSize(14.px)
                    )
                }
            }
            
            lazy var itemsTable = Table{
                Tr{
                    Td("Unis").width(50.px)
                    Td("Description")
                }
            }.width(100.percent)
            
            if let data = order.items.replace(from: " ", to: "").data(using: .utf8) {
                
                do {
                    let items = try JSONDecoder().decode( [ String : [String] ].self, from: data)
                    
                    items.forEach { pocid, pocids in
                        
                        guard let poc = pocs[pocid.uppercased()] else {
                            return
                        }
                        
                        var units = pocids.count
                        
                        itemsTable.appendChild(
                            Tr{
                                Td(units.toString)
                                Td("\(poc.brand) \(poc.model) \(poc.name)".purgeSpaces)
                            }
                        )
                        
                    }
                    
                }
                catch {
                    print("❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ")
                    print(error)
                }
                
            }
            
            view.appendChild(itemsTable)
            
            view.appendChild(Div{
                Div("Cliente: \(order.firstName) \(order.lastName)")
                Div("ID: \(order.idNumber)")
            })
            
            view.appendChild(Div{
                Svg()
                    .id(Id(stringLiteral: "BC_\(order.id.uuidString.uppercased())"))
            }
            .align(.center))
            
            view.appendChild(Div()
                .marginBottom(7.px)
                .marginTop(12.px)
                .id(Id(stringLiteral: "QR_\(order.id.uuidString.uppercased())")))
            
            self.purchaseOrdersDiv.appendChild(view)
            
        }
    }
}
