//
//  RegionRepository.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/17.
//

import RxSwift

public protocol RegionRepositoryProtocol {
    func searchRegion(query: String) -> Observable<RegionEntity>
}

public struct RegionRepository: RegionRepositoryProtocol {
    private let dataSource: RegionDataSourceProtocol
    
    public init(dataSource: RegionDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    public func searchRegion(query: String) -> Observable<RegionEntity> {
        dataSource
            .searchRegion(.init(query: query))
            .map { $0.generate() }
    }
}
