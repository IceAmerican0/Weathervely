//
//  Date+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/17.
//

import UIKit

extension Date {
    
    var yesterday: String {
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: date)
    }
    
    var today: String {
        
        let date = self
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "MM dd a hh"
        
        return dateFormmater.string(from: date)
    }
}
