//
// SkylineDocumentation+DocumentView.swift
//


import Foundation
import TCFundamentals
import TCFireSignal
import Web
import SkylineDocumentationCore

extension SkylineDocumentationView {

    class DocumentView: Div {

        private enum FeedbackSelection {
            case helpful
            case notHelpful
        }

        override class var name: String { "div" }

        var family: DocumentFamily

        var item: DocumentItem

        @State var documentBody: [DocumentBodyBlock]

        @State private var feedbackSelection: FeedbackSelection? = nil

        init(
            family: DocumentFamily,
            item: DocumentItem,
            documentBody: [DocumentBodyBlock]
        ) {
            self.family = family
            self.item = item
            self.documentBody = documentBody.sorted { $0.orderIndex < $1.orderIndex }
        }

        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("\(self.family.description) | \(self.item.title)")
                        .marginLeft(7.px)
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                .marginBottom(7.px)

                Div {
                    
                    Div {

                        Div {
                            H2(self.item.title)
                                .color(.white)
                                .fontSize(28.px)
                                .custom("flex", "1 1 320px")

                            self.feedbackControl()
                        }
                        .custom("display", "flex")
                        .custom("align-items", "center")
                        .custom("justify-content", "space-between")
                        .custom("flex-wrap", "wrap")
                        .custom("gap", "10px 18px")
                        .marginBottom(8.px)
                        
                        P(self.item.objective)
                            .color(.lightGray)
                            .fontSize(16.px)
                            .lineHeight(23.px)
                            .marginBottom(12.px)
                        
                        Div {
                            
                            Span("Version \(self.item.version)")
                                .color(.white)
                                .fontSize(13.px)
                                .backgroundColor(.slateHeader)
                                .borderRadius(all: 7.px)
                                .padding(v: 5.px, h: 9.px)
                                .marginRight(7.px)
                            
                            Span(self.item.status.rawValue)
                                .color(.white)
                                .fontSize(13.px)
                                .backgroundColor(.darkOrange)
                                .borderRadius(all: 7.px)
                                .padding(v: 5.px, h: 9.px)
                                .marginRight(7.px)
                            
                            if !self.item.keywords.isEmpty {
                                Span(self.item.keywords.joined(separator: ", "))
                                    .color(.lightBlueText)
                                    .fontSize(13.px)
                            }
                        }
                    }
                    .backgroundColor(.grayBlackDark)
                    .borderRadius(all: 14.px)
                    .padding(all: 18.px)
                    .marginBottom(14.px)
                    
                    Div {
                        
                        P("Sin contenido para mostrar.")
                            .color(.lightGray)
                            .fontSize(16.px)
                            .lineHeight(24.px)
                            .hidden(self.$documentBody.map{ !$0.isEmpty })

                        Div{
                            ForEach(self.$documentBody) { block in
                                self.render(block)
                            }

                        }
                        .hidden(self.$documentBody.map{ $0.isEmpty })

                    }
                    .backgroundColor(.grayBlack)
                    .borderRadius(all: 14.px)
                    .padding(all: 22.px)
                    
                }
                .custom("height","calc(100% - 60px)")
                .overflow(.auto)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("height","calc(85% - 14px)")
            .custom("width","calc(85% - 14px)")
            .custom("left","calc(8% - 14px)")
            .custom("top","calc(8% - 14px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
        }

        @DOM private func feedbackControl() -> DOM.Content {
            Div {
                self.feedbackButton(.helpful)
                self.feedbackButton(.notHelpful)

                Span("Give Feedback")
                    .color(.lightBlueText)
                    .fontSize(14.px)
                    .whiteSpace(.nowrap)
                    .marginLeft(3.px)
            }
            .custom("display", "flex")
            .custom("align-items", "center")
            .custom("gap", "5px")
            .custom("flex", "0 0 auto")
        }

        @DOM private func feedbackButton(_ selection: FeedbackSelection) -> DOM.Content {
            Div {
                Svg {
                    Path()
                        .custom(
                            "d",
                            "M1 21h4V9H1v12zM23 10c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.82 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"
                        )
                        .custom("fill", "#10181b")
                }
                .custom("viewBox", "0 0 24 24")
                .custom("display", "block")
                .custom("transform", selection == .notHelpful ? "rotate(180deg)" : "none")
                .width(17.px)
                .height(17.px)
            }
            .title(selection == .helpful ? "Helpful" : "Not helpful")
            .custom("display", "flex")
            .custom("align-items", "center")
            .custom("justify-content", "center")
            .width(50.px)
            .height(28.px)
            .backgroundColor(self.$feedbackSelection.map {
                $0 == selection ? .lightBlue : Color(r: 129, g: 190, b: 199)
            })
            .borderRadius(all: 4.px)
            .cursor(.pointer)
            .onClick {
                self.feedbackSelection = selection
            }
        }


