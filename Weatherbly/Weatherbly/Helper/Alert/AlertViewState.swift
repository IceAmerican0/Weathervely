//
//  AlertViewState.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit

public struct AlertViewState {
    public enum AlertType {
        /// 알림
        case Info
        /// 에러
        case Error
    }
    
    public enum HapticType {
        case success
        case error
        case warning
        case select
        case impact
    }
    
    public var title: String
    public var message: String?
    public let alertType: AlertType
    public let hapticType: HapticType
    
    public init(title: String,
                message: String? = nil,
                alertType: AlertType,
                hapticType: HapticType = .impact) {
        self.title = title
        self.message = message
        self.alertType = alertType
        self.hapticType = hapticType
    }
}

public typealias AlertActionHandler = () -> Void

// TODO: 추후 예/아니오 알럿 선택시
public enum AlertBoxButtonListState {
    case single
    case double
}

public struct AlertBoxButtonState {
    let title: String
    let action: (() -> Void)?
    
    public init(title: String, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }
}
