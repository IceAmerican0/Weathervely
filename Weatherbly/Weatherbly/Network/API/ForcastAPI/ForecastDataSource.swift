//
//  ForecastDataSource.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import RxSwift
import Moya
import RxMoya

public protocol ForecastDataSourceProtocol {
    func getVillageForcast() -> Observable<HomeForecastEntity>
    func getTenDayForeCast() -> Observable<TenDayForecastEntity>
}

public final class ForecastDataSource: ForecastDataSourceProtocol {
    private var provider: WVProvider<ForeCastTarget>
  
    init(provider: WVProvider<ForeCastTarget> = WVProvider<ForeCastTarget>()) {
        self.provider = provider
    }
    
    public func getVillageForcast() -> Observable<HomeForecastEntity> {
        provider.rx
            .request(.getVillageForcastInfo)
            .mapTo(HomeForecastEntity.self)
    }
    
    public func getTenDayForeCast() -> Observable<TenDayForecastEntity> {
        provider.rx
            .request(.getTenDayForecastInfo)
            .mapTo(TenDayForecastEntity.self)
    }
}
