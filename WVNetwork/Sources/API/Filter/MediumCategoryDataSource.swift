//
//  MediumCategoryDataSource.swift
//  Weatherbly
//
//  Created by Khai on 5/29/24.
//

import RxMoya
import RxSwift

public protocol MediumCategoryDataSourceProtocol {
    func getMainMediumCategoryList() -> Observable<MainMediumCategoryEntity>
    func getStyleMediumCategoryList(id: Int) -> Observable<StyleMediumCategoryEntity>
}

public final class MediumCategoryDataSource: MediumCategoryDataSourceProtocol {
    private let provider: WVProvider<MediumCategoryTarget>
    
    public init(provider: WVProvider<MediumCategoryTarget> = WVProvider<MediumCategoryTarget>()) {
        self.provider = provider
    }
    
    public func getMainMediumCategoryList() -> Observable<MainMediumCategoryEntity> {
        provider
            .request(.getMainMediumCategoryList)
            .mapTo(MainMediumCategoryEntity.self)
    }
    
    public func getStyleMediumCategoryList(id: Int) -> Observable<StyleMediumCategoryEntity> {
        provider
            .request(.getStyleMediumCategoryList(id: id))
            .mapTo(StyleMediumCategoryEntity.self)
    }
}
