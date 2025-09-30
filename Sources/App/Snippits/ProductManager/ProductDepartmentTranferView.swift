//
//  ProductDepartmentTranferView.swift
//  
//
//  Created by Victor Cantu on 8/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension ProductManagerView{
    
    class ProductDepartmentTranferView: Div {
        
        override class var name: String { "div" }
        
        ///dep, cat, line, main, all
        let level: CustProductType
        
        let levelId: UUID?
        
        let levelName: String
        
        let pocids: [UUID]
        
        let storeDeps: [CustStoreDepsAPI]
        
        private var callback: ((
        ) -> ())
        
        init(
            level: CustProductType,
            levelId: UUID?,
            levelName: String,
            pocids: [UUID],
            storeDeps: [CustStoreDepsAPI],
            callback: @escaping ((
            ) -> ())
        ) {
            self.level = level
            self.levelId = levelId
            self.levelName = levelName
            self.pocids = pocids
            self.storeDeps = storeDeps
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var targetLevel: CustProductType = .main
        
        var depRefrence: [UUID:String] = [:]
        
        var catRefrence: [UUID:String] = [:]
        
        var lineRefrence: [UUID:String] = [:]
        
        @State var depId: UUID? = nil
        
        @State var depName: String = ""
        
        @State var cats: [CustStoreCats] = []
        
        @State var catId: UUID? = nil
        
        @State var catName: String = ""
        
        @State var lines: [CustStoreLines] = []
        
        @State var lineId: UUID? = nil
        
        @State var lineName: String = ""
        
        @State var depListener = ""
        
        lazy var depSelect = Select(self.$depListener)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(100.percent)
            .fontSize(22.px)
            .height(34.px)
            .onChange { _, select in
                
                
                self.catId = nil
                self.catListener = ""
                self.catName = ""
                self.cats = []
                
                self.lineId = nil
                self.lineListener = ""
                self.lineName = ""
                self.lines = []
                
                guard let id = UUID(uuidString: self.depListener) else {
                    
                    self.targetLevel = .main
                    
                    self.depId = nil
                    self.depName = ""
                    
                    return
                }
                
                self.targetLevel = .dep
                
                self.depId = id
                
                self.depName = self.depRefrence[id] ?? ""
                
                self.loadDepartment(id, self.depName)
            }
        
        @State var selectCatIsHidden = true
        
        @State var catListener = ""
        
        lazy var catSelect = Select(self.$catListener)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(100.percent)
            .fontSize(22.px)
            .height(34.px)
            .onChange { _, select in
                
                self.lineId = nil
                self.lineListener = ""
                self.lineName = ""
                self.lines = []
                
                guard let id = UUID(uuidString: self.catListener) else {
                    
                    self.targetLevel = .dep
                    
                    self.catId = nil
                    self.catListener = ""
                    self.catName = ""
                    
                    return
                }
                
                self.targetLevel = .cat
                
                self.catId = id
                
                self.catName = self.catRefrence[id] ?? ""
                
                self.loadCategorie(id, self.catName)
                
            }
        
        @State var selectLineIsHidden = true
        
        @State var lineListener = ""
        
        lazy var lineSelect = Select(self.$lineListener)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(100.percent)
            .fontSize(22.px)
            .height(34.px)
            .onChange { _, select in
                
                guard let id = UUID(uuidString: self.lineListener) else {
                    
                    self.targetLevel = .cat
                    
                    self.lineId = nil
                    self.lineListener = ""
                    self.lineName = ""
                    
                    return
                }
                
                self.targetLevel = .line
                
                self.lineId = id
                
                self.lineName = self.lineRefrence[id] ?? ""
                
            }
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Tranferir Productos")
                        .color(.lightBlueText)
                        .height(35.px)
                }
                
                Div().clear(.both).height(7.px)
                
                Div{
                    
                    H2("Origen:")
                        .marginRight(7.px)
                        .color(.white)
                        .height(35.px)
                        .float(.left)
                    
                    H2("\(self.level.description) \(self.levelName)")
                        .marginRight(7.px)
                        .color(.goldenRod)
                        .height(35.px)
                        .float(.left)
                }
                
                Div().clear(.both).height(7.px)
                
                Div()
                    .marginRight(7.px)
                    .marginLeft(7.px)
                    .height(0.7.px)
                
                Div().clear(.both).height(7.px)
                
                H2("Seleccione Destino:")
                    .marginRight(7.px)
                    .color(.white)
                    .height(35.px)
                    .float(.left)
                
                Div().clear(.both).height(7.px)
                
                self.depSelect
                
                Div().clear(.both).height(7.px)
                
                self.catSelect
                    .hidden(self.$cats.map { $0.isEmpty })
                Div().clear(.both).height(7.px)
                    .hidden(self.$cats.map { $0.isEmpty })
                
                self.lineSelect
                    .hidden(self.$lines.map { $0.isEmpty })
                Div().clear(.both).height(7.px)
                    .hidden(self.$lines.map { $0.isEmpty })
                
                Div("Transferir Productos")
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(97.percent)
                    .onClick {
                        self.transferProducts()
                    }
                
            }
            .custom("left", "calc(50% - 274px)")
            .custom("top", "calc(50% - 274px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            //.height(535.px)
            .width(500.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            depSelect.appendChild(Option("Seleccione Departamento").value(""))
            
            storeDeps.forEach { dep in
                depRefrence[dep.id] = dep.name
                depSelect.appendChild(Option(dep.name).value(dep.id.uuidString))
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
        }
        
        func loadDepartment(_ depid: UUID,_ depname: String){
            
            loadingView(show: true)
            
            API.v1.storeCats(id: depid, curObjs: [], callback: { resp in
                
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
                
                self.cats = payload.cats
                
                self.catSelect.innerHTML = ""
                
                self.catSelect.appendChild(Option("Seleccione Categoria").value(""))
                
                payload.cats.forEach { cat in
                    self.catRefrence[cat.id] = cat.name
                    self.catSelect.appendChild(Option(cat.name).value(cat.id.uuidString))
                }
                
            })
        }
        
        func loadCategorie(_ catid: UUID,_ catname: String) {
            
            loadingView(show: true)
         
            API.v1.storeLines(id: catid, curObjs: []) { resp in
                
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
                self.lines = payload.lines
                
                self.lineSelect.innerHTML = ""
                
                self.lineSelect.appendChild(Option("Seleccione Linea").value(""))
                
                payload.lines.forEach { line in
                    self.lineRefrence[line.id] = line.name
                    self.lineSelect.appendChild(Option(line.name).value(line.id.uuidString))
                }
                
            }
            
        }
        
        func transferProducts(){
            
            guard let depId else {
                showError(.errorGeneral, "Seleccione Ubicacíon a tranferir")
                return
            }
            
            loadingView(show: true)
            
            API.custPOCV1.productDepartmentTransfer(
                originLevel: level,
                originId: levelId,
                originName: levelName,
                targetLevel: targetLevel,
                depId: depId,
                depName: depName,
                catId: catId,
                catName: catName,
                lineId: lineId,
                lineName: lineName,
                pocids: pocids
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                self.callback()
                
                self.remove()
                
            }
        }
    }
}

