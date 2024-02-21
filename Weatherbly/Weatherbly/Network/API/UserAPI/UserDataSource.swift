//
//  UserDataSource.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import RxSwift
import RxMoya

public protocol UserDataSourceProtocol {
    func getUserInfo(_ nickname: String) -> Observable<UserInfoEntity>
    func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<EmptyEntity>
    func getAddressList() -> Observable<AddressListEntity>
    func addAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity>
    func setMainAddress(_ addressID: Int) -> Observable<EmptyEntity>
    func fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest) -> Observable<EmptyEntity>
    func deleteAddress(_ addressID: Int) -> Observable<EmptyEntity>
}

public final class UserDataSource: UserDataSourceProtocol {
    
    private let provider: WVProvider<UserTarget>
    
    public init(provider: WVProvider<UserTarget> = WVProvider<UserTarget>()) {
        self.provider = provider
    }
    
    public func getUserInfo(_ nickname: String) -> Observable<UserInfoEntity> {
        provider.rx
            .request(.getUserInfo(nickname))
            .mapTo(UserInfoEntity.self)
    }
    
    public func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<EmptyEntity> {
        provider.rx
            .request(.fetchUserInfo(userInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func getAddressList() -> Observable<AddressListEntity> {
        provider.rx
            .request(.getAddressList)
            .mapTo(AddressListEntity.self)
    }
    
    public func addAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity> {
        provider.rx
            .request(.addAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func setMainAddress(_ addressID: Int) -> Observable<EmptyEntity> {
        provider.rx
            .request(.setMainAddress(addressID))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest) -> Observable<EmptyEntity> {
        provider.rx
            .request(.fetchAddress(addressID, addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func deleteAddress(_ addressID: Int) -> Observable<EmptyEntity> {
        provider.rx
            .request(.deleteAddress(addressID))
            .mapTo(EmptyEntity.self)
    }
}
