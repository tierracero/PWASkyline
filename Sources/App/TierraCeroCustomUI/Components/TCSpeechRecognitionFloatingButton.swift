//
//  TCSpeechRecognitionFloatingButton.swift
//

import Foundation
import Web

final class TCSpeechRecognitionFloatingButton: Div {

    override class var name: String { "div" }

    private static let assistantPreparationReply =
        "Tu módulo de IA está en preparación. Espéralo muy pronto."

    private let manager: SpeechRecognitionManager
    private let preview = Div()
    private let previewStatus = Span("Dictado por voz")
    private let finalText = Div()
    private let interimText = Div()
    private let clearButton = Button("×")
    private let speechButton = Button()
    private let aurora = Span()
    private let ring = Span()
    private let statusIndicator = Span()
    private let logo = Img()

    private var presentedState: SpeechRecognitionManager.State = .unavailable
    private var accumulatedFinalText = ""
    private var errorPresentationId = UUID()
    private var previewDismissId = UUID()
    private var assistantReplyId = UUID()
    private var isPresentingError = false
    private var didListenInCurrentSession = false

    init(manager: SpeechRecognitionManager = .shared) {
        self.manager = manager
        super.init()
    }

    required init() {
        self.manager = .shared
        super.init()
    }

    @DOM override var body: DOM.Content {
        preview
        speechButton
    }

    override func buildUI() {
        super.buildUI()

        TCSpeechRecognitionFloatingTheme.install()
        self.class(Class(TCSpeechRecognitionFloatingClass.root))

        configurePreview()
        configureButton()
        present(state: .unavailable)
    }

    func refreshAvailability() {
        isPresentingError = false
        present(state: manager.refreshAvailability())
    }

    override func shutdown() {
        previewDismissId = UUID()
        errorPresentationId = UUID()
        assistantReplyId = UUID()
        manager.shutdown()
        super.shutdown()
    }

    private func configurePreview() {
        preview
            .class(Class(TCSpeechRecognitionFloatingClass.preview))
            .attribute("role", "status")
            .attribute("aria-live", "polite")
            .display(.none)

        previewStatus.class(Class(TCSpeechRecognitionFloatingClass.previewStatus))
        finalText.class(Class(TCSpeechRecognitionFloatingClass.finalText))
        interimText.class(Class(TCSpeechRecognitionFloatingClass.interimText))

        clearButton
            .class(Class(TCSpeechRecognitionFloatingClass.clearButton))
            .attribute("type", "button")
            .attribute("aria-label", "Cerrar transcripción")
            .onClick { [weak self] in
                self?.clearPreview()
            }

        preview.appendChild(previewStatus)
        preview.appendChild(clearButton)
        preview.appendChild(finalText)
        preview.appendChild(interimText)
    }

    private func configureButton() {
        aurora.class(Class(TCSpeechRecognitionFloatingClass.aurora))
        ring.class(Class(TCSpeechRecognitionFloatingClass.ring))
        statusIndicator.class(Class(TCSpeechRecognitionFloatingClass.statusIndicator))
        logo
            .class(Class(TCSpeechRecognitionFloatingClass.logo))
            .src("/skyline/media/tierraceroRoundLogoWhite.svg")
            .alt("Tierra Cero")

        speechButton
            .class(Class(TCSpeechRecognitionFloatingClass.button))
            .attribute("type", "button")
            .attribute("aria-label", "Activar dictado por voz")
            .attribute("aria-pressed", "false")
            .attribute("title", "Activar dictado por voz")
            .onClick { [weak self] in
                self?.toggleRecognition()
            }

        speechButton.appendChild(aurora)
        speechButton.appendChild(ring)
        speechButton.appendChild(logo)
        speechButton.appendChild(statusIndicator)
    }

    private func toggleRecognition() {
        switch presentedState {
        case .idle, .unavailable, .error:
            startRecognition()
        case .listening:
            manager.stop()
        case .starting, .stopping:
            break
        }
    }

