//
//  Calendar+.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/24.
//

import Foundation

public extension Calendar {
    static var shared: Calendar = {
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? currentCalendar.timeZone
        currentCalendar.locale = Locale(identifier: "ko_KR")
        return currentCalendar
    }()
}
