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
    func getToken(_ agreement: Bool) -> Observable<AuthLoginEntity>
    func nicknameValidation(_ nickname: String) -> Observable<EmptyEntity>
    func setNickname(_ nickname: String) -> Observable<EmptyEntity>
    func setAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity>
    func setGender(_ gender: String) -> Observable<EmptyEntity>
}

public final class AuthDataSource: AuthDataSourceProtocol {
    private let provider: WVProvider<AuthTarget>
    
    public init(provider: WVProvider<AuthTarget> = WVProvider<AuthTarget>()) {
        self.provider = provider
    }
    
    public func getToken(_ agreement: Bool) -> Observable<AuthLoginEntity> {
        provider
            .request(.login(agreement))
            .mapTo(AuthLoginEntity.self)
    }
    
    public func nicknameValidation(_ nickname: String) -> Observable<EmptyEntity> {
        provider
            .request(.nicknameValidation(nickname))
            .mapTo(EmptyEntity.self)
    }
    
    public func setNickname(_ nickname: String) -> Observable<EmptyEntity> {
        provider
            .request(.nickname(nickname))
            .mapTo(EmptyEntity.self)
    }
    
    public func setAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity> {
        provider
            .request(.address(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func setGender(_ gender: String) -> Observable<EmptyEntity> {
        provider
            .request(.gender(gender))
            .mapTo(EmptyEntity.self)
    }
}
