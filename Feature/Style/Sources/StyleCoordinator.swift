//
//  StyleCoordinator.swift
//  Style
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol StyleCoordinatorDelegate {
    func detailTapped(closetID: Int, tempID: Int)
}

public class StyleCoordinator: Coordinator, StyleViewDelegate {
    public var navigationController: UINavigationController
    public var delegate: StyleCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        delegate?.detailTapped(closetID: closetID, tempID: tempID)
    }
}
