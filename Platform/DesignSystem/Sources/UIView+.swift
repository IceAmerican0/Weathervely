//
//  UIView+.swift
//  DesignSystem
//
//  Created by Khai on 10/29/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import ResourcePackage
import UIKit
import Then

public extension UIView {
    func shimmer(_ radius: CGFloat) -> UIView {
        ShimmerView().setCornerRadius(radius)
    }
    
    func setWeatherUI(weather: String, time: String) -> ([UIColor], UIImage) {
        let isAM = time.isAM()
        
        return switch weather {
        case "맑음": isAM ?
            (.gradient10, UIImage.sunny_am) :
            (.gradient20, UIImage.sunny_pm)
        case "흐림": (.gradient30, UIImage.cloudy)
        case "구름많음": isAM ?
            (.gradient40, UIImage.clouds_am) :
            (.gradient50, UIImage.clouds_pm)
        case "비",
             "구름많고 비",
             "소나기",
             "흐리고 비": (.gradient60, UIImage.rainy)
        case "눈비": (.gradient70, UIImage.snowyRainy)
        case "눈": (.gradient80, UIImage.snowy)
        case "바람": (.gradient90, UIImage.windy)
        default: (.gradient10, UIImage.sunny_am)
        }
    }
    
    func setTenDaysWeatherUI(weather: String, time: String) -> ([UIColor], UIImage) {
        switch weather {
        case "맑음": (.gradient10, UIImage.ten_sunny_am)
        case "흐림": (.gradient30, UIImage.ten_cloudy)
        case "구름많음": (.gradient40, UIImage.ten_clouds_am)
        case "비",
             "구름많고 비",
             "소나기",
             "흐리고 비": (.gradient60, UIImage.rainy)
        case "눈비": (.gradient70, UIImage.snowyRainy)
        case "눈": (.gradient80, UIImage.ten_snowy)
        case "바람": (.gradient90, UIImage.ten_windy)
        default: (.gradient10, UIImage.ten_sunny_am)
        }
    }
    
    func addGradient(colors: [UIColor]) {
        let gradient = CAGradientLayer().then {
            $0.colors = colors.map { $0.cgColor }
            $0.locations = [0.01, 0.98]
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = CGPoint(x: 1, y: 1)
            $0.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
            $0.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.insertSublayer(gradient, at: 0)
    }
}
