//
//  NotificationListViewModel.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import DesignSystem
import Network
import UIKit
import RxSwift
import RxCocoa

public protocol NotificationListViewModelLogic: ViewModelBusinessLogic {
    func pullToRefresh()
    func getNotiInfo()
    func deleteNoti(row: Int) -> Bool
    
    var shimmerStatus: PublishRelay<Bool> { get }
    var refreshStatus: PublishRelay<Bool> { get }
    var notificationInfo: BehaviorRelay<[NotificationEntity]> { get }
}

final class NotificationListViewModel: RxBaseViewModel, NotificationListViewModelLogic {
    private let dataSource: NotificationDataSourceProtocol = NotificationDataSource()
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
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
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
                    owner.alertState.accept(
                        .init(
                            title: "알림이 삭제됐어요",
                            alertType: .toast
                        )
                    )
                    state = true
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                    state = false
                }
            ).disposed(by: bag)
        
        return state
    }
}