    private func startRecognition() {
        previewDismissId = UUID()
        errorPresentationId = UUID()
        assistantReplyId = UUID()
        isPresentingError = false
        didListenInCurrentSession = false
        accumulatedFinalText = ""
        _ = finalText.innerText("")
        _ = interimText.innerText("")
        preview.display(.block)

        manager.start(
            language: "es-MX",
            onInterimResult: { [weak self] text in
                self?.receiveInterim(text)
            },
            onFinalResult: { [weak self] text in
                self?.receiveFinal(text)
            },
            onStateChange: { [weak self] state in
                self?.receive(state: state)
            },
            onError: { [weak self] error in
                self?.receive(error: error)
            }
        )
    }

    private func receive(state: SpeechRecognitionManager.State) {
        if isPresentingError, state == .idle {
            completeListeningSession(replyAfter: 4.6)
            return
        }

        present(state: state)

        switch state {
        case .starting:
            _ = previewStatus.innerText("Preparando micrófono…")
            preview.display(.block)
        case .listening:
            didListenInCurrentSession = true
            _ = previewStatus.innerText("Escuchando…")
            preview.display(.block)
        case .stopping:
            _ = previewStatus.innerText("Finalizando dictado…")
        case .idle:
            if completeListeningSession() {
                return
            }

            _ = previewStatus.innerText(
                accumulatedFinalText.isEmpty ? "Dictado por voz" : "Transcripción lista"
            )
            schedulePreviewDismissal(after: accumulatedFinalText.isEmpty ? 1.4 : 5.0)
        case .unavailable:
            _ = previewStatus.innerText("Dictado no disponible")
        case .error:
            break
        }
    }

    private func receiveInterim(_ text: String) {
        _ = interimText.innerText(text)
        preview.display(.block)
    }

    private func receiveFinal(_ text: String) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return }

        accumulatedFinalText = append(cleanText, to: accumulatedFinalText)
        _ = finalText.innerText(accumulatedFinalText)
        _ = interimText.innerText("")
        preview.display(.block)
    }

    private func receive(error: SpeechRecognitionManager.RecognitionError) {
        let presentationId = UUID()
        errorPresentationId = presentationId
        isPresentingError = true

        present(state: error == .unsupported ? .unavailable : .error)
        _ = previewStatus.innerText("Dictado por voz")
        _ = finalText.innerText(error.userMessage)
        _ = interimText.innerText("")
        preview.display(.block)

        Dispatch.asyncAfter(4.5) { [weak self] in
            guard let self, self.errorPresentationId == presentationId else { return }
            self.isPresentingError = false
            self.present(state: self.manager.isSupported ? .idle : .unavailable)
            self.schedulePreviewDismissal(after: 2.5)
        }
    }

    private func present(state: SpeechRecognitionManager.State) {
        presentedState = state

        TCSpeechRecognitionFloatingClass.stateClasses.forEach {
            removeClass(Class($0))
        }
        self.class(Class(TCSpeechRecognitionFloatingClass.className(for: state)))

        let isActive = state == .starting || state == .listening || state == .stopping
        let label = state == .listening
            ? "Detener dictado por voz"
            : "Activar dictado por voz"

        speechButton
            .attribute("aria-label", label)
            .attribute("aria-pressed", isActive ? "true" : "false")
            .attribute("title", label)
    }

    private func clearPreview() {
        previewDismissId = UUID()
        assistantReplyId = UUID()
        manager.stopSpeaking()
        accumulatedFinalText = ""
        _ = finalText.innerText("")
        _ = interimText.innerText("")
        preview.display(.none)
    }

    @discardableResult
    private func completeListeningSession(replyAfter delay: Double = 0) -> Bool {
        guard didListenInCurrentSession else { return false }
        didListenInCurrentSession = false

        let replyId = UUID()
        assistantReplyId = replyId

        guard delay > 0 else {
            presentAssistantReply()
            return true
        }

        Dispatch.asyncAfter(delay) { [weak self] in
            guard let self, self.assistantReplyId == replyId else { return }
            self.presentAssistantReply()
        }
        return true
    }

    private func presentAssistantReply() {
        let reply = Self.assistantPreparationReply

        isPresentingError = false
        present(state: manager.isSupported ? .idle : .unavailable)
        _ = previewStatus.innerText("Respuesta de Tierra Cero IA")

        if accumulatedFinalText.isEmpty {
            _ = finalText.innerText(reply)
            _ = interimText.innerText("")
        } else {
            _ = interimText.innerText(reply)
        }

        preview.display(.block)
        _ = manager.speak(reply, language: "es-MX", rate: 0.96)
        schedulePreviewDismissal(after: 7.0)
    }

    private func schedulePreviewDismissal(after delay: Double) {
        let dismissalId = UUID()
        previewDismissId = dismissalId

        Dispatch.asyncAfter(delay) { [weak self] in
            guard
                let self,
                self.previewDismissId == dismissalId,
                self.presentedState != .starting,
                self.presentedState != .listening,
                self.presentedState != .stopping
            else {
                return
            }

            self.preview.display(.none)
        }
    }

    private func append(_ text: String, to existingText: String) -> String {
        guard !existingText.isEmpty else { return text }
        return existingText + (existingText.last?.isWhitespace == true ? "" : " ") + text
    }
}

