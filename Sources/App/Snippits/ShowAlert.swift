//
//  ShowAlert.swift
//  
//
//  Created by Victor Cantu on 2/17/22.
//

import Foundation
import Web

class ShowAlert: Div {
	
	let title: String
	let message: String
	
	init(
		title: String,
		message: String
	) {
		self.title = title
		self.message = message
	}
	
	required init() {
		fatalError("init() has not been implemented")
	}
	
	override class var name: String { "div" }
	
	@DOM override var body: DOM.Content {
		Div{
			Table{
				Tr{
					
					Td{
						Img()
							.src("/skyline/media/icon-alert.svg")
							.width(96.px)
							.padding(all: 24.px)
						
					}
					.margin(all: 12)
					.align(.center)
					.verticalAlign(.middle)
					
					Td{
						Span(self.title)
							.class(.subTitle)
							.color(.white)
						
						Br()
						
						Span(self.message)
							.class(.title)
							.color(.white)
						
					}
					.align(.left)
					.verticalAlign(.middle)
					
				}
			}
			.width(100.percent)
			.height(100.percent)
		}
		.backgroundColor( .init(r: 0, g: 0, b: 0, a: 0.77))
		.border(width: .thin, style: .solid, color: .yellow)
		.borderRadius(all: 24.px)
		.padding(all: 12)
		.margin(all: 7.px)
		.minHeight(50.px)
		.width(500.px)
		
	}
	
}

