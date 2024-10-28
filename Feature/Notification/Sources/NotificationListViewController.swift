//
//  NotificationListViewController.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import DesignSystem
import UIKit

public final class NotificationListViewController: RxBaseViewController<NotificationListViewModel>, Toastable {
    private var navigationView = CSNavigationView(.rightButton(.leftArrow_black, .tab_mypage_nor)).then {
        $0.setTitle("알림")
        $0.addBorder(.bottom, 1, .gray30)
    }
    
    private let shimmerView = NotificationListShimmerView()
    
    private var zeroNotiView = UIView()
    
    private var zeroNotiImageView = UIImageView().then {
        $0.image = .alarm_empty
    }
    
    private var zeroNotiLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .gray50
    ).make(text: "알림이 없습니다.")
    
    private var notiButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("알림 받기", for: .normal)
    }
    
    private let infoView = UIView().then {
        $0.backgroundColor = .gray10
        $0.setCornerRadius(12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var refresh = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.refreshControl = refresh
        $0.backgroundColor = .clear
        $0.separatorColor = .gray20
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 100))
        $0.register(withType: NotificationListTableViewCell.self)
        $0.registerHeaderFooterView(withType: NotificationListTableFooterView.self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .pushReceived, object: nil)
        NotificationCenter.default.removeObserver(self, name: .returnFromSetting, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingListView),
            name: .pushReceived,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingListView(_:)),
            name: .returnFromSetting,
            object: nil
        )
        
        viewModel.getNotiInfo()
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView)
            $0.addItem(shimmerView).grow(1)
            $0.addItem(zeroNotiView).alignItems(.center).justifyContent(.center).grow(1).define {
                $0.addItem(zeroNotiImageView).size(48)
                $0.addItem(zeroNotiLabel).marginTop(10)
                $0.addItem(notiButton).alignSelf(.stretch).marginTop(40).marginHorizontal(52).height(48).display(.none)
            }.display(.none)
            $0.addItem(tableView).marginTop(16).grow(1).display(.none)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        viewModel.shimmerStatus
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(with: self) { owner, _ in
                owner.shimmerView.removeFromSuperview()
                owner.settingListView()
                owner.container.flex.layout()
            }.disposed(by: bag)
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self) { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }.disposed(by: bag)
        
        navigationView.rightButtonDidTapRelay
            .drive(with: self) { owner, _ in
                if let homeTabBarController = owner.navigationController?.tabBarController as? HomeTabBarController {
                    homeTabBarController.switchTab(tab: .setting)
                    owner.navigationController?.viewControllers.removeLast()
                }
            }.disposed(by: bag)
        
        notiButton.rx.tap
            .bind(with: self) { _, _ in
                UserNotificationManager.shared.toPushSetting()
            }.disposed(by: bag)
        
        viewModel.refreshStatus
            .bind(with: self) { owner, refreshing in
                switch refreshing {
                case true:
                    owner.tableView.refreshControl?.beginRefreshing()
                case false:
                    owner.tableView.refreshControl?.endRefreshing()
                }
            }.disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, _ in
                owner.viewModel.navigationPushToPreviousViewControllerRelay.accept([])
            }.disposed(by: bag)
        
        viewModel.notificationInfo
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(
                cellIdentifier: NotificationListTableViewCell.identifier,
                cellType: NotificationListTableViewCell.self
            )) { row, data, cell in
                let count = self.viewModel.notificationInfo.value.count
                
                if count == 0 {
                    self.settingListView()
                }
                
                if row == count - 1 {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                }
                
                cell.selectionStyle = .none
                cell.configureCellState(state: data)
            }.disposed(by: bag)
    }
    
    override func viewModelBinding() {
        viewModel.toastRelay
            .bind(with: self) { owner, value in
                owner.presentToast(content: value)
            }.disposed(by: bag)
    }
    
    @objc
    private func settingListView(_ notification: Notification? = nil) {
        if let setting = notification?.object as? UNNotificationSettings {
            let status = setting.authorizationStatus
            if status == .notDetermined || status == .denied {
                updateView(status: false)
            } else {
                updateView(status: true)
            }
        } else {
            Task {
                let isAuthorized = await UserNotificationManager.shared.checkAuthorization()
                Task { @MainActor in
                    self.updateView(status: isAuthorized)
                }
            }
        }
    }
    
    private func updateView(status: Bool) {
        if viewModel.notificationInfo.value.count > 0 {
            zeroNotiView.flex.display(.none)
            tableView.flex.display(.flex)
        } else {
            zeroNotiView.flex.display(.flex)
            tableView.flex.display(.none)
            
            if !UserDefaultManager.shared.pushAgreement {
                notiButton.setTitle("알림 받기", for: .normal)
            }
            
            if !status {
                notiButton.flex.display(.flex)
                notiButton.setTitle("알림 권한 설정하기", for: .normal)
            }
        }
        
        zeroNotiView.flex.markDirty()
        tableView.flex.markDirty()
        container.flex.layout()
    }
    
    @objc
    private func pullToRefresh() {
        viewModel.pullToRefresh()
    }
}

extension NotificationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { [weak self] _, _, handler in
            guard let self else { return }
            handler(self.viewModel.deleteNoti(row: indexPath.row))
        })
        deleteAction.backgroundColor = .clear
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableView.dequeueHeaderFooterView(withType: NotificationListTableFooterView.self)
    }
}
