//
//  SideMenuItemView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web

class SideMenuItemView: Div {
    
    override class var name: String { "div" }
    
    var icon: String
    var title: String
    var subTitle: String
    var caller: String
    private var callback: ((_ caller: String) -> ())
    
    init(
        icon: String,
        title: String,
        subTitle: String,
        caller: String,
        callback: @escaping ((_ caller: String) -> ())
    ) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.caller = caller
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        VBox(.interactive) {
            Img()
                .src(self.icon)
                .width(46.px)
                .height(46.px)
                .custom("object-fit", "contain")

            Div {
                USubTitle(self.title)
                    .class(.oneLineText)

                UMinorTitle(self.subTitle)
                    .class(.oneLineText)
                    .marginTop(4.px)
            }
            .custom("min-width", "0")
        }
        .display(.grid)
        .custom("grid-template-columns", "46px minmax(0, 1fr)")
        .custom("align-items", "center")
        .custom("gap", "12px")
        .attribute("aria-label", self.title)
    }
    
    override func buildUI() {
        super.buildUI()

        marginBottom(10.px)
        onClick {
            self.callback(self.caller)
        }
        onKeyUp { _, event in
            guard event.code == "Enter" || event.code == "Space" else { return }
            event.preventDefault()
            self.callback(self.caller)
        }
    }
    
}
