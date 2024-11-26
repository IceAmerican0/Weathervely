//
//  NotificationDataSource.swift
//  Weatherbly
//
//  Created by Khai on 7/18/24.
//

import Moya
import RxSwift
import RxMoya
import Foundation

public protocol NotificationDataSourceProtocol {
    func getNotificationList() -> Observable<[NotificationEntity]>
    func deleteNotification(id: Int) -> Observable<EmptyEntity>
}

public final class NotificationDataSource: NotificationDataSourceProtocol {
    private let provider: WVProvider<NotificationTarget>
    
    public init(provider: WVProvider<NotificationTarget> = WVProvider<NotificationTarget>()) {
        self.provider = provider
    }
    
    public func getNotificationList() -> Observable<[NotificationEntity]> {
        provider
            .request(.getNotificationList)
            .flatMap { response in
                do {
                    return .just(try response.map([NotificationEntity].self))
                } catch(let error) {
                    if let error = error as? MoyaError {
                        return .error(WVNetworkError.networkError(error))
                    }
                    return .error(WVNetworkError.unknownError)
                }
            }.asObservable()
    }
    
    public func deleteNotification(id: Int) -> Observable<EmptyEntity> {
        provider
            .request(.deleteNotification(id: id))
            .mapTo(EmptyEntity.self)
    }
}
