//
//  SettingViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/04.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxCocoa
import RxSwift

final class SettingViewController: RxBaseViewController<SettingViewModel> {
    
    private var titleLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make(text: "마이페이지")
    
    private let topView = UIView().then {
        $0.backgroundColor = .violet500
        $0.setCornerRadius(16)
    }
    
    private var profileImage = UIImageView().then {
        $0.image = .icon_profile
    }
    
    private var nameLabel = LabelMaker(
        font: .title_3_B,
        fontColor: .white
    ).make()
    
    private var nameSetButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(5)
        $0.titleLabel?.font = .body_5_M
        $0.setTitle("설정", for: .normal)
        $0.setTitleColor(.violet800, for: .normal)
    }
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .white
        $0.separatorColor = .gray20
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentInset.top = 8
        $0.register(withType: SettingTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = UserDefaultManager.shared.nickname
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define {
            $0.addItem(titleLabel)
            $0.addItem(topView).direction(.row).alignItems(.center).justifyContent(.spaceBetween).marginTop(20).width(Constants.screenWidth - 40).height(68).define { top in
                top.addItem(profileImage).marginLeft(20).size(24)
                top.addItem(nameLabel).marginLeft(12).grow(1)
                top.addItem(nameSetButton).marginRight(20).width(53).height(24)
            }
            $0.addItem().backgroundColor(.gray10).width(100%).height(16)
            $0.addItem(tableView).marginBottom(20).grow(1)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        nameSetButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.toEditNicknameView()
            }.disposed(by: bag)
        
        viewModel.menuTitle
            .bind(to: tableView.rx.items(
                cellIdentifier: SettingTableViewCell.identifier,
                cellType: SettingTableViewCell.self
            )) { _, data, cell in
                cell.configureCellState(state: data)
            }.disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.viewModel.didTapCell(at: indexPath.item)
            }.disposed(by: bag)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.menuTitle.value.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
    }
}
