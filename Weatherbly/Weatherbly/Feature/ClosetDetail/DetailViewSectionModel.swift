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
    case warmFirst(items: [Item])
    case warmSecond(items: [Item])
    case coolFirst(items: [Item])
    case coolSecond(items: [Item])
}

enum DetailSectionItem {
    case mainDetail(SelectedClosetInfo)
    case withItem(WithItemsInfo)
    case firstRow(RowInfo)
    case secondRow(RowInfo)
//    case firstRow(RowInfo, rowType: RowType)
//    case secondRow(RowInfo)
}

extension DetailViewSectionModel: SectionModelType {
    public typealias Item = DetailSectionItem
    
    var items: [Item] {
        switch self {
        case .mainDetail(items: let items):
            return items.map { $0 }
        case .withItem(items: let items):
            return items.map { $0 }
        case .warmFirst(items: let items):
            return items.map { $0 }
        case .warmSecond(items: let items):
            return items.map { $0 }
        case .coolFirst(items: let items):
            return items.map { $0 }
        case .coolSecond(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: DetailViewSectionModel, items: [DetailSectionItem]) {
        switch original  {
        case .mainDetail:
            self = .mainDetail(items: items)
        case .withItem:
            self = .withItem(items: items)
        case .warmFirst:
            self = .warmFirst(items: items)
        case .warmSecond:
            self = .warmSecond(items: items)
        case .coolFirst:
            self = .coolFirst(items: items)
        case .coolSecond:
            self = .coolSecond(items: items)
        }
    }
    
}
