//
//  LoadingView.swift
//  
//
//  Created by Victor Cantu on 3/21/22.
//

import Foundation
import Web

public class LoadingView: Div {
	
	public override class var name: String { "Div" }

    @State var helpText: String?  = nil

    var currentViewId: UUID = .init()
	
    let ws = WS()
    
	@DOM public override var body: DOM.Content {
        Table {
            Tr {
                Td {
                    

                        Img()
                            .src("/skyline/media/tierraceroRoundLogoWhite.svg")
                            .marginBottom(12.px)
                            .width(100.px)

                        Br()

                        Span(self.$helpText.map{ $0 ?? "" })
                            .hidden(self.$helpText.map{ $0 == nil })


                        
                }
                .align(.center)
                .verticalAlign(.middle)
            }
            
        }
        .width(100.percent)
        .height(100.percent)

        Img()
            .src("/skyline/media/cross.png")
            .position(.absolute)
            .cursor(.pointer)
            .width(18.px)
            .right(25.px)
            .top(25.px)
            .onClick({ _, event in
                //faseOutLoadingView()
            })

	}
	
	public override func buildUI() {
		self
        .backgroundColor(.transparentBlack)
        .filter(.opacity(0))
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .id("loadingView")
        .zIndex(999999998)
        .display(.none)
        .left(0.px)
        .top(0.px)


        WebApp.current.wsevent.listen {
            
            guard !$0.isEmpty else { return }

            let (event, _) = self.ws.recive($0)

            guard let event else { return }

            switch event {
            case .asyncMessageUpdate:
            
                guard let payload = self.ws.asyncMessageUpdate($0),
                payload.eventId == self.currentViewId else {
                    return
                }

                self.helpText = payload.message

            default:
                break
            }
        }
		
	}

    public func show(_ id: UUID? = nil) {

        if let id  {
            currentViewId = id
        }
        else {
            currentViewId =  .init()
        }
        
        self.fadeIn( begin: .display(.block))

    }

    public func show(_ id: UUID? = nil, text: String) {    

        if let id  {
            currentViewId = id
        }
        else {
            currentViewId =  .init()
        }

        if !text.isEmpty {
            helpText = text
        }

        self.fadeIn( begin: .display(.block))

    }

    public func hide() {
        helpText = nil

        self.fadeOut( end: .hidden)
    }
	
    public func message(id: UUID, text: String) {
        if currentViewId == id  {
            helpText = text
        }
    }

}
