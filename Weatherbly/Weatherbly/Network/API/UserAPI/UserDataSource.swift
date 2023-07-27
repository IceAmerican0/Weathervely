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
    func getUserInfo(_ nickname: String) -> Observable<Result<EmptyEntity, Error>>
    func fetchUserInfo(_ userInfo: String) -> Observable<Result<EmptyEntity, Error>>
    func getAddressList(_ nickname: String) -> Observable<Result<EmptyEntity, Error>>
    func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, Error>>
    func fetchAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, Error>>
    func deleteAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, Error>>
}

public final class UserDataSource: UserDataSourceProtocol {
    
    private let provider: MoyaProvider<UserTarget>
    
    public init(provider: MoyaProvider<UserTarget> = MoyaProvider<UserTarget>()) {
        self.provider = provider
    }
    
    public func getUserInfo(_ nickname: String) -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.getUserInfo(nickname))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchUserInfo(_ userInfo: String) -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.fetchUserInfo(userInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func getAddressList(_ nickname: String) -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.getAddressList(nickname))
            .mapTo(EmptyEntity.self)
    }
    
    public func addAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.addAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func fetchAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.fetchAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
    
    public func deleteAddress(_ addressInfo: AddressRequest) -> Observable<Result<EmptyEntity, Error>> {
        provider.rx
            .request(.deleteAddress(addressInfo))
            .mapTo(EmptyEntity.self)
    }
}
