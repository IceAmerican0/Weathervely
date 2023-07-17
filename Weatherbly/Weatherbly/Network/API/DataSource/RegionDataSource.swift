//
//  RegionDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift

public protocol RegionDataSourceProtocol {
    func searchRegion(_ request: SearchRegionRequest) -> Observable<SearchRegionResponse>
}

public final class RegionDataSource: RegionDataSourceProtocol {
    
    private let provider: RegionProvider<RegionAPI>
    
    public init(provider: RegionProvider<RegionAPI> = RegionProvider<RegionAPI>()) {
        self.provider = provider
    }
    
    public func searchRegion(_ request: SearchRegionRequest) -> Observable<SearchRegionResponse> {
        provider
            .request(.searchRegion(request))
            .mapTo(SearchRegionResponse.self)
    }
}
