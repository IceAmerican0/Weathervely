//
//  FilterSection.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import RxDataSources

public enum FilterSection {
    case style(items: [Item])
    case cloth(items: [Item])
}

public enum FilterSectionItem {
    case style(FilterStyleListInfo)
    case cloth(FilterItemListInfo)
}

extension FilterSection: SectionModelType {
    public typealias Item = FilterSectionItem
    
    public var items: [Item] {
        switch self {
        case .style(items: let items): items.map { $0 }
        case .cloth(items: let items): items.map { $0 }
        }
    }
    
    public init(original: FilterSection, items: [Item]) {
        switch original {
        case .style: self = .style(items: items)
        case .cloth: self = .cloth(items: items)
        }
    }
}
