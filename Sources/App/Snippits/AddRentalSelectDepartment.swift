//
//  AddRentalSelectDepartment.swift
//  
//
//  Created by Victor Cantu on 6/2/22.
//

import Foundation
import TCFundamentals
import Web

class AddRentalSelectDepartment: Div {
    
    override class var name: String { "div" }
    
    var products: [CustStoreDepsRental] = []
    
    var costType: CustAcctCostTypes
    var currentUsedIDs: [UUID]
    var uts: Double
    var highPriority: Bool
    private var callback: ((_ rental: RentalObject?) -> ())
    
    init(
        costType: CustAcctCostTypes,
        currentUsedIDs: [UUID],
        uts: Double,
        highPriority: Bool,
        callback: @escaping ((_ rental: RentalObject?) -> ())
    ) {
        self.costType = costType
        self.currentUsedIDs = currentUsedIDs
        self.uts = uts
        self.callback = callback
        self.highPriority = highPriority
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var prductGrid = Div()
    
    lazy var innerBody = Div{
        Img()
            .closeButton(.subView)
            .onClick{
                self.callback(nil)
                self.remove()
                
            }
        
        H1("Seleccione Departamento")
            .color(.lightBlueText)
        
        Div()
            .class(.clear)
            .marginTop(12.px)
        
        H3("Datos del Cliente")
        
        Div().class(.clear)
        
        self.prductGrid
    }
    
    @DOM override var body: DOM.Content {
        innerBody
        .padding(all: 12.px)
        .top(10.percent)
        .height(80.percent)
        .width(80.percent)
        .custom("left", "calc(10% - 12px)")
        .position(.absolute)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
        
    }
    
    override func buildUI() {
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
        
        API.custAPIV1.loadRentalStoreLevels(id: nil, full: nil) { resp in
            
            guard let resp  else {
                return
            }
            
            
             guard let data = resp.data else {
                 showError(.errorGeneral, .unexpenctedMissingPayload)
                 return
             }
             
            
            data.forEach { dep in
                let img = Img()
                self.prductGrid.appendChild(
                    Div{
                        img
                            .src("/skyline/media/tc-logo-512x512.png")
                            .height(70.percent)
                        Div().class(.clear)
                        Span(dep.name)
                    }
                        .cursor(.pointer)
                        .class(.roundBlue)
                        .float(.left)
                        .align(.center)
                        .height(150.px)
                        .width(150.px)
                        .backgroundColor(.white)
                        .borderRadius(all: 12.px)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .onClick {
                            
                            print(Int(self.uts))
                            
//                            return
                            
                            loadingView(show: true)
                            
                            API.custPOCV1.loadDepPOCInventory(
                                depid: dep.id,
                                storeid: custCatchStore,
                                uts: Int64(self.uts),
                                highPriority: self.highPriority
                            ) { resp in
                                
                                loadingView(show: false)
                                
                                guard let resp = resp else {
                                    showError(.errorDeCommunicacion, "No se pudo comuncar con del servidor")
                                    return
                                }
                                
                                guard resp.status == .ok else{
                                    showError(.errorDeCommunicacion, "No se pudo comuncar con del servidor")
                                    return
                                }
                                
                                 guard let data = resp.data else {
                                     showError(.errorGeneral, .unexpenctedMissingPayload)
                                     return
                                 }
                                 
                                self.innerBody.appendChild(
                                    /// shows squered off button of departments
                                    AddRentalSelectProduct(costType: self.costType, currentUsedIDs: self.currentUsedIDs, pocs: data.pocs, callback: { poc in
                                        self.appendChild(
                                            /// Shows confirmation window
                                            /// icon, detail , data and inventory list
                                            AddRentalProductConfirm(costType: self.costType, currentUsedIDs: self.currentUsedIDs, poc:  poc, callback: { rentalObject in
                                                
                                                rentalObject.items.forEach { item in
                                                    self.currentUsedIDs.append(item.itemid)
                                                }
                                                
                                                self.callback(rentalObject)
                                                
                                                showSuccess(.operacionExitosa, "Se agergo Producto", .short)
                                                
                                            })
                                        )
                                    })
                                )
                            }
                        }
                )
                if !dep.coverLandscape.isEmpty {
                    img.load("https://baronrojotrajes.com/contenido/thump_\(dep.coverLandscape)")
                }
            }
        }
    }
    
    func addItem(){
        
    }
    
}
