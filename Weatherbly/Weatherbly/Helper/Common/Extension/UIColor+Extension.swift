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
    static let clear10 = UIColor(named: "clear10")!
    
    static let white20 = UIColor(named: "white20")!
    static let white30 = UIColor(named: "white30")!
    
    static let black10 = UIColor(named: "black10")!
    static let black50 = UIColor(named: "black50")!
    static let black90 = UIColor(named: "black90")!
    
    static let dim68 = UIColor(named: "dim68")!
    
    static let blue10 = UIColor(named: "blue10")!
    static let blue50 = UIColor(named: "blue50")!
    static let blue100 = UIColor(named: "blue100")!
    static let blue150 = UIColor(named: "blue150")!
    static let blue200 = UIColor(named: "blue200")!
    static let blue300 = UIColor(named: "blue300")!
    static let blue400 = UIColor(named: "blue400")!
    static let blue500 = UIColor(named: "blue500")!
    static let blue600 = UIColor(named: "blue600")!
    static let blue700 = UIColor(named: "blue700")!
    static let blue800 = UIColor(named: "blue800")!
    static let blue900 = UIColor(named: "blue900")!
    
    static let violet10 = UIColor(named: "violet10")!
    static let violet50 = UIColor(named: "violet50")!
    static let violet100 = UIColor(named: "violet100")!
    static let violet150 = UIColor(named: "violet150")!
    static let violet200 = UIColor(named: "violet200")!
    static let violet300 = UIColor(named: "violet300")!
    static let violet400 = UIColor(named: "violet400")!
    static let violet500 = UIColor(named: "violet500")!
    static let violet600 = UIColor(named: "violet600")!
    static let violet700 = UIColor(named: "violet700")!
    static let violet800 = UIColor(named: "violet800")!
    static let violet900 = UIColor(named: "violet900")!
    
    static let kiwiGray90 = UIColor(named: "kiwiGray90")!
    static let kiwiGray700 = UIColor(named: "kiwiGray700")!
    static let gray10 = UIColor(named: "gray10")!
    static let gray20 = UIColor(named: "gray20")!
    static let gray30 = UIColor(named: "gray30")!
    static let gray40 = UIColor(named: "gray40")!
    static let gray50 = UIColor(named: "gray50")!
    static let gray60 = UIColor(named: "gray60")!
    static let gray70 = UIColor(named: "gray70")!
    static let gray80 = UIColor(named: "gray80")!
    static let gray90 = UIColor(named: "gray90")!
    static let gray100 = UIColor(named: "gray100")!
    static let gray200 = UIColor(named: "gray200")!
    static let gray300 = UIColor(named: "gray300")!
    static let gray400 = UIColor(named: "gray400")!
    static let gray500 = UIColor(named: "gray500")!
    static let gray600 = UIColor(named: "gray600")!
    static let gray700 = UIColor(named: "gray700")!
    static let gray800 = UIColor(named: "gray800")!
    static let gray900 = UIColor(named: "gray900")!
    
    static let red10 = UIColor(named: "red10")!
    static let red50 = UIColor(named: "red50")!
    static let red100 = UIColor(named: "red100")!
    static let red150 = UIColor(named: "red150")!
    static let red200 = UIColor(named: "red200")!
    static let red300 = UIColor(named: "red300")!
    static let red400 = UIColor(named: "red400")!
    static let red500 = UIColor(named: "red500")!
    static let red600 = UIColor(named: "red600")!
    static let red700 = UIColor(named: "red700")!
    static let red800 = UIColor(named: "red800")!
    static let red900 = UIColor(named: "red900")!
    
    static let salmon10 = UIColor(named: "salmon10")!
    static let salmon50 = UIColor(named: "salmon50")!
    static let salmon100 = UIColor(named: "salmon100")!
    static let salmon150 = UIColor(named: "salmon150")!
    static let salmon200 = UIColor(named: "salmon200")!
    static let salmon300 = UIColor(named: "salmon300")!
    static let salmon400 = UIColor(named: "salmon400")!
    static let salmon500 = UIColor(named: "salmon500")!
    static let salmon600 = UIColor(named: "salmon600")!
    static let salmon700 = UIColor(named: "salmon700")!
    static let salmon800 = UIColor(named: "salmon800")!
    static let salmon900 = UIColor(named: "salmon900")!
    
    static let orange10 = UIColor(named: "orange10")!
    static let orange50 = UIColor(named: "orange50")!
    static let orange100 = UIColor(named: "orange100")!
    static let orange150 = UIColor(named: "orange150")!
    static let orange200 = UIColor(named: "orange200")!
    static let orange300 = UIColor(named: "orange300")!
    static let orange400 = UIColor(named: "orange400")!
    static let orange500 = UIColor(named: "orange500")!
    static let orange600 = UIColor(named: "orange600")!
    static let orange700 = UIColor(named: "orange700")!
    static let orange800 = UIColor(named: "orange800")!
    static let orange900 = UIColor(named: "orange900")!
    
    static let yellow10 = UIColor(named: "yellow10")!
    static let yellow50 = UIColor(named: "yellow50")!
    static let yellow100 = UIColor(named: "yellow100")!
    static let yellow150 = UIColor(named: "yellow150")!
    static let yellow200 = UIColor(named: "yellow200")!
    static let yellow300 = UIColor(named: "yellow300")!
    static let yellow400 = UIColor(named: "yellow400")!
    static let yellow500 = UIColor(named: "yellow500")!
    static let yellow600 = UIColor(named: "yellow600")!
    static let yellow700 = UIColor(named: "yellow700")!
    static let yellow800 = UIColor(named: "yellow800")!
    static let yellow900 = UIColor(named: "yellow900")!
    
    static let pistachio10 = UIColor(named: "pistachio10")!
    static let pistachio50 = UIColor(named: "pistachio50")!
    static let pistachio100 = UIColor(named: "pistachio100")!
    static let pistachio150 = UIColor(named: "pistachio150")!
    static let pistachio200 = UIColor(named: "pistachio200")!
    static let pistachio300 = UIColor(named: "pistachio300")!
    static let pistachio400 = UIColor(named: "pistachio400")!
    static let pistachio500 = UIColor(named: "pistachio500")!
    static let pistachio600 = UIColor(named: "pistachio600")!
    static let pistachio700 = UIColor(named: "pistachio700")!
    static let pistachio800 = UIColor(named: "pistachio800")!
    static let pistachio900 = UIColor(named: "pistachio900")!
    
    static let green10 = UIColor(named: "green10")!
    static let green50 = UIColor(named: "green50")!
    static let green100 = UIColor(named: "green100")!
    static let green150 = UIColor(named: "green150")!
    static let green200 = UIColor(named: "green200")!
    static let green300 = UIColor(named: "green300")!
    static let green400 = UIColor(named: "green400")!
    static let green500 = UIColor(named: "green500")!
    static let green600 = UIColor(named: "green600")!
    static let green700 = UIColor(named: "green700")!
    static let green800 = UIColor(named: "green800")!
    static let green900 = UIColor(named: "green900")!
    
    static let mint10 = UIColor(named: "mint10")!
    static let mint50 = UIColor(named: "mint50")!
    static let mint100 = UIColor(named: "mint100")!
    static let mint150 = UIColor(named: "mint150")!
    static let mint200 = UIColor(named: "mint200")!
    static let mint300 = UIColor(named: "mint300")!
    static let mint400 = UIColor(named: "mint400")!
    static let mint500 = UIColor(named: "mint500")!
    static let mint600 = UIColor(named: "mint600")!
    static let mint700 = UIColor(named: "mint700")!
    static let mint800 = UIColor(named: "mint800")!
    static let mint900 = UIColor(named: "mint900")!
    
    static let sky10 = UIColor(named: "sky10")!
    static let sky50 = UIColor(named: "sky50")!
    static let sky100 = UIColor(named: "sky100")!
    static let sky150 = UIColor(named: "sky150")!
    static let sky200 = UIColor(named: "sky200")!
    static let sky300 = UIColor(named: "sky300")!
    static let sky400 = UIColor(named: "sky400")!
    static let sky500 = UIColor(named: "sky500")!
    static let sky600 = UIColor(named: "sky600")!
    static let sky700 = UIColor(named: "sky700")!
    static let sky800 = UIColor(named: "sky800")!
    static let sky900 = UIColor(named: "sky900")!
    
    static let lightBlue10 = UIColor(named: "lightBlue10")!
    static let lightBlue50 = UIColor(named: "lightBlue50")!
    static let lightBlue100 = UIColor(named: "lightBlue100")!
    static let lightBlue150 = UIColor(named: "lightBlue150")!
    static let lightBlue200 = UIColor(named: "lightBlue200")!
    static let lightBlue300 = UIColor(named: "lightBlue300")!
    static let lightBlue400 = UIColor(named: "lightBlue400")!
    static let lightBlue500 = UIColor(named: "lightBlue500")!
    static let lightBlue600 = UIColor(named: "lightBlue600")!
    static let lightBlue700 = UIColor(named: "lightBlue700")!
    static let lightBlue800 = UIColor(named: "lightBlue800")!
    static let lightBlue900 = UIColor(named: "lightBlue900")!
    
    static let pink10 = UIColor(named: "pink10")!
    static let pink50 = UIColor(named: "pink50")!
    static let pink100 = UIColor(named: "pink100")!
    static let pink150 = UIColor(named: "pink150")!
    static let pink200 = UIColor(named: "pink200")!
    static let pink300 = UIColor(named: "pink300")!
    static let pink400 = UIColor(named: "pink400")!
    static let pink500 = UIColor(named: "pink500")!
    static let pink600 = UIColor(named: "pink600")!
    static let pink700 = UIColor(named: "pink700")!
    static let pink800 = UIColor(named: "pink800")!
    static let pink900 = UIColor(named: "pink900")!
    
    static let gdBlue30 = UIColor(named: "gdBlue30")!
    static let gdBlue40 = UIColor(named: "gdBlue40")!
    static let gdBlue70 = UIColor(named: "gdBlue70")!
}

// MARK: Gradient
extension [UIColor] {
    static let gradient10: [UIColor] = [.violet500, .blue500]
    static let gradient20: [UIColor] = [.violet500, .gray100]
    static let gradient30: [UIColor] = [.violet150, .gdBlue30]
    static let gradient40: [UIColor] = [.blue200, .gdBlue40]
    static let gradient50: [UIColor] = [.gray60, .gray400]
    static let gradient60: [UIColor] = [.blue500, .gray70]
    static let gradient70: [UIColor] = [.blue500, .gdBlue70]
    static let gradient80: [UIColor] = [.blue200, .blue700]
    static let gradient90: [UIColor] = [.violet500, .blue300]
}
