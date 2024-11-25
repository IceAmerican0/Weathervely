//
//  RootCoordinator.swift
//  Weathervely
//
//  Created by Khai on 11/20/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil
import ClosetDetail
import Forecast
import Home
import Location
import Nickname
import Notification
import Region
import Setting
import Style

public class RootCoordinator: Coordinator {
    
    var window: UIWindow?
    public var navigationController: UINavigationController
    
    public init(
        window: UIWindow?,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
    }
    
    public func start() {
        if !UserDefaultManager.shared.dong.isEmpty {
            setTabBar()
        } else if UserDefaultManager.shared.nickname.isEmpty {
            setRootGreeting()
        } else {
            setRootRegion()
        }
    }
}

private extension RootCoordinator {
    func setRootWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func setViewController() {
        navigationController.setViewControllers(navigationController.viewControllers, animated: true)
    }
    
    // MARK: OnBoard
    func setRootGreeting() {
        navigationController = UINavigationController(rootViewController: GreetingViewController(EmptyViewModel()))
        setRootWindow()
    }
    
    
    func setRootRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.start()
        setRootWindow()
    }
    
    // MARK: TabBar
    func setTabBar() {
        window?.rootViewController = HomeTabBarController()
        window?.makeKeyAndVisible()
    }
    
    // MARK: Navigation
    func toLocation() {
        let coordinator = MapCoordinator(navigationController: navigationController)
        coordinator.start()
        setViewController()
    }
    
    func toNotification() {
        let coordinator = NotificationCoordinator(navigationController: navigationController)
        coordinator.start()
        setViewController()
    }
    
    func toForecast() {
        let coordinator = TenDaysForecastCoordinator(navigationController: navigationController)
        coordinator.start()
        setViewController()
    }
    
    func toClosetDetail(closetID: Int, tempID: Int) {
        let coordinator = ClosetDetailCoordinator(
            navigationController: navigationController,
            closetID: closetID,
            tempID: tempID
        )
        coordinator.start()
        setViewController()
    }
    
    func toCompleteNickname(nickname: String) {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
        coordinator.toComplete(nickname: nickname)
        setViewController()
    }
    
    func toOnBoardRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.toSetting(state: .onboard)
        setViewController()
    }
    
    func toRegionComplete(state: SettingRegionState) {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.toComplete(state: state)
        setViewController()
    }
    
    func toRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.toEdit(state: .edit)
        setViewController()
    }
    
    func toNickname() {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
        coordinator.start()
        setViewController()
    }
}

// MARK: Delegate
extension RootCoordinator:
    HomeTabBarDelegate,
    HomeCoordinatorDelegate
{
    public func getViewController(tab: Tab) -> UIViewController {
        switch tab {
        case .home: HomeViewController(HomeViewModel())
        case .style: StyleViewController(StyleViewModel())
        case .setting: SettingViewController(SettingViewModel())
        }
    }
    
    public func locationTapped() {
        toLocation()
    }
    
    public func regionTapped() {
        toRegion()
    }
    
    public func notificationTapped() {
        toNotification()
    }
    
    public func forecastTapped() {
        toForecast()
    }
    
    public func filterTapped() {
        
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        toClosetDetail(closetID: closetID, tempID: tempID)
    }
}
