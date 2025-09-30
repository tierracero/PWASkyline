//
//  pdfLinkString.swift
//  
//
//  Created by Victor Cantu on 2/26/23.
//

import Foundation


func pdfLinkString(folio: String, pdf: String) -> String{
    return baseSkylineAPIUrl(ie: "downPDF") +
    "&folio=\(folio)" +
    "&id=\(pdf)" +
    "&pdf=\(pdf)" +
    "&tcon=web"
}
