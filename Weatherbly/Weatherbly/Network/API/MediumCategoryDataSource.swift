//
//  MediumCategoryDataSource.swift
//  Weatherbly
//
//  Created by Khai on 5/29/24.
//

import RxMoya
import RxSwift

protocol MediumCategoryDataSourceProtocol {
    func getMediumCategoryList(id: [Int]) -> Observable<MediumCategoryEntity>
}

final class MediumCategoryDataSource: MediumCategoryDataSourceProtocol {
    private let provider: WVProvider<MediumCategoryTarget>
    
    public init(provider: WVProvider<MediumCategoryTarget> = WVProvider<MediumCategoryTarget>()) {
        self.provider = provider
    }
    
    func getMediumCategoryList(id: [Int] = []) -> Observable<MediumCategoryEntity> {
        provider.rx
            .request(.getMediumCategoryList(id: id))
            .mapTo(MediumCategoryEntity.self)
    }
}
