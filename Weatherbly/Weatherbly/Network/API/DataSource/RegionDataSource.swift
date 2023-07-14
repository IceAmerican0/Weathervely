//
//  RegionDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift

public protocol RegionDataSourceProtocol {
    func fetchRegion(_ request: SearchRegionRequest) -> Observable<SearchRegionResponse>
}

public final class RegionDataSource: RegionDataSourceProtocol {
    
    private let provider: MoyaProvider<RegionAPI>
    
    public init(provider: MoyaProvider<RegionAPI> = MoyaProvider<RegionAPI>()) {
        self.provider = provider
    }
    
    public func fetchRegion(_ request: SearchRegionRequest) -> Observable<SearchRegionResponse> {
        provider
            .request(.searchRegion(request))
            .mapTo()
    }
}


//public protocol AccountRemoteDataSourceProtocol {
//    func fetchAccountBalance(
//        _ request: AccountBalanceRequest
//    ) -> Observable<AccountBalanceResponse>
//}
//
//public final class AccountRemoteDataSource: AccountRemoteDataSourceProtocol {
//    private let provider: SOLProvider<AccountAPI>
//
//    public init(
//        provider: SOLProvider<AccountAPI> = SOLProvider<AccountAPI>()
//    ) {
//        self.provider = provider
//    }
//
//    public func fetchAccountBalance(
//        _ request: AccountBalanceRequest
//    ) -> Observable<AccountBalanceResponse> {
//        provider
//            .request(.accountBalance(request))
//            .mapTo(AccountBalanceResponse.self)
//    }
//}
