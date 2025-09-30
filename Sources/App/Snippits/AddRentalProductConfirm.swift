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
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var itemdiv = Div()
    lazy var options = Div()
    lazy var avatar = Img()
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.uiView1)
                .onClick{
                    self.remove()
                    
                }
            
            H1("Datos del Producto")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(12.px)
            
            // General Product data
            Div{
                
                Div{
                
                    self.avatar
                        .src("/skyline/media/tc-logo-512x512.png")
                        .height(150.px)
                    
                }
                .align(.center)
                
                Div().class(.clear)
                
                Div{
                    Span("TDP: \(self.poc.productionTime.toString) mins")
                        .float(.right)
                    Span("Nombre")
                }
                
                
                
                Div().class(.clear)
                
                Strong(self.poc.name)
                
                
                Div().class(.clear)
                
                Span("Descripción")
                
                Div().class(.clear)
                
                Strong(self.poc.smallDescription)
                
                Div().class(.clear)
                
                Div{
                    Span("Descripcion")
                        .float(.left)
                    
                    Strong("$\(self.cost.formatMoney)")
                }
                .fontSize(24.px)
                .align(.right)
                .marginTop(7.px)
                .marginBottom(7.px)
                .marginRight(7.px)
                
                Div().class(.clear)
                
                TextArea(self.$descr)
                    .placeholder("Ingrese descripción")
                    .fontSize(24.px)
                    .width(98.percent)
                    .height(100.px)
                
                //description
                
            }
            .class(.oneThird)
            .fontSize(18.px)
            
            // Product Options
            Div{
                
                self.options
                    .height(400.px)
                    .class(.roundBlue)
                    .overflow(.auto)
                    .padding(all: 7.px)
                    .custom("width","calc(100% - 14px)")
                
                Div().class(.clear)
            }
            .width(45.percent)
            .float(.left)
            
            // Items (fisical items)
            Div{
                H2("Productos")
                    .marginLeft(7.px)
                    .marginRight(7.px)
                
                self.itemdiv
                    .height(364.px)
                    .class(.roundBlue)
                    .overflow(.auto)
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                
            }
            .width(22.percent)
            .float(.left)
            
            Div().class(.clear)
            
            Div{
                
                Div{
                    Strong("+ Agregar Producto")
                        .fontSize(24.px)
                }
                .align(.center)
                .marginTop(9.px)
                .class(.smallButtonBox)
                .onClick(self.addItem)
            }
            .align(.right)
        }
        .padding(all: 12.px)
        .top(20.percent)
        .width(75.percent)
        .custom("left", "calc(12.5% - 12px)")
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
    
        switch self.costType{
        case .cost_a:
            cost = poc.pricea
        case .cost_b:
            cost = poc.priceb
        case .cost_c:
            cost = poc.pricec
        }
        
        self.poc.rentalActions.forEach { action in
            
            options.appendChild(H2(action.name))
            
            options.appendChild(Div().class(.clear))
            
            options.appendChild(Span(action.smallDescription).fontSize(18.px))
            
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
                            .color(.red)
                            .fontSize(24.px)
                    )
                    
                }
                else {
                    optionDiv.appendChild(
                        Label(option.name)
                            .fontSize(24.px)
                    )
                }
                
                switch option.type {
                case .selection:
                    
                    let select = Select()
                        .fontSize(24.px)
                        .class(.textFiledLight)
                        .width(90.percent)
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
                    innerDiv.appendChild(
                        Span(option.help)
                    )
                case .addSum:
                    
                    innerDiv.appendChild(
                        InputText()
                            .placeholder(option.help)
                            .onKeyUp { input, event in
                                self.optionValues[action.id]?[option.id] = input.text
                            }
                            .width(90.percent)
                            .class(.textFiledLight)
                    )

                case .textField:
                    innerDiv.appendChild(
                        InputText()
                            .fontSize(24.px)
                            .placeholder(option.help)
                            .onKeyUp { input, event in
                                self.optionValues[action.id]?[option.id] = input.text
                            }
                            .width(90.percent)
                            .class(.textFiledLight)
                    )
                case .textArea:
                    innerDiv.appendChild(
                        TextArea()
                            .fontSize(24.px)
                            .placeholder(option.help)
                            .onKeyUp { input, event in
                                self.optionValues[action.id]?[option.id] = input.text
                            }
                            .width(90.percent)
                            .height(70.px)
                            .class(.textFiledLight)
                    )
                case .checkBox:
                    break
                case .instruction:
                    break
                }
                
                innerDiv.appendChild(Span(option.help))
                
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
                Div{
                    
                    box
                        .float(.left)
                        .checked(self.$selecteItem.map{
                            if item.id == self.selecteItem {
                                return true
                            }
                            else{
                                return false
                            }
                        })
                    
                    Strong(item.ecoNumber)
                        .fontSize(24.px)
                    
                }
                    .class(.smallButtonBox)
                    .align(.right)
                    .padding(all: 12.px)
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
            showError(.campoRequerido, "Seleccione producto para continuar")
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
                    showError(.campoRequerido, "\(object.name) REQUERIDO")
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
}
