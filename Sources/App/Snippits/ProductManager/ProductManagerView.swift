
//
//  ProductManagerView.swift
//  
//
//  Created by Victor Cantu on 1/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ProductManagerView: Div {
    
    override class var name: String { "div" }
    
    private var close: ((
    ) -> ())
    
    private var minimize: ((
    ) -> ())

    init(
        close: @escaping ((
        ) -> ()),
        minimize: @escaping ((
        ) -> ())
    ) {
        self.close = close
        self.minimize = minimize
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var department: UUID? = nil
    @State var departmentName = ""
    
    @State var category: UUID? = nil
    @State var categoryName = ""
    
    @State var line: UUID? = nil
    @State var lineName = ""
    
    @State var levelView: LevelView = .department
    
    @State var categories: [CustStoreCatsQuick] = []
    
    @State var lines: [CustStoreLinesQuick] = []
    
    @State var depPOCs: [CustPOCQuick] = []
    
    @State var catPOCs: [CustPOCQuick] = []
    
    @State var linePOCs: [CustPOCQuick] = []
    
    @State var title = "Departamentos"
    
    @State var backLink = ""
    
    @State var productTranferMode = false
    
    @State var selectedProductIds: [UUID] = []
    
    var pocRowRefrence: [UUID:StoreItemPOCView] = [:]
    
    lazy var departmentsView = Div {
        Table{
            Tr{
                Td("Crear Departamento...")
                .verticalAlign(.middle)
                .align(.center)
                .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
        .id(Id(stringLiteral: "departmentsView"))
        .class(.roundDarkBlue)
        .height(100.percent)
        .padding(all: 7.px)
        .overflow(.auto)
        
    lazy var categoriesView = Div {
        Table{
            Tr{
                Td("Crear Categoria...")
                .verticalAlign(.middle)
                .align(.center)
                .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
        .id(Id(stringLiteral: "categoriesView"))
        .class(.roundDarkBlue)
        .height(100.percent)
        .padding(all: 7.px)
        .overflow(.auto)
    
    lazy var linesView = Div {
        Table{
            Tr{
                Td("Crear Linea...")
                .verticalAlign(.middle)
                .align(.center)
                .color(.gray)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
        .id(Id(stringLiteral: "linesView"))
        .class(.roundDarkBlue)
        .height(100.percent)
        .padding(all: 7.px)
        .overflow(.auto)
    
    lazy var productsView = Div ()
    
    @State var searchTerm = ""
    
    var productSuperSearchView: ProductSuperSearchView? = nil
    
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .marginRight(12.px)
                    .marginTop(7.px)
                    .onClick{
                        self.close()
                    }
                
                Img()
                    .src("/skyline/media/lowerWindow.png")
                    .marginRight(18.px)
                    .class(.iconWhite)
                    .cursor(.pointer)
                    .marginTop(7.px)
                    .float(.right)
                    .width(24.px)
                    .onClick {
                        self.minimize()
                    }
                
                Div{
                    Img()
                        .src("/skyline/media/add.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Compras")
                        .fontSize(22.px)
                }
                .onClick({
                    addToDom(ToolReciveSendInventory(loadid: nil))
                })
                .marginRight(18.px)
                .class(.uibtn)
                .float(.right)
                
                Div{
                    Span("Transferencias")
                        .fontSize(22.px)
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.right)
                .onClick{
                    self.loadProductTransferView()
                }
                
                Div{
                    Span("Auditar").fontSize(22.px)
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.right)
                .onClick({
                    addToDom(AuditView(auditType: .general))
                })
                
                //
                
                /*
                 addToDom(SocialManagerAddProfileView { page in
                 */
                
                H2("Tienda")
                    .color(.lightBlueText)
                    .marginRight(12.px)
                    .float(.left)
                
                Div{
                    Div(self.$searchTerm.map{ $0.isEmpty ? "Buscar Producto..." : $0 })
                        .color(self.$searchTerm.map{ $0.isEmpty ? .gray : .white })
                }
                .class(.textFiledBlackDark)
                .borderRadius(12.px)
                .cursor(.pointer)
                .padding(all: 7.px)
                .width(350.px)
                .float(.left)
                .onClick {
                    
                    if let view = self.productSuperSearchView {
                        
                        addToDom(view)
                        
                        view.fadeIn(time: 0.3, begin: .display(.block)) {
                            view.searchProductField.select()
                        }
                        
                        return
                    }
                    
                    let view = ProductSuperSearchView(searchTerm: self.$searchTerm) {
                        self.productSuperSearchView?.remove()
                        self.productSuperSearchView = nil
                        self.searchTerm = ""
                    }
                    
                    self.productSuperSearchView = view
                    
                    addToDom(view)
                }
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            Div{
                
                Div{
                    
                    H2(self.$title)
                        .color(.gold)
                        .float(.left)
                    
                    H2(self.$backLink)
                        .hidden(self.$backLink.map{ $0.isEmpty })
                        .color(.darkOrange)
                        .marginLeft(7.px)
                        .float(.left)
                        .onClick {
                            
                            self.productTranferMode = false
                            
                            self.selectedProductIds = []
                            
                            switch self.levelView {
                            case .department:
                                break
                            case .category:
                                
                                print("Return to  dep")
                                
                                self.department = nil
                                self.departmentName  = ""
                                
                            case .line:
                                print("return to cat")
                                
                                self.category = nil
                                self.categoryName  = ""
                                
                            case .lineSelected:
                                self.line = nil
                                self.lineName  = ""
                            }
                            
                        }
                    
                    Div{
                        
                        Img()
                            .src(self.$productTranferMode.map{ $0 ? "/skyline/media/cross.png": "/skyline/media/pencil.png" })
                            .paddingRight(7.px)
                            .height(18.px)
                        
                        Span(self.$productTranferMode.map{ $0 ? "Cancelar Edicion" : "Editar" })
                    }
                    .class(.uibtnLargeOrange)
                    .marginTop(-7.px)
                    .float(.right)
                    .onClick {
                        if self.productTranferMode {
                            print("productTranferMode 🟢 007")
                            self.selectedProductIds = []
                            self.productTranferMode = false
                        }
                        else {
                            self.productTranferMode = true
                        }
                    }
                    
                    Div{
                        Img()
                            .src("/skyline/media/history_setting_icon_orange.png")
                            .paddingRight(7.px)
                            .height(18.px)
                        Span("Configuración")
                    }
                    .class(.uibtnLargeOrange)
                    .marginRight(12.px)
                    .marginTop(-7.px)
                    .float(.right)
                    .onClick {
                        let view = Configuration()
                        addToDom(view)
                    }
                    
                    /*
                    Div{
                        Img()
                            .src( MercadoLibreControler.shared.$profile.map{ ($0 == nil) ? "/skyline/media/mercadoLibreLongLogoGray.png" : "/skyline/media/mercadoLibreLongLogoYellow.png" } )
                            .cursor(.pointer)
                            .height(32.px)
                            
                    }
                    .marginRight(12.px)
                    .float(.right)
                    .onClick {
                        
                        let profiles = customerServiceProfile?.profile ?? []
                        
                        print(profiles)
                        
                        if profiles.contains(.thirdPartyOnlineStores) {
                            print("🟢001")
                            /// No profile , Connect  View
                            if MercadoLibreControler.shared.profile == nil {
                                
                                let view = SocialManagerAddProfileView(
                                    type: .mercadoLibre
                                ) { page in
                                    
                                }
                                addToDom(view)
                            }
                            ///  Has profile show settings
                            else {
                                
                            }
                            
                        }
                        else {
                            print("🟢002")
                            /// Load Promotinal contract page
                        }
                    }
                    */
                    Div().class(.clear)
                }
                .marginBottom(7.px)
                .height(30.px)
                
                Div{
                    
                    /// Departamentos
                    Div{
                        
                        Div {
                            self.departmentsView
                        }
                        .custom("height", "calc(100% - 72px)")
                        .marginBottom(12.px)
                        
                        Div().class(.clear)
                        
                        Div("+ Agregar Departamento")
                            .class(.uibtnLargeOrange)
                            .textAlign(.center)
                            .width(92.percent)
                            .marginTop(23.px)
                            .onClick {
                                
                                self.appendChild(CreateStoreLevelDepartement(
                                    callback: { id, name in
                                        /*
                                        self.department = id
                                        self.departmentName = name
                                        */
                                        storeDeps.append(.init(
                                            id: id,
                                            modifiedAt: getNow(),
                                            name: name,
                                            smallDescription: "",
                                            description: "",
                                            icon: "",
                                            coverLandscape: "",
                                            coverPortrait: ""
                                        ))
                                        
                                        let view = StoreItemTierView(
                                            type: .dep,
                                            dep: id,
                                            cat: nil,
                                            line: nil,
                                            tierName: name,
                                            icon: "",
                                            coverLandscape: "",
                                            coverPortrait: ""
                                        ) { isEdited, id, name in
                                            
                                            self.productTranferMode = false
                                            self.selectedProductIds = []
                                            
                                            if isEdited {
                                                var cc = 0
                                                storeDeps.forEach { item in
                                                    if item.id == id  {
                                                        storeDeps[cc].name = name
                                                    }
                                                    cc += 1
                                                }
                                            }
                                            else{
                                                self.loadDepartment(id, name)
                                            }
                                            
                                        }
                                        
                                        self.departmentsView.appendChild(view)
                                        
                                        _ = JSObject.global.scrollToBottom!( "departmentsView")
                                        
                                    },
                                     deleted: {
                                         /// No action requierd
                                     },
                                    changeAvatar: { id, url in
                                         
                                     }))
                                
                            }
                        
                        Div().class(.clear)
                    }
                    .hidden(self.$levelView.map({ $0 != .department }))
                    .height(100.percent)
                    .width(370.px)
                    .float(.left)
                    
                    /// Categoria
                    Div{
                        
                        H3("Categorias")
                            .marginBottom(12.px)
                            .color(.white)
                        
                        Div().class(.clear)
                        
                        Div {
                            self.categoriesView
                        }
                        .custom("height", "calc(100% - 110px)")
                        .marginBottom(12.px)
                        
                        Div().class(.clear)
                        
                        Div("+ Agregar Categoria")
                            .class(.uibtnLargeOrange)
                            .textAlign(.center)
                            .width(92.percent)
                            .marginTop(23.px)
                            .onClick {
                                
                                guard let department = self.department else {
                                    return
                                }
                                
                                addToDom(CreateStoreLevelCategoria(
                                    depid: department,
                                    depname: self.departmentName,
                                    callback: { id, name in
                                        /*
                                        self.category = id
                                        self.categoryName = name
                                        */
                                        self.categories.append(.init(
                                            id: id,
                                            name: name,
                                            icon: "",
                                            coverLandscape: "",
                                            coverPortrait: ""
                                        ))
                                        
                                        let view = StoreItemTierView(
                                            type: .cat,
                                            dep: department,
                                            cat: id,
                                            line: nil,
                                            tierName: name,
                                            icon: "",
                                            coverLandscape: "",
                                            coverPortrait: ""
                                        ) { isEdited, id, tierName in
                                            
                                            self.productTranferMode = false
                                            self.selectedProductIds = []
                                            
                                            if isEdited {
                                                //@State var categories: [CustStoreCatsQuick] = []
                                                var cc = 0
                                                self.categories.forEach { cat in
                                                    if cat.id == id {
                                                        self.categories[cc].name = tierName
                                                    }
                                                    cc += 1
                                                }
                                            }
                                            else{
                                                self.loadCategorie(id, tierName)
                                            }
                                            
                                        }
                                        
                                        self.categoriesView.appendChild(view)
                                        
                                        _ = JSObject.global.scrollToBottom!( "categoriesView")
                                    },
                                    deleted: {
                                        
                                    },
                                    changeAvatar: { id, url in
                                        
                                    })
                                )
                            }
                        
                        Div().class(.clear)
                        
                    }
                    .hidden(self.$levelView.map({ $0 != .category }))
                    .height(100.percent)
                    .width(370.px)
                    .float(.left)
                    
                    /// Linea
                    Div{
                        
                        H3("Lineas")
                            .color(.white)
                            .marginBottom(12.px)
                        
                        Div {
                            self.linesView
                        }
                        .custom("height", "calc(100% - 110px)")
                        .marginBottom(12.px)
                        
                        Div().class(.clear)
                        
                        Div("+ Agregar Linea")
                            .class(.uibtnLargeOrange)
                            .textAlign(.center)
                            .width(92.percent)
                            .marginTop(23.px)
                            .onClick {
                                
                                guard let department = self.department else {
                                    return
                                }
                                
                                guard let category = self.category else{
                                    return
                                }
                                
                                addToDom(
                                    CreateStoreLevelLine(
                                        catid: category,
                                        catname: self.categoryName,
                                        callback: { id, name in
                                            /*
                                            self.line = id
                                            self.lineName = name
                                            */
                                            self.lines.append(.init(
                                                id: id,
                                                name: name,
                                                icon: "",
                                                coverLandscape: "",
                                                coverPortrait: ""
                                            ))
                                            
                                            let view = StoreItemTierView(
                                                type: .line,
                                                dep: department,
                                                cat: category,
                                                line: id,
                                                tierName: name,
                                                icon: "",
                                                coverLandscape: "",
                                                coverPortrait: ""
                                            ) { isEdited, id, tierName in
                                                
                                                
                                                self.productTranferMode = false
                                                self.selectedProductIds = []
                                                
                                                
                                                if isEdited {
                                                    //@State var lines: [CustStoreLinesQuick] = []
                                                    var cc = 0
                                                    self.lines.forEach { line in
                                                        if line.id == id {
                                                            self.lines[cc].name = tierName
                                                        }
                                                        cc += 1
                                                    }
                                                }
                                                else{
                                                    self.loadLine(id, tierName)
                                                }
                                                
                                            }
                                            
                                            self.linesView.appendChild(view)
                                            
                                            _ = JSObject.global.scrollToBottom!( "linesView")
                                            
                                        },
                                        deleted: {
                                            
                                        },
                                        changeAvatar: { id, url in
                                            
                                        }
                                    )
                                )
                            }
                        
                        Div().class(.clear)
                        
                    }
                    .hidden(self.$levelView.map({ $0 != .line }))
                    .height(100.percent)
                    .width(370.px)
                    .float(.left)
                    
                    self.productsView
                        .custom("height", "calc(100% - 24px)")
                        .custom("width", "calc(100% - 395px)")
                        .class(.roundDarkBlue)
                        .marginLeft(7.px)
                        .overflow(.auto)
                        .padding(all: 7.px)
                        .float(.left)
                }
                .custom("height", "calc(100% - 37px)")
                
                Div{
                    Div("Tranferir Productos")
                    Div("Cambiar de Departamento")
                    .class(.oneLineText)
                    .textAlign(.center)
                    .color(.lightGray)
                    .fontSize(13.px)
                }
                .boxShadow(h: 0.px, v: 0.px, blur: 24.px, color: .black)
                .hidden(self.$productTranferMode.map{ !$0 })
                .class(.uibtnLargeOrange)
                .position(.absolute)
                .bottom(24.px)
                .right(24.px)
                .onClick {
                    self.transferProducts()
                }
                
                Div{
                    Div("+ Agregar Producto")
                    Div(self.$levelView.map {
                        switch $0 {
                        case .department:
                            return "- Sin Departamento -"
                        case .category:
                            return "Departameto \(self.departmentName)"
                        case .line:
                            return "Categoria \(self.categoryName)"
                        case .lineSelected:
                            return "Linea \(self.lineName)"
                        }
                    })
                    .class(.oneLineText)
                    .textAlign(.center)
                    .color(.lightGray)
                    .fontSize(13.px)
                }
                    .boxShadow(h: 0.px, v: 0.px, blur: 24.px, color: .black)
                    .hidden(self.$productTranferMode.map{ $0 })
                    .class(.uibtnLargeOrange)
                    .position(.absolute)
                    .bottom(24.px)
                    .right(24.px)
                    .onClick {
                        self.addProduct()
                    }
                
            }
            .custom("height", "calc(100% - 37px)")
            
        }
        .custom("height","calc(100% - 75px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(34.px)
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        self.loadDeps()
        
        $department.listen {
            if let _ = $0 {
                /// I have selected a departe and am now in category mode
                self.backLink = "< Todos los Departamentos"
                
                self.title = "DEP: \(self.departmentName)"
                
                self.levelView = .category
                
            }
            else{
                /// I have resign  department will return   to main view
                
                self.title = "Departamentos"
                
                self.backLink = ""
                
                self.productsView.innerHTML = ""
                
                self.levelView = .department
                
            }
        }
        
        $category.listen {
            if let _ = $0 {
                
                self.backLink = "< \(self.departmentName)"
                
                self.title = "CAT: \(self.categoryName)"
                
                self.levelView = .line
                
            }
            else{
                
                self.backLink = "< Todos los Departamentos"
                
                self.title = "DEP: \(self.departmentName)"
                
                self.categories = []
                
                self.productsView.innerHTML = ""
                
                self.catPOCs.forEach { poc in
                    
                    let view = StoreItemPOCView(
                        searchTerm: "",
                        poc: .init(
                            id: poc.id,
                            upc: poc.upc,
                            name: poc.name,
                            brand: poc.brand,
                            model: poc.model,
                            price: poc.pricea,
                            avatar: poc.avatar,
                            units: nil,
                            reqSeries: poc.reqSeries
                        )
                    ) { update, deleted in
                        
                        if self.productTranferMode {
                            print("productTranferMode 🟢 001")
                            if !self.selectedProductIds.contains(poc.id) {
                                print("productTranferMode 🟢")
                                self.selectedProductIds.append(poc.id)
                            }
                            else {
                                
                                print("productTranferMode 🟡")
                                
                                var _selectedProductIds: [UUID] = []
                                
                                self.selectedProductIds.forEach { id in
                                    if id == poc.id {
                                        return
                                    }
                                    _selectedProductIds.append(id)
                                }
                                
                                self.selectedProductIds = _selectedProductIds
                                
                            }
                            return
                        }
                        
                        let view = ManagePOC(
                            leveltype: CustProductType.all,
                            levelid: nil,
                            levelName: "",
                            pocid: poc.id,
                            titleText: "",
                            quickView: false
                        ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                            update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                        } deleted: {
                            deleted()
                        }
                        /*
                                _ pocid: UUID,
        _ upc: String,
        _ brand: String,
        _ model: String,
        _ name: String,
        _ cost: Int64,
        _ price: Int64,
        _ avatar: String,
        _ reqSeries: Bool
                        */
                        
                        addToDom(view)
                    }.border(
                        width: .thick,
                        style: self.$selectedProductIds.map{ $0.contains(poc.id) ? .solid : .none },
                        color: .skyBlue
                    )
                    
                    self.pocRowRefrence[poc.id] = view
                    
                    self.productsView.appendChild(view)
                    
                }
                
                self.levelView = .category
                
            }
        }
        
        $line.listen {
            
            if let _ = $0 {
                self.productsView
                    .custom("width", "calc(100% - 36px)")
                
                self.backLink = "< \(self.categoryName)"
                
                self.title = "LINEA: \(self.lineName)"
                
                self.levelView = .lineSelected
            
            }
            else {
                
                self.productsView
                    .custom("width", "calc(100% - 397px)")
                
                self.backLink = "< \(self.departmentName)"
                
                self.title = "CAT: \(self.categoryName)"
                
                self.lines = []
                
                self.productsView.innerHTML = ""
                
                self.linePOCs.forEach { poc in
                    
                    let view = StoreItemPOCView(
                        searchTerm: "",
                        poc: .init(
                            id: poc.id,
                            upc: poc.upc,
                            name: poc.name,
                            brand: poc.brand,
                            model: poc.model,
                            price: poc.pricea,
                            avatar: poc.avatar,
                            units: nil,
                            reqSeries: poc.reqSeries
                        )
                    )
                    { update, deleted in
                        
                        if self.productTranferMode {
                            print("productTranferMode 🟢 002")
                            if !self.selectedProductIds.contains(poc.id) {
                                self.selectedProductIds.append(poc.id)
                            }
                            else {
                                
                                var _selectedProductIds: [UUID] = []
                                
                                self.selectedProductIds.forEach { id in
                                    if id == poc.id {
                                        return
                                    }
                                    _selectedProductIds.append(id)
                                }
                                
                                self.selectedProductIds = _selectedProductIds
                                
                            }
                            return
                        }
                        
                        let view = ManagePOC(
                            leveltype: CustProductType.all,
                            levelid: nil,
                            levelName: "",
                            pocid: poc.id,
                            titleText: "",
                            quickView: false
                        ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                            update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                        } deleted: {
                            deleted()
                        }
                        
                        
                        addToDom(view)
                    }.border(
                        width: BorderWidthType.thick,
                        style: self.$selectedProductIds.map{ $0.contains(poc.id) ? .solid : .none },
                        color: .skyBlue
                    )
                    
                    self.pocRowRefrence[poc.id] = view
                    
                    self.productsView.appendChild(view)
                    
                }
                
                self.levelView = .line
                
            }
            
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
    func loadDeps(){
        
        if !storeDeps.isEmpty {
            loadDepsAction()
            return
        }
        
        loadingView(show: true)
        
        API.v1.storeDeps(curObjs: []) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let deps = resp.data?.deps else {
                showError(.errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            storeDeps = deps
            
            self.loadDepsAction()
        }
        
    }
    
    func loadDepsAction() {
        
        if storeDeps.isEmpty {
            return
        }
        
        self.departmentsView.innerHTML = ""
        
        storeDeps.forEach { dep in
            
            let view = StoreItemTierView(
                type: .dep,
                dep: dep.id,
                cat: nil,
                line: nil,
                tierName: dep.name,
                icon: dep.icon,
                coverLandscape: dep.coverLandscape,
                coverPortrait: dep.coverPortrait
            ) { isEdited, id, depname in
                
                self.productTranferMode = false
                self.selectedProductIds = []
                
                if isEdited {
                    var cc = 0
                    storeDeps.forEach { item in
                        if item.id == id  {
                            storeDeps[cc].name = depname
                        }
                        cc += 1
                    }
                }
                else{
                    self.loadDepartment(id, depname)
                }
            }
            
            self.departmentsView.appendChild(view)
            
        }
    }
    
    func loadDepartment(_ depid: UUID,_ depname: String){
        
        loadingView(show: true)
        
        API.custAPIV1.storeLoadDepartment(id: depid) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            self.departmentName = depname
            
            self.department = depid
            
            self.categoriesView.innerHTML = ""
            
            self.categories = payload.cats
            
            self.catPOCs = payload.prods
            
            payload.cats.forEach { cat in
                
                let view = StoreItemTierView(
                    type: .cat,
                    dep: depid,
                    cat: cat.id,
                    line: nil,
                    tierName: cat.name,
                    icon: cat.icon,
                    coverLandscape: cat.coverLandscape,
                    coverPortrait: cat.coverPortrait
                ) { isEdited, id, tierName in
                    
                    self.productTranferMode = false
                    self.selectedProductIds = []
                    
                    if isEdited {
                        var cc = 0
                        self.categories.forEach { cat in
                            if cat.id == id {
                                self.categories[cc].name = tierName
                            }
                            cc += 1
                        }
                    }
                    else{
                        self.loadCategorie(id, tierName)
                    }
                }
                
                self.categoriesView.appendChild(view)

                
            }
            
            self.addProductToDom(pocs: payload.prods)
            
        }
    }
    
    func loadCategorie(_ catid: UUID,_ catname: String) {
        
        loadingView(show: true)
        
        API.custAPIV1.storeLoadCategorie(id: catid) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                return
            }
            
            guard let depid = self.department else{
                return
            }
            
            self.categoryName = catname
            
            self.category = catid
            
            self.linesView.innerHTML = ""
            
            self.lines = payload.lines
            
            self.linePOCs = payload.prods
            
            payload.lines.forEach { line in
                
                let view = StoreItemTierView(
                    type: .line,
                    dep: depid,
                    cat: catid,
                    line: line.id,
                    tierName: line.name,
                    icon: line.icon,
                    coverLandscape: line.coverLandscape,
                    coverPortrait: line.coverPortrait
                ) { isEdited, id, tierName in
                    
                    self.productTranferMode = false
                    self.selectedProductIds = []
                    
                    if isEdited {
                        var cc = 0
                        self.lines.forEach { line in
                            if line.id == id {
                                self.lines[cc].name = tierName
                            }
                            cc += 1
                        }
                    }
                    else{
                        self.loadLine(id, tierName)
                    }
                }
                
                self.linesView.appendChild(view)
                
            }
            
            self.addProductToDom(pocs: payload.prods)
            
        }
    }
    
    func loadLine(_ lineid: UUID,_ linename: String){
        
        loadingView(show: true)
        
        API.custAPIV1.storeLoadLine(id: lineid) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                return
            }
            
            self.levelView = .lineSelected
            
            self.lineName = linename
            
            self.line = lineid
            
            self.addProductToDom(pocs: payload.prods)
            
        }
    
    }
    
    func transferProducts() {
        
        if selectedProductIds.isEmpty {
            showError(.errorGeneral, "Seleccione Produtos a transferir")
            return
        }
        
        if storeDeps.isEmpty {
            showError(.errorGeneral, "No hay departamentos para hacer una trasferencia.")
            return
        }
        
        if storeDeps.count == 1 {
            showError(.errorGeneral, "Debe haber más de un departamento para poder hacer una transferencia.")
            return
        }
        
        var level: CustProductType = .main
        
        var levelId: UUID? = nil
        
        var levelName = ""
        
        switch levelView{
        case .department:
            /// Main level
            levelName = "Seccion Principal"
        case .category:
            level = .dep
            levelId = department
            levelName = departmentName
        case .line:
            level = .cat
            levelId = category
            levelName = categoryName
        case .lineSelected:
            level = .line
            levelId = line
            levelName = lineName
        }
        
        addToDom(ProductDepartmentTranferView(
            level: level,
            levelId: levelId,
            levelName: levelName,
            pocids: selectedProductIds,
            storeDeps: storeDeps,
            callback: {
                
                switch self.levelView{
                case .department:
                    break
                case .category:
                    self.depPOCs = []
                case .line:
                    self.catPOCs = []
                case .lineSelected:
                    self.linePOCs = []
                }
                
                self.selectedProductIds.forEach { id in
                    self.pocRowRefrence[id]?.remove()
                    self.pocRowRefrence.removeValue(forKey: id)
                }
            }
        ))
        
    }
    
    func addProduct(){
        switch levelView {
        case .department:
            addToDom(ConfirmView(
                type: .ok,
                title: "Funcion no soportada",
                message: "Aun no es posible agregar productos SIN DEPARTAMENTO, si necesitas esta funccion contacta a Soporte TC",
                callback: { isConfirmed, comment in
                    
                }))
        case .category:
            
            let view = ManagePOC(
                leveltype: .dep,
                levelid: department,
                levelName: departmentName,
                pocid: nil,
                titleText: "Departamento \(departmentName)",
                quickView: false
            ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                
                let view = StoreItemPOCView(
                    searchTerm: "",
                    poc: .init(
                        id: pocid,
                        upc: upc,
                        name: name,
                        brand: brand,
                        model: model,
                        price: price,
                        avatar: avatar,
                        units: nil,
                        reqSeries: reqSeries
                    )
                ) { update, deleted in
                    
                    if self.productTranferMode {
                        print("productTranferMode 🟢 003")
                        if !self.selectedProductIds.contains(pocid) {
                            self.selectedProductIds.append(pocid)
                        }
                        else {
                            
                            var _selectedProductIds: [UUID] = []
                            
                            self.selectedProductIds.forEach { id in
                                if id == pocid {
                                    return
                                }
                                _selectedProductIds.append(id)
                            }
                            
                            self.selectedProductIds = _selectedProductIds
                            
                        }
                        return
                    }
                    
                    let view = ManagePOC(
                        leveltype: CustProductType.all,
                        levelid: nil,
                        levelName: "",
                        pocid: pocid,
                        titleText: "",
                        quickView: false
                    ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                        
                        update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                        
                    } deleted: {
                        deleted()
                    }
                    
                    addToDom(view)
                }.border(
                    width: BorderWidthType.thick,
                    style: self.$selectedProductIds.map{ $0.contains(pocid) ? .solid : .none },
                    color: .skyBlue
                )
                
                self.pocRowRefrence[pocid] = view
                
                self.productsView.appendChild(view)
                
            }
            deleted: {
                
            }
            
            
            addToDom(view)
            
        case .line:
            
            let view = ManagePOC(
                leveltype: .cat,
                levelid: category,
                levelName: categoryName,
                pocid: nil,
                titleText: "Categoria \(categoryName)",
                quickView: false
            ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                
                let view = StoreItemPOCView(
                    searchTerm: "",
                    poc: .init(
                        id: pocid,
                        upc: upc,
                        name: name,
                        brand: brand,
                        model: model,
                        price: price,
                        avatar: avatar,
                        units: nil,
                        reqSeries: reqSeries
                    )
                ) { update, deleted in
                    
                    if self.productTranferMode {
                        print("productTranferMode 🟢 004")
                        if !self.selectedProductIds.contains(pocid) {
                            self.selectedProductIds.append(pocid)
                        }
                        else {
                            
                            var _selectedProductIds: [UUID] = []
                            
                            self.selectedProductIds.forEach { id in
                                if id == pocid {
                                    return
                                }
                                _selectedProductIds.append(id)
                            }
                            
                            self.selectedProductIds = _selectedProductIds
                            
                        }
                        return
                    }
                    
                    let view = ManagePOC(
                        leveltype: CustProductType.all,
                        levelid: nil,
                        levelName: "",
                        pocid: pocid,
                        titleText: "",
                        quickView: false
                    ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                        
                        update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                        
                    }
                    deleted: {
                        deleted()
                    }
                    
                    
                    addToDom(view)
                }.border(
                    width: .thick,
                    style: self.$selectedProductIds.map{ $0.contains(pocid) ? .solid : .none },
                    color: .skyBlue
                )
                
                self.pocRowRefrence[pocid] = view
                
                self.productsView.appendChild(view)
                
            } deleted: {
                
            }
            
            addToDom(view)
            
        case .lineSelected:
            
            let view = ManagePOC(
                leveltype: .line,
                levelid: line,
                levelName: lineName,
                pocid: nil,
                titleText: "Liena \(lineName)",
                quickView: false
            ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                
                let view = StoreItemPOCView(
                    searchTerm: "",
                    poc: .init(
                        id: pocid,
                        upc: upc,
                        name: name,
                        brand: brand,
                        model: model,
                        price: price,
                        avatar: avatar,
                        units: nil,
                        reqSeries: reqSeries
                    )
                ) { update, deleted in
                    
                    if self.productTranferMode {
                        print("productTranferMode 🟢 005")
                        if !self.selectedProductIds.contains(pocid) {
                            self.selectedProductIds.append(pocid)
                        }
                        else {
                            
                            var _selectedProductIds: [UUID] = []
                            
                            self.selectedProductIds.forEach { id in
                                if id == pocid {
                                    return
                                }
                                _selectedProductIds.append(id)
                            }
                            
                            self.selectedProductIds = _selectedProductIds
                            
                        }
                        return
                    }
                    
                    let view = ManagePOC(
                        leveltype: CustProductType.all,
                        levelid: nil,
                        levelName: "",
                        pocid: pocid,
                        titleText: "",
                        quickView: false
                    ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                        
                        update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                        
                    }
                    deleted: {
                        deleted()
                    }
                    
                    addToDom(view)
                }.border(
                    width: BorderWidthType.thick,
                    style: self.$selectedProductIds.map{ $0.contains(pocid) ? .solid : .none },
                    color: .skyBlue
                )
                
                self.pocRowRefrence[pocid] = view
                
                self.productsView.appendChild(view)
                
            } deleted: {
                
            }
            
            addToDom(view)
            
        }
    }
    
    func addProductToDom(pocs: [CustPOCQuick]){
        
        self.productsView.innerHTML = ""
        
        var suspende: [CustPOCQuick] = []
        
        pocs.forEach { poc in
            
            if poc.status == .suspended {
                suspende.append(poc)
                return
            }
            
            let view = StoreItemPOCView(
                searchTerm: "",
                poc: .init(
                    id: poc.id,
                    upc: poc.upc,
                    name: poc.name,
                    brand: poc.brand,
                    model: poc.model,
                    price: poc.pricea,
                    avatar: poc.avatar,
                    units: nil,
                    reqSeries: poc.reqSeries
                )
            ) { update, deleted in
                
                if self.productTranferMode {
                    print("productTranferMode 🟢 006")
                    if !self.selectedProductIds.contains(poc.id) {
                        print("🟡 add")
                        self.selectedProductIds.append(poc.id)
                    }
                    else {
                        print("🟡 remove")
                        var _selectedProductIds: [UUID] = []
                        
                        self.selectedProductIds.forEach { id in
                            if id == poc.id {
                                return
                            }
                            _selectedProductIds.append(id)
                        }
                        
                        self.selectedProductIds = _selectedProductIds
                        
                    }
                    return
                }
                
                let view = ManagePOC(
                    leveltype: CustProductType.all,
                    levelid: nil,
                    levelName: "",
                    pocid: poc.id,
                    titleText: "",
                    quickView: false
                ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                    
                    update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                    
                } deleted: {
                    deleted()
                }
                
                addToDom(view)
            }.border(
                width: BorderWidthType.thick,
                style: self.$selectedProductIds.map{ $0.contains(poc.id) ? .solid : .none },
                color: .lightBlue
            )
            
            self.pocRowRefrence[poc.id] = view
            
            self.productsView.appendChild(view)
            
        }
        
        suspende.forEach { poc in
            
            let view = StoreItemPOCView(
                searchTerm: "",
                poc: .init(
                    id: poc.id,
                    upc: poc.upc,
                    name: poc.name,
                    brand: poc.brand,
                    model: poc.model,
                    price: poc.pricea,
                    avatar: poc.avatar,
                    units: nil,
                    reqSeries: poc.reqSeries
                )
            ) { update, deleted in
                
                if self.productTranferMode {
                    print("productTranferMode 🟢 006")
                    if !self.selectedProductIds.contains(poc.id) {
                        print("🟡 add")
                        self.selectedProductIds.append(poc.id)
                    }
                    else {
                        print("🟡 remove")
                        var _selectedProductIds: [UUID] = []
                        
                        self.selectedProductIds.forEach { id in
                            if id == poc.id {
                                return
                            }
                            _selectedProductIds.append(id)
                        }
                        
                        self.selectedProductIds = _selectedProductIds
                        
                    }
                    return
                }
                
                let view = ManagePOC(
                    leveltype: CustProductType.all,
                    levelid: nil,
                    levelName: "",
                    pocid: poc.id,
                    titleText: "",
                    quickView: false
                ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                    
                    update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                    
                } deleted: {
                    deleted()
                }
                
                addToDom(view)
            }.border(
                width: BorderWidthType.thick,
                style: self.$selectedProductIds.map{ $0.contains(poc.id) ? .solid : .none },
                color: .lightBlue
            )
                .opacity(0.5)
            
            self.pocRowRefrence[poc.id] = view
            
            self.productsView.appendChild(view)
            
        }
    }
    
    func loadProductTransferView(){
        addToDom(ProductTransferView())
        
    }
    
}

extension ProductManagerView {
    enum LevelView: String {
        case department
        
        case category
        
        case line
        
        case lineSelected
        
    }
}
