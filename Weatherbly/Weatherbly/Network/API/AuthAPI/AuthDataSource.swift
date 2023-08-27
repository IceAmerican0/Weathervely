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
    func getToken(_ nickname: String) -> Observable<Result<AuthLoginEntity, WVNetworkError>>
    func setNickname(_ nickname: String) -> Observable<Result<EmptyEntity, WVNetworkError>>
    func setAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WVNetworkError>>
    func setGender(_ gender: String) -> Observable<Result<EmptyEntity, WVNetworkError>>
}

public final class AuthDataSource: AuthDataSourceProtocol {
    private let provider: MoyaProvider<AuthTarget>
    
    public init(provider: MoyaProvider<AuthTarget> = MoyaProvider<AuthTarget>()) {
        self.provider = provider
    }
    
    public func getToken(_ nickname: String) -> Observable<Result<AuthLoginEntity, WVNetworkError>> {
        provider.rx
            .request(.login(nickname))
            .mapTo(AuthLoginEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
    
    public func setNickname(_ nickname: String) -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.nickname(nickname))
            .mapTo(EmptyEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
    
    public func setAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.address(addressInfo))
            .mapTo(EmptyEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
    
    public func setGender(_ gender: String) -> Observable<Result<EmptyEntity, WVNetworkError>> {
        provider.rx
            .request(.gender(gender))
            .mapTo(EmptyEntity.self)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catch { error in
                return .just(.failure(.noInternetError))
            }
    }
}
