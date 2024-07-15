//
//  ClosetDetailDataSource.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/11/24.
//

import Foundation
import RxSwift

protocol DetailDataSourceProtocol {
//    var provider: WVProvider<ClosetDetailTarget> { get }
    
    func getClosetDetail(closetId: Int, tempId: Int) -> Observable<ClosetDetailEntity>
    func getWarmmerCloset(closetId: Int, page: Int, tempId: Int) -> Observable<DiffTempEntity>
    func getWarmRowItems(closetId: Int, page: Int, tempId: Int, row: Int) -> Observable<EachRowEntity>
    func getCoolerCloset(closetId: Int, page: Int, tempId: Int) -> Observable<DiffTempEntity>
    func getCoolRowItems(closetId: Int, page: Int, tempId: Int, row: Int) -> Observable<EachRowEntity>
}

final class DetailDataSource: DetailDataSourceProtocol {
    let provider = WVProvider<ClosetDetailTarget>()
    
    public func getClosetDetail(closetId: Int, tempId: Int) -> Observable<ClosetDetailEntity> {
        provider.rx
            .request(.closetDetail(closetId, tempId))
            .mapTo(ClosetDetailEntity.self)
    }
    
    public func getWarmmerCloset(closetId: Int, page: Int, tempId: Int) -> Observable<DiffTempEntity> {
        provider.rx
            .request(.warmerTemp(closetId, page: page, tempId: tempId))
            .mapTo(DiffTempEntity.self)
    }
    
    public func getWarmRowItems(closetId: Int, page: Int, tempId: Int, row: Int) -> Observable<EachRowEntity> {
        provider.rx
            .request(.warmerRows(closetId, page: page, tempId: tempId, row: row))
            .mapTo(EachRowEntity.self)
    }
    
    public func getCoolerCloset(closetId: Int, page: Int, tempId: Int) -> Observable<DiffTempEntity> {
        provider.rx
            .request(.coolerTemp(closetId, page: page, tempId: tempId))
            .mapTo(DiffTempEntity.self)
    }
     
    public func getCoolRowItems(closetId: Int, page: Int, tempId: Int, row: Int) -> Observable<EachRowEntity> {
        provider.rx
            .request(.coolerRows(closetId, page: page, tempId: tempId, row: row))
            .mapTo(EachRowEntity.self)
    }
}
