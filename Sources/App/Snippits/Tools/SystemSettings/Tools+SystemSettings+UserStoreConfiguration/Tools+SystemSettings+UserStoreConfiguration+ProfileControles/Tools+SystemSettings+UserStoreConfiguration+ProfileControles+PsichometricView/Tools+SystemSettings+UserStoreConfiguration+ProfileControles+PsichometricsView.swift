//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+PsichometricsView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class PsichometricsView: Div {

        override class var name: String { "div" }
        
        @State var items: [PsychometricsTestQuick]

        init(
            items: [PsychometricsTestQuick]
        ) {
            self.items = items
        
            super.init()
            
        }

        required init() {
          fatalError("init() has not been implemented")
        }
            
        @State var selectedId: UUID? = nil

        lazy var itemsContainer = Div()
            
        @DOM override var body: DOM.Content {

            Div{

                H2("Lista de Pruebas")
                .color(.white)

                Div().clear(.both).height(7.px)

                Div {

                    Table().noResult(label: "No hay puestos de trabajo", button: "Agregar")  {
                        self.createNewItem()
                    }
                    .hidden(self.$items.map{ !$0.isEmpty })

                    Div {

                        ForEach(self.$items){ item in

                            Div(item.name).class(.uibtnLarge)
                                .border(width: .medium, style: self.$selectedId.map{ ($0 != item.id) ? .none : .solid }, color: .lightBlue )
                                .width(90.percent)
                                .marginTop(7.px)
                                .onClick {
                                    self.loadItem(item)
                                }

                        }
                    }
                    .hidden(self.$items.map{ $0.isEmpty })

                }
                .custom("height", "calc(100% - 105px)")
                .class(.roundDarkBlue)
                .padding(all: 7.px)
                .overflow(.auto)

                Div {
                    Div("+ Agregar Prueba")
                    .custom("width","calc(100% - 12px)")
                    .class(.uibtnLargeOrange)
                    .align(.center)
                    .onClick {
                        self.createNewItem()
                    }
                }

            }
            .height(100.percent)
            .width(30.percent)
            .float(.left)

            Div{
                
                self.itemsContainer
                .custom("height", "calc(100% - 14px)")
                .padding(all: 7.px)
                .overflow(.auto)

            }
            .height(100.percent)
            .width(70.percent)
            .float(.left)
            
        }

        override func buildUI() {
            super.buildUI()
            
            height(100.percent)
            width(100.percent)
            
        }

        func createNewItem() {

            let view = PsichometricView(test: nil) { action in
                self.proccessAction(action)
            }
            
            itemsContainer.innerHTML = ""

            itemsContainer.appendChild(view)

        }

        func loadItem(_ item: PsychometricsTestQuick) {

            loadingView(show: true)

            API.custAPIV1.getPsychometricsTest(testId: item.id) { resp in

                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError )
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                    return
                }

                let view = PsichometricView(test: payload) { action in
                    self.proccessAction(action)
                }   
            
                self.itemsContainer.innerHTML = ""

                self.itemsContainer.appendChild(view)

            }

        }
        
        func proccessAction(_ action: PsichometricViewCallbackType) {

            switch action {
            case .create(let item):

                self.items.append(item)
                
                self.loadItem(item)

            case .update(let item):
                
                var items: [PsychometricsTestQuick] = []

                self.items.forEach  { currentItem in
                    if currentItem.id == item.id {
                        items.append(item)
                        return
                    }
                    items.append(currentItem)
                }
                
                self.items = items
                
            }
        }

    }
}