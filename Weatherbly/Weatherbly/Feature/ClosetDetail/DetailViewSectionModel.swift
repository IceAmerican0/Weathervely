//
//  DetailViewSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import RxDataSources

enum DetailViewSectionModel {
    case mainDetail(items: [Item])
    case withItem(items: [Item])
    case warmmer(items: [Item])
    case cooler(items: [Item])
}

enum DetailSectionItem {
    case mainDetail(SelectedClosetInfo)
    case withItem(WithItemsInfo)
    case warmmer(RowInfo)
    case cooler(RowInfo)
}

extension DetailViewSectionModel: SectionModelType {
    public typealias Item = DetailSectionItem
    
    var items: [Item] {
        switch self {
        case .mainDetail(items: let items):
            return items.map { $0 }
        case .withItem(items: let items):
            return items.map { $0 }
        case .warmmer(items: let items):
            return items.map { $0 }
        case .cooler(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: DetailViewSectionModel, items: [DetailSectionItem]) {
        switch original  {
        case .mainDetail:
            self = .mainDetail(items: items)
        case .withItem:
            self = .withItem(items: items)
        case .warmmer:
            self = .warmmer(items: items)
        case .cooler:
            self = .cooler(items: items)
        }
    }
    
}
