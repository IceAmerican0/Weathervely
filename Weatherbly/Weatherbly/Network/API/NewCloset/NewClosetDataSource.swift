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
    func getClosetWithType(typeID: Int, page: Int) -> Observable<NewClosetEntity>
    func getTypes() -> Observable<ClosetTypeEntity>
    func getCategories(typeID: Int) -> Observable<CategoryEntity>
    func closetWithCategory(typeID: Int, page: Int, items: String?) -> Observable<NewClosetEntity>
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
    
    func getClosetWithType(typeID: Int, page: Int) -> Observable<NewClosetEntity> {
        provider
            .request(.getClosetWithType(typeID: typeID, page: page))
            .mapTo(NewClosetEntity.self)
    }
    
    func getTypes() -> Observable<ClosetTypeEntity> {
        provider
            .request(.getTypes)
            .mapTo(ClosetTypeEntity.self)
    }
    
    func getCategories(typeID: Int) -> Observable<CategoryEntity> {
        provider
            .request(.getCategories(typeID: typeID))
            .mapTo(CategoryEntity.self)
    }
    
    func closetWithCategory(typeID: Int, page: Int, items: String?) -> Observable<NewClosetEntity> {
        provider
            .request(.closetWithCategory(typeID: typeID, page: page, items: items ?? ""))
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
