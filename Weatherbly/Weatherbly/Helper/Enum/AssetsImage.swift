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
    case toolTipArrow
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
    case closeButton
    case connectionLost
    case daily
    case defaultImage
    case delete
    case dust
    case gradientButton
    case humidity
    case launchLogo
    case mainLogo
    case regionChange
    case sampleCloth
    case schedule
    case search
    case thermometer
    case wifiError
    
    // Setting
    case editNameIcon
    case setting
    case settingInquryIcon
    case settingLocationIcon
    case settingStyleIcon
    case settingTemperatureIcon
    case whiteHeart
    
    // Weather
    case blurCloudImage
    case cloudyImage
    case cloudyNightImage
    case nightImage
    case rainnyImage
    case sunnyImage
    case weatherLoadingImage
    case windyImage
    
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
