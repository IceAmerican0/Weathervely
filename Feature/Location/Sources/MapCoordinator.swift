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
}

public class MapCoordinator: Coordinator, MapViewDelegate {
    public var navigationController: UINavigationController
    var delegate: MapCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    public func start() {
        let vc = MapViewController(MapViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
}
