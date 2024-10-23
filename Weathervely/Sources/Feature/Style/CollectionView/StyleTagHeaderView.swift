//
//  StyleTagHeaderView.swift
//  Weathervely
//
//  Created by Khai on 10/21/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public final class StyleTagHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    
    weak var delegate: HomeStyleFilterViewDelegate?
    
    private var viewState: [CategoryInfo] = []
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout().setFlexibleLayout()
    ).then {
        $0.alwaysBounceVertical = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: TypeTagCell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    private func layout() {
        flex.addItem(collectionView).marginTop(14).grow(1)
    }
    
    public func configureState(state: [CategoryInfo]) {
        viewState = state
        collectionView.reloadData()
    }
}

extension StyleTagHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewState.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: TypeTagCell.self, for: indexPath).then {
            $0.configureCellState(text: viewState[indexPath.row].name)
        }
        
        return cell
    }
}
