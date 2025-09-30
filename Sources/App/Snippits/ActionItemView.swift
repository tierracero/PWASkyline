//
//  ActionItemView.swift
//
//
//  Created by Victor Cantu on 7/17/22.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class ActionItemView: Div {
    
    override class var name: String { "div" }

    /// Object Refrence, this will be modified everytime  we have a modification on the value of the refrence
    var objects: [UUID: CustSaleActionObjectItems] = [:]
    
    let constructoreid: UUID
    
    let item: CustSaleActionItem
    
    private var callback: ((
        _ data: CustSaleActionObjectConstructor
    ) -> ())
    
    init(
        constructoreid: UUID,
        item: CustSaleActionItem,
        callback: @escaping ((
            _ data: CustSaleActionObjectConstructor
        ) -> ())
    ) {
        self.constructoreid = constructoreid
        self.item = item
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var itemBody = Div()
    
    @DOM override var body: DOM.Content {
        
        H2(item.name).color(.lightBlueText)
        
        self.itemBody
        
        Div()
            .borderBottom(width: .thin, style: .solid, color: .black)
            .class(.clear)
    }
    
    override func buildUI() {
        super.buildUI()
        
        item.objects.forEach { obj in
            
            let id: UUID = .init()
            
            objects[id] = .init(
                id: id,
                type: obj.type,
                title: obj.title,
                help: obj.help,
                placeholder: obj.placeholder,
                value: "",
                options: obj.options,
                isRequired: obj.isRequired,
                customerMessage: obj.customerMessage
            )
            
            let itemGrid = Div()
            
            switch obj.type{
            case .textField:
                
                itemGrid.appendChild(InputText()
                    .placeholder(obj.placeholder)
                    .class(.textFiledLightLarge)
                    .onKeyUp { tf in
                        self.objects[id]?.value = tf.text
                        self.updateData()
                    })
                
            case .textArea:
                
                itemGrid.appendChild(TextArea()
                    .placeholder(obj.placeholder)
                    .class(.textFiledLightLarge)
                    .height(90.px)
                    .onKeyUp { tf in
                        self.objects[id]?.value = tf.text
                        self.updateData()
                    })
                
            case .checkBox, .instruction:
                @State var bool: Bool = false
                
                $bool.listen{
                    self.objects[id]?.value = ($0 ? "si" : "no")
                    self.updateData()
                }
                
                itemGrid.appendChild(InputCheckbox().toggle($bool))
                
            case .selection:
                
                let select = Select{
                    Option("Seleccione Opcion")
                        .value("")
                }
                    .height(50.px)
                    .width(90.percent)
                    .class(.textFiledLightLarge)
                    .onChange { event, tf in
                        self.objects[id]?.value = tf.text
                        self.updateData()
                    }
                
                obj.options.forEach { val in
                    select.appendChild(
                        Option(val)
                            .value(val)
                    )
                }
                
                itemGrid.appendChild(select)
            case .radio:
                
                obj.options.forEach { val in
                    
                    itemGrid.appendChild(Div {
                        
                        Div {
                            InputRadio()
                                .name("optionRadio")
                                .onClick {
                                    self.objects[id]?.value = val
                                    self.updateData()
                                }
                        }
                        .class(.oneThird)
                        
                        Div(val)
                        .class(.twoThird)
                    })
                }
            }
            
            self.itemBody.appendChild(
                
                Div{
                
                    Div(obj.title)
                        .color({ obj.isRequired ? .red : .black }())
                        .class(.oneHalf)
                    
                    itemGrid
                        .class(.oneHalf)
                    
                    Div(obj.help).color(.gray)
                    
                    Div().class(.breaks)
                        .borderBottomColor(.black)
                }
                
            )
        }
    }
    
    func updateData(){
        
        callback(.init(
            id: self.constructoreid,
            custSaleAction: item.id,
            name: item.name,
            productionTime: item.productionTime,
            workforceLevel: item.workforceLevel,
            productionLevel: item.productionLevel,
            objects: self.objects.map{$1}
        ))
    }
}
