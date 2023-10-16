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
        
        Tab.allCases.forEach { tab in
            let viewController = tab.viewController
            viewController.tabBarItem = UITabBarItem(title: tab.title, image: UIImage(systemName: tab.rawValue), selectedImage: nil)
            viewControllers?.append(viewController)
        }
    }
}
