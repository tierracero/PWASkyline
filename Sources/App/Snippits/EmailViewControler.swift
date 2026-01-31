//
//  EmailViewControler.swift
//  
//
//  Created by Victor Cantu on 2/18/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import Web

class EmailViewControler: Div {
    
    override class var name: String { "div" }
    
    /// minimized, default, maximized
    @State var mode: ViewMode
    
    private var switchMode: ((
        _ mode: ViewMode
    ) -> ())
    
    init(
        mode: ViewMode,
        switchMode: @escaping ((
            _ mode: ViewMode
        ) -> ())
    ) {
        self.mode = mode
        self.switchMode = switchMode
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var profiles: [String] = []
    
    var defaultBoxes = ["INBOX", "INBOX.Sent", "INBOX.Trash", "INBOX.spam"]
    
    var newEmailsCount = 0
    
    var loaded = false
    
    @State var currentUser = ""
    
    @State var newEmails = "0"
    
    @State var totalEmails = 0
    
    @State var currentBox: String = "INBOX"
    
    @State var emailBoxRefecne: [String:EmailBoxView] = [:]
    
    /// mailBoxes name :
    @State var emailListRefrence: [String:[EmailQuickView]] = [:]
    
    lazy var foldersView = Div()
        .height(100.percent)
        .width(100.percent)
        .overflow(.auto)
    
    lazy var emailsView = Div()
        .hidden(self.$totalEmails.map{ $0 == 0 })
        .height(100.percent)
        .width(100.percent)
        .overflow(.auto)
    
    lazy var noEmailsView = Table().noResult(label: "- 📭 Sin Correos -")
    
    lazy var mailSelect = Select(self.$currentUser)
        .hidden(self.$profiles.map{ $0.count < 2 })
        .class(.textFiledBlackDark)
        .marginTop(3.px)
        .width(300.px)
        .maxWidth(50.percent)
        .height(31.px)
        .float(.left)
        .onChange {
            WebApp.current.window.localStorage.set(self.currentUser, forKey: "selectesMail_\(custCatchUser)")
            self.loadView()
        }
    
    lazy var mailLoadingView = Div{
        Table().noResult(label: "📨 Cargando...")
    }
    .backgroundColor(.transparentBlack)
    .position(.absolute)
    .height(100.percent)
    .borderRadius(12.px)
    .width(100.percent)
    .top(0.px)
    
    @DOM override var body: DOM.Content {
        /// header
        Div {
            
            Img()
                .src(self.$mode.map{ ($0 == .minimized || $0 == .default) ? "skyline/media/maximizeWindow.png" :  "skyline/media/lowerWindow.png"  })
                .hidden(self.$mode.map{ $0 == .default }) // FIX - 190223
                .class(.iconWhite)
                .marginRight(7.px)
                .cursor(.pointer)
                .marginTop(3.px)
                .float(.right)
                .width(24.px)
                .onClick {
                    switch self.mode{
                    case .minimized:
                        self.mode = .default
                    case .default:
                        self.mode = .maximized
                    case .maximized:
                        self.mode = .default
                    }
                    
                    self.switchMode(self.mode)
                    
                }
            
            Img()
                .hidden(self.$mode.map{ $0 == .minimized })
                .src("skyline/media/minizeView.png")
                .class(.iconWhite)
                .marginRight(12.px)
                .cursor(.pointer)
                .marginTop(3.px)
                .float(.right)
                .width(24.px)
                .onClick {
                    self.mode = .minimized
                    self.switchMode(self.mode)
                }
            
            Strong("|")
                .marginRight(12.px)
                .fontSize(24.px)
                .color(.white)
                .float(.right)
            
            Img()
                .src("skyline/media/newMail.png")
                .class(.iconWhite)
                .marginRight(12.px)
                .cursor(.pointer)
                .marginTop(3.px)
                .float(.right)
                .width(24.px)
                .onClick {
                    
                    var senderName = custCatchUser

                    if self.currentUser.contains("ventas@"){
                        senderName = "VENTAS \(senderName)"
                    }
                    else if self.currentUser.contains("pagos@"){
                        senderName = "PAGOS \(senderName)"
                    }
                    else if self.currentUser.contains("operaciones@"){
                        senderName = "OPERACIONES \(senderName)"
                    }
                    
                    let view = EmailCompose(
                        uid: nil,
                        subject: "",
                        sender: .init(
                            personal: senderName,
                            email: self.currentUser
                        ),
                        recipients: []
                    )
                    
                    addToDom(view)
                    
                }
            
            Img()
                .src("/skyline/media/icon-mail.png")
                .marginRight(7.px)
                .marginLeft(3.px)
                .marginTop(3.px)
                .width(28.px)
                .float(.left)
            
            H2(self.$currentUser)
                .hidden(self.$profiles.map{ $0.count > 1 })
                .color(.white)
                .float(.left)
            
            self.mailSelect

            Div{
                Table{
                    Tr{
                        Td(self.$newEmails)
                            .borderSpacing(all:0.px)
                            .verticalAlign(.middle)
                            .fontSize(14.px)
                            .align(.center)
                            .color(.white)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            //.hidden(self.$newEmails.map{ $0 == "0" })
            .hidden(self.$mode.map{ $0 == .default })
            .backgroundColor(.red)
            .borderRadius(12.px)
            .marginLeft(7.px)
            .marginTop(2.px)
            .minWidth(24.px)
            .height(24.px)
            .float(.left)
            
            Div().class(.clear)
        }
        
        Div().class(.clear)
        
        Div{
            Div{
                Div {
                    self.foldersView
                }
                .custom("height", "calc(100% - 7px)")
                .margin(all: 3.px)
                
            }
            .height(100.percent)
            .width(35.percent)
            .float(.left)
            
            Div{
                Div{
                    
                    self.emailsView
                    
                    self.noEmailsView
                    
                }
                .custom("height", "calc(100% - 7px)")
                .margin(all: 3.px)
            }
            .height(100.percent)
            .width(65.percent)
            .float(.left)
            
        }
        .custom("height", "calc(100% - 37px)")
        .marginTop(1.px)
        
        self.mailLoadingView
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        backgroundColor(.grayBlack)
        position(.relative)
        borderRadius(12.px)
        height(100.percent)
        width(100.percent)
        
        $mode.listen {
            WebApp.current.window.localStorage.set( JSString($0.rawValue), forKey: "EmailControlerViewMode")
            self.switchMode($0)
        }
        
        mode = ViewMode(rawValue: (WebApp.current.window.localStorage.string(forKey: "EmailControlerViewMode") ?? "")) ?? .minimized
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func loadView() {
        
        self.mailLoadingView.display(.block)
        
        if !loaded {
            
            let current = WebApp.current.window.localStorage.string(forKey: "selectesMail_\(custCatchUser)") ?? ""
            
            if !current.isEmpty{
                currentUser = current
            }
            else {
                WebApp.current.window.localStorage.set(custCatchUser, forKey: "selectesMail_\(custCatchUser)")
                currentUser = custCatchUser
            }
            
            profiles.append(custCatchUser)
            
            mailSelect.appendChild(
                Option(custCatchUser)
                    .value(custCatchUser)
            )
            
            if linkedProfile.contains(.bizMailVentas) {
                profiles.append("ventas@\(custCatchUrl)")
                
                let option = Option("ventas@\(custCatchUrl)")
                    .value("ventas@\(custCatchUrl)")
                
                if currentUser == "ventas@\(custCatchUrl)" {
                    option.selected(true)
                }
                
                mailSelect.appendChild(option)
            }
            
            if linkedProfile.contains(.bizMailPagos) {
                profiles.append("pagos@\(custCatchUrl)")
                
                let option = Option("pagos@\(custCatchUrl)")
                    .value("pagos@\(custCatchUrl)")
                
                if currentUser == "pagos@\(custCatchUrl)" {
                    option.selected(true)
                }
                
                mailSelect.appendChild(option)
            }
            
            if linkedProfile.contains(.bizMailOperaciones) {
                profiles.append("operaciones@\(custCatchUrl)")
                
                let option = Option("operaciones@\(custCatchUrl)")
                    .value("operaciones@\(custCatchUrl)")
                
                if currentUser == "operaciones@\(custCatchUrl)" {
                    option.selected(true)
                }
                
                mailSelect.appendChild(option)
            }
            
            if profiles.count == 1 {
                currentUser = custCatchUser
            }
            
            loaded = true
            
        }
        
        self.foldersView.innerHTML = ""
        
        self.emailBoxRefecne.removeAll()
         
        emailListRefrence.forEach { _, views in
            for view in views {
                view.remove()
            }
        }
        
        emailListRefrence.removeAll()
        
        self.mailLoadingView.display(.block)
        
        API().mailV1.boxes(username: currentUser) { resp in
            
            guard let resp else {
                return
            }
            
            guard resp.status == .ok else {
                return
            }
            
            guard let items = resp.data else {
                return
            }
            
            self.defaultBoxes.forEach { box in
                
                let view = EmailBoxView(
                    item: .init(
                        name: box,
                        delimiter: ".",
                        attributes: 32
                    ),
                    count: 0,
                    currentBox: self.$currentBox
                )
                    .onClick {
                        self.switchMailBox(box: box)
                    }
                
                self.foldersView.appendChild(view)
                
                self.emailBoxRefecne[box] = view
            }
            
            items.forEach { box in
                
                if !self.defaultBoxes.contains(box.name) {
                    
                    let view = EmailBoxView(
                        item: .init(
                         name: box.name,
                         delimiter: box.delimiter,
                         attributes: box.attributes
                        ),
                        count: 0,
                        currentBox: self.$currentBox
                    )
                        .onClick {
                            self.switchMailBox(box: box.name)
                        }
                    
                    self.foldersView.appendChild(view)
                    
                    self.emailBoxRefecne[box.name] = view
                }
            }
            
            self.loadBox(box: "INBOX")
            
        }
       
    }
    
    func loadBox(box: String) {
        
        if self.emailListRefrence[box] == nil {
            self.emailListRefrence[box] = []
        }
        
        self.mailLoadingView.display(.block)
        
        API().mailV1.box(username: currentUser, box: box) { resp in
            
            self.mailLoadingView.display(.none)
            
            guard let resp else {
                return
            }
            guard resp.status == .ok else {
                return
            }
            guard let items = resp.data else {
                return
            }
            
            self.currentBox = box
            
            var newMessages = 0
            
            self.totalEmails = items.count
            
            items.forEach { item in
                
                let view = EmailQuickView(item: item) {
                    
                    loadingView(show: true)
                    
                    API().mailV1.open(
                        username: self.currentUser,
                        box: box,
                        uid: item.uid
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            print("❌ 001")
                            return
                        }
                        
                        guard resp.status == .ok else {
                            print("❌ 002")
                            return
                        }
                        
                        guard let payload = resp.data else {
                            print("❌ 003")
                            return
                        }

                        let view = EmailFullView(
                            subject: item.subject,
                            box: box,
                            uid: item.uid,
                            header: payload.header,
                            mailBody: payload.body,
                            attachment: payload.attachment) {
                                /// ``🗑 Delete``
                                self.deleteEmail(box: box, UIDs: [item.uid])
                            } replyMail: {
                                /// Reply
                                /*
                                 MessagePreview
                                 
                                 msgno: Int,
                                 uid: Int,
                                 seen: Bool,
                                 flagged: Bool,
                                 answered: Bool,
                                 recivedAt: Int64,
                                 to: String,
                                 from: String,
                                 subject: String,
                                 attachments: Int
                                */
                                
                                /// `Set Sender from Original Recipiant`
                                
                                var senderName = ""
                                var senderEmail = ""
                                
                                if item.to.contains("<") {
                                    let parts = item.to.explode("<")
                                    
                                    guard let name = parts.first?.purgeSpaces else{
                                        return
                                    }
                                    
                                    guard var email = parts.last?.purgeSpaces else{
                                        return
                                    }
                                    
                                    email = email.replace(from: ">", to: "")
                                    
                                    senderName = name
                                    
                                    if email.contains("ventas@"){
                                        senderName = "VENTAS \(senderName)"
                                    }
                                    else if email.contains("pagos@"){
                                        senderName = "PAGOS \(senderName)"
                                    }
                                    else if email.contains("operaciones@"){
                                        senderName = "OPERACIONES \(senderName)"
                                    }
                                    
                                    senderEmail = email
                                    
                                }
                                else if item.to.contains("@") {
                                    
                                    if item.to.contains("ventas@"){
                                        senderName = "VENTAS \(senderName)"
                                    }
                                    else if item.to.contains("pagos@"){
                                        senderName = "PAGOS \(senderName)"
                                    }
                                    else if item.to.contains("operaciones@"){
                                        senderName = "OPERACIONES \(senderName)"
                                    }
                                    
                                    
                                    senderEmail = item.to
                                }
                                    
                                guard !senderEmail.isEmpty else{
                                    showError(.generalError, "No se localizo usuario enviador.")
                                    return
                                }
                                
                                let sender: EmailCompose.EmailAddress = .init(personal: senderName, email: senderEmail)
                                
                                var recipiantName = ""
                                var recipiantEmail = ""
                                
                                if item.from.contains("<") {
                                    let parts = item.from.explode("<")
                                    
                                    guard let name = parts.first?.purgeSpaces else {
                                        return
                                    }
                                    
                                    guard var email = parts.last?.purgeSpaces else {
                                        return
                                    }
                                    
                                    email = email.replace(from: ">", to: "")
                                    
                                    recipiantName = name
                                    
                                    recipiantEmail = email
                                    
                                }
                                else if item.from.contains("@") {
                                    recipiantEmail = item.from
                                }
                                    
                                guard !recipiantEmail.isEmpty else{
                                    showError(.generalError, "No se localizo usuario enviador.")
                                    return
                                }
                                
                                let recipients: [EmailCompose.EmailAddress] = [
                                    .init(personal: recipiantName, email: recipiantEmail)
                                ]
                                
                                let view = EmailCompose(
                                    uid: item.uid,
                                    subject: "RE: \(item.subject)",
                                    sender: sender,
                                    recipients: recipients
                                )
                                
                                addToDom(view)
                                
                            }

                        addToDom(view)
                        
                    }
                }
                
                self.emailsView.appendChild(view)
                
                self.emailListRefrence[box]?.append(view)
                
                if !item.seen {
                    newMessages += 1
                }
                
            }
            
            if box == "INBOX" {
                self.newEmailsCount = newMessages
                self.newEmails = newMessages.toString
                self.emailBoxRefecne["INBOX"]?.count = newMessages
            }
            
        }
    }
    
    func deleteEmail(box: String, UIDs:[Int]) {
        
        if let views = emailListRefrence[box] {
            
            views.forEach { view in
                if UIDs.contains(view.item.uid)  {
                    view.remove()
                }
            }
            
        }
    }
    
    func switchMailBox(box: String){
        /// emailListRefrence
        /// loadBox
        
        if box == currentBox {
            /// requested box is current box
            print("✉️ Same Inbox")
            return
        }
        
        self.emailsView.innerHTML = ""
        
        if let items = emailListRefrence[box] {
            /// 📥 Found in catch
            items.forEach { view in
                self.emailsView.appendChild(view)
            }
            
            currentBox = box
            
            return
        }
        
        loadBox(box: box)
        
    }
}

extension EmailViewControler {
    /// minimized, default, maximized
    public enum ViewMode: String, Codable {
        case minimized
        case `default`
        case maximized
    }
}
