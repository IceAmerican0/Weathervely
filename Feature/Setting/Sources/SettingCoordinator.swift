//
//  SettingCoordinator.swift
//  Setting
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol SettingCoordinatorDelegate {
    func regionTapped()
    func notificationTapped()
    func inquiryTapped()
    func policyTapped()
}

public class SettingCoordinator: Coordinator, SettingViewDelegate {
    public var navigationController: UINavigationController
    var delegate: SettingCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
    }
    
    public func regionTapped() {
        delegate?.regionTapped()
    }
    
    public func notificationTapped() {
        delegate?.notificationTapped()
    }
    
    public func inquiryTapped() {
        delegate?.inquiryTapped()
    }
    
    public func policyTapped() {
        delegate?.policyTapped()
    }
}
