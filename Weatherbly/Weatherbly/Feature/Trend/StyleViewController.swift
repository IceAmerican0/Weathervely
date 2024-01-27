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

final class StyleViewController: RxBaseViewController<StyleViewModel> {
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일")
    
//    private var collectionViewLayout = UICollectionViewFlowLayout().then {
//        $0.scrollDirection = .vertical
//        $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
//        $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        $0.minimumLineSpacing = 5
//    }
//    
//    private lazy var collectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: collectionViewLayout
//    ).then {
//        $0.delegate = self
//        $0.dataSource = self
//        $0.backgroundColor = .clear
//        $0.showsHorizontalScrollIndicator = false
//        $0.register(withType: StyleCollectionViewCell.self)
//    }
    
    override func attribute() {
        super.attribute()
        
        scrollView.do {
            $0.backgroundColor = .green
        }
        
        titleLabel.do {
            $0.backgroundColor = .red
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.backgroundColor = .orange
        container.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pin.all()
        contentView.backgroundColor = .yellow
        contentView.pin.all()
        
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func layout() {
        super.layout()
        
        contentView.flex.define {
            $0.addItem(titleLabel).width(100%).height(2000)
        }
        
        
        
//        container.backgroundColor = .orange
//        container.addSubview(scrollView)
//        scrollView.pin.all()
//        scrollView.addSubview(contentView)
//        
//        contentView.flex.layout(mode: .adjustHeight)
//        
//        contentView.flex.define {
//            $0.addItem(titleLabel).width(100%).height(2000)
//        }
//        
//        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
//
    }
    
    override func bind() {
        super.bind()
        
//        viewModel.recommendClosetEntityRelay
//            .asDriver()
//            .drive(
//                with: self,
//                onNext: { owner, _ in
//                    owner.collectionView.reloadData()
//                }
//            )
//            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.getRecommendCloset()
    }
}

extension StyleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recommendClosetEntityRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: StyleCollectionViewCell.self, for: indexPath)
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
