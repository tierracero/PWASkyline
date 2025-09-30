//
//  LoaderView.swift
//  
//
//  Created by Victor Cantu on 3/21/22.
//

import Foundation
import Web

class LoaderView: Div {
	
	override class var name: String { "Div" }
	
	@DOM override var body: DOM.Content {
		Table{
			Tr{
				Td{
					Div{
						Div()
						Div()
						Div()
						Div()
					}
					.class(.ldsRing)
				}
				.align(.center)
				.verticalAlign(.middle)
			}
		}
		.width(100.percent)
		.height(100.percent)
	}
	
	override func buildUI() {
		self
		.position(.absolute)
		.width(100.percent)
		.height(100.percent)
		.top(0.px)
		.left(0.px)
		.backgroundColor(.hex(0x1D2026))
		.zIndex(999999999)
		
	}
	
}
