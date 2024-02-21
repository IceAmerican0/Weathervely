//
//  AuthDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

public protocol AuthDataSourceProtocol {
    func getToken() -> Observable<AuthLoginEntity>
    func setNickname(_ nickname: String, _ uuid: String) -> Observable<EmptyEntity>
    func setAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity>
    func setGender(_ gender: String) -> Observable<EmptyEntity>
}

public final class AuthDataSource: AuthDataSourceProtocol {
    private let provider: WVProvider<AuthTarget>
    
    public init(provider: WVProvider<AuthTarget> = WVProvider<AuthTarget>()) {
        self.provider = provider
    }
    
    public func getToken() -> Observable<AuthLoginEntity> {
        provider.rx
            .request(.login)
            .mapTo(AuthLoginEntity.self)
    }
    
    public func setNickname(_ nickname: String, _ uuid: String) -> Observable<EmptyEntity> {
        provider.rx
            .request(.nickname(nickname, uuid))
            .mapTo(EmptyEntity.self)
    }
    
    public func setAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity> {
        provider.rx
            .request(.address(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func setGender(_ gender: String) -> Observable<EmptyEntity> {
        provider.rx
            .request(.gender(gender))
            .mapTo(EmptyEntity.self)
    }
}
