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
    func getNotiInfo()
    func deleteNoti(row: Int) -> Bool
    
    var notificationInfo: BehaviorRelay<[PushNotification]> { get }
}

final class NotificationListViewModel: RxBaseViewModel, NotificationListViewModelLogic {
    /// 알림 DB
    private let DBManager = PushNotificationDBManager.shared
    /// 알림 정보
    public var notificationInfo = BehaviorRelay<[PushNotification]>(value: [])
    
    public func getNotiInfo() {
//        notificationInfo.accept(DBManager.readAllNotifications())
        
        // TODO: Delete Dummy
        let dummy: [PushNotification] = [
            .init(
                id: 0,
                title: "날씨와 옷차림",
                message: "이따 비가 억수로 내려요\n가디건+레인부츠 코디 어때요?",
                date: "방금 전"
            ),
            .init(
                id: 1,
                title: "찜",
                message: "홍길동이 찜한 후드티와 어울리는 코디를 준비했어요\n찬 바람이 불 때 제격이에요",
                date: "1시간 전"
            ),
            .init(
                id: 2,
                title: "웨더블리 꿀팁",
                message: "홈 탭에서 날씨에 맞는 나의 스타일을 세팅해요",
                date: "2일 전"
            ),
            .init(
                id: 3,
                title: "웨더블리 꿀팁",
                message: "홈 탭에서 날씨에 맞는 나의 스타일을 세팅해요",
                date: "2024.2.1"
            ),
        ]
        notificationInfo.accept(dummy)
    }
    
    public func deleteNoti(row: Int) -> Bool {
        let id = notificationInfo.value[row].id
        return DBManager.deleteNotification(id: id)
    }
}
