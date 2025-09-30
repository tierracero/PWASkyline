//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+JobPostView+AddPsicometricsView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles.JobPostView {
    
    class AddPsicometricsView: Div {

        override class var name: String { "div" }

        private var callback: (
            _ item: PsychometricsTestQuick
        ) ->  Void

        init(
            callback: @escaping  (
                _ item: PsychometricsTestQuick
            ) ->  Void
        ) {
            self.callback = callback
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var items: [PsychometricsTestQuick] = []

        @State var term: String = ""
        
        lazy var termField = InputText(self.$term)
            .custom("width","calc(100% - 24px)")
            .placeholder("Ultima Modificación")
            .class(.textFiledBlackDark)
            .height(31.px)

        @DOM override var body: DOM.Content {
            
            Div{
                
                /*

                Header

                */
                Div {
                    
                    Img()
                        .closeButton(.uiView3)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Selecciona Requisito")
                        .color(.lightBlueText)
                }

                Div().class(.clear).marginBottom(7.px)
                
                Span("Buscar Prueba").color(.lightGray)

                Div().class(.clear).marginBottom(3.px)

                self.termField

                Div().class(.clear).marginBottom(7.px)

                Div{

                    Table().noResult(label: "Inicie busqueda de pruebas a relacionar")

                    Div{
                        ForEach(self.$items) { item in
                            Div{

                                Div {
                                    
                                    Div{
                                        Span(item.type.description)
                                        .float(.right)
                                        Span(item.type.name)
                                    }

                                    Div().height(3.px).clear(.both)

                                    Div(item.name)
                                    .fontSize(22.px)

                                    Div().height(3.px).clear(.both)

                                    Div(item.description)
                                    .fontSize(16.px)
                                }
                                .custom("width", "calc(100% - 35px)")
                                .float(.left)

                                Div {
                                    Table{
                                        Tr{
                                            Td{

                                                Img()
                                                    .src("/skyline/media/cross.png")
                                                    .marginRight(7.px)
                                                    .cursor(.pointer)
                                                    .float(.right)
                                                    .width(24.px)
                                                    .onClick{ _, event in
                                                        /*

                                                        var requirements: [JobPostRequierments] = []

                                                        self.requirements.forEach { citem in
                                                            if citem == item  {
                                                                return 
                                                            }
                                                            requirements.append(citem)
                                                        }

                                                        self.requirements = requirements
                                                        
                                                        */

                                                        
                                                        event.stopPropagation()
                                                    }
                
                                            }
                                            .verticalAlign(.middle)
                                            .align(.center)

                                        }
                                    }
                                    .height(100.percent)
                                    .width(100.percent)
                                }
                                .width(35.px)
                                .float(.left)

                                Div().clear(.both)
                                
                            }
                            .class(.uibtnLarge)
                            .width(90.percent)
                            .marginTop(7.px)
                            .onClick {
                                //self.addJobRequirements(item)
                            }
                        }
                    }
                    .margin(all: 7.px)
                }
                .class(.roundDarkBlue)
                .height(300.px)

                Div().class(.clear).marginBottom(7.px)
                
                Div{
                    
                    Div("Agregar Requisito")
                        .class(.uibtnLarge)
                        .onClick{
                            self.addItem()
                        }
                }
                .align(.center)
            }
            .backgroundColor(.grayBlack)
            .custom("left", "calc(50% - 374px)")
            .custom("top", "calc(50% - 200px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(700.px)
            .color(.white)
            
        }
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            top(0.px)
            left(0.px)
            
        }
        
        override func didAddToDOM() {
            
        }

        func addItem(){

            let searchTerm = term.purgeSpaces 

            if searchTerm.isEmpty {
                return
            }


            /*
            /// [JobRolsQuick]
            searchJobRols(term: searchTerm) { searchedTerm, items in
            }
            */
        }

    //
    }
}
