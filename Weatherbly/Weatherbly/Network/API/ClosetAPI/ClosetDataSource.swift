//
//  ClosetDataSource.swift
//  Weatherbly
//
//  Created by 60156056 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

public protocol ClosetDataSourceProtocol { // TODO: Entity 변경
    func getStyleList() -> Observable<Result<EmptyEntity, WBNetworkError>>
    func setStylePickedList(_ closetIDs: [Int]) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getSensoryTemperatureStyle(_ dateTime: String) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func setSensoryTemperature(_ closetInfo: String) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getRecommendStyleList(_ dateTime: String) -> Observable<Result<EmptyEntity, WBNetworkError>>
}

public final class ClosetDataSource: ClosetDataSourceProtocol {
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
    
    public func getSensoryTemperatureStyle(_ dateTime: String) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.getSensoryTemperatureStyle(dateTime))
            .mapTo(EmptyEntity.self)
    }
    
    public func setSensoryTemperature(_ closetInfo: String) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.setSensoryTemperature(closetInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func getRecommendStyleList(_ dateTime: String) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.getRecommendStyleList(dateTime))
            .mapTo(EmptyEntity.self)
    }
}
