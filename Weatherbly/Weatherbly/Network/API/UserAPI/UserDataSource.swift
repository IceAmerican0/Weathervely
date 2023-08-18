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
    func getUserInfo(_ nickname: String) -> Observable<Result<UserInfoEntity, WBNetworkError>>
    func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func getAddressList() -> Observable<Result<AddressListEntity, WBNetworkError>>
    func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func setMainAddress(_ addressID: Int) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func deleteAddress(_ addressID: Int) -> Observable<Result<EmptyEntity, WBNetworkError>>
}

public final class UserDataSource: UserDataSourceProtocol {
    
    private let provider: MoyaProvider<UserTarget>
    
    public init(provider: MoyaProvider<UserTarget> = MoyaProvider<UserTarget>()) {
        self.provider = provider
    }
    
    public func getUserInfo(_ nickname: String) -> Observable<Result<UserInfoEntity, WBNetworkError>> {
        provider.rx
            .request(.getUserInfo(nickname))
            .mapTo(UserInfoEntity.self)
    }
    
    public func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.fetchUserInfo(userInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func getAddressList() -> Observable<Result<AddressListEntity, WBNetworkError>> {
        provider.rx
            .request(.getAddressList)
            .mapTo(AddressListEntity.self)
    }
    
    public func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.addAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func setMainAddress(_ addressID: Int) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.setMainAddress(addressID))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.fetchAddress(addressID, addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func deleteAddress(_ addressID: Int) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.deleteAddress(addressID))
            .mapTo(EmptyEntity.self)
    }
}
