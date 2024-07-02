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
    func getRecommendCloset(_ dateTime: String) -> Observable<RecommendClosetEntity>
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity>
}

final class ClosetDataSource: ClosetDataSourceProtocol {
    private let provider: WVProvider<ClosetTarget>
    
    public init(provider: WVProvider<ClosetTarget> = WVProvider<ClosetTarget>()) {
        self.provider = provider
    }
    
    public func getStyleList() -> Observable<EmptyEntity> {
        provider
            .request(.getStyleList)
            .mapTo(EmptyEntity.self)
    }
    
    func getRecommendCloset(_ dateTime: String) -> Observable<RecommendClosetEntity> {
        provider
            .request(.getRecommendStyleList(dateTime))
            .mapTo(RecommendClosetEntity.self)
    }
    
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.stylePicked(closetID))
            .mapTo(EmptyEntity.self)
    }
}
