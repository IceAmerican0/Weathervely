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
    func didTapCell(count: Int)
}

public enum FilterListViewState {
    case style
    case item
}

final class FilterListViewController: RxBaseViewController<FilterListViewModel> {
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private lazy var filterList = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.registerHeader(withType: ClosetFilterHeaderView.self)
        $0.register(withType: FilterListCell.self)
    }
    
    private lazy var dataSource = setDataSource()

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(filterList).grow(1)
        }
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        filterList.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        filterList.rx
            .itemSelected
            .bind(
                with: self,
                onNext: { owner, _ in
                    switch owner.viewModel.viewState {
                    case .style: owner.viewModel.filterStyleList()
                    case .item: owner.viewModel.filterItemList()
                    }
                }
            )
            .disposed(by: bag)
        
        viewModel.filterSection
            .bind(to: filterList.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

// MARK: UICollectionView Delegate & DataSource
extension FilterListViewController: UICollectionViewDelegateFlowLayout {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<FilterSection> {
        RxCollectionViewSectionedReloadDataSource<FilterSection>(configureCell: { dataSource, collectionView, indexPath, _ in
//            guard self != nil else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case let .style(cellState):
                return collectionView.dequeueCell(withType: FilterListCell.self, for: indexPath).then {
                    let state: FilterListCellState = .init(
                        title: cellState.title,
                        selectable: true,
                        selected: cellState.selected
                    )
                    $0.configureCellState(state: state)
                }
            case let .cloth(cellState):
                return collectionView.dequeueCell(withType: FilterListCell.self, for: indexPath).then {
                    let info = cellState.info[indexPath.row]
                    let state: FilterListCellState = .init(
                        title: info.title,
                        selectable: info.selectable,
                        selected: info.selected
                    )
                    $0.configureCellState(state: state)
                }
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            
            if kind == UICollectionView.elementKindSectionHeader {
                if case let .cloth(title, _) = dataSource[indexPath.section] {
                    return collectionView.dequeueReusableHeaderView(withType: FilterListHeaderView.self, for: indexPath).then {
                        $0.configureViewState(title: title)
                    }
                }
            }
            
            return UICollectionReusableView()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if viewModel.viewState == .item {
            return CGSize(width: view.frame.width, height: 19)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 37)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}
