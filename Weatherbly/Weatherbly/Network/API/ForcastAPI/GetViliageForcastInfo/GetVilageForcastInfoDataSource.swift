//
//  GetClosetDataSource.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import Foundation
import RxSwift
import Moya

protocol GetClosetDataSourceProtocol {
    func getCloset() -> Observable<Result<GetVilageForcastInfoEntity, WBNetworkError>>
}

final class GetVilageForcastInfoDataSource: GetClosetDataSourceProtocol {
    private var provider: MoyaProvider<ForcastTarget>
  
    init(provider: MoyaProvider<ForcastTarget> = MoyaProvider<ForcastTarget>()) {
        self.provider = provider
    }
    
    func getCloset() -> Observable<Result<GetVilageForcastInfoEntity,WBNetworkError>> {
        provider
            .rx
            .request(.getVilageForcastInfo)
            .mapTo(GetVilageForcastInfoEntity.self)
        
    }
}
