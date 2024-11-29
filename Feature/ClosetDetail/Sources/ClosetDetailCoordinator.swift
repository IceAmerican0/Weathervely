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
    func backButtonTapped()
    func homeButtonTapped()
    func detailTapped(closetID: Int, tempID: Int)
    func mallTapped(urlString: String)
}

public class ClosetDetailCoordinator: Coordinator, ClosetDetailViewDelegate {
    public var navigationController: UINavigationController
    private var vc: ClosetDetailViewController
    public var delegate: ClosetDetailCoordinatorDelegate?
    
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
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    public func homeButtonTapped() {
        delegate?.homeButtonTapped()
    }
    
    public func detailTapped(closetID: Int, tempID: Int) {
        delegate?.detailTapped(closetID: closetID, tempID: tempID)
    }
    
    public func mallTapped(urlString: String) {
        delegate?.mallTapped(urlString: urlString)
    }
}
