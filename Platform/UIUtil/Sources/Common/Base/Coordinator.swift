//
//  Coordinator.swift
//  Weathervely
//
//  Created by Khai on 11/20/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

public protocol TabCoordinator {
    var viewController: UIViewController { get set }
    
    func start() -> UINavigationController
}
