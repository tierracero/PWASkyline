//
// CustAssetsAvatarUploader.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class CustAssetsAvatarUploader: Div {

    override class var name: String { "div" }

    let ws = WS()
    
    let viewId: UUID = .init()

    private let avatar: State<String>

    private let destination: ImagePickerTo
    
    private let itemId: UUID?

    @State private var uploadPercent: String? = nil

    private lazy var fileLoader = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"])
        .hidden(true)

    private lazy var avatarImage = Img()
        .src(self.avatar.map { self.source(for: $0) })
        .width(126.px)
        .height(126.px)
        .objectFit(.contain)
        .cursor(.pointer)

    init(
        avatar: State<String>,
        destination: ImagePickerTo,
        itemId: UUID? = nil
    ) {
        self.avatar = avatar
        self.destination = destination
        self.itemId = itemId
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @DOM override var body: DOM.Content {
        self.fileLoader

        Div("Avatar")
            .fontWeight(.bold)

        Div {
            self.avatarImage

            Img()
                .src("/skyline/media/upload2.png")
                .height(30.px)
                .position(.absolute)
                .right(6.px)
                .bottom(6.px)
                .cursor(.pointer)

            Div {
                Table {
                    Tr {
                        Td(self.$uploadPercent.map { $0 ?? "" })
                            .verticalAlign(.middle)
                            .fontSize(16.px)
                            .align(.center)
                            .color(.white)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            .backgroundColor(.init(r: 0, g: 0, b: 0, a: 0.58))
            .borderRadius(all: 12.percent)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .overflow(.hidden)            
            .left(0.px)
            .top(0.px)
            .hidden(self.$uploadPercent.map { $0 == nil })
            
        }
        .custom("border", "1px solid rgba(19, 60, 82, 0.68)")
        .custom("background", "rgba(3, 18, 32, 0.68)")
        .custom("justify-content", "center")
        .custom("align-items", "center")
        .custom("align-self", "center")
        .custom("max-width", "100%")
        .borderRadius(all: 7.percent)
        .position(.relative)
        .cursor(.pointer)
        .display(.flex)
        .height(148.px)
        .width(148.px)
        .onClick {
            self.fileLoader.click()
        }
    }

    override func buildUI() {
        super.buildUI()

        display(.flex)
        custom("flex-direction", "column")
        custom("gap", "8px")

        fileLoader.$files.listen {
            $0.forEach { self.loadMedia($0) }
        }

        WebApp.current.wsevent.listen {
            
            guard !$0.isEmpty else { return }

            let (event, _) = self.ws.recive($0)

            guard let event else { return }

            switch event {
            case .asyncFileUpload:
                guard let payload = self.ws.asyncFileUpload($0),
                      payload.eventid == self.viewId else {
                    return
                }

                self.uploadPercent = nil
                self.avatar.wrappedValue = payload.avatar

            case .asyncFileUpdate:
                guard let payload = self.ws.asyncFileUpdate($0),
                      payload.eventId == self.viewId else {
                    return
                }

                self.uploadPercent = payload.message

            default:
                break
            }
        }
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        fileLoader.$files.removeAllListeners()
        $uploadPercent.removeAllListeners()
    }

    private func loadMedia(_ file: File) {
        uploadTripAvatar(
            file: file,
            eventId: viewId,
            id: itemId,
            to: destination,
            progress: { self.uploadPercent = $0 },
            completed: { self.avatar.wrappedValue = $0 }
        )
    }

    private func source(for value: String) -> String {
        let value = value.purgeSpaces

        guard !value.isEmpty else {
            return "/skyline/media/tierraceroRoundLogoWhite.svg"
        }

        guard !value.hasPrefix("/") && !value.hasPrefix("http://") && !value.hasPrefix("https://") else {
            return value
        }

        return destination.url(
            url: custCatchUrl,
            pDir: pDir,
            isPreRegistration: itemId == nil,
            accountType: custCatchAccountType
        ) + value
    }
}
