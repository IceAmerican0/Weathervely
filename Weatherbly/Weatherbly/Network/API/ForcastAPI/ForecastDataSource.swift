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
    func getVillageForcast() -> Observable<VillageForecastInfoEntity>
    func getTenDayForeCast() -> Observable<SevenDayForecastInfoEntity>
}

final class ForecastDataSource: ForcastDataSourceProtocol {
    private var provider: WVProvider<ForeCastTarget>
  
    init(provider: WVProvider<ForeCastTarget> = WVProvider<ForeCastTarget>()) {
        self.provider = provider
    }
    
    func getVillageForcast() -> Observable<VillageForecastInfoEntity> {
        provider.rx
            .request(.getVillageForcastInfo)
            .mapTo(VillageForecastInfoEntity.self)
    }
    
    func getTenDayForeCast() -> Observable<SevenDayForecastInfoEntity> {
        provider.rx
            .request(.getTenDayForecastInfo)
            .mapTo(SevenDayForecastInfoEntity.self)
    }
}
