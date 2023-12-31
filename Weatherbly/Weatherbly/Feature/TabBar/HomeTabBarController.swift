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
        self.navigationController?.isNavigationBarHidden = true
        setTabBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        tabBar.layer.cornerRadius = 14
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        UITabBar.clearShadow()
        tabBar.layer.setShadow(
            CGSize(width: 0, height: -1),
            UIColor.black10.cgColor, 1, 4
        )
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
