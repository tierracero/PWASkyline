//
//  StartServiceOrderEquipmentView.swift
//  
//
//  Created by Victor Cantu on 4/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class StartServiceOrderEquipmentView: Div {
    
    override class var name: String { "div" }
    
    @State var equipment: EquipmentObject?
    
    var refid: UUID

    private var callback: ((
        _ equipment: EquipmentObject
    ) -> ())
    
    init(
        equipment: EquipmentObject?,
        callback: @escaping ((
            _ equipment: EquipmentObject
        ) -> ())
    ) {
        self.equipment = equipment
        self.callback = callback
        
        self.refid = equipment?.refid ?? .init()
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var selectEquipmentField = ""
    
    @State var _idTag1: String = ""
    @State var _idTag2: String = ""
    @State var _tag1: String = ""
    @State var _tag2: String = ""
    @State var _tag3: String = ""
    @State var _tag4: String = ""
    @State var _tag5: String = ""
    @State var _tag6: String = ""
    @State var _descr: String = ""
    @State var _checkTag1: Bool = false
    @State var _checkTag2: Bool = false
    @State var _checkTag3: Bool = false
    @State var _checkTag4: Bool = false
    @State var _checkTag5: Bool = false
    @State var _checkTag6: Bool = false
    
    lazy var idTag1 = InputText(self.$_idTag1)
        .autocomplete(.off)
        .placeholder(configServiceTags.idTagPlaceholder)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
        .onFocus {
            self.selectEquipmentField = "idTag1"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var idTag2 = InputText(self.$_idTag2)
        .autocomplete(.off)
        .placeholder(configServiceTags.secondIDTagPlaceholder)
        .class(.textFiledLightLarge)
        .custom("width", "calc(100% - 10px)")
        .onFocus {
            self.selectEquipmentField = "idTag2"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    var tag3CurrentSeleccionList: [UUID] = []
    var tag1CurrentSeleccionList: [UUID] = []
    var tag2CurrentSeleccionList: [UUID] = []
    
    @State var curOrderManagerBrand: [CustOrderManagerBrand] = []
    
    @State var curOrderManagerType: [CustOrderManagerType] = []
    
    @State var curOrderManagerModel: [CustOrderManagerModel] = []
    
    /// Brand
    @State var tag1PreSelctedItemID: UUID? = nil
    @State var tag1SelctedItemID: UUID? = nil
    
    /// Type eg:  X Box Play station iPhone Celular iPad Tablet Refrigerador...
    @State var tag3isDisabeld = true
    @State var tag3PreSelctedItemID: UUID? = nil
    @State var tag3SelctedItemID: UUID? = nil
    
    /// Model
    @State var tag2isDisabeld = true
    @State var tag2PreSelctedItemID: UUID? = nil
    @State var tag2SelctedItemID: UUID? = nil
    
    lazy var tag1Label = Label(configServiceTags.tag1Name)
        .float(.right)
        .color(self.$selectEquipmentField.map{ $0 == "tag1" ? .black : .gray })
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag1" ? 18.px : 12.px })
    
    lazy var tag1 = InputText(self.$_tag1)
        .autocomplete(.off)
        .placeholder(configServiceTags.tag1Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag1"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag1Results =  Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
                    Span{
                        Img()
                            .src("/skyline/media/add.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(12.px)
                            
                        
                        Label("Agregar")
                            .fontSize(32.px)
                            .color(.black)
                            .cursor(.pointer)
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.addOrderManagerBrand()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            
            }
        }
        .width(100.percent)
        .height(130.px)
    }
    .maxHeight(300.px)
    .overflow(.auto)
    
    lazy var tag1ResultsView = Div{
        self.tag1Results
        Div(" + Agregar ")
            .padding(all: 12.px)
            .fontWeight(.bolder)
            .fontSize(24.px)
            .color(.black)
            .cursor(.pointer)
            .marginTop(7.px)
            .align(.center)
            .cursor(.pointer)
            .onClick(self.addOrderManagerBrand)
        
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    .position(.absolute)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    
    lazy var tag2Label = Label(configServiceTags.tag2Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag2" ? 18.px : 12.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag2" ? .black : .gray })
        .float(.right)

    lazy var tag2 = InputText(self.$_tag2)
        .placeholder(configServiceTags.tag2Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .autocomplete(.off)
        .onFocus {
            self.selectEquipmentField = "tag2"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag2Results = Div {
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
                    Span{
                        Img()
                            .src("/skyline/media/add.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(12.px)
                            
                        
                        Label("Agregar")
                            .fontSize(32.px)
                            .color(.black)
                            .cursor(.pointer)
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.addOrderManagerModel()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .width(100.percent)
        .height(130.px)
    }
        .maxHeight(300.px)
        .overflow(.auto)
    
    
    lazy var tag2ResultsView = Div{
        self.tag2Results
        
        Div(" + Agregar")
            .padding(all: 12.px)
            .fontWeight(.bolder)
            .fontSize(24.px)
            .color(.black)
            .cursor(.pointer)
            .marginTop(7.px)
            .align(.center)
            .cursor(.pointer)
            .onClick{
                self.addOrderManagerModel()
            }
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    .position(.absolute)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    
    lazy var tag3Label = Label(configServiceTags.tag3Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag3" ? 18.px : 12.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag3" ? .black : .gray })
        .float(.right)
    
    lazy var tag3 = InputText(self.$_tag3)
        .placeholder(configServiceTags.tag3Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .autocomplete(.off)
        .onFocus {
            self.selectEquipmentField = "tag3"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag3Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
                    Span{
                        Img()
                            .src("/skyline/media/add.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(12.px)
                            
                        
                        Label("Agregar")
                            .fontSize(32.px)
                            .color(.black)
                            .cursor(.pointer)
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.addOrderManagerType()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .width(100.percent)
        .height(130.px)
    }
    .maxHeight(300.px)
    .overflow(.auto)
    
    lazy var tag3ResultsView = Div{
        
        self.tag3Results
        
        Div(" + Agregar ")
            .padding(all: 12.px)
            .fontWeight(.bolder)
            .fontSize(24.px)
            .color(.black)
            .cursor(.pointer)
            .marginTop(7.px)
            .align(.center)
            .cursor(.pointer)
            .onClick(self.addOrderManagerType)
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    .position(.absolute)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    
    lazy var tag4 = InputText(self.$_tag4)
        .autocomplete(.off)
        .placeholder(configServiceTags.tag4Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag4"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag5 = InputText(self.$_tag5)
        .autocomplete(.off)
        .placeholder(configServiceTags.tag5Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag5"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag6 = InputText(self.$_tag6)
        .autocomplete(.off)
        .placeholder(configServiceTags.tag6Placeholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .onFocus {
            self.selectEquipmentField = "tag6"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var descr = TextArea(self.$_descr)
        .height(90.px)
        .placeholder(configServiceTags.tagDescrPlaceholder)
        .class(.textFiledLightLarge)
        .width(100.percent)
        .custom("width", "calc(100% - 10px)")
    
    lazy var checkTag1 = InputCheckbox().toggle(self.$_checkTag1)
    
    lazy var checkTag2 = InputCheckbox().toggle(self.$_checkTag2)

    lazy var checkTag3 = InputCheckbox().toggle(self.$_checkTag3)
    
    lazy var checkTag4 = InputCheckbox().toggle(self.$_checkTag4)
    
    lazy var checkTag5 = InputCheckbox().toggle(self.$_checkTag5)
    
    lazy var checkTag6 = InputCheckbox().toggle(self.$_checkTag6)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.$equipment.map{ ($0 == nil) ? "Agregar \(configServiceTags.typeOfServiceObject.description) Adicional" : "Editar \(configServiceTags.typeOfServiceObject.description) Adicional" })
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            H2("Datos del orden")
                .color(.lightBlueText)
            
            /// `idTag1`
            Label(configServiceTags.idTagName)
                .float(.right)
                .color(self.$selectEquipmentField.map{ $0 == "idTag1" ? .black : .gray })
                .fontSize(self.$selectEquipmentField.map{ $0 == "idTag1" ? 18.px : 12.px })
            
            Div().class(.clear)
            
            self.idTag1
            
            Div().class(.clear)
            
            /// `idTag2`
            Div{
                Label(configServiceTags.secondIDTagName)
                    .float(.right)
                    .color(self.$selectEquipmentField.map{ $0 == "idTag2" ? .black : .gray })
                    .fontSize(self.$selectEquipmentField.map{ $0 == "idTag2" ? 18.px : 12.px })
                    
                Div().class(.clear)
                
                self.idTag2
                
            }.hidden(!configServiceTags.secondIDTagRequiered)
            Div().class(.clear)
            
            if configServiceTags.useBrandModelMode {
                
                ///`tag1`
                Div{
                    
                    Div{
                        
                        Label("*").color(.red)
                            .float(.right)
                            .fontWeight(.bolder)
                            .fontSize(self.$selectEquipmentField.map{ $0 == "tag2" ? 18.px : 12.px })
                        
                        self.tag1Label
                    }
                    
                    Div().class(.clear)
                    
                    self.tag1
                        .onBlur({
                            Dispatch.asyncAfter(0.3) {
                                if let id = self.tag1SelctedItemID {
                                    orderManagerBrand.forEach { brand in
                                        if brand.id == id {
                                            self._tag1 = brand.name
                                        }
                                    }
                                }
                            }
                            
                        })
                        .onKeyUp({ tf, event in
                            print(event.key)
                            
                            let key = event.key
                            
                            if (key == "ArrowUp") {
                                
                                if let id = self.tag1PreSelctedItemID {
                                    
                                    var cc = 0
                                    var curentSelected = 0
                                    
                                    self.tag1CurrentSeleccionList.forEach { _id in
                                        if id == _id {
                                            curentSelected += cc
                                        }
                                        cc += 1
                                    }
                                    
                                    print("current selected [up] \(curentSelected)")
                                    
                                    if curentSelected == 0 { return }
                                    
                                    self.tag1PreSelctedItemID = self.tag1CurrentSeleccionList[(curentSelected - 1)]
                                    
                                }
                                
                                return
                            }
                            
                            if (key == "ArrowDown") {
                                
                                if let id = self.tag1PreSelctedItemID {
                                    
                                    var cc = 0
                                    var curentSelected = 0
                                    
                                    self.tag1CurrentSeleccionList.forEach { _id in
                                        if id == _id {
                                            curentSelected += cc
                                        }
                                        cc += 1
                                    }
                                    
                                    print("current selected [down] \(curentSelected)")
                                    
                                    if (curentSelected + 1) == self.tag1CurrentSeleccionList.count { return }
                                    
                                    self.tag1PreSelctedItemID = self.tag1CurrentSeleccionList[(curentSelected + 1)]
                                    
                                }
                                
                                return
                            }
                            
                            if ignoredKeys.contains(key) { return }
                            
                            if (key == "Enter" || key == "NumpadEnter") {
                                
                                if let id = self.tag1PreSelctedItemID {
                                    
                                    orderManagerBrand.forEach { brand in
                                        if brand.id == id {
                                            if self.tag1SelctedItemID != brand.id {
                                                /// change name to selected TYPE
                                                self._tag1 = brand.name
                                                self.tag1SelctedItemID = nil
                                                self.tag1SelctedItemID = brand.id
                                                self._tag3 = ""
                                            }
                                            
                                            // Preforme Focus Acctions
                                            self.tag3.select()
                                            self.tag3Focus()
                                        }
                                    }
                                    
                                }
                                
                                return
                            }
                            
                            /// if any other key
                            self.tag1SelctedItemID = nil
                            
                            self.tag1Focus()
                            
                        })
                        .onClick({ _, event in
                            self.tag1Focus()
                            event.stopPropagation()
                        })
                    
                    self.tag1ResultsView
                    
                }
                
                Div().class(.clear)
                
                ///`tag3`
                Div{

                    Div{
                        
                        Label("*").color(.red)
                            .float(.right)
                            .fontWeight(.bolder)
                            .fontSize(self.$selectEquipmentField.map{ $0 == "tag2" ? 18.px : 12.px })
                        
                        self.tag3Label
                    }

                    Div().class(.clear)
                
                    self.tag3
                        .opacity(0.3)
                        .disabled(true)
                        .onBlur({
                            
                            Dispatch.asyncAfter(0.3) {
                                if let id = self.tag3SelctedItemID {
                                    orderManagerType.forEach { type in
                                        if type.id == id {
                                            self._tag3 = type.name
                                        }
                                    }
                                }
                            }
                            
                        })
                        .onKeyUp({ tf, event in
                            print(event.key)
                            
                            let key = event.key
                            
                            if (key == "ArrowUp") {
                                
                                if let id = self.tag3PreSelctedItemID {
                                    
                                    var cc = 0
                                    var curentSelected = 0
                                    
                                    self.tag3CurrentSeleccionList.forEach { _id in
                                        if id == _id {
                                            curentSelected += cc
                                        }
                                        cc += 1
                                    }
                                    
                                    print("current selected [up] \(curentSelected)")
                                    
                                    if curentSelected == 0 { return }
                                    
                                    self.tag3PreSelctedItemID = self.tag3CurrentSeleccionList[(curentSelected - 1)]
                                    
                                }
                                
                                return
                            }
                            
                            if (key == "ArrowDown") {
                                
                                if let id = self.tag3PreSelctedItemID {
                                    
                                    var cc = 0
                                    var curentSelected = 0
                                    
                                    self.tag3CurrentSeleccionList.forEach { _id in
                                        if id == _id {
                                            curentSelected += cc
                                        }
                                        cc += 1
                                    }
                                    
                                    print("current selected [down] \(curentSelected)")
                                    
                                    if (curentSelected + 1) == self.tag3CurrentSeleccionList.count { return }
                                    
                                    self.tag3PreSelctedItemID = self.tag3CurrentSeleccionList[(curentSelected + 1)]
                                    
                                }
                                
                                return
                            }
                            
                            if ignoredKeys.contains(key) { return }
                            
                            if (key == "Enter" || key == "NumpadEnter") {
                                
                                if let id = self.tag3PreSelctedItemID {
                                    
                                    orderManagerType.forEach { type in
                                        if type.id == id {
                                            
                                            if self.tag3SelctedItemID != type.id {
                                                /// change name to selected TYPE
                                                self._tag3 = type.name
                                                self.tag3SelctedItemID = nil
                                                self.tag3SelctedItemID = type.id
                                                self._tag2 = ""
                                            }
                                            
                                            // Preforme Focus Acctions
                                            self.tag2.select()
                                            self.tag2Focus()
                                        }
                                    }
                                    
                                }
                                
                                return
                            }
                            
                            /// if any other key
                            self.tag3SelctedItemID = nil
                            
                            self.tag3Focus()
                            
                        })
                        .onClick({ _, event in
                            self.tag3Focus()
                            event.stopPropagation()
                        })
                    
                    self.tag3ResultsView
                    
                }
                
                Div().class(.clear)
                
                ///`tag2`
                Div{
                    Div{
                        Label("*").color(.red)
                            .float(.right)
                            .fontWeight(.bolder)
                            .fontSize(self.$selectEquipmentField.map{ $0 == "tag2" ? 18.px : 12.px })
                        
                        self.tag2Label
                    }
                    
                    Div().class(.clear)
                    
                    self.tag2
                        .opacity(0.3)
                        .disabled(true)
                        .onBlur({
                            
                            Dispatch.asyncAfter(0.3) {
                                if let id = self.tag2SelctedItemID {
                                    orderManagerModel.forEach { model in
                                        if model.id == id {
                                            self._tag2 = model.name
                                        }
                                    }
                                }
                            }
                            
                        })
                        .onKeyUp({ tf, event in
                            print(event.key)
                            
                            let key = event.key
                            
                            if (key == "ArrowUp") {
                                
                                if let id = self.tag2PreSelctedItemID {
                                    
                                    var cc = 0
                                    var curentSelected = 0
                                    
                                    self.tag2CurrentSeleccionList.forEach { _id in
                                        if id == _id {
                                            curentSelected += cc
                                        }
                                        cc += 1
                                    }
                                    
                                    print("current selected [up] \(curentSelected)")
                                    
                                    if curentSelected == 0 { return }
                                    
                                    self.tag2PreSelctedItemID = self.tag2CurrentSeleccionList[(curentSelected - 1)]
                                    
                                }
                                
                                return
                            }
                            
                            if (key == "ArrowDown") {
                                
                                if let id = self.tag2PreSelctedItemID {
                                    
                                    var cc = 0
                                    var curentSelected = 0
                                    
                                    self.tag2CurrentSeleccionList.forEach { _id in
                                        if id == _id {
                                            curentSelected += cc
                                        }
                                        cc += 1
                                    }
                                    
                                    print("current selected [down] \(curentSelected)")
                                    
                                    if (curentSelected + 1) == self.tag2CurrentSeleccionList.count { return }
                                    
                                    self.tag2PreSelctedItemID = self.tag2CurrentSeleccionList[(curentSelected + 1)]
                                    
                                }
                                
                                return
                            }
                            
                            if ignoredKeys.contains(key) { return }
                            
                            if (key == "Enter" || key == "NumpadEnter") {
                                
                                if let id = self.tag2PreSelctedItemID {
                                    
                                    orderManagerModel.forEach { brand in
                                        if brand.id == id {
                                            /// change name to selected TYPE
                                            self._tag2 = brand.name
                                            //self.tag3SelctedItem = type.name
                                            self.tag2SelctedItemID = nil
                                            self.tag2SelctedItemID = brand.id
                                        }
                                    }
                                    
                                    self.tag1ResultsView.hidden(true)
                                    self.tag3ResultsView.hidden(true)
                                    self.tag2ResultsView.hidden(true)
                                    
                                }
                                
                                return
                            }
                            
                            /// if any other key
                            self.tag2SelctedItemID = nil
                            
                            self.tag2Focus()
                            
                        })
                        .onClick({ _, event in
                            
                            self.selectEquipmentField = "tag2"
                            self.tag1ResultsView.hidden(true)
                            self.tag3ResultsView.hidden(true)
                            self.tag2ResultsView.hidden(false)
                            
                            event.stopPropagation()
                        })
                    
                    self.tag2ResultsView
                }
                
                Div().class(.clear)
                
            }
            else {
                
                ///`tag1`
                Div{
                    
                    self.tag1Label
                    
                    Div().class(.clear)
                    
                    self.tag1
                    
                }.hidden(!configServiceTags.tag1)
                
                Div().class(.clear)
                
                ///`tag3`
                Div{
                    self.tag3Label
                    
                    Div().class(.clear)
                    
                    self.tag3
                    
                }.hidden(!configServiceTags.tag3)
                
                Div().class(.clear)
                
                ///`tag2`
                Div{
                    self.tag2Label
                    
                    Div().class(.clear)
                    
                    self.tag2
                }
                .hidden(!configServiceTags.tag2)
                
                Div().class(.clear)
                
            }
            
            ///`tag4`
            Div{
                Label(configServiceTags.tag4Name)
                    .float(.right)
                    .color(self.$selectEquipmentField.map{ $0 == "tag4" ? .black : .gray })
                    .fontSize(self.$selectEquipmentField.map{ $0 == "tag4" ? 18.px : 12.px })

                Div().class(.clear)
                self.tag4
            }.hidden(!configServiceTags.tag4)
            Div().class(.clear)
            
            ///`tag5`
            Div{
                Label(configServiceTags.tag5Name)
                    .float(.right)
                    .color(self.$selectEquipmentField.map{ $0 == "tag5" ? .black : .gray })
                    .fontSize(self.$selectEquipmentField.map{ $0 == "tag5" ? 18.px : 12.px })

                Div().class(.clear)
                self.tag5
            }.hidden(!configServiceTags.tag5)
            Div().class(.clear)
            
            ///`tag6`
            Div{
                Label(configServiceTags.tag6Name)
                    .float(.right)
                    .color(self.$selectEquipmentField.map{ $0 == "tag6" ? .black : .gray })
                    .fontSize(self.$selectEquipmentField.map{ $0 == "tag6" ? 18.px : 12.px })

                Div().class(.clear)
                self.tag6
            }.hidden(!configServiceTags.tag6)
            Div().class(.clear)

            H2("Descripcion de la orden")
                .color(.lightBlueText)
            
            self.descr
            
            Div().class(.clear)
            
            /// Quick Checks
            Div{
                /// checkTag1
                Div{
                    Div{
                        self.checkTag1
                    }
                    .width(70.px)
                    .float(.left)
                    
                    Div(configServiceTags.checkTag1Name)
                    .class( .oneLineText)
                    .custom("width", "calc(100% - 70px)")
                    .float(.left)
                }
                .hidden(!configServiceTags.checkTag1)
                .class(.oneHalf)
                
                /// checkTag2
                Div{
                    Div{
                        self.checkTag2
                    }
                    .width(70.px)
                    .float(.left)
                    
                    Div(configServiceTags.checkTag2Name)
                    .class(.oneLineText)
                    .custom("width", "calc(100% - 70px)")
                    .float(.left)
                    Div().class(.clear)
                }
                .hidden(!configServiceTags.checkTag2)
                .class(.oneHalf)
                
                /// checkTag3
                Div{
                    Div{
                        self.checkTag3
                    }
                    .width(70.px)
                    .float(.left)
                    Div(configServiceTags.checkTag3Name)
                    .class(.oneLineText)
                    .custom("width", "calc(100% - 70px)")
                    .float(.left)
                    Div().class(.clear)
                }
                .hidden(!configServiceTags.checkTag3)
                .class(.oneHalf)
                
                /// checkTag4
                Div{
                    Div{
                        self.checkTag4
                    }
                    .width(70.px)
                    .float(.left)
                    
                    Div(configServiceTags.checkTag4Name)
                    .class(.oneLineText)
                    .custom("width", "calc(100% - 70px)")
                    .float(.left)
                    Div().class(.clear)
                }
                .hidden(!configServiceTags.checkTag4)
                .class(.oneHalf)
                
                /// checkTag5
                Div{
                    Div{
                        self.checkTag5
                    }
                    .width(70.px)
                    .float(.left)
                    Div(configServiceTags.checkTag5Name)
                    .class( .oneLineText)
                    .custom("width", "calc(100% - 70px)")
                    .float(.left)
                    Div().class(.clear)
                }
                .hidden(!configServiceTags.checkTag5)
                .class(.oneHalf)
                
                /// checkTag6
                Div{
                    Div{
                        self.checkTag6
                    }
                    .width(70.px)
                    .float(.left)
                    Div(configServiceTags.checkTag6Name)
                    .class(.oneLineText)
                    .custom("width", "calc(100% - 70px)")
                    .float(.left)
                    Div().class(.clear)
                }
                .hidden(!configServiceTags.checkTag6)
                .class(.oneHalf)
                
            }
            
            Div().class(.clear)
            
            Div{
                Div(self.$equipment.map{ ($0 == nil) ? "Agregar" : "Guardar Cambios"})
                    .onClick {
                        self.addEquipment()
                    }
                    .class(.uibtnLargeOrange)
            }
            .align(.right)
            
        }
        .custom("left", "calc(50% - 250px)")
        .custom("top", "calc(50% - 350px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 12.px)
        .overflow(.auto)
        .height(650.px)
        .width(500.px)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if configServiceTags.useBrandModelMode {
            
            self.$tag1SelctedItemID.listen {
                if let _ = $0 {
                    self.tag3isDisabeld = false
                    self.tag1.class(.isOk)
                }
                else{
                    self.tag3isDisabeld = true
                    self._tag3 = ""
                    self.tag3SelctedItemID = nil
                    self.tag1.removeClass(.isOk)
                }
            }
            
            self.$tag3SelctedItemID.listen {
                
                if let _ = $0 {
                    self.tag2isDisabeld = false
                    self.tag3.class(.isOk)
                }
                else {
                    
                    self.tag2isDisabeld = true
                    self._tag2 = ""
                    self.tag2SelctedItemID = nil
                    self.tag3.removeClass(.isOk)
                }
            }
            
            self.$tag2SelctedItemID.listen {
                if let _ = $0 {
                    self.tag2.class(.isOk)
                }
                else{
                    self.tag2.removeClass(.isOk)
                }
            }
            
            $tag3isDisabeld.listen {
                if $0 {
                    self.tag3.disabled(true)
                    self.tag3.opacity(0.3)
                }
                else{
                    self.tag3.disabled(false)
                    self.tag3.opacity(1.0)
                }
            }
            
            $tag2isDisabeld.listen {
                if $0 {
                    self.tag2.disabled(true)
                    self.tag2.opacity(0.3)
                }
                else{
                    self.tag2.disabled(false)
                    self.tag2.opacity(1.0)
                }
            }
        }
         
        
    }
    
    /// brand
    func addOrderManagerBrand(){
        
        self.tag1ResultsView.hidden(true)
        
        let view = AddOrderManagerBrand(
            term: self._tag1
        ){ brand in
            
            /// add to local catch
            orderManagerBrand.append(brand)
            /// change name to selected TYPE
            self._tag1 = brand.name
            
            /// Clear Current Data
            self.tag1SelctedItemID = nil
            
            /// load new data
            self.tag1SelctedItemID = brand.id
            
            // Preforme Focus Acctions
            self.tag3.select()
            self.tag3Focus()
            
        }
        
        self.appendChild(view)
        
        view.termInput.select()
    }
    /// type
    func addOrderManagerType(){
        
        self.tag3ResultsView.hidden(true)
        
        guard let brandId = self.tag1SelctedItemID else {
            showError(.errorGeneral, "No se pudo cargar el id de la marca")
            return
        }
        
        let view = AddOrderManagerType(
            brandId: brandId,
            term: self._tag3
        ) { type in
            /// add to local catch
            orderManagerType.append(type)
            /// change name to selected TYPE
            
            print("nde type added")
            
            print(type)
            
            self._tag3 = type.name
            
            self.tag3SelctedItemID = nil
            
            self.tag3SelctedItemID = type.id
            
            // Preforme Focus Acctions
            self.tag2.select()
            self.tag2Focus()
        }
        
        self.appendChild(view)
        
        view.termInput.select()
        
    }
    /// model
    func addOrderManagerModel(){
        
        self.tag2ResultsView.hidden(true)
        
        guard let typeId = self.tag3SelctedItemID else{
            showError(.unexpectedResult, "No se localizo \(configServiceTags.tag3Name) seleccionado, Contacte a Soporte TC")
            return
        }
        
        guard let brandId = self.tag1SelctedItemID else{
            showError(.unexpectedResult, "No se localizo \(configServiceTags.tag3Name) seleccionado, Contacte a Soporte TC")
            return
        }
        
        var brandName = ""
        
        orderManagerBrand.forEach { brand in
            if brandId == brand.id {
                brandName = brand.name
            }
        }
        
        let view = AddOrderManagerModel(
            term: self._tag2,
            typeId: typeId,
            brandId: brandId,
            brandName: brandName
        ){ model in
            /// add to local catch
            orderManagerModel.append(model)
            /// change name to selected TYPE
            self._tag2 = model.name
            
            self.tag2SelctedItemID = nil
            
            self.tag2SelctedItemID = model.id
            
        }
        
        self.appendChild(view)
        
        view.termInput.select()
    }
    
    /// brand
    func tag1Focus(){
        
        self.selectEquipmentField = "tag1"
        
        if orderManagerBrand.isEmpty {
            
            /// No brands  available  to `TYPE`
            self.tag1ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.addOrderManagerBrand()
            
            return
        }
        else {
            
            self.tag1Results.innerHTML = ""
            
            self.tag1CurrentSeleccionList.removeAll()
            
            /// This means their has already been a selection  on bulr will default back is selction remaind valid
            if let _ = tag1SelctedItemID {
                self._tag1 = ""
            }
            
            /// Strat filtering proces is applied
            if self._tag1.isEmpty{
                self.curOrderManagerBrand = orderManagerBrand
            }
            else {
                /// term to search
                let term = self._tag1.purgeSpaces.pseudo
                
                /// Refrecne to avoid duplicate results
                var included:[UUID] = []
                
                self.curOrderManagerBrand.removeAll()
                
                ///prase results with `PREFIX`
                orderManagerBrand.forEach { type in
                    if type.pseudo.hasPrefix(term){
                        included.append(type.id)
                        self.curOrderManagerBrand.append(type)
                    }
                }
                
                ///prase results with `CONTAINS` && not in `included` list
                orderManagerBrand.forEach { type in
                    if type.pseudo.contains(term) && !included.contains(type.id){
                        included.append(type.id)
                        self.curOrderManagerBrand.append(type)
                    }
                }
                
            }
            
            if let id = self.tag1SelctedItemID {
                
                /// Verify is the id that has been selected is included in the list to be viewed
                var idIsIncluded = false
                self.curOrderManagerBrand.forEach { brand in
                    if brand.id == id {
                        idIsIncluded = true
                    }
                }
                
                if idIsIncluded{
                    self.tag1PreSelctedItemID = id
                }
                else{
                    self.tag1PreSelctedItemID = self.curOrderManagerBrand.first?.id
                }
                
            }
            else {
                self.tag1PreSelctedItemID = self.curOrderManagerBrand.first?.id
            }
            
            self.curOrderManagerBrand.forEach { brand in
            
                self.tag1CurrentSeleccionList.append(brand.id)
                
                let view = OrderManagerItem(
                    id: brand.id,
                    name: brand.name,
                    preSelectID: self.$tag1PreSelctedItemID
                ){ id, name in
                    
                    if self.tag1SelctedItemID != id {
                        /// change name to selected TYPE
                        self._tag1 = name
                        self.tag1SelctedItemID = nil
                        self.tag1SelctedItemID = id
                        self._tag3 = ""
                    }
                    
                    // Preform Focus Accion
                    self.tag3.select()
                    
                    Dispatch.asyncAfter(0.25) {
                        self.tag3Focus()
                    }
                }
                
                self.tag1Results.appendChild(view)
            }
            
            self.tag1ResultsView.hidden(false)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            
        }
        
    }
    /// type
    func tag3Focus(){
        
        self.selectEquipmentField = "tag3"
        
        /// Empty the id of the viewd list
        self.tag3CurrentSeleccionList.removeAll()
        
        /// Empty the viewed list
        self.curOrderManagerType.removeAll()
        
        /// List preloader
        var _curOrderManagerType: [CustOrderManagerType] = []
        
        guard let brandId = self.tag1SelctedItemID else {
            showError(.errorGeneral, "Seleccione \(configServiceTags.idTagName.uppercased())")
            return
        }
        
        orderManagerType.forEach { type in
            if type.custOrderManagerBrand != brandId {
                return
            }
            _curOrderManagerType.append(type)
        }
        
        if _curOrderManagerType.isEmpty {
            self.tag1ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.addOrderManagerType()
            return
        }
        
        self.tag3Results.innerHTML = ""
        
        /// This means their has already been a selection  on bulr will default back is selction remaind valid
        if let _ = tag3SelctedItemID {
            self._tag3 = ""
        }
        
        if self._tag3.isEmpty {
            curOrderManagerType = _curOrderManagerType
        }
        else{
            /// term to search
            let term = self._tag3.purgeSpaces.pseudo
            /// Refrecne to avoid duplicate results
            var included:[UUID] = []
            ///prase results with `PREFIX`
            _curOrderManagerType.forEach { type in
                if type.pseudo.hasPrefix(term){
                    included.append(type.id)
                    self.curOrderManagerType.append(type)
                }
            }
            ///prase results with `CONTAINS` && not in `included` list
            _curOrderManagerType.forEach { type in
                if type.pseudo.contains(term) && !included.contains(type.id){
                    included.append(type.id)
                    self.curOrderManagerType.append(type)
                }
            }
            
        }
        
        if let id = self.tag3SelctedItemID {
            
            /// Verify is the id that has been selected is included in the list to be viewed
            var idIsIncluded = false
            self.curOrderManagerType.forEach { type in
                if type.id == id {
                    idIsIncluded = true
                }
            }
            
            if idIsIncluded{
                self.tag3PreSelctedItemID = id
            }
            else{
                self.tag3PreSelctedItemID = curOrderManagerType.first?.id
            }
            
        }
        else {
            self.tag3PreSelctedItemID = curOrderManagerType.first?.id
        }
        
        self.curOrderManagerType.forEach { type in
        
            self.tag3CurrentSeleccionList.append(type.id)
            
            let view = OrderManagerItem(
                id: type.id,
                name: type.name,
                preSelectID: self.$tag3PreSelctedItemID
            ){ id, name in
                
                if self.tag3SelctedItemID != id {
                    /// change name to selected TYPE
                    self._tag3 = name
                    // self.tag3SelctedItem = type.name
                    self.tag3SelctedItemID = nil
                    self.tag3SelctedItemID = id
                    self._tag2 = ""
                }
                // Preform Focus Accion
                self.tag2.select()
                
                Dispatch.asyncAfter(0.25) {
                    self.tag2Focus()
                }
            }
            
            self.tag3Results.appendChild(view)
        }
        
        self.tag1ResultsView.hidden(true)
        self.tag3ResultsView.hidden(false)
        self.tag2ResultsView.hidden(true)
        
    }
    /// model
    func tag2Focus(){
        
        self.selectEquipmentField = "tag2"
        
        self.curOrderManagerModel.removeAll()
        
        /// Pre resutls, loads all  the `Models` of the `Brands` no filtering aplied till next step
        var _curOrderManagerModel: [CustOrderManagerModel] = []
        
        guard let typeId = self.tag3SelctedItemID else {
            showError(.errorGeneral, "Seleccione tipo objeto")
            return
        }
        
        /// Populate `curOrderManagerBrand` base on the id of the select `TYPE`
        orderManagerModel.forEach { model in
            if typeId != model.custOrderTypeManager { return }
            _curOrderManagerModel.append(model)
        }
        
        if _curOrderManagerModel.isEmpty {
            /// No brands  available  to `TYPE`
            self.tag1ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.addOrderManagerModel()
            
            return
        }
        else {
            
            self.tag2Results.innerHTML = ""
            
            self.tag2CurrentSeleccionList.removeAll()
            
            /// This means their has already been a selection  on bulr will default back is selction remaind valid
            if let _ = tag2SelctedItemID {
                self._tag2 = ""
            }
            
            /// Strat filtering proces is applied
            if self._tag2.isEmpty {
                curOrderManagerModel = _curOrderManagerModel
            }
            else{
               
                /// term to search
                let term = self._tag2.purgeSpaces.pseudo
                /// Refrecne to avoid duplicate results
                var included:[UUID] = []
                ///prase results with `PREFIX`
                _curOrderManagerModel.forEach { type in
                    if type.pseudo.hasPrefix(term){
                        included.append(type.id)
                        self.curOrderManagerModel.append(type)
                    }
                }
                ///prase results with `CONTAINS` && not in `included` list
                _curOrderManagerModel.forEach { type in
                    if type.pseudo.contains(term) && !included.contains(type.id){
                        included.append(type.id)
                        self.curOrderManagerModel.append(type)
                    }
                }
                
            }
            
            if let id = self.tag2SelctedItemID {
                
                /// Verify is the id that has been selected is included in the list to be viewed
                var idIsIncluded = false
                self.curOrderManagerModel.forEach { brand in
                    if brand.id == id {
                        idIsIncluded = true
                    }
                }
                
                if idIsIncluded{
                    self.tag2PreSelctedItemID = id
                }
                else{
                    self.tag2PreSelctedItemID = self.curOrderManagerModel.first?.id
                }
                
            }
            else {
                self.tag2PreSelctedItemID = self.curOrderManagerModel.first?.id
            }
            
            self.curOrderManagerModel.forEach { model in
            
                self.tag2CurrentSeleccionList.append(model.id)
                
                let view = OrderManagerItem(
                    id: model.id,
                    name: model.name,
                    preSelectID: self.$tag2PreSelctedItemID
                ){ id, name in
                    /// change name to selected TYPE
                    self._tag2 = name
                    self.tag2SelctedItemID = nil
                    self.tag2SelctedItemID = id
                    
                    self.tag1ResultsView.hidden(true)
                    self.tag2ResultsView.hidden(true)
                    self.tag3ResultsView.hidden(true)
                    
                }
                
                self.tag2Results.appendChild(view)
            }
            
            self.tag1ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.tag2ResultsView.hidden(false)
            
        }
    }
    
    func addEquipment(){
        
        if _descr.isEmpty {
            showError(.campoRequerido, .requierdValid("Description"))
            return
        }
        
        callback(.init(
            refid: refid,
            IDTag1: _idTag1,
            IDTag2: _idTag2,
            tag1: _tag1,
            tag2: _tag2,
            tag3: _tag3,
            tag4: _tag4,
            tag5: _tag5,
            tag6: _tag6,
            tagCheck1: _checkTag1,
            tagCheck2: _checkTag2,
            tagCheck3: _checkTag3,
            tagCheck4: _checkTag4,
            tagCheck5: _checkTag5,
            tagCheck6: _checkTag6,
            tagDescr: _descr
        ))
        
        self.remove()
    }
    
}
