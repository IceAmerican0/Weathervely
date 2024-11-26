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
    
    func popViewController() {
        navigationController.popViewController(animated: true)
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
    
    func toFilter(delegate: HomeStyleFilterViewDelegate, selectedTime: String) {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.toFilter(delegate: delegate, selectedTime: selectedTime)
        
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
    
    func toOnBoardRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.toSetting(state: .onboard)
        setViewController()
    }
    
    func toRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.toEdit(state: .edit)
        setViewController()
    }
    
    func toRegionComplete(state: SettingRegionState) {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.toComplete(state: state)
        setViewController()
    }
    
    func toNickname() {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
        coordinator.start()
        setViewController()
    }
    
    func toCompleteNickname(nickname: String) {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
        coordinator.toComplete(nickname: nickname)
        setViewController()
    }
}

// MARK: Delegate
extension RootCoordinator:
    HomeTabBarDelegate,
    HomeCoordinatorDelegate,
    StyleCoordinatorDelegate,
    ClosetDetailCoordinatorDelegate,
    NicknameCoordinatorDelegate,
    RegionCoordinatorDelegate,
    SettingCoordinatorDelegate
{
    public func backButtonTapped() {
        popViewController()
    }
    
    // MARK: TabBar
    public func getViewController(tab: Tab) -> UIViewController {
        switch tab {
        case .home: HomeViewController(HomeViewModel())
        case .style: StyleViewController(StyleViewModel())
        case .setting: SettingViewController(SettingViewModel())
        }
    }
    
    // MARK: Home
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
    
    public func filterTapped(delegate: HomeStyleFilterViewDelegate, selectedTime: String) {
        toFilter(delegate: delegate, selectedTime: selectedTime)
    }
    
    // MARK: ClosetDetail
    public func detailTapped(closetID: Int, tempID: Int) {
        toClosetDetail(closetID: closetID, tempID: tempID)
    }
    
    // MARK: Nickname
    public func nicknameEntered(nickname: String) {
        toCompleteNickname(nickname: nickname)
    }
    
    public func nicknameCompleted() {
        toOnBoardRegion()
    }
    
    // MARK: Region
    public func changeButtonTapped() {
        <#code#>
    }
    
    public func addButtonTapped() {
        <#code#>
    }
    
    public func regionEntered(state: SettingRegionState) {
        toRegionComplete(state: state)
    }
    
    // MARK: Setting
    public func inquiryTapped() {
        
    }
    
    public func policyTapped() {
        
    }
}
