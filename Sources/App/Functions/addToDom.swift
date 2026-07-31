//
//  addToDom.swift
//  
//
//  Created by Victor Cantu on 9/25/22.
//

import Foundation
import JavaScriptKit
import Web
import DOM

enum SuperViewPresentation {
    case standard
    case interactive
}

final class SuperView: Div {

    override class var name: String { "div" }

    private let content: DOMElement?
    private let presentation: SuperViewPresentation
    private var cleanupScheduled = false

    #if arch(wasm32)
    private var contentObserver: JSValue?
    private var contentObserverClosure: JSClosure?
    #endif

    required init() {
        content = nil
        presentation = .standard
        super.init()
        configure()
    }

    init(
        content: DOMElement,
        presentation: SuperViewPresentation = .standard
    ) {
        self.content = content
        self.presentation = presentation
        super.init()

        configure()
        prepare(content)
        appendChild(content)
        observeContentLifecycle(content)
    }

    deinit {
        disconnectContentObserver()
        #if arch(wasm32) && JAVASCRIPTKIT_WITHOUT_WEAKREFS
        contentObserverClosure?.release()
        #endif
    }

    private func configure() {
        self.class(.transparantBlackBackGround)
        attribute("data-add-to-dom-super-view", "true")
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        opacity(0)
        custom("transition", "opacity 340ms ease-out")

        switch presentation {
        case .standard:
            attribute("data-super-view-presentation", "standard")
            custom("backdrop-filter", "blur(3px)")
            custom("-webkit-backdrop-filter", "blur(3px)")
        case .interactive:
            // Keep the established overlay darkening while avoiding a
            // full-viewport blur during high-frequency pointer interaction.
            attribute("data-super-view-presentation", "interactive")
            custom("backdrop-filter", "none")
            custom("-webkit-backdrop-filter", "none")
        }

        onDidAddToDOM { [weak self] in
            Web.Dispatch.async { [weak self] in
                guard let self, self.isInDOM else { return }

                self.opacity(1)
                if let content = self.content as? BaseElement {
                    content
                        .opacity(1)
                        .custom("translate", "0 0")
                }
            }
        }

        onDidRemoveFromDOM { [weak self] in
            self?.disconnectContentObserver()
        }
    }

    private func prepare(_ content: DOMElement) {
        guard let content = content as? BaseElement else { return }

        // The super view now owns the modal background. Removing this class
        // avoids stacking the legacy overlay color beneath it.
        content
            .removeClass(.transparantBlackBackGround)
            .opacity(0)
            .custom("translate", "0 150px")
            .custom(
                "transition",
                "opacity 340ms ease-out, translate 340ms cubic-bezier(0.22, 1, 0.36, 1)"
            )

        content.onDidRemoveFromDOM { [weak self] in
            self?.scheduleCleanup()
        }
    }

    func restoreContent() {
        display(.block)
        opacity(1)

        guard let content = content as? BaseElement else { return }
        content
            .display(.block)
            .opacity(1)
            .custom("translate", "0 0")
    }

    private func observeContentLifecycle(_ content: DOMElement) {
        #if arch(wasm32)
        contentObserverClosure = JSClosure { [weak self] _ in
            guard let self, self.isInDOM else { return .undefined }

            let containsContent = self.domElement.object?["contains"]
                .function?
                .callAsFunction(
                    optionalThis: self.domElement.object,
                    arguments: [content.domElement]
                )?.boolean ?? false

            if !containsContent {
                self.scheduleCleanup()
                return .undefined
            }

            let contentDisplay = content.domElement.object?["style"]
                .object?["display"]
                .string ?? ""

            self.display(contentDisplay == "none" ? .none : .block)

            return .undefined
        }

        contentObserver = JSObject.global.MutationObserver
            .function?
            .new(contentObserverClosure)
            .jsValue

        let childListOptions: [String: JSValue] = ["childList": .boolean(true)]
        contentObserver?.object?["observe"]
            .function?
            .callAsFunction(
                optionalThis: contentObserver?.object,
                arguments: [domElement, childListOptions.jsValue]
            )

        let contentStyleOptions: [String: JSValue] = [
            "attributes": .boolean(true),
            "attributeFilter": ["style"].jsValue
        ]
        contentObserver?.object?["observe"]
            .function?
            .callAsFunction(
                optionalThis: contentObserver?.object,
                arguments: [content.domElement, contentStyleOptions.jsValue]
            )
        #endif
    }

    private func scheduleCleanup() {
        guard !cleanupScheduled else { return }
        cleanupScheduled = true

        Web.Dispatch.async { [weak self] in
            self?.removeSuperView()
        }
    }

    private func removeSuperView() {
        guard isInDOM else { return }
        disconnectContentObserver()
        remove()
    }

    private func disconnectContentObserver() {
        #if arch(wasm32)
        contentObserver?.object?["disconnect"]
            .function?
            .callAsFunction(optionalThis: contentObserver?.object)
        contentObserver = nil
        #endif
    }
}

func addToDom(
    _ view: DOMElement,
    presentation: SuperViewPresentation = .standard
) {
    if let content = view as? BaseElement,
       let superView = content.superview as? SuperView {
        superView.restoreContent()
        return
    }

    WebApp.shared.document.body.appendChild(
        SuperView(
            content: view,
            presentation: presentation
        )
    )
    // WebApp.shared.window.document.body.appendChild(view)
    // WebApp.shared.window.document.appendChild(view)
}
