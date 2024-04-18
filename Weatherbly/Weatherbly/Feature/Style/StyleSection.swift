//
//  StyleSection.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/18/24.
//

import RxDataSources

public enum StyleSection {
    case normal(items: [Item])
}

public enum StyleSectionItem {
    case normal(StyleClosetInfo)
}

extension StyleSection: SectionModelType {

    public typealias Item = StyleSectionItem
    
    public var items: [Item] {
        switch self {
        case .normal(items: let items): items.map { $0 }
        }
    }
    
    public init(original: StyleSection, items: [StyleSectionItem]) {
        switch original {
        case .normal: self = .normal(items: items)
        }
    }
    
    
}
