//
//  CSColor.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/11.
//

import UIKit

enum CSColor {
   case _0__54
   case _0__03
   case _40_106_167
   case _178_36_36
   case _186_141_244
   case _209_240_252
   case _220_220_220
   case _236_207_255
   
   
    var color: UIColor {
        switch self {
        case ._0__03:
            return UIColor(r: 0, g: 0, b: 0, a: 0.3)
        case ._0__54:
            return UIColor(r: 0, g: 0, b: 0, a: 0.54)
        case ._40_106_167:
            return UIColor(r: 40, g: 106, b: 167)
        case ._178_36_36:
            return UIColor(r: 178, g: 36, b: 36)
        case ._186_141_244:
            return UIColor(r: 186, g: 141, b: 244)
        case ._209_240_252:
            return UIColor(r: 209, g: 240, b: 252)
        case ._220_220_220:
            return UIColor(r: 220, g: 220, b: 220)
        case ._236_207_255:
            return UIColor(r: 236, g: 207, b: 255)
        }
    }
    
    // MARK: - Layer 관련된색상을 설정할 때는 UIColor 가 아닌 cgColor를 사용한다.

       var cgColor: CGColor {
           self.color.cgColor
       }
   }
