//
//  NotificationListViewModel.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import UIKit
import RxSwift
import RxCocoa

public protocol NotificationListViewModelLogic: ViewModelBusinessLogic {
    func pullToRefresh()
    func getNotiInfo()
    func deleteNoti(row: Int) -> Bool
    
    var shimmerStatus: PublishRelay<Bool> { get }
    var refreshStatus: PublishRelay<Bool> { get }
    var notificationInfo: BehaviorRelay<[PushNotification]> { get }
}

final class NotificationListViewModel: RxBaseViewModel, NotificationListViewModelLogic {
    /// 알림 DB
    private let DBManager = PushNotificationDBManager.shared
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 새로고침 상태
    public var refreshStatus: PublishRelay<Bool> = .init()
    /// 알림 정보
    public var notificationInfo = BehaviorRelay<[PushNotification]>(value: [])
    
    /// 새로고침
    public func pullToRefresh() {
        refreshStatus.accept(true)
        getNotiInfo()
    }
    
    /// 리스트 불러오기
    public func getNotiInfo() {
        DBManager.deleteOldNotification()
        let list = DBManager.readAllNotifications()
        shimmerStatus.accept(true)
        refreshStatus.accept(false)
        notificationInfo.accept(list)
    }
    
    /// 알림 삭제
    public func deleteNoti(row: Int) -> Bool {
        let id = notificationInfo.value[row].id
        let state = DBManager.deleteNotification(id: id)
        
        if state {
            alertState.accept(
                .init(
                    title: "알림이 삭제됐어요",
                    alertType: .toast
                )
            )
        }
        
        getNotiInfo()
        
        return state
    }
}
