//
//  InternalCommunicationView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/// Presents the internal communications returned by
/// `API.custAPIV1.sincCustSettings`.
class InternalCommunicationView: Div {

    override class var name: String { "div" }

    var internalCommunications: [InternalCommunicationMessagesMin]

    @State private var messageCount: Int

    @State private var hasMessages: Bool

    private var messageViews: [UUID: VBox] = [:]

    private let onDismiss: () -> Void

    private var didNotifyDismissal = false

    init(
        internalCommunications: [InternalCommunicationMessagesMin],
        onDismiss: @escaping () -> Void = {}
    ) {
        let currentTime = getNow()
        let messages = internalCommunications
            .filter { message in
                guard let expiredAt = message.expiredAt else {
                    return true
                }
                return expiredAt >= currentTime
            }
            .sorted { lhs, rhs in
                let lhsPriority = Self.priorityOrder(lhs.priority)
                let rhsPriority = Self.priorityOrder(rhs.priority)

                if lhsPriority == rhsPriority {
                    return lhs.createdAt > rhs.createdAt
                }

                return lhsPriority > rhsPriority
            }

        self.internalCommunications = messages
        self.messageCount = messages.count
        self.hasMessages = !messages.isEmpty
        self.onDismiss = onDismiss

        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private lazy var messagesView = Div()
        .class(Class(TCInternalCommunicationClass.messageList))
        .width(100.percent)

    private lazy var emptyView = VBox(.standard) {
        Table().noResult(label: "No hay comunicaciones internas")
    }
    .class(Class(TCInternalCommunicationClass.emptyState))

    @DOM override var body: DOM.Content {
        VPopUp(.custome(w: 920, h: 760)) {
            VTitle("Comunicaciones internas") {
                USmallTitle(self.$messageCount.map { "\($0) pendientes" })
                    .class(Class(TCInternalCommunicationClass.countBadge))
            } onClose: {
                self.remove()
            }

            VBodyGrid {

                VGrid(.full) {
                    self.messagesView
                    .display(self.$hasMessages.map{ !$0 ? .none : .block })
                        .hidden(self.$hasMessages.map { !$0 })

                    self.emptyView
                        .display(self.$hasMessages.map{ $0 ? .none : .block })
                        .hidden(self.$hasMessages)
                }
            }
        }
        .class(Class(TCInternalCommunicationClass.popup))
        .custom("filter", "blur(0px) !important")
    }

    override func buildUI() {
        super.buildUI()

        TCInternalCommunicationTheme.apply(to: self)

        position(.absolute)
        width(100.percent)
        height(100.percent)
        left(0.px)
        top(0.px)

        internalCommunications.forEach(addCommunication)
    }

    private func addCommunication(
        _ communication: InternalCommunicationMessagesMin
    ) {

        let messageView = VBox(.standard) {
            Div {

                Div(Self.typeIcon(communication.type))

                Div {
                    Div {
                        USmallTitle(communication.type.description)
                            .class(Class(TCInternalCommunicationClass.typeBadge))

                        USmallTitle(communication.priority.description)
                            .class(Class(TCInternalCommunicationClass.priorityBadge))
                    }
                    .class(Class(TCInternalCommunicationClass.badges))
                    .float(.right)

                    UTitle(communication.title)
                        .class(Class(TCInternalCommunicationClass.messageTitle))

                    USubTitle(communication.subtitle)
                        .class(Class(TCInternalCommunicationClass.messageSubtitle))

                }
                .custom("min-width", "0")
            }
            .class(Class(TCInternalCommunicationClass.messageContent))

            if let media = communication.media,
               !media.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Img()
                    .src( (WebApp.shared.window.location.hostname == "localhost") ? "https://skyline.tierracero.com/skyline/comms/\(media)" : "/skyline/comms/\(media)" )
                    .alt(communication.title)
                    .class(Class(TCInternalCommunicationClass.messageMedia))
            }

            if let shortMessage = communication.shortMessage, !shortMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Div(shortMessage)
                    .class(Class(TCInternalCommunicationClass.messageBody))
            }

            Div().clear(.both)
            /*
            Div {
                UMinorTitle(Self.createdAtText(communication.createdAt))
                    .class(Class(TCInternalCommunicationClass.messageDate))
            }
            .class(Class(TCInternalCommunicationClass.messageFooter))
            */
        }
        .class(Class(TCInternalCommunicationClass.messageCard))
        .attribute("data-priority", communication.priority.rawValue)
        .marginBottom(12.px)

