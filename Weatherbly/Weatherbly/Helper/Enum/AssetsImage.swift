//
//  AssetsImage.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/

import UIKit

public enum AssetsImage: String {
    
    // Arrow
    case downArrow
    case navigationBackButton
    case rightArrow
    case toolTipArrow
    case upArrow
    
    // Background
    case cloudyAfternoon
    case cloudyEvening
    case cloudyMorning
    case sunnyAfternoon
    case sunnyEvening
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
    case touchIcon
    case wifiError
    
    // Setting
    case editNameIcon
    case setting
    case settingInquryIcon
    case settingLocationIcon
    case settingMenuButton
    case settingStyleIcon
    case settingTemperatureIcon
    case whiteHeart
    
    // Weather
    case weatherLoadingImage
    case sun
    case moon
    case rainny
    case rainsnow
    case snow
    case sunCloudy
    case moonCloudy
    case clouds
    case windy
    
    // TenDayWeather
    case tenDayAmCloud
    case tenDayPmCloud
    case tenDayRain
    case tenDayRainSnow
    case tenDaySnow
    case tenDaySunny
    
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
