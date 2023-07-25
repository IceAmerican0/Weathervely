//
//  AssetsImage.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/

import UIKit

enum AssetsImage: String {
    
    // Arrow
    case downArrow
    case navigationBackButton
    case rightArrow
    case upArrow
    
    // Background
    case cloudyAfternoon
    case cloudyDawn
    case cloudyEvening
    case cloudyLunch
    case cloudyMorning
    case sunnyAfternoon
    case sunnyDawn
    case sunnyEvening
    case sunnyLunch
    case sunnyMorning
    
    // Common
    case clockIcon
    case daily
    case delete
    case dust
    case humidity
    case sampleCloth
    case schedule
    case search
    case thermometer
    case whiteHeart
    
    // Setting
    case editNameIcon
    case setting
    case settingInquryIcon
    case settingLocationIcon
    case settingStyleIcon
    case settingTemperatureIcon
    
    // Weather
    case cloudyMoonMain
    case cloudySunMain
    case cloudySunTen
    case moonMain
    case rain
    case rainyMain
    case rainyTen
    case sunCloudyMain
    case sunCloudyTen
    case sunnyMain
    case sunnyTen
    case thunderMain
    case thunderTen
    case windyMoonMain
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
