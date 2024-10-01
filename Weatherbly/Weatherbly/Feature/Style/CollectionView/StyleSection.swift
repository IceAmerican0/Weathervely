//
//  StyleSection.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import Foundation
import RxDataSources

public enum StyleSection {
    case banner
    case tag(types: [CategoryInfo])
    case title(type: String)
    case category(types: [CategoryInfo])
    case card(item: [ClosetInfo])
}


extension StyleSection: AnimatableSectionModelType {
    public var identity: UUID { UUID() }
    
    public var items: [StyleSectionItem] {
        return []
    }
    
    public init(original: StyleSection, items: [StyleSectionItem]) {
        switch original {
        case .banner:
            self = .banner
        case .tag(let types):
            self = .tag(types: types)
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
    case tag([CategoryInfo])
    case title(String)
    case category([CategoryInfo])
    case card([ClosetInfo])
    
    public static func == (lhs: StyleSectionItem, rhs: StyleSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}


