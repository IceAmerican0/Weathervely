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
        view.backgroundColor = .white
        setTabBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setTabBar() {
        var tabs: [UIViewController] = []
        Tab.allCases.forEach { tab in
            let resizedImage = tab.image.resized(to: CGSize(width: 30, height: 30))
            let viewController = tab.viewController
            viewController.title = tab.title
            viewController.tabBarItem = UITabBarItem(title: tab.title,
                                                     image: resizedImage,
                                                     selectedImage: nil)
            tabs.append(viewController)
        }
        viewControllers = tabs.map { UINavigationController(rootViewController: $0) }
    }
}
