//
//  Color.swift
//  
//
//  Created by Victor Cantu on 3/20/22.
//

import Foundation
import Web

extension Color { // TODO: cheke what colors are not being used
    
    /// need tpo incorp ??
    ///
    public static var highlighBlue: Color { .init(.rgb(0, 135, 255)) }
    public static var folioRowDefaultColor: Color { .init(r: 83, g: 136, b: 150) }
    
    public static var grayBlackDark: Color { .init(.rgb(29, 32, 38)) }
    public static var grayBlack: Color { .init(.rgb(35, 39, 47)) }
    public static var grayContrast: Color { .init(.rgb(81, 85, 94)) }
    
    public static var yellowContrast: Color { .init(.rgb(210, 190, 14)) }
    
    /// default
    public static var transparentBlack: Color { .init(.rgba(0, 0, 0, 0.7)) }
    public static var darkTansperant: Color = .init(r:0, g: 0, b: 0, a: 0.7)
    public static var whiteTansperant: Color = .init(r: 255, g: 255, b: 255, a: 0.1)
    
    public static var grayHeader: Color = .init(r: 62, g: 69, b: 79)
    public static var grayText: Color = .init(r: 111, g: 113, b: 121)
    public static var grayShadow: Color = .init(r: 240, g: 240, b: 240)
    public static var grayShadowPlaceholder: Color = .init(r: 180, g:180, b: 180)
    
    public static var backGroundRow: Color = .init(r: 31, g: 33, b: 36)
    public static var backGroundLightGraySlate: Color = .init(r: 55, g: 56, b: 61)
    public static var backGroundGray: Color = .init(r: 44, g: 46, b: 53)
    public static var backGroundGraySlate: Color = .init(r: 44, g: 46, b: 53)
    
    public static var slateRed: Color = .init(r: 193, g: 39, b: 45)
    public static var slateGreen: Color = .init(r: 0, g: 146, b: 63)
    public static var slateGray: Color = .init(r: 40, g: 178, b: 225)
    public static var slateHeader: Color = .init(r: 36, g: 43, b: 52)
    
    public static var lightGrayTC: Color = .init(r: 111, g: 113, b: 121)
    public static var lightBlue: Color = .init(r: 40, g: 178, b: 225)
    public static var lightBlueText: Color = .init(r: 104, g: 142, b: 182)
    
    public static var titleBlue: Color = .init(r: 3, g: 169, b: 244)
    
    public static var strongBlue: Color = .init(r: 44, g: 177, b: 255)
    
    public static var yellowTC: Color = .init(r: 232, g: 202, b: 77)
    public static var yellowText: Color = .init(r: 231, g: 203, b: 77)
    public static var yellowDarkText: Color = .init(r: 186, g: 166, b: 78)
    
    public static var peach: Color = .init(r: 244, g: 146, b: 146)
    
	public static var statusPending: Color { .init(r: 255, g: 165, b: 16) }
	public static var statusActive: Color { .init(r: 0, g: 176, b: 236) }
	public static var statusPendingSpare: Color { .init(r: 241, g: 90, b: 36) }
	public static var statusCanceled: Color { .init(r: 224, g: 224, b: 224) }
	public static var statusFinalize: Color { .init(r: 0, g: 178, b: 52) }
	public static var statusArchive: Color { .init(r: 224, g: 224, b: 224) }
	public static var statusCollection: Color { .init(r: 255, g: 204, b: 204) }
	
}
