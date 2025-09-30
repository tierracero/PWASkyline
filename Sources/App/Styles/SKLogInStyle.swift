//
//  SkylineStyle.swift
//  
//
//  Created by Victor Cantu on 3/9/22.
//

import Foundation
import Web

public class SKLogInStyle: Stylesheet {
	@Rules
    public override var rules: Rules.Content {
	
        Rule(Html.pointer)
            .lineHeight(.number(1.16))
            .custom("-ms-text-size-adjust", "100%")
            .custom("-webkit-text-size-adjust", "100%")
        
        Rule(Body.pointer)
            .margin(all: 0.px)
        
        Rule(Article.pointer, ASide.pointer, Footer.pointer, Header.pointer, Nav.pointer, Section.pointer)
            .display(.block)
        
        Rule(H1.pointer, H2.pointer, H3.pointer, H4.pointer, H5.pointer, H6.pointer, Class.h1, Class.h2, Class.h3, Class.h4, Class.h5, Class.h5)
            .clear(.both)
            .color(.white)
            .custom("font-weight", "600")
        
        Rule(H1.pointer, Class.h1)
            .fontSize(38.px)
            .lineHeight(48.px)
            .letterSpacing(0.px)
        
        Rule(H2.pointer, Class.h2)
            .fontSize(32.px)
            .lineHeight(42.px)
            .letterSpacing(0.px)
        
        Rule(H3.pointer, Class.h3, BlockQuote.pointer)
            .fontSize(24.px)
            .lineHeight(34.px)
            .letterSpacing(0.px)
        
        Rule(H3.pointer, Class.h3)
            .marginTop(36.px)
            .marginBottom(12.px)
        
        Rule(H4.pointer, Class.h4, H5.pointer, Class.h5, H6.pointer, Class.h6)
            .fontSize(20.px)
            .lineHeight(30.px)
            .custom("letter-spacing", "-0.1px")
            .marginTop(48.px)
            .marginBottom(4.px)
        
        Rule(H1.pointer, Class.h1, H2.pointer, Class.h2)
            .marginTop(48.px)
            .marginBottom(16.px)
        
        Rule(H1.pointer)
            .fontSize(2.em)
            .margin(all: 0.67.em)
        
		Rule(Tr.pointer)
			.borderStyle(.none)
		
		Rule(Tr.pointer)
			.borderBottomStyle(.none)
		
		Rule(Body.pointer)
			.backgroundColor(.black)
		
		Rule(Class.title)
			.margin(all: 12.px)
			.fontSize(23.px)
		
		Rule(Class.subTitle)
			.margin(all: 12.px)
			.fontSize(16.px)
		
		Rule(Class.darkTextField)
			.fontSize(24.px)
			.height(48.px)
			.textAlign(.left)
			.borderStyle(.none)
			.borderRadius(all: 12.px)
			.padding(all: 12.px)
			.backgroundColor(.grayBlackDark)
			.color(.darkGrey)
		
		Rule(Class.lightTextField)
		
		Rule(Class.clear)
			.clear(.both)
			.height(1.px)
			.margin(all: 0.px)
			.padding(all: 0.px)
		
		Rule(Class.oneTwoFlex)
			.float(.right)
			.width(49.percent)
			.display(.inline)
			.margin(all: 0.px)
		
		Rule(Class.oneTwoFlex.firstChild)
			.float(.left)
		
		Rule(Class.bottomFooterText)
			.position(.absolute)
			.bottom(24.px)
			.marginLeft(24.px)
			.marginRight(24.px)
		
		Rule(Class.ldsRing)
			.display(.inlineBlock)
			.position(.relative)
			.width(80.px)
			.height(80.px)
		
		Rule(Class.ldsRing.inside(Div.pointer))
			.boxSizing(.borderBox)
			.display(.block)
			.position(.absolute)
			.width(64.px)
			.height(64.px)
			.margin(all: 8.px)
			.border(width: .length(8.px), style: .solid, color: .white)
			.borderRadius(all: 50.percent)
			.custom("animation", "lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite")
			.custom("border-color", "#0ABAFA transparent transparent transparent")
		
        Rule(Class.iconWhite)
            .filter(.invert(99))
        
		Rule(Class.ldsRing.inside(Div.pointer.nthChild("1")))
			.animationDelay(-0.45)
		
		Rule(Class.ldsRing.inside(Div.pointer.nthChild("2")))
			.animationDelay(-0.3)
		
		Rule(Class.ldsRing.inside(Div.pointer.nthChild("3")))
			.animationDelay(-0.15)
		
		Keyframes(.ldsRing)
			.from {
				Transform(.rotate(0))
			}
			.to {
				Transform(.rotate(360))
			}
		
	}
}

extension KeyframesName {
	static var ldsRing: KeyframesName { "lds-ring" }
}

extension Class {
	static var ldsRing: Class { "lds-ring" }
}
/*

 @keyframes lds-ring {
 0% {
	 transform: rotate(0deg);
	 }
 100% {
	 transform: rotate(360deg);
	 }
 }

 */
