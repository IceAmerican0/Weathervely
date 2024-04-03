//
//  AlertViewState.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit

public struct AlertViewState {
    public enum AlertType {
        /// 토스트
        case toast
        /// 알럿창
        case popup
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
    public let closeAction: AlertActionHandler?
    public let buttonListState: AlertButtonListState
    public let hapticType: HapticType
    
    public init(
        title: String,
        message: String? = nil,
        alertType: AlertType,
        closeAction: AlertActionHandler? = nil,
        buttonListState: AlertButtonListState = .single,
        hapticType: HapticType = .impact
    ) {
        self.title = title
        self.message = message
        self.alertType = alertType
        self.closeAction = closeAction
        self.buttonListState = buttonListState
        self.hapticType = hapticType
    }
}

public typealias AlertActionHandler = () -> Void

public enum AlertButtonListState {
    case single
    case double(left: AlertButtonState, right: AlertButtonState)
}

public struct AlertButtonState {
    let title: String
    let action: AlertActionHandler?
    
    public init(title: String, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }
}
