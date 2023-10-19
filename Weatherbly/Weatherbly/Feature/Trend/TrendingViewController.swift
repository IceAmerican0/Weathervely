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
import RxSwift
import Kingfisher

final class TrendingViewController: RxBaseViewController<TrendingViewModel> {
    
    private var titleLabel = CSLabel(.bold, 22, "스타일 추천")
    
    private var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
        $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.minimumLineSpacing = 5
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: TrendingCollectionViewCell.self)
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(titleLabel).marginTop(15)
            $0.addItem(collectionView).marginTop(15).grow(1)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.recommendClosetEntityRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    owner.collectionView.reloadData()
                }
            )
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.getRecommendCloset()
    }
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recommendClosetEntityRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: TrendingCollectionViewCell.self, for: indexPath)
        let closetInfo = viewModel.recommendClosetEntityRelay.value[indexPath.item]
        
        if let url = URL(string: closetInfo.imageUrl) {
            cell.imageView.kf.setImage(with: url,
                                            placeholder: nil,
                                            options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 2,
                                                                                        retryInterval: .seconds(2))),
                                                      .transition(.fade(0.1)),
                                                      .cacheOriginalImage]) { result in
                switch result {
                case .success:
                    break
                case .failure:
                    cell.imageView.image = AssetsImage.defaultImage.image
                    break
                }
            }
        }
        
        return cell
    }
}
