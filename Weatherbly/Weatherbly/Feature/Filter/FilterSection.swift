//
//  FilterSection.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import RxDataSources

public enum FilterSection {
    case style(items: [Item])
    case item(category: String, items: [Item])
}

public enum FilterSectionItem {
    case style(FilterStyleListInfo)
    case item(FilterItemListInfo)
}

extension FilterSection: SectionModelType {
    public typealias Item = FilterSectionItem
    
    public var items: [Item] {
        switch self {
        case .style(items: let items):
            items.map { $0 }
        case .item(category: _, items: let items):
            items.map { $0 }
        }
    }
    
    public init(original: FilterSection, items: [Item]) {
        switch original {
        case .style:
            self = .style(items: items)
        case let .item(category, _):
            self = .item(category: category, items: items)
        }
    }
}
