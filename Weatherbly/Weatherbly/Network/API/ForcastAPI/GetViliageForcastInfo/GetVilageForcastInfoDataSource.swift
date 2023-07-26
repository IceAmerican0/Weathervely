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
    func getCloset() -> Observable<Result<GetVilageForcastInfoEntity, Error>>
}

final class GetVilageForcastInfoDataSource: GetClosetDataSourceProtocol {
    private var provider: GetVilageForcastInfoProvider<ForcastTarget>
  
    init(provider: GetVilageForcastInfoProvider<ForcastTarget> = GetVilageForcastInfoProvider<ForcastTarget>()) {
        self.provider = provider
    }
    
    func getCloset() -> Observable<Result<GetVilageForcastInfoEntity,Error>> {
        provider
            .request(.getVilageForcastInfo)
            .mapTo(GetVilageForcastInfoEntity.self)
        
    }
}
