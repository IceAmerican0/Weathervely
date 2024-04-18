//
//  HomeTabBarController.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit

public final class HomeTabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setTabBar()
    }
    
    private func setTabBar() {
        var tabs: [UIViewController] = []
        Tab.allCases.forEach { tab in
            let viewController = tab.viewController
            viewController.title = tab.title
            viewController.tabBarItem = UITabBarItem(title: tab.title,
                                                     image: tab.image,
                                                     selectedImage: tab.selectedImage.withRenderingMode(.alwaysOriginal))
            
            // 탭 타이틀 폰트 조정
            let baseAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray50,
                .font: UIFont.body_5_B
            ]
            
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.body_5_B
            ]
            
            viewController.tabBarItem.setTitleTextAttributes(baseAttributes, for: .normal)
            viewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
            
            tabs.append(viewController)
        }
        viewControllers = tabs.map { UINavigationController(rootViewController: $0) }
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.setCornerRadius(14, [.topLeft, .topRight])
        
        UITabBar.clearShadow()
        tabBar.layer.setShadow(
            CGSize(width: 0, height: -1),
            UIColor.black10.cgColor, 1, 4
        )
    }
    
    func switchToSettingsTab() {
        selectedIndex = 2
    }
}

extension UITabBar {
    /// 기본 그림자 스타일 초기화
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
