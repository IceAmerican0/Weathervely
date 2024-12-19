//
//  EditRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/12.
//

import DesignSystem
import UIUtil
import UIKit

public final class EditRegionViewController: RxBaseViewController<EditRegionViewModel>, Toastable {
    private var navigationView = CSNavigationView(.leftOnly(.leftArrow_black)).then {
        $0.setTitle("동네 설정")
        $0.addBorder(.bottom, 1, .gray30)
    }
    
    private let header = LabelMaker(
        font: .body_3_M,
        fontColor: .gray200
    ).make(text: "즐겨 찾는 동네 (최대 3개)")
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setLayout()
    ).then {
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.backgroundColor = .clear
        $0.register(withType: EditRegionCollectionViewCell.self)
    }
    
    private var confirmButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("동네 추가하기", for: .normal)
    }
    
    private var listCount = 0
    
    var delegate: RegionViewDelegate?
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.pin.top(view.pin.safeArea.top).horizontally().bottom()
    }
    
    public override func layout() {
        super.layout()
        
        container.flex.backgroundColor(.violet10).define {
            $0.addItem(navigationView)
            $0.addItem(header).marginTop(22).marginLeft(20)
            $0.addItem(collectionView).marginTop(13).marginHorizontal(20).grow(1)
            $0.addItem(confirmButton).alignSelf(.stretch).marginHorizontal(20).bottom(20).height(48)
        }
    }
    
    public override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.delegate?.backButtonTapped()
            }).disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with:self) { owner, _ in
                owner.delegate?.addButtonTapped()
            }
            .disposed(by: bag)
    }
    
    public override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.toastRelay
            .bind(with: self) { owner, value in
                owner.presentToast(content: value)
            }.disposed(by: bag)
        
        viewModel.loadedListRelay
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }.disposed(by: bag)
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.viewModel.updateMainRegion(indexPath.row)
            }.disposed(by: bag)
    }
}

// MARK: UICollectionViewLayout & DataSource
extension EditRegionViewController: UICollectionViewDataSource {
    private func setLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environment -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
                let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { _, _, handler in
                    handler(self?.viewModel.deleteRegion(indexPath.row) ?? false)
                })
                
                let editAction = UIContextualAction(style: .normal, title: "편집", handler: { _, _, handler in
                    self?.viewModel.didTapCellButton(indexPath.row)
                })
                
                let size = CGSize(width: 68, height: 68)
                deleteAction.image = UIImage().setSwipeActionView(size: size, color: .gray40, radius: 16, image: UIImage.icon_delete_list)
                editAction.image = UIImage().setSwipeActionView(size: size, color: .violet200, radius: 16, image: UIImage.icon_edit_list)
                
                deleteAction.backgroundColor = .violet10
                editAction.backgroundColor = .violet10
                
                return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            }
            config.backgroundColor = .clear
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 16
            
            return section
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.loadedListRelay.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueCell(withType: EditRegionCollectionViewCell.self, for: indexPath).then {
            let data = self.viewModel.loadedListRelay.value
            self.listCount = data.count
            
            $0.configureCellState(region: data[indexPath.row].addressName, row: indexPath.row)
        }
    }
}
