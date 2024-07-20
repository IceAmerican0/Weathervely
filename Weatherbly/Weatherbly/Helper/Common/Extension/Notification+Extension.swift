//
//  Notification+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/16/24.
//

import Foundation

extension Notification.Name {
    static let categoryTagTap = Notification.Name("CategoryTagDidTap")
    static let styleClosetTap = Notification.Name("StyleTabClosetDidTap")
    static let styleTagTap = Notification.Name("styleTapDidTap")
    static let tpyeCategoryName: (String) -> Notification.Name = { key in
        return Notification.Name(key)
    }
}
