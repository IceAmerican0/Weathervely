//
//  GetClosetDataSource.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import RxSwift
import Moya
import RxMoya

protocol ForcastDataSourceProtocol {
    func getVillageForcast() -> Observable<Result<VillageForecastInfoEntity, WVNetworkError>>
    func getTenDayForeCast() -> Observable<Result<SevenDayForecastInfoEntity, WVNetworkError>>
}

final class ForecastDataSource: ForcastDataSourceProtocol {
    private var provider: MoyaProvider<ForeCastTarget>
  
    init(provider: MoyaProvider<ForeCastTarget> = MoyaProvider<ForeCastTarget>()) {
        self.provider = provider
    }
    
    func getVillageForcast() -> Observable<Result<VillageForecastInfoEntity,WVNetworkError>> {
        provider
            .rx
            .request(.getVillageForcastInfo)
            .mapTo(VillageForecastInfoEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
    
    func getTenDayForeCast() -> Observable<Result<SevenDayForecastInfoEntity, WVNetworkError>> {
        provider
            .rx
            .request(.getTenDayForecastInfo)
            .mapTo(SevenDayForecastInfoEntity.self)
    }
}
