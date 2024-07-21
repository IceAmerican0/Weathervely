//
//  StyleSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import Foundation
import RxDataSources

typealias SyleSectionItem = StyleTabItem
enum StyleTabItem: Equatable, IdentifiableType  {

    case banner(StyleBanner)
    case type([StyleTabSectionModel])
    case styles(NewClosetInfo)
    case closets(NewClosetInfo)
    
    var identity: String {
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

enum StyleTabSectionModel: AnimatableSectionModelType {
    
//    typealias Item = StyleTabItem
    
    case banner(item: [SyleSectionItem])
    case types(header: [ClosetTypeInfo], items: [SyleSectionItem])
    case styles(header: (typeInfo: ClosetTypeInfo, categories: [MCategoryInfo]), items: [SyleSectionItem])
    case closets(item: [SyleSectionItem])
    
    var identity: String {
        switch self {
        case .banner: return "banner"
        case .types: return UUID().uuidString.identity
        case .styles(let header): return header.header.typeInfo.identity
        case .closets: return "closets"
        }
    }
    
    var items: [SyleSectionItem] {
        switch self {
        case .banner(item: let item): item
        case .types(_, items: let item): item.map { $0 }
        case .styles(_, items: let items): items
        case .closets(item: let items): items.map { $0 }
        }
    }
}


extension StyleTabSectionModel: SectionModelType, Equatable, IdentifiableType{
    static func == (lhs: StyleTabSectionModel, rhs: StyleTabSectionModel) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    init(original: StyleTabSectionModel, items: [SyleSectionItem]) {
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


