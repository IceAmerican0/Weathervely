//
//  RegionDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift

public protocol RegionDataSourceProtocol {
    func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, WVNetworkError>>
}

public final class RegionDataSource: RegionDataSourceProtocol {
    
    private let provider: MoyaProvider<RegionTarget>
    
    public init(provider: MoyaProvider<RegionTarget> = MoyaProvider<RegionTarget>()) {
        self.provider = provider
    }
    
    public func searchRegion(_ request: String) -> Observable<Result<SearchRegionEntity, WVNetworkError>> {
        provider
            .rx
            .request(.searchRegion(request))
            .mapTo(SearchRegionEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
}
