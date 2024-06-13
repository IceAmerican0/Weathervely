//
//  Date+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/17.
//

import Foundation

extension Date {
    // MARK: Now
    var now: String {
        DateFormatter.shared.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return DateFormatter.shared.string(from: self)
    }
    
    /// 오전 / 오후 00시
    func currentTime() -> String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "a h시"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: - Yesterday
    var yesterdayTime: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "MM dd a hh"
        
        return dateFormatter.string(from: date)
    }
    
    var yesterdayThousandFormat: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "HH00"
        
        return dateFormatter.string(from: date).forecastValidTime
    }
    
    var yesterdayDate: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    var yesterdayHyphenFormat: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Today
    /// DateTimePicker 형식
    var todayDatePickerFormat: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "MM dd a hh"
        
        return dateFormatter.string(from: self)
    }
    
    /// 날짜별로 정렬된 날씨 Entity에서 특정시간대 카테고리 검색 시 사용
    var todayThousandFormat: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "HH00"
        
        return dateFormatter.string(from: self)
    }
    
    var today: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }
    
    var todayphenFormat: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    var todayHourFormat: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy-MM-dd HH:00"
        
        return dateFormatter.string(from: self)
    }
    
    /// "yyyy년 MM월 dd일 EEEE"
    var todayWeekFormat: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        
        return dateFormatter.string(from: self)
    }
    
    func todaySelectedFormat(_ selectedHour: String) -> String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy-MM-dd \(selectedHour)"
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: - Tomorrow
    /// 메인 날씨 Entity에서 날짜별로 정렬할때 형식
    var tomorrow: String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }
    
    func tomorrowSelectedFormat(_ selectedHour: String) -> String {
        let date = Calendar.current.date(byAdding: .day, value: +1, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy-MM-dd \(selectedHour)"
        
        return dateFormatter.string(from: date)
    }
    
    var tomorrowThousandFormat: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "HH00"
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Day after tomorrow
    var dayAfterTomorrow: String {
        let date = Calendar.current.date(byAdding: .day, value: +2, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - two Day after tomorrow
    var twoDaysAfterTomorrow: String {
        let date = Calendar.current.date(byAdding: .day, value: +3, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - custom day
    func dayAfter(_ value: Int) -> Int {
        let date = Calendar.current.date(byAdding: .day, value: value, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return Int(dateFormatter.string(from: date))!
    }
    
    func tenDaysFormat(_ value: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: value, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "M.dd"
        
        return dateFormatter.string(from: date)
    }
    
    func dayOfTheWeek(_ value: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: value, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "E"
        
        return dateFormatter.string(from: date)
    }
    
    func timePassed() -> String {
        let second = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if second < minute {
            return "방금 전"
        }
        
        if second < hour {
            return "\(second / minute)분 전"
        }
        
        if second < day {
            return "\(second / hour)시간 전"
        }
        
        if second < week {
            return "\(second / day)일 전"
        }
        
        DateFormatter.shared.dateFormat = "yyyy.MM.dd"
        return DateFormatter.shared.string(from: self)
    }
}

