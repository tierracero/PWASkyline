//
//  ConfirmOptionView.swift
//  
//
//  Created by Victor Cantu on 2/14/23.
//

import Foundation
import TCFundamentals
import Web

class ConfirmOptionView: Div {
    
    override class var name: String { "div" }
    
    var viewTitle: String
    
    var viewDescription: String
    
    var buttonOneTag: String
    
    var buttonTwoTag: String
    
    var buttonThreeTag: String?
    
    private var optionOne: ((
        ) -> ()
    )
    
    private var optionTwo: ((
        ) -> ()
    )
    
    private var optionThree: ((
        ) -> ()
    )?
    
    init(
        viewTitle: String,
        viewDescription: String,
        buttonOneTag: String,
        buttonTwoTag: String,
        buttonThreeTag: String? = nil,
        optionOne: @escaping ((
        ) -> ()),
        optionTwo: @escaping ((
        ) -> ()),
        optionThree: ((
        ) -> ())? = nil
    ) {
        self.viewTitle = viewTitle
        self.viewDescription = viewDescription
        self.buttonOneTag = buttonOneTag
        self.buttonTwoTag = buttonTwoTag
        self.buttonThreeTag = buttonThreeTag
        self.optionOne = optionOne
        self.optionTwo = optionTwo
        self.optionThree = optionThree
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var buttonView = Div()
        .padding(all: 7.px)
        .margin(all: 7.px)
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView3)
                    .onClick {
                        self.remove()
                    }
                
                H2(self.viewTitle)
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Div(self.viewDescription)
                .padding(all: 7.px)
                .margin(all: 7.px)
                .fontSize(32.px)
                .align(.center)
                .color(.white)
            
            self.buttonView
            
            Div().class(.clear).marginBottom(7.px)
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 275px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(550.px)
        .top(30.percent)
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        height(100.percent)
        width(100.percent)
        position(.fixed)
        left(0.px)
        top(0.px)
        
        if let buttonThreeTag, let optionThree  {
            
            let buttonOne = Div(buttonOneTag)
                .class(.uibtnLarge)
                .marginRight(12.px)
                .width(29.percent)
                .align(.center)
                .float(.left)
                .onClick{
                    self.optionOne()
                    self.remove()
                }
            
            let buttonTwo = Div(buttonTwoTag)
                .class(.uibtnLarge)
                .marginRight(12.px)
                .width(29.percent)
                .align(.center)
                .float(.left)
                .onClick{
                    self.optionTwo()
                    self.remove()
                }
        
            let buttonThree = Div(buttonThreeTag)
                .class(.uibtnLarge)
                .marginRight(12.px)
                .width(29.percent)
                .align(.center)
                .float(.left)
                .onClick{
                    optionThree()
                    self.remove()
                }
            
            buttonView.appendChild(buttonOne)
            buttonView.appendChild(buttonTwo)
            buttonView.appendChild(buttonThree)
            
        }
        else{
            
            let buttonOne = Div(buttonOneTag)
                .class(.uibtnLarge)
                .marginRight(12.px)
                .width(42.percent)
                .align(.center)
                .float(.left)
                .onClick{
                    self.optionOne()
                    self.remove()
                }
            
            let buttonTwo = Div(buttonTwoTag)
                .class(.uibtnLarge)
                .marginRight(12.px)
                .width(42.percent)
                .align(.center)
                .float(.left)
                .onClick{
                    self.optionTwo()
                    self.remove()
                }
            
            buttonView.appendChild(buttonOne)
            buttonView.appendChild(buttonTwo)
        
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
