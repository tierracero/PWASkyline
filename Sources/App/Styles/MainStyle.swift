//
//  MainStyle.swift
//  
//
//  Created by Victor Cantu on 3/9/22.
//

import Foundation
import Web

class MainStyle: Stylesheet {
    
	@Rules
	override var rules: Rules.Content {
        
        Rule(THead.pointer)
        .position(.fixed)
        .top(0.px)

        Rule(Class.oneLineText)
            .textOverflow(.ellipsis)
            .overflow(.hidden)
            .whiteSpace(.nowrap)
        
		Rule(Pointer.any)
			.margin(all: 0)
			.padding(all: 0)
        
        Rule(A.pointer)
            .cursor(.default)
        
        Rule(Class.roundGray)
            .border(width: .thin, style: .solid, color: .rgb( 54, 54, 54))
            .borderRadius(all: 12.px)
            .overflow(.auto)
        
        Rule(Class.textFiledBlackDarkLarge)
            .border(width: BorderWidthType.thin, style: .solid, color: .grayBlackDark)
            .backgroundColor(.grayBlackDark)
            .borderRadius(7.px)
            .paddingRight(3.px)
            .paddingLeft(3.px)
            .fontSize(26.px)
            .height(32.px)
            .color(.white)
        
        Rule(Class.textFiledBlackDarkFull)
            .border(width: BorderWidthType.thin, style: .solid, color: .grayBlackDark)
            .backgroundColor(.grayBlackDark)
            .width(100.percent)
            .borderRadius(7.px)
            .paddingRight(3.px)
            .paddingLeft(3.px)
            .fontSize(26.px)
            .height(32.px)
            .color(.white)
        
        Rule(Class.transparantBlackBackGround)
            .backgroundColor(r: 0, g: 0, b: 0, a: 0.7)
            .zIndex(1)
        
        Rule(Class.oneHalf)
            .padding(top: 7.px, right: 7.px, bottom: 0.px, left: 7.px)
            .maxWidth(100.percent)
            .width(100.percent)
            .float(.left)
        
        Rule(Class.oneForth)
            .padding(v: 7.px, h: 7.px)
            .maxWidth(100.percent)
            .width(100.percent)
            .float(.left)
        
        Rule(Class.popUpView10)
            .backgroundColor(.init(r: 23, g: 23, b: 28))
        
        Rule(Class.popUpView)
            .backgroundColor(.init(r: 23, g: 23, b: 28))
        
        Rule(Class.popUpHeaderView)
            .display(.none)
            .height(12.px)
        
        
        Rule(Class.row)
            .margin(v: 24, h: 12)
            .flexWrap(.wrap)
            .display(.flex)
        /*
        MediaRule(.all.minWidth(576.px)) {
            Rule(Class.colSm12)
                .custom("flex", "0 0 auto")
                .width(100.percent)
        }
        
        MediaRule(.all.minWidth(768.px)) {
            
            Rule(Class.colMd3)
                .custom("flex", "0 0 auto")
                .width(25.percent)
            
            Rule(Class.colMd6)
                .custom("flex", "0 0 auto")
                .width(50.percent)
            
            Rule(Class.colMd9)
                .custom("flex", "0 0 auto")
                .width(75.percent)
        }
        
        MediaRule(.all.minWidth(992.px)) {
            
            Rule(Class.colLg3)
                .custom("flex", "0 0 auto")
                .width(25.percent)
            
            Rule(Class.colLg6)
                .custom("flex", "0 0 auto")
                .width(50.percent)
            
            Rule(Class.colLg9)
                .custom("flex", "0 0 auto")
                .width(75.percent)
        }
        */
        MediaRule(.all.minWidth(833.px)) {
            
            Rule(Class.hideInLargeScreen)
                .display(.none)
            
            Rule(Class.popUpView10)
                .marginTop(10.percent.important)
                .maxHeight(80.percent)
                .borderRadius(24.px)
                .padding(all: 12.px)
                .overflow(.auto)
            
            Rule(Class.popUpView)
                .marginTop(15.percent.important)
                .borderRadius(24.px)
                .padding(all: 12.px)
            
            Rule(Class.oneHalf)
                .maxWidth(50.percent.important)
                .width(50.percent.important)
            
            Rule(Class.oneForth)
                .maxWidth(25.percent.important)
                .width(25.percent.important)
            
        }
        
        MediaRule(.all.maxWidth(833.px)) {
            
            Rule(Class.hideInSmallScreen)
                .display(.none)
            
            Rule(Class.popUpHeaderView)
                .display(.block.important)
            
            Rule(Class.popUpView)
                .left(0.percent.important)
                .top(0.percent.important)
                .position(.absolute)
                .height(100.percent)
                .width(100.percent)

            Rule(Class.popUpView10)
                .left(0.percent.important)
                .top(0.percent.important)
                .position(.absolute)
                .height(100.percent)
                .width(100.percent)

        }
        
		Keyframes("anibox1")
			.from {
				Transform(.rotate(0))
				Opacity(0)
			}
			.to {
				Transform(.rotate(45))
				Opacity(1)
			}
        
        
	}
}

extension Keyframes {
	static var anibox1: Keyframes { "anibox1" }
}
