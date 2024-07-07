//
//  StyleSection.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/18/24.
//

import RxDataSources

enum StyleTabSectionModel {
    case banner(item: [Item])
    case types(header: [ClosetTypeInfo])
    case styles(header: (typeInfo: ClosetTypeInfo, categories: [MCategoryInfo]), items: [Item])
}

enum StyleTabItem {
    case banner(StyleBanner)
    case styles(NewClosetInfo)
}

extension StyleTabSectionModel: SectionModelType {
    public typealias Item = StyleTabItem
    
    var items: [Item] {
        switch self {
        case .banner(item: let item): item
        case .types: []
        case .styles(_, items: let items): items.map { $0 }
        }
    }
    
    init(original: StyleTabSectionModel, items: [StyleTabItem]) {
        switch original {
        case .banner:
            self = .banner(item: items)
        case .types(let header):
            self = .types(header: header)
        case .styles(let header, _):
            self = .styles(header: header, items: items)
        }
    }
        
    
}

