//
//  StyleTabSectionModelTest.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/5/24.
//

import Foundation
import RxDataSources

enum StyleTabSectionModelTest {
    case banner(item: [Item], footer: [ClosetTypeInfo])
    case styles(header: [ClosetTypeInfo], items: [Item])
}

enum StyleTabItemTest {
    case banner(StyleBanner)
    case styles(StylesSectionCustomData)
}

struct StyleBannerSectionCustomData {
    var items: [StyleBanner]
    var footer: [ClosetTypeInfo]
}

struct StylesSectionCustomData {
    var header: [ClosetTypeInfo]
    var items: [StyleClosetInfo]
}

extension StyleTabSectionModelTest: SectionModelType {
    
    public typealias Item = StyleTabItemTest
    
    var items: [Item] {
        switch self {
        case .banner(item: let item, _):
            return item
        case .styles(_, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: StyleTabSectionModelTest, items: [StyleTabItemTest]) {
        switch original {
        case .banner(_, let footer):
            self = .banner(item: items, footer: footer)
        case .styles(let header, _):
            self = .styles(header: header, items: items)
        }
    }
}
