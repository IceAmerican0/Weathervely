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
    func getTypeList() -> Observable<Result<EmptyEntity, Error>>
}

public final class TypeDataSource: TypeDataSourceProtocol {
    private let provider: MoyaProvider<TypeTarget>
    
    public init(provider: MoyaProvider<TypeTarget> = MoyaProvider<TypeTarget>()) {
        self.provider = provider
    }
    
    public func getTypeList() -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.getTypeList)
            .mapTo(EmptyEntity.self)
    }
}
