//
//  StyleSection.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import Network
import Foundation
import RxDataSources

public enum StyleSection {
    case banner(item: [Item])
    case tag(types: [CategoryInfo])
    case title(type: String)
    case category(types: [CategoryInfo])
    case card(item: [ClosetInfo])
}


extension StyleSection: AnimatableSectionModelType {
    public typealias Item = StyleSectionItem
    public var identity: UUID { UUID() }
    
    public var items: [Item] {
        switch self {
        case .banner(let item): item
        case .tag: []
        case .title(let type): [.title(type)]
        case .category(let types): types.map { Item.category($0) }
        case .card(let items): items.map { Item.card($0) }
        }
    }
    
    public init(original: StyleSection, items: [Item]) {
        switch original {
        case .banner:
            self = original
        case .tag:
            self = original
        case .title(let type):
            self = .title(type: type)
        case .category(let types):
            self = .category(types: types)
        case .card(let item):
            self = .card(item: item)
        }
    }
}

public enum StyleSectionItem: Equatable, IdentifiableType {
    public var identity: UUID { UUID() }
    
    case banner
    case tag(CategoryInfo)
    case title(String)
    case category(CategoryInfo)
    case card(ClosetInfo)
    
    public static func == (lhs: StyleSectionItem, rhs: StyleSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
