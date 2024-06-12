//
//  ClosetDetailDataSource.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/11/24.
//

import Foundation
import RxSwift

final class ClosetDetailDataSource {
    private let provider = WVProvider<ClosetDetailTarget>()
    
    public func getClosetDetail(closetId: Int) -> Observable<ClosetDetailEntity> {
        provider.rx
            .request(.closetDetail(closetId))
            .mapTo(ClosetDetailEntity.self)
    }
    
    public func getWarmmerCloset(closetId: Int, page: Int) -> Observable<DiffTempEntity> {
        provider.rx
            .request(.warammerTemp(closetId, page: page))
            .mapTo(DiffTempEntity.self)
    }
    
    public func getCoolerCloset(closetId: Int, page: Int) -> Observable<DiffTempEntity> {
        provider.rx
            .request(.coolerTemp(closetId, page: page))
            .mapTo(DiffTempEntity.self)
    }
}
