//
//  TypeDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import RxSwift
import RxMoya

public protocol TypeDataSourceProtocol {
    func getTypeList() -> Observable<StyleTypeEntity>
}

public final class TypeDataSource: TypeDataSourceProtocol {
    private let provider: WVProvider<TypeTarget>
    
    public init(provider: WVProvider<TypeTarget> = WVProvider<TypeTarget>()) {
        self.provider = provider
    }
    
    public func getTypeList() -> Observable<StyleTypeEntity> {
        provider
            .request(.getTypeList)
            .mapTo(StyleTypeEntity.self)
    }
}
