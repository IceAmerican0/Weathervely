//
//  StyleSection.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/18/24.
//

import UIKit
import RxDataSources

enum StyleTabSectionModel {
    case banner(item: [Item])
    case styles(items: [Item])
//    case styles(items: [Item])
}

enum StyleTabItem {
    case banner(StyleBanner)
    case styles(StyleClosetInfo)
}

extension StyleTabSectionModel: SectionModelType {
    public typealias Item = StyleTabItem
    
    var items: [Item] {
        switch self {
        case .banner(item: let item):
            return item.map { $0 }
        case .styles(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: StyleTabSectionModel, items: [StyleTabItem]) {
        switch original {
        case .banner:
            self = .banner(item: items)
        case .styles:
            self = .styles(items: items)
        }
    }
        
    
}


//
//public enum StyleSection {
//    case normal(items: [Item])
//}
//
//public enum StyleSectionItem {
//    case normal(StyleClosets)
//}
//
//extension StyleSection: SectionModelType {
//
//    public typealias Item = StyleSectionItem
//    
//    public var items: [Item] {
//        switch self {
//        case .normal(items: let items): items.map { $0 }
//        }
//    }
//    
//    public init(original: StyleSection, items: [StyleSectionItem]) {
//        switch original {
//        case .normal: self = .normal(items: items)
//        }
//    }
//    
//    
//}
