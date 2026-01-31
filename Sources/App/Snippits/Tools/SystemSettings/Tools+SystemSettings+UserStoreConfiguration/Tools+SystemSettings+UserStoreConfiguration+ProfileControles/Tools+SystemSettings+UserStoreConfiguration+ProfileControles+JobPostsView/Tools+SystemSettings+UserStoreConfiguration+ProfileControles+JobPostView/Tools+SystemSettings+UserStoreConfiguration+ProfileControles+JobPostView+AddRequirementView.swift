//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+JobPostView+AddRequirementView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles.JobPostView {
    
    class AddRequirementView: Div {

        override class var name: String { "div" }

        private var callback: (
            _ item: JobPostRequierments
        ) ->  Void

        init(
            requirement: JobPostRequierments?,
            callback: @escaping  (
                _ item: JobPostRequierments
            ) ->  Void
        ) {
            self.callback = callback
            super.init()
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        @State var valueListener = ""

        /// JobPostRequierments
        /// age, sex, educationalLevel, expirience
        @State var requiermentHelper: JobPostRequiermentsHelper? = nil
        @State var requiermentListener = ""
        /// JobPostRequierments
         lazy var requiermentSelect = Select(self.$requiermentListener)
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        /// JobPostAgeRequierments
        /// age, sex, educationalLevel, expirience
        @State var jobPostAgeRequiermentsHelper: JobPostAgeRequiermentsHelper? = nil
        @State var jobPostAgeRequiermentsListener = ""
        /// JobPostAgeRequierments
        lazy var jobPostAgeRequiermentsSelect = Select(self.$jobPostAgeRequiermentsListener)
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        /// Genders
        /// male, female
        @State var jobPostGenderRequiermentsHelper: Genders? = nil
        @State var jobPostGenderRequiermentsListener = ""
        lazy var jobPostGenderRequiermentsSelect = Select(self.$jobPostGenderRequiermentsListener)
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        /// JobPostEducationalLevelRequierments
        /// notRequired, elementrie, juniorHigh, highSchool, bachelor, trade, technician, collage, postgraduate, doctorate
        @State var jobPostEducationRequiermentsHelper: JobPostEducationalLevelRequiermentsHelper? = nil
        @State var jobPostEducationRequiermentsListener = ""
        lazy var jobPostEducationRequiermentsSelect = Select(self.$jobPostEducationRequiermentsListener)
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        /// JobPostExpirienceRequierments
        /// notRequired, years
        @State var jobPostExpirienceRequiermentsHelper: JobPostExpirienceRequiermentsHelper? = nil
        @State var jobPostExpirienceRequiermentsListener = ""
        lazy var jobPostExpirienceRequiermentsSelect = Select(self.$jobPostExpirienceRequiermentsListener)
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
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

                /*

                Selecciona tipo de requerimiento

                */
                Div {

                    Span("Selecciona tipo de requerimiento")

                    Div().class(.clear).marginBottom(3.px)

                    self.requiermentSelect

                    Div().class(.clear).marginBottom(7.px)

                }

                /*

                Edad Requerida

                */
                Div {
                    Span("Edad Requerida")

                    Div().class(.clear).marginBottom(3.px)
                    Div{
                        self.jobPostAgeRequiermentsSelect
                    }
                    .width(self.$jobPostAgeRequiermentsHelper.map{ ($0?.requiersValue ?? false) ? 50.percent : 100.percent })
                    .float(.left)
                    Div {  
                        InputText(self.$valueListener).custom("width","calc(100% - 7px)")
                        .class(.textFiledBlackDark)
                        .placeholder("16 - 32")
                        .textAlign(.right)
                        .height(31.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    .hidden(self.$jobPostAgeRequiermentsHelper.map{ !($0?.requiersValue ?? false) })
                    Div().class(.clear).marginBottom(7.px)
                }
                .hidden(self.$requiermentHelper.map{ $0 != .age })
                
                /*

                Sexo Requerido

                */
                Div {

                    Span("Sexo Requerido")

                    Div().class(.clear).marginBottom(3.px)

                    Div{
                        self.jobPostGenderRequiermentsSelect
                    }
                    .width(100.percent)

                    Div().class(.clear).marginBottom(7.px)
                    
                }
                .hidden(self.$requiermentHelper.map{ $0 != .sex })

                /*

                Educacion Requerida

                */
                Div {
                    Span("Educacion Requerida")

                    Div().class(.clear).marginBottom(3.px)
                    Div{
                        self.jobPostEducationRequiermentsSelect
                    }
                    .width(self.$jobPostEducationRequiermentsHelper.map{ ($0?.requiersValue ?? false) ? 50.percent : 100.percent })
                    .float(.left)
                    Div {  
                        InputText(self.$valueListener).custom("width","calc(100% - 7px)")
                        .class(.textFiledBlackDark)
                        .placeholder("Nombre de especialidad o carrera tecníca")
                        .textAlign(.right)
                        .height(31.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    .hidden(self.$jobPostEducationRequiermentsHelper.map{ !($0?.requiersValue ?? false) })
                    Div().class(.clear).marginBottom(7.px)
                }
                .hidden(self.$requiermentHelper.map{ $0 != .educationalLevel })

                /*

                Expericia Requerida

                */
                Div {
                    Span("Expericia Requerida")

                    Div().class(.clear).marginBottom(3.px)
                    Div{
                        self.jobPostExpirienceRequiermentsSelect
                    }
                    .width(self.$jobPostExpirienceRequiermentsHelper.map{ ($0?.requiersValue ?? false) ? 50.percent : 100.percent })
                    .float(.left)
                    Div {  
                        InputText(self.$valueListener).custom("width","calc(100% - 7px)")
                        .class(.textFiledBlackDark)
                        .placeholder("Años de expereincia")
                        .textAlign(.right)
                        .height(31.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    .hidden(self.$jobPostExpirienceRequiermentsHelper.map{ !($0?.requiersValue ?? false) })
                    Div().class(.clear).marginBottom(7.px)
                }
                .hidden(self.$requiermentHelper.map{ $0 != .expirience })

                Div().class(.clear).marginBottom(7.px)
                
                Div{
                    Div("Agregar Requisito")
                        .class(.uibtnLarge)
                        .cursor(.default)
                        .opacity(0.5)


                }
                .hidden(self.$requiermentHelper.map{ $0 != nil })
                .align(.center)

                Div{
                    Div("Agregar Requisito")
                        .class(.uibtnLarge)
                        .onClick{
                            self.addRequirement()
                        }
                }
                .hidden(self.$requiermentHelper.map{ $0 == nil })
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
            
            JobPostRequierments.allCases.forEach { item in
                requiermentSelect.appendChild(Option(item.description).value(item.code.rawValue))
            }

            JobPostAgeRequierments.allCases.forEach { item in
                jobPostAgeRequiermentsSelect.appendChild(Option(item.code.description).value(item.code.rawValue))
            }

            Genders.allCases.forEach { item in
                jobPostGenderRequiermentsSelect.appendChild(Option(item.description).value(item.rawValue))
            }

            JobPostEducationalLevelRequierments.allCases.forEach { item in
                jobPostEducationRequiermentsSelect.appendChild(Option(item.code.description).value(item.code.rawValue))
            }

            JobPostExpirienceRequierments.allCases.forEach { item in
                jobPostExpirienceRequiermentsSelect.appendChild(Option(item.code.description).value(item.code.rawValue))
            }

            $requiermentListener.listen {
                self.requiermentHelper = JobPostRequiermentsHelper(rawValue: $0) 
            }

            $jobPostAgeRequiermentsListener.listen {
                self.jobPostAgeRequiermentsHelper = JobPostAgeRequiermentsHelper(rawValue: $0)
            }
            
            $jobPostGenderRequiermentsListener.listen {
                self.jobPostGenderRequiermentsHelper = Genders(rawValue: $0)
            }

            $jobPostEducationRequiermentsListener.listen {
                self.jobPostEducationRequiermentsHelper = JobPostEducationalLevelRequiermentsHelper(rawValue: $0)
            }
            
            $jobPostExpirienceRequiermentsListener.listen {
                self.jobPostExpirienceRequiermentsHelper = JobPostExpirienceRequiermentsHelper(rawValue: $0)
            }

        }
        
        override func didAddToDOM() {
            
        }

        func addRequirement() {

            guard let requiermentHelper else {
                showError(.requiredField, "Seleccione Requerimineto")
                return
            }

            switch requiermentHelper {
            case .age:
                guard let jobPostAgeRequiermentsHelper else {
                    showError(.requiredField, "Seleccione Edad Reqeurida Valida")
                    return
                }

                if jobPostAgeRequiermentsHelper.requiersValue {
                    if valueListener.isEmpty {
                        showError(.requiredField, "Ingrese una Edad Valida")
                        return
                    }
                }

                switch jobPostAgeRequiermentsHelper {    
                case .notRequired:
                    addRequirementAction(.age(.notRequired))
                case .range:
                    addRequirementAction(.age(.range(valueListener)))
                }

            case .educationalLevel:

                guard let jobPostEducationRequiermentsHelper else {
                    showError(.requiredField, "Seleccione Edad Reqeurida Valida")
                    return
                }

                if jobPostEducationRequiermentsHelper.requiersValue {
                    if valueListener.isEmpty {
                        showError(.requiredField, "Ingrese una Edad Valida")
                        return
                    }
                }

                switch jobPostEducationRequiermentsHelper {
                case .notRequired:
                    addRequirementAction(.educationalLevel(.notRequired))
                case .elementrie:
                    addRequirementAction(.educationalLevel(.elementrie))
                case .juniorHigh:
                    addRequirementAction(.educationalLevel(.juniorHigh))
                case .highSchool:
                    addRequirementAction(.educationalLevel(.highSchool))
                case .bachelor:
                    addRequirementAction(.educationalLevel(.bachelor(valueListener)))
                case .trade:
                    addRequirementAction(.educationalLevel(.trade(valueListener)))
                case .technician:
                    addRequirementAction(.educationalLevel(.technician(valueListener)))
                case .collage:
                    addRequirementAction(.educationalLevel(.collage(valueListener)))
                case .postgraduate:
                    addRequirementAction(.educationalLevel(.postgraduate(valueListener)))
                case .doctorate:
                    addRequirementAction(.educationalLevel(.doctorate(valueListener)))
                }
            case .expirience:
            
                guard let jobPostExpirienceRequiermentsHelper else {
                    showError(.requiredField, "Seleccione Edad Reqeurida Valida")
                    return
                }

                if jobPostExpirienceRequiermentsHelper.requiersValue {
                    if valueListener.isEmpty {
                        showError(.requiredField, "Ingrese una Edad Valida")
                        return
                    }
                }

                switch jobPostExpirienceRequiermentsHelper {
                case .notRequired:
                    addRequirementAction(.expirience(.notRequired))
                case .years:
                    addRequirementAction(.expirience(.years(valueListener)))
                }

            case .sex:

                guard let jobPostGenderRequiermentsHelper else {
                    showError(.requiredField, "Seleccione Sexo Valido")
                    return
                }
                
                addRequirementAction(.sex(jobPostGenderRequiermentsHelper))

            }

        }

        func addRequirementAction(_ item: JobPostRequierments) {
            callback(item)
            self.remove()
        }
        
    }
}
