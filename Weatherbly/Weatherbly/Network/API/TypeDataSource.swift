//
//  TypeDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

public protocol TypeDataSourceProtocol {
    func getTypeList() -> Observable<EmptyEntity>
}

public final class TypeDataSource: TypeDataSourceProtocol {
    private let provider: WVProvider<TypeTarget>
    
    public init(provider: WVProvider<TypeTarget> = WVProvider<TypeTarget>()) {
        self.provider = provider
    }
    
    public func getTypeList() -> Observable<EmptyEntity> {
        provider.rx
            .request(.getTypeList)
            .mapTo(EmptyEntity.self)
    }
}
