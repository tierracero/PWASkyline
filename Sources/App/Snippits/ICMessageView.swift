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
    
    var smallChatIsOpen: State<Bool>
    
    private var callback: ((_ id: API.custAPIV1.LoadMessaging) -> ())
    
    init(
        data: API.custAPIV1.LoadMessaging,
        smallChatIsOpen: State<Bool>,
        callback: @escaping ((_ id: API.custAPIV1.LoadMessaging) -> ())
    ) {
        self.data = data
        self.smallChatIsOpen = smallChatIsOpen
        self.callback = callback
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
                
                guard let resp  else {
                    return
                }
                
                if resp.status != .ok {
                    self.remove()
                }
                
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
        .hidden(self.smallChatIsOpen.map{ !$0 })

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
            case .replied, .filed:
                print("will try to remove")
                self.remove()
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
        
        reCalculateTimeText()
        
    }
    
    func reCalculateTimeText() {
        
        self.lastMessageAtText = orderTimeMesure(uts: lastMessageAt, type: .createdAt).timeString
        
        let interval = getNow() - lastMessageAt
        
        var delay: Double = 0
        
        if interval <= 30 {
            delay = 30
        }
        else if interval > 30 && interval <= 300 {
            delay = 60
        }
        else if interval > 300 && interval <= 3600 {
            delay = 600
        }
        else if interval > 3600 && interval <= 86400 {
            delay = 3600
        }
        else if interval > 86400 {
            delay = 86400
        }
        
        Dispatch.asyncAfter( delay ) {
            self.reCalculateTimeText()
        }
        
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
