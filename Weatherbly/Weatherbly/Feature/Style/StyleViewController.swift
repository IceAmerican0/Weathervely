//
//  StyleViewController.swift
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

final class StyleViewController: RxBaseScrollViewController<StyleViewModel> {
    
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make("스타일")
    private var bannerView = UIImageView()
    private var firstThemeView = HorizonCollectionViewMoleCule()
    
    override func attribute() {
        super.attribute()
        titleLabel.do {
            $0.backgroundColor = .red
        }
        
        firstThemeView.do {
            $0.collectionView.dataSource = self
            $0.collectionView.delegate = self
        }
    }
    override func layout() {
        super.layout()
        
        contentView.flex.define { flex in
            flex.addItem(titleLabel).width(100%).height(400)
            flex.addItem(firstThemeView).width(100%).height(800)
            
        }
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.recommendClosetEntityRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
//                    owner.collectionView.reloadData()
                }
            )
            .disposed(by: bag)
    }
    
    override func bind() {
        super.bind()
    }
    
}
//
//extension StyleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        viewModel.recommendClosetEntityRelay.value.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueCell(withType: StyleCollectionViewCell.self, for: indexPath)
//        let closetInfo = viewModel.recommendClosetEntityRelay.value[indexPath.item]
//        
//        if let url = URL(string: closetInfo.imageUrl) {
//            cell.imageView.kf.setImage(with: url,
//                                            placeholder: nil,
//                                            options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 2,
//                                                                                        retryInterval: .seconds(2))),
//                                                      .transition(.fade(0.1)),
//                                                      .cacheOriginalImage]) { result in
//                switch result {
//                case .success:
//                    break
//                case .failure:
//                    cell.imageView.image = AssetsImage.defaultImage.image
//                    break
//                }
//            }
//        }
//        
//        return cell
//    }
//}


extension StyleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = firstThemeView.collectionView.dequeueCell(withType: HorizontalCollectionViewCell.self, for: indexPath)
        
        return cell
    }
    
    
}

extension StyleViewController: UICollectionViewDelegate {
    
}
