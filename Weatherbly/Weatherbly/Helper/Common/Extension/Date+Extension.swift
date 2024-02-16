//
//  Date+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/17.
//

import UIKit

extension Date {
    
    // MARK: - Yesterday

    var yesterdayTime: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: date)
    }
    
    var yesterdayThousandFormat: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "HH00"
        
        return dateFormmater.string(from: date).forecastValidTime
    }
    
    
    var yesterdayDate: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var yesterdayHyphenFormat: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd"
        
        return dateFormmater.string(from: date)
    }
    
    
    // MARK: - Today

    // DateTimePicker 형식
    var todayDatePickerFormat: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: self)
    }
    
    // 날짜별로 정렬된 날씨 Entity에서 특정시간대 카테고리 검색 시 사용
    var todayThousandFormat: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "HH00"
        
        return dateFormmater.string(from: self)
    }
    
    var today: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: self)
    }
    
    var todayphenFormat: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd"
        
        return dateFormmater.string(from: self)
    }
    
    var todayHourFormat: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd HH:00"
        
        return dateFormmater.string(from: self)
    }
    
    /// "yyyy년 MM월 dd일 EEEE"
    var todayWeekFormat: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy년 MM월 dd일 EEEE"
        
        return dateFormmater.string(from: self)
    }
    
    func todaySelectedFormat(_ selectedHour: String) -> String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd \(selectedHour)"
        
        return dateFormmater.string(from: self)
    }
    
    // MARK: - Tomorrow

    // 메인 날씨 Entity에서 날짜별로 정렬할때 형식
    var tomorrow: String {
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: self)
    }
    
    func tomorrowSelectedFormat(_ selectedHour: String) -> String {
        let date = Calendar.current.date(byAdding: .day, value: +1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd \(selectedHour)"
        
        return dateFormmater.string(from: date)
    }
    
    var tomorrowThousandFormat: String {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "HH00"
        
        return dateFormmater.string(from: date)
    }
    
    // MARK: - Day after tomorrow
    var dayAfterTomorrow: String {
        let date = Calendar.current.date(byAdding: .day, value: +2, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    
    // MARK: - two Day after tomorrow
    var twoDaysAfterTomorrow: String {
        let date = Calendar.current.date(byAdding: .day, value: +3, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
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
}

