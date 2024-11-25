//
//  HomeCoordinator.swift
//  Home
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol HomeCoordinatorDelegate {
    func locationTapped()
    func regionTapped()
    func notificationTapped()
    func forecastTapped()
    func filterTapped()
    func detailTapped(closetID: Int, tempID: Int)
}

public class HomeCoordinator: Coordinator, HomeViewDelegate {
    public var navigationController: UINavigationController
    
    var delegate: HomeViewDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = HomeViewController(HomeViewModel())
        vc.delegate = self
    }
    
    public func locationTapped() {
        delegate?.locationTapped()
    }
    
    public func regionTapped() {
        delegate?.regionTapped()
    }
    
    public func notificationTapped() {
        delegate?.notificationTapped()
    }
    
    public func forecastTapped() {
        delegate?.forecastTapped()
    }
    
    public func filterTapped() {
        delegate?.filterTapped()
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        delegate?.detailTapped(closetID: closetID, tempID: tempID)
    }
}
