//
//  GetClosetDataSource.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import RxSwift
import Moya
import RxMoya

protocol GetClosetDataSourceProtocol {
    func getVilageForcast() -> Observable<Result<GetVilageForcastInfoEntity, WBNetworkError>>
}

final class GetVilageForcastInfoDataSource: GetClosetDataSourceProtocol {
    private var provider: MoyaProvider<ForcastTarget>
  
    init(provider: MoyaProvider<ForcastTarget> = MoyaProvider<ForcastTarget>()) {
        self.provider = provider
    }
    
    func getVilageForcast() -> Observable<Result<GetVilageForcastInfoEntity,WBNetworkError>> {
        provider
            .rx
            .request(.getVilageForcastInfo)
            .mapTo(GetVilageForcastInfoEntity.self)
        
    }
}
