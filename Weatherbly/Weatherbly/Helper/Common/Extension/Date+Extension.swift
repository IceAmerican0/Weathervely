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
    
    var yesterday24Time: String {
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "HH00"
        
        return dateFormmater.string(from: date)
    }
    
    var yesterdayDate: String {
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    
    // MARK: - Today

    // DateTimePicker 형식
    var todayTime: String {
        
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: date)
    }
    
    // 날짜별로 정렬된 날씨 Entity에서 특정시간대 카테고리 검색 시 사용
    var today24Time: String {
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "HH00"
        
        return dateFormmater.string(from: date)
    }
    
    var todayDate: String {
        
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var todayParamType: String {
        
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd HH:00"
        
        return dateFormmater.string(from: date)
    }
    
    // MARK: - Tomorrow

    // 메인 날씨 Entity에서 날짜별로 정렬할때 형식
    var tomorrowDate: String {
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var tomorrowParamType: String {
        let date = Calendar.current.date(byAdding: .day, value: +1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd HH:00"
        
        return dateFormmater.string(from: date)
    }
    
    // MARK: - Day after tomorrow

    var dayAfterTomorrowDate: String {
        let date = Calendar.current.date(byAdding: .day, value: +2, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    
    // MARK: - two Day after tomorrow

    var twoDaysAfterTomorrowDate: String {
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
}
