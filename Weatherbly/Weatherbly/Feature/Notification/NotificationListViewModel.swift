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
    
    var refreshStatus: PublishRelay<Bool> { get }
    var notificationInfo: BehaviorRelay<[PushNotification]> { get }
}

final class NotificationListViewModel: RxBaseViewModel, NotificationListViewModelLogic {
    /// 알림 DB
    private let DBManager = PushNotificationDBManager.shared
    /// 새로고침 상태
    public var refreshStatus: PublishRelay<Bool>
    /// 알림 정보
    public var notificationInfo = BehaviorRelay<[PushNotification]>(value: [])
    
    override init() {
        self.refreshStatus = .init()
        super.init()
        self.getNotiInfo()
    }
    
    /// 새로고침
    public func pullToRefresh() {
        refreshStatus.accept(true)
        getNotiInfo()
    }
    
    /// 리스트 불러오기
    public func getNotiInfo() {
        refreshStatus.accept(false)
        DBManager.deleteOldNotification()
        notificationInfo.accept(DBManager.readAllNotifications())
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
