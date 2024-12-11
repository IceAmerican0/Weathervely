//
//  NotificationCoordinator.swift
//  Notification
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol NotificationCoordinatorDelegate {
    func backButtonTapped()
}

public class NotificationCoordinator: Coordinator, NotificationListViewDelegate {
    public var navigationController: UINavigationController
    public var delegate: NotificationCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = NotificationListViewController(NotificationListViewModel())
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}
