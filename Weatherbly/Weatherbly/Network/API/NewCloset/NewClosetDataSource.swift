//
//  NewClosetDataSource.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya
import RxSwift
import RxMoya

protocol NewClosetDataSourceProtocol {
    func getHomeCloset(page: Int) -> Observable<NewClosetEntity>
    func getStyleCloset(style: Int, item: [Int], page: Int) -> Observable<NewClosetEntity>
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity>
}

final class NewClosetDataSource: NewClosetDataSourceProtocol {
    private let provider: WVProvider<NewClosetTarget>
    
    public init(provider: WVProvider<NewClosetTarget> = WVProvider<NewClosetTarget>()) {
        self.provider = provider
    }
    
    func getHomeCloset(page: Int) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getHomeCloset(page: page))
            .mapTo(NewClosetEntity.self)
    }
    
    func getStyleCloset(style: Int, item: [Int], page: Int) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getStyleCloset(style: style, item: item, page: page))
            .mapTo(NewClosetEntity.self)
    }
    
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider.rx
            .request(.stylePicked(closetID))
            .mapTo(EmptyEntity.self)
    }
}
