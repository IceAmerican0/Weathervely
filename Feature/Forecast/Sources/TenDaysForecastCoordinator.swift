//
//  TenDaysForecastCoordinator.swift
//  Forecast
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol TendaysForecastCoordinatorDelegate {
    func backButtonTapped()
}

public class TenDaysForecastCoordinator: Coordinator, TenDaysForecastViewDelegate {
    public var navigationController: UINavigationController
    public var delegate: TendaysForecastCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = TenDaysForeCastViewController(TenDaysForecastViewModel())
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}
