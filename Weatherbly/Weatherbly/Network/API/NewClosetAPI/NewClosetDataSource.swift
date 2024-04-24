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
    func getHomeCloset(style: String, page: Int) -> Observable<NewClosetEntity>
    func getStyleCloset(style: String, page: Int) -> Observable<NewClosetEntity>
    func getMainFilteredCloset(page: Int, pageSize: Int, styleID: [String], category: [String]) -> Observable<NewClosetEntity>
    func getStyleFilteredCloset(page: Int, pageSize: Int, styleID: [String], category: [String]) -> Observable<NewClosetEntity>
}

final class NewClosetDataSource: NewClosetDataSourceProtocol {
    private let provider: WVProvider<NewClosetTarget>
    
    public init(provider: WVProvider<NewClosetTarget>) {
        self.provider = provider
    }
    
    func getHomeCloset(style: String, page: Int) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getMainCloset(style: style, page: page))
            .mapTo(NewClosetEntity.self)
    }
    
    func getStyleCloset(style: String, page: Int) -> Observable<NewClosetEntity> {
        provider.rx
            .request(.getStyleCloset(style: style, page: page))
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
