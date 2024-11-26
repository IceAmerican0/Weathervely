//
//  StyleTagHeaderView.swift
//  Weathervely
//
//  Created by Khai on 10/21/24.
//

import WVNetwork
import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public protocol StyleTagHeaderViewDelegate: AnyObject {
    func didTap(row: Int)
}

public final class StyleTagHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    
    weak var delegate: StyleTagHeaderViewDelegate?
    
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
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
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
        backgroundColor = .white
        flex.addItem(collectionView).marginTop(14).marginLeft(20).grow(1)
    }
    
    public func configureState(state: [CategoryInfo]) {
        viewState = state
        collectionView.reloadData()
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, indexPath in
                    owner.delegate?.didTap(row: indexPath.row)
                    owner.autoScroll(to: indexPath.row)
                }
            ).disposed(by: bag)
    }
    
    public func autoScroll(to row: Int) {
        collectionView.selectItem(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .left)
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
