//
//  CSFont.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import Foundation
import UIKit

/*
 AppleSDGothicNeoB
 AppleSDGothicNeoEB
 AppleSDGothicNeoH
 AppleSDGothicNeoL
 AppleSDGothicNeoM
 AppleSDGothicNeoR
 AppleSDGothicNeoSB
 AppleSDGothicNeoT
 AppleSDGothicNeoUL
 */

enum CSFont {
    case heading_1_UL
    case heading_2_B
    
    var CSFontL: UIFont {
        switch self {
        case .heading_1_UL:
            UIFont(name: "AppleSDGothicNeoUL", size: 56)
        case .heading_2_B:
            UIFont(name: "Apple", size: 32)
            
        }
    }
}
