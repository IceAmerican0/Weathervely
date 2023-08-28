//
//  ClosetDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

protocol ClosetDataSourceProtocol {
    func getStyleList() -> Observable<Result<EmptyEntity, WVNetworkError>>
    func setStylePickedList(_ closetIDs: [Int]) -> Observable<Result<EmptyEntity, WVNetworkError>>
    func getOnBoardSensoryTemperatureCloset(_ dateTime: String) -> Observable<Result<SensoryTempClosetEntity, WVNetworkError>>
    func getMainSensoryTemperatureCloset(_ dateTime: String, _ closetId: Int) -> Observable<Result<SensoryTempClosetEntity, WVNetworkError>>
    func setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest) -> Observable<Result<EmptyEntity, WVNetworkError>>
    func getRecommendCloset(_ dateTime: String) -> Observable<Result<RecommendClosetEntity, WVNetworkError>>
    func pagerViewClicked(_ closetID: Int) -> Observable<Result<EmptyEntity, WVNetworkError>>
}

final class ClosetDataSource: ClosetDataSourceProtocol {
    private let provider: MoyaProvider<ClosetTarget>
    
    public init(provider: MoyaProvider<ClosetTarget> = MoyaProvider<ClosetTarget>()) {
        self.provider = provider
    }
    
    public func getStyleList() -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.getStyleList)
            .mapTo(EmptyEntity.self)
    }
    
    public func setStylePickedList(_ closetIDs: [Int]) -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.styleStylePickedList(closetIDs))
            .mapTo(EmptyEntity.self)
    }
    
    public func getOnBoardSensoryTemperatureCloset(_ dateTime: String) -> Observable<Result<SensoryTempClosetEntity, WVNetworkError>> {
        provider.rx
            .request(.getOnBoardClosetByTemperature(dateTime))
            .mapTo(SensoryTempClosetEntity.self)
    }
    public func getMainSensoryTemperatureCloset(_ dateTime: String, _ closetId: Int) -> Observable<Result<SensoryTempClosetEntity, WVNetworkError>> {
        provider.rx
            .request(.getMainClosetByTemperature(dateTime, closetId))
            .mapTo(SensoryTempClosetEntity.self)
    }
    
    public func setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest) -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.setSensoryTemperature(sensoryTempRequest))
            .mapTo(EmptyEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
    
    func getRecommendCloset(_ dateTime: String) -> Observable<Result<RecommendClosetEntity, WVNetworkError>> {
        provider.rx
            .request(.getRecommendStyleList(dateTime))
            .mapTo(RecommendClosetEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
    
    func pagerViewClicked(_ closetID: Int) -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.pagerViewClicked(closetID))
            .mapTo(EmptyEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
}
