//
//  ClosetDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

protocol ClosetDataSourceProtocol { // TODO: Entity 변경
    func getStyleList() -> Observable<Result<EmptyEntity, WBNetworkError>>
    func setStylePickedList(_ closetIDs: [Int]) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getOnBoardSensoryTemperatureCloset(_ dateTime: String) -> Observable<Result<SensoryTempClosetEntity, WBNetworkError>>
    func getMainSensoryTemperatureCloset(_ dateTime: String, _ closetId: Int) -> Observable<Result<SensoryTempClosetEntity, WBNetworkError>>
    func setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getRecommendCloset(_ dateTime: String) -> Observable<Result<RecommendClosetEntity, WBNetworkError>>
    func pagerViewClicked(_ closetID: Int) -> Observable<Result<EmptyEntity, WBNetworkError>>
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
    
    public func getOnBoardSensoryTemperatureCloset(_ dateTime: String) -> Observable<Result<SensoryTempClosetEntity, WBNetworkError>> {
        provider.rx
            .request(.getOnBoardClosetByTemperature(dateTime))
            .mapTo(SensoryTempClosetEntity.self)
    }
    public func getMainSensoryTemperatureCloset(_ dateTime: String, _ closetId: Int) -> Observable<Result<SensoryTempClosetEntity, WBNetworkError>> {
        provider.rx
            .request(.getMainClosetByTemperature(dateTime, closetId))
            .mapTo(SensoryTempClosetEntity.self)
    }
    
    public func setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.setSensoryTemperature(sensoryTempRequest))
            .mapTo(EmptyEntity.self)
    }
    
    func getRecommendCloset(_ dateTime: String) -> Observable<Result<RecommendClosetEntity, WBNetworkError>> {
        provider.rx
            .request(.getRecommendStyleList(dateTime))
            .mapTo(RecommendClosetEntity.self)
    }
    
    func pagerViewClicked(_ closetID: Int) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.pagerViewClicked(closetID))
            .mapTo(EmptyEntity.self)
    }
}
