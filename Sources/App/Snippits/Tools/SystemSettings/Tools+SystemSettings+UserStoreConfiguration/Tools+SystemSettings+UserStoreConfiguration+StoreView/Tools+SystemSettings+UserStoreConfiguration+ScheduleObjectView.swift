//
//  Tools+SystemSettings+UserStoreConfiguration+StoreDetailView.swift
//
//
//  Created by Victor Cantu on 6/8/24.
//

import Foundation 
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class ScheduleObjectView: Div {

        override class var name: String { "div" }

        let day: Weekdays

        @State var workDay: Bool

        /// followed, broken
        @State var type: CustUserProfileScheduleDayTypes

        /// followed, broken
        @State var operationTypeListener: String

        @State var start: String

        @State var lucheStart: String

        @State var lucheEnd: String

        @State var end: String

        init(
            day: Weekdays,
            schedule: ConfigStoreScheduleObject
        ) {
            self.day = day
            self.workDay = schedule.workDay
            self.type = schedule.type
            self.operationTypeListener = schedule.type.rawValue
            self.start = schedule.start.toString
            self.lucheStart = schedule.lucheStart.toString
            self.lucheEnd = schedule.lucheEnd.toString
            self.end = schedule.end.toString
        }

        lazy var operationTypeSelect = Select(self.$operationTypeListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var startField = InputText(self.$start)
        .placeholder("Iniico de jornada 8:00")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var lucheStartField = InputText(self.$lucheStart)
        .placeholder("Iniico de jornada 8:00")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var lucheEndField = InputText(self.$lucheEnd)
        .placeholder("Iniico de receso 8:00")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var endField = InputText(self.$end)
        .placeholder("Iniico de jornada 8:00")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        required init() {
          fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            
            Div().clear(.both).height(3.px)

            Div{
                H2(self.day.documentableName)
                .float(.left)

                Div{
                    InputCheckbox().toggle(self.$workDay)
                    .marginRight(7.px)
                }
                .float(.right)

            }
            
            Div().clear(.both).height(3.px)

            // Tipo de horario
            Div{

                Div{

                    Div("Tipo de Horario")
                    .class(.oneLineText)

                }
                .width(50.percent)
                .float(.left)

                Div{
                    
                    Div().clear(.both).height(3.px)

                }
                .width(50.percent)
                .float(.left)

                Div().clear(.both)

            }
            .marginBottom(7.px)

            // Tipo de horario
            Div{

                Div{

                    Div("inicio de Operaciónes")
                    .class(.oneLineText)
                    
                    Div().clear(.both).height(3.px)

                    self.startField

                }
                .width(50.percent)
                .float(.left)

                Div{

                    Div("final de operaciónes")
                    .class(.oneLineText)
                    
                    Div().clear(.both).height(3.px)

                    self.endField
                    
                }
                .width(50.percent)
                .float(.left)

                Div().clear(.both)

            }
            .marginBottom(7.px)

            // Tipo de horario
            Div{

                Div{

                    Div("inicio de Comida")
                    .class(.oneLineText)
                    
                    Div().clear(.both).height(3.px)

                    self.lucheStartField

                }
                .width(50.percent)
                .float(.left)

                Div{

                    Div("final de Comida")
                    .class(.oneLineText)
                    
                    Div().clear(.both).height(3.px)

                    self.lucheEndField
                    
                }
                .width(50.percent)
                .float(.left)

                Div().clear(.both)

            }
            .marginBottom(7.px)
            .hidden(self.$type.map{ $0 == .followed })

        }

        override func buildUI() {
            super.buildUI()
            self.class(.roundDarkBlue)
            
            $workDay.listen {
                if $0 {
                    self.opacity(1.0)
                }else {
                    self.opacity(0.5)
                }
            }

            if workDay {
                self.opacity(1.0)
            }else {
                self.opacity(0.5)
            }



            CustUserProfileScheduleDayTypes.allCases.forEach { item in
                operationTypeSelect.appendChild(
                    Option(item.description)
                    .value(item.rawValue)
                )
            }

            operationTypeListener = type.rawValue

            $operationTypeListener.listen {
                
                guard let value =  CustUserProfileScheduleDayTypes(rawValue: $0) else {
                    return
                }

                self.type = value
            }

            

        }

        func saveStore() {



        }
    }
}
