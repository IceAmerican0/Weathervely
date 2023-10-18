//
//  TrendingViewController.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class TrendingViewController: RxBaseViewController<TrendingViewModel> {
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.delegate = self
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: TrendingCollectionViewCell.self)
    }

    override func layout() {
        super.layout()
    }
    
    override func bind() {
        super.bind()
    }
}

extension TrendingViewController: UICollectionViewDelegate {
    
}
