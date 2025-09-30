//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+JobPostView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class JobPostView: Div {

        override class var name: String { "div" }
    
        @State var notes: [CustGeneralNotesQuick]

        private var callback: (
            _ action: CallbackAcction
        ) ->  Void

        init(
            jobPost: JobPostItem?,
            notes: [CustGeneralNotesQuick],
            callback: @escaping  (
                _ action: CallbackAcction
            ) ->  Void
        ) {
            self.notes = notes
            self.callback = callback
            super.init()
            self.loadJob(jobPost)
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        @State var id: UUID? = nil

        @State var createdAt: Int64? = nil
        
        @State var modifiedAt: Int64? = nil
        
        @State var storeId: UUID? = nil
        
        @State var workedBy: UUID? = nil
        
        /// administrative, operational
        @State var type: JobPostType? = nil
        
        /// easy, medium, hard, specialty
        @State var psychometricsLevel: PsychometricLevel? = nil
        
        @State var psychometricsTest: [PsychometricsTestQuick] = []
        
        @State var primaryTasks: [CustJobTaskQuick] = []
        
        @State var secondaryTasks: [CustJobTaskQuick] = []
        
        @State var rules: [CustDocumentationBookManagerQuick] = []
        
        @State var name: String = ""
        
        @State var descr: String = ""
        
        /// [JobPostRequierments]
        /// age, sex, educationalLevel, expirience
        @State var requirements: [JobPostRequierments] = []
        
        @State var available: Bool = false

        /*
        
        MARK: Form Inputs
        
        */
        lazy var createdAtField = InputText(self.$createdAt.map{

            guard let uts = $0 else {
                return ""
            }

            return getDate(uts).formatedLong

        })
            .placeholder("Fecha de Creación")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        lazy var modifiedAtField = InputText(self.$modifiedAt.map{

            guard let uts = $0 else {
                return "N/A"
            }

            return getDate(uts).formatedLong

        })
            .placeholder("Ultima Modificación")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)

         lazy var storeSelect = Select()
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onChange { event, select in
                self.storeId = UUID(uuidString: select.value)
            }

        /// JobPostType
        /// administrative, operational
         lazy var typeSelect = Select()
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onChange { event, select in
                self.type = JobPostType(rawValue: select.value)
            }

        /// PsychometricLevel
        /// easy, medium, hard, specialty
         lazy var psychometricsLevelSelect = Select()
            .body{
                Option("Seleccione Opcion")
                    .value("")
            }
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onChange { event, select in
                self.psychometricsLevel = PsychometricLevel(rawValue: select.value)
            }

        lazy var nameField = InputText(self.$name)
            .placeholder("Nombre del Puesto")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        lazy var descriptionField = InputText(self.$descr)
            .placeholder("Nombre del Puesto")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)


