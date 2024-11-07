//
//  String+.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/10.
//

import Foundation

public extension String {
    
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
    
    var toDate: Date {
        DateFormatter.shared.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return DateFormatter.shared.date(from: self) ?? Date()
    }
    
    /// ISO 형식 설정 후 변경
    var isoToDate: Date {
        DateFormatter.shared.dateFormat = "yyyy.MM.dd'T'HH:mm:ss.SSSZ"
        return DateFormatter.shared.date(from: self) ?? Date()
    }
    
    func toTimeString(day: String, time: String) -> String {
        DateFormatter.shared.dateFormat = "a h시"
        
        var dateComponent = Calendar.shared.dateComponents([.year, .month, .day], from: Date())
        dateComponent.minute = 0
        dateComponent.second = 0
        
        switch day {
        case "현재":
            return Date().now
        case "오늘":
            break
        case "내일":
            dateComponent.day! += 1
        default:
            return Date().now
        }
        
        let period = time.prefix(2)
        let time = Int(time.dropFirst(3).dropLast()) ?? 0
        
        if period == "오후" && time != 12 {
            dateComponent.hour = time + 12
        }
        
        if period == "오전" && time == 12 {
            dateComponent.hour = 0
        } else {
            dateComponent.hour = time
        }
        
        guard let target = Calendar.shared.date(from: dateComponent) else { return Date().now }
        
        return target.now
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
    
    /// UUID 생성
    func generateSafeUUID() -> String {
        let uuid: String? = UUID().uuidString
        let tempID: String = "tempID-" + Date().microCurrent
        
        if uuid != nil && uuid?.isEmpty == false {
            return uuid ?? tempID
        } else {
            return tempID
        }
    }
    
    /// 버전비교 >> "2.44.1".compareVersion(with: "2.4312.54") -> .orderedDescending
    func compareVersion(with target: String) -> ComparisonResult {
        let compare1 = self.split(separator: ".").compactMap { Int($0) }
        let compare2 = target.split(separator: ".").compactMap { Int($0) }
        
        for (v1, v2) in zip(compare1, compare2) {
            var splited1 = v1
            var splited2 = v2
            let count1 = String(splited1).count
            let count2 = String(splited2).count
            
            if count1 < count2 {
                splited1 = Int(String(splited1) + String(repeating: "0", count: count2 - count1)) ?? 0
            } else if count1 > count2 {
                splited2 = Int(String(splited2) + String(repeating: "0", count: count1 - count2)) ?? 0
            }
            
            if splited1 < splited2 {
                return .orderedAscending
            } else if splited1 > splited2 {
                return .orderedDescending
            }
        }
        
        if compare1.count < compare2.count {
            return .orderedAscending
        } else if compare1.count > compare2.count {
            return .orderedDescending
        }
        
        return .orderedSame
    }
}
