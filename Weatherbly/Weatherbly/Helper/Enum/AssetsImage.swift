//
//  AssetsImage.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/

import UIKit

enum AssetsImage: String {
    
    case navigationBackButton
    case upArrow
    case downArrow
    case editNameIcon
    case whiteHeart
    case settingTemperatureIcon
    case settingStyleIcon
    case settingLocationIcon
    case settingInquryIcon
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