        override func buildUI() {
            
            super.buildUI()
            
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
        }

        @DOM private func render(_ block: DocumentBodyBlock) -> DOM.Content {
            switch block.type {
            case .title:
                H2(block.payload)
                    .color(.white)
                    .fontSize(25.px)
                    .marginTop(18.px)
                    .marginBottom(10.px)
            case .subtitle:
                H3(block.payload)
                    .color(.lightBlueText)
                    .fontSize(20.px)
                    .marginTop(18.px)
                    .marginBottom(8.px)
            case .body:
                P(block.payload)
                    .color(.lightGray)
                    .fontSize(16.px)
                    .lineHeight(24.px)
                    .marginBottom(12.px)
            case .image:
                self.imageBlock(block.payload)
            case .video:
                self.mediaPlaceholder("Video", block.payload)
            case .steps:
                self.listBlock(block.payload, numbered: true)
            case .list:
                self.listBlock(block.payload, numbered: false)
            case .table:
                Pre(block.payload)
                    .color(.lightGray)
                    .fontSize(14.px)
                    .lineHeight(21.px)
                    .backgroundColor(.grayBlackDark)
                    .borderRadius(all: 10.px)
                    .padding(all: 14.px)
                    .overflow(.auto)
                    .marginBottom(12.px)
            case .note:
                self.calloutBlock(title: "Nota", payload: block.payload, color: .lightBlueText)
            case .warning:
                self.calloutBlock(title: "Atencion", payload: block.payload, color: .darkOrange)
            case .tip:
                self.calloutBlock(title: "Tip", payload: block.payload, color: .lightBlueText)
            case .divider:
                Div()
                    .height(1.px)
                    .backgroundColor(.grayBlackDark)
                    .margin(v: 18.px, h: 0.px)
            case .pageBreak:
                Div()
                    .height(18.px)
            }
        }
        
        @DOM private func listBlock(_ payload: String, numbered: Bool) -> DOM.Content {
            Div {
                ForEach(self.listItems(from: payload)) { index, item in
                    Div {
                        Span(numbered ? "\(index + 1)." : "-")
                            .color(.darkOrange)
                            .fontSize(16.px)
                            .custom("width", "28px")
                            .float(.left)
                        
                        P(item)
                            .color(.lightGray)
                            .fontSize(16.px)
                            .lineHeight(23.px)
                            .custom("width", "calc(100% - 32px)")
                            .float(.left)
                        
                        Div().class(.clear)
                    }
                    .marginBottom(9.px)
                }
            }
            .margin(v: 10.px, h: 0.px)
        }
        
        @DOM private func imageBlock(_ payload: String) -> DOM.Content {
            Div {
                Img()
                    .src(self.imagePath(payload))
                    .custom("max-width", "100%")
                    .custom("max-height", "520px")
                    .custom("object-fit", "contain")
                    .borderRadius(all: 10.px)
                
                Div(payload)
                    .color(.gray)
                    .fontSize(13.px)
                    .marginTop(7.px)
            }
            .backgroundColor(.grayBlackDark)
            .borderRadius(all: 14.px)
            .padding(all: 12.px)
            .margin(v: 14.px, h: 0.px)
            .align(.center)
        }
        
        @DOM private func calloutBlock(title: String, payload: String, color: Color) -> DOM.Content {
            Div {
                Strong(title)
                    .color(color)
                    .fontSize(15.px)
                
                P(payload)
                    .color(.lightGray)
                    .fontSize(15.px)
                    .lineHeight(22.px)
                    .marginTop(6.px)
            }
            .backgroundColor(.grayBlackDark)
            .borderLeft(width: .medium, style: .solid, color: color)
            .borderRadius(all: 10.px)
            .padding(all: 14.px)
            .margin(v: 12.px, h: 0.px)
        }
        
        @DOM private func mediaPlaceholder(_ title: String, _ payload: String) -> DOM.Content {
            Div {
                Strong(title)
                    .color(.darkOrange)
                    .fontSize(15.px)
                
                P(payload)
                    .color(.lightGray)
                    .fontSize(15.px)
                    .lineHeight(22.px)
                    .marginTop(6.px)
            }
            .backgroundColor(.grayBlackDark)
            .borderRadius(all: 10.px)
            .padding(all: 14.px)
            .margin(v: 12.px, h: 0.px)
        }
        
        private func listItems(from payload: String) -> [String] {
            payload
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        private func imagePath(_ payload: String) -> String {
            if payload.hasPrefix("/") || payload.hasPrefix("http://") || payload.hasPrefix("https://") {
                return payload
            }
            
            return "/skyline/tutorial/\(payload)"
        }

    }

}
