//
//  ClosetDataSource.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya
import RxSwift
import RxMoya

protocol ClosetDataSourceProtocol {
    func getHomeCloset(page: Int, time: String) -> Observable<ClosetEntity>
    func getClosetWithType(typeID: Int, page: Int) -> Observable<ClosetEntity>
    func getTypes() -> Observable<ClosetTypeEntity>
    func closetWithCategory(typeID: Int, page: Int, items: String?) -> Observable<ClosetEntity>
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity>
    func getFilterCount(list: [String], time: String) -> Observable<ClosetEntity>
}

final class ClosetDataSource: ClosetDataSourceProtocol {
    private let provider: WVProvider<ClosetTarget>
    
    public init(provider: WVProvider<ClosetTarget> = WVProvider<ClosetTarget>()) {
        self.provider = provider
    }
    
    func getHomeCloset(page: Int, time: String) -> Observable<ClosetEntity> {
        provider
            .request(.getHomeCloset(page: page, time: time))
            .mapTo(ClosetEntity.self)
    }
    
    func getClosetWithType(typeID: Int, page: Int) -> Observable<ClosetEntity> {
        provider
            .request(.getClosetWithType(typeID: typeID, page: page))
            .mapTo(ClosetEntity.self)
    }
    
    func getTypes() -> Observable<ClosetTypeEntity> {
        provider
            .request(.getTypes)
            .mapTo(ClosetTypeEntity.self)
    }
    
    func closetWithCategory(typeID: Int, page: Int, items: String?) -> Observable<ClosetEntity> {
        provider
            .request(.closetWithCategory(typeID: typeID, page: page, items: items ?? ""))
            .mapTo(ClosetEntity.self)
    }
    
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.stylePicked(closetID))
            .mapTo(EmptyEntity.self)
    }
    
    func getFilterCount(list: [String], time: String) -> Observable<ClosetEntity> {
        provider
            .request(.getFilterCount(list: list, time: time))
            .mapTo(ClosetEntity.self)
    }
}
