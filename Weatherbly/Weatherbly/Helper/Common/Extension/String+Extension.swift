//
//  String+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/10.
//

import Foundation

extension String {
    
    var addColon: String {
        return String(self.prefix(2)) + ":" + String(self.suffix(2))
    }
    
    var hourToMainLabel: String {
        
        var returnValue = ""
        if self == Date().todayThousandFormat { return "현재" }
            var hour = Int(self)! / 100
            if hour < 24 {
                // 오늘 시간
                
                if hour < 12 {
                    returnValue = "오전 \(String(hour))"
                } else if hour == 12 {
                    returnValue = "오후 \(String(hour))"
                } else {
                    returnValue = "오후 \(String(hour - 12))"
                }
                
                return returnValue + "시"
            } else {
                // 내일 시간
                hour -= 24
                
                if hour < 12 {
                    returnValue = "내일 오전 \(String(hour))"
                } else if hour == 12 {
                    returnValue = "내일 오후 \(String(hour))"
                } else {
                    returnValue = "내일 오후 \(String(hour - 12))"
                }
                
                return returnValue + "시"
            }
        
    }
    
}
