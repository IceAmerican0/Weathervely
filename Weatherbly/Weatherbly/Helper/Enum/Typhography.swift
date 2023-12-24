//
//  Typhography.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import Foundation
import UIKit

enum Typhography {
    case bold
    case medium
    case ultraLight
    
    var CSFont: UIFont {
        switch self {
        case .bold(let size: CGFloat)
            UIFont.system)
        case .medium
        }
    }
}
