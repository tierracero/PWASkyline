//
// SelectStoreDepartment.swift
//
//
//  Created by Victor Cantu on 26/10/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SelectStoreDepartment: Div {

    override class var name: String { "div" }

    private var createPOC: ((
        _ type: CustProductType,
        _ levelid: UUID?,
        _ titleText: String
    ) -> ())

    init(
        createPOC: @escaping ((
            _ type: CustProductType,
            _  levelid: UUID?,
            _ titleText: String
        ) -> ())
        
    ) {
        self.createPOC = createPOC
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var activeMode: ActiveMode = .selectDep
    
    @State var titleText: String = "Seleccionar Departamento"
    
    @State var selectedDepartmentId: UUID? = nil
    
    @State var selectedDepartment = ""
    
    @State var selectedCategoryId: UUID? = nil
    
    @State var selectedCategory = ""
    
    @State var selectedLineId: UUID? = nil
    
    @State var selectedLine = ""
    
    @State var hasDeps: Bool = false
    
    @State var hasCats: Bool = false
    
    @State var hasLines: Bool = false
    
    lazy var depResultDiv = Div()
        .custom("height","calc(100% - 55px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$hasDeps.map{ !$0 })
    
    lazy var depNoResultDiv = Div{
        Table{
            Tr{
                Td(self.$selectedDepartment.map{ "No hay departementos, registre uno nuevo." })
                    .align(.center)
                    .verticalAlign(.middle)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
        .custom("height","calc(100% - 55px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$hasDeps.map{ $0 })
    
    lazy var catResultDiv = Div()
        .custom("height","calc(100% - 45px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$hasCats.map{ !$0 })
    
    lazy var catNoResultDiv = Div{
        Table{
            Tr{
                Td{
                    Div(self.$selectedDepartment.map{ "No hay categorias registradas para \($0.uppercased()), cree el producto o una categorias nueva." })
                    
                    Div{
                        
                        Div(self.$selectedDepartment.map{ "Crear producto en: \($0.uppercased())" })
                            .class(.uibtnLargeOrange)
                            .onClick{
                                self.createPOC(.dep, self.selectedDepartmentId, self.selectedDepartment)
                                self.remove()
                            }
                    }
                    .align(.center)
                    
                    Div{
                        
                        Div("Crear Nueva Categoria")
                            .class(.uibtnLarge)
                            .onClick{
                                
                                guard let depid = self.selectedDepartmentId else{
                                    showError(.unexpectedResult, "No se cargo id del departamento, refresque el webapp")
                                    return
                                }
                                
                                self.appendChild(
                                    
                                    CreateStoreLevelCategoria(
                                        depid: depid,
                                        depname: self.selectedDepartment,
                                        callback: { id, name in
                                            self.loadLinesInCat(id, name)
                                        }, deleted: {
                                            
                                        }, changeAvatar: { id, url in
                                            
                                        })
                                   )
                            }
                    }
                    .align(.center)
                }
                .align(.center)
                .verticalAlign(.middle)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
        .custom("height","calc(100% - 45px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$hasCats.map{ $0 })
    
    lazy var lineResultDiv = Div()
        .custom("height","calc(100% - 85px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$hasLines.map{ !$0 })
    
    lazy var lineNoResultDiv = Div {
        Table{
            Tr{
                Td{
                    
                    Div{
                        
                        Span(self.$selectedCategory.map{ "No hay lineas registradas para \($0.uppercased()), cree el producto o una linea nueva." })
                        
                        Div( self.$selectedCategory.map{"Crear produto en: \($0.uppercased())"} )
                            .class(.uibtnLargeOrange)
                            .onClick{
                                self.createPOC(.cat, self.selectedCategoryId, "\(self.selectedDepartment) > \(self.selectedCategory)")
                                self.remove()
                            }
                        
                        Div("Crear Nueva Linea")
                            .class(.uibtnLarge)
                            .onClick{
                                
                                guard let catid = self.selectedCategoryId else{
                                    showError(.unexpectedResult, "No se cargo id de la categoria, refresque el webapp")
                                    return
                                }
                                
                                self.appendChild(
                                    
                                    CreateStoreLevelLine(
                                        catid: catid,
                                        catname: self.selectedCategory,
                                        callback: { id, name in
                                            self.selectedLine = name
                                            self.selectedLineId = id
                                        }, deleted: {
                                            //self.remove()
                                        }, changeAvatar: { id, url in
                                            
                                        })
                                  )
                            }
                        
                    }
                    .align(.center)
                    
                    
                }
                .align(.center)
                .verticalAlign(.middle)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
        .custom("height","calc(100% - 85px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$hasLines.map{ $0 })

    @DOM override var body: DOM.Content {
        Div{

            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                  
                Img()
                    .backButton
                    .hidden(self.$activeMode.map{ ($0 == .selectDep) })
                    .float(.left)
                    .onClick {
                        switch self.activeMode{
                        case .selectDep:
                            break
                        case .selectCat:
                            
                            self.titleText = "Seleccionar Departamento"
                            self.activeMode = .selectDep
                            
                            self.selectedDepartmentId = nil
                            self.selectedDepartment = ""
                            
                            self.selectedCategoryId = nil
                            self.selectedCategory = ""
                            
                        case .selectLine:
                            
                            self.titleText = "Seleccionar Categoria"
                            self.activeMode = .selectCat
                            
                            self.selectedCategoryId = nil
                            self.selectedCategory = ""
                            
                        }
                    }
                
                H2( self.$activeMode.map{ ($0 == .selectDep) ? "Buscar Departamento" : "Atras" } )
                    .color(self.$activeMode.map{ ($0 == .selectDep) ? .lightBlueText : .darkOrange })
                    .float(.left)
                
                H2( self.$titleText )
                    .hidden(self.$activeMode.map{ ($0 == .selectDep) } )
                    .maxWidth(70.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.gray)
                    .float(.left)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
            
            Span(self.$activeMode.map {$0.helpText })
                .color(.gray)
            
            Div().class(.clear).marginTop(3.px)

            /// Dep Result Div
            Div{
                
                H2("Seleccionar Departamento").color(.lightBlueText)
                
                Div().class(.clear).marginTop(7.px)
                
                self.depResultDiv
                
                self.depNoResultDiv
                
                Div{
                    Div("Crear Nuevo Departamento")
                        .class(.uibtnLarge)
                        .marginTop(7.px)
                        .onClick{
                            
                            self.appendChild(CreateStoreLevelDepartement { id, name in
                                self.loadCatsInDep(id, name)
                            } deleted: {
                                
                            } changeAvatar: { id, url in
                                
                            })
                            
                        }
                }
                .align(.center)
                
            }
            .hidden(self.$activeMode.map {$0 != .selectDep})
            .custom("height", "calc(100% - 80px)")
            
            /// Cat Result Div
            Div{
                
                H2("Seleccionar Categoria").color(.lightBlueText)
                
                Div().class(.clear).height(7.px)
                
                self.catResultDiv
                
                self.catNoResultDiv
                
                Div{
                    
                    Div(self.$selectedDepartment.map{ "Crear producto en: \($0.uppercased())" })
                        .class(.uibtnLargeOrange)
                        .onClick{
                            self.createPOC(.dep, self.selectedDepartmentId, self.selectedDepartment)
                            self.remove()
                        }
                }
                .align(.center)
                
                Div{
                    
                    Div("Crear Nueva Categoria")
                        .class(.uibtnLarge)
                        .onClick{
                            
                            guard let depid = self.selectedDepartmentId else{
                                showError(.unexpectedResult, "No se cargo id del departamento, refresque el webapp")
                                return
                            }
                            
                            self.appendChild(
                                CreateStoreLevelCategoria(
                                    depid: depid,
                                    depname: self.selectedDepartment
                                ) { id, name in
                                    
                                    self.loadLinesInCat(id, name)
                                } deleted: {
                                    
                                } changeAvatar: { id, url in
                                    
                                })
                        }
                }
                .align(.center)
                
            }
            .hidden(self.$activeMode.map {$0 != .selectCat})
            .custom("height", "calc(100% - 140px)")
            
            /// Line Result Div
            Div{
                //self.$selectedCategory.map{ "\(self.selectedDepartment) > \($0.capitalized)" }
                H2("Seleccionar Linea").color(.lightBlueText)
                
                Div().class(.clear).height(7.px)
                
                self.lineResultDiv
                
                self.lineNoResultDiv
                
                Div{
                    
                    Div(self.$selectedCategory.map{ "Crear producto en: \($0.uppercased())" })
                        .class(.uibtnLargeOrange)
                        .onClick{
                            self.createPOC(.cat, self.selectedCategoryId, "\(self.selectedDepartment) > \(self.selectedCategory)")
                            self.remove()
                        }
                }
                .align(.center)
                
                Div{
                    Div("Crear Nueva Linea")
                        .class(.uibtnLarge)
                        .onClick{
                            
                            guard let catid = self.selectedCategoryId else{
                                showError(.unexpectedResult, "No se cargo id de la categoria, refresque el webapp")
                                return
                            }
                            
                            self.appendChild(
                                CreateStoreLevelLine(
                                    catid: catid,
                                    catname: self.selectedCategory
                                ) { id, name in
                                    self.selectedLine = name
                                    self.selectedLineId = id
                                } deleted: {
                                    
                                } changeAvatar: { id, url in
                                    
                                })
                        }
                }
                .align(.center)
            
            }
            .hidden(self.$activeMode.map {$0 != .selectLine})
            .custom("height", "calc(100% - 100px)")
            
            Div()
                .class(.clear)
                .marginTop(7.px)
            
            
        }
        .custom("top", "calc(7.5% - 24px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height( 85.percent)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        loadDeps()

    }
    
    override func didAddToDOM() {

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
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let deps = resp.data?.deps else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            storeDeps = deps
            
            self.loadDepsAction()
        }
        
    }
    
    func loadDepsAction() {
        
        self.titleText = "Buscar productos"
        
        activeMode = .selectDep
        
        if storeDeps.isEmpty {
            hasDeps = false
        }
        else {
            hasDeps = true
        }
        
        self.depResultDiv.innerHTML = ""
        
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
            ) { isEdited, id, name in
                if isEdited {
                    var cc = 0
                    storeDeps.forEach { item in
                        if item.id == id  {
                            storeDeps[cc].name = name
                        }
                        cc += 1
                    }
                }
                else {
                    self.loadCatsInDep(dep.id, dep.name)
                }
            }
            
            self.depResultDiv.appendChild(view)
        }
    }
    
    func loadCatsInDep(_ depid: UUID,_ depname: String) {
        
        loadingView(show: true)
        
        API.v1.storeCats(id: depid, curObjs: []) { resp in
            
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
                showError(.generalError, resp.msg)
                return
            }
            
            if payload.cats.isEmpty {
                self.hasCats = false
            }
            else {
                self.hasCats = true
            }
            
            self.activeMode = .selectCat
            
            self.titleText = "Seleccionar Departamento"
            
            self.selectedDepartment = depname
            
            self.selectedDepartmentId = depid
            
            self.catResultDiv.innerHTML = ""
            
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
                ) { isEdited, id, name in
                    if !isEdited {
                        self.loadLinesInCat(cat.id, cat.name)
                    }
                    
                }
                
                self.catResultDiv.appendChild(view)
                
            }
            
        }
    }
    
    func loadLinesInCat(_ catid: UUID,_ catname: String) {
        
        loadingView(show: true)
        
        API.v1.storeLines(id: catid, curObjs: []) { resp in
            
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
                showError(.generalError, resp.msg)
                return
            }
            
            if data.lines.isEmpty {
                self.hasLines = false
            }
            else {
                self.hasLines = true
            }
            
            self.activeMode = .selectLine
            
            self.titleText = "Seleccionar Categoria"
            
            self.selectedCategory = catname
            
            self.selectedCategoryId = catid
            
            self.lineResultDiv.innerHTML = ""
            
            
            data.lines.forEach { line in
                
                self.lineResultDiv.appendChild(
                    Div{
                        Span("Crear en: ")
                        Span(line.name).color(.orange)
                    }
                    .backgroundColor(.grayBlackDark)
                    .borderRadius(all: 12)
                    .class(.oneLineText)
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .cursor(.pointer)
                    .fontSize(32.px)
                    .color(.white)
                    .onClick {
                        self.createPOC(.line, line.id, "\(self.selectedDepartment) > \(self.selectedCategory) > \(line.name)")
                        self.remove()
                    }
                )
            }
            
        }
    }

}

extension SelectStoreDepartment {


    enum ActiveMode: String, Codable {
        case selectDep
        case selectCat
        case selectLine
        
        var titleDescription: String {
            switch self {
            case .selectDep:
                return "Seleccionar Departamento"
            case .selectCat:
                return "Seleccionar Categoria"
            case .selectLine:
                return "Seleccionar Linea"
            }
        }
        
        var helpText: String{
            switch self {
            case .selectDep:
                return "Seleccione el departemento donde va a crear el producto."
            case .selectCat:
                return "Seleccione la categoria donde va a crear el producto."
            case .selectLine:
                return "Seleccione la linea donde va a crear el producto "
            }
        }
        
    }
    
}