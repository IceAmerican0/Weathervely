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
    func filterTapped(delegate: HomeStyleFilterViewDelegate, selectedTime: String)
    func detailTapped(closetID: Int, tempID: Int)
}

public class HomeCoordinator:
    Coordinator,
    HomeViewDelegate
{
    public var navigationController: UINavigationController
    
    var delegate: HomeCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = HomeViewController(HomeViewModel())
        vc.delegate = self
    }
    
    public func toFilter(delegate: HomeStyleFilterViewDelegate, selectedTime: String) {
        let vc = FilterListViewController(FilterListViewModel(selectedTime: selectedTime))
        vc.delegate = delegate
        vc.setBottomSheet()
//        presentViewControllerWithAnimationRelay.accept(vc)
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
    
    public func filterTapped(delegate: HomeStyleFilterViewDelegate, selectedTime: String) {
        self.delegate?.filterTapped(delegate: delegate, selectedTime: selectedTime)
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        delegate?.detailTapped(closetID: closetID, tempID: tempID)
    }
}
