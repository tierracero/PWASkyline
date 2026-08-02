//
//  SpeechRecognitionManager.swift
//

import Foundation
import JavaScriptKit
import Web

protocol SpeechRecognitionTarget: AnyObject {
    func speechRecognitionDidReceiveInterimText(_ text: String)
    func speechRecognitionDidReceiveFinalText(_ text: String)
}

final class SpeechRecognitionManager {

    static let shared = SpeechRecognitionManager()

    enum State: Equatable {
        case unavailable
        case idle
        case starting
        case listening
        case stopping
        case error
    }

    enum RecognitionError: Error, Equatable {
        case unsupported
        case bridgeUnavailable
        case microphonePermissionDenied
        case noSpeech
        case audioCapture
        case unableToStart
        case browser(code: String, message: String)

        var userMessage: String {
            switch self {
            case .unsupported:
                return "El reconocimiento de voz no está disponible en este navegador. Puedes continuar escribiendo normalmente."
            case .bridgeUnavailable:
                return "El dictado por voz todavía no está disponible. Intenta nuevamente en un momento."
            case .microphonePermissionDenied:
                return "No se pudo acceder al micrófono. Verifica el permiso del micrófono en la configuración del navegador."
            case .noSpeech:
                return "No se detectó voz. Intenta nuevamente cuando estés listo."
            case .audioCapture:
                return "No se encontró un micrófono disponible para iniciar el dictado."
            case .unableToStart:
                return "No fue posible iniciar el dictado por voz. Intenta nuevamente."
            case .browser(_, let message):
                return message.isEmpty
                    ? "No fue posible continuar con el reconocimiento de voz."
                    : message
            }
        }
    }

    private struct BridgeEvent: Decodable {
        let type: String
        let state: String
        let finalText: String
        let interimText: String
        let errorCode: String
        let message: String
    }

    private weak var activeTarget: SpeechRecognitionTarget?
    private var eventClosure: JSClosure?
    private var onInterimResult: ((String) -> Void)?
    private var onFinalResult: ((String) -> Void)?
    private var onStateChange: ((State) -> Void)?
    private var onError: ((RecognitionError) -> Void)?
    private var didReceiveEventForCurrentSession = false
    private(set) var state: State = .unavailable

    private init() {}

    var isSupported: Bool {
        guard
            let bridge = bridge,
            let function = bridge["isSupported"].function
        else {
            return false
        }

        return function
            .callAsFunction(optionalThis: bridge)?.boolean ?? false
    }

    var isListening: Bool {
        guard
            let bridge = bridge,
            let function = bridge["isListening"].function
        else {
            return false
        }

        return function
            .callAsFunction(optionalThis: bridge)?.boolean ?? false
    }

    @discardableResult
    func speak(
        _ message: String,
        language: String = "es-MX",
        rate: Double = 1,
        pitch: Double = 1
    ) -> Bool {
        guard
            let bridge = bridge,
            let speak = bridge["speak"].function
        else {
            return false
        }

        let options: [String: JSValue] = [
            "language": .string(language),
            "rate": .number(rate),
            "pitch": .number(pitch)
        ]

        return speak.callAsFunction(
            optionalThis: bridge,
            arguments: [message, options.jsValue]
        )?.boolean ?? false
    }

    func stopSpeaking() {
        guard
            let bridge = bridge,
            let stopSpeaking = bridge["stopSpeaking"].function
        else {
            return
        }

        _ = stopSpeaking.callAsFunction(optionalThis: bridge)
    }

    func setActiveTarget(_ target: SpeechRecognitionTarget) {
        activeTarget = target
    }

    func clearActiveTarget(_ target: SpeechRecognitionTarget) {
        guard activeTarget === target else { return }
        activeTarget = nil
    }

