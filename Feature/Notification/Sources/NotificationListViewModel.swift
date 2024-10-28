//
//  NotificationListViewModel.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import Network
import WVAlert
import UIKit

public protocol NotificationListViewModelLogic: ViewModelBusinessLogic {
    func pullToRefresh()
    func getNotiInfo()
    func deleteNoti(row: Int) -> Bool
    
    var toastRelay: PublishRelay<Bool> { get }
    var shimmerStatus: PublishRelay<Bool> { get }
    var refreshStatus: PublishRelay<Bool> { get }
    var notificationInfo: BehaviorRelay<[NotificationEntity]> { get }
}

final class NotificationListViewModel: RxBaseViewModel, NotificationListViewModelLogic {
    private let dataSource: NotificationDataSourceProtocol = NotificationDataSource()
    /// toast
    public var toastRelay: PublishRelay<Bool> = .init()
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 새로고침 상태
    public var refreshStatus: PublishRelay<Bool> = .init()
    /// 알림 정보
    public var notificationInfo = BehaviorRelay<[NotificationEntity]>(value: [])
    
    /// 새로고침
    public func pullToRefresh() {
        refreshStatus.accept(true)
        getNotiInfo()
    }
    
    /// 리스트 불러오기
    public func getNotiInfo() {
        dataSource.getNotificationList()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.notificationInfo.accept(response)
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.notificationInfo.accept([])
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 알림 삭제
    public func deleteNoti(row: Int) -> Bool {
        var state = false
        dataSource.deleteNotification(id: notificationInfo.value[row].id)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toastRelay.accept("알림이 삭제됐어요")
                    state = true
                },
                onError: { owner, error in
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                    state = false
                }
            ).disposed(by: bag)
        
        return state
    }
}
