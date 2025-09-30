//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+PsichometricView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class PsichometricView: Div {

        override class var name: String { "div" }

        private var callback: (
            _ type: PsichometricViewCallbackType
        ) ->  Void

        init(
            test: API.custAPIV1.GetPsychometricsTestReponse?,
            callback: @escaping  (
                _ type: PsichometricViewCallbackType
            ) ->  Void
        ) {
            self.callback = callback
            super.init()
            self.loadTest(payload: test)
        }

        required init() {
          fatalError("init() has not been implemented")
        }
            
        @State var id: UUID? = nil
        
        @State var createdAt: Int64? = nil
        
        @State var modifiedAt: Int64? = nil
        
        /// language, officeFunction, machine, traite, other
        @State var type: PsychometricType? = nil
        
        /// easy, medium, hard, specialty
        @State var level: PsychometricLevel? = nil
        
        @State var name: String = ""
        
        @State var descr: String = ""
        
        @State var instruction: String = ""
        
        @State var content: String = ""
        
        /// Sugested JobRol catagery
        @State var jobRole: JobRolsQuick? = nil

        @State var jobRoles: [JobRolsQuick] = []

        @State var questions: [QuestionObjectItem] = []

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

        @State var typeListener = ""

        /// PsychometricType
        lazy var typeSelect = Select(self.$typeListener)
            .body{
                Option("Seleccione Opcion")
                .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        @State var levelListener = ""

        /// PsychometricLevel
        lazy var levelSelect = Select(self.$levelListener)
            .body{
                Option("Seleccione Opcion")
                .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            
        lazy var nameField = InputText(self.$name)
            .custom("width","calc(100% - 24px)")
            .placeholder("Nombre de la prueba")
            .class(.textFiledBlackDark)
            .height(31.px)

        lazy var descriptionField = InputText(self.$descr)
            .custom("width","calc(100% - 24px)")
            .placeholder("Motivo o razon de la prueba")
            .class(.textFiledBlackDark)
            .height(31.px)

        lazy var instructionField = TextArea(self.$instruction)
            .custom("width","calc(100% - 24px)")
            .placeholder("Que va hacer el usario para resolver la sigunete prueba")
            .class(.textFiledBlackDark)
            .height(70.px)

        lazy var contentField = TextArea(self.$content)
            .custom("width","calc(100% - 24px)")
            .placeholder("contenido de la prueba")
            .class(.textFiledBlackDark)
            .height(70.px)

        @State var jobRoleIdListener = ""

        lazy var jobRoleIdField = InputText(self.$jobRoleIdListener)
            .custom("width","calc(100% - 24px)")
            .placeholder("Contador, Mecanico, Maestro, Ventas...")
            .class(.textFiledBlackDark)
            .hidden(self.$jobRole.map{ !($0 == nil) })
            .height(31.px)
            .onFocus { inputText in
                self.jobRoles.removeAll()
            }
            .onBlur {
                Dispatch.asyncAfter(1) {
                    self.jobRoles.removeAll()
                }
            }

        lazy var jobRoleSelectedItem = Div {
            
            Div{
                Div(self.$jobRole.map{ $0?.name ?? "" })
                .class(.oneLineText)
                .marginTop(4.px)
            }
            .custom("width", "calc(100% - 35px)")
            .float(.left)

            Div{

                Img()
                        .src("/skyline/media/cross.png")
                        .marginTop(8.px)
                        .cursor(.pointer)
                        .width(16.px)
                        .onClick{
                            self.jobRole = nil
                            Dispatch.asyncAfter(0.1) {
                                self.jobRoleIdField.select()
                            }
                        }

            }
            .align(.center)
            .width(35.px)
            .float(.left)

            Div().clear(.both)
        }
        .hidden(self.$jobRole.map{ ($0 == nil) })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        
        lazy var jobRoleIdResultContainer = Div{
            Div {
                ForEach(self.$jobRoles) { jobRole in
                    Div(jobRole.name)
                    .custom("width", "calc(100% - 14px)")
                    .class(.uibtnLarge)
                    .onClick {
                        self.jobRole = jobRole
                        self.jobRoles.removeAll()
                        self.jobRoleIdListener = ""
                    }
                }
            }
            .margin(all: 7.px)
        }
        .backgroundColor(.transparentBlack)
        .class(.roundDarkBlue)
        .position(.absolute)
        .hidden(self.$jobRoles.map{ $0.isEmpty })

        @DOM override var body: DOM.Content {
            
            H2(self.$id.map{ ($0 == nil) ? "Crear Puebra" : "Modificar Prueba" })
                .color(.lightBlueText)

            Div().class(.clear).marginBottom(7.px)
            
            Div{

                Div {
                    
                    Div{

                        Span("Puesto creado")
                            .color(.lightGray)
                        Div().height(3.px).clear(.both)
                        self.createdAtField
                        Div().height(7.px).clear(.both)

                    }
                    .hidden(self.$id.map{ $0 == nil })

                    Span("Tipo de prueba")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.typeSelect
                    Div().height(7.px).clear(.both)
                    
                    Span("Nivel de Dificultad")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.levelSelect
                    Div().height(7.px).clear(.both)

                    Span("Nombre de la prueba")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.nameField
                    Div().height(7.px).clear(.both)

                    Span("Categoria de la prueba")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.jobRoleIdField
                    self.jobRoleSelectedItem
                    Div().height(7.px).clear(.both)

                    self.jobRoleIdResultContainer

                }
                //.height(100.percent) https://intratc.co/api/cust/v1/searchJobRols?token=17530180141W4nwZxDtRvV7u7XmsaCIRcJOHISmuNUN4fy63rLtJJoFONL&user=vcantu01@tierracero.com&key=XBuHxkAYZHBUwnzysyXhu4pj8jY8cCVX3bwXqXv0dgg%3d&mid=%2boPlYEoYnKf8tbQ13pA8zQ%3d%3d&term=ventas
                .width(50.percent)
                .overflow(.auto)
                .float(.left)

                Div {
                    
                    Div{

                        Span("Ultima Modificacion")
                            .color(.lightGray)
                        Div().height(3.px).clear(.both)
                        self.modifiedAtField
                        Div().height(7.px).clear(.both)

                    }
                    .hidden(self.$id.map{ $0 == nil })

                    Span("Descripción de la prueba")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.descriptionField
                    Div().height(7.px).clear(.both)

                    Span("Instrcciónes de la prueba")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.instructionField
                    Div().height(7.px).clear(.both)

                    Span("Contenido de la prueba")
                        .color(.lightGray)
                    Div().height(3.px).clear(.both)
                    self.contentField
                    Div().height(7.px).clear(.both)

                }
                //.height(100.percent)
                .width(50.percent)
                .overflow(.auto)
                .float(.left)

                Div().class(.clear).marginBottom(7.px)

                Div{
                    Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .marginTop(7.px)
                                .cursor(.pointer)
                                .height(24.px)
                                .onClick {
                                    self.addQuestion()
                                }
                        }
                        .marginRight(7.px)
                        .float(.right)
                    H2("Preguntas de puebas")
                    .color(.white)
                }

                Div().class(.clear).marginBottom(7.px)

                Div{

                    Table().noResult(label: "No existen preguntas que agrerar", button: "Agregar") {
                        self.addQuestion()
                    }
                    .hidden(self.$questions.map{ !$0.isEmpty })
                    .height(200.px)

                    ForEach(self.$questions) { item in
                        
                        QuestionObjectRow(item: item) {
                            
                            let view = QuestionObjectView(
                                itemId: item.itemId,
                                testId: self.id,
                                questionId: item.questionId,
                                question: item.question,
                                answers: item.answers
                            ) { question in

                                var questions: [QuestionObjectItem] = []

                                var hasAdded = false

                                self.questions.forEach {  currentQuestion in

                                    if currentQuestion.itemId ==  question.itemId {
                                        questions.append(currentQuestion)
                                        hasAdded = true
                                        return
                                    }

                                    questions.append(question)

                                }

                                if !hasAdded {
                                    questions.append(question)
                                }

                                self.questions = questions

                            }

                            addToDom(view)
                            
                        } removeItem: {
                            /*

                            MARK: REMOVE QUESTION
                            
                            */

                            if let questionId = item.questionId {

                                loadingView(show: true)

                                API.custAPIV1.removePsychometricsTestQuestion(
                                    questionId: questionId
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

                                    var questions: [QuestionObjectItem] = []

                                    self.questions.forEach { currentQuestion in

                                        if currentQuestion.itemId == item.itemId {
                                            return
                                        }

                                        questions.append(currentQuestion)
                                        
                                    }

                                    self.questions = questions
                                    
                                }
                            }

                            var questions: [QuestionObjectItem] = []

                            self.questions.forEach { currentQuestion in

                                if currentQuestion.itemId == item.itemId {
                                    return
                                }

                                questions.append(currentQuestion)
                                
                            }

                            self.questions = questions
                        } 

                    }
                    .hidden(self.$questions.map{ $0.isEmpty })

                }
                .margin(all: 7.px)

            }
            .custom("height", "calc(100% - 82px)")
            .overflow(.auto)

            Div {
                Div(self.$id.map{ ($0 == nil) ? "Crear Prueba" : "Guardar Cambios" })
                .class(.uibtnLargeOrange)
                .onClick {

                    if let id = self.id {
                        self.saveTest(id)
                        return
                    }

                    self.createTest()

                }
            }
            .align(.right)

        }
        
        override func buildUI() {
            
            height(100.percent)
            width(100.percent)
            
            PsychometricType.allCases.forEach { item in
                typeSelect.appendChild(Option(item.description).value(item.rawValue))
            }

            PsychometricLevel.allCases.forEach{ item in
                levelSelect.appendChild(Option(item.description).value(item.rawValue))
            }

            $typeListener.listen {  
                self.type = PsychometricType(rawValue: $0)
            }

            $levelListener.listen {
                self.level = PsychometricLevel(rawValue: $0)
            }

            $jobRoleIdListener.listen {
                
                let term = $0.purgeSpaces

                if term.count < 3 {
                    return
                }

                Dispatch.asyncAfter(0.7) {

                    var compare = self.jobRoleIdListener.purgeSpaces

                    guard compare == term else {
                        return
                    }
                    
                    searchJobRols(term: term) { searchedTearm, jobRoles in
                            
                        compare = self.jobRoleIdListener.purgeSpaces

                        guard compare == term else {
                            return
                        }

                        self.jobRoles = jobRoles

                    }
                }
            }
        }
        
        func loadTest(payload: API.custAPIV1.GetPsychometricsTestReponse?) {

            guard let payload else {
                return 
            }

            let test = payload.test
            
            id = test.id
            createdAt = test.createdAt
            modifiedAt = test.modifiedAt

            type = test.type
            typeListener = test.type.rawValue

            level = test.level
            levelListener = test.level.rawValue

            name = test.name
            descr = test.description
            instruction = test.instruction
            content = test.content ?? ""
            
            jobRole = payload.jobRole

            questions = payload.questions.map{
                .init(
                    itemId: .init(),
                     questionId: $0.question.id,
                     question: $0.question.question,
                    answers: $0.answers.map{
                        .init(
                            itemId: .init(),
                            type: $0.type,
                            answerId: $0.id,
                            answer: $0.answer
                        )
                    }
                )
            }

        }

        func addQuestion() {

            let view = QuestionObjectView(
                itemId: .init(),
                testId: self.id,
                questionId: nil,
                question: "",
                answers: []
            ) { question in
                self.questions.append(question)
            }

            addToDom(view)

        }
        
        func saveTest(_ testId: UUID, _ ignoreEmptyContent: Bool = false) {

            guard let type else {
                showError(.campoRequerido, "Seleccione tipo de prueba")
                return
            }

            guard let level else {
                showError(.campoRequerido, "Seleccione nivel de prueba")
                return
            }

            let name = name.purgeSpaces

            let descr = descr.purgeSpaces

            let instruction = instruction.purgeSpaces

            let content = content.purgeSpaces

            if name.isEmpty {
                showError(.campoRequerido, "Ingrese un nombre valida.")
                return
            }

            if descr.isEmpty {
                showError(.campoRequerido, "Ingrese un descrición valida.")
                return
            }

            if instruction.isEmpty {
                showError(.campoRequerido, "Ingrese un descrición valida.")
                return
            }

            if content.isEmpty && !ignoreEmptyContent {

                addToDom(ConfirmationView(
                    type: .yesNo,
                    title: "Continuar sin contenido",
                    message: "¿Desea crear un prueba sin contenido especial, solo instrucciones de operaciones?"
                ) { isConfirmed, _ in
                    if isConfirmed {
                        self.saveTest(testId, isConfirmed)
                    }
                })

                return

            }
            
            loadingView(show: true)

            API.custAPIV1.savePsychometricsTest(
                id: testId,
                 type: type,
                 level: level,
                 name: name,
                 description: descr,
                 instruction: instruction,
                 content: content.isEmpty ? nil : content,
                 jobrolid: jobRole?.id
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

            }

        }

        func createTest(_ ignoreEmptyContent: Bool = false){
            
            guard let type else {
                showError(.campoRequerido, "Seleccione tipo de prueba")
                return
            }

            guard let level else {
                showError(.campoRequerido, "Seleccione nivel de prueba")
                return
            }

            let name = name.purgeSpaces

            let descr = descr.purgeSpaces

            let instruction = instruction.purgeSpaces

            let content = content.purgeSpaces

            if name.isEmpty {
                showError(.campoRequerido, "Ingrese un nombre valida.")
                return
            }

            if descr.isEmpty {
                showError(.campoRequerido, "Ingrese un descrición valida.")
                return
            }

            if instruction.isEmpty {
                showError(.campoRequerido, "Ingrese un descrición valida.")
                return
            }

            if content.isEmpty && !ignoreEmptyContent {

                addToDom(ConfirmationView(
                    type: .yesNo,
                    title: "Continuar sin contenido",
                    message: "¿Desea crear un prueba sin contenido especial, solo instrucciones de operaciones?"
                ) { isConfirmed, _ in
                    if isConfirmed {
                        self.createTest(isConfirmed)
                    }
                })

                return

            }
            
            if self.questions.count < 10 {
                showError(.campoRequerido, "Se rerquieren por lo menos 10 preguntas en la prueba")
                return
            }

            var questions: [API.custAPIV1.CreatePsychometricsTestQuestions] = []
            
            for  question in self.questions {

                if question.answers.isEmpty {
                    showError(.campoRequerido, "Una de las preguntas esta vacia. Favor de editar la.")
                    break
                }

                if question.answers.count < 3{
                    showError(.campoRequerido, "La pregunta \"\(question.answers)\" solo tiene \(question.answers.count) pregunrtas, agrege por lo menos 3")
                    break
                }

                questions.append(.init(
                    question: question.question,
                     answers: question.answers.map {
                        .init(
                            type: $0.type,
                            answer: $0.answer
                        )
                     }
                ))
            }

            loadingView(show: true)

            API.custAPIV1.createPsychometricsTest(
                tcaccount: nil,
                type: type,
                level: level,
                name: name,
                description: descr,
                instruction: instruction,
                content: content.isEmpty ? nil : content,
                jobrolid: jobRole?.id,
                questions: questions
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

                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                    return
                }

                self.callback(.create(.init(
                    id: payload.test.id,
                    tcaccount: payload.test.tcaccount,
                    type: payload.test.type,
                    level: payload.test.level,
                    name: payload.test.name,
                    description: payload.test.description,
                    instruction: payload.test.instruction,
                    content: payload.test.content,
                    jobrolid: payload.test.jobrolid
                )))

                self.remove()

            }
        }

    }

    enum PsichometricViewCallbackType {

        case create(PsychometricsTestQuick)

        case update(PsychometricsTestQuick)

    }

}
