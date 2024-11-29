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
        coordinator.delegate = self
        coordinator.start()
        setViewController()
    }
    
    func toNotification() {
        let coordinator = NotificationCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        setViewController()
    }
    
    func toForecast() {
        let coordinator = TenDaysForecastCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        setViewController()
    }
    
    func toFilter(delegate: HomeStyleFilterViewDelegate, selectedTime: String) {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.toFilter(delegate: delegate, selectedTime: selectedTime)
    }
    
    func toClosetDetail(closetID: Int, tempID: Int) {
        let coordinator = ClosetDetailCoordinator(
            navigationController: navigationController,
            closetID: closetID,
            tempID: tempID
        )
        coordinator.delegate = self
        coordinator.start()
        setViewController()
    }
    
    func toOnBoardRegion() {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.toOnboard()
    }
    
    func toRegion(state: EditRegionState) {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.toEdit(state: state)
        setViewController()
    }
    
    func toRegionComplete(state: SettingRegionState) {
        let coordinator = RegionCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.toComplete(state: state)
        setViewController()
    }
    
    func toNickname() {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        setViewController()
    }
    
    func toCompleteNickname(nickname: String) {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
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
        Task { @MainActor in
            UIApplication.shared.open(url)
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
        toRegion(state: .edit)
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
        toRegion(state: .change)
    }
    
    public func addButtonTapped() {
        toRegion(state: .add)
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
