//
//  AssetsImage.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/

import UIKit

enum AssetsImage: String {
    
    // Arrow
    case navigationBackButton
    case upArrow
    case downArrow
    
    // Common
    case daily
    case setting
    case schedule
    
    // Weather
    case cloudyMoonMain
    case cloudySunMain
    case cloudySunTen
    case grayRain1Main
    case grayRain2Main
    case grayRainTen
    case moonMain
    case rainyMain
    case rainyTen
    case sunCloudyMain
    case sunCloudyTen
    case sunnyMain
    case thunderMain
    case thunderTen
    case whiteRainTen
    case windyMoonMain
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
