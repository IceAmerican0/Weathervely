//
//  NotificationCoordinator.swift
//  Notification
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public class NotificationCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = NotificationListViewController(NotificationListViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
}
