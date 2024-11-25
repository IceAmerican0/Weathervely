//
//  ClosetDetailCoordinator.swift
//  ClosetDetail
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol ClosetDetailCoordinatorDelegate {
    func detailTapped(closetID: Int, tempID: Int)
}

public class ClosetDetailCoordinator: Coordinator, ClosetDetailViewDelegate {
    public var navigationController: UINavigationController
    private var vc: ClosetDetailViewController
    var delegate: ClosetDetailCoordinatorDelegate?
    
    public init(
        navigationController: UINavigationController,
        closetID: Int,
        tempID: Int
    ) {
        self.navigationController = navigationController
        self.vc = .init(ClosetDetailViewModel(closetId: closetID, tempId: tempID))
    }
    
    public func start() {
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        navigationController.viewControllers.append(vc)
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        delegate?.detailTapped(closetID: closetID, tempID: tempID)
    }
}
