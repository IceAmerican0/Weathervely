//
//  WeatherDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/26.
//

import Moya
import RxSwift

public protocol WeatherDataSourceProtocol {
    func dailyForecast(_ request: String) -> Observable<Result<DailyForecastEntity, Error>>
}

public final class WeatherDataSource: WeatherDataSourceProtocol {
    
    private let provider: MoyaProvider<WeatherTarget>
    
    public init(provider: MoyaProvider<WeatherTarget> = MoyaProvider<WeatherTarget>()) {
        self.provider = provider
    }
    
    public func dailyForecast(_ request: String) -> Observable<Result<DailyForecastEntity, Error>> {
        provider.rx
            .request(.daily(request))
            .mapTo(DailyForecastEntity.self)
    }
}
