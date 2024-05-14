//
//  EditRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/12.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import Then

final class EditRegionViewController: RxBaseViewController<EditRegionViewModel> {
    private var navigationView = CSNavigationView(.leftButton(.leftArrow_black)).then {
        $0.setTitle("동네 설정")
        $0.addBorder(.bottom)
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
    
    private var confirmButton = NewCSButton(.standard, style: .violet600).then {
        $0.setTitle("동네 추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private var listCount = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.pin.top(view.pin.safeArea.top).horizontally().bottom()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.backgroundColor(.violet10).define {
            $0.addItem(navigationView).width(UIScreen.main.bounds.width)
            $0.addItem(header).marginTop(22).marginLeft(20)
            $0.addItem(collectionView).marginTop(13).marginHorizontal(20).grow(1)
            $0.addItem(confirmButton).alignSelf(.stretch).marginHorizontal(20).bottom(20).height(48)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }).disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with:self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
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
    
    private func confirmButtonState() {
        confirmButton.do {
            if listCount == 3 {
                $0.isEnabled = false
            } else {
                $0.isEnabled = true
            }
        }
    }
}

// MARK: UICollectionViewLayout & DataSource
extension EditRegionViewController: UICollectionViewDataSource {
    private func setLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environment -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
                let handler: UIContextualAction.Handler = { _, _, success in
                    success(self?.viewModel.deleteRegion(indexPath.row) ?? false)
                }
                let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: handler)
                deleteAction.backgroundColor = .violet600
                
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
            config.backgroundColor = .clear
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 16
            
            return section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.loadedListRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: EditRegionCollectionViewCell.self, for: indexPath).then {
            let data = self.viewModel.loadedListRelay.value
            self.listCount = data.count
            
            $0.configureCellState(EditRegionCellState(region: data[indexPath.row].addressName, count: self.listCount))
            
            self.confirmButtonState()
        }
        
        cell.buttonTap
            .drive(with: self) { owner, _ in
                cell.button.resetState()
                owner.viewModel.didTapCellButton(indexPath.row)
            }.disposed(by: cell.bag)
        
        return cell
    }
}
