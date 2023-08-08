//
//  UserDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

public protocol UserDataSourceProtocol { // TODO: return값 수정
    func getUserInfo(_ nickname: String) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getAddressList(_ nickname: String) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func fetchAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func deleteAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
}

public final class UserDataSource: UserDataSourceProtocol {
    
    private let provider: MoyaProvider<UserTarget>
    
    public init(provider: MoyaProvider<UserTarget> = MoyaProvider<UserTarget>()) {
        self.provider = provider
    }
    
    public func getUserInfo(_ nickname: String) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.getUserInfo(nickname))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.fetchUserInfo(userInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func getAddressList(_ nickname: String) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.getAddressList(nickname))
            .mapTo(EmptyEntity.self)
    }
    
    public func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.addAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.fetchAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func deleteAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.deleteAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
}
