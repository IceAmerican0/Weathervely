//
//  NicknameCoordinator.swift
//  Nickname
//
//  Created by Khai on 11/21/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil

public protocol NicknameCoordinatorDelegate {
    func backButtonTapped()
    func nicknameEntered(nickname: String)
    func nicknameCompleted()
}

public class NicknameCoordinator: Coordinator, NicknameViewDelegate {
    public var navigationController: UINavigationController
    var delegate: NicknameCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = NicknameViewController(NicknameViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
    
    public func toComplete(nickname: String) {
        let vc = NicknameCompleteViewController(NicknameCompleteViewModel(nickname: nickname))
        vc.hidesBottomBarWhenPushed = true
        navigationController.viewControllers.append(vc)
    }
    
    public func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    public func nicknameEntered(nickname: String) {
        delegate?.nicknameEntered(nickname: nickname)
    }
    
    public func nicknameCompleted() {
        delegate?.nicknameCompleted()
    }
}
