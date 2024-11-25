//
//  RegionCoordinator.swift
//  Region
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public class RegionCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    private let vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        navigationController = UINavigationController(rootViewController: vc)
    }
    
    public func toOnboard() {
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
    
    public func toSetting(state: SettingRegionState) {
        let vc = SettingRegionViewController(SettingRegionViewModel(state))
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
    
    public func toEdit(state: EditRegionState) {
        let vc = EditRegionViewController(EditRegionViewModel(state))
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
    
    public func toComplete(state: SettingRegionState) {
//        let vc = SettingRegionCompleteViewController(SettingRegionCompleteViewModel(state))
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
}
