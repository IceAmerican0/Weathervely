//
//  HomeSection.swift
//  Weatherbly
//
//  Created by Khai on 1/7/24.
//

import RxDataSources

public enum HomeSection {
    case forecast(items: [Item])
    case closet(items: [Item])
}

public enum HomeSectionItem {
    case forecast(HomeForecastInfo)
    case closet(NewClosetInfo)
}

extension HomeSection: SectionModelType {
    public typealias Item = HomeSectionItem
    
    public var items: [Item] {
        switch self {
        case .forecast(items: let items): items.map { $0 }
        case .closet(items: let items): items.map { $0 }
        }
    }
    
    public init(original: HomeSection, items: [Item]) {
        switch original {
        case .forecast: self = .forecast(items: items)
        case .closet: self = .closet(items: items)
        }
    }
}
