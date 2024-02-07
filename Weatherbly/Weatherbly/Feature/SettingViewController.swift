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
        font: .body_2_M,
        fontColor: .white
    ).make()
    
    private var nameSetButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(5)
        $0.titleLabel?.font = .body_5_M
        $0.setTitle("설정", for: .normal)
        $0.setTitleColor(.violet800, for: .normal)
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(
            width: (Constants.screenWidth - 72) / 3,
            height: 100
        )
        $0.sectionInset = UIEdgeInsets(
            top: 16, left: 20, bottom: 20, right: 20
        )
        $0.minimumLineSpacing = 16
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then {
        $0.delegate = self
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(withType: SettingCollectionViewCell.self)
    }
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.bounces = false
        $0.backgroundColor = .white
        $0.separatorColor = .gray20
        $0.separatorInset = UIEdgeInsets(
            top: 0, left: 20, bottom: 0, right: 20
        )
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
            $0.addItem(titleLabel).marginTop(11.5)
            $0.addItem(topView).direction(.row).alignItems(.center).justifyContent(.spaceBetween).marginTop(20).width(Constants.screenWidth - 40).height(68).define { top in
                top.addItem(profileImage).marginLeft(20).size(24)
                top.addItem(nameLabel).marginLeft(12).grow(1)
                top.addItem(nameSetButton).marginRight(20).width(53).height(24)
            }
            $0.addItem(collectionView).width(100%).height(136)
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
        
        viewModel.profileMenuTitle
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }.disposed(by: bag)
        
        viewModel.menuTitle
            .bind(to: tableView.rx.items(
                cellIdentifier: SettingTableViewCell.identifier,
                cellType: SettingTableViewCell.self
            )) { _, data, cell in
                cell.configureCellState(state: data)
            }.disposed(by: bag)
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.viewModel.didTapCollectionViewCell(at: indexPath.item)
            }.disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.viewModel.didTapTableViewCell(at: indexPath.item)
            }.disposed(by: bag)
    }
}

// MARK: UICollectionViewDelegate & DataSource
extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.profileMenuTitle.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueCell(withType: SettingCollectionViewCell.self, for: indexPath).then {
            let data = viewModel.profileMenuTitle.value
            $0.configureCellState(state: data[indexPath.item])
        }
    }
}

// MARK: UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.menuTitle.value.count - 1 {
            cell.separatorInset = UIEdgeInsets(
                top: 0, left: cell.bounds.size.width, bottom: 0, right: 0
            )
        }
    }
}
