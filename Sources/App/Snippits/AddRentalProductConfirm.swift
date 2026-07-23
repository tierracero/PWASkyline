//
//  AddRentalProductConfirm.swift
//  
//
//  Created by Victor Cantu on 6/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class AddRentalProductConfirm: Div {
    
    override class var name: String { "div" }
    
    @State var descr = ""
    /// `Action`[UUID] -> `Option`[UUID] -> `Value`[String]
    var optionValues: [UUID:[UUID:String]] = [:]
    @State var selecteItem: UUID? = nil
    var ecoNumber = ""
    var cost: Int64 = 0
    
    var costType: CustAcctCostTypes
    var currentUsedIDs: [UUID]
    var poc: API.custPOCV1.LoadDepPOCInventoryResponse.POC
    private var callback: ((_ product: RentalObject) -> ())
    
    init(
        costType: CustAcctCostTypes,
        currentUsedIDs:  [UUID],
        poc: API.custPOCV1.LoadDepPOCInventoryResponse.POC,
        callback: @escaping ((_ product: RentalObject) -> ())
    ) {
        self.costType = costType
        self.currentUsedIDs = currentUsedIDs
        self.poc = poc
        self.callback = callback

        switch costType {
        case .cost_a:
            self.cost = poc.pricea
        case .cost_b:
            self.cost = poc.priceb
        case .cost_c:
            self.cost = poc.pricec
        }

        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var itemdiv = Div()
    lazy var options = Div()
    lazy var avatar = Img()
    
    @DOM override var body: DOM.Content {
        VPopUp(.semiFull) {
            VTitle("Datos del producto") {
                USmallTitle(self.poc.name)
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.oneForth) {
                    VBox(.raised) {
                        self.avatar
                            .src("/skyline/media/tc-logo-512x512.png")
                            .width(130.px)
                            .height(130.px)
                            .custom("object-fit", "contain")
                            .custom("align-self", "center")

                        UTitle(self.poc.name)
                            .marginTop(10.px)

                        UMinorTitle(self.poc.smallDescription)
                            .marginTop(5.px)
                            .custom("line-height", "1.4")

                        Div {
                            USmallTitle("TDP · \(self.poc.productionTime.toString) min")
                            USubTitle("$\(self.cost.formatMoney)")
                        }
                        .display(.flex)
                        .custom("align-items", "center")
                        .custom("justify-content", "space-between")
                        .custom("gap", "8px")
                        .marginTop(14.px)
                        .paddingTop(12.px)
                        .custom("border-top", "1px solid var(--tc-beta-border)")

                        UField("Descripción", required: false) {
                            TextArea(self.$descr)
                                .placeholder("Ingrese descripción")
                                .width(100.percent)
                                .height(105.px)
                        }
                        .marginTop(14.px)
                    }
                    .height(100.percent)
                    .display(.flex)
                    .custom("flex-direction", "column")
                }

                VGrid(.half) {
                    VBox {
                        UTitle("Configuración")
                        UMinorTitle("Complete las opciones requeridas para este producto.")
                            .marginTop(4.px)

                        self.options
                            .custom("height", "min(560px, calc(100vh - 230px))")
                            .overflow(.auto)
                            .marginTop(12.px)
                            .paddingRight(5.px)
                    }
                    .height(100.percent)
                }

                VGrid(.oneForth) {
                    VBox {
                        UTitle("Productos")
                        UMinorTitle("Seleccione una unidad disponible.")
                            .marginTop(4.px)

                        self.itemdiv
                            .custom("height", "min(560px, calc(100vh - 230px))")
                            .overflow(.auto)
                            .marginTop(12.px)
                            .paddingRight(5.px)
                    }
                    .height(100.percent)
                }

                VGrid(.full) {
                    ULargeButton("+ Agregar producto")
                        .float(.right)
                        .onClick(self.addItem)
                }
            }
        }
    }
    
    override func buildUI() {
        super.buildUI()

        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
    
        self.poc.rentalActions.forEach { action in
            
            options.appendChild(UTitle(action.name))
            
            options.appendChild(Div().class(.clear))
            
            options.appendChild(
                UMinorTitle(action.smallDescription)
                    .custom("line-height", "1.4")
            )
            
            options.appendChild(Div().class(.clear))
            
            optionValues[action.id] = [:]
            
            action.objects.forEach { option in
            
                self.optionValues[action.id]?[option.id] = ""
                
                /// .section div
                let optionDiv = Div().class(.section)
                
                /// .section inner div
                let innerDiv = Div()
                
                if option.isRequired {
                    optionDiv.appendChild(
                        Label(option.name)
                            .custom("color", "var(--tc-beta-orange-hot)")
                            .fontSize(15.px)
                    )
                    
                }
                else {
                    optionDiv.appendChild(
                        Label(option.name)
                            .fontSize(15.px)
                    )
                }
                
                switch option.type {
                case .selection:
                    
                    let select = Select()
                        .fontSize(15.px)
                        .class(.textFiledBlackDark)
                        .width(100.percent)
                        .height(36.px)
                        .onChange { event, select in
                            self.optionValues[action.id]?[option.id] = select.value
                        }
                    
                    select.appendChild(
                        Option("-- Seleccione --")
                            .value("")
                    )
                    
                    option.options.forEach { val in
                        select.appendChild(
                            Option(val)
                                .value(val)
                        )
                    }
                    
                    innerDiv.appendChild(
                        select
                    )
                case .addSum:
                    
                    innerDiv.appendChild(
                        InputText()
                            .placeholder(option.help)
                            .onKeyUp { input, event in
                                self.optionValues[action.id]?[option.id] = input.text
                            }
                            .width(100.percent)
                            .class(.textFiledBlackDark)
                    )

                case .textField:
                    innerDiv.appendChild(
                        InputText()
                            .fontSize(15.px)
                            .placeholder(option.help)
                            .onKeyUp { input, event in
                                self.optionValues[action.id]?[option.id] = input.text
                            }
                            .width(100.percent)
                            .class(.textFiledBlackDark)
                    )
                case .textArea:
                    innerDiv.appendChild(
                        TextArea()
                            .fontSize(15.px)
                            .placeholder(option.help)
                            .onKeyUp { input, event in
                                self.optionValues[action.id]?[option.id] = input.text
                            }
                            .width(100.percent)
                            .height(70.px)
                            .class(.textFiledBlackDark)
                    )
                case .checkBox:
                    break
                case .instruction:
                    break
                }
                
                innerDiv.appendChild(
                    UMinorTitle(option.help)
                        .marginTop(4.px)
                )
                
                optionDiv.appendChild(innerDiv)
                
                options.appendChild(optionDiv)
                
                options.appendChild(Div().class(.clear))
                
            }
            
            options.appendChild(
                Div().class(.clear)
                    .borderTop(width: .thin, style: .solid, color: .gray)
                    .marginTop(7.px)
                    .paddingBottom(7.px)
            )
            
        }
        
        self.poc.inventroy.forEach { item in
            
            guard !self.currentUsedIDs.contains(item.id) else {
                return
            }
            
            let box = InputCheckbox()
            
            itemdiv.appendChild(
                VBox(.interactive) {
                    
                    box
                        .width(18.px)
                        .height(18.px)
                        .checked(self.$selecteItem.map{
                            if item.id == self.selecteItem {
                                return true
                            }
                            else{
                                return false
                            }
                        })
                    
                    Div {
                        USubTitle(item.ecoNumber)
                        USmallTitle("Disponible")
                            .marginTop(3.px)
                    }
                    
                }
                    .display(.grid)
                    .custom("grid-template-columns", "auto minmax(0, 1fr)")
                    .custom("align-items", "center")
                    .custom("gap", "10px")
                    .padding(all: 10.px)
                    .marginBottom(7.px)
                    .onClick{
                        self.selecteItem = item.id
                        self.ecoNumber = item.ecoNumber
                    }
            )
        }
    
        if !poc.avatar.isEmpty {
            if let pDir = customerServiceProfile?.account.pDir {
                avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.avatar)")
            }
        }
        
    }
    
    func addItem(){
        
        guard let itemid = self.selecteItem else {
            showError(.requiredField, "Seleccione producto para continuar")
            return
        }
        
        var allFiledsAreValid = true
        
        var rentalObject: RentalObject = .init(
            pocid: self.poc.id,
            name: self.poc.name,
            cost: self.cost,
            productionTime: self.poc.productionTime,
            items: []
        )
        
        var rentalObjectProduct: RentalProduct = .init(
            itemid: itemid,
            ecoNumber: self.ecoNumber,
            rentalActions: [],
            description: self.descr
        )
        
        self.poc.rentalActions .forEach { action in
            
            var act: RentalProductAction = .init(actionid: action.id, name: action.name, objects: [])
            
            action.objects.forEach { object in
                
                let value = self.optionValues[action.id]?[object.id] ?? ""
                
                if object.isRequired && value.isEmpty {
                    allFiledsAreValid = false
                    showError(.requiredField, "\(object.name) REQUERIDO")
                }
                
                let opt: RentalProductObjects = .init(id: object.id, name: object.name, value: value)
            
                act.objects.append(opt)
                
            }
            
            rentalObjectProduct.rentalActions.append(act)
            
        }
        
        rentalObject.items.append(rentalObjectProduct)
        
        if !allFiledsAreValid {
            return
        }
        
        self.callback(rentalObject)
        
        self.remove()
        
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $descr.removeAllListeners()
        $selecteItem.removeAllListeners()
    }
}
