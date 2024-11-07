//
//  DetailViewSectionModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import WVNetwork
import Foundation
import RxDataSources

public typealias Item = DetailSectionItem

public enum DetailSectionItem: Equatable, IdentifiableType {
    case mainDetail(SelectedClosetInfo)
    case withItem(WithItemsInfo)
    case firstRow(RowInfo)
    case secondRow(RowInfo)
    
    public var identity: String {
        switch self {
        case .mainDetail(let item):
            return "mainDetail-\(item.identity)"
        case .withItem(let item):
            return "withItem-\(item.identity)"
        case .firstRow(let item):
            return "firstRow-\(item.identity)"
        case .secondRow(let item):
            return "secondRow-\(item.identity)"
        }
    }
}

public enum DetailViewSectionModel: AnimatableSectionModelType {
    case mainDetail(items: [Item])
    case withItem(items: [Item])
    case warmFirst(items: [Item])
    case warmSecond(items: [Item])
    case coolFirst(items: [Item])
    case coolSecond(items: [Item])
    
    public var identity: String {
        switch self {
        case .mainDetail: return "mainDetail"
        case .withItem: return "withItem"
        case .warmFirst: return "warmFirst"
        case .warmSecond: return "warmSecond"
        case .coolFirst: return "coolFirst"
        case .coolSecond: return "coolSecond"
        }
    }
    
    public var items: [Item] {
        switch self {
        case .mainDetail(let items): return items
        case .withItem(let items): return items
        case .warmFirst(let items): return items
        case .warmSecond(let items): return items
        case .coolFirst(let items): return items
        case .coolSecond(let items): return items
        }
    }
}

extension DetailViewSectionModel: SectionModelType, Equatable {    
    public init(original: DetailViewSectionModel, items: [Item]) {
        switch original {
        case .mainDetail:
            self = .mainDetail(items: items.filter { if case .mainDetail = $0 { return true } else { return false } })
        case .withItem:
            self = .withItem(items: items.filter { if case .withItem = $0 { return true } else { return false } })
        case .warmFirst:
            self = .warmFirst(items: items.filter { if case .firstRow = $0 { return true } else { return false } })
        case .warmSecond:
            self = .warmSecond(items: items.filter { if case .secondRow = $0 { return true } else { return false } })
        case .coolFirst:
            self = .coolFirst(items: items.filter { if case .firstRow = $0 { return true } else { return false } })
        case .coolSecond:
            self = .coolSecond(items: items.filter { if case .secondRow = $0 { return true } else { return false } })
        }
    }
}
