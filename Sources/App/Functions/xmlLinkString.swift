//
//  xmlLinkString.swift
//  
//
//  Created by Victor Cantu on 2/26/23.
//

import TCFundamentals
import Foundation

func xmlLinkString(folio: String, xml: String) -> String {
    return baseSkylineAPIUrl(ie: "downXML") +
    "&folio=\(folio)" +
    "&id=\(xml)" +
    "&xml=\(xml)" +
    "&tcon=web"
}
