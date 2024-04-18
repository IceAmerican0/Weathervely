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
    
    var notificationInfo: PublishRelay<[NotificationInfo]> { get }
}

final class NotificationListViewModel: RxBaseViewModel, NotificationListViewModelLogic {
    /// 알림 정보
    public var notificationInfo = PublishRelay<[NotificationInfo]>()
    
    public func getNotiInfo() {
        // TODO: Delete Dummy
        let dummy: [NotificationInfo] = [
            .init(
                title: "날씨와 옷차림",
                comment: "이따 비가 억수로 내려요\n가디건+레인부츠 코디 어때요?",
                receivedTime: "방금 전"
            ),
            .init(
                title: "찜",
                comment: "홍길동이 찜한 후드티와 어울리는 코디를 준비했어요\n찬 바람이 불 때 제격이에요",
                receivedTime: "1시간 전"
            ),
            .init(
                title: "웨더블리 꿀팁",
                comment: "홈 탭에서 날씨에 맞는 나의 스타일을 세팅해요",
                receivedTime: "2일 전"
            ),
            .init(
                title: "웨더블리 꿀팁",
                comment: "홈 탭에서 날씨에 맞는 나의 스타일을 세팅해요",
                receivedTime: "2024.2.1"
            ),
        ]
        notificationInfo.accept(dummy)
    }
}
