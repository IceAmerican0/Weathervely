//
//  FilterListViewController.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxDataSources

final class FilterListViewController: RxBaseViewController<FilterListViewModel> {
    weak var delegate: StyleListViewDelegate?
    
    private var exitButton = UIButton().then {
        $0.setImage(.filter_exit, for: .normal)
    }
    
    private lazy var filterList = UICollectionView(
        frame: .zero,
        collectionViewLayout: setLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.registerHeader(withType: FilterListHeaderView.self)
        $0.register(withType: HomeItemFilterCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    private var resetButton = NewCSButton(.standard, style: .violet100).then {
        $0.setImage(.filter_reset, for: .normal)
        $0.setImage(.filter_reset_dis, for: .disabled)
        $0.backgroundColor = .gray30
        $0.isEnabled = false
    }
    
    private let confirmButton = NewCSButton(.standard, style: .violet600).then {
        $0.titleLabel?.font = .title_3_B
        $0.setTitle("n개 코디 보기", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exitButton.pin.top(16).right(20).size(24)
        filterList.pin.below(of: exitButton).horizontally().bottom(88)
        resetButton.pin.bottomLeft(20).width(72).height(48)
        confirmButton.pin.after(of: resetButton).bottomRight(20).marginLeft(8).height(48)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.addSubview(exitButton)
        container.addSubview(filterList)
        container.addSubview(resetButton)
        container.addSubview(confirmButton)
        
        viewModel.getCategoryList()
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        viewModel.filterSection
            .observe(on: MainScheduler.instance)
            .bind(to: filterList.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.filterCount
            .asDriver(onErrorJustReturn: -1)
            .drive(with: self) { owner, count in
                if count > 0 {
                    owner.confirmButton.isEnabled = true
                    owner.confirmButton.setTitle("\(count)개 코디 보기", for: .normal)
                } else {
                    owner.confirmButton.isEnabled = false
                    if count == 0 {
                        owner.confirmButton.setTitle("조건에 맞는 코디가 없어요", for: .normal)
                    } else {
                        owner.confirmButton.setTitle("다시 시도해주세요", for: .normal)
                    }
                }
            }.disposed(by: bag)
        
        viewModel.selectedList
            .subscribe(
                with: self,
                onNext: { owner, list in
                    if list.count > 0 {
                        owner.resetButton.isEnabled = true
                    } else {
                        owner.resetButton.isEnabled = false
                    }
            }).disposed(by: bag)
        
        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isLoading in
                switch isLoading {
                case true:
                    owner.confirmButton.startAnimation()
                case false:
                    owner.confirmButton.stopAnimation()
                }
            }.disposed(by: bag)
        
        exitButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: bag)
        
        resetButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.reset()
                owner.filterList.reloadData()
            }.disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                if owner.confirmButton.titleLabel?.text != "다시 시도해주세요" {
                    owner.viewModel.filterCompleted()
                    owner.delegate?.didTap()
                }
                owner.dismiss(animated: true)
            }.disposed(by: bag)
    }
}

// MARK: UICollectionView DataSource & UI
extension FilterListViewController {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<FilterSection> {
        RxCollectionViewSectionedReloadDataSource<FilterSection>(configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
            guard let self else { return UICollectionViewCell() }
            
            if case let .item(cellState) = dataSource[indexPath] {
                let cell = collectionView.dequeueCell(
                    withType: HomeItemFilterCell.self,
                    for: indexPath
                ).then {
                    $0.configureCellState(state: cellState, selectedList: self.viewModel.selectedList.value)
                }
                
                cell.buttonTap
                    .drive(with: self) { owner, _ in
                        if owner.viewModel.isLoading.value { return }
                        owner.viewModel.getFilterCount(id: cellState.id)
                        cell.listButton.isSelected.toggle()
                    }.disposed(by: cell.bag)
                
                return cell
            }
            return UICollectionViewCell()
            
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
        
            if case UICollectionView.elementKindSectionHeader = kind {
                if case let .item(category, _) = dataSource[indexPath.section] {
                    return collectionView.dequeueReusableHeaderView(
                        withType: FilterListHeaderView.self,
                        for: indexPath
                    ).then {
                        $0.configureViewState(title: category)
                    }
                }
            }
            return UICollectionReusableView()
        })
    }
    
    // MARK: UI
    func setLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
            guard self != nil else { return nil }
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(37)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: item.layoutSize.heightDimension
                ),
                subitems: [item]
            )
            group.interItemSpacing = .fixed(16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(19)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 12, leading: 20, bottom: 26, trailing: 20
            )
            section.interGroupSpacing = 20
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    }
}
