//
//  StyleSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import Foundation
import RxDataSources

public enum StyleTabItem: Equatable, IdentifiableType  {

    case banner(StyleBanner)
    case type([StyleTabSectionModel])
    case styles(ClosetInfo)
    case closets(ClosetInfo)
    
    public var identity: String {
        switch self {
        case .banner(let item):
            return "banner-\(item.identity)"
        case .type(let item):
            // FIXME: - 잘작동하는지 보고 나중에 수정 필요
            return "type-\(item.map { $0.identity })"
        case .styles(let item):
            return "styles-\(item.identity)"
        case .closets(let item):
            return "closets-\(item.identity)"
        }
    }
}

public enum StyleTabSectionModel: AnimatableSectionModelType {
    case banner(item: [StyleTabItem])
    case types(header: [ClosetTypeInfo], items: [StyleTabItem])
    case styles(header: (typeInfo: ClosetTypeInfo, categories: [StyleMediumCategoryInfo]), items: [StyleTabItem])
    case closets(item: [StyleTabItem])
    
    public var identity: String {
        switch self {
        case .banner: return "banner"
        case .types: return UUID().uuidString.identity
        case .styles(let header): return header.header.typeInfo.identity
        case .closets: return "closets"
        }
    }
    
    public var items: [StyleTabItem] {
        switch self {
        case .banner(item: let item): item
        case .types(_, items: let item): item.map { $0 }
        case .styles(_, items: let items): items
        case .closets(item: let items): items.map { $0 }
        }
    }
}


extension StyleTabSectionModel: SectionModelType, Equatable, IdentifiableType{
    public static func == (lhs: StyleTabSectionModel, rhs: StyleTabSectionModel) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    public init(original: StyleTabSectionModel, items: [StyleTabItem]) {
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


