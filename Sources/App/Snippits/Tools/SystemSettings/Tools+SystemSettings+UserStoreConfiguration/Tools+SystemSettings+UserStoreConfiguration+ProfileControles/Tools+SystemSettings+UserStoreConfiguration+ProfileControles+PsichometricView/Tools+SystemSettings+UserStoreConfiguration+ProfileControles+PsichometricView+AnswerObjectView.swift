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
    
    class AnswerObjectView: Div {

        override class var name: String { "div" }
        
        var itemId: UUID

        var testId: UUID?

        var questionId: UUID?

        var question: String

        @State var answerId: UUID?

        /// best, correct, incorrect, neutral
        @State var type: PsychometricsTestAnswersType?

        @State var answer: String
        
        private var callback: (
            _ item: AnswerObjectItem
        ) -> Void

        init(
            itemId: UUID,
            testId: UUID?,
            questionId: UUID?,
            question: String,
            answerId: UUID?,
            type: PsychometricsTestAnswersType?,
            answer: String,
            callback: @escaping (
                _ item: AnswerObjectItem
            ) -> Void
        ) {
            self.itemId = itemId
            self.testId = testId
            self.questionId = questionId
            self.question = question
            self.answerId = answerId
            self.type = type
            self.answer = answer
            self.callback = callback
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        /// PsychometricsTestAnswersType
        @State var typeListener: String = ""

        /// PsychometricLevel
        lazy var typeSelect = Select(self.$typeListener)
            .body{
                Option("Seleccione Opción")
                .value("")
            }
            .custom("width","calc(100% - 7px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            
        lazy var answerArea = TextArea(self.$answer)
            .custom("width","calc(100% - 24px)")
            .placeholder("Texto de la Respuesta")
            .class(.textFiledBlackDark)
            .height(100.px)

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
                    
                    H2(self.$answerId.map{ ($0 == nil) ? "Crear Respuesta" : "Editar Respuesta" })
                        .color(.gray)
                        .float(.left)
                    
                    Div().clear(.both)
                    
                }
                
                Div().clear(.both).height(7.px)

                Div {
                    Div {
                        H3("Tipo de Respuesta")
                        .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        self.typeSelect
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(7.px)

                H2("Pregunta a responder")
                .color(.white)
                
                Div().clear(.both).height(7.px)

                H2("\"\(self.question)\"")
                .color(.darkGoldenRod)
                
                Div().clear(.both).height(7.px)

                H3("Texto de la respuesta")
                .color(.white)

                Div().clear(.both).height(7.px)

                self.answerArea

                Div{
                    Div(self.$answerId.map{ ($0 == nil) ? "Crear Respuesta" : "Guardar Respuesta" })
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addAnswer()
                    }
                }
                .align(.right)

            }
            .boxShadow(h: 0.px, v: 0.px, blur: 3.px, color: .black)
            .custom("top", "calc(50% - \((300 / 2) - (7 * 2))px)")
            .custom("left", "calc(50% - \((500 / 2) - (7 * 2))px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(500.px)
       
        }

        override func buildUI() {
            
            self.class(.transparantBlackBackGround) 
            position(.absolute)
            height(100.percent)
            width(100.percent)
            top(0.px)
            left(0.px)

            $typeListener.listen {
                self.type = PsychometricsTestAnswersType(rawValue: $0)
            }

            PsychometricsTestAnswersType.allCases.forEach{ item in
                typeSelect.appendChild(Option(item.description).value(item.rawValue))
            }
            
            typeListener = type?.rawValue ?? ""

        }

        func addAnswer() {

            guard let type else {
                showError(.campoRequerido, "Seleccione Un timpo de respuesta valida")
                return
            }

            let answer = answer.purgeSpaces

            if answer.isEmpty {
                showError(.campoRequerido, "Ingrese una respuesta valida")
                return
            }

            if let answerId {

                loadingView(show: true)

                API.custAPIV1.savePsychometricsTestAnswer(
                    answerId: answerId,
                    type: type,
                    answer: answer
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

                    self.callback(.init(
                        itemId: self.itemId,
                        type: type,
                        answerId: answerId,
                        answer: answer
                    ))

                }

                return
                
            }

            if let questionId {

                loadingView(show: true)

                API.custAPIV1.addPsychometricsTestAnswer(
                    questionId: questionId,
                    type: type,
                    answer: answer
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

                    guard let answer = resp.data else {
                        showError(.unexpectedResult, .unexpectedMissingPayload)
                        return
                    }
                    
                    self.callback(.init(
                        itemId: self.itemId,
                        type: answer.type,
                        answerId: answer.id,
                        answer: answer.answer
                    ))

                    self.remove()

                }

                return
            }

            callback(.init(
                itemId: itemId,
                type: type,
                answerId: answerId,
                answer: answer
            ))

            self.remove()

        }
    }
}

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles.PsichometricView {

    struct AnswerObjectItem: Hashable, Equatable {
        
        var itemId: UUID // { .init() }

        /// best, correct, incorrect, neutral
        var type: PsychometricsTestAnswersType

        var answerId: UUID?

        var answer: String
        
        init(
            itemId: UUID,
            type: PsychometricsTestAnswersType,
            answerId: UUID?,
            answer: String
        ){
            self.itemId = itemId
            self.type = type
            self.answerId = answerId
            self.answer = answer
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.itemId == rhs.itemId
        }
        
        public func hash (into hasher: inout Hasher) {
            hasher.combine(itemId)
        }

    }

}