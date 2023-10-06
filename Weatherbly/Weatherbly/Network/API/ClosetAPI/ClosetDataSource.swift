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
    func getStyleList() -> Observable<EmptyEntity>
    func setStylePickedList(_ closetIDs: [Int]) -> Observable<EmptyEntity>
    func getOnBoardSensoryTemperatureCloset(_ dateTime: String) -> Observable<SensoryTempClosetEntity>
    func getMainSensoryTemperatureCloset(_ dateTime: String, _ closetId: Int) -> Observable<SensoryTempClosetEntity>
    func setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest) -> Observable<EmptyEntity>
    func getRecommendCloset(_ dateTime: String) -> Observable<RecommendClosetEntity>
    func pagerViewClicked(_ closetID: Int) -> Observable<EmptyEntity>
}

final class ClosetDataSource: ClosetDataSourceProtocol {
    private let provider: WVProvider<ClosetTarget>
    
    public init(provider: WVProvider<ClosetTarget> = WVProvider<ClosetTarget>()) {
        self.provider = provider
    }
    
    public func getStyleList() -> Observable<EmptyEntity> {
        provider.rx
            .request(.getStyleList)
            .mapTo(EmptyEntity.self)
    }
    
    public func setStylePickedList(_ closetIDs: [Int]) -> Observable<EmptyEntity> {
        provider.rx
            .request(.styleStylePickedList(closetIDs))
            .mapTo(EmptyEntity.self)
    }
    
    public func getOnBoardSensoryTemperatureCloset(_ dateTime: String) -> Observable<SensoryTempClosetEntity> {
        provider.rx
            .request(.getOnBoardClosetByTemperature(dateTime))
            .mapTo(SensoryTempClosetEntity.self)
    }
    public func getMainSensoryTemperatureCloset(_ dateTime: String, _ closetId: Int) -> Observable<SensoryTempClosetEntity> {
        provider.rx
            .request(.getMainClosetByTemperature(dateTime, closetId))
            .mapTo(SensoryTempClosetEntity.self)
    }
    
    public func setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest) -> Observable<EmptyEntity> {
        provider.rx
            .request(.setSensoryTemperature(sensoryTempRequest))
            .mapTo(EmptyEntity.self)
    }
    
    func getRecommendCloset(_ dateTime: String) -> Observable<RecommendClosetEntity> {
        provider.rx
            .request(.getRecommendStyleList(dateTime))
            .mapTo(RecommendClosetEntity.self)
    }
    
    func pagerViewClicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider.rx
            .request(.pagerViewClicked(closetID))
            .mapTo(EmptyEntity.self)
    }
}
