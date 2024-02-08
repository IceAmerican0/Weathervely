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
        }
        return returnValue + "시"
    }
    
    var forecastValidTime: String {
        if self == "0000" || self == "0100" || self == "0200" {
            return "0300"
        }
        
        return self
    }
    
    /// "오전/오후 00시" 입력 > 오전일시 true
    func isAM() -> Bool {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "a h시"

        guard let date = dateFormatter.date(from: self) else {
            return false
        }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        return (6...17).contains(hour)
    }

    /// "1.0.0" -> 100
    func versionToInt() -> Int {
        Int(self.replacingOccurrences(of: ".", with: "")) ?? 100
    }
}
