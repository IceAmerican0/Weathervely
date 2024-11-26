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
    var delegate: NotificationCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = NotificationListViewController(NotificationListViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}