    func start(
        language: String = "es-MX",
        onInterimResult: @escaping (String) -> Void,
        onFinalResult: @escaping (String) -> Void,
        onStateChange: @escaping (State) -> Void,
        onError: @escaping (RecognitionError) -> Void
    ) {
        guard
            let bridge = bridge,
            let start = bridge["start"].function
        else {
            transition(to: .unavailable, notifying: onStateChange)
            onError(.bridgeUnavailable)
            return
        }

        guard isSupported else {
            transition(to: .unavailable, notifying: onStateChange)
            onError(.unsupported)
            return
        }

        releaseSessionCallbacks()
        self.onInterimResult = onInterimResult
        self.onFinalResult = onFinalResult
        self.onStateChange = onStateChange
        self.onError = onError
        didReceiveEventForCurrentSession = false

        eventClosure = JSClosure { [weak self] values in
            guard let payload = values.first?.string else {
                self?.receive(error: .browser(
                    code: "invalid-event",
                    message: "El navegador devolvió una respuesta de dictado no válida."
                ))
                return .undefined
            }

            self?.receive(payload: payload)
            return .undefined
        }

        let options: [String: JSValue] = [
            "language": .string(language),
            "continuous": .boolean(false),
            "interimResults": .boolean(true),
            "maxAlternatives": .number(1)
        ]

        guard let eventClosure else {
            receive(error: .unableToStart)
            return
        }

        let didStart = start.callAsFunction(
            optionalThis: bridge,
            arguments: [options.jsValue, eventClosure]
        )?.boolean ?? false

        if !didStart {
            if !didReceiveEventForCurrentSession {
                receive(error: .unableToStart)
            }

            // The bridge has returned, so JavaScript can no longer invoke the
            // callback for a session that never started.
            releaseSessionCallbacks()
        }
    }

    func stop() {
        invokeBridgeMethod("stop")
    }

    func abort() {
        invokeBridgeMethod("abort")
    }

    func shutdown() {
        activeTarget = nil
        stopSpeaking()

        guard eventClosure != nil else {
            releaseSessionCallbacks()
            state = .unavailable
            return
        }

        abort()
    }

    func refreshAvailability() -> State {
        let newState: State = isSupported ? .idle : .unavailable
        state = newState
        return newState
    }

    private var bridge: JSObject? {
        JSObject.global.PWASkylineSpeech.object
    }

    private func invokeBridgeMethod(_ method: String) {
        guard
            let bridge = bridge,
            let function = bridge[method].function
        else {
            receive(error: .bridgeUnavailable)
            return
        }

        _ = function.callAsFunction(optionalThis: bridge)
    }

    private func receive(payload: String) {
        didReceiveEventForCurrentSession = true

        guard let data = payload.data(using: .utf8) else {
            receive(error: .browser(
                code: "invalid-event",
                message: "El navegador devolvió una respuesta de dictado no válida."
            ))
            return
        }

        do {
            let event = try JSONDecoder().decode(BridgeEvent.self, from: data)
            handle(event)
        } catch {
            receive(error: .browser(
                code: "invalid-event",
                message: "El navegador devolvió una respuesta de dictado no válida."
            ))
        }
    }

    private func handle(_ event: BridgeEvent) {
        switch event.type {
        case "state":
            let newState = state(from: event.state)
            transition(to: newState)

            if newState == .idle {
                // Let the current JavaScript callback return before releasing
                // its retained JSClosure. This avoids invalidating a host
                // function while WebAssembly is still executing inside it.
                Dispatch.async { [weak self] in
                    guard self?.state == .idle else { return }
                    self?.releaseSessionCallbacks()
                }
            }

        case "result":
            if !event.interimText.isEmpty {
                onInterimResult?(event.interimText)
                activeTarget?.speechRecognitionDidReceiveInterimText(event.interimText)
            }

            if !event.finalText.isEmpty {
                onFinalResult?(event.finalText)
                activeTarget?.speechRecognitionDidReceiveFinalText(event.finalText)
            }

        case "error":
            receive(error: recognitionError(
                code: event.errorCode,
                message: event.message
            ))

        default:
            receive(error: .browser(
                code: "unknown-event",
                message: "El navegador devolvió un evento de dictado desconocido."
            ))
        }
    }

    private func receive(error: RecognitionError) {
        transition(to: error == .unsupported ? .unavailable : .error)
        onError?(error)
    }

    private func transition(
        to newState: State,
        notifying callback: ((State) -> Void)? = nil
    ) {
        state = newState
        (callback ?? onStateChange)?(newState)
    }

    private func state(from value: String) -> State {
        switch value {
        case "idle": return .idle
        case "starting": return .starting
        case "listening": return .listening
        case "stopping": return .stopping
        case "error": return .error
        default: return .unavailable
        }
    }

    private func recognitionError(code: String, message: String) -> RecognitionError {
        switch code {
        case "unsupported":
            return .unsupported
        case "not-allowed", "service-not-allowed":
            return .microphonePermissionDenied
        case "no-speech":
            return .noSpeech
        case "audio-capture":
            return .audioCapture
        case "unable-to-start":
            return .unableToStart
        default:
            return .browser(code: code, message: message)
        }
    }

    private func releaseSessionCallbacks() {
        eventClosure = nil
        onInterimResult = nil
        onFinalResult = nil
        onStateChange = nil
        onError = nil
        didReceiveEventForCurrentSession = false
    }
}
