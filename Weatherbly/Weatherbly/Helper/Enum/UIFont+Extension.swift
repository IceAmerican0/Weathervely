//
//  UIFont+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit

// MARK: AppleSDGothicNeo
public enum GothicNeo {
    static let heavy      = "AppleSDGothicNeoH"
    static let extraBold  = "AppleSDGothicNeoEB"
    static let bold       = "AppleSDGothicNeoB"
    static let semiBold   = "AppleSDGothicNeoSB"
    static let medium     = "AppleSDGothicNeoM"
    static let regular    = "AppleSDGothicNeoR"
    static let light      = "AppleSDGothicNeoL"
    static let ultraLight = "AppleSDGothicNeoUL"
    static let thin       = "AppleSDGothicNeoT"
}

// MARK: Custom Font
extension UIFont {
    static let heading_1_UL = UIFont(name: GothicNeo.ultraLight, size: 67)
    static let heading_2_B  = UIFont(name: GothicNeo.bold,       size: 40)
    static let heading_3_B  = UIFont(name: GothicNeo.bold,       size: 36)
    static let heading_4_B  = UIFont(name: GothicNeo.bold,       size: 32)
    static let heading_5_B  = UIFont(name: GothicNeo.bold,       size: 30)
    static let title_1_B    = UIFont(name: GothicNeo.bold,       size: 26)
    static let title_1_M    = UIFont(name: GothicNeo.medium,     size: 26)
    static let title_2_B    = UIFont(name: GothicNeo.bold,       size: 24)
    static let title_2_M    = UIFont(name: GothicNeo.medium,     size: 24)
    static let title_3_B    = UIFont(name: GothicNeo.bold,       size: 23)
    static let title_3_M    = UIFont(name: GothicNeo.medium,     size: 23)
    static let body_1_B     = UIFont(name: GothicNeo.bold,       size: 21)
    static let body_1_M     = UIFont(name: GothicNeo.medium,     size: 21)
    static let body_2_B     = UIFont(name: GothicNeo.bold,       size: 20)
    static let body_2_M     = UIFont(name: GothicNeo.medium,     size: 20)
    static let body_3_B     = UIFont(name: GothicNeo.bold,       size: 19)
    static let body_3_M     = UIFont(name: GothicNeo.medium,     size: 19)
    static let body_4_B     = UIFont(name: GothicNeo.bold,       size: 18)
    static let body_4_M     = UIFont(name: GothicNeo.medium,     size: 18)
    static let body_5_B     = UIFont(name: GothicNeo.bold,       size: 17)
    static let body_5_M     = UIFont(name: GothicNeo.medium,     size: 17)
    static let caption_1_M  = UIFont(name: GothicNeo.medium,     size: 15)
    static let caption_2_M  = UIFont(name: GothicNeo.medium,     size: 14)
}
