//
//  RegionDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift

public protocol RegionDataSourceProtocol {
    func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, WBNetworkError>>
}

public final class RegionDataSource: RegionDataSourceProtocol {
    
    private let provider: MoyaProvider<RegionTarget>
    
    public init(provider: MoyaProvider<RegionTarget> = MoyaProvider<RegionTarget>()) {
        self.provider = provider
    }
    
    public func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, WBNetworkError>> {
        provider
            .rx
            .request(.searchRegion(request))
            .mapTo(SearchRegionEntity.self)
    }
}
