//
//  DateFormatter+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/06.
//

import Foundation

public extension DateFormatter {
    static var shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()
}
