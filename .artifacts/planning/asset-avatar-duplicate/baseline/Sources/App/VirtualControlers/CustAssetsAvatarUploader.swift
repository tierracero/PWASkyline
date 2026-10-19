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

    private var availableImages: [MediaViewer.MediaFile]

    private var images: [MediaViewer.MediaFile] = []

    private var selectedImageIndex = 0

    @State private var selectedImageSource = ""

    @State private var uploadPercent: String? = nil

    private lazy var fileLoader = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"])
        .hidden(true)

    private lazy var avatarImage = Img()
        .src(self.$selectedImageSource)
        .attribute("alt", "Imagen del activo")
        .width(100.percent)
        .height(100.percent)
        .objectFit(.contain)
        .cursor(.pointer)
        .onClick { self.openMediaViewer() }

    private lazy var imageDots = Div()
        .display(.flex)
        .custom("justify-content", "center")
        .custom("gap", "10px")
        .width(148.px)
        .custom("max-width", "100%")

    init(
        avatar: State<String>,
        destination: ImagePickerTo,
        itemId: UUID? = nil,
        images: [MediaViewer.MediaFile] = []
    ) {
        self.avatar = avatar
        self.destination = destination
        self.itemId = itemId
        self.availableImages = images.filter { $0.type == .image && !$0.file.purgeSpaces.isEmpty }
        super.init()
        refreshImages()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @DOM override var body: DOM.Content {
        self.fileLoader

        Div {

            Img()
                .src("/skyline/media/upload2.png")
                .cursor(.pointer)
                .float(.right)
                .height(22.px)
                .onClick {
                    self.fileLoader.click()
                }

            Div("Avatar")
                .fontWeight(.bold)

        }

        Div {

            self.avatarImage

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
            .align(.center)       
            .left(0.px)
            .top(0.px)
            .hidden(self.$uploadPercent.map { $0 == nil })
            
        }
        .custom("border", "1px solid rgba(19, 60, 82, 0.68)")
        .custom("background", "rgba(3, 18, 32, 0.68)")
        .custom("max-width", "100%")
        .borderRadius(all: 7.percent)
        .position(.relative)
        .overflow(.hidden)
        .cursor(.pointer)
        .display(.flex)
        .height(148.px)
        .width(148.px)

        self.imageDots
    }

    override func buildUI() {
        super.buildUI()

        display(.flex)
        custom("flex-direction", "column")
        custom("gap", "8px")

        fileLoader.$files.listen {
            $0.forEach { self.loadMedia($0) }
        }

        avatar.listen { [weak self] _ in
            guard let self, self.isInDOM else { return }
            self.refreshImages()
        }

        WebApp.current.wsevent.listen { [weak self] in
            guard let self, self.isInDOM else { return }
            
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
                self.updateAvatar(payload.avatar, fileName: payload.fileName)

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
        $selectedImageSource.removeAllListeners()
    }

    private func loadMedia(_ file: File) {
        uploadTripAvatar(
            file: file,
            eventId: viewId,
            id: itemId,
            to: destination,
            progress: { [weak self] value in
                guard let self, self.isInDOM else { return }
                self.uploadPercent = value
            },
            completed: { [weak self] value in
                guard let self, self.isInDOM else { return }
                self.updateAvatar(value)
            }
        )
    }

    private func updateAvatar(_ value: String, fileName: String? = nil) {
        if let fileName, !fileName.purgeSpaces.isEmpty {
            availableImages.removeAll { self.source(for: $0.file) == self.source(for: fileName) }
            availableImages.insert(
                .init(fileId: nil, file: fileName, avatar: value, type: .image),
                at: 0
            )
        }
        avatar.wrappedValue = value
        refreshImages()
    }

    private func refreshImages() {
        images = availableImages
        let avatarName = avatar.wrappedValue.purgeSpaces

        if !avatarName.isEmpty {
            let avatarSource = source(for: avatarName)
            if let index = images.firstIndex(where: {
                source(for: $0.file) == avatarSource || source(for: $0.avatar) == avatarSource
            }) {
                let avatarImage = images.remove(at: index)
                images.insert(avatarImage, at: 0)
            } else {
                images.insert(
                    .init(fileId: nil, file: avatarName, avatar: avatarName, type: .image),
                    at: 0
                )
            }
        }

        selectedImageIndex = 0
        selectedImageSource = images.first.map {
            source(for: $0.avatar.isEmpty ? $0.file : $0.avatar)
        } ?? source(for: "")
        renderDots()
    }

    private func selectImage(at index: Int) {
        guard images.indices.contains(index) else { return }
        selectedImageIndex = index
        let image = images[index]
        selectedImageSource = source(for: image.avatar.isEmpty ? image.file : image.avatar)
        renderDots()
    }

    private func renderDots() {
        imageDots.innerHTML = ""
        for (index, _) in images.prefix(5).enumerated() {
            let isSelected = index == selectedImageIndex
            imageDots.appendChild(
                Button()
                    .attribute("type", "button")
                    .attribute("aria-label", "Ver imagen \(index + 1)")
                    .attribute("aria-pressed", isSelected ? "true" : "false")
                    .width(12.px)
                    .height(12.px)
                    .padding(all: 0.px)
                    .borderRadius(all: 50.percent)
                    .backgroundColor(isSelected ? .init(r: 36, g: 185, b: 232) : .init(r: 37, g: 44, b: 59))
                    .custom("border", "1px solid rgba(102, 184, 236, 0.55)")
                    .cursor(.pointer)
                    .onClick { self.selectImage(at: index) }
            )
        }
    }

    private func openMediaViewer() {
        guard uploadPercent == nil, images.indices.contains(selectedImageIndex) else { return }
        let files = images.map {
            MediaViewer.MediaFile(
                fileId: $0.fileId,
                file: source(for: $0.file),
                avatar: source(for: $0.avatar.isEmpty ? $0.file : $0.avatar),
                type: $0.type
            )
        }
        addToDom(
            MediaViewer(
                relid: itemId,
                type: .content,
                url: "",
                files: files,
                currentView: selectedImageIndex,
                allowsMediaActions: false
            ),
            presentation: .interactive
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
