//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+PsichometricView+AddQuestionObjectView.swift
//  
//
//  Created by Victor Cantu on 7/14/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles.PsichometricView {
    
    class QuestionObjectView: Div  {

        override class var name: String { "div" }

        /// this is the itemId to identify one object form an other 
        var itemId: UUID

        var testId: UUID?

        // Question UUID if registerd
        @State var questionId: UUID?

        @State var question: String

        @State var answers: [AnswerObjectItem] = []

        var answersContainer: [AnswerObjectItem] 
        
        private var callback: (
            _ item: QuestionObjectItem
        ) ->  Void

        init(
            itemId: UUID,
            testId: UUID?,
            questionId: UUID?,
            question: String,
            answers: [AnswerObjectItem],
            callback: @escaping (
                _ item: QuestionObjectItem
            ) ->  Void
        ) {
            self.itemId = itemId
            self.testId = testId
            self.questionId = questionId
            self.question = question
            self.answersContainer = answers
            self.callback = callback
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        lazy var questionArea = TextArea(self.$question)
            .custom("width","calc(100% - 24px)")
            .placeholder("Texto de la Pregunta")
            .class(.textFiledBlackDark)
            .height(70.px)

        lazy var answerArea = Div()

        @DOM public override var body: DOM.Content {
            
            Div{
                /*
                Header
                */
                Div{
                    
                    Img()
                        .src("/skyline/media/cross.png")
                        .marginRight(7.px)
                        .cursor(.pointer)
                        .float(.right)
                        .width(24.px)
                        .onClick{
                            self.remove()
                        }
                    
                    H2(self.$questionId.map{ ($0 == nil) ? "Crear Pregunta" : "Editar Pregunta"  })
                        .color(.gray)
                        .float(.left)
                    
                    Div().clear(.both)
                    
                }
                
                Div().clear(.both).height(7.px)
                
                H3("Pregunta a Realizar").color(.white)
                
                Div().clear(.both).height(7.px)

                Div{
                    self.questionArea
                }
                .backgroundColor(.grayBlackDark)
                .padding(all: 3.px)

                Div().clear(.both).height(7.px)
                
                Div{

                    Img()
                        .float(.right)
                        .cursor(.pointer)
                        .src("/skyline/media/add.png")
                        .height(18.px)
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .marginRight(7.px)
                        .onClick {
                            self.addAnswer()
                        }

                    H3("Lista de posibles respuestas").color(.white)
                }
               
                Div().clear(.both).height(7.px)

                Div{

                    Table().noResult(label: "No hay preguntas actuales", button: "Agregar") {
                        self.addAnswer()
                    }
                    .hidden(self.$answers.map{ !$0.isEmpty })

                    Div{
                        self.answerArea
                    }
                    .padding(all: 7.px)
                    .hidden(self.$answers.map{ $0.isEmpty })
                }
                .class(.roundDarkBlue)
                .overflow(.auto)
                .height(200.px)

                Div().clear(.both).height(7.px)

                Div{
                    Div(self.$questionId.map{  ($0 == nil) ? "Crear Pregunta" : "Guardar Cambios" })
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addQuestion()
                    }
                }
                .align(.right)
                
            }
            .boxShadow(h: 0.px, v: 0.px, blur: 3.px, color: .black)
            .custom("left", "calc(50% - \((600 / 2) + (7 * 2))px)")
            .custom("top", "calc(50% - \((450 / 2) + (7 * 2))px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(450.px)
            .width(600.px)

        }

        override func buildUI() {
            
            self.class(.transparantBlackBackGround) 
            position(.absolute)
            height(100.percent)
            width(100.percent)
            top(0.px)
            left(0.px)

            $answers.listen { 
                
                self.answerArea.innerHTML = ""

                $0.forEach { item in
                    let view = Div{
                            
                            Div{

                                Div {
                                    
                                    Span("Tipo de respuesa")
                                    .marginRight(3.px)
                                    .fontSize(18.px)

                                    Span(item.type.description)
                                    .color(.goldenRod)
                                    .marginRight(3.px)
                                    .fontSize(18.px)
                                    .float(.right)

                                }
                                
                                Div().clear(.both).height(7.px)

                                Div(item.answer)

                                Div().clear(.both).height(3.px)
                                
                                }
                                .custom("width", "calc(100% - 35px)")
                                .float(.left)

                            Div{
                                
                                Table{  
                                    Tr{
                                        Td{

                                            Img()
                                                .src("/skyline/media/cross.png")
                                                .cursor(.pointer)
                                                .width(18.px)
                                                .onClick{ _, event in
                                                    self.removeAnswer(item.itemId, item.answerId)
                                                    event.stopPropagation()
                                                }
                                        }
                                        .verticalAlign(.middle)
                                        .align(.right)
                                    }
                                }
                                .height(100.percent)
                                .width(100.percent)
                                
                            }
                            .width(35.px)
                            .float(.left)

                            Div().clear(.both)
                        }
                        .custom("width", "calc(100% - 14px)")
                        .class(.uibtnLarge)
                        .onClick {
                            self.addAnswer(item)
                        }

                    self.answerArea.appendChild(view)
                    
                }

            }

            answers = answersContainer

        }

        func addAnswer(_ answer: AnswerObjectItem? = nil) {

            let question = self.question.purgeSpaces

            if question.isEmpty {
                showError(.requiredField, "Ingrese pregunta a realizar.")
                return 
            }

            let view = AnswerObjectView(
                itemId: answer?.itemId ?? .init(),
                testId: self.testId,
                questionId: self.questionId,
                question: question,
                answerId: answer?.answerId,
                type: answer?.type,
                answer: answer?.answer ?? ""
            ) { answer in

                var answers: [AnswerObjectItem] = []
                
                var foundElement = false

                self.answers.forEach { thisAnswer in

                    if thisAnswer.itemId == answer.itemId {
                        foundElement = true
                        answers.append(answer)
                        return
                    }

                    answers.append(thisAnswer)

                }

                if !foundElement {
                    answers.append(answer)
                }

                self.answers = answers

            }
            
            addToDom(view)

        }

        func removeAnswer(_ itemId: UUID, _ answerId: UUID? ) {
            
            if let answerId {

                if self.answers.count < 3  {
                    showError(.requiredField, "Ingrese por lo menos tres respuestas.")
                    return
                }

                loadingView(show: true)

                API.custAPIV1.removePsychometricsTestAnswer(
                    answerId: answerId
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
                    
                    var answers: [AnswerObjectItem] = []
                    
                    self.answers.forEach { answer in

                        if answer.itemId == itemId {
                            return
                        }

                        answers.append(answer)

                    }

                    self.answers = answers

                }

                return  
            }

            var answers: [AnswerObjectItem] = []

            self.answers.forEach { answer in

                if answer.itemId == itemId {
                    return
                }

                answers.append(answer)

            }

            self.answers = answers

        }

        func addQuestion() {

            let question = question.purgeSpaces

            if question.isEmpty {
                showError(.requiredField, "Ingrese pregunta a realizar")
                return
            }

            if answers.count < 3 {
                showError(.requiredField, "Ingrese por lo menos tres respuestas.")
                return
            }

            if let questionId {

                loadingView(show: true)

                API.custAPIV1.savePsychometricsTestQuestion(
                    questionId: questionId,
                    question: question
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

                }

                return
                
            }

            if let testId {
                
                loadingView(show: true)

                API.custAPIV1.addPsychometricsTestQuestion(
                    testid: testId,
                    question: question,
                    answers: answers.map {
                        .init(
                            type: $0.type,
                            answer: $0.answer
                        )
                    }
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

                    guard let payload = resp.data else {
                        showError(.unexpectedResult, .unexpectedMissingPayload)
                        return
                    }

                    let  question = payload.question

                    let answers = payload.answers

                    self.callback(.init(
                        itemId: self.itemId,
                        questionId: question.id,
                        question: question.question,
                        answers: answers.map{
                            .init(
                                itemId: .init(),
                                type: $0.type,
                                answerId: $0.id,
                                answer: $0.answer
                            )
                        }
                    ))
                    
                }

                return
            }

            callback(.init(
                itemId: itemId,
                questionId: questionId,
                question: question,
                answers: answers
            ))

            self.remove()

        }
    }
}