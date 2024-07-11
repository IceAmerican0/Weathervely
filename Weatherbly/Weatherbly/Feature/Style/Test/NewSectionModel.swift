//
//  NewSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import RxDataSources

enum NewStyleTabSectionModel {
    case banner(item: [Item])
    case types(header: [ClosetTypeInfo], items: [Item])
    case styles(header: (typeInfo: ClosetTypeInfo, categories: [MCategoryInfo]), items: [Item])
}

enum NewStyleTabItem {
    case banner(StyleBanner)
    case type([NewStyleTabSectionModel])
    case styles(NewClosetInfo)
}

extension NewStyleTabSectionModel: SectionModelType {
    public typealias Item = NewStyleTabItem
    
    var items: [Item] {
        switch self {
        case .banner(item: let item): item
        case .types(_, items: let item): item.map { $0 }
        case .styles(_, items: let items): items.map { $0 }
        }
    }
    
    init(original: NewStyleTabSectionModel, items: [NewStyleTabItem]) {
        switch original {
        case .banner:
            self = .banner(item: items)
        case .types(let header, _):
            self = .types(header: header, items: items)
        case .styles(let header, _):
            self = .styles(header: header, items: items)
        }
    }
        
    
}


