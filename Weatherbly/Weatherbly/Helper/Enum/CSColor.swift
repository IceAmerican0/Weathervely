//
//  CSColor.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/11.
//

import UIKit

enum CSColor {
    case none
    case _0__03
    case _0__054
    case _0__1
    case _40_106_167
    case _50_50_50
    case _102_102_102
    case _126_212_255
    case _151_151_151
    case _155_155_155
    case _172_107_255
    case _172_107_255_004
    case _178_36_36
    case _186_141_244
    case _209_240_252
    case _210_210_210
    case _210_175_255
    case _212_195_233_39
    case _214_214_214
    case _217_217_217
    case _220_220_220
    case _236_207_255
    case _237_237_237
    case _248_248_248
    case _253_253_253
    case _255_163_163
    case _255_255_255
    

    var color: UIColor {
        switch self {
        case .none:
            return UIColor(r: 39, g: 39, b: 39)
        case ._0__03:
            return UIColor(r: 0, g: 0, b: 0, a: 0.3)
        case ._0__054:
            return UIColor(r: 0, g: 0, b: 0, a: 0.54)
        case ._0__1:
            return UIColor(r: 0, g: 0, b: 0, a: 1)
        case ._40_106_167:
            return UIColor(r: 40, g: 106, b: 167)
        case ._50_50_50:
            return UIColor(r: 50, g: 50, b: 50)
        case ._102_102_102:
            return UIColor(r: 102, g: 102, b: 102)
        case ._126_212_255:
            return UIColor(r: 126, g: 212, b: 255)
        case ._151_151_151:
            return UIColor(r: 151, g: 151, b: 151)
        case ._155_155_155:
            return UIColor(r: 155, g: 155, b: 155)
        case ._172_107_255:
            return UIColor(r: 172, g: 107, b: 255)
        case ._172_107_255_004:
            return UIColor(r: 172, g: 107, b: 255, a: 0.04)
        case ._178_36_36:
            return UIColor(r: 178, g: 36, b: 36)
        case ._186_141_244:
            return UIColor(r: 186, g: 141, b: 244)
        case ._209_240_252:
            return UIColor(r: 209, g: 240, b: 252)
        case ._210_210_210:
            return UIColor(r: 210, g: 210, b: 210)
        case ._210_175_255:
            return UIColor(r: 210, g: 175, b: 255)
        case ._212_195_233_39:
            return UIColor(r: 212, g: 195, b: 233, a: 0.39)
        case ._214_214_214:
            return UIColor(r: 214, g: 214, b: 214)
        case ._217_217_217:
            return UIColor(r: 217, g: 217, b: 217)
        case ._220_220_220:
            return UIColor(r: 220, g: 220, b: 220)
        case ._236_207_255:
            return UIColor(r: 236, g: 207, b: 255)
        case ._237_237_237:
            return UIColor(r: 237, g: 237, b: 237, a: 0.5)
        case ._248_248_248:
            return UIColor(r: 248, g: 248, b: 248)
        case ._253_253_253:
            return UIColor(r: 253, g: 253, b: 253)
        case ._255_163_163:
            return UIColor(r: 255, g: 163, b: 163)
        case ._255_255_255:
            return UIColor(r: 255, g: 255, b: 255, a: 0.5)
        }
    }
    
    // MARK: - Layer 관련된색상을 설정할 때는 UIColor 가 아닌 cgColor를 사용한다.
    var cgColor: CGColor {
       self.color.cgColor
    }
}
