//
//  UIColor+Extension.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/11.
//

import UIKit


extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString:String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.startIndex
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

// MARK: Custom Color
public extension UIColor {
    static let blue10 = UIColor(named: "blue10")
    static let blue50 = UIColor(named: "blue50")
    static let blue100 = UIColor(named: "blue100")
    static let blue150 = UIColor(named: "blue150")
    static let blue200 = UIColor(named: "blue200")
    static let blue300 = UIColor(named: "blue300")
    static let blue400 = UIColor(named: "blue400")
    static let blue500 = UIColor(named: "blue500")
    static let blue600 = UIColor(named: "blue600")
    static let blue700 = UIColor(named: "blue700")
    static let blue800 = UIColor(named: "blue800")
    static let blue900 = UIColor(named: "blue900")
    
    static let violet10 = UIColor(named: "violet10")
    static let violet50 = UIColor(named: "violet50")
    static let violet100 = UIColor(named: "violet100")
    static let violet150 = UIColor(named: "violet150")
    static let violet200 = UIColor(named: "violet200")
    static let violet300 = UIColor(named: "violet300")
    static let violet400 = UIColor(named: "violet400")
    static let violet500 = UIColor(named: "violet500")
    static let violet600 = UIColor(named: "violet600")
    static let violet700 = UIColor(named: "violet700")
    static let violet800 = UIColor(named: "violet800")
    static let violet900 = UIColor(named: "violet900")
    
    static let gray10 = UIColor(named: "gray10")
    static let gray20 = UIColor(named: "gray20")
    static let gray30 = UIColor(named: "gray30")
    static let gray40 = UIColor(named: "gray40")
    static let gray50 = UIColor(named: "gray50")
    static let gray60 = UIColor(named: "gray60")
    static let gray70 = UIColor(named: "gray70")
    static let gray80 = UIColor(named: "gray80")
    static let gray90 = UIColor(named: "gray90")
    static let gray100 = UIColor(named: "gray100")
    static let gray200 = UIColor(named: "gray200")
    static let gray300 = UIColor(named: "gray300")
    static let gray400 = UIColor(named: "gray400")
    static let gray500 = UIColor(named: "gray500")
    static let gray600 = UIColor(named: "gray600")
    static let gray700 = UIColor(named: "gray700")
    static let gray800 = UIColor(named: "gray800")
    static let gray900 = UIColor(named: "gray900")
    
    static let red10 = UIColor(named: "red10")
    static let red50 = UIColor(named: "red50")
    static let red100 = UIColor(named: "red100")
    static let red150 = UIColor(named: "red150")
    static let red200 = UIColor(named: "red200")
    static let red300 = UIColor(named: "red300")
    static let red400 = UIColor(named: "red400")
    static let red500 = UIColor(named: "red500")
    static let red600 = UIColor(named: "red600")
    static let red700 = UIColor(named: "red700")
    static let red800 = UIColor(named: "red800")
    static let red900 = UIColor(named: "red900")
    
    static let salmon10 = UIColor(named: "salmon10")
    static let salmon50 = UIColor(named: "salmon50")
    static let salmon100 = UIColor(named: "salmon100")
    static let salmon150 = UIColor(named: "salmon150")
    static let salmon200 = UIColor(named: "salmon200")
    static let salmon300 = UIColor(named: "salmon300")
    static let salmon400 = UIColor(named: "salmon400")
    static let salmon500 = UIColor(named: "salmon500")
    static let salmon600 = UIColor(named: "salmon600")
    static let salmon700 = UIColor(named: "salmon700")
    static let salmon800 = UIColor(named: "salmon800")
    static let salmon900 = UIColor(named: "salmon900")
    
    static let orange10 = UIColor(named: "orange10")
    
    static let yellow10 = UIColor(named: "yellow10")
    
    static let pistachio10 = UIColor(named: "pistachio10")
    
    static let green10 = UIColor(named: "green10")
    
    static let mint10 = UIColor(named: "mint10")
    
    static let sky10 = UIColor(named: "sky10")
    
    static let lightBlue10 = UIColor(named: "lightBlue10")
    
    static let pink10 = UIColor(named: "pink10")
}
