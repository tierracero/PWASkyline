//
// CommunicationCenterController.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class CommunicationCenterController {

    typealias Message = API.custAPIV1.LoadMessaging

    @State var unreadCount = 0

    private var messagesById: [UUID: Message] = [:]
    private var messageViewsById: [UUID: ICMessageView] = [:]
    private var conversationIdByAlertId: [UUID: UUID] = [:]

    private var communicationRenderId = UUID()
    private var communicationRequestId = UUID()
    private var communicationMutationRevision: UInt64 = 0
    private var relativeTimeRefreshId = UUID()

    private let newMessagesView: Div
    private let historicalMessagesView: Div
    private let openMessage: (Message) -> Void

    private(set) var isActive = true

    init(
        newMessagesView: Div,
        historicalMessagesView: Div,
        openMessage: @escaping (Message) -> Void
    ) {
        self.newMessagesView = newMessagesView
        self.historicalMessagesView = historicalMessagesView
        self.openMessage = openMessage
        startRelativeTimeRefresh()
    }

    func conversationId(for message: Message) -> UUID {
        message.orderid ?? message.id
    }

    func beginRequest() -> (id: UUID, revision: UInt64) {
        let requestId = UUID()
        communicationRequestId = requestId
        return (requestId, communicationMutationRevision)
    }

    func isCurrentRequest(_ requestId: UUID) -> Bool {
        isActive && requestId == communicationRequestId
    }

    @discardableResult
    func replaceSnapshot(
        _ messages: [Message],
        requestId: UUID,
        startingAt revision: UInt64
    ) -> Bool {
        guard isCurrentRequest(requestId) else {
            return false
        }

        guard revision == communicationMutationRevision else {
            return false
        }

        replaceSnapshot(messages)
        return true
    }

    func replaceSnapshot(_ messages: [Message]) {
        guard isActive else {
            return
        }

        communicationRenderId = UUID()
        communicationMutationRevision &+= 1

        messageViewsById.values.forEach { $0.remove() }
        messageViewsById.removeAll(keepingCapacity: true)
        messagesById.removeAll(keepingCapacity: true)
        conversationIdByAlertId.removeAll(keepingCapacity: true)
        newMessagesView.innerHTML = ""
        historicalMessagesView.innerHTML = ""

        var snapshot: [Message] = []
        var includedConversationIds: Set<UUID> = []

        messages.forEach { message in
            guard message.status != .replied else {
                return
            }

            let id = conversationId(for: message)

            guard includedConversationIds.insert(id).inserted else {
                return
            }

            messagesById[id] = message
            conversationIdByAlertId[message.id] = id
            snapshot.append(message)
        }

        synchronizeUnreadCount()

        let renderId = communicationRenderId
        asyncAddCommunicationMessage(
            renderId: renderId,
            messages: snapshot
        )
    }

    func upsert(_ message: Message) {
        guard isActive else {
            return
        }

        let id = conversationId(for: message)

        guard message.status != .replied else {
            removeConversation(conversationId: id)
            return
        }

        // WebSocket retries can deliver the same note more than once. Keep the
        // existing view when the visible state has not changed; removing and
        // reinserting it only increases the chance of racing a DOM refresh.
        if let previous = messagesById[id],
           previous.id == message.id,
           previous.status == message.status,
           previous.lastMessageAt == message.lastMessageAt,
           previous.activity == message.activity,
           messageViewsById[id] != nil {
            messagesById[id] = message
            conversationIdByAlertId[message.id] = id
            synchronizeUnreadCount()
            return
        }

        communicationMutationRevision &+= 1

        if let previous = messagesById[id] {
            conversationIdByAlertId.removeValue(forKey: previous.id)
        }

        messageViewsById[id]?.remove()
        messageViewsById.removeValue(forKey: id)
        messagesById[id] = message
        conversationIdByAlertId[message.id] = id

        appendMessageView(message)
        synchronizeUnreadCount()
    }

    func removeMessage(alertId: UUID) {
        guard let conversationId = conversationIdByAlertId[alertId] else {
            return
        }

        removeConversation(conversationId: conversationId)
    }

    func removeConversation(conversationId: UUID) {
        guard isActive else {
            return
        }

        communicationMutationRevision &+= 1

        if let message = messagesById.removeValue(forKey: conversationId) {
            conversationIdByAlertId.removeValue(forKey: message.id)
        }

        messageViewsById.removeValue(forKey: conversationId)?.remove()
        synchronizeUnreadCount()
    }

    func updateStatus(
        conversationId: UUID,
        status: CustAlertRefrenceStatus
    ) {
        let resolvedConversationId = conversationIdByAlertId[conversationId]
            ?? conversationId

        guard let message = messagesById[resolvedConversationId] else {
            return
        }

        guard status != .replied else {
            removeConversation(conversationId: resolvedConversationId)
            return
        }

        upsert(Message(
            id: message.id,
            orderid: message.orderid,
            type: message.type,
            subType: message.subType,
            folio: message.folio,
            lastMessageAt: message.lastMessageAt,
            userid: message.userid,
            name: message.name,
            avatar: message.avatar,
            activity: message.activity,
            status: status
        ))
    }

    func reset() {
        communicationRenderId = UUID()
        communicationRequestId = UUID()
        communicationMutationRevision &+= 1

        messageViewsById.values.forEach { $0.remove() }
        messageViewsById.removeAll(keepingCapacity: true)
        messagesById.removeAll(keepingCapacity: true)
        conversationIdByAlertId.removeAll(keepingCapacity: true)
        newMessagesView.innerHTML = ""
        historicalMessagesView.innerHTML = ""
        synchronizeUnreadCount()
    }

    func shutdown() {
        guard isActive else {
            return
        }

        isActive = false
        relativeTimeRefreshId = UUID()
        reset()
        $unreadCount.removeAllListeners()
    }

    private func synchronizeUnreadCount() {
        unreadCount = messagesById.values.reduce(into: 0) { count, message in
            if message.status == .new {
                count += 1
            }
        }
    }

    private func asyncAddCommunicationMessage(
        renderId: UUID,
        messages: [Message],
        index: Int = 0
    ) {
        guard isActive, renderId == communicationRenderId else {
            return
        }

        guard messages.indices.contains(index) else {
            return
        }

        let message = messages[index]

        guard renderId == communicationRenderId else {
            return
        }

        let id = conversationId(for: message)

        // A live event may update a conversation while the initial snapshot is
        // still being rendered. Do not append the stale snapshot copy after the
        // live message has already replaced it.
        guard let currentMessage = messagesById[id], currentMessage.id == message.id else {
            Dispatch.asyncAfter(0.01) {
                guard renderId == self.communicationRenderId else {
                    return
                }

                self.asyncAddCommunicationMessage(
                    renderId: renderId,
                    messages: messages,
                    index: index + 1
                )
            }
            return
        }

        appendMessageView(currentMessage)

        guard renderId == communicationRenderId else {
            return
        }

        Dispatch.asyncAfter(0.01) {
            guard renderId == self.communicationRenderId else {
                return
            }

            self.asyncAddCommunicationMessage(
                renderId: renderId,
                messages: messages,
                index: index + 1
            )
        }
    }

    private func appendMessageView(_ message: Message) {
        let id = conversationId(for: message)

        guard messagesById[id] != nil, messageViewsById[id] == nil else {
            return
        }

        let view = ICMessageView(
            data: message,
            callback: openMessage
        ) { [weak self] dismissedMessage in
            self?.removeMessage(alertId: dismissedMessage.id)
        }

        messageViewsById[id] = view

        let container = message.status == .new
            ? newMessagesView
            : historicalMessagesView

        // `insertChild(at:)` uses the Swift Web package's cached child as the
        // browser reference node. A concurrent state-driven refresh can detach
        // that reference before this event runs, producing NotFoundError from
        // JavaScript. Appending is safe for both fresh and live views.
        container.appendChild(view)
    }

    private func startRelativeTimeRefresh() {
        let refreshId = UUID()
        relativeTimeRefreshId = refreshId
        scheduleRelativeTimeRefresh(refreshId)
    }

    private func scheduleRelativeTimeRefresh(_ refreshId: UUID) {
        Dispatch.asyncAfter(30) {
            guard self.isActive, refreshId == self.relativeTimeRefreshId else {
                return
            }

            self.messageViewsById.values.forEach {
                $0.refreshRelativeTime()
            }

            self.scheduleRelativeTimeRefresh(refreshId)
        }
    }
}
