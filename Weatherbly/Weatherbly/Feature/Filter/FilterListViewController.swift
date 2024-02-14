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

public protocol FilterListViewDelegate: AnyObject {
    func didTapCell(count: Int, isFiltered: Bool)
    func didTapConfirm()
}

public enum FilterListViewState: Int {
    case style
    case item
}

final class FilterListViewController: RxBaseViewController<FilterListViewModel> {
    weak var delegate: FilterListViewDelegate?
    
    private lazy var filterList = UICollectionView(
        frame: .zero,
        collectionViewLayout: setLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.registerHeader(withType: FilterListHeaderView.self)
        $0.register(withType: FilterListCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch viewModel.viewState {
        case .style: viewModel.filterStyleList()
        case .item: viewModel.filterItemList()
        }
        
        DispatchQueue.main.async {
            self.filterList.reloadData()
        }
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(filterList).marginTop(26).grow(1)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        filterList.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        filterList.rx
            .itemSelected
            .bind(with: self) { owner, _ in
                switch owner.viewModel.viewState {
                case .style: owner.viewModel.filterStyleList()
                case .item: owner.viewModel.filterItemList()
                }
            }.disposed(by: bag)
        
        viewModel.filterSection
            .observe(on: MainScheduler.instance)
            .bind(to: filterList.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.filterCount
            .subscribe(
                with: self,
                onNext: { owner, count in
                    let isFiltered = owner.viewModel.isFiltered
                    owner.delegate?.didTapCell(count: count, isFiltered: isFiltered)
                }
            ).disposed(by: bag)
    }
}

// MARK: UICollectionView DataSource & UI
extension FilterListViewController: UICollectionViewDelegate {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<FilterSection> {
        RxCollectionViewSectionedReloadDataSource<FilterSection>(configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
            guard self != nil else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case let .style(cellState):
                return collectionView.dequeueCell(
                    withType: FilterListCell.self,
                    for: indexPath
                ).then {
                    let state: FilterListCellState = .init(
                        title: cellState.title,
                        selectable: true,
                        selected: cellState.selected
                    )
                    $0.configureCellState(state: state)
                }
            case let .item(cellState):
                return collectionView.dequeueCell(
                    withType: FilterListCell.self,
                    for: indexPath
                ).then {
                    let state: FilterListCellState = .init(
                        title: cellState.title,
                        selectable: cellState.selectable,
                        selected: cellState.selected
                    )
                    $0.configureCellState(state: state)
                }
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            
            if kind == UICollectionView.elementKindSectionHeader {
                if case let .item(title, _) = dataSource[indexPath.section] {
                    return collectionView.dequeueReusableHeaderView(
                        withType: FilterListHeaderView.self,
                        for: indexPath
                    ).then {
                        $0.configureViewState(title: title)
                    }
                }
            }
            
            return UICollectionReusableView()
        })
    }
    
    // MARK: UI
    func setLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
            guard let state = self?.viewModel.viewState else { return nil }
            switch state {
            case .style:
                return self?.setStyleSection()
            case .item:
                return self?.setItemSection()
            }
        }
    }
    
    func setStyleSection() -> NSCollectionLayoutSection {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .estimated(37)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: cellSize.heightDimension
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        layoutGroup.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20, bottom: 0, trailing: 20
        )
        section.interGroupSpacing = 16
        
        return section
    }
    
    func setItemSection() -> NSCollectionLayoutSection {
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
