//
//  HomeTabBarController.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import ResourcePackage
import UIUtil
import UIKit

public final class HomeTabBarController: UITabBarController {
    var currentNavigation: UINavigationController? {
        viewControllers?[selectedIndex] as? UINavigationController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setTabBarStyle()
    }
    
    public func switchTab(tab: Tab) {
        switch tab {
        case .home:
            selectedIndex = 0
        case .style:
            selectedIndex = 1
        case .setting:
            selectedIndex = 2
        }
    }
    
    private func setTabBarStyle() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.setCornerRadius(14, [.topLeft, .topRight])
        
        // Shadow
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        tabBar.layer.setShadow(
            CGSize(width: 0, height: -1),
            UIColor.black10.cgColor, 1, 4
        )
        
        // Font
        UITabBarItem
            .appearance()
            .setTitleTextAttributes(
                [
                    .foregroundColor: UIColor.gray50,
                    .font: UIFont.body_5_B
                ],
                for: .normal
            )
        
        UITabBarItem
            .appearance()
            .setTitleTextAttributes(
                [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.body_5_B
                ],
                for: .selected
            )
    }
}
