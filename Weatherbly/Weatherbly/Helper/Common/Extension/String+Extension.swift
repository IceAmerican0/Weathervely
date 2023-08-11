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
    
    var hourToMain: String {
        
        print(#function, self)
        var returnValue = ""
        if self == Date().today24Time {
            return "현재"
        }
            var hour = Int(self)!
            
            if hour < 2400 {
            // 오늘 시간
            returnValue = (hour < 1200) ? "오전 \(returnValue)" : "오후 \(returnValue)"
            returnValue = (hour < 1200)
                ? returnValue + String(hour).trimmingCharacters(in: CharacterSet(charactersIn: "0"))
                :
                ((self == "2000")
                  ? returnValue + String(hour - 1200).prefix(1)
                  : returnValue + String(hour - 1200).trimmingCharacters(in: CharacterSet(charactersIn: "0")))
                return returnValue + " 시"
            } else {
            // 내일 시간
                returnValue = (hour < 1200) ? "오전 \(returnValue)" : "오후 \(returnValue)"
                returnValue = (((hour - 2400)) < 1000) ? returnValue + String(hour).trimmingCharacters(in: CharacterSet(charactersIn: "0")) : returnValue + String(hour - 1200).prefix(2)
                return returnValue + " 시"
            }
    }
    
}
