//
//  HomeTabBarController.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import ResourcePackage
import UIUtil
import UIKit

public protocol HomeTabBarDelegate {
    func getViewController(tab: Tab) -> UIViewController
}

public final class HomeTabBarController: UITabBarController {
    
    public var tabDelegate: HomeTabBarDelegate?
    
    var currentNavigation: UINavigationController? {
        viewControllers?[selectedIndex] as? UINavigationController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public func setTabBar() {
        var tabs: [UIViewController] = []
        Tab.allCases.forEach { tab in
            guard let vc = tabDelegate?.getViewController(tab: tab) else { return }
            vc.title = tab.title
            vc.tabBarItem = UITabBarItem(
                title: tab.title,
                image: tab.image,
                selectedImage: tab.selectedImage.withRenderingMode(.alwaysOriginal)
            )
            
            // 탭 타이틀 폰트 조정
            let baseAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray50,
                .font: UIFont.body_5_B
            ]
            
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.body_5_B
            ]
            
            vc.tabBarItem.setTitleTextAttributes(baseAttributes, for: .normal)
            vc.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
            
            tabs.append(UINavigationController(rootViewController: vc))
        }
        viewControllers = tabs
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.setCornerRadius(14, [.topLeft, .topRight])
        
        UITabBar.clearShadow()
        tabBar.layer.setShadow(
            CGSize(width: 0, height: -1),
            UIColor.black10.cgColor, 1, 4
        )
    }
    
    func switchTab(tab: Tab) {
        switch tab {
        case .home:
            selectedIndex = 0
        case .style:
            selectedIndex = 1
        case .setting:
            selectedIndex = 2
        }
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
