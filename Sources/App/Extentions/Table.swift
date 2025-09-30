//
//  Table.swift
//  
//
//  Created by Victor Cantu on 4/1/23.
//

import Foundation
import Web

extension Table {
 
    public func noResult(label: String) -> Table {
        
        return Table {
            Tr{
                Td{
                    Span(label)
                        .color(.gray)
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .height(100.percent)
        .width(100.percent)
        
    }
    
    public func noResult(label: String, button buttonLabel: String, buttonAcction: @escaping () -> Void) -> Table {
        
        return Table {
            Tr {
                Td {

                    Span(label)
                        .color(.gray)

                    Div {
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .marginTop(7.px)
                                .cursor(.pointer)
                                .height(24.px)
                        }
                        .marginRight(7.px)
                        .float(.left)
                            
                        Span(buttonLabel)
                            .cursor(.pointer)
                            .float(.left)
                            
                        Div().clear(.both)
                    }
                    .class(.uibtnLargeOrange, .oneLineText)
                    .maxWidth(100.percent)
                    .onClick {
                        buttonAcction()
                    }
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .height(100.percent)
        .width(100.percent)
        
    }
}