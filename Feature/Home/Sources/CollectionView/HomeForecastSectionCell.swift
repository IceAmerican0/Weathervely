//
//  HomeForecastSectionCell.swift
//  Weatherbly
//
//  Created by Khai on 7/15/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import Then

public final class HomeForecastSectionCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    private var state: [HomeForecastInfo] = []
    /// 뷰컨으로 넘길 값
    public var selectedIndex: BehaviorRelay<Int> = .init(value: 0)
    /// 스크롤시 갖고 있는 값
    public var currentIndex = 0
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(
            width: Constants.screenWidth - 64,
            height: 150
        )
        $0.minimumLineSpacing = 14
    }
    
    public lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then {
        $0.delegate = self
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = .fast
        $0.contentInset = .init(top: 0, left: 32, bottom: 0, right: 32)
        $0.backgroundColor = .clear
        $0.register(withType: HomeForecastCell.self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout()
    }
    
    public func configureCellState(state: [HomeForecastInfo]) {
        self.state = state
        collectionView.reloadData()
    }
    
    public func swipePage(to index: Int) {
        currentIndex = index
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

private extension HomeForecastSectionCell {
    private func layout() {
        backgroundColor = .clear
        
        flex.define {
            $0.addItem(collectionView).marginTop(14).grow(1)
        }
    }
}

// MARK: UICollectionViewDelegate & DataSource
extension HomeForecastSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        state.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueCell(withType: HomeForecastCell.self, for: indexPath).then {
            $0.configureCellState(state: state[indexPath.row])
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidth
        let roundIndex = round(index)
        currentIndex = Int(roundIndex)
        
        targetContentOffset.pointee = CGPoint(x: roundIndex * cellWidth - scrollView.contentInset.left, y: 0)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if selectedIndex.value != currentIndex {
            selectedIndex.accept(currentIndex)
            currentIndex = -1
        }
    }
}
