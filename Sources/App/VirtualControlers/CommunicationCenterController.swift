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

        communicationMutationRevision &+= 1

        if let previous = messagesById[id] {
            conversationIdByAlertId.removeValue(forKey: previous.id)
        }

        messageViewsById[id]?.remove()
        messageViewsById.removeValue(forKey: id)
        messagesById[id] = message
        conversationIdByAlertId[message.id] = id

        appendMessageView(message, insertAtFront: true)
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

        appendMessageView(message, insertAtFront: false)

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

    private func appendMessageView(
        _ message: Message,
        insertAtFront: Bool
    ) {
        let id = conversationId(for: message)

        guard messagesById[id] != nil else {
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

        if insertAtFront {
            container.insertChild(view, at: 0)
        } else {
            container.appendChild(view)
        }
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
