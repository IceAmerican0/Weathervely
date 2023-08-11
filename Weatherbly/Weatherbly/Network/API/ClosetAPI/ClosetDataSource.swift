//
//  ClosetDataSource.swift
//  Weatherbly
//
//  Created by 60156056 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

protocol ClosetDataSourceProtocol { // TODO: Entity 변경
    func getStyleList() -> Observable<Result<EmptyEntity, WBNetworkError>>
    func setStylePickedList(_ closetIDs: [Int]) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getSensoryTemperatureCloset(_ dateTime: String) -> Observable<Result<SensoryTempClosetEntity, WBNetworkError>>
    func setSensoryTemperature(_ closetInfo: String) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getRecommendCloset(_ dateTime: String) -> Observable<Result<RecommendClosetEntity, WBNetworkError>>
}

final class ClosetDataSource: ClosetDataSourceProtocol {
    private let provider: MoyaProvider<ClosetTarget>
    
    public init(provider: MoyaProvider<ClosetTarget> = MoyaProvider<ClosetTarget>()) {
        self.provider = provider
    }
    
    public func getStyleList() -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.getStyleList)
            .mapTo(EmptyEntity.self)
    }
    
    public func setStylePickedList(_ closetIDs: [Int]) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.styleStylePickedList(closetIDs))
            .mapTo(EmptyEntity.self)
    }
    
    public func getSensoryTemperatureCloset(_ dateTime: String) -> Observable<Result<SensoryTempClosetEntity, WBNetworkError>> {
        provider.rx
            .request(.getSensoryTemperatureCloset(dateTime))
            .mapTo(SensoryTempClosetEntity.self)
    }
    
    public func setSensoryTemperature(_ closetInfo: String) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.setSensoryTemperature(closetInfo))
            .mapTo(EmptyEntity.self)
    }
    
    func getRecommendCloset(_ dateTime: String) -> Observable<Result<RecommendClosetEntity, WBNetworkError>> {
        provider.rx
            .request(.getRecommendStyleList(dateTime))
            .mapTo(RecommendClosetEntity.self)
    }
}
