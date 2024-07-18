//
//  StyleSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import RxDataSources

enum StyleTabSectionModel {
    case banner(item: [Item])
    case types(header: [ClosetTypeInfo], items: [Item])
    case styles(header: (typeInfo: ClosetTypeInfo, categories: [MCategoryInfo]), items: [Item])
    case closets(item: [Item])
}

enum StyleTabItem {
    case banner(StyleBanner)
    case type([StyleTabSectionModel])
    case styles(CSStyleSectionItem)
    case cloets(NewClosetInfo)
}

struct CSStyleSectionItem {
    var typeInfo: ClosetTypeInfo?
    var categories: [MCategoryInfo]?
    var closets: [NewClosetInfo]?
}

extension StyleTabSectionModel: SectionModelType {
    public typealias Item = StyleTabItem
    
    var items: [Item] {
        switch self {
        case .banner(item: let item): item
        case .types(_, items: let item): item.map { $0 }
        case .styles(_, items: let items): items
        case .closets(item: let items): items.map { $0 }
        }
    }
    
    init(original: StyleTabSectionModel, items: [StyleTabItem]) {
        switch original {
        case .banner:
            self = .banner(item: items)
        case .types(let header, _):
            self = .types(header: header, items: items)
        case .styles(let header, _):
            self = .styles(header: header, items: items)
        case .closets(_):
            self = .closets(item: items)
        }
    }
        
    
}


