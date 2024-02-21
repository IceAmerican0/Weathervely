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
    func getMainCloset(page: Int, pageSize: Int) -> Observable<NewClosetEntity>
    func getStyleCloset(page: Int, pageSize: Int) -> Observable<NewClosetEntity>
    func getMainFilteredCloset(page: Int, pageSize: Int, styleID: [String], category: [String]) -> Observable<NewClosetEntity>
    func getStyleFilteredCloset(page: Int, pageSize: Int, styleID: [String], category: [String]) -> Observable<NewClosetEntity>
}

final class NewClosetDataSource: NewClosetDataSourceProtocol {
    private let provider: WVProvider<NewClosetTarget>
    
    public init(provider: WVProvider<NewClosetTarget>) {
        self.provider = provider
    }
    
    func getMainCloset(page: Int, pageSize: Int) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getMainCloset(page: page, pageSize: pageSize))
            .mapTo(NewClosetEntity.self)
    }
    
    func getStyleCloset(page: Int, pageSize: Int) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getMainCloset(page: page, pageSize: pageSize))
            .mapTo(NewClosetEntity.self)
    }
    
    func getMainFilteredCloset(
        page: Int,
        pageSize: Int,
        styleID: [String],
        category: [String]
    ) -> Observable<NewClosetEntity> {
        provider.rx
            .request(
                .getMainFilteredCloset(
                    page: page,
                    pageSize: pageSize,
                    styleID: styleID,
                    category: category
                )
            )
            .mapTo(NewClosetEntity.self)
    }
    
    func getStyleFilteredCloset(
        page: Int,
        pageSize: Int,
        styleID: [String],
        category: [String]
    ) -> Observable<NewClosetEntity> {
        provider.rx
            .request(
                .getStyleFilteredCloset(
                    page: page,
                    pageSize: pageSize,
                    styleID: styleID,
                    category: category
                )
            )
            .mapTo(NewClosetEntity.self)
    }
}
