//
//  UIFont+.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit

// MARK: AppleSDGothicNeo
public enum GothicNeo {
    public static let heavy      = "AppleSDGothicNeoH00"
    public static let extraBold  = "AppleSDGothicNeoEB00"
    public static let bold       = "AppleSDGothicNeo-Bold"
    public static let semiBold   = "AppleSDGothicNeo-SemiBold"
    public static let medium     = "AppleSDGothicNeo-Medium"
    public static let regular    = "AppleSDGothicNeo-Regular"
    public static let light      = "AppleSDGothicNeo-Light"
    public static let ultraLight = "AppleSDGothicNeo-UltraLight"
    public static let thin       = "AppleSDGothicNeo-Thin"
}

// MARK: Custom Font
extension UIFont {
    public static let heading_1_UL = UIFont(name: GothicNeo.ultraLight, size: 56)!
    public static let heading_2_B  = UIFont(name: GothicNeo.bold,       size: 32)!
    public static let heading_3_B  = UIFont(name: GothicNeo.bold,       size: 28)!
    public static let heading_4_B  = UIFont(name: GothicNeo.bold,       size: 24)!
    public static let heading_5_B  = UIFont(name: GothicNeo.bold,       size: 22)!
    public static let title_1_B    = UIFont(name: GothicNeo.bold,       size: 20)!
    public static let title_1_M    = UIFont(name: GothicNeo.medium,     size: 20)!
    public static let title_2_B    = UIFont(name: GothicNeo.bold,       size: 18)!
    public static let title_2_SB   = UIFont(name: GothicNeo.semiBold,   size: 18)!
    public static let title_2_M    = UIFont(name: GothicNeo.medium,     size: 18)!
    public static let title_3_B    = UIFont(name: GothicNeo.bold,       size: 17)!
    public static let title_3_M    = UIFont(name: GothicNeo.medium,     size: 17)!
    public static let body_1_B     = UIFont(name: GothicNeo.bold,       size: 16)!
    public static let body_1_M     = UIFont(name: GothicNeo.medium,     size: 16)!
    public static let body_2_B     = UIFont(name: GothicNeo.bold,       size: 15)!
    public static let body_2_M     = UIFont(name: GothicNeo.medium,     size: 15)!
    public static let body_3_B     = UIFont(name: GothicNeo.bold,       size: 14)!
    public static let body_3_M     = UIFont(name: GothicNeo.medium,     size: 14)!
    public static let body_4_B     = UIFont(name: GothicNeo.bold,       size: 13)!
    public static let body_4_M     = UIFont(name: GothicNeo.medium,     size: 13)!
    public static let body_5_B     = UIFont(name: GothicNeo.bold,       size: 12)!
    public static let body_5_M     = UIFont(name: GothicNeo.medium,     size: 12)!
    public static let caption_1_M  = UIFont(name: GothicNeo.medium,     size: 11)!
    public static let caption_2_M  = UIFont(name: GothicNeo.medium,     size: 10)!
}

// MARK: Line Height
extension UIFont {
    public func setLineHeight() -> CGFloat {
        switch self {
        case .heading_1_UL: 67
        case .heading_2_B:  40
        case .heading_3_B:  36
        case .heading_4_B:  32
        case .heading_5_B:  30
        case .title_1_B:    26
        case .title_1_M:    26
        case .title_2_B:    24
        case .title_2_SB:   24
        case .title_2_M:    24
        case .title_3_B:    23
        case .title_3_M:    23
        case .body_1_B:     21
        case .body_1_M:     21
        case .body_2_B:     20
        case .body_2_M:     20
        case .body_3_B:     19
        case .body_3_M:     19
        case .body_4_B:     18
        case .body_4_M:     18
        case .body_5_B:     17
        case .body_5_M:     17
        case .caption_1_M:  15
        case .caption_2_M:  14
        default:            20
        }
    }
}
