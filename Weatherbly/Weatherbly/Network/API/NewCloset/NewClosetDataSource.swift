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
    func getClosetWithType(typeID: Int, page: Int) -> Observable<NewClosetEntity>
    func getTypes() -> Observable<ClosetTypeEntity>
    func getCategories(typeID: Int) -> Observable<CategoryEntity>
    func closetWithCategory(typeID: Int, page: Int, items: [Int]?) -> Observable<EmptyEntity>
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
    
    func getClosetWithType(typeID: Int, page: Int ) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getClosetWithType(typeID: typeID, page: page))
            .mapTo(NewClosetEntity.self)
    }
    
    func getTypes() -> Observable<ClosetTypeEntity> {
        provider.rx
            .request(.getTypes)
            .mapTo(ClosetTypeEntity.self)
    }
    
    func getCategories(typeID: Int) -> Observable<CategoryEntity> {
        provider.rx
            .request(.getCategories(typeID: typeID))
            .mapTo(CategoryEntity.self)
    }
    
    func closetWithCategory(typeID: Int, page: Int, items: [Int]?) -> Observable<EmptyEntity> {
        provider.rx
            .request(.closetWithCategory(typeID: typeID, page: page, items: items ?? []))
            .mapTo(EmptyEntity.self)
    }
    
    func stylePicked(_ closetID: Int) -> Observable<EmptyEntity> {
        provider.rx
            .request(.stylePicked(closetID))
            .mapTo(EmptyEntity.self)
    }
    
}
