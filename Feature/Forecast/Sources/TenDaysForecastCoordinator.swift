//
//  TenDaysForecastCoordinator.swift
//  Forecast
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public class TenDaysForecastCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = TenDaysForeCastViewController(TenDaysForecastViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
}
