//
//  FilteredStyleDataSource.swift
//  Weatherbly
//
//  Created by Khai on 6/3/24.
//

import RxMoya
import RxSwift

protocol FilteredStyleDataSourceProtocol {
    func getFilteredStyledCount(id: [Int]) -> Observable<HomeFilterCountEntity>
}

final class FilteredStyleDataSource: FilteredStyleDataSourceProtocol {
    private let provider: WVProvider<FilteredStyleTarget>
    
    public init(provider: WVProvider<FilteredStyleTarget> = WVProvider<FilteredStyleTarget>()) {
        self.provider = provider
    }
    
    func getFilteredStyledCount(id: [Int] = []) -> Observable<HomeFilterCountEntity> {
        provider.rx
            .request(.getFilteredStyledCount(id: id))
            .mapTo(HomeFilterCountEntity.self)
    }
}

