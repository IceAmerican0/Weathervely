//
//  HomeForecastSectionView.swift
//  Weatherbly
//
//  Created by Khai on 7/15/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public final class HomeForecastSectionView: UIView {
    private var state: [HomeForecastInfo] = []
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(
            width: Constants.screenWidth - 40,
            height: 150
        )
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then {
        $0.delegate = self
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        $0.register(withType: HomeForecastCell.self)
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
        pin.all()
        flex.layout()
    }
    
    public func configureCellState(state: [HomeForecastInfo]) {
        self.state = state
        collectionView.reloadData()
    }
}

private extension HomeForecastSectionView {
    private func layout() {
        backgroundColor = .white
        
        flex.define {
            $0.addItem(collectionView).grow(1)
        }
    }
}

// MARK: UICollectionViewDelegate & DataSource
extension HomeForecastSectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        state.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueCell(withType: HomeForecastCell.self, for: indexPath).then {
            $0.configureCellState(state: state[indexPath.row])
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cell = flowLayout.itemSize.width/* + flowLayout.minimumLineSpacing*/
    }
}
