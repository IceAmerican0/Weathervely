//
//  StyleListView.swift
//  Weatherbly
//
//  Created by Khai on 4/30/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

public protocol StyleListViewDelegate: AnyObject {
    func didTap()
}

public final class StyleListView: UIView {
    var bag = DisposeBag()
    
    weak var delegate: StyleListViewDelegate?
    
    public lazy var filterList = UICollectionView(
        frame: .zero,
        collectionViewLayout: setCollectionLayout()
    ).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(withType: HomeStyleFilterCell.self)
    }
    
    public var viewState: [StyleTypeInfo] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout()
    }
    
    public func reloadView(state: [StyleTypeInfo]) {
        viewState = state
        filterList.reloadData()
    }
}

private extension StyleListView {
    private func layout() {
        backgroundColor = .white
        
        flex.define {
            $0.addItem(filterList).grow(1)
        }
    }
}

// MARK: UICollectionView Layout & DataSource
extension StyleListView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewState.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(
            withType: HomeStyleFilterCell.self,
            for: indexPath
        ).then {
            $0.configureCellState(state: viewState[indexPath.row])
        }
        
        cell.buttonTap
            .drive(with: self, onNext: { owner, _ in
                UserDefaultManager.shared.filteringStyle(id: owner.viewState[indexPath.row].id)
                owner.delegate?.didTap()
                cell.listButton.isSelected.toggle()
            }).disposed(by: cell.bag)
        
        return cell
    }
    
    func setCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
            guard self != nil else { return nil }
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(70),
                heightDimension: .estimated(29)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let layoutGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: itemSize,
                subitems: [item]
            )
            layoutGroup.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: layoutGroup)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0, leading: 0, bottom: 0, trailing: 0
            )
            section.interGroupSpacing = 10
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
}
