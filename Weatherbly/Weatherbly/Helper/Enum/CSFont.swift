//
//  CSFont.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit

private enum GothicNeo: String {
    case heavy      = "AppleSDGothicNeoH"
    case extraBold  = "AppleSDGothicNeoEB"
    case bold       = "AppleSDGothicNeoB"
    case semiBold   = "AppleSDGothicNeoSB"
    case medium     = "AppleSDGothicNeoM"
    case regular    = "AppleSDGothicNeoR"
    case light      = "AppleSDGothicNeoL"
    case ultraLight = "AppleSDGothicNeoUL"
    case thin       = "AppleSDGothicNeoT"
}

public enum CSFont {
    case heading_1_UL
    case heading_2_B
    case heading_3_B
    case heading_4_B
    case heading_5_B
    case title_1_B
    case title_1_M
    case title_2_B
    case title_2_M
    case title_3_B
    case title_3_M
    case body_1_B
    case body_1_M
    case body_2_B
    case body_2_M
    case body_3_B
    case body_3_M
    case body_4_B
    case body_4_M
    case body_5_B
    case body_5_M
    case caption_1_M
    case caption_2_M
    
    var font: UIFont {
        var name: GothicNeo
        var size: CGFloat
        switch self {
        case .heading_1_UL:
            name = GothicNeo.ultraLight
            size = 56
        case .heading_2_B:
            name = GothicNeo.bold
            size = 32
        case .heading_3_B:
            name = GothicNeo.bold
            size = 28
        case .heading_4_B:
            name = GothicNeo.bold
            size = 24
        case .heading_5_B:
            name = GothicNeo.bold
            size = 22
        case .title_1_B:
            name = GothicNeo.bold
            size = 20
        case .title_1_M:
            name = GothicNeo.medium
            size = 20
        case .title_2_B:
            name = GothicNeo.bold
            size = 18
        case .title_2_M:
            name = GothicNeo.medium
            size = 18
        case .title_3_B:
            name = GothicNeo.bold
            size = 17
        case .title_3_M:
            name = GothicNeo.medium
            size = 17
        case .body_1_B:
            name = GothicNeo.bold
            size = 16
        case .body_1_M:
            name = GothicNeo.medium
            size = 16
        case .body_2_B:
            name = GothicNeo.bold
            size = 15
        case .body_2_M:
            name = GothicNeo.medium
            size = 15
        case .body_3_B:
            name = GothicNeo.bold
            size = 14
        case .body_3_M:
            name = GothicNeo.medium
            size = 14
        case .body_4_B:
            name = GothicNeo.bold
            size = 13
        case .body_4_M:
            name = GothicNeo.medium
            size = 13
        case .body_5_B:
            name = GothicNeo.bold
            size = 12
        case .body_5_M:
            name = GothicNeo.medium
            size = 12
        case .caption_1_M:
            name = GothicNeo.medium
            size = 11
        case .caption_2_M:
            name = GothicNeo.medium
            size = 10
        }
        
        return UIFont(name: name.rawValue, size: size) ?? UIFont.systemFont(ofSize: 15)
    }
}
