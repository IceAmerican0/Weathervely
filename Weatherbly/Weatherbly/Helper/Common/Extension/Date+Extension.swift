//
//  Date+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/17.
//

import UIKit

extension Date {
    
    var yesterdayTime: String {
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: date)
    }
    
    var yesterdayDate: String {
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var todayTime: String {
        
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: date)
    }
    
    var todayDate: String {
        
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var tomorrowDate: String {
        let date = Calendar.current.date(byAdding: .day, value: +1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var dayAfterTomorrowDate: String {
        let date = Calendar.current.date(byAdding: .day, value: +2, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    var twoDaysAfterTomorrowDate: String {
        let date = Calendar.current.date(byAdding: .day, value: +3, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyyMMdd"
        
        return dateFormmater.string(from: date)
    }
    
    
    func dayAfter(_ value: Int) -> Int {
        let date = Calendar.current.date(byAdding: .day, value: value, to: self)!
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return Int(dateFormatter.string(from: date))!
    }
}
