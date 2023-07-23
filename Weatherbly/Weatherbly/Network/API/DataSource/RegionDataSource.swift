//
//  RegionDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift

public protocol RegionDataSourceProtocol {
    func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, Error>>
}

public final class RegionDataSource: RegionDataSourceProtocol {
    
    private let provider: RegionProvider<RegionTarget>
    
    public init(provider: RegionProvider<RegionTarget> = RegionProvider<RegionTarget>()) {
        self.provider = provider
    }
    
    public func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, Error>> {
        provider
            .request(.searchRegion(request))
            .mapTo(SearchRegionEntity.self)
    }
}
