//
//  UFields.swift
//

import Foundation
import Web

public final class UField: Div {
    public override class var name: String { "div" }

    private let labelView = Label()
    private let contentView = Div()

    public init<U>(
        _ label: U,
        required: Bool = true,
        @DOM content: @escaping DOM.Block
    ) where U: UniValue, U.UniValue == String {
        super.init()

        _ = labelView.innerText(label)
        if required {
            labelView.appendChild(Span(" *").custom("color", "var(--tc-beta-orange-hot)"))
        }
        contentView.parseDOMItem(content().domContentItem)
        configure()
    }

    public required init() {
        super.init()
        configure()
    }

    @DOM public override var body: DOM.Content {
        labelView
        contentView
    }

    private func configure() {
        self.class(Class(TCTripBetaClass.uiField))
        labelView.class(Class(TCTripBetaClass.uiFieldLabel))
    }
}

public final class UTextField: InputText {
    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiControl))
    }
}

public final class UDateField: InputDate {
    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiControl))
    }
}

public final class USelectField: Select {
    public override class var name: String { "select" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiControl))
    }
}

public final class UTextArea: TextArea {
    public override class var name: String { "textarea" }

    public required init() {
        super.init()
        self.class(Class(TCTripBetaClass.uiControl))
    }
}