/*
       
        @State var psychometricsTest: [PsychometricsTestQuick] = []
        
        @State var primaryTasks: [CustJobTaskQuick] = []
        
        @State var secondaryTasks: [CustJobTaskQuick] = []
        
        @State var rules: [CustDocumentationBookManagerQuick] = []
        
        @State var name: String = ""
        
        @State var descr: String = ""
        
        /// [JobPostRequierments]
        /// age, sex, educationalLevel, expirience
        @State var requirements: [JobPostRequierments] = []
        
        @State var available: Bool = false


  */      

        @DOM override var body: DOM.Content {

            H2(self.$id.map{ ($0 == nil) ? "Crear Puesto de Trabajo" : "Editar Puesto de Trabajo" })
                .color(.goldenRod)

            Div().height(7.px).clear(.both)

            Div{

                Div{

                    Span("Puesto creado")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.createdAtField
                    Div().height(7.px).clear(.both)

                }
                .hidden(self.$id.map{ $0 == nil })

                Div{

                    Span("Ultima Modificacion")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.modifiedAtField
                    Div().height(7.px).clear(.both)

                }
                .hidden(self.$id.map{ $0 == nil })

                Span("Nombre del Puesto de Trabajo")
                    .color(.lightGray)
                Div().height(3.px).clear(.both)
                self.nameField
                Div().height(7.px).clear(.both)

                Span("Descripcion del Puesto de Trabajo")
                    .color(.lightGray)
                Div().height(3.px).clear(.both)
                self.descriptionField
                Div().height(7.px).clear(.both)

                Span("Tienda Operacional")
                    .color(.lightGray)
                Div().height(3.px).clear(.both)
                self.storeSelect
                Div().height(7.px).clear(.both)

                Span("Tipo de puesto")
                    .color(.lightGray)
                Div().height(3.px).clear(.both)
                self.typeSelect
                Div().height(7.px).clear(.both)

                Span("Nivel de pruebas psicometricas")
                    .color(.lightGray)
                Div().height(3.px).clear(.both)
                self.psychometricsLevelSelect
                Div().height(7.px).clear(.both)

                /*

                MARK: Job Requirements 

                */

                Div{
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .marginRight(7.px)
                            .cursor(.pointer)
                            .height(24.px)
                            .float(.right)
                            .onClick {
                                self.addJobRequirements(nil)
                            }

                        Span("Requisitos del trabajo")
                        .color(.lightGray)
                    }
                    Div().height(3.px).clear(.both)
                    Div{
                        Div{
                            
                            Table().noResult(label: "No hay requisitos", button: "Agregar")  {
                                self.addJobRequirements(nil)
                            }
                            .hidden(self.$requirements.map{ !$0.isEmpty })

                            ForEach(self.$requirements){ item in
                                Div{

                                    Img()
                                        .src("/skyline/media/cross.png")
                                        .marginRight(7.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .width(24.px)
                                        .onClick{ _, event in

                                            var requirements: [JobPostRequierments] = []

                                            self.requirements.forEach { citem in
                                                if citem == item  {
                                                    return 
                                                }
                                                requirements.append(citem)
                                            }

                                            self.requirements = requirements
                                             event.stopPropagation()
                                        }
                
                                    Span(item.description)
                                }.class(.uibtnLarge)
                                    .width(90.percent)
                                    .marginTop(7.px)
                                    .onClick {
                                        //self.addJobRequirements(item)
                                    }
                            }
                            .hidden(self.$requirements.map{ $0.isEmpty })
                            
                        }
                        .custom("height","calc(100% -  17px)")
                        .padding(all: 7.px)
                        .overflow(.auto)
                    }
                    .class(.roundDarkBlue)
                    .height(200.px)
                    Div().height(7.px).clear(.both)
                }
                
            }
            .height(100.percent)
            .width(50.percent)
            .overflow(.auto)
            .float(.left)

            Div{
                /*
                MARK: PsicometicsTest Container
                */
                Div{

                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .marginRight(7.px)
                            .cursor(.pointer)
                            .height(24.px)
                            .float(.right)

                        Span("Pruebas Psicometricas")
                        .color(.lightGray)
                    }
                    
                    Div().height(3.px).clear(.both)

                    Div{
                        Div{
                           
                            Table().noResult(label: "No hay pruebas psicometricas", button: "Agregar")  {
                                self.addPsicometicTest()
                            }
                            .hidden(self.$psychometricsTest.map{ !$0.isEmpty })
 
                            ForEach(self.$psychometricsTest){ item in
                                Div(item.name).class(.uibtnLarge)
                                    .width(90.percent)
                                    .marginTop(7.px)
                                    .onClick {
                                        self.addPsicometicTest()
                                    }
                            }
                            .hidden(self.$psychometricsTest.map{ $0.isEmpty })
                            
                        }
                        .custom("height","calc(100% -  17px)")
                        .padding(all: 7.px)
                        .overflow(.auto)
                    }
                    .class(.roundDarkBlue)
                    .height(200.px)
                    Div().height(7.px).clear(.both)

                }

                /*
                MARK: Primary Task Container
                */
                Div{

                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .marginRight(7.px)
                            .cursor(.pointer)
                            .height(24.px)
                            .float(.right)

                        Span("Tareas Primarias")
                        .color(.lightGray)
                    }
                    
                    Div().height(3.px).clear(.both)

                    Div{
                        Div{
                           
                            Table().noResult(label: "No hay tareas primarias", button: "Agregar")  {
                                self.addPrimaryTask()
                            }
                            .hidden(self.$primaryTasks.map{ !$0.isEmpty })
 
                            ForEach(self.$primaryTasks){ item in
                                Div(item.name).class(.uibtnLarge)
                                    .width(90.percent)
                                    .marginTop(7.px)
                                    .onClick {
                                        self.addPrimaryTask()
                                    }
                            }
                            .hidden(self.$primaryTasks.map{ $0.isEmpty })
                            
                        }
                        .custom("height","calc(100% -  17px)")
                        .padding(all: 7.px)
                        .overflow(.auto)
                    }
                    .class(.roundDarkBlue)
                    .height(200.px)
                    Div().height(7.px).clear(.both)

                }
                
                /*
                MARK: Secondary Task Container
                */
                Div{

                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .marginRight(7.px)
                            .cursor(.pointer)
                            .height(24.px)
                            .float(.right)

                        Span("Pruebas Psicometricas")
                        .color(.lightGray)
                    }
                    
                    Div().height(3.px).clear(.both)

                    Div{
                        Div{
                           
                            Table().noResult(label: "No hay puestos de trabajo", button: "Agregar")  {
                                self.addSecondaryTask()
                            }
                            .hidden(self.$secondaryTasks.map{ !$0.isEmpty })
 
                            ForEach(self.$secondaryTasks){ item in
                                Div(item.name).class(.uibtnLarge)
                                    .width(90.percent)
                                    .marginTop(7.px)
                                    .onClick {
                                        self.addSecondaryTask()
                                    }
                            }
                            .hidden(self.$secondaryTasks.map{ $0.isEmpty })
                            
                        }
                        .custom("height","calc(100% -  17px)")
                        .padding(all: 7.px)
                        .overflow(.auto)
                    }
                    .class(.roundDarkBlue)
                    .height(200.px)
                    Div().height(7.px).clear(.both)

                }
            }
            .width(50.percent)
            .float(.left)

        }

        override func buildUI() {
            super.buildUI()
            height(100.percent)
            width(100.percent)
            
            stores.forEach { _, store in
                storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
            }

            JobPostType.allCases.forEach { item in
                    typeSelect.appendChild(Option(item.description).value(item.rawValue))
            }

            PsychometricLevel.allCases.forEach { item in
                    psychometricsLevelSelect.appendChild(Option(item.description).value(item.rawValue))
            }

        }
    
        func loadJob(_ jobPost: JobPostItem?) {

            guard let jobPost else {
                return
            }

            id = jobPost.id

            storeId = jobPost.storeId
            
            storeSelect.text = jobPost.storeId.uuidString

            workedBy = jobPost.workedBy
            
            /// JobPostType
            /// administrative, operational
            type = jobPost.type

            typeSelect.text = jobPost.type.rawValue
            
            /// PsychometricLevel
            /// easy, medium, hard, specialty
            psychometricsLevel = jobPost.psychometricsLevel
            
            psychometricsLevelSelect.text = jobPost.psychometricsLevel.rawValue

            /// [UUID]
            psychometricsTest = jobPost.psychometricsTest
            
            /// [UUID]
            primaryTasks = jobPost.primaryTasks
            
            /// [UUID]
            secondaryTasks = jobPost.secondaryTasks
            
            /// [UUID]
            rules  = jobPost.rules
            
            /// String
            name = jobPost.name
            
            /// String
            descr = jobPost.description

            /// [JobPostRequierments]
            /// age, sex, educationalLevel, expirience
            requirements = jobPost.requirements
            
            available = jobPost.available
            
        }

        func addJobRequirements(_ requirement: JobPostRequierments?) {
            let view = AddRequirementView(requirement: requirement) { requirement in
                self.requirements.append(requirement)
            }
            addToDom(view)
        }

        func addPsicometicTest() {

        }

        func addPrimaryTask() {

        }

        func addSecondaryTask() {

        }

    }

    enum CallbackAcction {

        case create(CustJobPostQuick)

        case update(CustJobPostQuick)

    }

}