        messageViews[communication.id] = messageView
        messagesView.appendChild(messageView)
    }

    private static func priorityOrder(
        _ priority: InternalCommunicationMessagePriority
    ) -> Int {
        switch priority {
        case .zero:
            return 0
        case .low:
            return 1
        case .medium:
            return 2
        case .high:
            return 3
        case .critical:
            return 4
        }
    }

    private static func typeIcon(
        _ type: InternalCommunicationMessageType
    ) -> String {
        switch type {
        case .communication:
            return "💬"
        case .update:
            return "↥"
        case .outage:
            return "⚠️"
        case .functionality:
            return "✦"
        }
    }

    private static func createdAtText(_ createdAt: Int64) -> String {
        let date = getDate(createdAt)
        return "\(date.formatedShort) · \(date.time)"
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $messageCount.removeAllListeners()
        $hasMessages.removeAllListeners()

        guard !didNotifyDismissal else {
            return
        }

        didNotifyDismissal = true
        onDismiss()
    }
}

private enum TCInternalCommunicationClass {
    static let root = "tc-internal-communication-theme"
    static let popup = "tc-internal-communication-popup"
    static let hero = "tc-internal-communication-hero"
    static let heroIcon = "tc-internal-communication-hero-icon"
    static let countBadge = "tc-internal-communication-count"
    static let messageList = "tc-internal-communication-list"
    static let messageCard = "tc-internal-communication-card"
    static let messageContent = "tc-internal-communication-content"
    static let messageIcon = "tc-internal-communication-icon"
    static let badges = "tc-internal-communication-badges"
    static let typeBadge = "tc-internal-communication-type"
    static let priorityBadge = "tc-internal-communication-priority"
    static let messageTitle = "tc-internal-communication-title"
    static let messageSubtitle = "tc-internal-communication-subtitle"
    static let messageBody = "tc-internal-communication-body"
    static let messageMedia = "tc-internal-communication-media"
    static let messageFooter = "tc-internal-communication-footer"
    static let messageDate = "tc-internal-communication-date"
    static let emptyState = "tc-internal-communication-empty"
}

private enum TCInternalCommunicationTheme {
    private static var isInstalled = false

    static func apply(to view: Div) {
        install()
        view.class(Class(TCInternalCommunicationClass.root))
    }

