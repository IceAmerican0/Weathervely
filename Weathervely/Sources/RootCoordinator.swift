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
import SafariServices

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
    
    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func getTabBarNavigation() -> UINavigationController {
        guard let tabBar = window?.rootViewController as? HomeTabBarController,
              let currentNavigation = tabBar.currentNavigation else {
            return navigationController
        }
        return currentNavigation
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
        let tabBar = HomeTabBarController()
        tabBar.tabDelegate = self
        tabBar.setTabBar()
        
        if let navigation = tabBar.viewControllers?.first as? UINavigationController {
            navigationController = navigation
        }
        
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    // MARK: Navigation
    func toLocation() {
        let coordinator = MapCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.start()
    }
    
    func toNotification() {
        let coordinator = NotificationCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.start()
    }
    
    func toForecast() {
        let coordinator = TenDaysForecastCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.start()
    }
    
    func toFilter(delegate: HomeStyleFilterViewDelegate, selectedTime: String) {
        let coordinator = HomeCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.toFilter(delegate: delegate, selectedTime: selectedTime)
    }
    
    func toClosetDetail(closetID: Int, tempID: Int) {
        let coordinator = ClosetDetailCoordinator(
            navigationController: getTabBarNavigation(),
            closetID: closetID,
            tempID: tempID
        )
        coordinator.delegate = self
        coordinator.start()
    }
    
    func toOnBoardRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.toOnboard()
    }
    
    func toEditRegion(state: EditRegionState) {
        let coordinator = RegionCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.toEdit(state: state)
    }
    
    func toSettingRegion(state: SettingRegionState) {
        let coordinator = RegionCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.toSetting(state: state)
    }
    
    func toRegionComplete(state: SettingRegionState) {
        let coordinator = RegionCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.toComplete(state: state)
    }
    
    func toNickname() {
        let coordinator = NicknameCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.start()
    }
    
    func toCompleteNickname(nickname: String) {
        let coordinator = NicknameCoordinator(navigationController: getTabBarNavigation())
        coordinator.delegate = self
        coordinator.toComplete(nickname: nickname)
        setViewController()
    }
    
    // MARK: Safari
    func openSafari(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let webView = SFSafariViewController(url: url)
        navigationController.present(webView, animated: false)
    }
    
    // MARK: OS Settings
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        Task {
            await MainActor.run {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: Delegate
extension RootCoordinator:
    ClosetDetailCoordinatorDelegate,
    TendaysForecastCoordinatorDelegate,
    HomeTabBarDelegate,
    HomeCoordinatorDelegate,
    MapCoordinatorDelegate,
    NicknameCoordinatorDelegate,
    NotificationCoordinatorDelegate,
    RegionCoordinatorDelegate,
    SettingCoordinatorDelegate,
    StyleCoordinatorDelegate
{
    public func backButtonTapped() {
        popViewController()
    }
    
    // MARK: TabBar
    public func getViewController(tab: Tab) -> UIViewController {
        switch tab {
        case .home:
            let coordinator = HomeCoordinator(navigationController: navigationController)
            coordinator.delegate = self
            return coordinator.getViewController()
        case .style:
            let coordinator = StyleCoordinator(navigationController: navigationController)
            coordinator.delegate = self
            return coordinator.getViewController()
        case .setting:
            let coordinator = SettingCoordinator(navigationController: navigationController)
            coordinator.delegate = self
            return coordinator.getViewController()
        }
    }
    
    // MARK: Home
    public func locationTapped() {
        toLocation()
    }
    
    public func regionTapped() {
        toEditRegion(state: .edit)
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
    public func homeButtonTapped() {
        popToRootViewController()
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        toClosetDetail(closetID: closetID, tempID: tempID)
    }
    
    public func mallTapped(urlString: String) {
        openSafari(urlString: urlString)
    }
    
    // MARK: Nickname
    public func nicknameEntered(nickname: String) {
        toCompleteNickname(nickname: nickname)
    }
    
    public func nicknameOnboardCompleted() {
        toOnBoardRegion()
    }
    
    public func nicknameCompleted() {
        
    }
    
    // MARK: Region
    public func changeButtonTapped() {
        toEditRegion(state: .change)
    }
    
    public func addButtonTapped() {
        toSettingRegion(state: .add)
    }
    
    public func regionEntered(state: SettingRegionState) {
        toRegionComplete(state: state)
    }
    
    // MARK: Map
    public func settingTapped() {
        openSettings()
    }
    
    // MARK: Setting
    public func nicknameTapped() {
        toNickname()
    }
    
    public func inquiryTapped() {
        let email = "weathervely@gmail.com"
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
    
    public func policyTapped() {
        let urlString = "https://docs.google.com/document/d/1MnwR04jGms26yha2oSdps06Ju0wMn-hGS1Zs6JtDAf8/edit?usp=sharing"
        openSafari(urlString: urlString)
    }
}