private enum TCSpeechRecognitionFloatingClass {
    static let root = "tc-speech-floating"
    static let button = "tc-speech-button"
    static let aurora = "tc-speech-aurora"
    static let ring = "tc-speech-ring"
    static let logo = "tc-speech-logo"
    static let statusIndicator = "tc-speech-status-indicator"
    static let preview = "tc-speech-preview"
    static let previewStatus = "tc-speech-preview-status"
    static let finalText = "tc-speech-final-text"
    static let interimText = "tc-speech-interim-text"
    static let clearButton = "tc-speech-clear"
    static let idle = "tc-speech-idle"
    static let starting = "tc-speech-starting"
    static let listening = "tc-speech-listening"
    static let stopping = "tc-speech-stopping"
    static let error = "tc-speech-error"
    static let unavailable = "tc-speech-unavailable"

    static let stateClasses = [idle, starting, listening, stopping, error, unavailable]

    static func className(for state: SpeechRecognitionManager.State) -> String {
        switch state {
        case .idle: return idle
        case .starting: return starting
        case .listening: return listening
        case .stopping: return stopping
        case .error: return error
        case .unavailable: return unavailable
        }
    }
}

private enum TCSpeechRecognitionFloatingTheme {
    private static var isInstalled = false

    static func install() {
        guard !isInstalled else { return }
        isInstalled = true

        let root = ".\(TCSpeechRecognitionFloatingClass.root)"
        let button = "\(root) .\(TCSpeechRecognitionFloatingClass.button)"

        WebApp.current.addStylesheet {
            CSSRule(Pointer(root))
                .position(.fixed)
                .left(18.px)
                .bottom(18.px)
                .zIndex(1_000_000_000)
                .custom("left", "calc(18px + env(safe-area-inset-left))")
                .custom("bottom", "calc(18px + env(safe-area-inset-bottom))")
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("align-items", "flex-start")
                .custom("gap", "10px")
                .custom("pointer-events", "none")

            CSSRule(Pointer(button))
                .position(.relative)
                .width(72.px)
                .height(72.px)
                .padding(all: 0.px)
                .borderRadius(all: 50.percent)
                .custom("display", "grid")
                .custom("place-items", "center")
                .custom("overflow", "visible")
                .custom("border", "1px solid rgba(113, 204, 255, 0.52)")
                .custom("background", "radial-gradient(circle at center, rgba(8, 18, 29, 0.98), rgba(0, 0, 0, 1))")
                .custom("box-shadow", "0 0 0 1px rgba(255, 255, 255, 0.05) inset, 0 10px 28px rgba(0, 0, 0, 0.48), 0 0 24px rgba(20, 145, 255, 0.38)")
                .custom("pointer-events", "auto")
                .custom("isolation", "isolate")
                .custom("cursor", "pointer")
                .custom("transition", "transform 180ms ease, border-color 180ms ease, box-shadow 180ms ease, opacity 180ms ease")

            CSSRule(Pointer("\(button):hover"))
                .custom("transform", "translateY(-2px)")

            CSSRule(Pointer("\(button):focus-visible"))
                .custom("outline", "3px solid rgba(89, 193, 255, 0.56)")
                .custom("outline-offset", "4px")

            CSSRule(Pointer("\(button) .\(TCSpeechRecognitionFloatingClass.aurora)"))
                .position(.absolute)
                .custom("inset", "-13px")
                .borderRadius(all: 50.percent)
                .custom("background", "radial-gradient(circle at 25% 30%, rgba(20, 145, 255, 0.9), transparent 40%), radial-gradient(circle at 75% 70%, rgba(255, 113, 25, 0.82), transparent 43%), radial-gradient(circle at center, rgba(3, 8, 14, 0.98), rgba(0, 0, 0, 1))")
                .custom("filter", "blur(10px)")
                .custom("opacity", "0.78")
                .custom("z-index", "-2")
                .custom("animation", "tc-speech-aurora-drift 7s linear infinite")

            CSSRule(Pointer("\(button) .\(TCSpeechRecognitionFloatingClass.ring)"))
                .position(.absolute)
                .custom("inset", "-7px")
                .borderRadius(all: 50.percent)
                .custom("border", "1px solid rgba(73, 185, 245, 0.46)")
                .custom("opacity", "0.58")
                .custom("z-index", "-1")

            CSSRule(Pointer("\(button) .\(TCSpeechRecognitionFloatingClass.logo)"))
                .position(.relative)
                .width(43.px)
                .height(43.px)
                .custom("object-fit", "contain")
                .custom("z-index", "2")
                .custom("filter", "drop-shadow(0 2px 5px rgba(0, 0, 0, 0.68))")

            CSSRule(Pointer("\(button) .\(TCSpeechRecognitionFloatingClass.statusIndicator)"))
                .position(.absolute)
                .right(4.px)
                .bottom(5.px)
                .width(10.px)
                .height(10.px)
                .borderRadius(all: 50.percent)
                .custom("border", "2px solid rgba(3, 13, 23, 0.95)")
                .custom("background", "rgba(93, 151, 190, 0.9)")
                .custom("z-index", "3")

            CSSRule(Pointer("\(root).\(TCSpeechRecognitionFloatingClass.listening) \(button)"))
                .custom("border-color", "rgba(113, 214, 255, 0.9)")
                .custom("box-shadow", "0 12px 32px rgba(0, 0, 0, 0.52), 0 0 32px rgba(20, 145, 255, 0.72), 0 0 24px rgba(255, 113, 25, 0.44)")

            CSSRule(Pointer("\(root).\(TCSpeechRecognitionFloatingClass.listening) .\(TCSpeechRecognitionFloatingClass.ring)"))
                .custom("animation", "tc-speech-listening-pulse 1.45s ease-out infinite")

            CSSRule(Pointer("\(root).\(TCSpeechRecognitionFloatingClass.listening) .\(TCSpeechRecognitionFloatingClass.statusIndicator)"))
                .custom("background", "rgba(34, 197, 255, 1)")
                .custom("box-shadow", "0 0 10px rgba(34, 197, 255, 0.92)")

            CSSRule(Pointer("\(root).\(TCSpeechRecognitionFloatingClass.starting) \(button), \(root).\(TCSpeechRecognitionFloatingClass.stopping) \(button)"))
                .custom("cursor", "wait")
                .custom("opacity", "0.78")

            CSSRule(Pointer("\(root).\(TCSpeechRecognitionFloatingClass.error) \(button)"))
                .custom("border-color", "rgba(255, 100, 63, 0.86)")
                .custom("box-shadow", "0 0 26px rgba(255, 86, 45, 0.52)")

            CSSRule(Pointer("\(root).\(TCSpeechRecognitionFloatingClass.unavailable) \(button)"))
                .custom("opacity", "0.62")
                .custom("filter", "saturate(0.55)")
        }

        WebApp.current.addStylesheet {
            CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.preview)"))
                .position(.relative)
                .width(320.px)
                .maxWidth(82.vw)
                .padding(v: 12.px, h: 14.px)
                .custom("box-sizing", "border-box")
                .custom("border", "1px solid rgba(89, 178, 232, 0.34)")
                .custom("border-left", "3px solid rgba(73, 185, 245, 0.82)")
                .custom("border-radius", "14px")
                .custom("background", "linear-gradient(145deg, rgba(7, 31, 50, 0.88), rgba(3, 15, 28, 0.78))")
                .custom("box-shadow", "0 18px 48px rgba(0, 0, 0, 0.46), inset 0 1px 0 rgba(255, 255, 255, 0.05)")
                .custom("backdrop-filter", "blur(18px) saturate(135%)")
                .custom("-webkit-backdrop-filter", "blur(18px) saturate(135%)")
                .custom("pointer-events", "auto")
                .custom("color", "rgba(237, 247, 255, 1)")

            CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.previewStatus)"))
                .custom("display", "block")
                .custom("padding-right", "24px")
                .custom("color", "rgba(99, 203, 255, 1)")
                .custom("font-size", "12px")
                .custom("font-weight", "700")
                .custom("letter-spacing", "0.04em")

            CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.finalText)"))
                .custom("margin-top", "7px")
                .custom("font-size", "14px")
                .custom("font-weight", "600")
                .custom("line-height", "1.4")
                .custom("overflow-wrap", "anywhere")

            CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.interimText)"))
                .custom("margin-top", "5px")
                .custom("color", "rgba(171, 191, 208, 1)")
                .custom("font-size", "13px")
                .custom("font-style", "italic")
                .custom("line-height", "1.35")
                .custom("overflow-wrap", "anywhere")

            CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.clearButton)"))
                .position(.absolute)
                .right(8.px)
                .top(7.px)
                .width(24.px)
                .height(24.px)
                .padding(all: 0.px)
                .custom("border", "0")
                .custom("background", "transparent")
                .custom("color", "rgba(255, 137, 68, 1)")
                .custom("font-size", "20px")
                .custom("line-height", "22px")
                .custom("cursor", "pointer")

            MediaRule(.screen.maxWidth(700.px)) {
                CSSRule(Pointer(button))
                    .width(64.px)
                    .height(64.px)

                CSSRule(Pointer("\(button) .\(TCSpeechRecognitionFloatingClass.logo)"))
                    .width(38.px)
                    .height(38.px)

                CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.preview)"))
                    .width(286.px)
            }

            MediaRule(.all.prefersReducedMotion) {
                CSSRule(Pointer("\(root) .\(TCSpeechRecognitionFloatingClass.aurora), \(root) .\(TCSpeechRecognitionFloatingClass.ring)"))
                    .custom("animation", "none !important")

                CSSRule(Pointer(button))
                    .custom("transition", "none")
                    .custom("transform", "none !important")
            }

            Keyframes("tc-speech-aurora-drift")
                .from {
                    TransformProperty(.rotate(0))
                    OpacityProperty(0.66)
                }
                .to {
                    TransformProperty(.rotate(360))
                    OpacityProperty(0.9)
                }

            Keyframes("tc-speech-listening-pulse")
                .from {
                    TransformProperty(.scale(1, 1))
                    OpacityProperty(0.76)
                }
                .to {
                    TransformProperty(.scale(1.38, 1.38))
                    OpacityProperty(0)
                }
        }
    }
}
