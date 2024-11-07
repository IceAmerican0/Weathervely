//
//  ClosetDataSource.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya
import RxSwift
import RxMoya

public protocol ClosetDataSourceProtocol {
    func getHomeCloset(page: Int, time: String) -> Observable<ClosetEntity>
    func getStyleCloset(typeID: Int, page: Int, categories: [String]) -> Observable<ClosetEntity>
    func getTypes() -> Observable<ClosetTypeEntity>
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity>
    func getFilterCount(list: [String], time: String) -> Observable<ClosetEntity>
}

public final class ClosetDataSource: ClosetDataSourceProtocol {
    private let provider: WVProvider<ClosetTarget>
    
    public init(provider: WVProvider<ClosetTarget> = WVProvider<ClosetTarget>()) {
        self.provider = provider
    }
    
    public func getHomeCloset(page: Int, time: String) -> Observable<ClosetEntity> {
        provider
            .request(.getHomeCloset(page: page, time: time))
            .mapTo(ClosetEntity.self)
    }
    
    public func getStyleCloset(typeID: Int, page: Int, categories: [String] = []) -> Observable<ClosetEntity> {
        provider
            .request(.getStyleCloset(typeID: typeID, page: page, items: categories))
            .mapTo(ClosetEntity.self)
    }
    
    public func getTypes() -> Observable<ClosetTypeEntity> {
        provider
            .request(.getTypes)
            .mapTo(ClosetTypeEntity.self)
    }
    
    public func stylePicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.stylePicked(closetID))
            .mapTo(EmptyEntity.self)
    }
    
    public func getFilterCount(list: [String], time: String) -> Observable<ClosetEntity> {
        provider
            .request(.getFilterCount(list: list, time: time))
            .mapTo(ClosetEntity.self)
    }
}
