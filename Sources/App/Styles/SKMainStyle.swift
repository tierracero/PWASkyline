//
//  SKMainStyle.swift
//  
//
//  Created by Victor Cantu on 3/19/22.
//

import Foundation
import Web

public class SKMainStyle: Stylesheet {
    
    @Rules
    public override var rules: Rules.Content {
        
        Rule(Class.hoverFocusBlack.hover)
            .backgroundColor(.black)
            .color(.white)
        
        Rule(Class.rowItem)
            .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
            .backgroundColor(.grayBlackDark)
            .borderRadius(all: 12.px)
            .marginBottom(7.px)
            .padding(all: 7.px)
            .paddingBottom(3.px)
            .overflow(.hidden)
            .cursor(.pointer)
            .fontSize(24.px)
            .color(.white)
        
        Rule(Class.rowItem.hover)
            .backgroundColor(.init(r: 19, g: 20, b: 23))
        
        Rule(Class.hiddeToolItem.hover.inside(Class.toolItem))
            .display(.block)
        
        Rule(Class.toolItem)
            .display(.none)
        
        Rule(Pointer.any)
            .margin(all: 0)
            .padding(all: 0)

        Rule(Th.pointer, Td.pointer)
            .padding(all: 3.px)
        
        /*
        Rule(H1.pointer.inside(Span.pointer) )
            .color(.red)
         */
        
        Rule(Class.clear)
            .clear(.both)
            .height(0.px)
            .margin(all: 0.px)
            .padding(all: 0.px)
        
        Rule(H1.pointer, H2.pointer, H3.pointer, H3.pointer, H5.pointer, H6.pointer)
                    .fontWeight(.normal)
                
        Rule(Header.pointer)

        Rule(Html.pointer)
            .height(100.percent)
            .width(100.percent)
            .backgroundColor(.black)
            .backgroundSize(all: .cover)

        Rule(Body.pointer)
            .height(100.percent)
            .width(100.percent)
            .fontFamily(.lucidaGrande)

        Rule(Class.roundCorner)
            .borderRadius(all: 1.em)

        Rule(Class.transparantBlackBackGround)
            .backgroundColor(r: 0, g: 0, b: 0, a: 0.7)
            .zIndex(999999991)

        Rule(Input.pointer)
            .border(width: .thin, style: .solid, color: .white)
            .padding(top: 0.px, right: 7.px, bottom: 0.px, left: 7.px)
            .color(.black)
            .borderRadius(all: 7.px)

        Rule(Class.usernameTextField)
            .backgroundImage("/skyline/media/userIcon.png")
            .fontSize(25.px)
            .backgroundRepeat(.noRepeat)
            .textAlign(.center)
            .height(35.px)
            .backgroundPosition(BackgroundPositionType.axis(h: XAxis("2px"), v: YAxis("3px")))
            .lineHeight(35.px)
            .marginBottom(10.px)

        Rule(Class.passwordTextField)
            .backgroundImage("/skyline/media/lockIcon.png")
            .fontSize(25.px)
            .backgroundRepeat(.noRepeat)
            .textAlign(.center)
            .height(35.px)
            .backgroundPosition(BackgroundPositionType.axis(h: XAxis("2px"), v: YAxis("3px")))
            .lineHeight(35.px)
            .color(.lightGray)
            .marginBottom(10.px)

        Rule(Class.title)
            .margin(all: 12.px)
            .fontSize(23.px)

        Rule(Class.subTitle)
            .margin(all: 12.px)
            .fontSize(16.px)

        Rule(Button.pointer)
        //.fontSize(FontSizeType.medium)
            .backgroundColor(.white)
            .paddingBottom(3.px)
            .paddingTop(3.px)
            .paddingLeft(7.px)
            .paddingRight(7.px)
            .borderRadius(all: 7.px)

        Rule(Class.button)
            .backgroundColor(.transparent)
            .borderStyle(.none)
            .fontSize(23.px)
            .color(.lightBlueText)
            .backgroundRepeat(.noRepeat)

        Rule(Class.topBarButton)
            .float(.right)
            .borderLeft(width: .thin, style: .solid, color: .hex(333333))
            .padding(top: 0.px, right: 10.px, bottom: 0.px, left: 20.px)
            .backgroundImage("/skyline/media/accbg.png")
            .cursor(.pointer)
            .display(.inlineBlock)
            .height(55.px)
            .lineHeight(57.px)
            .backgroundSize(h: .auto, v: 100.percent)

        Rule(Class.uibutton)
            .position(.relative)
            .overflow(.visible)
            //.display(.inlineBlock)
            .custom("width", "fit-content")
            .padding(top: 5.px, right: 10.px, bottom: 5.px, left: 10.px)
            .margin(top: 5.px, right: 3.px, bottom: 5.px, left: 0.px)
            .textDecorationLine(.none)
            .textAlign(.center)
            .cursor(.pointer)
            .outline(width: 0.px, style: OutlineStyleType.none, color: .transparent)
            .color(.hex(0x333333))
            .backgroundColor(.hex(0xf4f4f4))
            .textShadow(TextShadowType.none)
            .border(width: .thin, style: .solid, color: .hex(0xaaaaaa))
            .fontWeight(.bold)
            .fontSize(11.px)
            .backgroundSize(h:  100.percent, v: 100.percent)
            .custom("background-image", "-webkit-gradient(linear, 0 0, 0 100%, from(#f4f4f4), to(#f4f4f4))")
            .custom("box-shadow", "0 1px 0 rgb(0 0 0 / 10%), inset 0 1px 0 #f2f2f2")
            .custom("transition", "all.2s ease-out")

        Rule(Class.roundBlue)
            .border(width: .thin, style: .solid, color: .rgb( 0, 153, 255))
            .borderRadius(all: 12.px)

        Rule(Class.roundDarkBlue)
            .border(width: .thin, style: .solid, color: .rgb( 28, 73, 102))
            .borderRadius(all: 12.px)

        Rule(Class.roundGray)
            .border(width: .thin, style: .solid, color: .rgb( 238, 238, 238))
            .borderRadius(all: 12.px)

        Rule(Class.roundGrayBlackDark)
            .border(width: .thin, style: .solid, color:  .grayBlackDark)
            .borderRadius(all: 12.px)

        Rule(Class.roundGrayBlack)
            .border(width: .thin, style: .solid, color:  .grayBlack)
            .borderRadius(all: 12.px)

        Rule(Class.textFiledBlackDark)
            .border(width: BorderWidthType.thin, style: .solid, color: .grayBlackDark)
            .backgroundColor(.grayBlackDark)
            .borderRadius(all: 7.px)
            .paddingRight(3.px)
            .paddingLeft(3.px)
            .fontSize(18.px)
            .height(23.px)
            .color(.white)
        
        Rule(Class.textFiledBlackDarkMedium)
            .border(width: BorderWidthType.thin, style: .solid, color: .grayBlackDark)
            .backgroundColor(.grayBlackDark)
            .fontSize(20.px)
            .height(36.px)
            .color(.white)
        
        Rule(Class.textFiledBlackDarkLarge)
            .border(width: BorderWidthType.thin, style: .solid, color: .grayBlackDark)
            .backgroundColor(.grayBlackDark)
            .fontSize(32.px)
            .height(38.px)
            .color(.white)
        
        Rule(Class.textFiledBlackDarkReadMode)
            .backgroundColor(.transparent)
            .border(style: .none)
            .marginLeft(7.px)
            .fontSize(18.px)
            .height(24.px)
            .color(.white)

        Rule(Class.textFiledLight)
            .border(width: BorderWidthType.thin, style: .solid, color: .lightGrey)
            .fontSize(18.px)
            .height(22.px)

        Rule(Class.oneHalf)
            .custom("width","calc(49% - 14px)")
            .padding(all: 7.px)
            .float(.left)

        Rule(Class.oneThird)
            .custom("width", "calc(32% - 16px)")
            .padding(all: 7.px)
            .float(.left)

        Rule(Class.twoThird)
            .custom("width", "calc(65% - 16px)")
            .padding(all: 7.px)
            .float(.left)

        Rule(Class.oneTwo)
            .padding(all: 3.px)
            .custom("width","calc(49% - 14px)")
            .display(.inline)
            .float(.left)

        Rule(Class.oneThirdOrderGrid)
            .custom("width", "calc(37% - 14px)")
            .padding(all: 7.px)
            .float(.left)

        Rule(Class.twoThirdOrderGrid)
            .custom("width", "calc(61% - 14px)")
            .padding(all: 7.px)
            .float(.left)
        
        Rule(Class.section)
            .padding(top: 0.px, right: 0.px, bottom: 8.px, left: 0.px)
            .marginBottom(7.px)

        Rule(Class.section.inside(Label.pointer))
            .padding(top: 11.px, right: 0.px, bottom: 0.px, left: 0.px)
            .color(.gray)
            .float(.left)
            .marginLeft(5.px)
            .marginTop(2.px)
            .width(30.percent)
            .fontSize(14.px)

        Rule(Class.section.inside(Div.pointer))
            .padding(top: 5.px, right: 0.px, bottom: 0.px, left: 0.px)
            .color(.hex(0x404040))
            .fontSize(14.px)
            .marginLeft(35.percent)

        Rule(Class.largeButtonBox)
            .custom("transition", "background-color .2s ease-out")
            .cursor(.pointer)
            .backgroundColor(.hex(0xf5f5f5))
            .border(width: .thin, style: .solid, color: .hex(0xdddddd))
            .boxShadow(h: 1.px, v: 1.px, blur: 2.px, color: .hex(0xf5f5f5))
            .borderRadius(all: 12.px)
            .position(.relative)
            .margin(top: 0.px, right: 0.px, bottom: 10.px, left: 0.px)
            .padding(v: 15.px, h: 10.px)

        Rule(Class.textFiledLightLarge)
            .custom("transition", "background-color .2s ease-out")
            .cursor(.pointer)
            .backgroundColor(.hex(0xf5f5f5))
            .border(width: .thin, style: .solid, color: .hex(0xdddddd))
            .boxShadow(h: 1.px, v: 1.px, blur: 2.px, color: .hex(0xf5f5f5))
            .borderRadius(all: 12.px)
            .position(.relative)
            .margin(top: 0.px, right: 0.px, bottom: 7.px, left: 0.px)
            .padding(v: 5.px, h: 5.px)
            .fontSize(20.px)
            .height(21.px)

        Rule(Class.smallButtonBox)
            .custom("transition", "background-color .2s ease-out")
            .cursor(.pointer)
            .backgroundColor(.hex(0xf5f5f5))
            .border(width: .thin, style: .solid, color: .hex(0xdddddd))
            .boxShadow(h: 1.px, v: 1.px, blur: 2.px, color: .hex(0xf5f5f5))
            .borderRadius(all: 12.px)
            .position(.relative)
            .margin(top: 0.px, right: 0.px, bottom: 3.px, left: 0.px)
            .padding(v: 5.px, h: 3.px)

        Rule(Class.breaks)
            .backgroundImage("/skyline/media/beake.png")
            .height(7.px)
            .backgroundRepeat(.repeatX)
            .backgroundPosition(BackgroundPositionType.center)
            .margin(top: 0.px, right: 0.px, bottom: 10.px, left: 35.px)

        /*
         ackground-image: url(https://tierracero.com/dev/core/images/loader.gif);
         background-position: 95% 50% !important;
         background-repeat: no-repeat;
         */

        Rule(Class.isLoading)
            .backgroundImage("/skyline/media/loader.gif")
            .backgroundPosition(.position(h: 95.percent, v: 50.percent))
            .backgroundRepeat(.noRepeat)

        Rule(Class.isOk)
            .backgroundImage("/skyline/media/checkmark2.png")
            .backgroundPosition(.position(h: 95.percent, v: 50.percent))
            .backgroundRepeat(.noRepeat)

        Rule(Class.isNok)
            .backgroundImage("/skyline/media/cross.png")
            .backgroundPosition(.position(h: 95.percent, v: 50.percent))
            .backgroundRepeat(.noRepeat)
        
        Rule(Class.zoom)
            .backgroundImage("/skyline/media/zoom.png")
            .backgroundPosition(.position(h: 95.percent, v: 50.percent))
            .backgroundRepeat(.noRepeat)
            .backgroundSize(all: 18.px)
        
        Rule(Class.redButton)
            .textAlign(.center)
            .backgroundColor(.hex(0xc1272c))
            .borderRadius(all: 12.px)
            .color(.hex(0xf49292))
            .fontSize(29.px)

        Rule(Class.greenButton)
            .textAlign(.center).textAlign(.center)
            .backgroundColor(.rgb( 0, 146, 63))
            .borderRadius(all: 12.px)
            .color(.lightGreen)
            .fontSize(29.px)

        Rule(Class.iconWhite)
            .filter(.invert(99))

        Rule(Class.iconBlue)
            .custom("filter", "invert(61%) sepia(15%) saturate(1580%) hue-rotate(159deg) brightness(92%) contrast(101%);")

        Rule(Class.oneLineText)
            .textOverflow(.ellipsis)
            .overflow(.hidden)
            .whiteSpace(.nowrap)

        Rule(Class.twoLineText)
            .custom("display", "-webkit-box")
            .custom("-webkit-line-clamp","2")
            .custom("-webkit-box-orient","vertical")
            .overflow(.hidden)
        
        Rule(Class.threeLineText)
            .custom("display", "-webkit-box")
            .custom("-webkit-line-clamp","3")
            .custom("-webkit-box-orient","vertical")
            .overflow(.hidden)
        
        Rule(Class.ldsRing)
            .display(.inlineBlock)
            .position(.relative)
            .width(80.px)
            .height(80.px)

        Rule(Class.ldsRing.inside(Div.pointer))
            .border(width: .thick, style: .solid, color: .white)
            .boxSizing(.borderBox)
            .display(.block)
            .position(.absolute)
            .width(64.px)
            .height(64.px)
            .margin(all: 8.px)
            .borderRadius(all: 50.percent)
            .custom("animation"," lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite")
            .custom("border-color","#48a4dc transparent transparent transparent")

        Rule(Class.ldsRing.inside(Div.pointer).nthChild("1"))
            .animationDelay(0.45.s)

        Rule(Class.ldsRing.inside(Div.pointer).nthChild("2"))
            .animationDelay(0.3.s)

        Rule(Class.ldsRing.inside(Div.pointer).nthChild("3"))
            .animationDelay(0.15.s)

        Keyframes("lds-ring")
            .from {
                Transform(.rotate(0))
            }
            .to {
                Transform(.rotate(360))
            }

        /// uibtn
        Rule(Class.uibtn)
            .border(width: .medium, style: .solid, color: .grayBlackDark)
            .boxShadow(h: 2.px, v: 2.px, blur: 3.px, color: .black)
            .custom("transition", "300ms ease-in-out")
            .custom("width", "fit-content")
            .custom("outline", "none")
            .margin(v: 0.px, h: 7.px)
            .borderRadius(all: 7.px)
            .cursor(.pointer)
            .color(.lightGray)
            .backgroundColor(.grayBlackDark)

        Rule(Class.uibtnLarge)
            .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
            .backgroundColor(.grayBlackDark)
            .custom("width", "fit-content")
            .borderRadius(all: 12.px)
            .padding(all: 7.px)
            .cursor(.pointer)
            .fontSize(24.px)
            .marginTop(7.px)
            .textOverflow(.ellipsis)
            .overflow(.hidden)
            .whiteSpace(.nowrap)
            .color(.white)
            
        
        Rule(Class.uibtnLargeOrange)
            .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
            .backgroundColor(.grayBlackDark)
            .custom("width", "fit-content")
            .borderRadius(all: 12.px)
            .padding(all: 7.px)
            .cursor(.pointer)
            .fontSize(24.px)
            .marginTop(7.px)
            .textOverflow(.ellipsis)
            .overflow(.hidden)
            .whiteSpace(.nowrap)
            .color(.darkOrange)
        
        Rule(Class.uibtn.inside(Svg.pointer))
            .custom("stroke-dasharray", "150 480")
            .custom("stroke-dashoffset", "150")
            .custom("stroke", "#fff")
            .custom("fill", "none")
            .custom("transition", "1s ease-in-out")
            .top(0.px)
            .left(0.px)
            .position(.absolute)

        Rule(Class.uibtn.hover)
            .custom("transition", "300ms ease-in-out")
            .backgroundColor(.black)
            .border(width: .medium, style: .solid, color: .black)
            .color(.white)

        Rule(Class.uibtn.hover.inside(Svg.pointer))
            .custom("stroke-dashoffset", "-480")

        Rule(Class.uibtn.inside(Span.pointer))
            .padding(v: 12.px, h: 7.px)
            .fontWeight(.lighter)
            .fontSize(22.px)
            .margin(all: 3.px)
        
        Rule(Class.roundCorner)
            .borderRadius(all: 1.em)
        
        Rule(Class.alpha3)
            .opacity(0.3)

        Rule(Class.alpha10)
            .opacity(1.0)
        
        Rule(Class.sideBar)
            .width(70.px)
            .top(55.px)
            .left(0.px)
            .custom("height", "calc(100% - 55px)")
            .backgroundColor(.transparentBlack)
            .position(.absolute)
        
        Rule(Class.chatBar)
            .paddingLeft(3.px)
            .paddingRight(3.px)
            .width(64.px)
            .top(55.px)
            .right(0.px)
            .custom("height", "calc(100% - 55px)")
            .backgroundColor(.transparentBlack)
            .position(.absolute)
        
        Rule(Class.communicationBox)
            .width(58.px)
            .custom("transition", "width 0.5s ease-in-out 300ms")
        
        Rule(Class.communicationBox.hover)
            .width(400.px)
     
    }
    
}
