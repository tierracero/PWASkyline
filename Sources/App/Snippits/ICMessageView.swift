//
//  ICMessageView.swift
//  
//
//  Created by Victor Cantu on 8/7/22.
//

import Foundation
import TCFundamentals
import Web
/**
 id: UUID,
 orderid: UUID?,
 `manual, message`
 type: CustAlertRefrenceType,
 `sale, order, chat, account, merca, ebay, amz, facebook, instagram, twitter`
 subType: CustAlertRefrenceSubType,
 folio: String,
 modifiedAt: Int64,
 lastMessageAt: Int64,
 userid: HybridIdentifier?,
 name: String,
 avatar: String?,
 activity: String,
 ` new, viewed , replied`
 status: CustAlertRefrenceStatus
 */
/// Instant Comunication Message View
class ICMessageView: Div {
    
    override class var name: String { "div" }
    
    let data: API.custAPIV1.LoadMessaging
    
    private let callback: (API.custAPIV1.LoadMessaging) -> Void

    private let dismissCallback: (API.custAPIV1.LoadMessaging) -> Void
    
    init(
        data: API.custAPIV1.LoadMessaging,
        callback: @escaping (API.custAPIV1.LoadMessaging) -> Void,
        dismissCallback: @escaping (API.custAPIV1.LoadMessaging) -> Void
    ) {
        self.data = data
        self.callback = callback
        self.dismissCallback = dismissCallback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    ///Icon that represents if the msg is un read, read, or user is righting
    @State var icon = ""
    @State var chatNick = ""
    @State var socialIcon = ""
    @State var lastMessageAt: Int64 = 0
    @State var lastMessageAtText = ""
    @State var activity: String = ""
    /// new, viewed , replied
    @State var status: CustAlertRefrenceStatus = .new
    
    @State var isFoccused = false

    private var displayName: String {
        let name = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? data.subType.description.capitalized : name
    }
    
    lazy var closeIcon = Img()
        .hidden(self.$isFoccused.map{ !$0 })
        .src("/skyline/media/cross.png")
        .class(Class(TCWorkDashboardClass.messageDismiss))
        .cursor(.pointer)
        .onClick { img, event in
            
            img.load("/skyline/media/loader.gif")
            
            API.custAPIV1.dismissMessage(
                alertid: self.data.id,
                orderid: self.data.orderid
            ) { resp in
                
                img.load("/skyline/media/cross.png")
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.dismissCallback(self.data)
            }
            
            event.stopPropagation()
        }
    
    @DOM override var body: DOM.Content {
        /// Keep the channel recognizable while giving the message content
        /// the majority of the card width.
        Div {
            Img()
                .src(self.$icon)
                .hidden(self.$socialIcon.map{ !$0.isEmpty })
                .class(Class(TCWorkDashboardClass.messageChannelIcon))

            Img()
                .src(self.$socialIcon)
                .hidden(self.$socialIcon.map{ $0.isEmpty })
                .class(Class(TCWorkDashboardClass.messageChannelIcon))

            Span(self.$chatNick)
                .hidden(self.$socialIcon.map{ !$0.isEmpty })
                .class(.oneLineText, Class(TCWorkDashboardClass.messageFolio))
        }
        .class(Class(TCWorkDashboardClass.messageChannel))
        
        Div {
            Div {
                Div(self.displayName)
                    .class(.oneLineText, Class(TCWorkDashboardClass.messageSender))

                Div(self.$lastMessageAtText)
                    .class(.oneLineText, Class(TCWorkDashboardClass.messageTime))
            }
            .class(Class(TCWorkDashboardClass.messageHeader))
            
            Div(self.$activity.map{ $0.replace(from: "\n", to: "") })
                .class(Class(TCWorkDashboardClass.messagePreview))
        }
        .class(Class(TCWorkDashboardClass.messageContent))

        self.closeIcon
        
    }
    
    override func buildUI() {
        
        super.buildUI()
        self.class(Class(TCWorkDashboardClass.messageCard))
        cursor(.pointer)
        onClick {
            self.callback(self.data)
        }
        onMouseOver {
            self.isFoccused = true
        }
        onMouseLeave {
            self.isFoccused = false
        }
        
        $status.listen {
            switch $0 {
            case .new:
                self.icon = "/skyline/media/mail.png"
            case .viewed:
                self.icon = "/skyline/media/mail_open.png"
            case .replied:
                self.icon = "/skyline/media/mail_open.png"
            case .filed:
                self.icon = "/skyline/media/mail_open.png"
            }
        }
        
        $lastMessageAt.listen {
            self.lastMessageAtText = orderTimeMesure(uts: $0, type: .createdAt).timeString
        }
        
        switch self.data.subType{
        case .sale, .order:
            self.chatNick = self.data.folio
            if self.data.folio.contains("-"){
                if let folio = self.data.folio.explode("-").last {
                    self.chatNick = folio
                }
            }
            
        case .chat:
            break
        case .account:
            break
        case .merca:
            break
        case .ebay:
            break
        case .amz:
            break
        case .facebook, .instagram, .twitter, .telegram, .whatsapp:
            
            socialIcon = "/skyline/media/scicon_\(self.data.subType.rawValue).jpg"
            
            self.chatNick = self.data.name
            
        }
        
        self.lastMessageAt = self.data.lastMessageAt
        
        self.activity = self.data.activity
        
        self.status = self.data.status
        
        refreshRelativeTime()
        
    }
    
    func refreshRelativeTime() {
        self.lastMessageAtText = orderTimeMesure(uts: lastMessageAt, type: .createdAt).timeString
    }
    

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $icon.removeAllListeners()
        $chatNick.removeAllListeners()
        $socialIcon.removeAllListeners()
        $lastMessageAt.removeAllListeners()
        $lastMessageAtText.removeAllListeners()
        $activity.removeAllListeners()
        $status.removeAllListeners()
        $isFoccused.removeAllListeners()
    }
}
