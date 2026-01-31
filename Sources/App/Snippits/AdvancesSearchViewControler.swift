//
//  AdvancesSearchViewControler.swift
//  
//
//  Created by Victor Cantu on 8/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class AdvancesSearchViewControler: Div {
    
    override class var name: String { "div" }
    
    @State var searchTerm: String
    
    @State var orders: [CustOrderLoadFolios] = []
    
    @State var accounts: [CustAcctAPI] = []
    
    init(
        searchTerm: String,
        orders: [CustOrderLoadFolios],
        accounts: [CustAcctAPI]
    ) {
        self.searchTerm = searchTerm
        self.orders = orders
        self.accounts = accounts
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var bizData: String = ""
    
    @State var firstName: String = ""
    
    @State var lastName: String = ""
    
    /// Mobile or Email
    @State var commMeth: String = ""
    
    /// Address
    @State var street: String = ""
    
    @State var colonie: String = ""
    
    @State var city: String = ""
    
    /// Tags
    
    @State var tag1: String = ""
    
    @State var tag2: String = ""
    
    @State var tag3: String = ""
    
    @State var tag4: String = ""
    
    @State var tag5: String = ""
    
    @State var tag6: String = ""
    
    @State var descr: String = ""
    
    /// Search Helpers
    @State var selectEquipmentField = ""
    
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
    
    lazy var bizDataField = InputText(self.$bizData)
        .placeholder("RFC, razon, nom empresa...")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var commMethField = InputText(self.$commMeth)
        .placeholder("Telefono / Correo")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var firstNameField = InputText(self.$firstName)
        .placeholder("Primer Nombre")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var lastNameField = InputText(self.$lastName)
        .placeholder("Primer Apellido")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var streetField = InputText(self.$street)
        .placeholder("Calle y Numero")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var colonieField = InputText(self.$colonie)
        .placeholder("Colonia")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var cityField = InputText(self.$city)
        .placeholder("Cuidad")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .height(36.px)
    
    lazy var tag1Label = Label(configServiceTags.tag1Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag1" ? 24.px : 16.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag1" ? .white : .gray })
    
    lazy var tag2Label = Label(configServiceTags.tag2Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag2" ? 24.px : 16.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag2" ? .white : .gray })
    
    lazy var tag3Label = Label(configServiceTags.tag3Name)
        .fontSize(self.$selectEquipmentField.map{ $0 == "tag3" ? 24.px : 16.px })
        .color(self.$selectEquipmentField.map{ $0 == "tag3" ? .white : .gray })
    
    lazy var tag1Field = InputText(self.$tag1)
        .autocomplete(.off)
        .placeholder(configServiceTags.tag1Placeholder)
        .class(.textFiledBlackDark)
        .height(36.px)
        .width(93.percent)
        .marginTop(3.px)
        .onFocus {
            self.selectEquipmentField = "tag1"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
        .onClick({ _, event in
            event.stopPropagation()
        })
    
    lazy var tag2Field = InputText(self.$tag2)
        .placeholder(configServiceTags.tag2Placeholder)
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .marginTop(3.px)
        .height(36.px)
        .onFocus {
            self.selectEquipmentField = "tag2"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
        .onClick({ _, event in
            event.stopPropagation()
        })
    lazy var tag3Field = InputText(self.$tag3)
        .placeholder(configServiceTags.tag3Placeholder)
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .marginTop(3.px)
        .height(36.px)
        .onClick({ _, event in
            event.stopPropagation()
        })
        .onFocus {
            self.selectEquipmentField = "tag3"
        }
        .onBlur {
            self.selectEquipmentField = ""
        }
    
    lazy var tag4Field = InputText(self.$tag4)
        .placeholder(configServiceTags.tag4Placeholder)
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .marginTop(3.px)
        .height(36.px)
    
    lazy var tag5Field = InputText(self.$tag5)
        .placeholder(configServiceTags.tag5Placeholder)
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .marginTop(3.px)
        .height(36.px)
    
    lazy var tag6Field = InputText(self.$tag6)
        .placeholder(configServiceTags.tag6Placeholder)
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .marginTop(3.px)
        .height(36.px)
    
    lazy var descrArea = InputText(self.$descr)
        .placeholder("Que se hizo...")
        .class(.textFiledBlackDark)
        .autocomplete(.off)
        .width(93.percent)
        .marginTop(3.px)
        .height(36.px)
    
    /// ``Control Items``
    lazy var tag1Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
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
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    //.position(.fixed)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    .onClick { _, event in
        event.stopPropagation()
    }
    
    lazy var tag2Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
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
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    //.position(.fixed)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    .onClick { _, event in
        event.stopPropagation()
    }
    
    lazy var tag3Results = Div{
        Table {
            Tr{
                Td{
                    Span("Aun no hay registros")
                        .color(.gray)
                        .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
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
        
    }
    .border(width: .medium, style: .solid, color: .lightGray)
    .boxShadow(h: 2.px, v: 2.px, blur: 12.px, color: .gray)
    .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.8))
    .padding(v: 7.px, h: 3.px)
    .borderRadius(all: 12.px)
    //.position(.fixed)
    .width(323.px)
    .hidden(true)
    .zIndex(1)
    .onClick { _, event in
        event.stopPropagation()
    }
    
    // Date Rangable
    
    @State var dateSelectListener = ""
    
    lazy var dateSelect = Select(self.$dateSelectListener)
        .class(.textFiledBlackDark)
        .fontSize(22.px)
        .height(34.px)
    
    /// the day the current active report  is done
    var startAtResultDate: Int64 = 0
    @State var startAt = ""
    
    lazy var startAtField = InputText(self.$startAt)
        .class(.textFiledBlackDark)
        .placeholder("DD/MM/AAAA")
        .fontSize(22.px)
        .width(150.px)
        .height(34.px)
    
    /// the day the current active report  is done
    var endAtResultDate: Int64 = 0
    @State var endAt = ""
    
    lazy var endAtField = InputText(self.$endAt)
        .class(.textFiledBlackDark)
        .placeholder("DD/MM/AAAA")
        .fontSize(22.px)
        .width(150.px)
        .height(34.px)
    
    @State var startAtLabel = ""
    
    @State var endAtLabel = ""
    
    /// ``Result Views``
    lazy var searchLeftView = ForEach(self.$orders) {
        OrderCatchControler.shared.orderRowView($0)
    }
    
    lazy var searchRightView = ForEach(self.$accounts) {
        AccountRowView(data: $0) { accountid in
            loadAccountView(id: .id(accountid))
        }
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .marginRight(7.px)
                    .onClick {
                        self.remove()
                    }
                
                H2("Busqueda Avanzada")
                    .color(.lightBlueText)
                    .marginLeft(3.px)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            
            Div().height(7.px)
            
            Div{
                
                
                Div().class(.clear).height(7.px)
                
                H2("¿Cuando buscamos?")
                    .color(.lightBlueText)
                    .marginLeft(3.px)
                    .float(.left)
                
                Div().class(.clear).height(7.px)
                
                Div{
                    
                    /// Date Select Type
                    Div{
                        Label("Seleccione Fecha")
                            .fontSize(12.px)
                            .color(.gray)
                        
                        Div().clear(.both)
                        
                        self.dateSelect
                    }
                    .marginLeft(12.px)
                    .marginTop(3.px)
                    
                    /// Star At
                    Div{
                        Label("Fecha Inicio")
                            .marginBottom(3.px)
                            .fontSize(12.px)
                            .color(.gray)
                        
                        Div().clear(.both)
                        
                        self.startAtField
                            .hidden(self.$endAtLabel.map{ !$0.isEmpty })
                        
                        Div(self.$startAtLabel)
                            .hidden(self.$endAtLabel.map{ $0.isEmpty })
                            .marginBottom(9.px)
                            .fontSize(22.px)
                            .color(.white)
                    }
                    .marginLeft(12.px)
                    .marginTop(3.px)
                    .float(.left)

                    /// End At
                    Div{
                        Label("Fecha Final")
                            .marginBottom(3.px)
                            .fontSize(12.px)
                            .color(.gray)
                        
                        Div().clear(.both)
                        
                        self.endAtField
                            .hidden(self.$endAtLabel.map{ !$0.isEmpty })
                        
                        Div(self.$endAtLabel)
                            .hidden(self.$endAtLabel.map{ $0.isEmpty })
                            .marginBottom(9.px)
                            .fontSize(22.px)
                            .color(.white)
                    }
                    .marginLeft(12.px)
                    .marginTop(3.px)
                    .float(.left)
                    
                }
                .marginTop(7.px)
                
                Div().class(.clear).height(7.px)
                
                H2("¿A quien buscamos?")
                    .color(.lightBlueText)
                    .marginLeft(3.px)
                    .float(.left)
                
                Div().class(.clear).height(7.px)
                
                Label("Nombre").color(.gray)
                    .marginTop(7.px)
                    .fontSize(22.px)
                    .color(.white)
                
                Div().class(.clear).height(3.px)
                
                Div{
                    Div{
                        self.firstNameField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        self.lastNameField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                
                Div().class(.clear).height(7.px)
                
                Label("Contacto").color(.gray)
                    .marginTop(7.px)
                    .fontSize(22.px)
                    .color(.white)
                
                Div().class(.clear).height(3.px)
                
                self.commMethField
                
                Div().class(.clear).height(7.px)
                
                Label("Empresa").color(.gray)
                    .marginTop(7.px)
                    .fontSize(22.px)
                    .color(.white)
                
                Div().class(.clear).height(3.px)
                
                self.bizDataField
                
                
                Label("Calle y numero").color(.gray)
                    .marginTop(7.px)
                    .fontSize(22.px)
                    .color(.white)
                
                Div().class(.clear).height(3.px)
                
                self.streetField
                
                Div().class(.clear).height(7.px)
                
                Label("Colonia").color(.gray)
                    .marginTop(7.px)
                    .fontSize(22.px)
                    .color(.white)
                
                Div().class(.clear).height(3.px)
                
                self.colonieField
                
                Div().class(.clear).height(7.px)
                
                Label("Cuidad").color(.gray)
                    .marginTop(7.px)
                    .fontSize(22.px)
                    .color(.white)
                
                Div().class(.clear).height(3.px)
                
                self.cityField
                
                Div().class(.clear).height(7.px)
                
            }
            .custom("height", "calc(100% - 35px)")
            .width(25.percent)
            .overflow(.auto)
            .float(.left)
            
            
            Div{
                Div{
                
                    H2("¿Que buscamos?")
                        .color(.lightBlueText)
                        .marginLeft(3.px)
                        .float(.left)
                    
                    Div().class(.clear).height(7.px)
                    
                    
                    Label("Descripcion de servicio").color(.gray)
                        .marginTop(7.px)
                        .fontSize(22.px)
                        .color(.white)
                    
                    Div().class(.clear).height(3.px)
                    
                    self.descrArea
                        .marginTop(7.px)
                    
                    Div().class(.clear).height(7.px)
                    

                    if configServiceTags.useBrandModelMode {
                        
                        ///`tag1`
                        Div{
                            
                            Div{
                                self.tag1Label
                            }
                            
                            Div().class(.clear).marginTop(3.px)
                            
                            self.tag1Field
                                .onBlur({
                                    
                                    Dispatch.asyncAfter(0.3) {
                                        if let id = self.tag1SelctedItemID {
                                            orderManagerBrand.forEach { brand in
                                                if brand.id == id {
                                                    self.tag1 = brand.name
                                                }
                                            }
                                        }
                                    }
                                    
                                })
                                .onKeyUp({ tf, event in
                                    
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
                                            
                                            print("current selected [down tag1] \(curentSelected)")
                                            
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
                                                        self.tag1 = brand.name
                                                        self.tag1SelctedItemID = nil
                                                        self.tag1SelctedItemID = brand.id
                                                        self.tag3 = ""
                                                    }
                                                    
                                                    // Preforme Focus Acctions
                                                    self.tag3Field.select()
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
                        
                        Div().class(.clear).height(7.px)
                        
                        ///`tag3`
                        Div{
                            Div{
                                self.tag3Label
                            }

                            Div().class(.clear).marginTop(3.px)
                        
                            self.tag3Field
                                .opacity(0.3)
                                .disabled(true)
                                .onBlur({
                                    
                                    Dispatch.asyncAfter(0.3) {
                                        if let id = self.tag3SelctedItemID {
                                            orderManagerType.forEach { type in
                                                if type.id == id {
                                                    self.tag3 = type.name
                                                }
                                            }
                                        }
                                    }
                                    
                                })
                                .onKeyUp({ tf, event in
                                    
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
                                            
                                            print("current selected [down tag3] \(curentSelected)")
                                            
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
                                                        self.tag3 = type.name
                                                        self.tag3SelctedItemID = nil
                                                        self.tag3SelctedItemID = type.id
                                                        self.tag2 = ""
                                                    }
                                                    
                                                    // Preforme Focus Acctions
                                                    self.tag2Field.select()
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
                        
                        Div().class(.clear).height(7.px)
                        
                        ///`tag2`
                        Div{
                            Div{
                                self.tag2Label.marginTop(3.px)
                            }

                            Div().class(.clear)
                            
                            self.tag2Field
                                .opacity(0.3)
                                .disabled(true)
                                .onBlur({
                                    
                                    Dispatch.asyncAfter(0.3) {
                                        if let id = self.tag2SelctedItemID {
                                            orderManagerModel.forEach { model in
                                                if model.id == id {
                                                    self.tag2 = model.name
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
                                            
                                            print("current selected [down tag2] \(curentSelected)")
                                            
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
                                                    self.tag2 = brand.name
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
                        
                        Div().class(.clear).height(7.px)
                        
                    }
                    else {
                        
                        ///`tag1`
                        Div{
                            Div{
                                self.tag1Label
                            }
                            
                            Div().class(.clear).marginTop(3.px)
                            
                            self.tag1Field
                            
                        }.hidden(!configServiceTags.tag1)
                        
                        Div().class(.clear).height(7.px)
                        
                        ///`tag3`
                        Div{
                            Div{
                                self.tag3Label
                            }
                            
                            Div().class(.clear).marginTop(3.px)
                            
                            self.tag3Field
                            
                        }.hidden(!configServiceTags.tag3)
                        
                        Div().class(.clear).marginTop(3.px)
                        
                        ///`tag2`
                        Div{
                            
                            Div{
                                self.tag2Label
                            }
                            
                            Div().class(.clear).marginTop(3.px)
                            
                            self.tag2Field
                        }
                        .hidden(!configServiceTags.tag2)
                        
                        Div().class(.clear).marginTop(3.px)
                        
                    }
                    
                    // Tag4
                    Div {
                        Div{
                            Label(configServiceTags.tag4Name).color(.gray)
                                .fontSize(22.px)
                                .color(.white)
                        }
                        
                        self.tag4Field
                    }
                    .hidden(!configServiceTags.tag4)
                    Div().class(.clear).height(7.px)
                        .hidden(!configServiceTags.tag4)
                    
                    // Tag5
                    Div {
                        Div{
                            Label(configServiceTags.tag5Name).color(.gray)
                                .fontSize(22.px)
                                .color(.white)
                        }
                        self.tag5Field
                    }
                    .hidden(!configServiceTags.tag5)
                    Div().class(.clear).height(7.px)
                        .hidden(!configServiceTags.tag5)
                    
                    // Tag6
                    Div {
                        Div{
                            Label(configServiceTags.tag6Name).color(.gray)
                                .fontSize(22.px)
                                .color(.white)
                        }
                        self.tag6Field
                    }
                    .hidden(!configServiceTags.tag6)
                    
                }
                .custom("height", "calc(100% - 60px)")
                .overflow(.auto)
                
                Div{
                    
                    Div("Buscar")
                        .class(.uibtnLargeOrange)
                        .paddingRight(7.px)
                        .marginRight(7.px)
                        .marginLeft(7.px)
                        .float(.right)
                        .onClick {
                            self.advancedSearchFolio()
                        }
                }
                .align(.right)
                .marginTop(7.px)
            }
            .custom("height", "calc(100% - 35px)")
            .width(25.percent)
            .overflow(.auto)
            .float(.left)
            
            Div{
                Div{
                    
                    H2("Resultados por Ordenes")
                        .color(.white)
                    
                    self.searchLeftView
                        .hidden(self.$orders.map{ $0.isEmpty })
                    
                    Table().noResult(label: "-🔎 No hay ordenes para mostrar-")
                        .hidden(self.$orders.map{ !$0.isEmpty })
                }
                
                Div{
                    H2("Resultados por Cuentas")
                        .color(.white)
                    
                    self.searchRightView
                        .hidden(self.$accounts.map{ $0.isEmpty })
                    
                    Table().noResult(label: "-🔎 No hay cuentas para mostrar-")
                        .hidden(self.$accounts.map{ !$0.isEmpty })
                    
                }
                
                
            }
            .custom("height", "calc(100% - 35px)")
            .marginLeft(2.percent)
            .width(48.percent)
            .overflow(.auto)
            .float(.left)
            
        }
        .boxShadow(h: 0.px, v: 0.px, blur: 3.px, color: .black)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(80.percent)
        .width(90.percent)
        .top(10.percent)
        .left(5.percent)
        .onClick {
            self.tag1ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
        }
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.backgroundColor(.transparentBlack)
            .height(100.percent)
            .width(100.percent)
            .position(.fixed)
            .left(0.px)
            .top(0.px)
        
        if configServiceTags.useBrandModelMode {
            
            $tag1SelctedItemID.listen {
                if let _ = $0 {
                    self.tag3isDisabeld = false
                    self.tag1Field.class(.isOk)
                }
                else{
                    self.tag3isDisabeld = true
                    self.tag1Field.removeClass(.isOk)
                    self.tag3 = ""
                    self.tag3SelctedItemID = nil
                }
            }
            
            $tag3SelctedItemID.listen {
                
                if let _ = $0 {
                    self.tag2isDisabeld = false
                    self.tag3Field.class(.isOk)
                }
                else {
                    
                    self.tag2isDisabeld = true
                    self.tag3Field.removeClass(.isOk)
                    self.tag2 = ""
                    self.tag2SelctedItemID = nil
                }
            }
            
            $tag2SelctedItemID.listen {
                if let _ = $0 {
                    self.tag2Field.class(.isOk)
                }
                else{
                    self.tag2Field.removeClass(.isOk)
                }
            }
            
            $tag3isDisabeld.listen {
                if $0 {
                    self.tag3Field.disabled(true)
                    self.tag3Field.opacity(0.3)
                }
                else{
                    self.tag3Field.disabled(false)
                    self.tag3Field.opacity(1.0)
                }
            }
            
            $tag2isDisabeld.listen {
                if $0 {
                    self.tag2Field.disabled(true)
                    self.tag2Field.opacity(0.3)
                }
                else{
                    self.tag2Field.disabled(false)
                    self.tag2Field.opacity(1.0)
                }
            }
        }
        
        $dateSelectListener.listen {
            
            guard let range = DateRangeSelection(rawValue: $0)?.range else {
                self.startAtLabel = ""
                self.endAtLabel = ""
                return
            }
            
            Console.clear()
            
            print(range.startAt)
            
            print(range.endAt)
            
            let startAt = getDate(range.startAt)
            
            let endAt = getDate(range.endAt)
            
            self.startAtLabel = "\(startAt.formatedLong) \(startAt.time)"
            
            self.endAtLabel = "\(endAt.formatedLong) 23:59"
            
        }
        
        DateRangeSelection.allCases.forEach { item in
            dateSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        dateSelectListener = DateRangeSelection.lastThirtydays.rawValue
        
    }
    
    /// type
    
    /// brand
    func tag1Focus(){
        
        self.selectEquipmentField = "tag1"
        
        if orderManagerBrand.isEmpty {
            
            /// No brands  available  to `TYPE`
            self.tag1ResultsView.hidden(true)
            self.tag2ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            
            return
        }
        else {
            
            self.tag1Results.innerHTML = ""
            
            self.tag1CurrentSeleccionList.removeAll()
            
            /// This means their has already been a selection  on bulr will default back is selction remaind valid
            if let _ = tag1SelctedItemID {
                self.tag1 = ""
            }
            
            /// Strat filtering proces is applied
            if self.tag1.isEmpty{
                self.curOrderManagerBrand = orderManagerBrand
            }
            else {
                /// term to search
                let term = self.tag1.purgeSpaces.pseudo
                
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
                        self.tag1 = name
                        self.tag1SelctedItemID = nil
                        self.tag1SelctedItemID = id
                        self.tag3 = ""
                    }
                    
                    // Preform Focus Accion
                    self.tag3Field.select()
                    
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
            showError(.generalError, "Seleccione \(configServiceTags.idTagName.uppercased())")
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
            
            return
        }
        
        self.tag3Results.innerHTML = ""
        
        /// This means their has already been a selection  on bulr will default back is selction remaind valid
        if let _ = tag3SelctedItemID {
            self.tag3 = ""
        }
        
        if self.tag3.isEmpty {
            curOrderManagerType = _curOrderManagerType
        }
        else{
            /// term to search
            let term = self.tag3.purgeSpaces.pseudo
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
                    self.tag3 = name
                    // self.tag3SelctedItem = type.name
                    self.tag3SelctedItemID = nil
                    self.tag3SelctedItemID = id
                    self.tag2 = ""
                }
                // Preform Focus Accion
                self.tag2Field.select()
                
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
            showError(.generalError, "Seleccione tipo objeto")
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
            
            
            return
        }
        else {
            
            self.tag2Results.innerHTML = ""
            
            self.tag2CurrentSeleccionList.removeAll()
            
            /// This means their has already been a selection  on bulr will default back is selction remaind valid
            if let _ = tag2SelctedItemID {
                self.tag2 = ""
            }
            
            /// Strat filtering proces is applied
            if self.tag2.isEmpty {
                curOrderManagerModel = _curOrderManagerModel
            }
            else{
               
                /// term to search
                let term = self.tag2.purgeSpaces.pseudo
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
                    self.tag2 = name
                    self.tag2SelctedItemID = nil
                    self.tag2SelctedItemID = id
                    
                    self.tag1ResultsView.hidden(true)
                    self.tag3ResultsView.hidden(true)
                    self.tag2ResultsView.hidden(true)
                    
                }
                
                self.tag2Results.appendChild(view)
            }
            
            self.tag1ResultsView.hidden(true)
            self.tag3ResultsView.hidden(true)
            self.tag2ResultsView.hidden(false)
            
        }
    }
    
    func advancedSearchFolio(){
        
        var startAtUTS: Int64? = nil
        
        var endAtUTS: Int64? = nil
        
        if let range = DateRangeSelection(rawValue: dateSelectListener)?.range  {
            startAtUTS = range.startAt
            endAtUTS = range.endAt
        }
        else {
            
            if startAt.isEmpty {
                showError(.requiredField, "Ingrese fecha de Inicio")
            }
            
            var dateParts = startAt.explode("/")
            
            if dateParts.count != 3 {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA"))
                return
            }
            
            guard let startDay = Int(dateParts[0]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31"))
                return
            }
            
            guard (startDay > 0 && startDay < 32) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31."))
                return
            }
            
            guard let startMonth = Int(dateParts[1]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard (startMonth > 0 && startMonth < 13) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard let startYear = Int(dateParts[2]) else {
                return
            }
            
            guard startYear >= (Date().year - 4) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Año invalido, ingrese un año igual o mayor que 4 años atras."))
                return
            }
            
            var comps = DateComponents()
            
            comps.day = startDay
            comps.month = startMonth
            comps.year = startYear
            comps.hour = 0
            comps.minute = 0
            
            guard let _startAtUTS = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
                showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
                return
            }
            
            dateParts = endAt.explode("/")
            
            if dateParts.count != 3 {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA"))
                return
            }
            
            guard let endDay = Int(dateParts[0]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31"))
                return
            }
            
            guard (endDay > 0 && endDay < 32) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31."))
                return
            }
            
            guard let endMonth = Int(dateParts[1]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard (endMonth > 0 && endMonth < 13) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard let endYear = Int(dateParts[2]) else {
                return
            }
            
            guard endYear >= (Date().year - 4) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Año invalido, ingrese un año igual o mayor que 4 años atras."))
                return
            }
            
            comps.day = endDay
            comps.month = endMonth
            comps.year = endYear
            comps.hour = 23
            comps.minute = 59
            
            guard let _endAtUTS = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
                showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
                return
            }
            
            startAtUTS = _startAtUTS + (60 * 60 * 6)
            
            endAtUTS = _endAtUTS + (60 * 60 * 6)
        }
        
        guard let startAtUTS else {
            showError(.requiredField, "Establezca fecha de inicio")
            return
        }
        
        guard let endAtUTS else {
            showError(.requiredField, "Establezca fecha de inicio")
            return
        }
        
        bizData = bizData.purgeSpaces
        firstName = firstName.purgeSpaces
        lastName = lastName.purgeSpaces
        commMeth = commMeth.purgeSpaces
        tag1 = tag1.purgeSpaces
        tag2 = tag2.purgeSpaces
        tag3 = tag3.purgeSpaces
        tag4 = tag4.purgeSpaces
        descr = descr.purgeSpaces
        
        loadingView(show: true)
        
        API.custAPIV1.advancesSearch(
            businessTerm: bizData,
            firstName: firstName,
            lastName: lastName,
            communication: commMeth,
            street: street,
            colonie: colonie,
            city: city,
            tag1: tag1,
            tag2: tag2,
            tag3: tag3,
            tag4: tag4,
            description: descr,
            startAt: startAtUTS,
            endAt: endAtUTS
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
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
            
            self.orders = data.orders
            
            self.accounts = data.accounts
            
        }
    }
}

