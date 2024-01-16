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
    func didTapCell(selected: [String: String])
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
        
        viewModel.filterSection
            .bind(to: filterList.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

// MARK: UICollectionView Delegate & DataSource
extension FilterListViewController: UICollectionViewDelegateFlowLayout {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<FilterSection> {
        RxCollectionViewSectionedReloadDataSource<FilterSection>(configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
            guard self != nil else { return UICollectionViewCell() }
            
            return collectionView.dequeueCell(withType: FilterListCell.self, for: indexPath).then {
                let state: FilterListCellState = .init(title: "비즈니스캐주얼", selectable: true, selected: false)
                $0.configureCellState(state: state)
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            
            if self?.viewModel.viewState == .item {
                if kind == UICollectionView.elementKindSectionHeader {
                    return collectionView.dequeueReusableHeaderView(
                        withType: FilterListHeaderView.self,
                        for: indexPath
                    ).then {
                        $0.configureViewState(title: "아우터")
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
}
