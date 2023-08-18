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
    func getAddressList(_ nickname: String) -> Observable<Result<AddressEntity, WBNetworkError>>
    func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func fetchAddress(_ targetID: Int, _ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
    func deleteAddress(_ targetID: Int, _ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>>
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
    
    public func getAddressList(_ nickname: String) -> Observable<Result<AddressEntity, WBNetworkError>> {
        provider.rx
            .request(.getAddressList(nickname))
            .mapTo(AddressEntity.self)
    }
    
    public func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.addAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchAddress(_ targetID: Int, _ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.fetchAddress(targetID, addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func deleteAddress(_ targetID: Int, _ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, WBNetworkError>> {
        provider.rx
            .request(.deleteAddress(targetID, addressInfo))
            .mapTo(EmptyEntity.self)
    }
}