    private static func install() {
        guard !isInstalled else {
            return
        }

        isInstalled = true
        let root = ".\(TCInternalCommunicationClass.root)"
        let card = "\(root) .\(TCInternalCommunicationClass.messageCard)"
        let modalHost = ".transparantBlackBackGround:has(> \(root))"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .custom("--tc-internal-glass", "rgba(5, 24, 40, 0.74)")
                .custom("--tc-internal-raised", "rgba(8, 34, 55, 0.82)")
                .custom("--tc-internal-border", "rgba(76, 169, 225, 0.30)")
                .custom("--tc-internal-blue", "#49b9f5")
                .custom("--tc-internal-ink", "#edf7ff")
                .custom("--tc-internal-muted", "#a8bed0")

            CSSRule(Pointer(modalHost))
                .custom("background", "rgba(1, 8, 17, 0.18) !important")
                .custom("backdrop-filter", "blur(8px) saturate(120%) !important")
                .custom("-webkit-backdrop-filter", "blur(8px) saturate(120%) !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.popup)"))
                .custom("background", "transparent !important")
                .custom("backdrop-filter", "none !important")
                .custom("-webkit-backdrop-filter", "none !important")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.popUpPanel)"))
                .custom("display", "grid")
                .custom("grid-template-rows", "auto minmax(0, 1fr)")
                .custom("gap", "12px")
                .custom("padding", "12px")
                .custom("background", "linear-gradient(145deg, rgba(8, 34, 54, 0.78), rgba(4, 16, 29, 0.64)) !important")
                .custom("border", "1px solid var(--tc-internal-border) !important")
                .custom("box-shadow", "0 28px 80px rgba(0, 0, 0, 0.56), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(24px) saturate(135%)")
                .custom("-webkit-backdrop-filter", "blur(24px) saturate(135%)")
                .overflow(.hidden)

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.title)"))
                .custom("background", "#252c3b !important")
                .custom("border", "1px solid rgba(102, 184, 236, 0.22)")
                .custom("border-left", "4px solid var(--tc-internal-blue)")
                .custom("border-radius", "12px")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.bodyGrid)"))
                .custom("overflow-y", "auto")
                .custom("align-content", "start")
                .custom("background", "transparent !important")

            CSSRule(Pointer("\(root) .\(TCTripBetaClass.box)"))
                .custom("background", "var(--tc-internal-glass) !important")
                .custom("border-color", "rgba(92, 153, 194, 0.24) !important")
                .custom("backdrop-filter", "blur(14px)")
                .custom("-webkit-backdrop-filter", "blur(14px)")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.hero)"))
                .custom("border-left", "3px solid var(--tc-internal-blue) !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.heroIcon)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "52px")
                .custom("height", "52px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.34)")
                .custom("border-radius", "14px")
                .custom("background", "rgba(10, 55, 87, 0.58)")
                .custom("font-size", "25px")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.countBadge)"))
                .custom("padding", "6px 10px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.30)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(18, 78, 118, 0.45)")
                .custom("color", "#9cd9ff !important")
                .custom("white-space", "nowrap")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageList)"))
                .custom("display", "grid")
                .custom("gap", "12px")

            CSSRule(Pointer(card))
                .custom("display", "grid")
                .custom("gap", "12px")
                .custom("border-left", "4px solid var(--tc-internal-blue) !important")
                .custom("background", "linear-gradient(145deg, rgba(9, 37, 59, 0.78), rgba(4, 19, 33, 0.68)) !important")

            CSSRule(Pointer("\(card)[data-priority='medium']"))
                .custom("border-left-color", "#f0c419 !important")

            CSSRule(Pointer("\(card)[data-priority='high']"))
                .custom("border-left-color", "#ff8a3d !important")

            CSSRule(Pointer("\(card)[data-priority='critical']"))
                .custom("border-left-color", "#ff5252 !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageContent)"))
                .custom("display", "grid")
                .custom("grid-template-columns", "48px minmax(0, 1fr)")
                .custom("gap", "12px")
                .custom("align-items", "start")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageIcon)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")
                .custom("width", "46px")
                .custom("height", "46px")
                .custom("border", "1px solid rgba(73, 185, 245, 0.25)")
                .custom("border-radius", "13px")
                .custom("background", "rgba(12, 54, 84, 0.52)")
                .custom("font-size", "23px")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.badges)"))
                .custom("display", "flex")
                .custom("flex-wrap", "wrap")
                .custom("gap", "7px")
                .custom("margin-bottom", "8px")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.typeBadge), \(root) .\(TCInternalCommunicationClass.priorityBadge)"))
                .custom("padding", "4px 8px")
                .custom("border", "1px solid rgba(95, 174, 222, 0.25)")
                .custom("border-radius", "999px")
                .custom("background", "rgba(20, 67, 98, 0.42)")
                .custom("color", "#bfe7ff !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageTitle)"))
                .custom("color", "var(--tc-internal-ink) !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageSubtitle), \(root) .\(TCInternalCommunicationClass.messageDate)"))
                .custom("color", "var(--tc-internal-muted) !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageBody)"))
                .custom("margin-top", "10px")
                .custom("color", "#d8e8f4")
                .custom("line-height", "1.5")
                .custom("white-space", "pre-wrap")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageMedia)"))
                .custom("display", "block")
                .custom("width", "100%")
                .custom("max-height", "280px")
                .custom("border", "1px solid rgba(95, 174, 222, 0.22)")
                .custom("border-radius", "12px")
                .custom("object-fit", "cover")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageFooter)"))
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "space-between")
                .custom("gap", "12px")
                .custom("padding-top", "10px")
                .custom("border-top", "1px solid rgba(95, 174, 222, 0.16)")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageFooter) .\(TCTripBetaClass.uiButton)"))
                .custom("min-height", "34px")
                .custom("padding", "6px 14px !important")

            CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.emptyState)"))
                .custom("min-height", "190px")
                .custom("display", "flex")
                .custom("align-items", "center")
                .custom("justify-content", "center")

            MediaRule(.screen.maxWidth(700.px)) {
                CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageContent)"))
                    .custom("grid-template-columns", "1fr")

                CSSRule(Pointer("\(root) .\(TCInternalCommunicationClass.messageFooter)"))
                    .custom("align-items", "stretch")
                    .custom("flex-direction", "column")
            }
        }
    }
}
