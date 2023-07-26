//
//  RegionDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift
import RxMoya

public protocol RegionDataSourceProtocol {
    func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, Error>>
}

public final class RegionDataSource: RegionDataSourceProtocol {
    
    private let provider: MoyaProvider<RegionTarget>
    
    public init(provider: MoyaProvider<RegionTarget> = MoyaProvider<RegionTarget>()) {
        self.provider = provider
    }
    
    public func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, Error>> {
        provider.rx
            .request(.searchRegion(request))
            .mapTo(SearchRegionEntity.self)
    }
}
