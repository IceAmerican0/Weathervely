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
    func getHomeCloset(page: Int, time: String) -> Observable<NewClosetEntity>
    func getStyleCloset(style: Int, item: [Int], page: Int) -> Observable<NewClosetEntity>
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity>
    func getFilterCount(list: [String], time: String) -> Observable<NewClosetEntity>
}

final class NewClosetDataSource: NewClosetDataSourceProtocol {
    private let provider: WVProvider<NewClosetTarget>
    
    public init(provider: WVProvider<NewClosetTarget> = WVProvider<NewClosetTarget>()) {
        self.provider = provider
    }
    
    func getHomeCloset(page: Int, time: String) -> Observable<NewClosetEntity> {
        provider
            .request(.getHomeCloset(page: page, time: time))
            .mapTo(NewClosetEntity.self)
    }
    
    func getStyleCloset(style: Int, item: [Int], page: Int) -> Observable<NewClosetEntity> {
        provider
            .request(.getStyleCloset(style: style, item: item, page: page))
            .mapTo(NewClosetEntity.self)
    }
    
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.stylePicked(closetID))
            .mapTo(EmptyEntity.self)
    }
    
    func getFilterCount(list: [String], time: String) -> Observable<NewClosetEntity> {
        provider
            .request(.getFilterCount(list: list, time: time))
            .mapTo(NewClosetEntity.self)
    }
}
