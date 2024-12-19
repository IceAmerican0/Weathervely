//
//  MapCoordinator.swift
//  Location
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol MapCoordinatorDelegate {
    func backButtonTapped()
    func settingTapped()
}

public class MapCoordinator: Coordinator, MapViewDelegate {
    public var navigationController: UINavigationController
    public var delegate: MapCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = MapViewController(MapViewModel())
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    public func settingTapped() {
        delegate?.settingTapped()
    }
}
