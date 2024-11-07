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
    func getUserInfo() -> Observable<UserInfoEntity>
    func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<EmptyEntity>
    func resetUserInfo(_ userID: Int) -> Observable<EmptyEntity>
    func getAddressList() -> Observable<AddressListEntity>
    func addAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity>
    func setMainAddress(_ addressID: Int) -> Observable<EmptyEntity>
    func fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest) -> Observable<EmptyEntity>
    func deleteAddress(_ addressID: Int) -> Observable<EmptyEntity>
    func fetchFCMToken(_ token: String) -> Observable<EmptyEntity>
    func fetchPushAgreement(_ agreement: Bool) -> Observable<EmptyEntity>
    func fetchUserVersion() -> Observable<EmptyEntity>
}

public final class UserDataSource: UserDataSourceProtocol {
    private let provider: WVProvider<UserTarget>
    
    public init(provider: WVProvider<UserTarget> = WVProvider<UserTarget>()) {
        self.provider = provider
    }
    
    public func getUserInfo() -> Observable<UserInfoEntity> {
        provider
            .request(.getUserInfo)
            .mapTo(UserInfoEntity.self)
    }
    
    public func fetchUserInfo(_ userInfo: UserInfoRequest) -> Observable<EmptyEntity> {
        provider
            .request(.fetchUserInfo(userInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func resetUserInfo(_ userID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.resetUserInfo(userID))
            .mapTo(EmptyEntity.self)
    }
    
    public func getAddressList() -> Observable<AddressListEntity> {
        provider
            .request(.getAddressList)
            .mapTo(AddressListEntity.self)
    }
    
    public func addAddress(_ addressInfo: AddressRequest) -> Observable<EmptyEntity> {
        provider
            .request(.addAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func setMainAddress(_ addressID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.setMainAddress(addressID))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest) -> Observable<EmptyEntity> {
        provider
            .request(.fetchAddress(addressID, addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func deleteAddress(_ addressID: Int) -> Observable<EmptyEntity> {
        provider
            .request(.deleteAddress(addressID))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchFCMToken(_ token: String) -> Observable<EmptyEntity> {
        provider
            .request(.fetchFCMToken(token))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchPushAgreement(_ agreement: Bool) -> Observable<EmptyEntity> {
        provider
            .request(.fetchPushAgreement(agreement))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchUserVersion() -> Observable<EmptyEntity> {
        provider
            .request(.fetchUserVersion)
            .mapTo(EmptyEntity.self)
    }
}
