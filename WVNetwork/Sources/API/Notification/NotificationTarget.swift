//
//  NotificationTarget.swift
//  Weatherbly
//
//  Created by Khai on 7/18/24.
//

import Moya

public enum NotificationTarget {
    /// 알림 리스트 가져오기
    case getNotificationList
    /// 알림 삭제
    case deleteNotification(id: Int)
}

extension NotificationTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getNotificationList:         "/notification"
        case .deleteNotification(let id):  "/notification/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getNotificationList:
            return .get
        case .deleteNotification:
            return .patch
        }
    }
    
    public var task: Moya.Task { .requestPlain }
}
