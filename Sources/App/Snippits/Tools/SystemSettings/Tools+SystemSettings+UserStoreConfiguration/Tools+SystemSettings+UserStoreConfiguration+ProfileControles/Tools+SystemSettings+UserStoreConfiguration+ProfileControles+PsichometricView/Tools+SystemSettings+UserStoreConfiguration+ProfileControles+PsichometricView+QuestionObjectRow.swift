import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles.PsichometricView {
    
    class QuestionObjectRow: Div {

        override class var name: String { "div" }

        var itemId: UUID 

        // Question UUID if registerd
        var questionId: UUID?

        var question: String

        var answers: [AnswerObjectItem]
        
        private var editItem: () -> Void

        private var removeItem: () -> Void

        init(
            item: QuestionObjectItem,
            editItem: @escaping (() -> Void),
            removeItem: @escaping (() -> Void)
        ){
            self.itemId = item.itemId
            self.questionId = item.questionId
            self.question = item.question
            self.answers = item.answers
            self.editItem = editItem
            self.removeItem = removeItem
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        @DOM public override var body: DOM.Content {
            Div {

                Div {
                    Span("Pregunta:")
                    .fontSize(16.px)
                    .color(.gray)

                    Span("Numero de respuestas: \(self.answers.count)")
                    .fontSize(16.px)
                    .color(.white)
                    .float(.right)
                }

                Div().clear(.both).height(7.px)
                
                Div{
                    H2(self.question)
                    .color(.white)
                }

            }
            .custom("width", "calc(100% - 35px)")
            .float(.left)

            Div {

                Table{  
                    Tr{
                        Td{

                            Img()
                                .src("/skyline/media/cross.png")
                                .cursor(.pointer)
                                .width(18.px)
                                .onClick{ _, event in
                                    self.removeItem()
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
            .height(50.px)
            .width(35.px)
            .float(.left)

            Div().clear(.both)
        }

        override func buildUI() {
            self.class(.uibtnLarge)
            custom("width", "calc(100% - 17px)")
            onClick {
                self.editItem()
            }
        }
    }

}

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles.PsichometricView {

    struct QuestionObjectItem: Hashable, Equatable {

        var itemId: UUID 

        // Question UUID if registerd
        var questionId: UUID?
        
        var question: String

        var answers: [AnswerObjectItem]
        
        init(
            itemId: UUID,
            questionId: UUID?,
            question: String,
            answers: [AnswerObjectItem]
        ){
            self.itemId = itemId
            self.questionId = questionId
            self.question = question
            self.answers = answers
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.itemId == rhs.itemId
        }
        
        public func hash (into hasher: inout Hasher) {
            hasher.combine(itemId)
        }
        
    }   
}