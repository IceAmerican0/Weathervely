//
//  NotificationListViewController.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

final class NotificationListViewController: RxBaseViewController<NotificationListViewModel> {
    private var navigationView = CSNavigationView(.rightButton(.leftArrow_black, .tab_mypage_nor)).then {
        $0.setTitle("알림")
        $0.addBorder(.bottom)
    }
    
    private var zeroNotiView = UIView()
    
    private var zeroNotiImageView = UIImageView().then {
        $0.image = .alarm_empty
    }
    
    private var zeroNotiLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .gray50
    ).make(text: "알림이 없습니다.")
    
    private var buttonView = UIView()
    
    private var notiButton = NewCSButton(.standard, style: .violet600).then {
        $0.setTitle("알림 받기", for: .normal)
    }
    
    private let infoView = UIView().then {
        $0.backgroundColor = .gray10
        $0.setCornerRadius(12)
        $0.layer.masksToBounds = true
    }
    
    private var infoLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .gray70
    ).make(text: "30일이 지난 알림은 자동으로 삭제돼요.")
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.contentInset.top = 16
        $0.separatorColor = .gray20
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.register(withType: NotificationListTableViewCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.getNotiInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if checkAuthorization() {
            zeroNotiView.flex.display(.none)
            tableView.flex.display(.flex)
        } else {
            zeroNotiView.flex.display(.flex)
            buttonView.flex.display(.flex)
            tableView.flex.display(.none)
        }
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView).width(100%)
            $0.addItem().grow(1).define {
                $0.addItem(zeroNotiView).alignItems(.center).justifyContent(.center).grow(1).define {
                    $0.addItem(zeroNotiImageView).size(48)
                    $0.addItem(zeroNotiLabel).marginTop(10)
                    $0.addItem(notiButton).alignSelf(.stretch).marginTop(40).marginHorizontal(52).height(48)
                }.display(.none)
                $0.addItem(tableView).marginTop(16).grow(1)
//                $0.addItem(infoView).marginTop(16).marginHorizontal(20).maxHeight(40).grow(1).define {
//                    $0.addItem(infoLabel).marginLeft(20).grow(1)
//                }
            }
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }).disposed(by: bag)
        
        navigationView.rightButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                if let homeTabBarController = owner.navigationController?.tabBarController as? HomeTabBarController {
                    homeTabBarController.switchTab(tab: .setting)
                    owner.navigationController?.viewControllers.removeLast()
                }
            }).disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, _ in
                
            }.disposed(by: bag)
        
        viewModel.notificationInfo
            .bind(to: tableView.rx.items(
                cellIdentifier: NotificationListTableViewCell.identifier,
                cellType: NotificationListTableViewCell.self
            )) { _, data, cell in
                cell.selectionStyle = .none
                cell.configureCellState(state: data)
            }.disposed(by: bag)
    }
}

extension NotificationListViewController: UITableViewDelegate {
    
}
