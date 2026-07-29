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

        Rule(Pointer(".tc-login-mesh-page"))
            .custom("isolation", "isolate")
            .custom("background", "#1D2026")

        Rule(Pointer(".tc-login-mesh-page .body-wrap"))
            .position(.relative)
            .custom("background", "transparent")
            .zIndex(2)

        Rule(Pointer(".tc-login-mesh-page .tc-login-content-layer"))
            .zIndex(2)

        Rule(Pointer(".tc-login-mesh-background"))
            .position(.fixed)
            .left(0.px)
            .top(0.px)
            .width(100.percent)
            .height(100.percent)
            .overflow(.hidden)
            .custom("background", "#1D2026")
            .custom("pointer-events", "auto")
            .custom("contain", "strict")
            .zIndex(1)

        Rule(Pointer(".tc-login-mesh-background canvas"))
            .display(.block)
            .width(100.percent)
            .height(100.percent)
            .opacity(1)
            .custom("transition", "opacity 520ms ease, transform 620ms ease, filter 520ms ease")

        Rule(Pointer(".tc-login-mesh-page .tc-login-content-layer, .tc-login-mesh-page .tc-login-main-root"))
            .custom("transition", "opacity 420ms ease, transform 520ms cubic-bezier(0.22, 1, 0.36, 1), filter 420ms ease")

        Rule(Pointer(".tc-login-mesh-page.tc-login-handoff .tc-login-content-layer"))
            .custom("opacity", "0")
            .custom("transform", "translateY(-8px)")
            .custom("filter", "blur(4px)")

        Rule(Pointer(".tc-login-mesh-page.tc-login-handoff .tc-login-main-root"))
            .custom("opacity", "0")
            .custom("transform", "translateY(-14px) scale(0.97)")
            .custom("filter", "blur(5px)")

        Rule(Pointer(".tc-login-mesh-page.tc-login-handoff .tc-login-mesh-background canvas"))
            .custom("opacity", "1")
            .custom("transform", "scale(1.035)")
            .custom("filter", "brightness(0.72) blur(2px)")

        Rule(Pointer(".tc-login-recovery-popup"))
            .custom("background", "rgba(1, 9, 22, 0.62) !important")
            .custom("backdrop-filter", "blur(12px) saturate(120%)")
            .custom("-webkit-backdrop-filter", "blur(12px) saturate(120%)")

        Rule(Pointer(".tc-login-recovery-popup[hidden]"))
            .custom("display", "none !important")

        Rule(Pointer(".tc-login-recovery-popup .tc-v-popup-panel"))
            .position(.relative)
            .custom("background", "linear-gradient(145deg, rgba(10, 32, 53, 0.92), rgba(5, 17, 34, 0.84)) !important")
            .custom("border", "1px solid rgba(77, 163, 255, 0.34) !important")
            .custom("border-radius", "18px !important")
            .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.62), 0 0 38px rgba(45, 116, 190, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.08) !important")
            .custom("backdrop-filter", "blur(24px) saturate(125%)")
            .custom("-webkit-backdrop-filter", "blur(24px) saturate(125%)")
            .custom("animation", "tc-login-recovery-enter 220ms ease-out both")

        Rule(Pointer(".tc-login-recovery-popup .tc-v-popup-panel::before"))
            .custom("content", "''")
            .position(.absolute)
            .custom("inset", "0")
            .custom("border-radius", "inherit")
            .custom("background", "linear-gradient(120deg, rgba(77, 163, 255, 0.1), transparent 38%, rgba(95, 75, 210, 0.08))")
            .custom("pointer-events", "none")

        Rule(Pointer(".tc-login-recovery-popup .tc-v-title"))
            .position(.relative)
            .custom("background", "rgba(3, 18, 35, 0.7) !important")
            .custom("border-bottom", "1px solid rgba(117, 151, 184, 0.22)")
            .custom("backdrop-filter", "blur(14px)")

        Rule(Pointer(".tc-login-recovery-popup .tc-v-title-text"))
            .custom("color", "#f4f7fb !important")
            .custom("font-size", "21px")
            .custom("letter-spacing", "0.01em")

        Rule(Pointer(".tc-login-recovery-popup .tc-u-small-title"))
            .custom("padding", "5px 9px")
            .custom("border", "1px solid rgba(77, 163, 255, 0.28)")
            .custom("border-radius", "999px")
            .custom("background", "rgba(35, 93, 146, 0.28)")
            .custom("color", "#8fc7ff !important")
            .custom("font-size", "11px")

        Rule(Pointer(".tc-login-recovery-popup .tc-v-title-close"))
            .custom("color", "#ff9f0a !important")

        Rule(Pointer(".tc-login-recovery-popup .tc-v-body-grid"))
            .position(.relative)
            .custom("padding", "16px")
            .custom("gap", "12px")

        Rule(Pointer(".tc-login-recovery-popup .tc-login-recovery-card"))
            .custom("padding", "18px !important")
            .custom("background", "linear-gradient(145deg, rgba(15, 42, 67, 0.72), rgba(8, 25, 43, 0.64)) !important")
            .custom("border", "1px solid rgba(117, 151, 184, 0.24) !important")
            .custom("border-radius", "13px !important")
            .custom("box-shadow", "0 14px 34px rgba(0, 0, 0, 0.24), inset 0 1px 0 rgba(255, 255, 255, 0.05) !important")
            .custom("backdrop-filter", "blur(12px)")

        Rule(Pointer(".tc-login-recovery-popup .tc-login-recovery-copy"))
            .custom("color", "#b9c8d8 !important")
            .custom("font-size", "14px")
            .custom("font-weight", "500")

        Rule(Pointer(".tc-login-recovery-popup .tc-u-field-label"))
            .custom("color", "#e9f2fb !important")
            .custom("font-size", "14px")

        Rule(Pointer(".tc-login-recovery-popup input"))
            .custom("min-height", "48px")
            .custom("background-color", "rgba(2, 14, 29, 0.78) !important")
            .custom("border", "1px solid rgba(117, 151, 184, 0.3) !important")
            .custom("border-radius", "9px !important")
            .custom("color", "#f4f7fb !important")
            .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.04)")
            .custom("transition", "border-color 150ms ease, box-shadow 150ms ease, background 150ms ease")

        Rule(Pointer(".tc-login-recovery-popup input:focus"))
            .custom("background-color", "rgba(4, 22, 42, 0.92) !important")
            .custom("border-color", "#4da3ff !important")
            .custom("outline", "none !important")
            .custom("box-shadow", "0 0 0 3px rgba(77, 163, 255, 0.14), 0 0 22px rgba(32, 120, 205, 0.12)")

        Rule(Pointer(".tc-login-recovery-popup .tc-login-recovery-secondary"))
            .custom("border", "1px solid rgba(117, 151, 184, 0.28) !important")
            .custom("background", "rgba(12, 31, 49, 0.78) !important")
            .custom("color", "#dce7f3 !important")

        Rule(Pointer(".tc-login-recovery-popup .tc-login-recovery-secondary:hover"))
            .custom("border-color", "rgba(143, 199, 255, 0.58) !important")
            .custom("background", "rgba(26, 61, 92, 0.88) !important")

        Rule(Pointer(".tc-login-recovery-popup .tc-login-recovery-primary"))
            .custom("border", "1px solid rgba(117, 199, 255, 0.48) !important")
            .custom("background", "linear-gradient(115deg, #168bd2, #3158c7) !important")
            .custom("color", "#ffffff !important")
            .custom("box-shadow", "0 12px 28px rgba(20, 94, 181, 0.32)")

        Rule(Pointer(".tc-login-recovery-popup .tc-login-recovery-primary:hover"))
            .custom("background", "linear-gradient(115deg, #21a0ea, #426ce1) !important")
            .custom("box-shadow", "0 15px 32px rgba(20, 111, 205, 0.4)")

        MediaRule(.all.prefersReducedMotion) {
            Rule(Pointer(".tc-login-recovery-popup .tc-v-popup-panel"))
                .custom("animation", "none")
        }

        Keyframes("tc-login-recovery-enter")
            .from {
                Transform(.translateY(10.px))
                Opacity(0)
            }
            .to {
                Transform(.translateY(0.px))
                Opacity(1)
            }

        Rule(Pointer(".tc-login-main-root"))
            .custom("width", "min(560px, calc(100vw - 36px))")
            .custom("box-sizing", "border-box")

        Rule(Pointer(".tc-login-main-root .tc-login-main-card"))
            .custom("padding", "34px !important")
            .custom("background", "linear-gradient(145deg, rgba(10, 32, 53, 0.58), rgba(5, 17, 34, 0.4)) !important")
            .custom("border", "1px solid rgba(77, 163, 255, 0.34) !important")
            .custom("border-radius", "20px !important")
            .custom("box-shadow", "0 30px 90px rgba(0, 0, 0, 0.58), 24px 32px 24px rgba(45, 116, 190, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.08) !important")
            .custom("backdrop-filter", "blur(28px) saturate(145%) !important")
            .custom("-webkit-backdrop-filter", "blur(28px) saturate(145%) !important")
            .custom("animation", "tc-login-main-enter 260ms ease-out both")

        Rule(Pointer(".tc-login-main-root .tc-login-main-title"))
            .custom("color", "#f4f7fb !important")
            .custom("font-size", "38px")
            .custom("line-height", "1.15")
            .custom("letter-spacing", "-0.02em")

        Rule(Pointer(".tc-login-main-root .tc-login-main-copy"))
            .custom("margin-top", "9px")
            .custom("color", "#aab9ca !important")
            .custom("font-size", "15px")
            .custom("font-weight", "500")

        Rule(Pointer(".tc-login-main-root .tc-login-main-field"))
            .custom("margin-top", "18px")
            .custom("gap", "7px")

        Rule(Pointer(".tc-login-main-root .tc-u-field-label"))
            .custom("color", "#e9f2fb !important")
            .custom("font-size", "14px")

        Rule(Pointer(".tc-login-main-root input"))
            .custom("width", "100% !important")
            .custom("min-height", "50px")
            .custom("box-sizing", "border-box")
            .custom("margin", "0 !important")
            .custom("padding-right", "48px !important")
            .custom("background-color", "rgba(2, 14, 29, 0.78) !important")
            .custom("border", "1px solid rgba(117, 151, 184, 0.3) !important")
            .custom("border-radius", "10px !important")
            .custom("color", "#f4f7fb !important")
            .custom("font-size", "16px !important")
            .custom("box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.04)")
            .custom("transition", "border-color 150ms ease, box-shadow 150ms ease, background 150ms ease")

        Rule(Pointer(".tc-login-main-root input:focus"))
            .custom("background-color", "rgba(4, 22, 42, 0.92) !important")
            .custom("border-color", "#4da3ff !important")
            .custom("outline", "none !important")
            .custom("box-shadow", "0 0 0 3px rgba(77, 163, 255, 0.14), 0 0 22px rgba(32, 120, 205, 0.12)")

        Rule(Pointer(".tc-login-main-root .tc-login-main-password"))
            .position(.relative)
            .width(100.percent)

        Rule(Pointer(".tc-login-main-root .tc-login-main-password-toggle"))
            .position(.absolute)
            .custom("right", "15px")
            .custom("top", "50%")
            .custom("width", "24px")
            .custom("height", "24px")
            .custom("transform", "translateY(-50%)")
            .custom("opacity", "0.8")
            .custom("z-index", "2")

        Rule(Pointer(".tc-login-main-root .tc-login-main-password-toggle:hover"))
            .custom("opacity", "1")

        Rule(Pointer(".tc-login-main-root .tc-login-main-actions"))
            .custom("display", "grid")
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("gap", "12px")
            .custom("margin-top", "24px")

        Rule(Pointer(".tc-login-main-root .tc-login-main-secondary"))
            .custom("border", "1px solid rgba(117, 151, 184, 0.28) !important")
            .custom("background", "rgba(12, 31, 49, 0.78) !important")
            .custom("color", "#dce7f3 !important")

        Rule(Pointer(".tc-login-main-root .tc-login-main-secondary:hover"))
            .custom("border-color", "rgba(143, 199, 255, 0.58) !important")
            .custom("background", "rgba(26, 61, 92, 0.88) !important")

        Rule(Pointer(".tc-login-main-root .tc-login-main-primary"))
            .custom("border", "1px solid rgba(117, 199, 255, 0.48) !important")
            .custom("background", "linear-gradient(115deg, #168bd2, #3158c7) !important")
            .custom("color", "#ffffff !important")
            .custom("box-shadow", "0 12px 28px rgba(20, 94, 181, 0.32)")

        Rule(Pointer(".tc-login-main-root .tc-login-main-primary:hover"))
            .custom("background", "linear-gradient(115deg, #21a0ea, #426ce1) !important")
            .custom("box-shadow", "0 15px 32px rgba(20, 111, 205, 0.4)")

        MediaRule(.all.maxWidth(620.px)) {
            Rule(Pointer(".tc-login-main-root .tc-login-main-card"))
                .custom("padding", "26px 20px !important")

            Rule(Pointer(".tc-login-main-root .tc-login-main-actions"))
                .custom("grid-template-columns", "1fr")
        }

        MediaRule(.all.prefersReducedMotion) {
            Rule(Pointer(".tc-login-main-root .tc-login-main-card"))
                .custom("animation", "none")

            Rule(Pointer(".tc-login-mesh-page .tc-login-content-layer, .tc-login-mesh-page .tc-login-main-root, .tc-login-mesh-background canvas"))
                .custom("transition", "none")

            Rule(Pointer(".tc-login-mesh-page.tc-login-handoff .tc-login-content-layer, .tc-login-mesh-page.tc-login-handoff .tc-login-main-root, .tc-login-mesh-page.tc-login-handoff .tc-login-mesh-background canvas"))
                .custom("opacity", "1 !important")
                .custom("transform", "none !important")
                .custom("filter", "none !important")
        }

        Keyframes("tc-login-main-enter")
            .from {
                Transform(.translateY(10.px))
                Opacity(0)
            }
            .to {
                Transform(.translateY(0.px))
                Opacity(1)
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
