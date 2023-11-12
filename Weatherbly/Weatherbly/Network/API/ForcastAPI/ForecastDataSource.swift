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
    func getVillageForcast() -> Observable<VillageForecastInfoEntity>
    func getTenDayForeCast() -> Observable<SevenDayForecastInfoEntity>
}

public final class ForecastDataSource: ForecastDataSourceProtocol {
    private var provider: WVProvider<ForeCastTarget>
  
    init(provider: WVProvider<ForeCastTarget> = WVProvider<ForeCastTarget>()) {
        self.provider = provider
    }
    
    public func getVillageForcast() -> Observable<VillageForecastInfoEntity> {
        provider.rx
            .request(.getVillageForcastInfo)
            .mapTo(VillageForecastInfoEntity.self)
    }
    
    public func getTenDayForeCast() -> Observable<SevenDayForecastInfoEntity> {
        provider.rx
            .request(.getTenDayForecastInfo)
            .mapTo(SevenDayForecastInfoEntity.self)
    }
}
