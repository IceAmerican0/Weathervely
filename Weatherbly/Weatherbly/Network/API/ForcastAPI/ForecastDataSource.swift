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
    func getVillageForcast() -> Observable<Result<VillageForecastInfoEntity, WBNetworkError>>
    func getTenDayForeCast() -> Observable<Result<SevenDayForecastInfoEntity, WBNetworkError>>
}

final class ForecastDataSource: ForcastDataSourceProtocol {
    private var provider: MoyaProvider<ForeCastTarget>
  
    init(provider: MoyaProvider<ForeCastTarget> = MoyaProvider<ForeCastTarget>()) {
        self.provider = provider
    }
    
    func getVillageForcast() -> Observable<Result<VillageForecastInfoEntity,WBNetworkError>> {
        provider
            .rx
            .request(.getVillageForcastInfo)
            .mapTo(VillageForecastInfoEntity.self)
        
    }
    
    func getTenDayForeCast() -> Observable<Result<SevenDayForecastInfoEntity, WBNetworkError>> {
        provider
            .rx
            .request(.getTenDayForecastInfo)
            .mapTo(SevenDayForecastInfoEntity.self)
    }
}
