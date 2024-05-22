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
    case styles(header: [ClosetTypeInfo], items: [Item])
}

enum StyleTabItem {
    case banner(StyleBanner)
    case styles(ClosetTypeInfo)
}

extension StyleTabSectionModel: SectionModelType {
    public typealias Item = StyleTabItem
    
    var items: [Item] {
        switch self {
        case .banner(item: let item):
            return item
        case .styles(_, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: StyleTabSectionModel, items: [StyleTabItem]) {
        switch original {
        case .banner:
            self = .banner(item: items)
        case .styles(let header, _):
            self = .styles(header: header, items: items)
        }
    }
        
    
}

